# 로컬 설정과 비밀정보 관리

실제 설정·인증 파일은 Git에서 제외합니다. 기존 로컬 파일은 그대로 유지합니다.

## 실행 준비

1. `src/main/resources/application.properties.example`을 같은 폴더의
   `application.properties`로 복사합니다.
2. 예시에 명시한 DB, JWT, 업로드 경로, 외부 API 환경 변수를 실행 환경에 설정합니다.
3. Google API 기능을 사용할 때만 권한이 있는 인증 파일을 resources에 준비합니다.
   현재 구현은 `credentials.json`과 `tts-key.json`을 클래스패스에서 읽습니다.
   인증 리소스가 없는 환경에서는 해당 외부 API 기능을 시연할 수 없습니다.
4. React 폴더에서 `npm ci`로 의존성을 설치합니다. `node_modules`와 `dist`는
   직접 생성하며 Git에 올리지 않습니다. lock 파일은 재현성을 위해 유지합니다.

## 제외 대상

- 실제 `application.properties`, `.env`와 로컬 환경 설정
- Google 인증 JSON, 개인키, OAuth 토큰 폴더
- DB 덤프, 로그, IDE 설정, 의존성 및 빌드 결과물
- 개인 비밀번호 생성용 `PasswordTest.java`

## 이미 커밋한 비밀정보

추적 제외는 과거 Git 기록의 비밀정보를 삭제하지 않습니다. 기존에 커밋한 Google
서비스 계정 키, OAuth client secret, JWT 비밀키, 결제·SMS API 키 및 DB 비밀번호는
노출 가능성을 전제로 확인하고 폐기·재발급해야 합니다.

과거 기록 정리에는 별도 협의와 기록 재작성이 필요합니다. 이번 정리에서는 강제
푸시나 과거 기록 재작성을 하지 않습니다.
