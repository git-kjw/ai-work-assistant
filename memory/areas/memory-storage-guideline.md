---
title: memory-storage-guideline
type: note
permalink: ai-work-assistant/areas/memory-storage-guideline
category: policy
tags:
- memory
- policy
status: accepted
created_at: 2026-04-09
---

요약
- 앞으로 모든 작업 내용(분석 노트, ERD, 마이그레이션 등)과 TODO 리스트는 ai-work-assistant/memory (Basic Memory)에 "노트 파일"로 저장한다.

저장 경로 규칙(권장)
- TODOs: memory/operations/tasks/
- 작업 요약·릴리즈 노트: memory/notes/
- 도메인 분석: memory/domains/
- 프로젝트 카드: memory/projects/

운영 규칙
- 모든 노트는 basic-memory-write_note 도구로 작성한다(Frontmatter 필수: title, category, tags, status, created_at).
- 민감 정보(비밀번호, API 키 등)는 메모에 저장하지 않는다. 시크릿은 환경변수 또는 시크릿 매니저 사용.
- 새 TODO가 생성되면 todos 테이블에 레코드 추가하고, 동일한 내용을 memory/operations/tasks에 노트로 작성하여 두 위치를 동기화한다.
- 작업 완료 시 todos.status를 업데이트하고 노트의 status도 갱신한다.

이 지침은 어시스턴트가 앞으로 따를 정책으로 기록되며, 필요시 수정한다.