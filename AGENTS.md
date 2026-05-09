# 저장소 지침

이 문서는 Codex, Claude Code, GitHub Copilot CLI가 이 저장소에서 공통으로 따르는 기준입니다. 각 도구별 진입점 파일이 있더라도 저장소 구조, 작업 방식, 보안 원칙은 이 파일을 우선 기준으로 삼습니다.

## 저장소 목적

`ai-work-assistant`는 `~/IdeaProjects/` 하위 여러 프로젝트의 분석, 구현, 리팩토링, 디버깅, 테스트 작성을 보조하고 그 결과를 `memory/`에 축적하는 멀티 프로젝트 AI 개발 보조 허브입니다. 단발성 답변보다 재사용 가능한 프로젝트 지식과 운영 기록을 남기는 것을 우선합니다.

## 프로젝트 구조

- `README.md`: 저장소 소개와 기본 사용법.
- `AGENTS.md`: 모든 에이전트가 공유하는 공통 작업 지침.
- `CLAUDE.md`: Claude Code용 진입점.
- `.github/copilot-instructions.md`: GitHub Copilot/Copilot CLI용 진입점.
- `.copilot/mcp.json`: Copilot CLI의 Basic Memory MCP 설정.
- `PROMPT_EXAMPLES.md`: 실제 요청 예시.
- `memory/projects/`: 프로젝트 카드, 실제 경로, 모듈 구성, 빌드 정보.
- `memory/domains/`: API, 서비스 로직, 아키텍처, 데이터 흐름 등 핵심 도메인 지식.
- `memory/prompts/`: 분석, 구현, 리팩토링, 테스트 등 작업 유형별 가이드.
- `memory/tasks/`, `memory/meetings/`, `memory/routines/`: 할 일, 회의, 반복 업무 기록.
- `memory/ideas/`, `memory/archive/`: 아이디어와 아카이브 문서.
- `memory/scripts/`: 메모리 운영 보조 스크립트.
- `real-path/`: `~/IdeaProjects/` 하위 실제 프로젝트로 연결되는 symlink 위치.

새 노트는 각 폴더의 `_template.md`를 먼저 확인한 뒤 작성합니다.

## 기본 작업 흐름

1. 대상 프로젝트가 있으면 `memory/projects/`의 프로젝트 카드를 먼저 확인합니다.
2. 관련 기술 맥락은 `memory/domains/`에서 확인합니다.
3. 작업 유형에 맞는 가이드가 있으면 `memory/prompts/`를 참고합니다.
4. 실제 소스가 필요하면 `real-path/` symlink 또는 프로젝트 카드의 실제 경로를 사용합니다.
5. 분석, 구현, 리팩토링, 디버깅, 테스트 후 새로 얻은 지식은 `memory/`의 적절한 폴더에 반영합니다.

신규 프로젝트를 발견하면 `memory/projects/_template.md` 기반 프로젝트 카드를 만들고, 필요하면 `real-path/`에 symlink를 구성합니다.

## 지식 기록 규칙

- 프로젝트 메타 정보는 `memory/projects/`에 기록합니다.
- 코드 흐름, API, 데이터 모델, 외부 연동, 캐시, 메시징, DB 구조는 `memory/domains/`에 기록합니다.
- 불확실한 아이디어는 `memory/ideas/`, 할 일과 작업 로그는 `memory/tasks/`, 회의 내용은 `memory/meetings/`에 기록합니다.
- 분류가 애매한 기술 메모나 ADR은 `memory/notes/`가 있으면 사용하고, 없으면 가장 가까운 성격의 폴더를 선택합니다.
- 노트 간 관계는 Obsidian 형식의 `[[노트명]]` 링크로 연결합니다.
- 날짜는 `YYYY-MM-DD` 형식을 사용합니다.
- 파일명은 가능하면 소문자와 하이픈을 사용합니다. 예: `moneyflow-architecture-data-flow.md`.

## 명령어

- `rg --files`: 저장소 파일 목록을 빠르게 확인합니다.
- `rg "검색어" memory/`: 기존 지식과 관련 노트를 검색합니다.
- `./memory/scripts/init-project.sh {project-name}`: `~/IdeaProjects/{project-name}`을 기준으로 프로젝트 카드와 symlink를 준비합니다.
- `basic-memory status`: `memory/` 파일과 Basic Memory DB 동기화 상태를 확인합니다.
- `basic-memory tool search-notes "검색어" --local`: Basic Memory 인덱스로 기존 지식을 검색합니다.
- `git status --short`: 변경 파일을 확인합니다.
- `git diff -- {path}`: 문서나 스크립트 변경 내용을 검토합니다.

이 저장소 자체에는 애플리케이션 빌드나 자동 테스트 구성이 없습니다.

## Basic Memory MCP 사용

이 저장소의 지식 베이스는 `~/ai-work-assistant/memory`를 기준으로 하는 Basic Memory입니다. 에이전트가 MCP를 사용할 수 있으면 파일을 직접 훑기 전에 Basic Memory 검색을 우선 사용합니다.

- Codex MCP 설정은 `~/.codex/config.toml`의 `mcp_servers.basic-memory`에 있습니다.
- Copilot CLI MCP 설정은 `.copilot/mcp.json`에 있습니다.
- MCP 서버 이름은 두 도구 모두 `basic-memory`를 사용합니다.
- MCP가 현재 세션에 노출되지 않으면 `basic-memory tool search-notes "검색어" --local`, `basic-memory tool read-note`, `basic-memory tool write-note`를 CLI 대안으로 사용합니다.
- MCP 설정을 새로 추가하거나 바꾼 뒤에는 실행 중인 에이전트 세션을 재시작해야 새 도구 목록에 반영될 수 있습니다.
- 노트를 작성할 때는 `memory/` 기준 상대 위치와 각 폴더의 `_template.md`를 우선합니다.

## 문서 작성 스타일

- 기본 언어는 한국어입니다. 기술 용어, 클래스명, API명, 명령어는 원문 영어를 유지합니다.
- Markdown heading을 명확히 사용하고, 짧은 문단과 실행 가능한 bullet을 선호합니다.
- 추측과 확인된 사실을 구분합니다. 코드나 문서에서 확인한 내용은 경로를 함께 남깁니다.
- 대규모 내용을 새로 만들 때는 기존 템플릿과 인접 문서의 구조를 따릅니다.
- 셸 스크립트는 `bash`, `set -e`, 따옴표 처리, 간결한 상태 메시지를 유지합니다.

## 검증 기준

- Markdown 변경은 heading 구조, 링크, 경로, 날짜 형식을 확인합니다.
- 스크립트를 수정했다면 가능한 한 실제 또는 임시 입력으로 실행해 동작을 확인합니다.
- 외부 프로젝트 문서를 갱신했다면 프로젝트 카드와 도메인 문서가 서로 모순되지 않는지 확인합니다.
- 검증하지 못한 부분은 최종 응답에 명확히 남깁니다.

## Git 및 PR 규칙

- 사용자가 명시하지 않으면 `git commit`, `git push`를 실행하지 않습니다.
- 커밋 메시지는 최근 이력처럼 짧고 구체적으로 작성합니다. 예: `readme 추가`, `Update CLAUDE.md to enhance knowledge management guidelines`.
- 변경은 하나의 목적에 집중합니다.
- PR 설명에는 변경 요약, 영향 경로, 검증 내용, 관련 작업이나 노트 링크를 포함합니다.

## 보안 및 데이터 보호

- `.env`, API key, token, password, 개인 인증 정보는 기록하지 않습니다.
- 운영 데이터 삭제, destructive query, 위험한 Git 명령은 사용자 확인 없이 실행하지 않습니다.
- 외부 프로젝트의 민감한 구현 세부사항은 필요한 범위만 요약합니다.
- 경로와 설정을 문서화할 때 실제 secret 값 대신 변수명이나 위치만 기록합니다.

## 에이전트별 진입점

- Codex는 이 `AGENTS.md`를 공통 지침으로 사용합니다.
- Claude Code는 `CLAUDE.md`에서 `@AGENTS.md`를 불러 공통 지침을 사용합니다.
- GitHub Copilot/Copilot CLI는 `.github/copilot-instructions.md`에서 이 파일을 공통 기준으로 참조합니다.

도구별 파일에는 해당 도구가 공통 지침을 찾는 방법과 특화 설정만 남깁니다. 공통 규칙을 여러 파일에 중복 작성하지 않습니다.
