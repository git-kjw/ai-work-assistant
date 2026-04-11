---
title: fastcampus-project-board-main
type: note
permalink: ai-work-assistant/projects/fastcampus-project-board-main
---

## 기본 정보

| 항목 | 내용 |
|------|------|
| 프로젝트명 | fastcampus-project-board-main |
| 실제 경로 | `/Users/jwkim/IdeaProjects/fastcampus-project-board-main/` |
| symlink 경로 | `~/ai-work-assistant/real-path/fastcampus-project-board-main` |
| 빌드 도구 | Gradle |
| 주요 언어 | Java 21 |
| 프레임워크 | Spring Boot 3.3.0 |
| 설명 | 패스트캠퍼스 게시판 프로젝트 메인 저장소 |

---

## 패키지 / 모듈 구성

```
fastcampus-project-board-main/
├── src/main/java/com/fastcampus/projectboard/
│   ├── domain/          # 엔티티 클래스
│   ├── repository/      # 데이터 접근 레이어 (Spring Data REST 포함)
│   ├── service/         # 비즈니스 로직
│   ├── controller/      # 웹 컨트롤러
│   ├── dto/             # 데이터 전송 객체
│   └── config/          # 설정 클래스 (Security, DataRest 등)
└── src/main/resources/
    ├── templates/       # Thymeleaf 템플릿
    └── application.yaml # 설정 파일
```

### 모듈별 상세

#### projectboard (단일 모듈)
- **역할**: 게시판 서비스 전체 (게시글, 댓글, 사용자 인증 등)
- **포트**: 30001
- **주요 API 경로**: `/api` (Spring Data REST)
- **의존 서비스**: MySQL

---

## 실행 방법

```bash
# 로컬 실행
cd ~/IdeaProjects/fastcampus-project-board-main
./gradlew bootRun

# 빌드
./gradlew build
```

---

## 환경 설정

- **개발 환경 프로파일**: 기본값
- **설정 파일 위치**: `src/main/resources/application.yaml`
- **외부 설정**: MySQL (localhost:3306/board)

---

## 서비스 개요

패스트캠퍼스 강의를 통해 제작된 게시판 서비스로, 게시글과 댓글 관리 기능을 제공하며 Spring Security를 이용한 인증 기능이 포함되어 있습니다.

## 기술 스택

- Java 21, Spring Boot 3.3.0
- Spring Data JPA, Spring Data REST
- Spring Security
- Thymeleaf (Decoupled Logic 사용)
- MySQL, H2 (테스트용)
- Lombok

## DB

- DB명: board (MySQL)
- 주요 테이블: article, article_comment, user_account

## 도메인 지식 파일

- [ ] `fastcampus-project-board-main-domain-overview.md`
- [ ] `fastcampus-project-board-main-api-spec.md`

---
