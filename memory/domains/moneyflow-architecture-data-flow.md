---
title: moneyflow-architecture-data-flow
type: note
permalink: memory/domains/moneyflow-architecture-data-flow
도메인명: MoneyFlow
category: domain
service:
  잡코리아 | 알바몬 | 통합플랫폼 | 공통: null
tags:
- domain
- moneyflow
- ios
- swiftui
related_projects:
- moneyflow
created_at: 2026-04-12
last_reviewed: 2026-04-12
---

## 개요

MoneyFlow의 핵심 구조(뷰/서비스/모델)와 JSON 파일 중심 데이터 흐름을 정리한다. 특히 iCloud Drive 동기화, 자동 저장, 통계 계산 로직이 어떻게 연결되는지와 현재 코드 기준 주의 포인트를 기록한다.

## 아키텍처 / 구조 (서비스·모듈 단위일 때)

```text
MoneyFlowApp
  └─ ContentView (탭/네비게이션 + 파일 import/export)
      ├─ DashboardView
      ├─ TransactionListView / QuickEntryView / AddTransactionView
      ├─ AccountListView / AccountEditView
      └─ StatisticsView (Charts)

DataManager (@MainActor, ObservableObject)
  ├─ appData(Account/Transaction/SavingsGoal)
  ├─ JSON file load/save + bookmark
  ├─ UserDefaults backup
  ├─ iCloud 기본 파일 생성/로드
  └─ refreshData() + file monitoring
```

### 모듈 / 컴포넌트 역할 정리

| 모듈 / 컴포넌트 | 역할 | 주요 의존 대상 |
|---------------|------|--------------|
| `ContentView` | iOS/macOS 화면 라우팅, 파일 import/export 트리거 | `DataManager`, `FileImporter/FileExporter` |
| `DataManager` | 앱 상태 단일 소스, 저장/로드/통계 계산 | `FileManager`, `UserDefaults`, bookmark API |
| `Models` | 도메인 모델/필터/포맷팅 유틸 | Foundation |
| `Views/*` | 거래/계좌/통계 UI 및 사용자 입력 | `DataManager` |
| `csv_to_moneyflow.py` | 외부 CSV를 앱 JSON으로 변환 | Python 표준 라이브러리 |

---

## API 명세 (API 단위일 때)

외부 HTTP API는 없다. 로컬 JSON 파일 I/O가 사실상 데이터 API 역할을 수행한다.

---

## 소스 흐름 분석 (기능·API 단위일 때)

```text
거래 추가(AddTransactionView.saveTransaction)
  └─ DataManager.addTransaction()
       └─ markAsChanged()
            ├─ saveToUserDefaults()
            └─ saveToCurrentFile() -> saveToFile(url)

파일 열기(ContentView.handleFileImport)
  └─ DataManager.loadFromFile(url)
       ├─ JSONDecoder(iso8601) decode
       ├─ saveBookmark(url)
       ├─ saveToUserDefaults()
       └─ startFileMonitoring(url)

당겨서 새로고침(.refreshable)
  └─ DataManager.refreshData()
       └─ loadFromFile(currentFileURL)
```

### 계층별 상세

| 계층 | 파일 경로 | 핵심 내용 |
|------|---------|---------|
| App Entry | `MoneyFlow/MoneyFlowApp.swift` | `DataManager` 주입, 앱 시작점 |
| Container View | `MoneyFlow/ContentView.swift` | 탭/네비게이션, 파일 열기/저장, 초기 설정 시트 |
| Service | `MoneyFlow/Services/DataManager.swift` | 데이터 저장소, 파일 동기화, 통계 집계 |
| Domain Model | `MoneyFlow/Models/Models.swift` | `Account`, `Transaction`, `AppData`, `SavingsGoal` |
| Feature Views | `MoneyFlow/Views/*.swift` | 거래/계좌/통계 UX 구현 |

### 외부 서비스 호출

| 서비스명 | 엔드포인트 | 용도 | 호출 방식 |
|---------|-----------|------|---------|
| iCloud Drive | 파일 경로(`Documents/MoneyFlowData.json`) | 멀티 디바이스 데이터 동기화 | File I/O + Ubiquity Container |
| UserDefaults | Key-Value 저장소 | 앱 내부 백업/복구 | `UserDefaults.standard` |

---

## 도메인 모델 / 데이터 구조

```swift
struct AppData {
  var accounts: [Account]
  var transactions: [Transaction]
  var savingsGoals: [SavingsGoal]
  var lastUpdated: Date
}

struct Account {
  var id: UUID
  var name: String
  var broker: String
  var yearlyLimit: Int?
  var colorName: String
  var isActive: Bool
}

struct Transaction {
  var id: UUID
  var accountId: UUID
  var amount: Int
  var type: TransactionType // 입금/출금
  var date: Date
  var memo: String?
}
```

---

## 비즈니스 규칙

- 거래 금액(`amount`)은 양수로 저장하고, 입출금 부호 의미는 `type`이 담당한다.
- 활성 계좌(`isActive == true`)만 거래 입력/주요 목록에 노출한다.
- 연간 목표가 있는 계좌는 올해 입금액 대비 잔여 한도를 계산해 UI에 표시한다.
- 데이터 변경 시 UserDefaults 백업 + 현재 파일 자동 저장을 동시에 수행한다.

---

## 발견된 문제점

- [ ] `lastModifiedDate`가 갱신되지 않아 파일 모니터링 자동 리로드 조건이 충족되지 않을 가능성 (`DataManager.reloadFromCurrentFile`) 
- [ ] iOS `TabView`에서 `SettingsView`의 tag가 `.transactions`와 중복되어 탭 선택 상태가 꼬일 수 있음 (`ContentView`) 
- [ ] 통계의 `목표` 탭은 placeholder 상태로 실제 목표 관리 기능이 미구현 (`StatisticsView.goalsView`) 

---

## 작업 이력

### 2026-04-12 — Dashboard 연도별 납입한도 기준 연도 보정
- **작업 유형**: 구현
- **변경 내용**: `DashboardView`에서 한도 진행률 계산 기준 연도를 `showAllTime` 상태에 따라 동적으로 전달하도록 수정하고, 연도별 모드에서는 `"{선택연도}년 납입"` 라벨로 표시하도록 반영
- **변경 이유**: 연도별 탭에서 `AccountStatistics`가 기본값(현재 연도)으로 계산되어 과거/미래 연도의 납입한도 달성률이 0 또는 오표시되던 문제 해결
- **영향 범위**: `~/IdeaProjects/MoneyFlow/MoneyFlow/Views/DashboardView.swift`

---

### 2026-04-12 — MoneyFlow 구조 분석
- **작업 유형**: 분석
- **변경 내용**: 프로젝트 구조/데이터 흐름 분석, 프로젝트 카드 및 도메인 문서 작성, `real-path` symlink 등록
- **변경 이유**: 향후 구현/리팩토링 시 재사용 가능한 기술 맵 확보
- **영향 범위**: `~/ai-work-assistant/memory/`, `~/ai-work-assistant/real-path/`

---

## 관련 도메인 파일

- `[[moneyflow]]`

## 상태 전이

### `DataManager.hasUnsavedChanges`

```text
false (저장됨)
  -> true  (add/update/delete)
  -> false (saveToFile 성공)
```

### 상태 전이 조건

| 전이 | 조건 | 처리 주체 |
|------|------|-----------|
| false -> true | 거래/계좌 변경 발생 | `DataManager.markAsChanged()` |
| true -> false | 파일 저장 완료 | `DataManager.saveToFile(url:)` |

## DB 스키마

DB는 없고 JSON 파일(`MoneyFlowData.json`)이 영속 저장소 역할을 수행한다.
