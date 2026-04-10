---
title: 2026-04-10-ai-work-assistant-copilot-instructions
type: note
permalink: ai-work-assistant/sessions/2026-04-10-ai-work-assistant-copilot-instructions
category: note
tags:
- session
- copilot-instructions
created_at: 2026-04-10
---

# 세션 기록: copilot-instructions 정리

- 작성일: 2026-04-10
- 작성자: Copilot CLI
- 프로젝트: ai-work-assistant

## 목적
저장소 구조와 기존 지침을 분석해 future Copilot 세션용 `.github/copilot-instructions.md`를 작성.

## 수행 내용
- README.md, CLAUDE.md, `.copilot/mcp.json`, `.githooks/pre-commit`, `scripts/check-memory-dir.sh`, `memory/**/_template.md` 분석
- `.github/copilot-instructions.md` 신규 생성
- 메모리 디렉토리 규칙 검증 명령과 아키텍처/컨벤션 반영

## 읽은 파일
- /Users/jwkim/ai-work-assistant/README.md
- /Users/jwkim/ai-work-assistant/CLAUDE.md
- /Users/jwkim/ai-work-assistant/.copilot/mcp.json
- /Users/jwkim/ai-work-assistant/.githooks/pre-commit
- /Users/jwkim/ai-work-assistant/scripts/check-memory-dir.sh
- /Users/jwkim/ai-work-assistant/memory/projects/_template.md
- /Users/jwkim/ai-work-assistant/memory/domains/_template.md

## 주요 발견
- 이 저장소는 앱 코드 빌드/테스트 레포가 아니라 AI 워크플로 허브이며, 핵심 검증은 메모리 디렉토리 규칙 검사 스크립트/훅이다.
- Basic Memory `directory`는 memory 루트 상대 경로를 사용해야 하며 `memory/` 접두사는 금지된다.
- 프로젝트 카드와 도메인 노트를 연계해 지식을 축적하는 운영 규칙이 핵심이다.

## 결과물
- `.github/copilot-instructions.md`


## 추가 수정 (사용자 피드백 반영)
- `.github/copilot-instructions.md` 본문을 전면 한국어로 변환해 가독성 개선
- 명령/경로/규칙은 동일하게 유지하고 설명 문장만 한국어화