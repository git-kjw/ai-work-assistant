---
title: 2026-04-09-remove-plaintext-db-credential
type: note
permalink: ai-work-assistant/operations/tasks/2026-04-09-remove-plaintext-db-credential
category: task
tags:
- security
- jpashop
- task
status: todo
created_at: 2026-04-09
---

Remove DB password from application.yml; move to environment variable or secret manager (e.g., SPRING_DATASOURCE_PASSWORD). Update README/CI and rotate exposed credential if necessary.