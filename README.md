# AI 업무 비서

GitHub Copilot CLI + Basic Memory 기반의 개인 업무 비서 시스템.

매일의 할일 관리, 미팅 준비, 도메인/소스 코드 분석 맥락 제공을 자연어 대화로 처리한다.

## 핵심 아이디어

- **Copilot CLI가 에이전트 런타임.** 별도 서버, 스케줄러, MCP 서버 개발 없이 Copilot CLI가 직접 Basic Memory MCP 도구를 호출한다.
- **지식은 Basic Memory에.** 시멘틱 검색으로 관련 맥락을 자동 연결한다.
- **작업 디렉토리 분리.** `~/ai-work-assistant`에서 CLI 실행, 실제 프로젝트는 `~/IdeaProjects`에 위치.

## 사용 예시

Claude Code에서 자연어로 말하면 된다. 카테고리별 대표 예시:

**일일 브리핑**
```
> 오늘 할일 요약해줘
> 남은 할일 뭐야?
```

**태스크 관리**
```
> payment-api에서 결제 재시도 로직 리팩토링 PR 리뷰해야 돼. 다음 주 월요일까지.
> PR 리뷰 끝났어
```

**반복 업무**
```
> 매주 금요일 2시까지 주간보고 써야 돼. Confluence에 올리고 김팀장한테 보내.
```

**미팅 관리**
```
> 다음 주 화요일 3시에 PG사 연동 기술 미팅 있어.
  나이스페이 v2 마이그레이션 건이고, 김팀장이랑 같이 가.
> 내일 PG사 미팅 준비할 거 정리해줘
```

**도메인 분석**
```
> 결제 도메인 전체 흐름 분석해줘. 상태 전이, DB, 프로시저 포함해서.
> 환불 로직 수정해야 하는데 어디를 고쳐야 해?
```

**주간보고**
```
> 이번 주 주간보고 초안 만들어줘
```

**아이디어 기록**
```
> 생각난 건데, 결제 실패하면 다른 결제수단을 자동으로 제안하면 이탈률 줄일 수 있지 않을까?
> payment-api 관련 아이디어 있었던 거 보여줘
```

**Slack 확인**
```
> Slack에서 최근 나와 관련된 내용 확인해줘
> 이번 주 백엔드팀 채널에서 중요한 내용 있었어?
```

**복합 질문**
```
> 결제 도메인 관련해서 지금까지 있었던 일 전부 정리해줘.
  도메인 분석, 관련 태스크, 미팅 내용, 의사결정 다 포함해서.
```

> 전체 프롬프트 예시는 [PROMPT_EXAMPLES.md](./PROMPT_EXAMPLES.md) 참고.

## 프로젝트 구조

```
ai-work-assistant/
├── CLAUDE.md                              # 에이전트 지침
├── README.md
├── GUIDE.md                               # 시작 로드맵 & 장기 운영 전략
├── PROMPT_EXAMPLES.md                     # 전체 프롬프트 예시
└── memory/                                # Basic Memory 노트
    ├── projects/                          # 프로젝트 카드 (환경, URL, 담당자)
    ├── domains/                           # 도메인 분석 (비즈니스 흐름, DB, 프로시저)
    ├── operations/
    │   ├── routines/                      # 반복 업무 (주간보고, 스탠드업 등)
    │   ├── tasks/                         # 진행중인 태스크
    │   └── meetings/                      # 미팅 배경, 안건, 준비물
    ├── ideas/                             # 아이디어, 개선 제안
    ├── areas/                             # 서비스 전체 아키텍처, 의사결정
    ├── notes/                             # 자유 메모 (기술, 사람, 공통모듈 등)
    └── archive/                           # 완료된 태스크, 지난 미팅
```

### 노트 역할 구분

| 폴더 | 담는 것 | 특징 |
|------|--------|------|
| `projects/` | 코드 **밖**의 맥락 — 서버 URL, DB 접속, 연관 서비스 | 한번 쓰면 잘 안 바뀜 |
| `domains/` | 비즈니스 흐름, 상태 전이, DB 스키마, 프로시저, 로직 소재지 | 프로젝트를 가로질러 전체 흐름 설명 |
| `operations/` | 운영 업무 — 할일, 미팅, 반복업무 | 매일 변동 |
| `ideas/` | 기능 아이디어, UX 개선, 떠오른 생각 | 워크플로우 있음 (raw → accepted) |
| `areas/` | 서비스 전체에 걸치는 아키텍처, MSA 전환 전략 등 | 장기 축적 |
| `notes/` | 기술 메모, 사람 정보, 공통 모듈, 트러블슈팅 등 | 분류 안 되는 모든 것 |

### 3단계 분석 체계

| 폴더 | 레벨 | 질문 | 예시 |
|------|------|------|------|
| `domains/` | 비즈니스 | "결제 프로세스가 어떻게 돌아가?" | 결제 흐름, 환불 정책, 상태 전이 |
| `notes/` | 기술 | "이 공통 모듈이 뭘 하는 거야?" | 공통 유틸, 기술 트러블슈팅 |
| `projects/` | 인프라 | "이 서비스 테스트 서버 어디야?" | 서버 URL, DB 정보, 담당자 |

## 시작하기

### 사전 준비

1. [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 설치
2. [Basic Memory](https://github.com/basicmachines-co/basic-memory) 설치 및 MCP 서버 설정

### 설정

1. 이 저장소를 clone한다.

```bash
git clone https://github.com/{username}/ai-work-assistant.git
cd ai-work-assistant
```

2. Basic Memory를 설치한다.

```bash
# uv 설치 (Python 패키지 매니저)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Basic Memory 설치
uv tool install basic-memory

# memory 프로젝트 추가
bm project add memory ~/ai-work-assistant/memory
```

3. MCP 설정 파일 (`~/.config/github-copilot/intellij/mcp.json`)에 추가:

```json
{
    "servers": {
        "basic-memory": {
            "type": "stdio",
            "command": "/Users/{username}/.local/bin/bm",
            "args": ["mcp", "--workspace", "memory"],
            "env": {}
        }
    }
}
```

4. IntelliJ 또는 터미널을 재시작한다.

5. `ai-work-assistant` 폴더에서 Copilot CLI를 실행한다.

```bash
cd ~/ai-work-assistant
gh copilot
```

6. 대화를 시작한다.

```
> 오늘 할일 요약해줘
```

### 초기 데이터 세팅

처음 시작할 때 아래 순서로 채워나가면 된다.

1. **프로젝트 카드** — 관리하는 프로젝트별로 `memory/projects/`에 카드 작성. Claude Code에게 "payment-api 프로젝트 카드 만들어줘, 내가 정보 불러줄게"라고 대화하며 채우면 빠르다.
2. **서비스 의존관계 맵** — `memory/areas/서비스-의존관계-맵.md` 작성.
3. **반복 업무 등록** — 주간보고, 스탠드업 등 정기 업무를 3개 이하로 시작.
4. **도메인 분석** — 가장 자주 다루는 도메인부터 분석 요청. 비즈니스 흐름, 상태 전이, DB 스키마, 프로시저, 로직 소재지를 포함한다. 도메인이 커지면 하위 도메인으로 분리.

> 첫 2주 로드맵, 일상 리듬, 장기 메모리 관리 전략은 [GUIDE.md](./GUIDE.md) 참고.

## 설계 원칙

### Agent-First Zettelkasten

전통적인 제텔카스텐을 AI 에이전트가 탐색할 수 있도록 변형한 메모 체계.

- **원자성** — 하나의 노트에 하나의 주제. 단위는 "도메인 하나" 또는 "의사결정 하나".
- **Wikilink** — `[[노트명]]`으로 노트 간 관계를 명시. Basic Memory가 knowledge graph로 자동 반영.
- **Frontmatter** — 메타데이터가 에이전트의 라우팅 역할. category, tags, status로 검색 범위를 좁힌다.

### 노트 네이밍 컨벤션

| 카테고리 | 규칙 | 예시 |
|----------|------|------|
| 프로젝트 카드 | `{프로젝트명}` | `payment-api` |
| 도메인 분석 | `{도메인명}` | `결제`, `결제-환불` |
| 태스크 | `{날짜}-{내용}` | `2026-04-07-PR리뷰-결제재시도` |
| 미팅 | `{날짜}-{미팅명}` | `2026-04-07-PG사-연동-기술미팅` |
| 반복업무 | `{업무명}` | `주간보고-작성` |

## 주의사항

- **보안**: 소스 코드 분석 시 코드 내용이 Anthropic API로 전송된다. 회사 보안 정책을 반드시 사전 확인할 것.
- **Stale 노트**: `last_reviewed`가 30일 이상 된 도메인 분석 노트는 현재 코드와 다를 수 있다.
- **노트에 민감 정보 금지**: 비밀번호, API 키, 개인정보 등은 노트에 저장하지 않는다.
- **Slack 자동 저장 금지**: Slack에서 가져온 정보는 사용자 확인 후에만 저장한다.

## 라이선스

MIT
