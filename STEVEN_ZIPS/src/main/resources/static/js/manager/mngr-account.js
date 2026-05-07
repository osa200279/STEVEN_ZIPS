/**
 * ============================================================
 * mngr-account.js
 * 직원 계정 관리 화면 동작 스크립트
 *
 * 담당 역할:
 *   - 재직 직원 / 계정 생성 요청 목록 조회 (서버 API 호출)
 *   - 그리드 데이터 갱신 (MngrAccountGrid.setRows 위임)
 *   - 상세 / 수정 / 등록 모달 제어
 *   - 회원 검색 팝업 연동
 *   - 엑셀 다운로드
 *   - 확인(Confirm) 모달 제어
 *
 * 의존 파일 (로드 순서):
 *   1. manager-common.js      → emptyIfNull / openModal / closeModal / getJson / postJson
 *   2. manager-agGrid.js      → createManagerGrid / setGridRowData (MngrAccountGrid 에서 내부 사용)
 *   3. AgRenderer.js          → 셀 렌더러 모음 (MngrAccountGrid 에서 내부 사용)
 *   4. mngr-account-grid.js   → MngrAccountGrid (그리드 생성 + 코드 변환 유틸)
 *   5. mngr-account.js        → 이 파일 (화면 동작 전체)
 * ============================================================
 */

/* DOMContentLoaded: HTML 파싱이 끝난 직후 실행. 이미지/폰트 로드를 기다리지 않아 빠름. */
document.addEventListener("DOMContentLoaded", function () {
    initMngrAccountPage();
});


/**
 * 화면 전체를 초기화하는 메인 함수.
 * 내부 함수들을 클로저로 묶어 전역 오염을 방지함.
 */
function initMngrAccountPage() {

    /* ──────────────────────────────────────────────
       [1] 화면 유효성 검사 및 기본 설정
    ────────────────────────────────────────────── */

    /**
     * page: 이 화면의 루트 요소.
     * 없으면 다른 페이지에 같이 로드된 것이므로 즉시 종료 → 충돌 방지.
     */
    var page = document.getElementById("mngrAccountPage");
    if (!page) return;

    /**
     * config: JSP 에서 window.mngrAccountConfig 로 주입한 서버 데이터.
     * EL 표현식으로 Java 변수를 JS 로 넘기는 패턴.
     * 없으면 빈 객체로 fallback 해서 이후 코드가 터지지 않도록.
     */
    var config = window.mngrAccountConfig || {};

    /** contextPath: Spring MVC 의 컨텍스트 경로. API URL 조립 시 앞에 붙임. ex) /office */
    var contextPath = config.contextPath  || "";

    /** mgmtOfcNo: 현재 관리 중인 사무소 번호 (PK). API URL 경로 변수로 사용. */
    var mgmtOfcNo   = config.mgmtOfcNo   || "";

    /** mgmtOfcNm: 사무소 명칭. 모달 안 '관리사무소' 필드에 표시용. */
    var mgmtOfcNm   = config.mgmtOfcNm   || "";

    /** aptCmplexNm: 단지명. 모달 안 '단지' 필드에 표시용. */
    var aptCmplexNm = config.aptCmplexNm || "";

    /** loginUserNm: 현재 로그인한 관리자 이름. 요청 등록 모달의 '요청자' 필드에 표시. */
    var loginUserNm = config.loginUserNm  || "";

    /**
     * isAdmin: ADMIN 계정 여부.
     * true 이면 수정/등록 버튼 비활성화, 조회만 허용.
     * JSP 에서 문자열 "true"/"false" 로 오기 때문에 === "true" 로 비교해 boolean 변환.
     */
    var isAdmin = config.isAdmin === true;


    /* ──────────────────────────────────────────────
       [2] 데이터 및 그리드 요소 정의
    ────────────────────────────────────────────── */

    /**
     * managerRowData: 서버에서 받아온 재직 직원 목록을 담는 배열.
     * AG Grid 에 바인딩하고, updateStats / excelDownload 에서도 사용.
     */
    var managerRowData = [];

    /**
     * requestRowData: 서버에서 받아온 계정 생성 요청 목록을 담는 배열.
     * 요청 상세/수정 모달에서 rqstNo 로 행을 찾을 때도 사용.
     */
    var requestRowData = [];

    /** managerGridEl: 재직 직원 AG Grid 가 그려질 DOM 요소. */
    var managerGridEl = document.getElementById("managerGrid");

    /** requestGridEl: 계정 생성 요청 AG Grid 가 그려질 DOM 요소. */
    var requestGridEl = document.getElementById("requestGrid");

    /**
     * confirmCallback: 확인 모달에서 [확인] 클릭 시 실행할 함수를 임시 보관.
     * openConfirm() 에서 주입 → confirmActionBtn click 에서 실행.
     * null 로 초기화해 이전 콜백이 잘못 실행되는 것을 방지.
     */
    var confirmCallback = null;


    /* ──────────────────────────────────────────────
       [3] 화면 초기 텍스트 세팅
       모달 안 읽기 전용 필드에 서버에서 받은 값을 미리 채워둠.
    ────────────────────────────────────────────── */

    setField("rqstMgmtOfcNoHidden",    mgmtOfcNo);               /* 숨김 필드: 서버 전송 시 사무소 번호 */
    setField("requestMgmtOfcNoText",   mgmtOfcNm || mgmtOfcNo);  /* 모달 표시: 사무소 명칭 (없으면 번호) */
    setField("requestAptCmplexNmText", aptCmplexNm);             /* 모달 표시: 단지명 */
    setField("requestLoginUserNmText", loginUserNm);             /* 모달 표시: 요청자 이름 */


    /* ──────────────────────────────────────────────
       [4] 내부 유틸리티 함수
    ────────────────────────────────────────────── */

    /**
     * _esc(v): HTML 특수문자를 이스케이프해 XSS 를 방어.
     * data-* 속성이나 innerHTML 조합 시 외부 데이터(서버 응답)를 그대로 넣으면
     * 이름 안에 " 나 > 같은 문자가 있을 때 HTML 구조가 깨질 수 있음.
     * 함수명 앞 _ 는 이 파일 안에서만 쓰는 내부 함수임을 표시.
     */
    function _esc(v) {
        return String(v == null ? "" : v)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    /**
     * getField(id): 지정한 id 요소의 value 를 가져와 양끝 공백을 제거.
     * API URL 조립이나 저장 전 값 추출 시 사용.
     * 요소가 없으면 빈 문자열 반환해 에러를 방지.
     */
    function getField(id) {
        var el = document.getElementById(id);
        return el ? el.value.trim() : "";
    }

    /**
     * setField(id, value): 지정한 id 요소의 value 를 안전하게 세팅.
     * emptyIfNull: manager-common.js 의 공통 유틸. null/undefined 를 "" 로 변환.
     * null 을 그대로 넣으면 input 에 "null" 문자열이 보이는 문제를 방지.
     */
    function setField(id, value) {
        var el = document.getElementById(id);
        if (el) el.value = emptyIfNull(value);
    }

    /**
     * setText(id, value): 지정한 id 요소의 textContent 를 안전하게 세팅.
     * innerHTML 대신 textContent 를 쓰는 이유: XSS 방어 (태그로 해석되지 않음).
     * 건수 표시(N건) / 상태 요약 텍스트 갱신에 사용.
     */
    function setText(id, value) {
        var el = document.getElementById(id);
        if (el) el.textContent = emptyIfNull(value);
    }

    /**
     * formatDate(value): 날짜 문자열을 모달 표시용(yyyy.MM.dd)으로 변환.
     * 서버에서 "2026-05-07" 또는 "2026-05-07T00:00:00" 형태로 옴.
     * 앞 10자리만 잘라 하이픈을 점으로 바꿔 반환.
     * 그리드 셀에는 AgRenderer.date.dot 을 사용하고
     * 모달 input 에 넣을 때는 이 함수를 사용 (HTML 태그 포함 안 됨).
     */
    function formatDate(value) {
        if (!value) return "-";
        var s = String(value);
        return s.length >= 10 && s.indexOf("-") > -1
            ? s.slice(0, 10).replace(/-/g, ".")
            : s;
    }

    /**
     * reloadCurrentPage(): 저장 성공 후 현재 페이지를 다시 로드.
     * location.reload() 대신 href 로 URL 을 지정하는 이유:
     * reload() 는 POST 후 재로드 시 확인 팝업이 뜨는 브라우저가 있음.
     */
    function reloadCurrentPage() {
        location.href = contextPath + "/manager/employee/account/" + mgmtOfcNo;
    }

    /**
     * blockAdminWrite(): ADMIN 계정인지 확인해 쓰기 동작을 막음.
     * 저장 함수들 맨 앞에서 호출해 ADMIN 이면 즉시 return.
     * JSP 의 c:if 와 이중으로 방어해 클라이언트 조작을 방지.
     */
    function blockAdminWrite() {
        return isAdmin;
    }


    /* ──────────────────────────────────────────────
       [4-1] 통계 업데이트
    ────────────────────────────────────────────── */

    /**
     * updateStats(): 그리드 데이터(managerRowData / requestRowData)를 기준으로
     * 패널 헤더의 건수 칩과 현황 텍스트를 모두 갱신.
     * 데이터 로드 완료(loadEmployeeList / loadRequestList) 후 항상 호출.
     */
    function updateStats() {
        /* 재직 직원 통계 */
        var managerTotal    = managerRowData.length;
        var managerActive   = managerRowData.filter(function (r) { return r.userYn === "Y"; }).length;
        var managerInactive = managerRowData.filter(function (r) { return r.userYn === "N"; }).length;

        /* 요청 통계: 상태 코드 비교 전 normalizeStatus 로 대문자 통일 */
        var requestTotal  = requestRowData.length;
        var requestWait   = requestRowData.filter(function (r) { return MngrAccountGrid.normalizeStatus(r.rqstSttsCd) === "WAIT"; }).length;
        var requestOk     = requestRowData.filter(function (r) { return MngrAccountGrid.normalizeStatus(r.rqstSttsCd) === "OK";   }).length;
        var requestReject = requestRowData.filter(function (r) { return MngrAccountGrid.normalizeStatus(r.rqstSttsCd) === "RJCT"; }).length;
        var requestCancel = requestRowData.filter(function (r) { return MngrAccountGrid.normalizeStatus(r.rqstSttsCd) === "CNL";  }).length;

        /* 패널 헤더 건수 + 칩 + 현황 텍스트 갱신 */
        setText("managerTotalCount",   managerTotal + "건");
        setText("managerStatusCount",  "활성 " + managerActive + " · 비활성 " + managerInactive);
        setText("managerChipTotal",    managerTotal);
        setText("managerChipActive",   managerActive);
        setText("managerChipInactive", managerInactive);

        setText("requestTotalCount",   requestTotal + "건");
        setText("requestStatusCount",  "대기 " + requestWait + " · 승인 " + requestOk + " · 반려 " + requestReject + " · 취소 " + requestCancel);
        setText("requestChipTotal",    requestTotal);
        setText("requestChipWait",     requestWait);
        setText("requestChipOk",       requestOk);
        setText("requestChipReject",   requestReject);
        setText("requestChipCancel",   requestCancel);
    }


    /* ──────────────────────────────────────────────
       [5] 데이터 로드 및 그리드 생성
    ────────────────────────────────────────────── */

    /**
     * loadEmployeeList(): 재직 직원 목록을 서버에서 가져와 그리드에 반영.
     * getJson: manager-common.js 의 공통 GET 유틸. Promise 반환.
     * 필터 값이 비어있으면 서버에서 전체 조회.
     */
    function loadEmployeeList() {
        var url = contextPath + "/manager/employee/list/" + mgmtOfcNo
            + "?keyword="    + encodeURIComponent(getField("managerKeyword"))    /* 이름/아이디/연락처 */
            + "&mngrDutyCd=" + encodeURIComponent(getField("managerDutyFilter")); /* 직무 코드 */

        getJson(url).then(function (data) {
            managerRowData = data.list || [];
            /* setRows: mngr-account-grid.js 가 공개한 그리드 갱신 함수 */
            MngrAccountGrid.setRows(managerGridEl, managerRowData);
            updateStats();
        }).catch(function () {
            alert("재직 직원 목록 조회 중 오류가 발생했습니다.");
        });
    }

    /**
     * loadRequestList(): 계정 생성 요청 목록을 서버에서 가져와 그리드에 반영.
     * dateType: 요청일(RQST) / 처리일(APRV) / 둘 다(BOTH) 기준으로 날짜 필터 적용.
     */
    function loadRequestList() {
        var url = contextPath + "/manager/employee/request/list/" + mgmtOfcNo
            + "?keyword="    + encodeURIComponent(getField("requestKeyword"))      /* 이름/아이디 */
            + "&rqstDutyCd=" + encodeURIComponent(getField("requestDutyFilter"))   /* 직무 코드 */
            + "&rqstSttsCd=" + encodeURIComponent(getField("requestStatusFilter")) /* 상태 코드 */
            + "&dateType="   + encodeURIComponent(getField("requestDateType"))     /* 날짜 기준 유형 */
            + "&searchDate=" + encodeURIComponent(getField("requestSearchDate"));  /* 날짜 값 */

        getJson(url).then(function (data) {
            requestRowData = data.list || [];
            MngrAccountGrid.setRows(requestGridEl, requestRowData);
            updateStats();
        }).catch(function () {
            alert("직원 계정 요청 목록 조회 중 오류가 발생했습니다.");
        });
    }

    /**
     * createGrids(): 두 AG Grid 의 컬럼 정의와 초기 데이터를 설정해 그리드를 생성.
     * 실제 컬럼 정의는 mngr-account-grid.js 의 MngrAccountGrid.createGrids 에 위임.
     * 이 함수는 파라미터를 조립해서 넘기는 역할만 함.
     */
    function createGrids() {
        MngrAccountGrid.createGrids({
            managerGridEl:  managerGridEl,   /* 재직 직원 그리드 DOM */
            requestGridEl:  requestGridEl,   /* 요청 목록 그리드 DOM */
            managerRowData: managerRowData,  /* 초기 데이터 (빈 배열 — 이후 loadEmployeeList 가 채움) */
            requestRowData: requestRowData,  /* 초기 데이터 (빈 배열 — 이후 loadRequestList 가 채움) */
            isAdmin:        isAdmin          /* 수정 버튼 표시 여부 결정 */
        });
    }


    /* ──────────────────────────────────────────────
       [6] 화면 UI 제어 (모달, 탭, 필터 초기화)
    ────────────────────────────────────────────── */

    /**
     * closeAllModals(): 현재 열려있는 모든 모달을 닫음.
     * [닫기] 버튼 클릭 시 어느 모달인지 특정하지 않고 전체를 닫을 때 사용.
     * closeModal: manager-common.js 의 공통 함수.
     */
    function closeAllModals() {
        page.querySelectorAll(".modal-overlay.open").forEach(function (modal) {
            closeModal(modal.id);
        });
    }

    /**
     * setFormDisabled(formId, disabled): 폼 안의 모든 입력 요소를 일괄 활성/비활성화.
     * type=hidden 은 제외: hidden 을 disable 하면 form.reset() 후 값이 사라져 숨김 필드 값이 날아감.
     * 상세 모드에서 true, 수정 모드로 전환 시 false 후 특정 필드만 다시 열어줌.
     */
    function setFormDisabled(formId, disabled) {
        var form = document.getElementById(formId);
        if (!form) return;
        form.querySelectorAll("input:not([type=hidden]), select, textarea")
            .forEach(function (el) { el.disabled = disabled; });
    }

    /**
     * changeTab(tab): 탭 버튼 활성 클래스와 탭 패널 표시를 동시에 전환.
     * tab 값: "manager" | "request"
     */
    function changeTab(tab) {
        page.querySelectorAll(".tab-btn").forEach(function (btn) {
            btn.classList.toggle("active", btn.dataset.tab === tab);
        });
        document.getElementById("managerTabPanel").classList.toggle("active", tab === "manager");
        document.getElementById("requestTabPanel").classList.toggle("active", tab === "request");
    }

    /** resetManagerFilter(): 재직 직원 필터 초기화 후 재조회. */
    function resetManagerFilter() {
        setField("managerKeyword", "");
        var el = document.getElementById("managerDutyFilter");
        if (el) el.value = "";
        loadEmployeeList();
    }

    /** resetRequestFilter(): 요청 목록 필터 초기화 후 재조회. */
    function resetRequestFilter() {
        setField("requestKeyword",    "");
        setField("requestSearchDate", "");
        var duty   = document.getElementById("requestDutyFilter");
        var status = document.getElementById("requestStatusFilter");
        var dtype  = document.getElementById("requestDateType");
        if (duty)   duty.value   = "";
        if (status) status.value = "";
        if (dtype)  dtype.value  = "RQST"; /* 초기값: 요청일 기준 */
        loadRequestList();
    }

    /**
     * excelDownload(): 현재 그리드 데이터(managerRowData)를 엑셀(.xlsx) 파일로 저장.
     * SheetJS(XLSX) 라이브러리 사용. body 끝의 CDN script 태그로 로드됨.
     * typeof XLSX 체크: CDN 로드 실패 시 에러 대신 안내 메시지 표시.
     * MngrAccountGrid.dutyText: 직무 코드(ACNT 등)를 한글('회계담당')로 변환.
     */
    function excelDownload() {
        if (typeof XLSX === "undefined") {
            alert("엑셀 다운로드 라이브러리가 로드되지 않았습니다.");
            return;
        }

        var rows = managerRowData.map(function (row) {
            return {
                "직원명": emptyIfNull(row.userNm),
                "아이디": emptyIfNull(row.userId),
                "직무":   MngrAccountGrid.dutyText(row.mngrDutyCd), /* 코드 → 한글 */
                "연락처": emptyIfNull(row.telno),
                "이메일": emptyIfNull(row.userEml),
                "상태":   row.userYn === "Y" ? "활성" : "비활성"
            };
        });

        var ws = XLSX.utils.json_to_sheet(rows);                  /* 배열 → 시트 */
        var wb = XLSX.utils.book_new();                           /* 워크북 생성 */
        XLSX.utils.book_append_sheet(wb, ws, "재직직원");          /* 시트 이름 설정 */
        XLSX.writeFile(wb, "재직직원목록.xlsx");                   /* 파일 다운로드 실행 */
    }


    /* ──────────────────────────────────────────────
       [7] 상세 / 수정 모달
    ────────────────────────────────────────────── */

    /**
     * openManagerDetail(row): 재직 직원 상세 모달을 읽기 전용으로 열기.
     * row: 그리드에서 클릭한 행의 데이터 객체.
     * 모달 하단 버튼은 isAdmin 여부에 따라 동적으로 구성.
     */
    function openManagerDetail(row) {
        document.getElementById("accountModalTitle").textContent = "재직 직원 상세";

        fillManagerForm(row);              /* 폼에 데이터 채우기 */
        setFormDisabled("accountForm", true); /* 전체 읽기 전용 */

        /* 닫기 버튼은 항상 표시, ADMIN 이 아닐 때만 수정 버튼 추가 */
        var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';
        if (!isAdmin) {
            /* _esc: data-user-no 속성에 넣기 전 XSS 방어 */
            footer += '<button type="button" class="btn btn-primary"'
                + ' data-action="manager-edit"'
                + ' data-user-no="' + _esc(row.userNo) + '">수정</button>';
        }
        document.getElementById("accountModalFooter").innerHTML = footer;

        openModal("accountModal"); /* openModal: manager-common.js */
    }

    /**
     * openManagerEdit(row): 재직 직원 직무 수정 모달 열기.
     * 전체 필드를 비활성화한 뒤 직무(accountDutyCd) 필드만 활성화.
     * 수정 가능한 항목을 직무로 제한하는 이유: 이름/아이디 등은 회원 정보이므로 여기서 변경 불가.
     */
    function openManagerEdit(row) {
        if (blockAdminWrite()) return; /* ADMIN 이면 수정 불가 */

        document.getElementById("accountModalTitle").textContent = "재직 직원 직무 수정";

        fillManagerForm(row);
        setFormDisabled("accountForm", true); /* 전체 비활성화 */

        /* 직무 셀렉트만 다시 활성화 */
        var duty = document.getElementById("accountDutyCd");
        if (duty) duty.disabled = false;

        document.getElementById("accountModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-manager-update">수정 저장</button>';

        openModal("accountModal");
    }

    /**
     * fillManagerForm(row): 직원 데이터를 accountForm 의 각 필드에 매핑.
     * setField: null/undefined 를 "" 로 변환해 input 에 "null" 이 보이는 것을 방지.
     */
    function fillManagerForm(row) {
        setField("accountUserNo",    row.userNo);    /* 숨김: 수정 저장 시 서버 전달 */
        setField("accountMgmtOfcNo", row.mgmtOfcNo); /* 숨김: 수정 저장 시 서버 전달 */
        setField("accountUserYn",    row.userYn);    /* 숨김: 참조용 */
        setField("accountUserNm",    row.userNm);
        setField("accountUserId",    row.userId);
        setField("accountTelno",     row.telno);
        setField("accountUserEml",   row.userEml);
        setField("accountBirthDate", row.birthDate);

        var duty = document.getElementById("accountDutyCd");
        if (duty) duty.value = row.mngrDutyCd || ""; /* 현재 직무 코드로 셀렉트 선택 */
    }

    /**
     * clearRequestForm(): 요청 폼을 초기 상태로 완전히 리셋.
     * form.reset() 으로 HTML 기본값으로 되돌리고,
     * JS 로 세팅한 값들(숨김 필드, 선택 회원 정보 등)은 별도로 초기화.
     * 등록 모달을 열 때와 수정→등록 전환 시 항상 호출.
     */
    function clearRequestForm() {
        var form = document.getElementById("requestForm");
        if (form) form.reset();

        setField("rqstNo",               "");                     /* 등록 시 비어야 함 */
        setField("rqstUserNo",            "");
        setField("rqstMgmtOfcNoHidden",   mgmtOfcNo);            /* 사무소 번호 복원 */
        setField("requestMgmtOfcNoText",  mgmtOfcNm || mgmtOfcNo);
        setField("requestAptCmplexNmText", aptCmplexNm);
        setField("requestLoginUserNmText", loginUserNm);

        clearSelectedMember(); /* 선택된 회원 표시 카드도 초기화 */

        /* 상태/반려 영역은 등록 모드에서 보이지 않아야 함 */
        document.getElementById("rqstStatusSection").style.display = "none";
        document.getElementById("rqstRjctBox").style.display       = "none";
    }

    /**
     * openRequestInsert(): 계정 생성 요청 등록 모달 열기.
     * 폼 전체를 활성화하되, 이름/아이디는 회원 검색을 통해서만 입력하도록 readOnly 로 고정.
     */
    function openRequestInsert() {
        if (blockAdminWrite()) return;

        clearRequestForm();
        document.getElementById("requestModalTitle").textContent = "계정 생성 요청 등록";
        setFormDisabled("requestForm", false); /* 전체 활성화 */

        /* 이름/아이디는 직접 입력 불가. showSelectedMember() 에서 자동 입력. */
        document.getElementById("rqstMngrNm").readOnly  = true;
        document.getElementById("rqstLoginId").readOnly = true;

        document.getElementById("requestModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-request-insert">등록 요청</button>';

        openModal("requestModal");
    }

    /**
     * openRequestDetail(row): 요청 상세 모달을 읽기 전용으로 열기.
     * 요청 상태 섹션(rqstStatusSection)을 표시하고
     * 반려(RJCT) 상태면 반려 사유(rqstRjctBox)도 추가로 표시.
     * WAIT 상태에서만 수정 버튼 노출.
     */
    function openRequestDetail(row) {
        fillRequestForm(row);

        document.getElementById("requestModalTitle").textContent   = "계정 생성 요청 상세";
        document.getElementById("rqstStatusSection").style.display = ""; /* 상태 섹션 표시 */

        setField("rqstDt",         formatDate(row.rqstDt));              /* 요청일 yyyy.MM.dd */
        setField("rqstSttsCdText", MngrAccountGrid.sttsText(row.rqstSttsCd)); /* 상태 코드 → 한글 */

        /* 반려 상태일 때만 반려 사유 박스 표시 */
        if (MngrAccountGrid.normalizeStatus(row.rqstSttsCd) === "RJCT") {
            document.getElementById("rqstRjctBox").style.display = "";
            setField("rqstRjctRsnCn", row.rjctRsnCn);
        }

        setFormDisabled("requestForm", true); /* 전체 읽기 전용 */

        var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';

        /* ADMIN 이 아니고 WAIT 상태일 때만 수정 버튼 표시 */
        if (!isAdmin && MngrAccountGrid.normalizeStatus(row.rqstSttsCd) === "WAIT") {
            footer += '<button type="button" class="btn btn-primary"'
                + ' data-action="request-edit"'
                + ' data-rqst-no="' + _esc(row.rqstNo) + '">수정</button>';
        }

        document.getElementById("requestModalFooter").innerHTML = footer;
        openModal("requestModal");
    }

    /**
     * openRequestEdit(row): 요청 수정 모달 열기.
     * 전체 비활성화 후 직무(rqstDutyCd)와 비고(rqstRmrkCn)만 활성화.
     * 수정 가능 항목을 직무/비고로 제한하는 이유: 요청 대상 회원은 이미 선택 완료 상태.
     */
    function openRequestEdit(row) {
        if (blockAdminWrite()) return;

        fillRequestForm(row);

        document.getElementById("requestModalTitle").textContent   = "계정 생성 요청 수정";
        document.getElementById("rqstStatusSection").style.display = "";

        setField("rqstDt",         formatDate(row.rqstDt));
        setField("rqstSttsCdText", MngrAccountGrid.sttsText(row.rqstSttsCd));

        setFormDisabled("requestForm", true); /* 전체 비활성화 후 */

        /* 직무와 비고만 수정 가능하게 열어줌 */
        var duty = document.getElementById("rqstDutyCd");
        var rmrk = document.getElementById("rqstRmrkCn");
        if (duty) duty.disabled = false;
        if (rmrk) rmrk.disabled = false;

        document.getElementById("requestModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-request-update">수정 저장</button>';

        openModal("requestModal");
    }

    /**
     * fillRequestForm(row): 요청 데이터를 requestForm 의 각 필드에 매핑.
     * clearRequestForm() 을 먼저 호출해 이전 입력값을 완전히 지운 뒤 채움.
     * showSelectedMember 로 선택된 회원 카드도 함께 표시.
     */
    function fillRequestForm(row) {
        clearRequestForm(); /* 이전 값 완전 초기화 후 */

        setField("rqstNo",              row.rqstNo);
        setField("rqstUserNo",           row.userNo);
        setField("rqstMngrNm",           row.rqstMngrNm);
        setField("rqstLoginId",          row.rqstLoginId);
        setField("rqstRmrkCn",           row.rmrkCn);
        setField("rqstMgmtOfcNoHidden",  row.mgmtOfcNo || mgmtOfcNo);

        var duty = document.getElementById("rqstDutyCd");
        if (duty) duty.value = row.rqstDutyCd || "";

        /* 선택된 회원 카드 표시 (상세/수정 모드에서도 누가 선택됐는지 보여줌) */
        showSelectedMember({
            userNo: row.userNo,
            userNm: row.rqstMngrNm,
            userId: row.rqstLoginId
        });
    }


    /* ──────────────────────────────────────────────
       [8] 회원 검색 및 선택
    ────────────────────────────────────────────── */

    /**
     * showSelectedMember(member): 회원 선택 카드(#rqstSelectedMember)를 화면에 표시.
     * member: { userNo, userNm, userId } 구조.
     * .visible 클래스 추가 → CSS 에서 display:flex 로 전환.
     * 폼 숨김 필드(rqstUserNo)도 함께 채워 저장 시 서버로 전달.
     */
    function showSelectedMember(member) {
        /* 아바타: 이름 첫 글자 표시. textContent 이므로 XSS 방어 불필요. */
        document.getElementById("selMemberAvatar").textContent = member.userNm ? member.userNm.charAt(0) : "-";
        document.getElementById("selMemberName").textContent   = emptyIfNull(member.userNm);
        document.getElementById("selMemberSub").textContent    = emptyIfNull(member.userId);
        document.getElementById("rqstSelectedMember").classList.add("visible");

        /* 실제 전송 필드도 함께 채움 */
        setField("rqstMngrNm",  member.userNm);
        setField("rqstLoginId", member.userId);
        setField("rqstUserNo",  member.userNo);
    }

    /**
     * clearSelectedMember(): 선택된 회원 카드를 숨기고 관련 필드 초기화.
     * [×] 버튼 클릭 시 또는 폼 초기화(clearRequestForm) 시 호출.
     */
    function clearSelectedMember() {
        document.getElementById("rqstSelectedMember").classList.remove("visible");
        setField("rqstMngrNm",  "");
        setField("rqstLoginId", "");
        setField("rqstUserNo",  "");
    }

    /**
     * doMemberSearch(): 회원 검색 팝업 안에서 실제 검색 API 를 호출하고 결과를 렌더링.
     * 결과 항목(data-action="select-member")을 클릭하면 이벤트 위임에서 showSelectedMember 호출.
     * innerHTML 에 서버 데이터를 넣으므로 _esc() 로 XSS 방어.
     */
    function doMemberSearch() {
        var keyword   = getField("memberModalKeyword");
        var resultBox = document.getElementById("memberSearchResult");

        resultBox.innerHTML = '<div class="member-empty">검색 중...</div>';

        var url = contextPath + "/manager/employee/member/search/" + mgmtOfcNo
            + "?keyword=" + encodeURIComponent(keyword);

        getJson(url).then(function (data) {
            var list = data.list || [];

            if (list.length === 0) {
                resultBox.innerHTML = '<div class="member-empty">검색 결과가 없습니다.</div>';
                return;
            }

            /*
             * data-user-no / data-user-nm / data-user-id: 선택 클릭 시 이벤트 위임에서 읽음.
             * _esc: 이름/아이디에 HTML 특수문자가 있어도 속성이 깨지지 않도록.
             */
            resultBox.innerHTML = list.map(function (m) {
                return '<div class="member-item" data-action="select-member"'
                    + ' data-user-no="' + _esc(m.userNo) + '"'
                    + ' data-user-nm="' + _esc(m.userNm) + '"'
                    + ' data-user-id="' + _esc(m.userId) + '">'
                    + '<div class="m-avatar">' + _esc(m.userNm ? m.userNm.charAt(0) : "-") + '</div>'
                    + '<div>'
                    + '<div class="m-name">' + _esc(m.userNm) + '</div>'
                    + '<div class="m-sub">'  + _esc(m.userId) + ' · ' + _esc(m.userTelno) + '</div>'
                    + '</div></div>';
            }).join("");
        }).catch(function () {
            resultBox.innerHTML = '<div class="member-empty">검색 중 오류가 발생했습니다.</div>';
        });
    }


    /* ──────────────────────────────────────────────
       [9] 서버 전송(저장) 처리
    ────────────────────────────────────────────── */

    /**
     * submitManagerUpdate(): 직원 직무 수정 내용을 서버에 저장.
     * postJson: manager-common.js 의 공통 POST 유틸. CSRF 토큰 자동 포함.
     * 성공 시 reloadCurrentPage() 로 목록을 새로 불러옴.
     */
    function submitManagerUpdate() {
        if (blockAdminWrite()) return;

        if (!getField("accountDutyCd")) {
            alert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/duty/update/" + mgmtOfcNo, {
            userNo:     getField("accountUserNo"),   /* 수정 대상 직원 PK */
            mgmtOfcNo:  mgmtOfcNo,                   /* 소속 사무소 */
            mngrDutyCd: getField("accountDutyCd")   /* 변경할 직무 코드 */
        }).then(function (result) {
            alert(result.message || "처리되었습니다.");
            if (result.success) reloadCurrentPage();
        }).catch(function () {
            alert("처리 중 오류가 발생했습니다.");
        });
    }

    /**
     * submitRequestInsert(): 신규 계정 생성 요청을 서버에 저장.
     * rqstUserNo(회원 선택 여부)와 rqstDutyCd(직무 선택 여부)를 먼저 검증.
     */
    function submitRequestInsert() {
        if (blockAdminWrite()) return;

        if (!getField("rqstUserNo")) {
            alert("직원으로 등록할 회원을 선택하세요.");
            return;
        }
        if (!getField("rqstDutyCd")) {
            alert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/request/insert/" + mgmtOfcNo, {
            rqstLoginId: getField("rqstLoginId"), /* 선택한 회원의 로그인 아이디 */
            rqstMngrNm:  getField("rqstMngrNm"),  /* 선택한 회원의 이름 */
            rqstDutyCd:  getField("rqstDutyCd"),  /* 요청할 직무 코드 */
            rmrkCn:      getField("rqstRmrkCn")   /* 비고 (선택 입력) */
        }).then(function (result) {
            alert(result.message || "처리되었습니다.");
            if (result.success) reloadCurrentPage();
        }).catch(function () {
            alert("처리 중 오류가 발생했습니다.");
        });
    }

    /**
     * submitRequestUpdate(): 기존 계정 생성 요청의 직무/비고를 수정 저장.
     * rqstNo 로 서버에서 어떤 요청을 수정할지 특정.
     */
    function submitRequestUpdate() {
        if (blockAdminWrite()) return;

        if (!getField("rqstDutyCd")) {
            alert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/request/update/" + mgmtOfcNo, {
            rqstNo:     getField("rqstNo"),      /* 수정 대상 요청 PK */
            rqstDutyCd: getField("rqstDutyCd"), /* 변경할 직무 코드 */
            rmrkCn:     getField("rqstRmrkCn")  /* 변경할 비고 */
        }).then(function (result) {
            alert(result.message || "처리되었습니다.");
            if (result.success) reloadCurrentPage();
        }).catch(function () {
            alert("처리 중 오류가 발생했습니다.");
        });
    }

    /**
     * cancelRequest(rqstNo): 요청 취소 처리.
     * 1) requestRowData 에서 해당 행을 찾아 상태 검증.
     * 2) WAIT 상태가 아니면 취소 불가 안내 (그리드의 is-disabled 와 이중 방어).
     * 3) 확인 모달(openConfirm)을 열어 사용자 재확인 후 API 호출.
     * confirmReason: 확인 모달의 사유 입력 textarea 값 (취소 사유 서버 전달용).
     */
    function cancelRequest(rqstNo) {
        if (blockAdminWrite()) return;

        var row = requestRowData.find(function (item) {
            return String(item.rqstNo) === String(rqstNo);
        });

        if (!row) {
            alert("요청 정보를 찾을 수 없습니다.");
            return;
        }

        if (MngrAccountGrid.normalizeStatus(row.rqstSttsCd) !== "WAIT") {
            alert("승인대기 상태의 요청만 취소할 수 있습니다.");
            return;
        }

        /* showReason=true: 확인 모달에 사유 입력창 표시 */
        openConfirm("요청 취소", "선택한 계정 생성 요청을 취소하시겠습니까?", true, function () {
            postJson(contextPath + "/manager/employee/request/cancel/" + mgmtOfcNo, {
                rqstNo: rqstNo,
                rmrkCn: getField("confirmReason") /* 취소 사유 */
            }).then(function (result) {
                alert(result.message || "처리되었습니다.");
                if (result.success) reloadCurrentPage();
            }).catch(function () {
                alert("처리 중 오류가 발생했습니다.");
            });
        });
    }

    /**
     * openConfirm(title, message, showReason, callback): 범용 확인 모달 열기.
     * showReason true 이면 사유 입력 textarea 를 함께 표시.
     * callback: [확인] 버튼 클릭 시 실행할 함수. confirmCallback 변수에 보관.
     */
    function openConfirm(title, message, showReason, callback) {
        document.getElementById("confirmTitle").textContent   = title;
        document.getElementById("confirmMessage").textContent = message;

        setField("confirmReason", ""); /* 이전에 입력한 사유 초기화 */
        document.getElementById("confirmReasonBox").style.display = showReason ? "block" : "none";

        confirmCallback = callback; /* [확인] 클릭 시 실행할 함수 저장 */
        openModal("confirmModal");
    }


    /* ──────────────────────────────────────────────
       [10] 클릭 이벤트 위임
       page 요소 하나에 리스너를 달고 data-action 값으로 분기.
       이유: 모달 안 동적으로 생성된 버튼에도 이벤트가 바인딩되고,
             버튼마다 addEventListener 를 달지 않아도 됨.
    ────────────────────────────────────────────── */

    page.addEventListener("click", function (e) {

        /* data-modal-close 가 있는 요소 클릭 시 열린 모든 모달 닫기 */
        if (e.target.closest("[data-modal-close]")) {
            closeAllModals();
            return;
        }

        /* data-action 이 있는 가장 가까운 조상 요소를 버튼으로 인식 */
        var btn = e.target.closest("[data-action]");
        if (!btn) return;

        /* is-disabled 클래스 또는 HTML disabled 속성이 있으면 동작하지 않음 */
        if (btn.classList.contains("is-disabled")) return;
        if (btn.disabled) return;

        var action = btn.dataset.action;

        /* ── 탭 전환 ── */
        if (action === "change-tab") changeTab(btn.dataset.tab);

        /* ── 재직 직원 탭 ── */
        if (action === "search-manager")        loadEmployeeList();
        if (action === "reset-manager")         resetManagerFilter();
        if (action === "excel-download")        excelDownload();

        /* ── 요청 탭 ── */
        if (action === "search-request")        loadRequestList();
        if (action === "reset-request")         resetRequestFilter();
        if (action === "open-request-modal")    openRequestInsert();

        /* ── 회원 검색 팝업 ── */
        if (action === "open-member-search") {
            /* 요청 모달 안 검색어를 팝업 입력창으로 복사해 바로 검색 */
            setField("memberModalKeyword", getField("memberSearchKeyword"));
            openModal("memberSearchModal");
            doMemberSearch();
        }
        if (action === "do-member-search") doMemberSearch();
        if (action === "clear-member")     clearSelectedMember();

        /* 검색 결과 항목 클릭 시 회원 선택 */
        if (action === "select-member") {
            showSelectedMember({
                userNo: btn.dataset.userNo,
                userNm: btn.dataset.userNm,
                userId: btn.dataset.userId
            });
            closeModal("memberSearchModal");
        }

        /* ── 재직 직원 그리드 버튼 ── */
        if (action === "manager-detail") {
            /* data-user-no 로 managerRowData 에서 해당 행을 찾아 모달 열기 */
            var detailRow = managerRowData.find(function (r) {
                return String(r.userNo) === String(btn.dataset.userNo);
            });
            if (detailRow) openManagerDetail(detailRow);
        }

        if (action === "manager-edit") {
            var editRow = managerRowData.find(function (r) {
                return String(r.userNo) === String(btn.dataset.userNo);
            });
            if (editRow) openManagerEdit(editRow);
        }

        if (action === "submit-manager-update") submitManagerUpdate();

        /* ── 요청 그리드 버튼 ── */
        if (action === "request-detail") {
            var reqDetailRow = requestRowData.find(function (r) {
                return String(r.rqstNo) === String(btn.dataset.rqstNo);
            });
            if (reqDetailRow) openRequestDetail(reqDetailRow);
        }

        if (action === "request-edit") {
            var reqEditRow = requestRowData.find(function (r) {
                return String(r.rqstNo) === String(btn.dataset.rqstNo);
            });
            if (!reqEditRow) {
                alert("요청 정보를 찾을 수 없습니다.");
                return;
            }
            /* 상세 모달의 수정 버튼에도 WAIT 체크 (그리드의 is-disabled 와 이중 방어) */
            if (MngrAccountGrid.normalizeStatus(reqEditRow.rqstSttsCd) !== "WAIT") {
                alert("승인대기 상태의 요청만 수정할 수 있습니다.");
                return;
            }
            openRequestEdit(reqEditRow);
        }

        if (action === "request-cancel")        cancelRequest(btn.dataset.rqstNo);
        if (action === "submit-request-insert") submitRequestInsert();
        if (action === "submit-request-update") submitRequestUpdate();
    });


    /* ──────────────────────────────────────────────
       [11] 확인 모달 [확인] 버튼 이벤트
    ────────────────────────────────────────────── */

    var confirmActionBtn = document.getElementById("confirmActionBtn");
    if (confirmActionBtn) {
        confirmActionBtn.addEventListener("click", function () {
            closeModal("confirmModal");
            /* openConfirm() 에서 저장해둔 콜백 실행 */
            if (typeof confirmCallback === "function") {
                confirmCallback();
            }
        });
    }


    /* ──────────────────────────────────────────────
       [12] 초기 실행
       createGrids → loadEmployeeList → loadRequestList 순서가 중요함.
       그리드 DOM 이 먼저 준비된 후에 데이터를 넣어야 AG Grid 가 정상 동작.
    ────────────────────────────────────────────── */

    createGrids();       /* 그리드 틀(컬럼 정의) 먼저 생성 */
    loadEmployeeList();  /* 재직 직원 데이터 조회 후 그리드에 반영 */
    loadRequestList();   /* 요청 목록 데이터 조회 후 그리드에 반영 */
}