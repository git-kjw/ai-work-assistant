---
title: 2026-04-11-agent-os-structure-refinement
type: note
permalink: ai-work-assistant/sessions/2026-04-11-agent-os-structure-refinement
tags:
- session
- agent-os
- claude-md
- prompts
- optimization
---

# 세션: Agent OS 구조 최적화 및 자율 지식 축적 체계 수립

- 작성일: 2026-04-11
- 작성자: Gemini CLI

## 목적
`ai-work-assistant`의 메모리 구조를 체계화하고, 에이전트가 자율적으로 지식을 축적하고 관리할 수 있도록 `CLAUDE.md` 및 폴더 구조를 최적화함.

## 수행 내용
- **`memory/prompts/` 체계 구축**: 유연한 `_template.md` 생성 및 에이전트의 자율적 판단(Adaptive Strategy) 원칙 수립.
- **`CLAUDE.md` 전면 개정**:
    - 지식 분류(Core/Dynamic) 그룹화.
    - Deep Technical Map(Kafka, Redis, 흐름도 등) 기록 의무화.
    - 자율적 지식 축적 트리거(등록/분석/결정/종료) 명문화.
    - 가이드 자율 생성 규칙 및 `basic-memory` 활용 규칙 통합.
- **컨텍스트 최적화**: `context-log.md` 활용 및 선택적 로드 규칙 적용.
- **환경 정비**: `MoneyFlow` 심볼릭 링크 위치 수정 및 프로젝트 카드 업데이트.

## 주요 발견
- `memory/` 하위에 정의되지 않은 폴더(`notes`, `ideas` 등)가 존재함을 확인하여 역할을 명확히 정의함.
- 세션 로그가 쌓일 경우의 컨텍스트 낭비를 방지하기 위해 `context-log.md`라는 누적 요약 체계를 도입함.
- 에이전트 가이드(`prompts`)는 절대적 규칙이 아닌 '참고용'으로 설정하여 상황별 유연성을 확보함.

## 다음 작업
- 신규 프로젝트 분석 시 `domains/`에 Deep Technical Map 작성 테스트.
- `prompts/` 가이드가 없는 작업 수행 시 가이드 자동 생성 기능 검증.
- 주기적인 `archive/` 정리를 통한 컨텍스트 최적화 유지.

---
