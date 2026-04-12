---
title: moneyflow
type: note
permalink: ai-work-assistant/projects/moneyflow
tags:
- project
- ios
- swiftui
---

## 기본 정보

| 항목 | 내용 |
|------|------|
| 프로젝트명 | MoneyFlow |
| 실제 경로 | `~/IdeaProjects/MoneyFlow/` |
| symlink 경로 | `~/ai-work-assistant/real-path/MoneyFlow` |
| 빌드 도구 | Xcode / xcodebuild |
| 주요 언어 | Swift 5 |
| 프레임워크 | SwiftUI, Charts |
| 설명 | iOS/macOS에서 JSON 파일 기반으로 계좌 입출금을 관리하고 iCloud Drive로 동기화하는 개인 자산 관리 앱 |

---

## 패키지 / 모듈 구성

```text
MoneyFlow/
├── MoneyFlow/                 # 앱 소스 (Models / Views / Services)
├── MoneyFlow.xcodeproj/       # Xcode 프로젝트 설정
├── csv_to_moneyflow.py        # CSV -> 앱 JSON 변환 스크립트
├── README.md                  # 사용법 및 동기화 가이드
├── TODO.md                    # 작업 이력/할 일
└── IMPROVEMENTS.md            # 개선 사항 보고서
```

### 모듈별 상세

#### MoneyFlow (앱 타겟)
- **역할**: 거래/계좌 CRUD, 통계 시각화, 파일 입출력 및 동기화 UI 제공
- **플랫폼**: iOS 17.0+, macOS 14.0+
- **주요 진입점**: `MoneyFlow/MoneyFlowApp.swift`, `MoneyFlow/ContentView.swift`
- **의존 서비스**: iCloud Drive(파일 동기화), UserDefaults(로컬 백업)

#### csv_to_moneyflow.py
- **역할**: 기존 CSV 거래 데이터를 MoneyFlow JSON 스키마로 변환
- **입력/출력**: CSV -> `MoneyFlowData.json`
- **특징**: 계좌 매핑, 입금/출금 판별, UUID 생성

---

## 실행 방법

```bash
# 프로젝트 열기
cd ~/IdeaProjects/MoneyFlow
open MoneyFlow.xcodeproj

# macOS 빌드
xcodebuild -project MoneyFlow.xcodeproj -scheme MoneyFlow -destination 'platform=macOS' build
```

---

## 환경 설정

- **Signing**: Xcode의 Signing & Capabilities에서 Apple ID Team 설정 필요
- **데이터 파일**: 기본 `MoneyFlowData.json` (iCloud Drive Documents 경로)
- **설정 파일 위치**: `MoneyFlow/Info.plist`, `MoneyFlow/MoneyFlow.entitlements`

---

## 서비스 개요

MoneyFlow는 거래/계좌 데이터를 서버 DB가 아닌 JSON 파일로 직접 관리하는 오프라인-우선 앱이다. 사용자는 파일 열기/저장으로 데이터 위치를 명시적으로 제어할 수 있고, iCloud Drive를 사용하면 macOS/iOS 간 파일 단위 동기화가 가능하다.

## 환경

- 운영: N/A (개인 로컬 앱)
- 테스트: N/A
- 소스 경로: `~/IdeaProjects/MoneyFlow`

## 기술 스택

- Swift 5, SwiftUI
- Charts (통계 시각화)
- UniformTypeIdentifiers, FileDocument, security-scoped bookmarks

## 연관 서비스

- 이 앱을 호출하는 외부 서비스: 없음
- 이 앱이 호출하는 외부 대상: iCloud Drive 파일 시스템

## DB

- DB명: 없음 (파일 기반 저장)
- 저장 포맷: JSON (`AppData`)
- 주요 엔티티: `Account`, `Transaction`, `SavingsGoal`

## 배포

- Xcode를 통한 로컬 실행/기기 설치
- App Store 배포 파이프라인은 현재 문서 기준 미정

## 도메인 지식 파일

- [x] `[[moneyflow-architecture-data-flow]]`