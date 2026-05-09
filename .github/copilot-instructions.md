# Copilot 지침

이 파일은 GitHub Copilot과 Copilot CLI가 이 저장소에서 참고하는 진입점입니다. 공통 저장소 규칙은 루트의 `AGENTS.md`를 따릅니다.

## 기본 규칙

- 문서, 스크립트, 지식 기록 방식은 `AGENTS.md`를 기준으로 맞춥니다.
- 공통 규칙을 이 파일에 중복 작성하지 않습니다.
- 변경할 때는 기존 `memory/` 템플릿과 인접 문서의 구조를 우선 따릅니다.
- secrets, API key, token, password, `.env` 값은 문서에 기록하지 않습니다.

## Basic Memory MCP

Copilot CLI에서 Basic Memory MCP를 사용할 때는 `.copilot/mcp.json` 설정을 기준으로 합니다.

- MCP 이름: `basic-memory`
- 메모리 경로: `~/ai-work-assistant/memory`
- 용도: 노트 검색, 읽기, 작성, 지식 베이스 관리

Copilot CLI 안에서 MCP 활성 상태가 필요하면 `/mcp` 명령으로 확인합니다.

## 작업 방식

- 대상 프로젝트가 있으면 먼저 `memory/projects/`의 프로젝트 카드를 확인합니다.
- 기술 분석이나 코드 변경 결과는 `memory/domains/` 또는 관련 운영 폴더에 반영합니다.
- 새 노트를 만들 때는 각 폴더의 `_template.md`를 우선 사용합니다.
- Copilot 전용 설정이 아닌 공통 운영 규칙은 `AGENTS.md`에만 추가합니다.
