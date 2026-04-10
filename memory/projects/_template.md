---
title: _template
type: note
permalink: ai-work-assistant/projects/template
---

## 기본 정보

| 항목 | 내용 |
|------|------|
| 프로젝트명 | {PROJECT_NAME} |
| 실제 경로 | `~/IdeaProjects/{project-dir}/` |
| symlink 경로 | `~/ai-work-assistant/real-path/{project-dir}` |
| 빌드 도구 | Gradle / Maven / npm / 기타 |
| 주요 언어 | Java / Kotlin / TypeScript / 기타 |
| 프레임워크 | Spring Boot / NestJS / 기타 |
| 설명 | 프로젝트 한 줄 설명 |

---

## 패키지 / 모듈 구성

```
{project-dir}/
├── {module-1}/          # 설명
├── {module-2}/          # 설명
└── {module-3}/          # 설명
```

### 모듈별 상세

#### {module-1}
- **역할**:
- **포트**:
- **주요 API 경로**:
- **의존 서비스**:

#### {module-2}
- **역할**:
- **포트**:
- **주요 API 경로**:
- **의존 서비스**:

---

## 실행 방법

```bash
# 로컬 실행
cd ~/IdeaProjects/{project-dir}
./gradlew :{module}:bootRun

# 빌드
./gradlew :{module}:build
```

---

## 환경 설정

- **개발 환경 프로파일**: `local`, `dev`
- **설정 파일 위치**: `{module}/src/main/resources/application.yml`
- **외부 설정**: (Vault, Config Server 등 있으면 기재)

---

## 서비스 개요

(이 서비스가 왜 만들어졌고 무엇을 하는지 2~3줄로 설명)

## 환경

- 운영: https://
- 테스트: https://
- 소스 경로: ~/IdeaProjects/{프로젝트명}

## 기술 스택

- Java 17, Spring Boot 3.x
- (기타 주요 프레임워크/라이브러리)

## 연관 서비스

- 이 API를 호출하는 곳: [[{프론트엔드 또는 다른 서비스}]]
- 이 서비스가 호출하는 곳: [[{의존 서비스}]]

## DB

- DB명: (DB명, MySQL/PostgreSQL 등)
- MCP 도구: (사용하는 DB MCP 서버와 connection name)
- 주요 테이블: (핵심 테이블 나열)

## 배포

- (배포 방식: K8s, Jenkins, ArgoCD 등)
- 브랜치 전략: (예: main → 운영, develop → 테스트)

## 도메인 지식 파일

> 이 프로젝트와 관련된 `memory/domains/` 파일 목록

- [ ] `{project}-{module}-{topic}.md`

---