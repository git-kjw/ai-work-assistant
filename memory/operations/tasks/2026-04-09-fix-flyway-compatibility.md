---
title: 2026-04-09-fix-flyway-compatibility
type: note
permalink: ai-work-assistant/operations/tasks/2026-04-09-fix-flyway-compatibility
category: task
tags:
- migrations
- flyway
- jpashop
status: todo
created_at: 2026-04-09
---

Investigate Flyway incompatibility with MySQL 9.3. Options: test older/newer flyway-core versions, use Flyway Gradle plugin to run migrations externally, or pin MySQL driver/version. Document chosen fix and test.