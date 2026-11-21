## 프로젝트 소개

- 공공주택 통합 관리 시스템
- 청약 신청부터 계약, 전입/전출, 민원 등 관리자, 입주민, 일반 사용자가 함께 이용하는 통합 플랫폼 전 과정을 하나의 플랫폼에서 처리


## ✨ 주요 기능

### 👤 사용자 (청약 신청자)
- 청약 공고 조회 및 신청, 청약 취소/재신청
- 진행 상태별 서류 제출 및 보완 재제출
- 카카오 지도 API 기반 단지 위치 조회


### 🏠 입주민
- 전입/전출 신고
- 관리비 사용량 비교 통계 조회
- 자유게시판 (게시글/댓글/대댓글, 파일 업로드)
- 시설 예약 및 이용현황 조회
- 투표 및 설문조사 참여
- 차량 등록 및 방문자 차량 등록

### 🏢 단지관리자 (관리사무소)
- 관리비 항목별 통계, 납부현황 관리, 부과/고지서 등록
- 방송 안내 관리 (TTS 및 WebSocket 기반 동별 방송 송출)
- 시설 점검·검침·공사보수 이력 관리, 편의시설 운영 및 예약 승인
- 협력업체/직원 계정 관리
- 공지사항, 투표/설문조사 등록
- 입주/퇴거 및 입주민 상태별 관리, 민원 내역 조회


### 🛠 중앙관리자
- 매물 등록 및 청약 공고 등록/조회/수정/삭제
- 청약 신청 승인/반려, 계약 단계 전환
- 계약 목록 엑셀 다운로드, 계약 상세/수정


## 👥 담당 역할 (TA)
- 🏢 **공고 관리** - 매물 등록 및 청약 공고 등록/조회/수정/삭제 (관리자)
- 📝 **청약 신청** - 공고 조회, 청약 신청, 청약 상태 조회, 서류 제출 및 재제출
- 🏠 **전입/전출 신고** - 계약 완료 후 전입 신청 및 입주민 전출 신고
- 📢 **방송 안내(TTS)** - 텍스트를 음성으로 변환하여 동별 실시간 방송 송출
- 💬 **자유게시판** - 게시글/댓글/대댓글 작성, 파일 업로드 및 썸네일 제공
- 🔐 **인증/인가** - Spring Security 기반 로그인 및 권한별 접근 제어


## 🛠 주요 기술 스택
- ⚙️ **백엔드** - Java, Spring Boot, MyBatis
- 🎨 **프론트엔드** - JavaScript, HTML5, CSS3, JSP, React
- 💾 **데이터베이스** - Oracle DB
- 🔐 **인증** - Spring Security, JWT
- 🌐 **외부 API** - Google Cloud Text-to-Speech, Google Drive API, WebSocket
- 🔄 **협업 도구** - SVN, Redmine, Notion, Discord, ERDCloud


## 🚀 빠른 시작

### 사전 요구사항
- Java 21
- Node.js 24 이상
- Oracle DB
- Sweetalert2 설치
- Axios 설치


### 설치 방법
git clone https://github.com/your-username/STEVEN_ZIPS.git
cd STEVEN_ZIPS

# 백엔드 (Spring Boot, Docker)
cd STEVEN_ZIPS

# 프론트엔드 (React)
cd STEVEN_REACT
npm install
npm start


## 접속
- 프론트엔드: `http://localhost:7777`
- 백엔드 API: `http://localhost:8080`

### 테스트 계정

|    구분   | ID |  PW  |
|----------|----|------|
| 중앙관리자  | ad | 1234 |


## 📂 폴더 구조
├── STEVEN_REACT/   # 프론트엔드 (React)
└── STEVEN_ZIPS/    # 백엔드 (Spring Boot + MyBatis)


## 🏗 아키텍처 구조

    ┌──────────┐      ┌────────────┐     ┌───────────┐
    │  React   │────▶ │ Spring Boot│────▶│ Oracle DB │
    │(Frontend)│      │ (Backend)  │     │(Database) │
    └──────────┘      └─────┬──────┘     └───────────┘
                            │
            ┌───────────────┼───────────────┐
            ▼               ▼               ▼
    ┌────────────┐   ┌─────────────┐   ┌────────────┐
    │  Google    │   │   Google    │   │  WebSocket │
    │  TTS API   │   │  Drive API  │   │  (방송 송출) │
    │ (직접 구현)  │    │  (협업 활용)  │   │  (협업 활용) │
    └────────────┘   └─────────────┘   └────────────┘

## 🖼 화면 미리보기

### 공고 관리 (중앙관리자)
| 공고 목록 |
|---|
| <img width="1461" height="902" alt="스크린샷 2026-11-21 오후 12 31 16" src="https://github.com/user-attachments/assets/a81eb26a-d9ce-47ac-a767-d7ae6a588561" />|
| 공고 등록 |
| <img width="1482" height="853" alt="스크린샷 2026-11-21 오후 12 23 14" src="https://github.com/user-attachments/assets/c591184e-97cc-4c4d-a8ea-dcb3f5d4141f" />|
|<img width="1488" height="904" alt="스크린샷 2026-11-21 오후 12 23 29" src="https://github.com/user-attachments/assets/f8f29c0a-3f2d-497d-b5d5-4e840d906ef6" />|





## 📜 라이선스
이 프로젝트는 교육 목적으로 제작되었습니다.



















