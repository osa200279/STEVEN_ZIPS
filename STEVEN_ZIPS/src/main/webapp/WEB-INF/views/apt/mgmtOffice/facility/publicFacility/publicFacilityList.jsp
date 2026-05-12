<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공용시설 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">

    <style>
        #publicFacilityPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f3f5f3; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #publicFacilityPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityPage .page-title-block p { color:var(--text-sec); font-size:12px; }
        #publicFacilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; background:#fff; }
        #publicFacilityPage .panel + .panel { margin-top:14px; }
        #publicFacilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityPage .btn { border-radius:4px; min-height:32px; font-size:12px; padding:0 12px; }
        #publicFacilityPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }

        /* 요약 칩 */
        #publicFacilityPage .summary-strip { display:flex; align-items:center; justify-content:space-between; padding:10px 16px; background:var(--surface-sub); border-bottom:1px solid var(--line); }
        #publicFacilityPage .summary-chips { display:flex; gap:6px; flex-wrap:wrap; }
        #publicFacilityPage .summary-chip { padding:3px 10px; border-radius:20px; border:1px solid var(--line); font-size:12px; color:var(--text-sec); background:var(--surface); }
        #publicFacilityPage .summary-chip strong { color:var(--accent); font-weight:800; margin-left:4px; }
        #publicFacilityPage .summary-note { font-size:11px; color:var(--text-ter); }

        /* 목록 헤더 */
        #publicFacilityPage .grid-summary { display:flex; align-items:center; justify-content:space-between; padding:8px 16px; border-bottom:1px solid var(--line); }
        #publicFacilityPage .grid-summary-left { display:flex; align-items:center; gap:8px; font-size:12px; color:var(--text-sec); }
        #publicFacilityPage .grid-summary-left strong { font-size:13px; color:var(--text-pri); font-weight:700; }
        #publicFacilityPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; }

        /* AG Grid */
        #publicFacilityPage .manager-grid-wrap { padding:0; }
        #publicFacilityGrid { width:100%; height:548px; }
        #publicFacilityGrid .ag-header-cell-label { justify-content:center; }
        #publicFacilityGrid .ag-cell { display:flex; align-items:center; justify-content:center; font-size:12px; }
        #publicFacilityGrid .cell-left { justify-content:flex-start; }
        #publicFacilityGrid .cell-right { justify-content:flex-end; }
        #publicFacilityGrid .cell-mono { font-family:'SF Mono','Consolas',monospace; color:var(--text-ter); }
        #publicFacilityGrid .grid-actions { display:inline-flex; align-items:center; justify-content:center; gap:5px; width:100%; }

        /* 배지 */
        #publicFacilityPage .badge { padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; }
        #publicFacilityPage .badge-green { background:#e8f0ea; color:#1f4027; border:1px solid #b7d4bb; }
        #publicFacilityPage .badge-yellow { background:#fef3c7; color:#713f12; border:1px solid #fde68a; }
        #publicFacilityPage .badge-red { background:#fee2e2; color:#7f1d1d; border:1px solid #fca5a5; }
        #publicFacilityPage .badge-gray { background:#f1f3f1; color:#4a5c4e; border:1px solid var(--line); }
        #publicFacilityPage .badge-blue { background:#dbeafe; color:#1e3a5f; border:1px solid #93c5fd; }

        /* 안내바 */
        #publicFacilityPage .info-line { display:flex; align-items:center; gap:8px; padding:10px 16px; border-top:1px solid var(--line); background:var(--surface-sub); font-size:12px; color:var(--text-sec); }
        #publicFacilityPage .info-line .material-symbols-rounded { font-size:15px; color:var(--accent); flex-shrink:0; }
    </style>

    <script>
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}"
        };
    </script>

    <script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
</head>

<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="publicFacilityPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>공용시설 관리</h2>
                        <p>단지 내 공용시설 정보·사진·자원·예약이력을 관리합니다.</p>
                    </div>
                    <div class="page-actions">
                        <sec:authorize access="!hasRole('ADMIN')">
                            <button type="button" class="btn btn-primary" id="registerBtn">
                                <span class="material-symbols-rounded">add</span>공용시설 등록
                            </button>
                        </sec:authorize>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="panel-title">
                            <span class="material-symbols-rounded">meeting_room</span>공용시설 목록
                        </div>
                    </div>

                    <%-- 요약 칩 --%>
                    <div class="summary-strip">
                        <div class="summary-chips">
                            <span class="summary-chip">전체 <strong id="chipTotal">0</strong></span>
                            <span class="summary-chip">예약가능 <strong id="chipRsv">0</strong></span>
                            <span class="summary-chip">사용중지 <strong id="chipClose">0</strong></span>
                        </div>
                        <span class="summary-note">각 열의 필터 버튼으로 공용시설을 조회할 수 있습니다.</span>
                    </div>

                    <%-- 목록 헤더 --%>
                    <div class="grid-summary">
                        <div class="grid-summary-left">
                            <strong>공용시설 현황</strong>
                            <span class="list-count" id="facilityCount">0건</span>
                        </div>
                    </div>

                    <%-- AG Grid 목록 --%>
                    <div class="manager-grid-wrap">
                        <div id="publicFacilityGrid" class="ag-theme-alpine manager-ag-grid grid-size-10"></div>
                    </div>

                    <div class="info-line">
                        <span class="material-symbols-rounded">info</span>
                        예약·운영시간·자원 등 상세 운영정보는 수정 화면에서 관리합니다.
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    (function () {
        var config = window.publicFacilityPageConfig || {};             // 페이지 설정값
        var contextPath = config.contextPath || "";                     // context path
        var mgmtOfcNo = config.mgmtOfcNo || "";                         // 관리사무소 번호
        var publicFacilityGridApi = null;                               // AG Grid API
        var publicFacilityRowData = [];                                 // 공용시설 목록 데이터

        var STTS_TEXT = { OPEN:"사용가능", USE:"사용중", REPAIR:"점검중", CLOSE:"사용중지" };       // 상태명 매핑
        var STTS_BADGE = { OPEN:"badge-green", USE:"badge-blue", REPAIR:"badge-yellow", CLOSE:"badge-red" }; // 상태 배지 매핑

        function el(id) { return document.getElementById(id); }          // 요소 조회
        function alertMessage(msg) { if (typeof showAlert === "function") showAlert(msg); else alert(msg); } // 알림 처리

        function getCsrfHeaders() {                                      // CSRF 헤더 생성
            var tokenMeta = document.querySelector('meta[name="_csrf"]'); // CSRF 토큰 meta
            var headerMeta = document.querySelector('meta[name="_csrf_header"]'); // CSRF 헤더명 meta
            var headers = {};                                            // 요청 헤더 객체
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content; // CSRF 헤더 추가
            return headers;                                              // 헤더 반환
        }

        async function getJson(url) {                                    // JSON GET 요청
            var response = await fetch(url, { method:"GET", headers:getCsrfHeaders() }); // 목록 조회 요청
            if (response.redirected || response.url.indexOf("/login.do") !== -1) {       // 로그인 만료 확인
                alertMessage("로그인이 필요합니다.");                    // 로그인 안내
                location.href = contextPath + "/login.do";               // 로그인 이동
                throw new Error("login required");                       // 처리 중단
            }
            var data = await response.json();                            // 응답 JSON 변환
            if (!response.ok || data.success === false) throw new Error(data.message || "조회 중 오류가 발생했습니다."); // 오류 처리
            return data;                                                 // 응답 반환
        }

        async function postJson(url, body) {                             // JSON POST 요청
            var headers = getCsrfHeaders();                              // CSRF 헤더 생성
            headers["Content-Type"] = "application/json";                // JSON 요청 타입
            var response = await fetch(url, { method:"POST", headers:headers, body:JSON.stringify(body || {}) }); // POST 요청
            var data = await response.json();                            // 응답 JSON 변환
            if (!response.ok || data.success === false) throw new Error(data.message || "처리 중 오류가 발생했습니다."); // 오류 처리
            return data;                                                 // 응답 반환
        }

        function badge(cls, text) { return '<span class="badge ' + cls + '">' + text + '</span>'; } // 배지 HTML
        function sttsBadge(cd) { return badge(STTS_BADGE[cd] || "badge-gray", STTS_TEXT[cd] || cd || "-"); } // 상태 배지
        function rsvBadge(value) { return value === "Y" ? badge("badge-green", "가능") : badge("badge-gray", "불가"); } // 예약 배지
        function fmtAmt(value) { return Number(value || 0) === 0 ? "무료" : Number(value || 0).toLocaleString() + "원"; } // 금액 표시

        function pageUrl(path) { return contextPath + "/manager/publicFacility/" + path; } // 페이지 URL 생성
        function moveRegister() { location.href = pageUrl("register/" + encodeURIComponent(mgmtOfcNo)); } // 등록 이동
        function moveDetail(cmnFacilityNo) { location.href = pageUrl("detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo)); } // 상세 이동
        function moveUpdate(cmnFacilityNo) { location.href = pageUrl("update-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo)); } // 수정 이동

        function updateChips(list) {                                     // 요약 칩 갱신
            el("chipTotal").textContent = list.length;                   // 전체 건수
            el("chipRsv").textContent = list.filter(function (r) { return r.rsvYn === "Y"; }).length; // 예약가능 건수
            el("chipClose").textContent = list.filter(function (r) { return r.cmnFacilitySttsCd === "CLOSE"; }).length; // 사용중지 건수
            el("facilityCount").textContent = list.length + "건";        // 목록 건수
        }

        function updateFilteredCount() {                                 // 필터 후 건수 갱신
            if (!publicFacilityGridApi) return;                          // Grid API 없으면 중단
            var count = publicFacilityGridApi.getDisplayedRowCount();     // 필터 적용 후 표시 건수
            el("facilityCount").textContent = count + "건";              // 표시 건수 반영
        }

        async function deleteFacility(cmnFacilityNo) {                   // 공용시설 삭제 처리
            if (!confirm("해당 공용시설을 삭제하시겠습니까?\n예약이력이 있는 경우 삭제되지 않습니다.")) return; // 삭제 확인
            try {
                await postJson(contextPath + "/manager/publicFacility/delete/" + encodeURIComponent(mgmtOfcNo), { cmnFacilityNo:cmnFacilityNo }); // 삭제 요청
                alertMessage("삭제되었습니다.");                         // 삭제 완료 안내
                loadList();                                              // 목록 재조회
            } catch (e) {
                console.error(e);                                        // 오류 로그
                alertMessage(e.message || "삭제 중 오류가 발생했습니다."); // 오류 안내
            }
        }

        function createColumnDefs() {                                    // AG Grid 컬럼 정의
            return [
                {
                    headerName:"시설번호",
                    field:"cmnFacilityNo",
                    width:135,
                    minWidth:120,
                    cellClass:"cell-mono",
                    filter:"agTextColumnFilter"
                },
                {
                    headerName:"시설명",
                    field:"cmnFacilityNm",
                    width:180,
                    minWidth:150,
                    cellClass:"cell-left",
                    filter:"agTextColumnFilter"
                },
                {
                    headerName:"동",
                    field:"dongNo",
                    width:95,
                    minWidth:85,
                    cellClass:"cell-mono",
                    filter:"agTextColumnFilter",
                    valueFormatter:function (params) { return params.value || "공용"; }
                },
                {
                    headerName:"상세위치",
                    field:"locCn",
                    width:190,
                    minWidth:150,
                    cellClass:"cell-left",
                    filter:"agTextColumnFilter",
                    valueFormatter:function (params) { return params.value || "—"; }
                },
                {
                    headerName:"예약",
                    field:"rsvYn",
                    width:105,
                    minWidth:95,
                    filter:"agSetColumnFilter",
                    filterParams:{ values:["Y", "N"], valueFormatter:function (params) { return params.value === "Y" ? "예약 가능" : "예약 불가"; } },
                    cellRenderer:function (params) { return rsvBadge(params.value); }
                },
                {
                    headerName:"이용요금",
                    field:"cmnAmt",
                    width:125,
                    minWidth:115,
                    cellClass:"cell-right",
                    filter:"agNumberColumnFilter",
                    valueFormatter:function (params) { return fmtAmt(params.value); }
                },
                {
                    headerName:"운영시간",
                    field:"oprHr",
                    width:145,
                    minWidth:120,
                    cellClass:"cell-left",
                    filter:"agTextColumnFilter",
                    valueFormatter:function (params) { return params.value || "—"; }
                },
                {
                    headerName:"자원수",
                    field:"itemCnt",
                    width:105,
                    minWidth:95,
                    filter:"agNumberColumnFilter",
                    valueFormatter:function (params) { return Number(params.value || 0) + "건"; }
                },
                {
                    headerName:"상태",
                    field:"cmnFacilitySttsCd",
                    width:120,
                    minWidth:105,
                    filter:"agSetColumnFilter",
                    filterParams:{ values:["OPEN", "USE", "REPAIR", "CLOSE"], valueFormatter:function (params) { return STTS_TEXT[params.value] || params.value; } },
                    cellRenderer:function (params) { return sttsBadge(params.value); }
                },
                {
                    headerName:"관리",
                    field:"cmnFacilityNo",
                    width:170,
                    minWidth:160,
                    sortable:false,
                    filter:false,
                    pinned:"right",
                    cellRenderer:function () {
                        return ''
                            + '<div class="grid-actions">'
                            + '  <button type="button" class="btn btn-xs btn-detail" data-action="detail">상세</button>'
                            + '  <button type="button" class="btn btn-xs btn-edit" data-action="edit">수정</button>'
                            + '  <button type="button" class="btn btn-xs btn-delete" data-action="delete">삭제</button>'
                            + '</div>';
                    }
                }
            ];
        }

        function initGrid() {                                            // AG Grid 초기화
            var gridDiv = el("publicFacilityGrid");                      // Grid 영역
            if (!gridDiv || !window.agGrid) return;                      // Grid 사용 불가 시 중단

            var gridOptions = {                                          // Grid 옵션
                theme:"legacy",
                columnDefs:createColumnDefs(),
                rowData:publicFacilityRowData,
                defaultColDef:{
                    sortable:true,
                    filter:true,
                    resizable:true,
                    suppressMovable:true
                },
                pagination:true,
                paginationPageSize:10,
                paginationPageSizeSelector:[10, 20, 50],
                rowHeight:46,
                headerHeight:42,
                suppressCellFocus:true,
                animateRows:true,
                suppressDragLeaveHidesColumns:true,
                onGridReady:function (params) {
                    publicFacilityGridApi = params.api;                  // Grid API 저장
                    loadList();                                          // 최초 목록 조회
                },
                onFilterChanged:function () {
                    updateFilteredCount();                               // 필터 적용 건수 갱신
                },
                onCellClicked:function (event) {
                    var btn = event.event.target.closest("[data-action]"); // 클릭 버튼 조회
                    if (!btn) return;                                    // 버튼 아니면 중단
                    var action = btn.dataset.action;                     // 버튼 action
                    var no = event.data.cmnFacilityNo;                   // 공용시설 번호
                    if (action === "detail") moveDetail(no);             // 상세 이동
                    if (action === "edit") moveUpdate(no);               // 수정 이동
                    if (action === "delete") deleteFacility(no);         // 삭제 처리
                }
            };

            agGrid.createGrid(gridDiv, gridOptions);                     // Grid 생성
        }

        async function loadList() {                                      // 공용시설 목록 조회
            var url = contextPath + "/manager/publicFacility/list/" + encodeURIComponent(mgmtOfcNo); // 목록 API URL
            try {
                var result = await getJson(url);                         // 목록 조회
                publicFacilityRowData = result.list || [];               // 목록 데이터 저장
                updateChips(publicFacilityRowData);                      // 전체 기준 요약 갱신
                if (publicFacilityGridApi) publicFacilityGridApi.setGridOption("rowData", publicFacilityRowData); // Grid 데이터 반영
                updateFilteredCount();                                   // 표시 건수 갱신
            } catch (e) {
                console.error(e);                                        // 오류 로그
                alertMessage(e.message || "공용시설 목록 조회 중 오류가 발생했습니다."); // 오류 안내
                publicFacilityRowData = [];                              // 빈 목록 세팅
                updateChips(publicFacilityRowData);                      // 요약 초기화
                if (publicFacilityGridApi) publicFacilityGridApi.setGridOption("rowData", publicFacilityRowData); // Grid 초기화
            }
        }

        document.addEventListener("DOMContentLoaded", function () {       // 페이지 초기화
            if (el("registerBtn")) el("registerBtn").addEventListener("click", moveRegister); // 등록 버튼 이벤트
            initGrid();                                                  // Grid 초기화
        });
    })();
</script>
</body>
</html>