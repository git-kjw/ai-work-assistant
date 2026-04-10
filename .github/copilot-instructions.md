# ai-work-assistant용 Copilot 지침

## 빌드, 테스트, 린트 명령

이 저장소는 애플리케이션 빌드 파이프라인이나 자동 테스트 스위트를 포함하지 않습니다. 아래 저장소 검증 명령을 사용하세요.

| 목적 | 명령 |
| --- | --- |
| 저장소 전체 가드 체크 실행 | `./scripts/check-memory-dir.sh` |
| 단일 파일만 동일 규칙으로 확인 | `git grep -nE "directory.*memory|memory/memory" -- <path/to/file>` |
| 로컬 pre-commit 훅 강제 적용 | `git config core.hooksPath .githooks` |

## 상위 아키텍처

- `~/ai-work-assistant`는 AI 작업 허브이며, 실제 제품 소스는 `~/IdeaProjects`에 있고 `real-path/` 심볼릭 링크로 연결합니다.
- `memory/`는 Basic Memory 시맨틱 검색 기반 지식 저장소입니다 (projects, domains, operations, notes, ideas, archive).
- `.copilot/mcp.json`에서 `basic-memory` MCP 서버를 설정하며 `BASIC_MEMORY_HOME=/Users/jwkim/ai-work-assistant/memory`를 사용합니다.
- `memory/scripts/init-project.sh`는 `~/IdeaProjects/<project>` 존재 확인 → `real-path/<project>` 링크 생성 → 템플릿 기반 `memory/projects/<project>.md` 생성 순서로 프로젝트 온보딩을 자동화합니다.
- `.githooks/pre-commit`과 `scripts/check-memory-dir.sh`는 `memory/memory/...` 같은 중첩 경로 실수를 막기 위해 동일 규칙을 강제합니다.

## 핵심 컨벤션

1. Basic Memory `directory` 값은 항상 memory 루트 기준 상대 경로를 사용합니다 (`projects`, `domains`, `operations/tasks` 등). `memory/` 접두사는 사용하지 않습니다.
2. 프로젝트를 분석할 때는 프로젝트 카드(`memory/projects/`)와 도메인 노트(`memory/domains/`)를 함께 연결하고 같이 갱신합니다.
3. 노트 파일명과 frontmatter는 템플릿(`memory/**/_template.md`)과 README 규칙을 따릅니다.
4. 같은 주제 노트가 이미 있으면 새 파일로 대체하지 말고 기존 노트에 append/update 합니다.
5. API/도메인 분석 순서는 Controller → Service → Repository/DAO → 외부 API 호출 → DTO/Domain 모델 → 설정 순서를 기본으로 합니다.
6. 에이전트 세션에서는 commit/push를 하지 않습니다 (`CLAUDE.md` 명시 규칙).
