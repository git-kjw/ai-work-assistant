---
title: jpashop
type: note
permalink: ai-work-assistant/projects/jpashop
tags:
- jpashop
- project-card
---

## 기본 정보

| 항목 | 내용 |
|------|------|
| 프로젝트명 | jpashop |
| 실제 경로 | `~/IdeaProjects/jpashop/` |
| symlink 경로 | `~/ai-work-assistant/real-path/jpashop` |
| 빌드 도구 | Gradle (Kotlin DSL) |
| 주요 언어 | Java 17 |
| 프레임워크 | Spring Boot 3.5.3 |
| 설명 | JPA 기반 쇼핑 예제 애플리케이션 (컨트롤러/서비스/레포지토리/도메인 포함) |

---

## 패키지 / 모듈 구성

```
jpashop/
├── build.gradle.kts
├── settings.gradle.kts
├── src/
│   ├── main/java/jpabook/jpashop/
│   │   ├── controller/
│   │   ├── domain/
│   │   ├── repository/
│   │   ├── service/
│   │   └── JpashopApplication.java
│   └── main/resources/
│       ├── application.yml
│       ├── db/migration/
│       └── templates/
└── ...
```

### 모듈별 상세

#### root
- **역할**: 학습/예제용 쇼핑 애플리케이션 (주문 흐름, JPA 예제)
- **포트**: 기본 8080 (Spring Boot)
- **주요 API 경로**: /, /hello, /items/**, /members/**, /order, /orders
- **의존 서비스**: MySQL (로컬) - 외부 API 없음

---

## 실행 방법

```bash
cd ~/IdeaProjects/jpashop
./gradlew bootRun
```

---

## 환경 설정

- **개발 환경 프로파일**: local
- **설정 파일 위치**: src/main/resources/application.yml (현재 로컬 MySQL 자격증명 포함 — 외부화 권장)
- **Flyway 마이그레이션**: src/main/resources/db/migration/V1__init.sql, V2__add_indexes.sql

---

## 서비스 개요

JPA 기반 쇼핑 애플리케이션 예제. 주문 생성/취소, 재고 관리, 도메인 모델(회원, 주문, 상품, 배송 등)을 포함.

## 기술 스택

- Java 17, Spring Boot 3.5.3
- Spring Data JPA, Thymeleaf, Flyway, MySQL 8.0.33, p6spy, Lombok

## 연관 서비스

- DB: MySQL (local) — DB명 `JPA` (application.yml)

## DB

- DB명: JPA
- 주요 테이블: orders, order_item, member, item, delivery, category

## 배포

- 로컬 학습용 (배포 파이프라인 미구성)

## 도메인 지식 파일

- memory/domains/jpashop-order-flow.md