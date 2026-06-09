# 중앙관리자 공고관리 리팩토링 계획

## 현황 요약

| 계층 | 파일 | 라인수 | 주요 문제 |
|------|------|--------|-----------|
| Controller | 3개 | 307줄 | JSP/React 중복 컨트롤러 |
| Service | 4개 | 243줄 | 단순 Mapper 위임, 책임 불명확 |
| MyBatis XML | 2개 | 513줄 | 중복 쿼리, 복잡한 인라인 SQL |
| DTO | 1개 | 66필드 | Blob DTO 안티패턴 |
| JSP | 1개 | 815줄 | 인라인 스타일, 모달 3개 혼재 |
| JS | 1개 | 987줄 | 전역변수, 130줄짜리 함수 존재 |

---

## 문제 목록 (심각도 순)

### [CRITICAL] AnnouncementDTO - 66필드 Blob DTO

**현재 상태**
```java
// AnnouncementDTO.java - 66개 필드가 한 클래스에 몰려있음
public class AnnouncementDTO {
    // 기본 컬럼 (10개)
    private String annNo, annTtl, annCn, ...;
    // 조인 컬럼 (15개)
    private String aptNm, rdnmadr, ...;
    // 세대수 관련 (5개)
    private int supplyHshldCnt, ...;
    // 제출서류 관련 (8개)
    private String sbmsnDocNms, ...;
    // 첨부파일 관련 (6개)
    private String atchFileId, ...;
    // 검색 조건 (8개)
    private String searchWord, startDt, ...;
    // 기타 (14개)
    ...
}
```

**문제점**
- 등록할 때는 검색 필드가 불필요
- 목록 조회시 상세 필드가 불필요
- 어느 필드가 어떤 용도인지 구분 불가
- 유효성 검증(@Valid) 적용 불가 (조건이 사용처마다 달라짐)

**개선 방향**
```java
// 용도별로 분리
AnnouncementSearchDTO   // 검색 조건 (searchWord, startDt, endDt, status...)
AnnouncementRegisterDTO // 등록/수정 입력값 (annTtl, annCn, aptComplexNo...)
AnnouncementResponseDTO // 조회 결과 (조인 결과 포함, 읽기 전용)
```

---

### [CRITICAL] MyBatis XML - 동일 쿼리 중복 (약 77줄 × 2)

**현재 상태**
```xml
<!-- announcement_Mapper.xml -->
<select id="selectAnnouncementList" resultType="AnnouncementDTO">
    SELECT a.ANN_NO, a.ANN_TTL, ... -- 77줄짜리 동일 쿼리
    FROM CENTER_ANN_BOARD_POST a
    JOIN APT_COMPLEX c ON ...
    WHERE a.DEL_YN = 'N'
    <if test="searchWord != null">AND a.ANN_TTL LIKE ...</if>
</select>

<select id="selectAnnouncement" resultType="AnnouncementDTO">
    SELECT a.ANN_NO, a.ANN_TTL, ... -- 위와 거의 동일한 쿼리 반복
    FROM CENTER_ANN_BOARD_POST a
    JOIN APT_COMPLEX c ON ...
    WHERE a.ANN_NO = #{annNo}
</select>
```

**문제점**
- 컬럼 추가/수정 시 두 쿼리 모두 수정해야 함
- 한 곳만 수정하면 동작 불일치 발생

**개선 방향**
```xml
<!-- SQL Fragment로 공통 부분 분리 -->
<sql id="annSelectColumns">
    a.ANN_NO, a.ANN_TTL, a.ANN_CN,
    c.APT_NM, c.RDNMADR,
    (SELECT COUNT(*) FROM APT_UNIT u WHERE u.APT_COMPLEX_NO = c.APT_COMPLEX_NO) AS SUPPLY_HSHLD_CNT,
    (SELECT LISTAGG(d.DOC_NM, ', ') WITHIN GROUP (ORDER BY d.DOC_NO)
     FROM SBMSN_DOC d WHERE d.ANN_NO = a.ANN_NO) AS SBMSN_DOC_NMS
</sql>

<sql id="annFromJoin">
    FROM CENTER_ANN_BOARD_POST a
    JOIN APT_COMPLEX c ON a.APT_COMPLEX_NO = c.APT_COMPLEX_NO
    LEFT JOIN RENT_LISTING r ON a.ANN_NO = r.ANN_NO
    WHERE a.DEL_YN = 'N'
</sql>

<select id="selectAnnouncementList" resultType="AnnouncementResponseDTO">
    SELECT <include refid="annSelectColumns"/>
    <include refid="annFromJoin"/>
    <if test="searchWord != null">AND a.ANN_TTL LIKE '%' || #{searchWord} || '%'</if>
    ORDER BY a.REG_DT DESC
</select>

<select id="selectAnnouncement" resultType="AnnouncementResponseDTO">
    SELECT <include refid="annSelectColumns"/>
    <include refid="annFromJoin"/>
    AND a.ANN_NO = #{annNo}
</select>
```

---

### [HIGH] announcement.js - 130줄짜리 함수 (editFromModal, submitForm)

**현재 상태**
```javascript
// editFromModal() - 126줄: 폼 초기화 + 필드 매핑 + 이벤트 등록 + UI 전환이 한 함수에
function editFromModal() {
    // DOM 초기화 (20줄)
    document.getElementById('annTtl').value = '';
    document.getElementById('annCn').value = '';
    // ... 반복

    // 필드 값 채우기 (40줄)
    document.getElementById('annTtl').value = currentPost.annTtl;
    document.getElementById('annCn').value = currentPost.annCn;
    // ... 반복

    // 이벤트 바인딩 (30줄)
    document.getElementById('submitBtn').addEventListener('click', ...);
    // ... 반복

    // 모달 전환 (36줄)
    document.getElementById('detailModal').style.display = 'none';
    document.getElementById('editModal').style.display = 'block';
}

// submitForm() - 102줄: 유효성검증 + 페이로드 생성 + fetch + 응답처리가 한 함수에
function submitForm() {
    // 유효성 검증 (25줄)
    if (!document.getElementById('annTtl').value) { alert('제목 입력'); return; }
    // ...

    // 페이로드 생성 (30줄)
    const data = { annTtl: ..., annCn: ..., ... };

    // API 요청 (20줄)
    fetch('/api/...', { method: 'POST', body: JSON.stringify(data) })
        .then(res => res.json())
        .then(result => {
            // 응답 처리 (27줄)
        });
}
```

**개선 방향**
```javascript
// 함수를 단일 책임 원칙에 따라 분리

function resetEditForm() { /* 폼 초기화만 */ }
function populateEditForm(post) { /* 데이터 채우기만 */ }
function bindEditFormEvents() { /* 이벤트 바인딩만 */ }
function switchToEditModal() { /* 모달 전환만 */ }

// editFromModal은 위 함수들을 순서대로 호출만
function editFromModal() {
    resetEditForm();
    populateEditForm(currentPost);
    bindEditFormEvents();
    switchToEditModal();
}

function validateAnnForm(formData) { /* 검증만, boolean 반환 */ }
function buildAnnPayload() { /* 페이로드 생성만 */ }
function submitAnnRequest(payload, mode) { /* fetch만 */ }
function handleAnnResponse(result) { /* 응답 처리만 */ }

function submitForm() {
    const payload = buildAnnPayload();
    if (!validateAnnForm(payload)) return;
    submitAnnRequest(payload, formMode).then(handleAnnResponse);
}
```

---

### [HIGH] 컨트롤러 중복 - AnnouncementController vs AnnListController

**현재 상태**
```
AnnouncementController  → JSP용 CRUD (/centralAdmin/announcement/*)
AnnListController       → React용 API (/api/react/adm/annList/*)
```

두 컨트롤러가 거의 동일한 서비스 메서드를 호출하면서 각자 응답 형식만 다름.

**문제점**
- 기능 추가 시 두 컨트롤러 모두 수정
- JSP 뷰를 React로 전환 완료되면 AnnouncementController 불필요

**개선 방향**
- JSP 전환이 완료됐다면: `AnnouncementController` 제거, `AnnListController`만 유지
- 아직 병행 운영 중이라면: 컨트롤러에 주석으로 "JSP용/React용" 명확히 표시하고, 공통 로직은 private 헬퍼 메서드로 추출

---

### [MEDIUM] 매직 스트링 하드코딩

**현재 상태**
```java
// 여러 파일에서 반복
if (result == "Y") { ... }
annVO.setDelYn("N");
member.getRole().equals("admin");
```

**개선 방향**
```java
// 기존 enums 패키지 활용 또는 신규 상수 클래스
public enum DelYn { Y, N }
public enum AnnStatus { ACTIVE("N"), DELETED("Y"); }

// 또는 상수 클래스
public class AnnConstants {
    public static final String DEL_YN_NO  = "N";
    public static final String DEL_YN_YES = "Y";
}
```

---

### [MEDIUM] announcement.jsp - 815줄에 CSS 400줄 인라인

**현재 상태**
```jsp
<!-- announcement.jsp: <style> 블록이 400줄 -->
<style>
    .ann-table { width: 100%; border-collapse: collapse; }
    .ann-table th { background: #2c3e50; color: white; }
    /* ... 400줄 계속 ... */
</style>

<!-- 모달 3개가 하나의 JSP에 혼재 -->
<div id="listSection"> ... 목록 ... </div>
<div id="registerModal"> ... 등록 폼 ... </div>
<div id="detailModal"> ... 상세 ... </div>
<div id="editModal"> ... 수정 폼 ... </div>
```

**개선 방향**
```
static/css/central/admin/announcement.css  ← 인라인 스타일 추출
WEB-INF/views/centralAdmin/
  ├── announcement.jsp          ← 목록 + include만
  ├── fragments/ann-register-modal.jsp
  ├── fragments/ann-detail-modal.jsp
  └── fragments/ann-edit-modal.jsp
```

---

### [MEDIUM] JS 전역 변수 남용

**현재 상태**
```javascript
// 파일 최상단에 전역으로 선언
let posts = [];
let filtered = [];
let aptComplexList = [];
let currentPage = 1;
let currentAnnNo = null;
let formMode = null;
```

**문제점**: 어떤 함수든 전역 상태를 직접 변경 가능 → 사이드 이펙트 추적 어려움

**개선 방향**
```javascript
// 상태를 하나의 객체로 캡슐화
const AnnState = {
    posts: [],
    filtered: [],
    aptComplexList: [],
    currentPage: 1,
    currentAnnNo: null,
    formMode: null,

    reset() { this.currentPage = 1; this.currentAnnNo = null; },
    setPage(n) { this.currentPage = n; }
};
```

---

### [LOW] 파일 업로드 TODO 미구현

**현재 상태**
```java
// AnnouncementServiceImpl.java
@Override
public ServiceResult insertAnnouncement(AnnouncementDTO dto, MultipartFile file) {
    // TODO: 파일 업로드 처리
    announcementMapper.insertAnnouncement(dto);
    return ServiceResult.OK;
}
```

**개선 방향**
- 파일 업로드 미지원이라면 파라미터에서 `MultipartFile` 제거
- 지원할 계획이라면 `AttachFileService`(이미 존재) 연동하여 구현

---

### [LOW] AnnRegisterController - Map 사용 vs DTO 사용 불일치

**현재 상태**
```java
// AnnListController - DTO 사용
public ResponseEntity<?> update(@RequestBody AnnouncementDTO dto) { ... }

// AnnRegisterController - Map 사용 (일관성 없음)
public ResponseEntity<?> insertAnn(@RequestBody Map<String, Object> param) { ... }
```

**개선 방향**: `AnnouncementRegisterDTO`로 통일

---

## 리팩토링 우선순위 및 작업 순서

```
Phase 1 - 구조 정리 (핵심, 기능 변경 없음)
  ① AnnouncementDTO → SearchDTO / RegisterDTO / ResponseDTO 분리
  ② MyBatis XML - <sql> fragment로 중복 쿼리 통합
  ③ announcement.js - 함수 분리 (editFromModal, submitForm)

Phase 2 - 코드 품질 개선
  ④ 인라인 CSS → 외부 CSS 파일로 추출
  ⑤ 매직 스트링 → 상수/Enum으로 교체
  ⑥ JS 전역 변수 → 상태 객체로 캡슐화

Phase 3 - 설계 개선 (선택)
  ⑦ JSP 중복 컨트롤러 정리
  ⑧ Map 파라미터 → DTO로 통일
  ⑨ 파일 업로드 TODO 처리 (구현 또는 제거)
```

---

## 작업별 예상 소요 시간

| 작업 | 예상 시간 | 위험도 | 기능 영향 |
|------|-----------|--------|-----------|
| DTO 분리 | 2~3h | 중간 | Mapper XML resultType 수정 필요 |
| SQL Fragment | 1h | 낮음 | 없음 |
| JS 함수 분리 | 2h | 낮음 | 없음 (리네이밍) |
| CSS 파일 추출 | 1h | 낮음 | 없음 |
| 매직 스트링 | 1h | 낮음 | 없음 |
| JS 상태 객체 | 2h | 중간 | 함수 참조 방식 변경 |
| 컨트롤러 정리 | 1h | 높음 | URL 변경 가능 |

---

## 체크리스트

### Phase 1
- [ ] `AnnouncementSearchDTO.java` 생성 (검색 조건 필드만)
- [ ] `AnnouncementRegisterDTO.java` 생성 (입력 필드만, @Valid 적용)
- [ ] `AnnouncementResponseDTO.java` 생성 (조회 결과 필드만)
- [ ] `AnnouncementDTO.java` 삭제 또는 deprecated 처리
- [ ] `announcement_Mapper.xml` - `<sql id="annSelectColumns">` 추출
- [ ] `announcement_Mapper.xml` - `<sql id="annFromJoin">` 추출
- [ ] `announcement_Mapper.xml` - selectAnnouncementList, selectAnnouncement에 `<include>` 적용
- [ ] MyBatis resultType을 `AnnouncementResponseDTO`로 변경
- [ ] `announcement.js` - `editFromModal()` → 4개 함수로 분리
- [ ] `announcement.js` - `submitForm()` → 4개 함수로 분리

### Phase 2
- [ ] `static/css/central/admin/announcement.css` 파일 생성
- [ ] `announcement.jsp`의 `<style>` 블록 → CSS 파일로 이동
- [ ] `AnnStatus` Enum 또는 `AnnConstants` 상수 클래스 생성
- [ ] 하드코딩 "Y"/"N" 상수로 교체
- [ ] `announcement.js` 전역 변수 → `AnnState` 객체로 통합
- [ ] `AnnState`를 참조하는 모든 함수 수정

### Phase 3
- [ ] JSP/React 중복 컨트롤러 정리 방향 결정
- [ ] `AnnRegisterController.insertAnn()` - Map → `AnnouncementRegisterDTO`로 교체
- [ ] `AnnouncementServiceImpl.insertAnnouncement()` - MultipartFile 파라미터 처리 결정
