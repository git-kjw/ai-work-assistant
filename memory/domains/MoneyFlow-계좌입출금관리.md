---
title: MoneyFlow 계좌입출금관리
category: domain
service: MoneyFlow
tags:
- MoneyFlow
- 계좌관리
- 입출금
- 한도관리
- 통계
status: active
created_at: 2026-04-08
last_reviewed: 2026-04-08
permalink: memory/domains/money-flow-gyejwaibculgeumgwanri
---

# MoneyFlow 계좌입출금관리 도메인

## 개요

개인 계좌의 입출금 내역을 기록하고 연간 납입 한도를 추적하는 금융 관리 도메인.

## 핵심 데이터 모델

### Account (계좌)
```
필드:
- id: UUID (Primary Key)
- name: String (계좌명, 예: "ISA", "연금저축")
- broker: String (증권사, 예: "나무", "한투")
- yearlyLimit: Int? (연간 납입 목표, 원 단위, nullable)
- colorName: String (UI 색상 구분용)
- isActive: Bool (활성 여부)
- createdAt: Date

기본 제공 계좌:
1. 종합매매 (나무) - 한도 없음, blue
2. ISA (나무) - 20,000,000원, purple
3. CMA (나무) - 한도 없음, teal
4. 연금저축 (한투) - 18,000,000원, orange
5. IRP (한투) - 9,000,000원, pink
```

### Transaction (거래)
```
필드:
- id: UUID (Primary Key)
- accountId: UUID (Foreign Key → Account)
- amount: Int (금액, 원 단위)
- type: TransactionType (.deposit | .withdrawal)
- date: Date (거래일)
- memo: String? (선택적 메모)
- createdAt: Date (생성 시각)

타입:
- deposit: 입금
- withdrawal: 출금
```

### AppData (루트)
```
필드:
- accounts: [Account]
- transactions: [Transaction]
- savingsGoals: [SavingsGoal] (현재 미사용)
- lastUpdated: Date

저장 위치: iCloud Drive의 JSON 파일
```

## 핵심 비즈니스 로직

### 1. 한도 관리 (AccountStatistics)

**계산 로직**:
```
yearlyDeposit = SUM(
  transactions 
  WHERE accountId = 해당계좌 
    AND type = deposit 
    AND YEAR(date) = 선택년도
)

remainingLimit = yearlyLimit - yearlyDeposit

진행률 = yearlyDeposit / yearlyLimit * 100
```

**한도 초과 표시**:
- 진행률 > 100%: 빨간색 표시
- 진행률 <= 100%: 초록색 표시

**소스 위치**: `MoneyFlow/Models/Models.swift` - AccountStatistics struct

### 2. 통계 계산

**월간 통계** (`monthlySummary(year, month)`):
```
deposit = SUM(amount WHERE type=deposit AND YEAR=year AND MONTH=month)
withdrawal = SUM(amount WHERE type=withdrawal AND YEAR=year AND MONTH=month)
return (deposit, withdrawal)
```

**연간 통계** (`yearlySummary(year)`):
```
deposit = SUM(amount WHERE type=deposit AND YEAR=year)
withdrawal = SUM(amount WHERE type=withdrawal AND YEAR=year)
return (deposit, withdrawal)
```

**계좌별 순증감** (2026-04-06 추가):
```
netChange = totalDeposit - totalWithdrawal
색상: netChange > 0 ? 초록 : 빨강
```

**소스 위치**: `MoneyFlow/Services/DataManager.swift` - monthlySummary, yearlySummary

### 3. 필터링 시스템

**FilterOptions**:
```
필드:
- selectedAccountIds: Set<UUID> (선택된 계좌)
- dateFilter: .all | .thisMonth | .thisYear | .custom
- customStartDate, customEndDate: Date? (커스텀 기간)
- transactionType: TransactionType? (입금/출금 선택)

적용 순서:
1. 계좌 필터 → accountId IN selectedAccountIds
2. 날짜 필터 → date BETWEEN start AND end
3. 거래 유형 필터 → type = 선택타입
```

**소스 위치**: `MoneyFlow/Models/Extensions.swift` - Array<Transaction>.filtered(by:)

## 데이터 저장 전략

### 이중 저장 방식
```
1. UserDefaults (앱 내부 백업)
   - 모든 데이터 변경 시 자동 저장
   - 빠른 복구용

2. JSON 파일 (iCloud Drive)
   - 사용자 지정 위치 저장
   - 크로스 플랫폼 동기화 (macOS ↔ iOS)
   - 파일명: MoneyFlowData.json
```

### 파일 동기화 메커니즘

**실시간 파일 감시**:
```swift
DispatchSource.makeFileSystemObjectSource(
  fileDescriptor: fd,
  eventMask: .write,  // 파일 쓰기 감지
  queue: .main
)
```

**동기화 흐름**:
1. 파일 변경 감지 (다른 기기에서 수정)
2. 자동 리로드 (`reloadFromCurrentFile()`)
3. UI 자동 갱신 (`@Published` 프로퍼티)

**Pull-to-Refresh** (2026-04-06 추가):
- 사용자가 아래로 끌어내리면 수동 동기화
- 0.5초 딜레이로 사용자 피드백 제공
- 모든 주요 화면에서 지원

**소스 위치**: `MoneyFlow/Services/DataManager.swift` - startFileMonitoring, refreshData

## UI 흐름

### 거래 추가 프로세스

```
1. AddTransactionView 열기
2. 계좌 선택 → 한도 정보 실시간 표시
3. 거래 유형 선택 (입금/출금)
4. 금액 입력:
   - 직접 입력 (실시간 콤마 포매팅)
   - 빠른 버튼 (1만~500만원)
   - 큰 금액 버튼 (500만~5천만원)
5. 날짜 선택
6. 메모 입력 (선택)
7. 저장 → DataManager.addTransaction()
   → JSON 파일 자동 저장
   → 다른 기기 자동 동기화
```

**소스 위치**: `MoneyFlow/Views/AddTransactionView.swift`

### 통계 조회 프로세스

```
1. StatisticsView 열기
2. 연도 선택 (상단 가로 스크롤)
3. 보기 타입 선택:
   - 연간: 월별 추이 차트 + 계좌별 연간 통계
   - 월간: 일별 거래 차트 + 계좌별 월간 통계
   - 목표: 저축 목표 (현재 미구현)
   - 계좌별: 계좌별 상세 통계
4. 차트/통계 표시
   - Y축: 한국어 단위 (천/만/억)
   - 색상: 입금(파랑), 출금(빨강)
   - 순증감: 초록(양수), 빨강(음수)
```

**소스 위치**: `MoneyFlow/Views/StatisticsView.swift`

## 주요 확장 함수

### 숫자 포매팅

**Int.formatted** (콤마 포매팅):
```swift
1000000 → "1,000,000"
```

**Int.currencyFormatted** (통화 포매팅):
```swift
1000000 → "1,000,000원"
```

**Double.chartFormatted** (차트 라벨용, 2026-04-06 추가):
```swift
20000000 → "2000만"
100000000 → "1억"
1500000 → "150만"
```

**소스 위치**: `MoneyFlow/Models/Extensions.swift`

### 날짜 포매팅

```swift
Date.yearMonth → "2026년 4월"
Date.dateString → "2026.04.08"
Date.shortDateString → "4/8"
```

## 기술적 특징

### 1. SwiftUI 활용
- `.refreshable`: Pull-to-Refresh (iOS 표준 제스처)
- `LazyVGrid`: 빠른 금액 버튼 3열 레이아웃
- `Charts`: 월별/연간 통계 시각화
- `.onChange`: 실시간 금액 포매팅
- `@EnvironmentObject`: DataManager 전역 주입

### 2. 한국 현지화
- `Locale(identifier: "ko_KR")`: 통화/날짜 포매팅
- 천/만/억 단위 시스템 (차트 Y축)
- "yyyy년 M월" 날짜 형식

### 3. 크로스 플랫폼
- iOS: TabView, 터치 최적화
- macOS: NavigationSplitView, 마우스 최적화
- 공통 비즈니스 로직: 100% 코드 공유

## 최근 개선 (2026-04-06)

### UI/UX 개선
1. ✅ 년도 표시: "2,026" → "2026" (콤마 제거)
2. ✅ 차트 Y축: "2.0E7" → "2000만" (한국어 단위)
3. ✅ 금액 입력: 실시간 포매팅 + 빠른 버튼 (LazyVGrid)
4. ✅ 계좌별 순증감: deposit - withdrawal 계산 및 색상 표시
5. ✅ Pull-to-Refresh: 모든 화면에서 동기화 제스처

### 파일 변경사항
- `StatisticsView.swift`: 년도 포맷, Y축 라벨, 순증감 표시
- `AddTransactionView.swift`: 금액 입력 UI 전면 개편
- `Extensions.swift`: chartFormatted 확장 추가
- `DataManager.swift`: refreshData() async 함수 추가

## 관련 노트

- [[MoneyFlow]] - 프로젝트 카드
- [[MoneyFlow-아키텍처]] - 기술 구조

## 참고

- 데이터 구조는 JSON 호환성 유지 (하위 호환)
- 모든 금액은 Int (원 단위, 소수점 없음)
- 날짜는 ISO8601 포맷으로 저장
- 파일 저장은 모든 변경 시 즉시 수행 (자동 저장)