@AGENTS.md

# Claude Code 지침

이 파일은 Claude Code가 이 저장소에서 자동으로 읽는 프로젝트 메모리 진입점입니다. 공통 저장소 규칙은 루트의 `AGENTS.md`를 따릅니다.

## 우선순위

1. 시스템, 플랫폼, 보안 정책을 최우선으로 따릅니다.
2. 그다음 `AGENTS.md`의 공통 저장소 규칙을 따릅니다.
3. 작업 유형별 세부 가이드는 `memory/prompts/`를 참고하되, 상위 규칙과 충돌하면 적용하지 않습니다.

## Claude Code 전용 운영 규칙

- 작업을 시작할 때 대상 프로젝트가 명확하면 `memory/projects/`와 `memory/domains/`의 기존 지식을 먼저 확인합니다.
- 새 분석, 구현, 리팩토링, 디버깅, 테스트 작성으로 의미 있는 지식이 생기면 `memory/` 하위 적절한 위치에 반영합니다.
- 새 노트는 해당 폴더의 `_template.md` 구조를 우선 사용합니다.
- Basic Memory MCP를 사용할 수 있으면 노트 검색과 저장에 활용합니다.
- `CLAUDE.md`에는 Claude Code 진입점 역할과 도구 특화 규칙만 둡니다. 공통 규칙 변경이 필요하면 `AGENTS.md`를 수정합니다.
