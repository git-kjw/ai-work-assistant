---
title: jpashop
type: note
permalink: ai-work-assistant/domains/jpashop
category: domain
tags:
- jpashop
- domain
- code
status: draft
service: jpashop
created_at: 2026-04-09
---

## 개요
- 로컬 경로: ~/IdeaProjects/jpashop
- 간단 설명: Spring Boot 기반의 JPA 실습 쇼핑몰 샘플 프로젝트(jpabook 예제 계열).

## 주요 기술 스택
- Java 17 (toolchain)
- Spring Boot 3.5.3 (spring-boot-starter-data-jpa, web, thymeleaf)
- Spring Data JPA (직접 EntityManager 사용)
- Thymeleaf 템플릿
- MySQL (jdbc:mysql://localhost:3306/JPA), Hibernate (ddl-auto: create)
- Lombok, p6spy

> 주의: application.yml에 `ddl-auto: create`가 설정되어 있어 데이터가 덮어써질 수 있음. DB 비밀번호는 메모에 저장하지 않음.

## 주요 파일/위치 (참조만; 코드 복사 없음)
- 빌드 설정: build.gradle.kts
- 애플리케이션 진입점: src/main/java/jpabook/jpashop/JpashopApplication.java
- 컨트롤러: src/main/java/jpabook/jpashop/controller/* (MemberController, ItemController, OrderController 등)
- 서비스: src/main/java/jpabook/jpashop/service/* (MemberService, ItemService, OrderService)
- 리포지토리: src/main/java/jpabook/jpashop/repository/* (EntityManager 기반 구현)
- 도메인(엔티티): src/main/java/jpabook/jpashop/domain/* (Member, Order, OrderItem, Item, Category, Delivery 등)
- 템플릿/정적자원: src/main/resources/templates, src/main/resources/static
- 설정: src/main/resources/application.yml

## 도메인 모델 요약
- Member (1) --- (N) Order
- Order (1) --- (N) OrderItem
- Order (1) --- (1) Delivery
- OrderItem --- (M:1) Item (Item은 단일 테이블 상속 전략; Book/Album/Movie 등 하위 엔티티 존재)
- Category (M:N) Item (조인 테이블 category_item)
- Address는 Embeddable로 Member와 Delivery에 포함

관계는 연관관계 편의 메서드(setMember, addOrderItem, setDelivery)로 양방향 연관관계 동기화 구현.

## 핵심 비즈니스 로직
- 주문 생성: Order.createOrder(...) — Member, Delivery, OrderItem을 묶어 저장하고 상태/주문일 설정.
- 주문 취소: Order.cancel() — 배송이 완료된 경우 예외 발생, 주문 상태 변경 및 OrderItem.cancel() 호출로 재고 복구.
- 재고 관리: Item.removeStock / addStock, OrderItem.createOrderItem에서 재고 감소.
- 트랜잭션: 서비스 계층에 @Transactional 사용, 읽기 전용 기본 설정 및 쓰기 메서드에 트랜잭션 적용.

## 구현·운영 주의사항
- application.yml에 DB 비밀번호가 포함되어 있음 — 노출 주의.
- Hibernate ddl-auto: create 설정은 개발용; 실제 데이터 유지 필요시 변경 필요.
- 리포지토리가 EntityManager를 직접 사용하므로 JPQL/Criteria 예제와 동적 쿼리 구현을 포함.
- Lombok 사용으로 컴파일 시 어노테이션 프로세서 필요.

## 참고/다음 작업 제안
- 테스트 및 샘플 데이터: src/test 확인 후, 데이터 마이그레이션 방식 개선 제안
- 운영 전: application.yml의 DB 설정을 환경별 분리(environments/프로파일) 및 ddl-auto 변경
- 보안: 비밀번호/시크릿은 환경변수 또는 시크릿 매니저로 이동

## 참조 파일 경로(핵심)
- src/main/java/jpabook/jpashop/JpashopApplication.java
- src/main/java/jpabook/jpashop/domain/*
- src/main/java/jpabook/jpashop/service/*
- src/main/java/jpabook/jpashop/repository/*
- src/main/resources/application.yml

[작성자 메모]
- 분석 시 코드와 설정을 직접 확인함. 민감 정보(비밀번호)는 노트에 직접 기입하지 않음 (애플리케이션 설정에서 존재함을 기록).

## 관련 프로젝트
- [[projects/jpashop]]
