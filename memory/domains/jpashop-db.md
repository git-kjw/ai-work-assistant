---
title: jpashop-db
type: note
permalink: ai-work-assistant/domains/jpashop-db
category: domain
service: jpashop
tags:
- jpashop
- database
- jpa
status: done
created_at: 2026-04-09
---

요약
- jpashop 프로젝트의 DB 구성 및 엔티티 매핑(테이블/컬럼/관계)과 테스트 기반 샘플 데이터를 정리함.
- 프로젝트 카드: [[projects/jpashop]]

환경 및 설정 (요약)
- DB 엔진: MySQL (드라이버: com.mysql.cj.jdbc.Driver)
- JDBC URL: jdbc:mysql://localhost:3306/JPA
- 사용자: root, 비밀번호: (노트에 저장하지 않음, application.yml에 평문으로 존재)
- JPA 설정: spring.jpa.hibernate.ddl-auto = create (애플리케이션 시작 시 스키마를 생성/재생성)
- SQL 로깅: org.hibernate.SQL 및 바인드 정보 TRACE로 활성화
- 빌드: Gradle (build.gradle.kts에 mysql-connector-java 포함)

엔티티(테이블) 및 매핑(중요사항만 요약)
- Member (src/main/java/jpabook/jpashop/domain/Member.java)
  - PK: member_id (Long)
  - 컬럼: name
  - 임베디드 Address -> city, street, zipcode (멤버 테이블 컬럼으로 포함)
  - 관계: OneToMany orders (mappedBy = "member")

- Order (src/main/java/jpabook/jpashop/domain/Order.java)
  - 테이블명: orders (@Table(name = "orders"))
  - PK: order_id
  - FKs: member_id -> Member.member_id, delivery_id -> Delivery.delivery_id
  - 컬럼: orderDate (LocalDateTime), status (Enum, 저장형 = STRING: ORDER/CANCEL)
  - 관계: ManyToOne member (LAZY), OneToMany orderItems (cascade ALL), OneToOne delivery (LAZY, cascade ALL)

- OrderItem (src/main/java/jpabook/jpashop/domain/OrderItem.java)
  - PK: order_item_id
  - FKs: item_id -> Item.item_id, order_id -> orders.order_id
  - 컬럼: orderPrice (int), count (int)

- Delivery (src/main/java/jpabook/jpashop/domain/Delivery.java)
  - PK: delivery_id
  - 임베디드 Address -> city, street, zipcode
  - 컬럼: status (Enum STRING: READY/COMP)
  - 관계: OneToOne mappedBy = "delivery" (Order이 FK 보유)

- Item (and subclasses) (src/main/java/jpabook/jpashop/domain/Item/Item.java)
  - 상속 전략: SINGLE_TABLE (구분 칼럼: dtype)
  - PK: item_id
  - 공통 컬럼: name, price, stockQuantity
  - 서브클래스 컬럼 (Book: author,isbn / Album: artist,etc / Movie: director,actor) — 동일 테이블에 NULL 허용
  - ManyToMany with Category via join table 'category_item' (category_id, item_id)

- Category (src/main/java/jpabook/jpashop/domain/Category.java)
  - PK: category_id
  - 컬럼: name
  - 관계: ManyToMany items (join table 'category_item'), self-referencing parent/children (parent_id)

제약/동작/운영상징
- Enum 저장: EnumType.STRING (가독성/이식성 좋음)
- Cascade: Order -> orderItems, delivery 에 CascadeType.ALL 적용 (Order persist 시 연관 엔티티도 함께 persist)
- Fetch: ManyToOne/OneToOne 지연로딩(LAZY) 사용
- 인덱스/유니크: 명시적 유니크 또는 추가 인덱스 없음(필요시 추가 권장)

초기 데이터(발견된 내용)
- 애플리케이션 시작 시 실행되는 import.sql 또는 InitDb(@PostConstruct/CommandLineRunner) 없음.
- 테스트에서 샘플 데이터 생성
  - src/test/java/.../OrderServiceTest.java: Book 생성 (name="JPA의 정석", price=20000, stock=10, author="저자1", isbn="123-4567890123"); Member 생성(name="회원1", Address("서울","강가","123-456"))
  - src/test/java/.../MemberRepositoryTest.java: Member("memberA") 저장(@Rollback(false) 사용됨)
- 결론: 운영 DB는 애플리케이션 기동 또는 테스트 실행에 따라 빈 상태이거나(데이터 없음) 테스트/수동 입력으로 채워짐.

리스크 및 권장 조치
- spring.jpa.hibernate.ddl-auto = create: 운영에서는 스키마를 파괴할 수 있으므로 마이그레이션 도구(Flyway/Liquibase) 사용 권장.
- 애플리케이션 설정에 평문 비밀번호 존재: 환경변수/시크릿 매니저로 이전 권장.
- 테스트(@SpringBootTest)가 동일한 MySQL 설정을 사용할 수 있음 — 테스트 전용 프로파일 또는 인메모리 DB 사용 권장.
- 주요 컬럼(예: 사용자 식별자)에 유니크 제약/인덱스 부여 고려.
- Item SINGLE_TABLE 전략은 NULL 컬럼 증가: 필요 시 JOINED 전략 검토.

참조 파일(주요)
- src/main/resources/application.yml
- src/main/java/jpabook/jpashop/domain/{Member.java,Order.java,OrderItem.java,Delivery.java,Address.java,Category.java,OrderStatus.java,DeliveryStatus.java}
- src/main/java/jpabook/jpashop/domain/Item/{Item.java,Book.java,Album.java,Movie.java}
- 테스트 샘플: src/test/java/jpabook/jpashop/service/OrderServiceTest.java, src/test/java/jpabook/jpashop/MemberRepositoryTest.java

다음 제안 작업
- ERD 생성(자동화 툴 또는 수동 도면)
- 마이그레이션 스크립트 작성(Flyway)
- 보안: 비밀번호 제거 및 프로파일 분리
- 성능: 필요한 인덱스 추가