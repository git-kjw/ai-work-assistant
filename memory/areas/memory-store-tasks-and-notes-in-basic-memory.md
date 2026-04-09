---
title: memory-store-tasks-and-notes-in-basic-memory
type: note
permalink: ai-work-assistant/areas/memory-store-tasks-and-notes-in-basic-memory
category: areas
tags:
- memory
- preference
status: active
created_at: '2026-04-09'
---

요청: 앞으로 작업내용(작업노트, TODO리스트 포함)은 로컬 경로 /ai-work-assistant/memory 에 Basic Memory 노트로 저장합니다. 모든 노트는 basic-memory-write_note 도구로 작성하며, 노트의 frontmatter에는 title, category, tags, status, created_at을 반드시 포함합니다.

세부지침:
- 태스크: memory/operations/tasks/ 아래에 저장
- 도메인/분석: memory/domains/ 아래에 저장
- 미팅: memory/operations/meetings/ 아래에 저장
- 아이디어: memory/ideas/ 아래에 저장

이 설정은 세션 간 지속되며, 이후 요청은 이 규칙을 따릅니다.