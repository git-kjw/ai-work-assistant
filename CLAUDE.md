# CLAUDE.md — AI Work Assistant: Agent OS1

> 이 파일은 Claude Code / GitHub Copilot CLI가 이 저장소에서 작업할 때 따라야 할
> **행동 원칙과 운영 규칙**을 정의합니다. 모든 작업은 이 파일을 최우선으로 따릅니다.

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
| `~/ai-work-assistant/memory/sessions/` | 세션 컨텍스트 로그 |
| `~/ai-work-assistant/real-path/` | symlink로 실제 프로젝트와 연결 |
| `~/IdeaProjects/` | **실제 소스코드** 위치 |

---

## 3. 작업 시작 전 필수 체크리스트 (Pre-flight)

작업 지시를 받으면 반드시 아래 순서로 진행하세요.

```
[ ] 1. memory/projects/ 에서 해당 프로젝트 .md 파일 존재 확인
[ ] 2. 없으면 → ~/IdeaProjects/ 에서 탐색 후 자동 등록 (4번 규칙 참고)
[ ] 3. memory/domains/ 에서 관련 도메인 지식 파일 존재 확인
[ ] 4. memory/prompts/ 에서 작업 유형에 맞는 프롬프트 가이드 로드
[ ] 5. 작업 수행
[ ] 6. 작업 결과를 memory/domains/ 에 기록 (5번 규칙 참고)
[ ] 7. memory/sessions/_template.md 복사 → YYYY-MM-DD-{작업제목}.md 로 세션 로그 저장
[ ] 8. memory/sessions/context-log.md 인덱스에 새 세션 파일 추가
```

---

## 4. 프로젝트 탐색 및 자동 등록 규칙

### 4-1. 프로젝트가 memory/projects/ 에 없는 경우
1. `~/IdeaProjects/` 하위를 탐색하여 해당 프로젝트 디렉토리를 찾는다
2. 프로젝트 구조를 분석한다 (패키지 구조, 빌드 도구, 주요 모듈 등)
3. `memory/projects/_template.md` 를 기반으로 새 `.md` 파일을 생성한다
4. `real-path/` 에 symlink를 생성한다 — 안전한 생성 절차 예:
   - 대상 경로 존재 확인: `test -d ~/IdeaProjects/{name}` 또는 `ls -ld ~/IdeaProjects/{name}`
   - 심볼릭 링크 생성(기존 링크 안전 대체): `ln -sfn ~/IdeaProjects/{name} ~/ai-work-assistant/real-path/{name}` (옵션: -sfn)
   - 생성 확인: `ls -ld ~/ai-work-assistant/real-path/{name}`
   - 주의: 이 명령은 원본(~/IdeaProjects/{name})을 삭제하지 않음. 실제 프로젝트 디렉터리를 삭제하거나 이동하지 않도록 주의.

### 4-2. 프로젝트 내 패키지/모듈 탐색
- 모노레포 구조인 경우 하위 패키지(예: `jk-bff-display-api`, `jk-bff-worer`)를 각각 파악한다
- 각 패키지의 진입점, 빌드 설정, 포트 정보 등을 `memory/projects/{project}.md` 에 기록한다

---

## 5. 도메인 지식 축적 규칙 (핵심)

> **작업할수록 똑똑해지는 구조**를 만드는 핵심 규칙입니다.

- 분석, 구현, 리팩토링, 디버깅 등 **모든 작업 후** 관련 도메인 지식을 `memory/domains/` 에 기록한다
- 파일명 규칙: `{project}-{module}-{도메인주제}.md` (예: `jk-bff-display-api-smart-fit.md`)
- 기존 파일이 있으면 **덮어쓰지 말고 내용을 추가**한다
- basic-memory MCP 툴을 사용하여 노트를 저장하고 시맨틱 검색을 활용한다

### 기록해야 할 내용
- API 엔드포인트 명세 (경로, HTTP 메서드, 요청/응답 구조)
- 비즈니스 로직 흐름 (Controller → Service → Repository → 외부 API)
- 연관 서비스 호출 관계
- 발견한 문제점 및 개선 사항
- 리팩토링/수정 내용 요약

---

## 6. 새 노트(.md) 파일 작성 규칙

> `memory/` 하위 어느 폴더든 새 `.md` 파일을 만들 때는 반드시 해당 폴더의 `_template.md` 를 기준으로 작성한다.

| 새로 만드는 파일 위치 | 참고할 템플릿 |
|---------------------|-------------|
| `memory/projects/{name}.md` | `memory/projects/_template.md` |
| `memory/domains/{name}.md` | `memory/domains/_template.md` |
| `memory/prompts/{name}.md` | `memory/prompts/_template.md` |
| `memory/decisions/ADR-{NNN}-{title}.md` | `memory/decisions/_template.md` |
| `memory/sessions/YYYY-MM-DD-{title}.md` | `memory/sessions/_template.md` |

**중요 — basic-memory write_note 디렉토리 사용법:**

basic-memory MCP 툴을 사용할 때는 `directory` 파라미터를 memory 루트에 대한 상대 경로(예: `projects`, `domains`, `sessions`)로 지정하세요. 예: `basic-memory-write_note(title: 'jpashop', content: '...', directory: 'projects')` → 파일은 `memory/projects/`에 생성됩니다. `directory`에 `memory/` 접두사를 포함하면 `memory/memory/...`와 같이 중첩된 폴더가 생성될 수 있습니다. 이미 중첩이 발생한 경우에는 백업 후 이동하여 정리하세요.

## Git Hook: 잘못된 memory 경로 방지
저장소에 `.githooks/pre-commit` 훅과 `scripts/check-memory-dir.sh` 검사 스크립트를 추가했습니다. 이 훅은 스테이징된 파일에서 `directory`에 `memory/` 접두사를 사용하는 패턴(`directory ... memory` 또는 `memory/memory`)을 검사하고, 발견 시 커밋을 거부합니다.

로컬에서 훅 활성화: `git config core.hooksPath .githooks`
수동 검사: `./scripts/check-memory-dir.sh`

주의: 훅은 자동 활성화되지 않습니다. 로컬에서 활성화하거나 CI에 검사를 추가하여 강제 적용하세요.

### 작성 절차
1. 해당 폴더의 `_template.md` 내용을 읽는다
2. 새 파일명 규칙에 맞게 파일을 생성한다
3. 템플릿 구조를 유지하되, 불필요한 섹션은 삭제해도 된다
4. 작성 후 basic-memory MCP로 저장한다
5. 인덱스 파일이 있는 폴더(`decisions/`, `sessions/`)는 해당 인덱스에도 항목을 추가한다

### 파일명 규칙
- `projects/` — `{project-name}.md` (예: `neo-jobko.md`)
- `domains/` — `{project}-{module}-{주제}.md` (예: `jk-bff-display-api-smart-fit.md`) / 서비스·모듈 단위면 `{project}-{주제}.md` (예: `display-jarvis-module-overview.md`)
- `prompts/` — `{작업유형}.md` (예: `code-review.md`)
- `decisions/` — `ADR-{NNN}-{제목}.md` (예: `ADR-002-caching-strategy.md`)
- `sessions/` — `YYYY-MM-DD-{작업제목}.md` (예: `2025-01-15-smart-fit-api-refactor.md`)

---

## 7. 작업 유형별 행동 규칙

각 작업 유형에 맞는 프롬프트 가이드를 `memory/prompts/` 에서 먼저 로드하세요.

| 작업 유형 | 가이드 파일 |
|-----------|-------------|
| 코드 분석 | `memory/prompts/analysis.md` |
| 디버깅 | `memory/prompts/debug.md` |
| 리팩토링 | `memory/prompts/refactor.md` |
| 기능 구현 | `memory/prompts/implementation.md` |
| 테스트 작성 | `memory/prompts/test.md` |
| 설계/아키텍처 | `memory/prompts/design.md` |

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

## 9. 코드 수정 원칙

- **기존 코드 스타일**을 최대한 유지한다
- 수정 전 반드시 원본 로직을 `memory/domains/` 에 기록한다
- 리팩토링 시 기능 동작이 변경되면 반드시 개발자에게 확인을 구한다
- 테스트 코드가 존재하면 수정 후 테스트 통과 여부를 확인한다

---

## 10. basic-memory 활용 규칙

> 모든 `.md` 파일은 basic-memory MCP를 통해 관리됩니다.

- 노트 저장: `mcp__basic-memory__write_note` 사용
- 노트 검색: `mcp__basic-memory__search_notes` 로 시맨틱 검색 후 작업 시작
- 관련 노트 탐색: `mcp__basic-memory__read_note` 로 연관 컨텍스트 로드
- 새 작업 시작 시 **반드시 시맨틱 검색으로 기존 지식 확인** 후 진행

---

## 11. CLAUDE.md 자기 업데이트 규칙

> 작업을 반복하면서 새로운 패턴이 발견되거나 기존 규칙이 맞지 않는 상황이 생기면,
> `CLAUDE.md` 와 각 `memory/prompts/` 가이드 파일을 직접 수정한다.

### 업데이트가 필요한 상황

| 상황 | 조치 |
|------|------|
| 반복 작업에서 공통 패턴이 발견됨 | 해당 `prompts/` 가이드에 패턴 추가, 필요시 CLAUDE.md 규칙 보강 |
| 기존 규칙이 특정 프로젝트 구조에 맞지 않음 | CLAUDE.md 해당 섹션 수정 + `decisions/`에 ADR로 변경 이유 기록 |
| 새로운 작업 유형이 생김 | `prompts/_template.md` 기반으로 새 가이드 파일 생성 + 섹션 7 테이블에 추가 |
| 금지/허용 기준을 조정해야 함 | 반드시 개발자 확인 후 섹션 12 수정 |

### 수정 절차

```
1. 변경이 필요한 이유를 먼저 개발자에게 설명하고 승인을 받는다
2. CLAUDE.md 또는 해당 prompts/ 파일을 수정한다
3. memory/decisions/ 에 ADR 파일로 변경 이유와 내용을 기록한다
4. basic-memory MCP로 변경된 파일을 저장한다
```

### 수정 원칙

- 기존 규칙을 **삭제하지 않는다** — 비활성화가 필요하면 `~~취소선~~` 처리 후 대체 규칙을 아래에 추가
- 섹션 번호와 구조는 유지한다 (내용만 수정)
- 변경 이력을 추적할 수 있도록 항상 ADR을 남긴다

---

## 12. 금지 사항

- 절대로 git commit, push를 하지 않는다.