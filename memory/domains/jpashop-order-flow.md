---
title: jpashop-order-flow
type: note
permalink: memory/domains/jpashop-order-flow
tags:
- jpashop
- order
- analysis
도메인명: jpashop-order-flow
category: domain
service:
- jpashop
related_projects:
- jpashop
created_at: 2026-04-10
last_reviewed: 2026-04-10
---

## 개요

POST /order 요청으로 시작되는 주문 생성 흐름(Controller → Service → Repository → DB)을 분석한 문서입니다. 재고 감소, 주문 생성, 연관 엔티티 저장 흐름과 권고사항을 정리합니다.

## 소스 흐름 분석

Entry: OrderController.order(memberId, itemId, count)
  └─ OrderService.order(memberId, itemId, count) @Transactional
       ├─ memberRepository.findOne(memberId)
       ├─ itemRepository.findOne(itemId)
       ├─ Delivery delivery = new Delivery(); delivery.setAddress(member.getAddress())
       ├─ OrderItem.createOrderItem(item, price, count)  // item.removeStock(count)
       ├─ Order.createOrder(member, delivery, orderItem)
       └─ orderRepository.save(order)  // em.persist(order), cascade = ALL (OrderItem, Delivery 저장)

## API 명세

### POST /order
설명: 회원(memberId), 상품(itemId), 수량(count)을 받아 주문을 생성한다.
요청 파라미터:
- memberId: Long (form field)
- itemId: Long (form field)
- count: int (form field)
응답: 리다이렉트 to /orders (뷰 기반)

## 도메인 모델 / 데이터 구조

- Member (member_id, name, address)
- Item (item_id, name, price, stockQuantity)
- Order (order_id, member_id, delivery_id, orderDate, status)
- OrderItem (order_item_id, order_id, item_id, orderPrice, count)
- Delivery (delivery_id, address, status)

## 비즈니스 규칙

- OrderItem 생성 시 item.removeStock(count)로 재고 감소; 재고 부족 시 NotEnoughStockException 발생 → 트랜잭션 롤백
- 주문 취소 시 delivery.status == COMP 이면 취소 불가

## 발견된 문제점 / 권고

- 컨트롤러 매핑: POST /orders/{orderId}/cancel 핸들러의 파라미터는 @PathVariable 사용 권장
- 동시성: 재고 감소 race condition 가능 → 낙관적 락(@Version) 또는 비관적 락/원자적 DB 업데이트 권장
- 조회 성능: 주문 조회에서 N+1 발생 가능성 → fetch join 또는 DTO 조회 권장
- application.yml에 DB 자격증명 포함 → 환경변수/Vault로 외부화 권장

## 작업 이력

### 2026-04-10 — 초기 분석 및 정리
- **작업 유형**: 분석
- **변경 내용**: 주문 흐름 분석 문서 작성

## 관련 도메인 파일

- `memory/projects/jpashop.md`