# AI Work Assistant

`ai-work-assistant`는 `~/IdeaProjects/` 하위 여러 프로젝트를 대상으로 분석, 구현, 리팩토링, 테스트를 수행하고, 작업 중 얻은 지식을 `memory/`에 축적해 점점 더 정교해지는 **멀티 프로젝트 AI 개발 보조 Agent OS**입니다.

## 핵심 목표

- 여러 프로젝트의 기술 지식을 재사용 가능한 형태로 누적
- 개발 작업(분석/구현/리팩토링/디버깅/테스트) 품질 향상
- 회의/루틴/태스크/아이디어까지 한 곳에서 운영 보조

## 디렉토리 구조

| 경로                                       | 용도                                     |
|------------------------------------------|----------------------------------------|
| `~/ai-work-assistant/CLAUDE.md`          | 에이전트 기본 지침(최우선 로컬 정책)                  |
| `~/ai-work-assistant/PROMPT_EXAMPLES.md` | 실제 대화 요청 예시 모음                         |
| `~/ai-work-assistant/memory/projects/`   | 프로젝트 카드(메타 정보, 실제 경로, 모듈 구성)           |
| `~/ai-work-assistant/memory/domains/`    | API/서비스 로직/아키텍처/데이터 흐름 등 핵심 도메인 지식     |
| `~/ai-work-assistant/memory/prompts/`    | 작업 유형별 가이드(analysis, refactor, test 등) |
| `~/ai-work-assistant/memory/meetings/`   | 회의 일정/회의록                              |
| `~/ai-work-assistant/memory/routines/`   | 반복 업무 관리                               |
| `~/ai-work-assistant/memory/tasks/`      | 할 일/작업 로그/후속 액션                        |
| `~/ai-work-assistant/memory/ideas/`      | 아이디어 메모(채택 전 단계 포함)                    |
| `~/ai-work-assistant/memory/notes/`      | 분류 어려운 기술 메모/트러블슈팅/ADR                 |
| `~/ai-work-assistant/memory/archive/`    | 아카이빙 문서                                |
| `~/ai-work-assistant/real-path/`         | 실제 프로젝트(`~/IdeaProjects/`) 연결 symlink  |

## 빠른 시작

1. 작업 루트로 이동  
   `cd ~/ai-work-assistant`
2. Claude Code 또는 Copilot CLI를 루트에서 실행
3. 자연어로 작업 지시
4. 결과가 `memory/`에 정리되어 누적되는지 확인

## 사용 가이드

### 1) 개발 작업 요청

아래처럼 프로젝트/모듈/API를 구체적으로 지정하면 가장 정확합니다.

```text
display-jarvis 프로젝트의 jk-bff-display-api 모듈 /v1/smart-fit/jobs API를 분석하고 리팩토링해줘.
```

```text
neo-jobko 프로젝트 전체 구조를 분석해줘. 우선 핵심 도메인 흐름 위주로 정리해줘.
```

### 2) 운영 업무 요청 (회의/루틴/태스크)

```text
이번 주 미팅 일정 정리해줘.
```

```text
매일 오전 10:45 데일리 스크럼 루틴 등록해줘.
```

```text
payment-api 관련 남은 태스크만 보여줘.
```

### 3) 지식 기록 요청 (아이디어/노트/아카이브)

```text
아이디어 하나 기록해줘. 결제 실패 시 대체 결제수단 자동 제안.
```

```text
Kafka consumer lag 해결 방법 notes에 정리해줘.
```

```text
지난주 미팅 노트 아카이브해줘.
```

더 많은 예시는 `PROMPT_EXAMPLES.md`를 참고하세요.

## 문서/노트 작성 규칙

- 모든 지식 노트는 basic-memory MCP 기준으로 관리
- 노트 생성 시 각 폴더의 `_template.md` 우선 참고
- 노트 간 연결은 Obsidian `[[노트명]]` 링크 적극 활용
- `write_note.directory`는 `memory/` 기준 상대 경로 사용  
  (예: `projects`, `domains`, `tasks`)

## 권장 작업 흐름

1. `projects/`에서 대상 프로젝트 카드 확인
2. `domains/`에서 기존 지식 확인
3. `prompts/` 가이드 참고 후 작업 수행
4. 결과를 `domains/` 및 관련 폴더에 즉시 반영

## 참고 문서

- 기본 정책: `CLAUDE.md`
- 요청 예시: `PROMPT_EXAMPLES.md`
