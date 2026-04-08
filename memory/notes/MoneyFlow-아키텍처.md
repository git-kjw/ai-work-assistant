---
title: MoneyFlow 아키텍처
category: note
tags:
- MoneyFlow
- Swift
- SwiftUI
- MVVM
- 아키텍처
created_at: 2026-04-08
permalink: memory/notes/money-flow-akitegceo
---

# MoneyFlow 아키텍처

## 아키텍처 패턴

**MVVM (Model-View-ViewModel) 패턴**

```
MoneyFlowApp (SwiftUI App)
    ↓
ContentView (Router)
    ↓ environmentObject
DataManager (ViewModel)
    ↓
AppData (Model) ↔ JSON 파일 (iCloud Drive)
```

## 계층별 구조

### Presentation Layer (View)

**ContentView** - 라우팅
- iOS: TabView (5개 탭)
- macOS: NavigationSplitView (사이드바 + 상세)
- 파일 관리 UI (열기/저장)

**주요 View 컴포넌트**:
1. `DashboardView` - 대시보드 (한도 현황 카드)
2. `TransactionListView` - 거래 목록 (날짜별 그룹핑)
3. `AddTransactionView` - 거래 추가/수정 (금액 입력 UI)
4. `AccountListView` - 계좌 목록
5. `AccountEditView` - 계좌 추가/수정
6. `StatisticsView` - 통계/차트
7. `QuickEntryView` - 빠른 입력
8. `SettingsView` - 설정 (iOS만)

### Business Logic Layer (ViewModel)

**DataManager** (`@MainActor` `ObservableObject`)
- 싱글톤 패턴 (`@StateObject` in App)
- `@EnvironmentObject`로 모든 View에 주입

**주요 책임**:
1. 데이터 CRUD (Account, Transaction)
2. 파일 I/O (JSON 로드/저장)
3. 통계 계산
4. 필터링 로직
5. 파일 모니터링 (실시간 동기화)
6. UserDefaults 백업

**상태 관리** (`@Published`):
```swift
appData: AppData              // 메인 데이터
isLoading: Bool               // 로딩 상태
errorMessage: String?         // 에러 메시지
currentFileURL: URL?          // 현재 파일 경로
hasUnsavedChanges: Bool       // 저장 여부
```

### Data Layer (Model)

**Models.swift**:
- `Account` - 계좌 모델
- `Transaction` - 거래 모델
- `AppData` - 루트 데이터 (Codable)
- `AccountStatistics` - 통계 헬퍼
- `SavingsGoal` - 저축 목표 (현재 미사용)
- `FilterOptions` - 필터 옵션

**Extensions.swift**:
- Date 확장 (날짜 포매팅, 범위 계산)
- Int 확장 (통화 포매팅)
- Double 확장 (차트 라벨 포매팅)
- Array<Transaction> 확장 (필터링, 그룹핑)

## 데이터 흐름

### 1. 거래 추가 플로우

```
사용자 입력 (AddTransactionView)
    ↓
DataManager.addTransaction(transaction)
    ↓
appData.transactions.append(transaction)  // @Published 트리거
    ↓
┌─ markAsChanged()
│   ├─ hasUnsavedChanges = true
│   ├─ saveToUserDefaults()     // 로컬 백업
│   └─ saveToCurrentFile()      // JSON 파일 저장
│       ↓
│       JSON 파일 업데이트
│           ↓
│           파일 변경 감지 (다른 기기)
│               ↓
│               자동 리로드 (실시간 동기화)
└─ UI 자동 갱신 (SwiftUI Reactive)
```

### 2. 통계 조회 플로우

```
StatisticsView.onAppear
    ↓
DataManager.getAllStatistics(year: selectedYear)
    ↓
appData.accounts.map { account in
    AccountStatistics(
        account: account,
        transactions: appData.transactions,
        year: year
    )
}
    ↓
통계 계산:
- yearlyDeposit (해당 년도 입금 합계)
- totalWithdrawal (해당 년도 출금 합계)
- netAmount (순증감)
- remainingLimit (남은 한도)
    ↓
View 렌더링 (차트, 카드)
```

### 3. Pull-to-Refresh 플로우

```
사용자 제스처 (아래로 끌어내리기)
    ↓
.refreshable { await dataManager.refreshData() }
    ↓
DataManager.refreshData() async
    ├─ isLoading = true
    ├─ Task.sleep(0.5초)        // UX 피드백
    └─ loadFromFile(currentFileURL)
        ↓
        JSON 파일 재로드
            ↓
            appData 갱신 (@Published)
                ↓
                UI 자동 갱신
```

## 파일 I/O 전략

### Security-Scoped Bookmark

**문제**: iCloud Drive 파일은 샌드박스 외부
**해결**: Bookmark 데이터 저장

```swift
// 저장
#if os(iOS)
let bookmark = url.bookmarkData(options: .minimalBookmark)
#else
let bookmark = url.bookmarkData(options: [.withSecurityScope])
#endif
UserDefaults.standard.set(bookmark, forKey: "bookmark")

// 복원
let url = URL(resolvingBookmarkData: bookmark)
let accessing = url.startAccessingSecurityScopedResource()
defer { url.stopAccessingSecurityScopedResource() }
// 파일 접근
```

### 파일 모니터링

**실시간 변경 감지**:
```swift
DispatchSource.makeFileSystemObjectSource(
    fileDescriptor: open(url.path, O_EVTONLY),
    eventMask: .write,
    queue: .main
)
.setEventHandler {
    // 파일 변경 감지 → 자동 리로드
    reloadFromCurrentFile()
}
```

**장점**:
- 다른 기기에서 변경 시 자동 동기화
- 무료 Apple 계정만으로 가능 (CloudKit 불필요)
- 파일 기반이라 디버깅/백업 용이

## SwiftUI 기술 활용

### 1. State Management

```swift
@StateObject          // App 수준 (DataManager)
@EnvironmentObject    // View 간 공유 (DataManager 주입)
@Published            // DataManager 프로퍼티 (UI 자동 갱신)
@State                // View 로컬 상태
@Binding              // 부모-자식 양방향 바인딩
```

### 2. Reactive UI

```swift
// onChange 모디파이어 (실시간 포매팅)
TextField("금액", text: $amount)
    .onChange(of: amount) { oldValue, newValue in
        formatAmountInput(newValue)
    }

// refreshable 모디파이어 (Pull-to-Refresh)
ScrollView {
    // 컨텐츠
}
.refreshable {
    await dataManager.refreshData()
}
```

### 3. Swift Charts

```swift
Chart {
    ForEach(monthlyData) { data in
        BarMark(
            x: .value("월", data.month),
            y: .value("금액", data.amount)
        )
        .foregroundStyle(data.type == .deposit ? .blue : .red)
    }
}
.chartYAxis {
    AxisMarks { value in
        AxisValueLabel {
            if let doubleValue = value.as(Double.self) {
                Text(doubleValue.chartFormatted)  // "2000만"
            }
        }
    }
}
```

## 크로스 플랫폼 전략

### 플랫폼 분기

```swift
#if os(iOS)
    // iOS 전용 코드
    .keyboardType(.numberPad)
    .navigationBarTitleDisplayMode(.inline)
#else
    // macOS 전용 코드
    .frame(minWidth: 600, minHeight: 400)
#endif
```

### UI 패턴 차이

| 기능 | iOS | macOS |
|------|-----|-------|
| 네비게이션 | TabView | NavigationSplitView |
| 파일 선택 | Sheet | Inline Button |
| 입력 방식 | 터치 | 마우스/키보드 |
| 레이아웃 | Vertical 중심 | Horizontal 활용 |

### 공통 코드 100% 재사용

- DataManager: 플랫폼 무관
- Models: 플랫폼 무관
- Extensions: 플랫폼 무관
- 비즈니스 로직: 플랫폼 무관
- View만 일부 분기 (UI 최적화)

## 성능 최적화

### 1. LazyVGrid (빠른 금액 버튼)

```swift
LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
    ForEach(quickAmountButtons, id: \.amount) { button in
        // 버튼 UI
    }
}
```
- 3열 그리드 레이아웃
- 터치 영역 최적화

### 2. 필터링 효율화

```swift
// Array<Transaction> 확장
func filtered(by options: FilterOptions) -> [Transaction] {
    var result = self
    // 단계별 필터링 (early return 활용)
    if !options.selectedAccountIds.isEmpty {
        result = result.filter { ... }
    }
    // ...
    return result
}
```

### 3. 날짜 캐싱

```swift
extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)  // 계산 결과 캐싱
    }
}
```

## 에러 처리

### 파일 I/O 에러

```swift
do {
    let data = try Data(contentsOf: url)
    appData = try decoder.decode(AppData.self, from: data)
} catch {
    errorMessage = "파일 로드 실패: \(error.localizedDescription)"
}
```

### UI 표시

```swift
if let errorMessage = dataManager.errorMessage {
    Text(errorMessage)
        .foregroundStyle(.red)
}
```

## 테스트 전략

**수동 테스트 체크리스트** (TODO.md):
- iOS/macOS 양쪽에서 UI 정상 동작
- 큰 숫자 표시 (억 단위)
- 금액 입력 성능
- 다양한 화면 크기 레이아웃
- 다크모드 지원
- 접근성(Accessibility)

## 관련 노트

- [[MoneyFlow]] - 프로젝트 카드
- [[MoneyFlow-계좌입출금관리]] - 도메인 분석

## 참고

- 아키텍처 문서화: 2026-04-08
- 최근 개선사항 반영 (2026-04-06)
- 소스 코드: `~/IdeaProjects/MoneyFlow`