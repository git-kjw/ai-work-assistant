---
title: MoneyFlow
type: note
permalink: ai-work-assistant/projects/money-flow
category: project
created_at: '2026-04-08'
last_reviewed: '2026-04-08'
service: MoneyFlow
status: active
tags:
- MoneyFlow
- iOS
- macOS
- Swift
- SwiftUI
- 금융관리
---

# MoneyFlow 프로젝트 카드

## 개요

macOS & iOS Universal 계좌 입출금 관리 앱. 개인 취미 프로젝트.

## 기본 정보

| 항목 | 내용 |
|------|------|
| 프로젝트명 | MoneyFlow |
| 유형 | macOS & iOS Universal 앱 |
| 목적 | 개인 계좌 입출금 내역 관리 및 연간 납입 한도 추적 |
| 실제 경로 | `~/IdeaProjects/MoneyFlow` |
| symlink 경로 | `~/ai-work-assistant/real-path/MoneyFlow` |
| 개발자 | jwkim |
| 개발 언어 | Swift |
| 프레임워크 | SwiftUI |
| 최소 버전 | iOS 17.0+, macOS 14.0+ |
| 빌드 도구 | Xcode 15.0+ |

## 기술 스택

- **언어**: Swift 5
- **UI**: SwiftUI
- **차트**: Swift Charts
- **데이터 저장**: JSON 파일 (iCloud Drive)
- **동기화**: iCloud Drive 파일 기반 (무료 계정 지원)
- **아키텍처**: MVVM 패턴

## 주요 기능

### 1. 거래 관리
- 날짜별 입출금 내역 기록
- 입금/출금 구분
- 메모 기능
- 검색 및 필터링 (계좌별, 기간별, 유형별)

### 2. 계좌 관리
- 계좌 추가/수정/삭제
- 5개 기본 계좌 제공:
  - 종합매매 (나무)
  - ISA (나무) - 연 2,000만원 한도
  - CMA (나무)
  - 연금저축 (한투) - 연 1,800만원 한도
  - IRP (한투) - 연 900만원 한도

### 3. 납입 한도 관리
- 연간 납입 한도 설정
- 올해 입금액 / 남은 한도 실시간 확인
- 진행률 표시

### 4. 통계
- 연간/월별 입출금 통계
- 계좌별 현황
- 차트 시각화 (Swift Charts)
- 계좌별 순증감 표시

### 5. iCloud Drive 동기화
- 무료 Apple 계정으로 맥북-아이폰 간 데이터 동기화
- JSON 파일 직접 읽기/쓰기
- 실시간 파일 변경 감지
- Pull-to-Refresh 동기화

## 프로젝트 구조

```
MoneyFlow/
├── MoneyFlowApp.swift           # 앱 진입점
├── ContentView.swift            # 라우팅 + 파일 관리
├── Models/
│   ├── Models.swift             # Account, Transaction, AppData
│   ├── Extensions.swift         # 날짜, 숫자 포매팅 유틸리티
│   └── ColorExtensions.swift    # 계좌 색상
├── Views/
│   ├── DashboardView.swift      # 대시보드
│   ├── TransactionListView.swift  # 거래 목록
│   ├── AddTransactionView.swift   # 거래 추가/수정
│   ├── AccountListView.swift      # 계좌 목록
│   ├── AccountEditView.swift      # 계좌 수정
│   ├── QuickEntryView.swift       # 빠른 입력
│   └── StatisticsView.swift       # 통계
└── Services/
    └── DataManager.swift         # 비즈니스 로직 + 파일 I/O
```

## 실행 방법

### macOS
```bash
cd ~/IdeaProjects/MoneyFlow
open MoneyFlow.xcodeproj
# Xcode에서 ⌘R로 실행
```

### iOS (개발자 모드)
1. iPhone을 Mac에 USB 연결
2. Xcode에서 프로젝트 열기
3. Signing & Capabilities에서 Team을 본인 Apple ID로 설정
4. 실행 대상을 연결된 iPhone으로 선택
5. ⌘R로 실행

**참고**: 무료 계정은 7일마다 재설치 필요

## 최근 개선사항 (2026-04-06 완료)

✅ **Phase 1: 데이터 표시 개선**
1. 년도 표시 형식 수정 (콤마 제거)
2. 월별추이 그래프 Y축 라벨 (한국어 단위)

✅ **Phase 2: 사용자 경험 개선**
3. 금액 입력 UI 대폭 개선 (실시간 포매팅, 빠른 버튼)
4. 계좌별 순증감 표시 추가

✅ **Phase 3: 편의 기능**
5. Pull-to-Refresh 동기화 기능

**완료율**: 100% (5/5)

## 관련 노트

- [[MoneyFlow-계좌입출금관리]] - 도메인 분석
- [[MoneyFlow-아키텍처]] - 기술 구조

## 향후 계획

IMPROVEMENTS.md 참고:
- 위젯 지원
- 차트 인터랙션
- AI 기반 자동 분류
- 푸시 알림
- CSV 가져오기

## 참고 문서

- README.md: 프로젝트 개요
- TODO.md: 작업 현황 (모두 완료)
- IMPROVEMENTS.md: 개선사항 완료 보고서