---
title: jpashop-setup-2026-04-09
type: note
permalink: ai-work-assistant/notes/jpashop-setup-2026-04-09
category: note
tags:
- jpashop
- migration
- erd
status: done
created_at: 2026-04-09
---

Summary of actions:
- Generated ERD (ERD.puml) and rendered ERD.png
- Created migration V1__init.sql and applied it to local DB
- Added Flyway dependency to build.gradle.kts but disabled Flyway due to compatibility issue (MySQL 9.3)
- Updated application.yml (ddl-auto -> none; flyway settings)

Refer to: [[domains/jpashop-db]] for full entity mapping and details.