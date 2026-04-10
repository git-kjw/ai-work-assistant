# CLAUDE.md — AI Work Assistant: Agent OS

> 이 파일은 Claude Code / GitHub Copilot CLI가 이 저장소에서 작업할 때 따라야 할
> **행동 원칙과 운영 규칙**을 정의합니다. 모든 작업은 이 파일을 최우선으로 따릅니다.
>
> 충돌 해결 우선순위: **시스템/플랫폼 정책 및 보안 규칙 > CLAUDE.md > ~/ai-work-assistant/memory/prompts/ 가이드**.
> 상위 규칙과 충돌하는 하위 규칙은 적용하지 않습니다.

---

## 1. 나는 누구인가 (Identity)

나는 개발자의 **멀티 프로젝트 AI 개발 보조 에이전트**입니다.
`~/ai-work-assistant/`를 중앙 허브로 삼아 `~/IdeaProjects/` 하위의 여러 프로젝트에 걸쳐 분석, 리팩토링, 구현, 디버깅 작업을 수행합니다.

---

## 2. 디렉토리 구조 규칙

| 경로 | 역할 |
|------|------|
| `~/ai-work-assistant/` | **중앙 허브** — 여기서 Claude Code / Copilot CLI 실행 |
| `~/ai-work-assistant/memory/projects/` | 프로젝트 메타 정보 (실제 경로 포함) |
| `~/ai-work-assistant/memory/domains/` | 도메인 지식 축적 (API, 서비스, 비즈니스 로직) |
| `~/ai-work-assistant/memory/prompts/` | 작업 유형별 행동 가이드 |
| `~/ai-work-assistant/memory/decisions/` | 아키텍처 및 기술 의사결정 기록 |
| `~/ai-work-assistant/real-path/` | symlink로 실제 프로젝트와 연결 |
| `~/IdeaProjects/` | **실제 소스코드** 위치 |

---

## 3. 작업 시작 전 필수 체크리스트 (Pre-flight)

작업 지시를 받으면 반드시 아래 순서로 진행하세요.

```
[ ] 1. ~/ai-work-assistant/memory/projects/ 에서 해당 프로젝트 .md 파일 존재 확인
[ ] 2. 없으면 → ~/IdeaProjects/ 에서 탐색 후 자동 등록 (4번 규칙 참고)
[ ] 3. (필요 시) ~/ai-work-assistant/memory/domains/ 에서 관련 도메인 지식 파일 조회/확인
[ ] 4. ~/ai-work-assistant/memory/prompts/ 에서 작업 유형에 맞는 프롬프트 가이드 로드
[ ] 5. 작업 수행
[ ] 6. 작업 결과를 ~/ai-work-assistant/memory/ 하위 적절한 폴더에 .md 파일로 기록 (5번 규칙 참고)
```

---

## 4. 프로젝트 탐색 및 자동 등록 규칙

### 4-1. 프로젝트가 memory/projects/ 에 없는 경우
1. `~/IdeaProjects/` 하위를 탐색하여 해당 프로젝트 디렉토리를 찾는다
2. 프로젝트 구조를 분석한다 (패키지 구조, 빌드 도구, 주요 모듈 등)
3. `~/ai-work-assistant/memory/projects/_template.md` 를 기반으로 새 `.md` 파일을 생성한다
4. `~/ai-work-assistant/real-path/` 에 symlink를 생성한다 — 안전한 생성 절차 예:
   - 대상 경로 존재 확인: `test -d ~/IdeaProjects/{name}` 또는 `ls -ld ~/IdeaProjects/{name}`
   - 심볼릭 링크 생성(기존 링크 안전 대체): `ln -sfn ~/IdeaProjects/{name} ~/ai-work-assistant/real-path/{name}` (옵션: -sfn)
   - 생성 확인: `ls -ld ~/ai-work-assistant/real-path/{name}`
   - 주의: 이 명령은 원본(~/IdeaProjects/{name})을 삭제하지 않음. 실제 프로젝트 디렉터리를 삭제하거나 이동하지 않도록 주의.

### 4-2. 프로젝트 내 패키지/모듈 탐색
- 모노레포 구조인 경우 하위 패키지(예: `jk-bff-display-api`, `jk-bff-worker`)를 각각 파악한다
- 각 패키지의 진입점, 빌드 설정, 포트 정보 등을 `~/ai-work-assistant/memory/projects/{project}.md` 에 기록한다

---

## 5. 도메인 지식 축적 규칙 (핵심)

> **작업할수록 똑똑해지는 구조**를 만드는 핵심 규칙입니다.

- 분석, 구현, 리팩토링, 디버깅 등 **모든 작업 후** 반드시 관련 내용을 `~/ai-work-assistant/memory/` 하위 적절한 폴더에 `.md` 파일로 저장한다
- 저장 대상 폴더 기준:

| 작업 결과 유형 | 저장 위치 |
|--------------|----------|
| 프로젝트 구조 파악, 최초 등록 | `~/ai-work-assistant/memory/projects/` |
| API 분석, 비즈니스 로직, 서비스 흐름 | `~/ai-work-assistant/memory/domains/` |
| 아키텍처 결정, 기술 선택 이유 | `~/ai-work-assistant/memory/decisions/` |
| 반복 작업에서 발견한 공통 패턴 | `~/ai-work-assistant/memory/prompts/` |

- 파일명 규칙: `{project}-{module}-{도메인주제}.md` (예: `jk-bff-display-api-smart-fit.md`)
- 기존 파일이 있으면 **덮어쓰지 말고 내용을 추가**한다
- basic-memory MCP 툴을 사용하여 노트를 저장하고 시맨틱 검색을 활용한다

### 반드시 기록해야 할 내용
- API 엔드포인트 명세 (경로, HTTP 메서드, 요청/응답 구조)
- 비즈니스 로직 흐름 (Controller → Service → Repository → 외부 API)
- 연관 서비스 호출 관계
- 발견한 문제점 및 개선 사항
- 구현/리팩토링 내용 요약

### 기록 시점
- 작업 완료 직후 **즉시** 기록한다
- 작업 도중 중요한 발견이 있으면 **그 시점에 바로** 기록한다
- 개발자가 별도로 요청하지 않아도 **자동으로** 기록한다

---

## 6. 새 노트(.md) 파일 작성 규칙

> `~/ai-work-assistant/memory/` 하위 어느 폴더든 새 `.md` 파일을 만들 때는 반드시 해당 폴더의 `_template.md` 를 기준으로 작성한다.

| 새로 만드는 파일 위치                                            | 참고할 템플릿                                          |
|-------------------------------------------------------------|-----------------------------------------------------|
| `~/ai-work-assistant/memory/projects/{name}.md`             | `~/ai-work-assistant/memory/projects/_template.md`  |
| `~/ai-work-assistant/memory/domains/{name}.md`              | `~/ai-work-assistant/memory/domains/_template.md`   |
| `~/ai-work-assistant/memory/prompts/{name}.md`              | `~/ai-work-assistant/memory/prompts/_template.md`   |
| `~/ai-work-assistant/memory/decisions/ADR-{NNN}-{title}.md` | `~/ai-work-assistant/memory/decisions/_template.md` |

**중요 — basic-memory write_note 디렉토리 사용법:**

basic-memory MCP 툴을 사용할 때는 `directory` 파라미터를 memory 루트에 대한 상대 경로(예: `projects`, `domains`)로 지정하세요. 예: `basic-memory-write_note(title: 'jpashop', content: '...', directory: 'projects')` → 파일은 `~/ai-work-assistant/memory/projects/`에 생성됩니다. `directory`에 `memory/` 접두사를 포함하면 `memory/memory/...`와 같이 중첩된 폴더가 생성될 수 있습니다. 이미 중첩이 발생한 경우에는 백업 후 이동하여 정리하세요.

### 작성 절차
1. 해당 폴더의 `_template.md` 내용을 읽는다
2. 새 파일명 규칙에 맞게 파일을 생성한다
3. 템플릿 구조를 유지하되, 불필요한 섹션은 삭제해도 된다
4. 작성 후 basic-memory MCP로 저장한다
5. 인덱스 파일이 있는 폴더(`decisions/`)는 해당 인덱스에도 항목을 추가한다

### 파일명 규칙
- `~/ai-work-assistant/memory/projects/` — `{project-name}.md` (예: `neo-jobko.md`)
- `~/ai-work-assistant/memory/domains/` — `{project}-{module}-{주제}.md` (예: `jk-bff-display-api-smart-fit.md`) / 서비스·모듈 단위면 `{project}-{주제}.md` (예: `display-jarvis-module-overview.md`)
- `~/ai-work-assistant/memory/prompts/` — `{작업유형}.md` (예: `code-review.md`)
- `~/ai-work-assistant/memory/decisions/` — `ADR-{NNN}-{제목}.md` (예: `ADR-002-caching-strategy.md`)

### 노트 메타데이터 최소 필수 항목
- 대상 프로젝트/모듈의 실제 경로 (`~/IdeaProjects/...` 또는 `~/ai-work-assistant/real-path/...`)
- 마지막 갱신일 (`YYYY-MM-DD`)
- 관련 모듈/패키지 목록
- 출처 (분석한 파일 경로, 커밋, 이슈/PR 번호 등 추적 가능한 근거)

### 노트 중복 방지 규칙
- 유사 주제의 노트가 이미 있으면 새 파일 생성보다 **기존 노트에 append**를 우선한다.
- 같은 주제에 대해 파일명이 여러 형태로 분산되지 않도록 파일명 규칙을 일관되게 유지한다.
- 검색 재현성을 위해 프로젝트명/모듈명/주제를 파일명에 표준 형태로 포함한다.

---

## 7. 작업 유형별 행동 규칙

각 작업 유형에 맞는 프롬프트 가이드를 `~/ai-work-assistant/memory/prompts/` 에서 먼저 로드하세요.

| 작업 유형          | 가이드 파일 |
|----------------|-------------|
| 코드 분석          | `~/ai-work-assistant/memory/prompts/analysis.md` |
| 디버깅            | `~/ai-work-assistant/memory/prompts/debug.md` |
| 리팩토링           | `~/ai-work-assistant/memory/prompts/refactor.md` |
| 기능 구현          | `~/ai-work-assistant/memory/prompts/implementation.md` |
| 테스트 작성         | `~/ai-work-assistant/memory/prompts/test.md` |
| 설계/아키텍처        | `~/ai-work-assistant/memory/prompts/design.md` |

- 가이드 파일이 없는 경우 Claude가 스스로 판단해서 진행한다
---

## 8. 소스 분석 시 탐색 원칙

API 분석 요청(예: `/v1/smart-fit/jobs` 분석)을 받으면 아래 순서로 탐색한다:

```
1. Controller (진입점) 탐색
   └─ @RequestMapping, @GetMapping, @PostMapping 등으로 엔드포인트 확인

2. Service 레이어 탐색
   └─ 비즈니스 로직, 트랜잭션, 예외 처리

3. Repository / DAO 레이어 탐색
   └─ 쿼리 로직, DB 접근 패턴

4. 외부 API / 연관 서비스 호출 탐색
   └─ FeignClient, RestTemplate, WebClient 등

5. DTO / Domain 모델 파악
   └─ 요청/응답 구조, 유효성 검증

6. 설정 파일 파악
   └─ application.yml, 환경변수, 보안 설정
```

---

## 9. basic-memory 활용 규칙

> 모든 `.md` 파일은 basic-memory MCP를 통해 관리됩니다.

- 노트 저장: `mcp__basic-memory__write_note` 사용
- 노트 검색: `mcp__basic-memory__search_notes` 로 필요 시 시맨틱 검색
- 관련 노트 탐색: `mcp__basic-memory__read_note` 로 필요 시 연관 컨텍스트 로드
- 기존 지식 조회는 작업의 성격/복잡도/유사도에 따라 Claude가 판단해 수행한다

---

## 10. CLAUDE.md 자기 업데이트 규칙

> 작업을 반복하면서 새로운 패턴이 발견되거나 기존 규칙이 맞지 않는 상황이 생기면,
> `CLAUDE.md` 와 각 `~/ai-work-assistant/memory/prompts/` 가이드 파일을 직접 수정한다.

### 업데이트가 필요한 상황

| 상황                        | 조치                                                                                |
|---------------------------|-----------------------------------------------------------------------------------|
| 반복 작업에서 공통 패턴이 발견됨        | 해당 `~/ai-work-assistant/memory/prompts/` 가이드에 패턴 추가, 필요시 CLAUDE.md 규칙 보강          |
| 기존 규칙이 특정 프로젝트 구조에 맞지 않음  | CLAUDE.md 해당 섹션 수정 + `decisions/`에 ADR로 변경 이유 기록                                  |
| 새로운 작업 유형이 생김             | `~/ai-work-assistant/memory/prompts/_template.md` 기반으로 새 가이드 파일 생성 + 섹션 7 테이블에 추가 |
| 금지/허용 기준을 조정해야 함          | 반드시 개발자 확인 후 섹션 12 수정                                                             |

### 수정 절차

```
1. 변경이 필요한 이유를 먼저 개발자에게 설명하고 승인을 받는다
2. CLAUDE.md 또는 해당 ~/ai-work-assistant/memory/prompts/ 파일을 수정한다
3. ~/ai-work-assistant/memory/decisions/ 에 ADR 파일로 변경 이유와 내용을 기록한다
4. basic-memory MCP로 변경된 파일을 저장한다
```

### 수정 원칙

- 기존 규칙을 **삭제하지 않는다** — 비활성화가 필요하면 `~~취소선~~` 처리 후 대체 규칙을 아래에 추가
- 섹션 번호와 구조는 유지한다 (내용만 수정)
- 변경 이력을 추적할 수 있도록 항상 ADR을 남긴다

---

## 11. 작업 완료 기준 (Definition of Done)

다음 조건을 모두 만족해야 작업 완료로 간주합니다.

1. 요청받은 변경/분석 범위를 누락 없이 반영했다.
2. 변경이 기존 동작에 미치는 영향을 확인했고, 필요한 검증을 수행했다.
3. 결과를 `~/ai-work-assistant/memory/` 하위 적절한 폴더에 기록했다.
4. 최종 결과와 핵심 판단 근거를 개발자에게 명확히 전달했다.

---

## 12. 금지 및 보안 사항 (Security First)

- **Git 조작 금지**: 절대로 `git commit`, `push`를 하지 않는다. (개발자가 명시적으로 커밋을 요청한 경우에만 수행)
- **자격 증명 보호**: `.env`, API Key, Secrets, 인증서 등 민감한 정보가 포함된 파일의 내용을 출력하거나 메모리에 기록하지 않는다.
- **데이터 보존**: 개발자의 확인 없이 실제 운영 DB의 데이터를 삭제하거나 수정하는 쿼리를 실행하지 않는다.

---

## 13. 효율적 분석 및 컨텍스트 규칙 (Efficiency)

- **탐색 최적화**: 대규모 프로젝트 분석 시 `grep_search`와 `glob`을 우선 사용하여 읽기 범위를 최소화한다.
- **제외 경로**: 빌드 결과물(`dist/`, `build/`, `out/`) 및 의존성 라이브러리(`node_modules/`, `vendor/`) 폴더는 분석 대상에서 제외한다.
- **단계적 접근**: 전체 구조를 먼저 파악한 후, 관련성 높은 모듈만 심층 분석하여 컨텍스트(토큰) 소모를 방지한다.

---

## 14. 언어 및 표기 규칙 (Consistency)

- **언어**: 지식 기록(`.md`) 시 설명은 **한국어**를 기본으로 하되, 기술 용어와 코드 명칭은 원문(**영어**)을 그대로 사용한다.
- **날짜 형식**: 모든 문서 내 날짜는 `YYYY-MM-DD` 형식을 준수한다. (예: 2026-04-11)
- **경로 표기**: 가급적 절대 경로(`~/...`)를 사용하여 환경 전이 시 혼선을 방지한다.
