---
title: fastcampus-project-board-main-domain-overview
type: note
permalink: ai-work-assistant/domains/fastcampus-project-board-main-domain-overview
---

# 도메인 모델 및 비즈니스 로직 분석: fastcampus-project-board-main

- 작성일: 2026-04-11
- 대상 프로젝트: `fastcampus-project-board-main`

## 1. 핵심 엔티티 구조 및 관계

### Article (게시글)
- **주요 필드**: `id`, `title`, `content`, `hashtag`
- **연관 관계**:
  - `UserAccount`와 N:1 관계 (`userAccount` 필드, optional = false)
  - `ArticleComment`와 1:N 관계 (`articleComments` 필드, CascadeType.ALL)
- **특징**: 
  - `title`, `hashtag`, `createdAt`, `createdBy`에 인덱스가 설정되어 검색 최적화됨.
  - `equals()`와 `hashCode()`는 엔티티의 ID만을 비교하도록 구현됨.

### ArticleComment (댓글)
- **주요 필드**: `id`, `content`
- **연관 관계**:
  - `Article`과 N:1 관계 (`article` 필드, optional = false)
  - `UserAccount`와 N:1 관계 (`userAccount` 필드, optional = false)
- **특징**:
  - 게시글에 종속적인 구조이며, 작성자 정보를 반드시 포함함.

### UserAccount (회원)
- **주요 필드**: `userId`(PK), `userPassword`, `email`, `nickname`, `memo`
- **특징**:
  - `userId`를 직접 PK로 사용함.
  - `email`에 유니크 인덱스가 설정되어 있음.

---

## 2. 공통 기능 (Auditing)

### AuditingFields
- 모든 주요 엔티티가 상속받는 추상 클래스.
- **필드**: `createdAt`, `createdBy`, `modifiedAt`, `modifiedBy`.
- **설정**: `@MappedSuperclass`와 `EntityListeners(AuditingEntityListener.class)`를 사용하여 생성/수정 정보를 자동 기록.

---

## 3. 데이터 접근 패턴 (Repository)

### ArticleRepository
- **Spring Data REST**: `@RepositoryRestResource` 어노테이션을 통해 API 엔드포인트가 자동 노출됨.
- **주요 쿼리 메소드**:
  - `findByTitleContaining`: 제목 부분 일치 검색 (페이징 지원).
  - `findByHashtag`: 해시태그 일치 검색 (페이징 지원).
  - `deleteByIdAndUserAccount_UserId`: 본인 확인 후 삭제 기능 지원.
  - `findAllDistinctHashtags`: 모든 게시글에서 중복 없이 해시태그 목록 추출 (JPQL 사용).

---

## 4. 비즈니스 규칙 및 설계 특징

1.  **엔티티 생성 제약**: 모든 엔티티는 `protected` 생성자를 가지고 있으며, `of()` 정적 팩토리 메소드를 통해 인스턴스를 생성하도록 강제함 (도메인 주도 설계 지향).
2.  **연관 관계 편의 메소드**: `Article` 클래스 내에 댓글을 추가하거나 관리하는 로직은 보이지 않으나, `articleComments` 세트가 `CascadeType.ALL`로 설정되어 게시글 삭제 시 댓글도 자동 삭제됨.
3.  **검색 최적화**: 다수의 인덱스 설정을 통해 게시판의 핵심 기능인 제목 및 해시태그 검색 성능을 고려함.

---
