/**
 * ============================================================
 * mngr-account.js
 * 직원 계정 관리 화면 동작 스크립트
 * ============================================================
 */

// HTML 문서가 완전히 로드되었을 때 실행
document.addEventListener("DOMContentLoaded", function () {
    // 페이지 초기화 함수 호출
    initMngrAccountPage();
});

/**
 * 페이지의 모든 기능을 초기화하고 이벤트를 바인딩하는 메인 함수
 */
function initMngrAccountPage() {

    /* [1] 화면 유효성 검사 및 기본 설정 */

    // 현재 페이지에 'mngrAccountPage'라는 ID를 가진 요소가 있는지 확인
    var page = document.getElementById("mngrAccountPage");
    // 해당 요소가 없으면 이 스크립트가 실행될 페이지가 아니므로 즉시 종료
    if (!page) return;

    // JSP 서버에서 전달한 설정 객체(window.mngrAccountConfig)를 가져옴 (없으면 빈 객체)
    var config = window.mngrAccountConfig || {};

    // 프로젝트의 기본 경로 (API 호출 시 사용)
    var contextPath = config.contextPath || "";
    // 현재 관리 중인 사무소 번호
    var mgmtOfcNo   = config.mgmtOfcNo || "";
    // 관리사무소 명칭 (모달 표시용)
    var mgmtOfcNm   = config.mgmtOfcNm || "";
    // 아파트 단지 명칭 (모달 표시용)
    var aptCmplexNm = config.aptCmplexNm || "";
    // 현재 로그인한 관리자의 이름
    var loginUserNm = config.loginUserNm || "";
    // 관리자 여부 확인 (true일 경우 쓰기 권한 제한 등에 사용)
    var isAdmin     = config.isAdmin === true;

    /* [2] 데이터 및 그리드 요소 정의 */

    // '재직 직원' 그리드에 표시될 데이터 배열
    var managerRowData = [];
    // '계정 생성 요청' 그리드에 표시될 데이터 배열
    var requestRowData = [];

    // '재직 직원' AG Grid가 그려질 HTML 엘리먼트
    var managerGridEl = document.getElementById("managerGrid");
    // '계정 생성 요청' AG Grid가 그려질 HTML 엘리먼트
    var requestGridEl = document.getElementById("requestGrid");

    // 확인(Confirm) 모달에서 '승인' 버튼을 눌렀을 때 실행될 함수를 임시 저장하는 변수
    var confirmCallback = null;

    /* [3] 화면 초기 텍스트 세팅 */

    // 요청 폼의 숨겨진 필드에 사무소 번호 세팅
    setField("rqstMgmtOfcNoHidden", mgmtOfcNo);
    // 화면상에 사무소 명칭 표시 (명칭 없으면 번호 표시)
    setField("requestMgmtOfcNoText", mgmtOfcNm || mgmtOfcNo);
    // 화면상에 단지명 표시
    setField("requestAptCmplexNmText", aptCmplexNm);
    // 등록자 항목에 로그인 사용자명 표시
    setField("requestLoginUserNmText", loginUserNm);

    /* [4] 유틸리티 내부 함수 (helper functions) */

    // null 또는 undefined 값을 빈 문자열로 변환
    function safe(value) {
        return emptyIfNull(value);
    }

    // HTML 문자열 조합 시 특수문자로 인한 태그 깨짐을 방지
    function escapeHtml(value) {
        return String(value == null ? "" : value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    // 요청 상태 코드를 대문자로 통일
    function normalizeStatus(code) {
        return MngrAccountGrid.normalizeStatus(code);
    }

    // 직무 코드를 한글명으로 변환
    function dutyText(code) {
        return MngrAccountGrid.dutyText(code);
    }

    // 요청 상태 코드를 한글명으로 변환
    function sttsText(code) {
        return MngrAccountGrid.sttsText(code);
    }

    // 날짜 값을 yyyy.MM.dd 형태로 변환
    function formatDate(value) {
        if (!value) return "-";
        var str = String(value);
        return str.length >= 10 && str.indexOf("-") > -1
            ? str.slice(0, 10).replace(/-/g, ".")
            : str;
    }

    // 지정한 id를 가진 input 요소의 값을 가져와 양끝 공백 제거
    function getField(id) {
        var el = document.getElementById(id);
        return el ? el.value.trim() : "";
    }

    // 지정한 ID를 가진 요소에 안전하게 값을 입력
    function setField(id, value) {
        var el = document.getElementById(id);
        if (el) el.value = safe(value);
    }

    // 지정한 ID를 가진 요소의 텍스트를 안전하게 변경
    function setText(id, value) {
        var el = document.getElementById(id);
        if (el) el.textContent = safe(value);
    }

    // 현재 페이지를 새로고침하여 최신 상태 반영
    function reloadCurrentPage(tab) {
        var url = contextPath + "/manager/employee/account/" + mgmtOfcNo;
        // 관리사무소 번호는 경로에 그대로 두고, 요청 처리 후에만 탭 상태를 쿼리스트링으로 유지한다.
        if (tab) url += "?tab=" + encodeURIComponent(tab);
        location.href = url;
    }

    // ADMIN 계정일 경우 수정을 막기 위한 체크 함수
    function blockAdminWrite() {
        return isAdmin;
    }

    // 각 목록 헤더의 건수 표시를 데이터 기준으로 갱신
    function updateStats() {
        var managerTotal = managerRowData.length;
        var managerActive = managerRowData.filter(function (row) {
            return row.userYn === "Y";
        }).length;
        var managerInactive = managerRowData.filter(function (row) {
            return row.userYn === "N";
        }).length;

        var requestTotal = requestRowData.length;
        var requestWait = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "WAIT";
        }).length;
        var requestOk = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "OK";
        }).length;
        var requestReject = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "RJCT";
        }).length;
        var requestCancel = requestRowData.filter(function (row) {
            return normalizeStatus(row.rqstSttsCd) === "CNL";
        }).length;

        setText("managerTotalCount", managerTotal + "건");
        setText("managerStatusCount", "활성 " + managerActive + " · 비활성 " + managerInactive);
        setText("managerChipTotal", managerTotal);
        setText("managerChipActive", managerActive);
        setText("managerChipInactive", managerInactive);
        setText("requestTotalCount", requestTotal + "건");
        setText(
            "requestStatusCount",
            "대기 " + requestWait + " · 승인 " + requestOk + " · 반려 " + requestReject + " · 취소 " + requestCancel
        );
        setText("requestChipTotal", requestTotal);
        setText("requestChipWait", requestWait);
        setText("requestChipOk", requestOk);
        setText("requestChipReject", requestReject);
        setText("requestChipCancel", requestCancel);
    }

    /* [5] 데이터 로드 및 그리드 생성 함수 */

    // 서버에서 재직 직원 목록을 가져옴
    function loadEmployeeList() {
        // 검색어와 직무 필터 값 가져오기
        var keyword = getField("managerKeyword");
        var duty = getField("managerDutyFilter");

        // API URL 조립 (인코딩 처리 포함)
        var url = contextPath + "/manager/employee/list/" + mgmtOfcNo
            + "?keyword=" + encodeURIComponent(keyword)
            + "&mngrDutyCd=" + encodeURIComponent(duty);

        // 비동기 GET 요청 실행
        getJson(url).then(function (data) {
            // 받아온 리스트 저장 (없으면 빈 배열)
            managerRowData = data.list || [];
            // 그리드 영역에 데이터 전달 및 렌더링
            MngrAccountGrid.setRows(managerGridEl, managerRowData);
            // 상단 통계 숫자 업데이트
            updateStats();
        }).catch(function () {
            alert("재직 직원 목록 조회 중 오류가 발생했습니다.");
        });
    }

    // 서버에서 계정 생성 요청 목록을 가져옴
    function loadRequestList() {
        // 검색어, 직무, 상태 필터 값 가져오기
        var keyword = getField("requestKeyword");
        var duty = getField("requestDutyFilter");
        var status = getField("requestStatusFilter");
        var dateType = getField("requestDateType");
        var searchDate = getField("requestSearchDate");

        // API URL 조립
        var url = contextPath + "/manager/employee/request/list/" + mgmtOfcNo
            + "?keyword=" + encodeURIComponent(keyword)
            + "&rqstDutyCd=" + encodeURIComponent(duty)
            + "&rqstSttsCd=" + encodeURIComponent(status)
            + "&dateType=" + encodeURIComponent(dateType)
            + "&searchDate=" + encodeURIComponent(searchDate);

        // 비동기 GET 요청 실행
        getJson(url).then(function (data) {
            requestRowData = data.list || [];
            // 그리드 영역에 데이터 전달 및 렌더링
            MngrAccountGrid.setRows(requestGridEl, requestRowData);
            updateStats();
        }).catch(function () {
            alert("직원 계정 요청 목록 조회 중 오류가 발생했습니다.");
        });
    }

    // 초기 AG Grid 객체들을 생성 (컬럼 정의 등 초기 설정 포함)
    function createGrids() {
        MngrAccountGrid.createGrids({
            managerGridEl: managerGridEl,
            requestGridEl: requestGridEl,
            managerRowData: managerRowData,
            requestRowData: requestRowData,
            isAdmin: isAdmin
        });
    }

    /* [6] 화면 UI 제어 함수 (모달, 탭) */

    // 열려 있는 모든 모달창을 찾아 닫음
    function closeAllModals() {
        page.querySelectorAll(".modal-overlay.open").forEach(function (modal) {
            closeModal(modal.id);
        });
    }

    // 특정 폼 안의 모든 입력 필드(input, select, textarea)를 활성화/비활성화
    function setFormDisabled(formId, disabled) {
        var form = document.getElementById(formId);
        if (!form) return;

        form.querySelectorAll("input:not([type=hidden]), select, textarea")
            .forEach(function (el) {
                el.disabled = disabled;
            });
    }

    // 탭 버튼 클릭 시 '재직 직원' ↔ '요청 내역' 화면 전환
    function changeTab(tab) {
        page.querySelectorAll(".tab-btn").forEach(function (btn) {
            btn.classList.toggle("active", btn.dataset.tab === tab);
        });

        document.getElementById("managerTabPanel").classList.toggle("active", tab === "manager");
        document.getElementById("requestTabPanel").classList.toggle("active", tab === "request");
    }

    // 새로고침 후 요청 탭 유지용: ?tab=request일 때만 요청 탭을 기본으로 연다.
    function applyInitialTab() {
        var tab = new URLSearchParams(location.search).get("tab");
        changeTab(tab === "request" ? "request" : "manager");
    }

    // 재직 직원 필터를 초기화하고 목록 다시 불러오기
    function resetManagerFilter() {
        setField("managerKeyword", ""); // 검색어 비우기
        var dutyFilter = document.getElementById("managerDutyFilter");
        if (dutyFilter) dutyFilter.value = ""; // 직무 선택 초기화
        loadEmployeeList(); // 재조회
    }

    // 요청 내역 필터를 초기화하고 목록 다시 불러오기
    function resetRequestFilter() {
        setField("requestKeyword", "");
        var dutyFilter = document.getElementById("requestDutyFilter");
        var statusFilter = document.getElementById("requestStatusFilter");
        var dateTypeFilter = document.getElementById("requestDateType");
        if (dutyFilter) dutyFilter.value = "";
        if (statusFilter) statusFilter.value = "";
        if (dateTypeFilter) dateTypeFilter.value = "RQST";
        setField("requestSearchDate", "");
        loadRequestList();
    }

    // SheetJS(XLSX) 라이브러리를 이용해 재직 직원 목록을 엑셀로 저장
    function excelDownload() {
        if (typeof XLSX === "undefined") {
            alert("엑셀 다운로드 라이브러리가 로드되지 않았습니다.");
            return;
        }

        // 그리드 데이터를 엑셀용 객체 배열로 변환
        var rows = managerRowData.map(function (row) {
            return {
                "직원명": safe(row.userNm),
                "아이디": safe(row.userId),
                "직무": dutyText(row.mngrDutyCd),
                "연락처": safe(row.telno),
                "이메일": safe(row.userEml),
                "상태": row.userYn === "Y" ? "활성" : "비활성"
            };
        });

        var ws = XLSX.utils.json_to_sheet(rows); // 시트 생성
        var wb = XLSX.utils.book_new();         // 워크북 생성
        XLSX.utils.book_append_sheet(wb, ws, "재직직원"); // 시트 추가
        XLSX.writeFile(wb, "재직직원목록.xlsx"); // 파일 다운로드 실행
    }

    /* [7] 상세 조회 및 수정 모달 관련 기능 */

    // 재직 직원 상세 정보 모달 열기
    function openManagerDetail(row) {
        document.getElementById("accountModalTitle").textContent = "재직 직원 상세";

        fillManagerForm(row); // 폼에 데이터 채우기
        setFormDisabled("accountForm", true); // 모든 필드 읽기 전용 설정

        // 하단 버튼 구성 (관리자 아니면 '수정' 버튼 추가)
        var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';
        if (!isAdmin) {
            footer += '<button type="button" class="btn btn-primary" data-action="manager-edit" data-row-key="'
                + escapeHtml(row.userNo) + '">수정</button>';
        }
        document.getElementById("accountModalFooter").innerHTML = footer;

        openModal("accountModal");
    }

    // 재직 직원 직무 수정 모달 열기
    function openManagerEdit(row) {
        if (blockAdminWrite()) return;

        document.getElementById("accountModalTitle").textContent = "재직 직원 직무 수정";

        fillManagerForm(row);
        setFormDisabled("accountForm", true); // 기본은 비활성화하되

        var duty = document.getElementById("accountDutyCd");
        if (duty) duty.disabled = false; // '직무' 필드만 선택 가능하게 변경

        // 하단 버튼을 '수정 저장'으로 세팅
        document.getElementById("accountModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-manager-update">수정 저장</button>';

        openModal("accountModal");
    }

    // 직원 정보를 팝업 내 폼 요소들에 매핑
    function fillManagerForm(row) {
        setField("accountUserNo", row.userNo);
        setField("accountMgmtOfcNo", row.mgmtOfcNo);
        setField("accountUserYn", row.userYn);
        setField("accountUserNm", row.userNm);
        setField("accountUserId", row.userId);
        setField("accountTelno", row.telno);
        setField("accountUserEml", row.userEml);
        setField("accountBirthDate", row.birthDate);

        var duty = document.getElementById("accountDutyCd");
        if (duty) duty.value = row.mngrDutyCd || "";
    }

    // 계정 생성 요청 폼의 모든 입력값 초기화
    function clearRequestForm() {
        var form = document.getElementById("requestForm");
        if (form) {
            form.reset();
            // 등록/상세/수정 모드를 같은 폼에서 재사용하므로 이전 모드 표시를 초기화한다.
            form.classList.remove("readonly-mode", "request-edit-mode");
        }

        setField("rqstNo", "");
        setField("rqstUserNo", "");
        setField("rqstMgmtOfcNoHidden", mgmtOfcNo);
        setField("requestMgmtOfcNoText", mgmtOfcNm || mgmtOfcNo);
        setField("requestAptCmplexNmText", aptCmplexNm);
        setField("requestLoginUserNmText", loginUserNm);

        clearSelectedMember(); // 검색해서 선택했던 회원 정보도 지움

        // 상태 표시 영역 및 반려 사유 영역 숨김
        document.getElementById("rqstStatusSection").style.display = "none";
        document.getElementById("rqstRjctBox").style.display = "none";
        var waitBadge = document.getElementById("rqstWaitBadge");
        if (waitBadge) waitBadge.classList.remove("visible");
    }

    // 신규 계정 생성 요청 모달 열기
    function openRequestInsert() {
        if (blockAdminWrite()) return;

        clearRequestForm(); // 빈 폼 준비

        // 등록 모드는 회원 검색으로 대상 회원을 선택해야 하므로 상세/수정 전용 스타일을 제거한다.
        document.getElementById("requestForm").classList.remove("readonly-mode", "request-edit-mode");

        document.getElementById("requestModalTitle").textContent = "계정 생성 요청 등록";

        setFormDisabled("requestForm", false); // 입력 가능하게 설정

        // 이름과 ID는 직접 입력이 아니라 '회원 검색'을 통해서만 입력되도록 막음
        document.getElementById("rqstMngrNm").readOnly = true;
        document.getElementById("rqstLoginId").readOnly = true;

        document.getElementById("requestModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-request-insert">등록 요청</button>';

        openModal("requestModal");
    }

    // 계정 요청 상세 정보 모달 열기
    function openRequestDetail(row) {
        fillRequestForm(row);

        document.getElementById("requestModalTitle").textContent = "계정 생성 요청 상세";
        document.getElementById("rqstStatusSection").style.display = ""; // 상태 영역 표시

        setField("rqstDt", formatDate(row.rqstDt)); // 요청 일자
        setField("rqstSttsCdText", sttsText(row.rqstSttsCd)); // 상태명(한글)
        var waitBadge = document.getElementById("rqstWaitBadge");
        if (waitBadge) waitBadge.classList.toggle("visible", !isAdmin && normalizeStatus(row.rqstSttsCd) === "WAIT");

        // 만약 거절(반려) 상태라면 반려 사유 박스를 보여줌
        if (normalizeStatus(row.rqstSttsCd) === "RJCT") {
            document.getElementById("rqstRjctBox").style.display = "";
            setField("rqstRjctRsnCn", row.rjctRsnCn);
        }

        setFormDisabled("requestForm", true); // 상세 정보는 기본적으로 수정 불가

        // 상세 모드는 조회 화면처럼 보이도록 전용 스타일 적용
        document.getElementById("requestForm").classList.remove("request-edit-mode");
        document.getElementById("requestForm").classList.add("readonly-mode");

        var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';

        // 관리자가 아니고 상태가 '대기' 중일 때만 수정 버튼 노출
        if (!isAdmin && normalizeStatus(row.rqstSttsCd) === "WAIT") {
            footer += '<button type="button" class="btn btn-primary" data-action="request-edit" data-row-key="'
                + escapeHtml(row.rqstNo) + '">수정</button>';
        }

        document.getElementById("requestModalFooter").innerHTML = footer;

        openModal("requestModal");
    }

    // 계정 생성 요청 수정 모달 열기
    function openRequestEdit(row) {
        if (blockAdminWrite()) return;

        fillRequestForm(row);

        // 수정 모드는 상세 화면과 동일하게 대상 회원을 고정하고, 직무/비고만 수정 가능하게 연다.
        document.getElementById("requestForm").classList.add("readonly-mode", "request-edit-mode");

        document.getElementById("requestModalTitle").textContent = "계정 생성 요청 수정";
        document.getElementById("rqstStatusSection").style.display = "";

        setField("rqstDt", formatDate(row.rqstDt));
        setField("rqstSttsCdText", sttsText(row.rqstSttsCd));
        var waitBadge = document.getElementById("rqstWaitBadge");
        if (waitBadge) waitBadge.classList.toggle("visible", normalizeStatus(row.rqstSttsCd) === "WAIT");

        setFormDisabled("requestForm", true); // 전체는 막고

        // 직무와 비고만 수정 가능하게 열어줌
        var duty = document.getElementById("rqstDutyCd");
        var rmrk = document.getElementById("rqstRmrkCn");

        if (duty) duty.disabled = false;
        if (rmrk) rmrk.disabled = false;

        document.getElementById("requestModalFooter").innerHTML =
            '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
            + '<button type="button" class="btn btn-primary" data-action="submit-request-update">수정 저장</button>';

        openModal("requestModal");
    }

    // 요청 데이터를 요청 폼에 채우기
    function fillRequestForm(row) {
        clearRequestForm();

        setField("rqstNo", row.rqstNo);
        setField("rqstUserNo", row.userNo);
        setField("rqstMngrNm", row.rqstMngrNm);
        setField("rqstLoginId", row.rqstLoginId);
        setField("rqstRmrkCn", row.rmrkCn);
        setField("rqstMgmtOfcNoHidden", row.mgmtOfcNo || mgmtOfcNo);

        var duty = document.getElementById("rqstDutyCd");
        if (duty) duty.value = row.rqstDutyCd || "";

        // UI상 선택된 회원 정보 표시
        showSelectedMember({
            userNo: row.userNo,
            userNm: row.rqstMngrNm,
            userId: row.rqstLoginId
        });
    }

    /* [8] 회원 검색 및 선택 로직 */

    // 회원 검색 창에서 특정 회원을 골랐을 때 화면에 표시
    function showSelectedMember(member) {
        // 아바타 첫 글자 표시
        document.getElementById("selMemberAvatar").textContent = member.userNm ? member.userNm.charAt(0) : "-";
        // 이름 및 아이디 텍스트 세팅
        document.getElementById("selMemberName").textContent = safe(member.userNm);
        document.getElementById("selMemberSub").textContent = safe(member.userId);
        // 선택된 회원 정보 영역 표시
        document.getElementById("rqstSelectedMember").classList.add("visible");

        // 폼 내부 실제 값 세팅
        setField("rqstMngrNm", member.userNm);
        setField("rqstLoginId", member.userId);
        setField("rqstUserNo", member.userNo);
    }

    // 선택된 회원 정보 초기화
    function clearSelectedMember() {
        document.getElementById("rqstSelectedMember").classList.remove("visible");
        setField("rqstMngrNm", "");
        setField("rqstLoginId", "");
        setField("rqstUserNo", "");
    }

    // 회원 찾기 모달에서 서버 API를 통해 회원 검색
    function doMemberSearch() {
        var keyword = getField("memberModalKeyword");
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

            // 검색 결과를 HTML 문자열로 생성하여 삽입
            resultBox.innerHTML = list.map(function (member) {
                var rejectedBadge = normalizeStatus(member.rqstSttsCd) === "RJCT"
                    ? '<span class="member-rjct-badge">반려 이력</span>'
                    : '';

                return '<div class="member-item" data-action="select-member"'
                    + ' data-user-no="' + escapeHtml(member.userNo) + '"'
                    + ' data-user-nm="' + escapeHtml(member.userNm) + '"'
                    + ' data-user-id="' + escapeHtml(member.userId) + '">'
                    + '<div class="m-avatar">' + escapeHtml(member.userNm ? member.userNm.charAt(0) : "-") + '</div>'
                    + '<div>'
                    + '<div class="member-name-row"><span class="m-name">' + escapeHtml(member.userNm) + '</span>' + rejectedBadge + '</div>'
                    + '<div class="m-sub">' + escapeHtml(member.userId) + ' · ' + escapeHtml(member.userTelno) + '</div>'
                    + '</div></div>';
            }).join("");
        }).catch(function () {
            resultBox.innerHTML = '<div class="member-empty">검색 중 오류가 발생했습니다.</div>';
        });
    }

    /* [9] 서버 전송(저장) 처리 */

    // 직원 직무 수정 내용 저장
    function submitManagerUpdate() {
        if (blockAdminWrite()) return;

        if (!getField("accountDutyCd")) {
            alert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/duty/update/" + mgmtOfcNo, {
            userNo: getField("accountUserNo"),
            mgmtOfcNo: mgmtOfcNo,
            mngrDutyCd: getField("accountDutyCd")
        }).then(function (result) {
            alert(result.message || "처리되었습니다.");
            if (result.success) reloadCurrentPage();
        }).catch(function () {
            alert("처리 중 오류가 발생했습니다.");
        });
    }

    // 신규 계정 생성 요청 저장
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
            rqstLoginId: getField("rqstLoginId"),
            rqstMngrNm: getField("rqstMngrNm"),
            rqstDutyCd: getField("rqstDutyCd"),
            rmrkCn: getField("rqstRmrkCn")
        }).then(function (result) {
            alert(result.message || "처리되었습니다.");
            if (result.success) reloadCurrentPage("request");
        }).catch(function () {
            alert("처리 중 오류가 발생했습니다.");
        });
    }

    // 기존 요청 수정 저장
    function submitRequestUpdate() {
        if (blockAdminWrite()) return;

        if (!getField("rqstDutyCd")) {
            alert("직무를 선택하세요.");
            return;
        }

        postJson(contextPath + "/manager/employee/request/update/" + mgmtOfcNo, {
            rqstNo: getField("rqstNo"),
            rqstDutyCd: getField("rqstDutyCd"),
            rmrkCn: getField("rqstRmrkCn")
        }).then(function (result) {
            alert(result.message || "처리되었습니다.");
            if (result.success) reloadCurrentPage("request");
        }).catch(function () {
            alert("처리 중 오류가 발생했습니다.");
        });
    }

    // 요청 취소 처리 (컨펌 모달 후 실행)
    function cancelRequest(rqstNo) {
        if (blockAdminWrite()) return;

        // 목록에서 대상 찾기
        var row = requestRowData.find(function (item) {
            return String(item.rqstNo) === String(rqstNo);
        });

        if (!row) {
            alert("요청 정보를 찾을 수 없습니다.");
            return;
        }

        // 대기 상태가 아니면 취소 불가능
        if (normalizeStatus(row.rqstSttsCd) !== "WAIT") {
            alert("승인대기 상태의 요청만 취소할 수 있습니다.");
            return;
        }

        // 공통 컨펌 모달 열고 확인 시 API 호출
        openConfirm("요청 취소", "선택한 계정 생성 요청을 취소하시겠습니까?", true, function () {
            postJson(contextPath + "/manager/employee/request/cancel/" + mgmtOfcNo, {
                rqstNo: rqstNo,
                rmrkCn: getField("confirmReason")
            }).then(function (result) {
                alert(result.message || "처리되었습니다.");
                if (result.success) reloadCurrentPage("request");
            }).catch(function () {
                alert("처리 중 오류가 발생했습니다.");
            });
        });
    }

    // 공통 확인(Confirm) 모달 호출 함수
    function openConfirm(title, message, showReason, callback) {
        document.getElementById("confirmTitle").textContent = title;
        document.getElementById("confirmMessage").textContent = message;

        setField("confirmReason", "");
        // 사유 입력창이 필요한 경우에만 노출
        document.getElementById("confirmReasonBox").style.display = showReason ? "block" : "none";

        confirmCallback = callback; // 실행할 함수를 변수에 저장해둠

        openModal("confirmModal");
    }

    /* [10] 이벤트 리스너 - 클릭 이벤트 위임 */

    // 페이지 내의 클릭 발생하는 모든 요소를 감시
    page.addEventListener("click", function (e) {
        // [닫기] 버튼 클릭 시 모든 모달 종료
        if (e.target.closest("[data-modal-close]")) {
            closeAllModals();
            return;
        }

        // data-action 속성이 있는 요소가 눌렸는지 확인
        var btn = e.target.closest("[data-action]");
        if (!btn) return;

        // HTML disabled 속성이 있는 버튼이면 무시
        // is-disabled 클래스는 흐리게 보이기 위한 표시용이므로 여기서 막지 않음
        if (btn.disabled) return;

        var action = btn.dataset.action;

        /* 액션 종류에 따른 분기 처리 */
        if (action === "change-tab") changeTab(btn.dataset.tab);       // 탭 전환
        if (action === "search-manager") loadEmployeeList();           // 직원 조회
        if (action === "reset-manager") resetManagerFilter();         // 직원 필터 초기화
        if (action === "search-request") loadRequestList();            // 요청 조회
        if (action === "reset-request") resetRequestFilter();         // 요청 필터 초기화
        if (action === "excel-download") excelDownload();              // 엑셀 다운로드

        if (action === "open-request-modal") openRequestInsert();      // 등록 모달 열기

        if (action === "open-member-search") {                         // 회원 검색 팝업 열기
            setField("memberModalKeyword", getField("memberSearchKeyword"));
            openModal("memberSearchModal");
            doMemberSearch();
        }

        if (action === "do-member-search") doMemberSearch();           // 실제 검색 실행
        if (action === "clear-member") clearSelectedMember();          // 선택된 회원 취소

        if (action === "select-member") {                              // 검색 결과에서 회원 선택
            showSelectedMember({
                userNo: btn.dataset.userNo,
                userNm: btn.dataset.userNm,
                userId: btn.dataset.userId
            });
            closeModal("memberSearchModal");
        }

        if (action === "manager-detail") {                             // 직원 상세 보기
            var managerDetailRow = managerRowData.find(function (row) {
                return String(row.userNo) === String(btn.dataset.rowKey);
            });
            if (managerDetailRow) openManagerDetail(managerDetailRow);
        }

        if (action === "manager-edit") {                               // 직원 수정 하기
            var managerEditRow = managerRowData.find(function (row) {
                return String(row.userNo) === String(btn.dataset.rowKey);
            });
            if (managerEditRow) openManagerEdit(managerEditRow);
        }

        if (action === "submit-manager-update") submitManagerUpdate(); // 직원 수정 저장

        if (action === "request-detail") {                             // 요청 상세 보기
            var requestDetailRow = requestRowData.find(function (row) {
                return String(row.rqstNo) === String(btn.dataset.rowKey);
            });
            if (requestDetailRow) openRequestDetail(requestDetailRow);
        }

        if (action === "request-edit") {                               // 요청 수정 하기
            var requestEditRow = requestRowData.find(function (row) {
                return String(row.rqstNo) === String(btn.dataset.rowKey);
            });
            if (!requestEditRow) {
                alert("요청 정보를 찾을 수 없습니다.");
                return;
            }
            if (normalizeStatus(requestEditRow.rqstSttsCd) !== "WAIT") {
                alert("승인대기 상태의 요청만 수정할 수 있습니다.");
                return;
            }
            openRequestEdit(requestEditRow);
        }

        if (action === "request-cancel") cancelRequest(btn.dataset.rowKey); // 요청 취소 실행
        if (action === "submit-request-insert") submitRequestInsert();       // 요청 등록 저장
        if (action === "submit-request-update") submitRequestUpdate();       // 요청 수정 저장
    });

    /* [11] 컨펌 모달 최종 확인 버튼 이벤트 */
    var confirmActionBtn = document.getElementById("confirmActionBtn");
    if (confirmActionBtn) {
        confirmActionBtn.addEventListener("click", function () {
            closeModal("confirmModal");
            // 저장해두었던 콜백 함수가 있다면 실행
            if (typeof confirmCallback === "function") {
                confirmCallback();
            }
        });
    }

    /* [12] 초기 실행 */
    createGrids();      // 그리드 틀 생성
    applyInitialTab();  // URL의 tab 파라미터에 맞춰 최초 활성 탭 결정
    loadEmployeeList(); // 직원 데이터 조회
    loadRequestList();  // 요청 데이터 조회
}
