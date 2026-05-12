<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설자산 목록</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">

    <style>
        /* ============================================================
           시설자산 목록 화면 전용 스타일
           - 등록/수정/상세 모달 스타일 제거
           - list.jsp에서 실제 사용하는 검색, 카드, 그리드 스타일만 유지
        ============================================================ */
        #facilityPage { --accent:#2e5c38; --accent-light:#e8f0ea; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; }
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }
        #facilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; background:#fff; }
        #facilityPage .panel + .panel { margin-top:14px; }
        #facilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #facilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #facilityPage .form-input, #facilityPage .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #facilityPage .form-input:focus, #facilityPage .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #facilityPage .btn { border-radius:4px; min-height:32px; font-size:12px; padding:0 12px; }
        #facilityPage .btn-primary { background:var(--accent); }
        #facilityPage .btn-primary:hover { background:#1a3d1f; }
        #facilityPage .page-actions { display:flex; align-items:center; justify-content:flex-end; gap:7px; }

        /* 현황 카드 */
        #facilityPage .asset-summary-row { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:10px; margin-bottom:14px; }
        #facilityPage .asset-summary-card { display:flex; align-items:center; gap:12px; min-height:74px; padding:14px 16px; border:1px solid var(--line); border-radius:6px; background:var(--surface); }
        #facilityPage .asset-summary-card .summary-icon { display:inline-flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:6px; background:var(--accent-light); color:var(--accent); flex-shrink:0; }
        #facilityPage .asset-summary-card .summary-icon .material-symbols-rounded { font-size:20px; }
        #facilityPage .asset-summary-card .summary-label { font-size:11px; font-weight:700; color:#6b7a6e; margin-bottom:2px; }
        #facilityPage .asset-summary-card .summary-value { font-size:22px; font-weight:800; color:var(--text-head); line-height:1; }
        #facilityPage .asset-summary-card.primary { background:var(--accent); border-color:#1f4027; }
        #facilityPage .asset-summary-card.primary .summary-icon { background:rgba(255,255,255,.14); color:#fff; }
        #facilityPage .asset-summary-card.primary .summary-label { color:rgba(255,255,255,.72); }
        #facilityPage .asset-summary-card.primary .summary-value { color:#fff; }

        /* 탭 */
        #facilityPage .facility-tab-row { display:flex; align-items:center; gap:6px; margin-bottom:14px; border-bottom:1px solid var(--line); }
        #facilityPage .facility-tab-btn { position:relative; display:inline-flex; align-items:center; gap:5px; height:36px; padding:0 14px; border:0; background:transparent; color:#6b7a6e; font-size:12px; font-weight:800; cursor:pointer; }
        #facilityPage .facility-tab-btn .material-symbols-rounded { font-size:17px; color:#9caa9e; }
        #facilityPage .facility-tab-btn.active { color:var(--accent); }
        #facilityPage .facility-tab-btn.active::after { content:""; position:absolute; left:0; right:0; bottom:-1px; height:2px; background:var(--accent); }
        #facilityPage .facility-tab-btn.active .material-symbols-rounded { color:var(--accent); }

        /* 검색 */
        #facilityPage .facility-filter-panel { overflow:visible; }
        #facilityPage .facility-filter-panel .panel-body { overflow:visible; }
        #facilityPage .facility-filter-grid { display:grid; grid-template-columns:1fr 1fr 1fr minmax(280px,1.4fr) auto; gap:10px; align-items:end; }
        #facilityPage .facility-search-field { position:relative; min-width:0; z-index:20; }
        #facilityPage .search-wrap { position:relative; width:100%; }
        #facilityPage .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #facilityPage .search-wrap input { padding-left:30px; width:100%; }
        #facilityPage .facility-search-suggest { display:none; position:absolute; left:0; right:0; top:calc(100% + 4px); z-index:60; max-height:292px; overflow:hidden; border:1px solid var(--line); border-radius:5px; background:#fff; box-shadow:0 8px 22px rgba(15,23,42,.12); }
        #facilityPage .facility-search-suggest.open { display:block; }
        #facilityPage .suggest-item { display:block; width:100%; padding:9px 11px; border:0; border-bottom:1px solid #edf0ed; background:#fff; text-align:left; cursor:pointer; font-family:inherit; }
        #facilityPage .suggest-item:hover { background:#f4f7f4; }
        #facilityPage .suggest-main { display:flex; align-items:center; gap:7px; font-size:12px; font-weight:800; color:#1f2937; }
        #facilityPage .suggest-no { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#2e5c38; }
        #facilityPage .suggest-sub { margin-top:3px; font-size:11px; color:#7a8a7d; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .suggest-empty { padding:8px 11px; font-size:11px; color:#7a8a7d; background:#fafcfb; }

        /* 목록 헤더 */
        #facilityPage .list-header-left { display:flex; align-items:center; gap:8px; min-width:0; }
        #facilityPage .list-header-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; flex-shrink:0; }
        #facilityPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #facilityPage .result-desc { font-size:11px; color:#7a8a7d; margin-left:8px; font-weight:500; }

        /* AG Grid */
        #facilityPage .facility-grid-wrap { padding:0; height:auto; overflow:hidden; }
        #facilityPage #facilityGrid { width:100%; height:auto; border:0; }
        #facilityPage .ag-theme-alpine { --ag-font-family:'Noto Sans KR',sans-serif; --ag-font-size:12px; --ag-header-background-color:#f0f2ef; --ag-header-foreground-color:#4a5c4e; --ag-border-color:#d7dce2; --ag-row-hover-color:#f4f7f4; --ag-selected-row-background-color:#edf6ef; }
        #facilityPage .ag-header-cell-label { justify-content:center; }
        #facilityPage .ag-cell { display:flex; align-items:center; }
        #facilityPage #facilityGrid.ag-layout-auto-height .ag-center-cols-viewport,
        #facilityPage #facilityGrid.ag-layout-auto-height .ag-center-cols-container { min-height:0 !important; }
        #facilityPage #facilityGrid .ag-center-cols-viewport,
        #facilityPage #facilityGrid .ag-body-viewport { overflow-y:hidden !important; }
        #facilityPage #facilityGrid .ag-body-horizontal-scroll,
        #facilityPage #facilityGrid .ag-body-horizontal-scroll-viewport {
            display:none !important;
            height:0 !important;
            min-height:0 !important;
            max-height:0 !important;
            overflow:hidden !important;
        }
        #facilityPage .cell-center { justify-content:center; text-align:center; }
        #facilityPage .td-bold { font-weight:600; color:#111827; }
        #facilityPage .td-mono { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#6b7a6e; }
        #facilityPage .td-empty { color:#9caa9e; }
        #facilityPage .grid-ellipsis { display:block; max-width:100%; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityPage .grid-actions { display:inline-flex; gap:5px; align-items:center; justify-content:center; width:100%; }
        #facilityPage .grid-actions .btn { min-height:28px; height:28px; padding:0 10px; font-size:11px; border-radius:4px; }
        #facilityPage .status-text { display:inline-flex; align-items:center; justify-content:center; gap:6px; font-size:12px; font-weight:700; line-height:1; white-space:nowrap; }
        #facilityPage .status-text::before { content:""; width:7px; height:7px; border-radius:50%; flex-shrink:0; }
        #facilityPage .status-text.is-available { color:#1f7a3f; }
        #facilityPage .status-text.is-available::before { background:#22c55e; }
        #facilityPage .status-text.is-disabled { color:#b42318; }
        #facilityPage .status-text.is-disabled::before { background:#ef4444; }
        #facilityPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:600; line-height:20px; border:1px solid transparent; box-shadow:none; white-space:nowrap; }
        #facilityPage .badge-blue { background:#dbeafe; color:#1e3a5f; border-color:#bfdbfe; }
        #facilityPage .badge-teal { background:#eef8f6; color:#245e55; border-color:#c8e3dd; }
        #facilityPage .badge-gray { background:#e9ece9; color:#374151; border-color:#d1d5db; }

        /* 안내바 */
        #facilityPage .facility-info-line { display:flex; align-items:center; gap:8px; padding:10px 16px; border-top:1px solid var(--line); background:#f8f9fb; font-size:12px; color:#6b7a6e; }
        #facilityPage .facility-info-line .material-symbols-rounded { font-size:15px; color:var(--accent); flex-shrink:0; }
        #facilityPage .facility-info-line a { color:var(--accent); font-weight:700; text-decoration:none; margin-left:4px; }




        @media (max-width:1100px) { #facilityPage .facility-filter-grid { grid-template-columns:1fr 1fr; } }
        @media (max-width:760px) { #facilityPage .asset-summary-row { grid-template-columns:1fr 1fr; } #facilityPage .facility-filter-grid { grid-template-columns:1fr; } }


    </style>

    <script>
        <sec:authorize access="hasRole('ADMIN')" var="facilityAdmin" />
        window.facilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            isAdmin: ${facilityAdmin}
        };
    </script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="facilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>시설자산 관리</h2>
                        <p>단지 내 시설자산 마스터 정보를 등록·조회·관리합니다</p>
                    </div>
                    <div class="page-actions"></div>
                </div>

                <div class="asset-summary-row">
                    <div class="asset-summary-card primary">
                        <div class="summary-icon"><span class="material-symbols-rounded">apartment</span></div>
                        <div><div class="summary-label">전체 시설 총수</div><div class="summary-value" id="statTotal">0</div></div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">domain</span></div>
                        <div><div class="summary-label">동 지정 시설</div><div class="summary-value" id="statDong">0</div></div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">location_city</span></div>
                        <div><div class="summary-label">공용 위치 시설</div><div class="summary-value" id="statCommonLoc">0</div></div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">block</span></div>
                        <div><div class="summary-label">비활성 시설</div><div class="summary-value" id="statDisabled">0</div><div style="font-size:11px;color:#9caa9e;margin-top:2px;" id="statDisabledToday"></div></div>
                    </div>
                </div>

                <div class="facility-tab-row tab-bar" role="tablist" aria-label="시설종류 선택">
                    <button type="button" class="facility-tab-btn tab-btn active" data-action="setFacilityTab" data-kind="ALL">
                        <span class="material-symbols-rounded">apartment</span>전체시설
                    </button>
                    <button type="button" class="facility-tab-btn tab-btn" data-action="setFacilityTab" data-kind="PUBLIC">
                        <span class="material-symbols-rounded">groups</span>편의시설
                    </button>
                </div>

                <div class="panel facility-filter-panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <div class="facility-filter-grid">
                            <div class="form-field">
                                <label class="field-label">시설유형</label>
                                <select class="form-select" id="filterFacTy" name="facilityTyCd">
                                    <option value="">전체</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">활성여부</label>
                                <select class="form-select" id="filterUseYn" name="useYn">
                                    <option value="">전체</option>
                                    <option value="Y">활성</option>
                                    <option value="N">비활성</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">동</label>
                                <select class="form-select" id="filterDong" name="dongNo">
                                    <option value="">전체</option>
                                    <c:forEach var="dong" items="${dongList}">
                                        <option value="${dong.dongNo}">${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}</option>
                                    </c:forEach>
                                    <option value="_COMMON_">공용 위치</option>
                                </select>
                            </div>
                            <div class="form-field facility-search-field">
                                <label class="field-label">시설 검색</label>
                                <div class="search-wrap">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="filterKeyword" name="keyword" autocomplete="off" placeholder="시설번호 · 시설명 · 상세위치 검색">
                                    <div class="facility-search-suggest" id="facilitySuggestList"></div>
                                </div>
                            </div>
                            <div class="form-field">
                                <label class="field-label">&nbsp;</label>
                                <div class="page-actions">
                                    <button type="button" class="btn btn-secondary btn-sm" data-action="resetFacility">초기화</button>
                                    <button type="button" class="btn btn-primary btn-sm" data-action="searchFacility">검색</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="list-header-left">
                            <h3 class="panel-title"><span class="material-symbols-rounded">apartment</span>시설자산 목록</h3>
                            <span class="list-count" id="facilityCount">0건</span>
                            <span class="result-desc" id="resultDesc">전체 조건</span>
                        </div>
                        <div class="list-header-right">
                            <%-- 편의시설 탭 전용 운영관리 이동 버튼 --%>
                            <button type="button" class="btn btn-secondary btn-sm" id="publicFacilityManageBtn" data-action="movePublicFacilityManage" style="display:none;">
                                <span class="material-symbols-rounded">settings</span>공용시설 운영관리
                            </button>
                            <button type="button" class="btn btn-secondary btn-sm" data-action="exportExcel"><span class="material-symbols-rounded">download</span>엑셀 다운로드</button>
                            <sec:authorize access="!hasRole('ADMIN')">
                                <button type="button" class="btn btn-primary btn-sm" data-action="openRegister"><span class="material-symbols-rounded">add</span>시설 등록</button>
                            </sec:authorize>
                        </div>
                    </div>
                    <div class="facility-grid-wrap"><div id="facilityGrid" class="ag-theme-alpine"></div></div>
                    <div class="facility-info-line">
                        <span class="material-symbols-rounded">info</span>
                        헬스장·독서실 등 편의시설에 대한 운영 관리는 편의시설 관리에서 진행합니다.
                        <a href="${pageContext.request.contextPath}/manager/publicFacilityList">편의시설 관리 →</a>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/AgRenderer.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/facility/mngr-facility-grid.js"></script>
<script>
    /* ============================================================
       시설자산 목록 화면 스크립트

       이 JSP의 JS 역할
       - 이 파일은 “시설 목록 화면”만 담당한다.
       - 등록/수정 폼 화면을 직접 그리지 않는다.
       - 상세 화면을 직접 그리지 않는다.
       - 등록/수정/상세 버튼을 누르면 해당 JSP 화면으로 이동만 한다.

       유지 기능
       - 목록 조회
       - 전체시설 / 편의시설 탭 변경
       - 시설유형 / 운영상태 / 동 / 검색어 필터 조회
       - 전체시설 탭에서 “편의시설” 선택 시 편의시설 탭으로 이동
       - 검색어 자동완성
       - 등록 / 상세 / 수정 화면 이동
       - AG Grid 출력
       - 엑셀 다운로드

       읽는 순서
       1. 기본 설정
       2. 공통 함수
       3. 페이지 이동
       4. 검색 조건
       5. 탭 / 시설유형 필터
       6. 목록 / 현황 카드
       7. 자동완성
       8. 엑셀 다운로드
       9. 이벤트 처리
       10. 초기 실행
    ============================================================ */
    (function () {

        /* ============================================================
           1. 기본 설정
           - JSP에서 내려준 값과 현재 화면에서 계속 써야 하는 상태값
        ============================================================ */

        /*
         * config
         * - JSP 상단 window.facilityPageConfig에 담아둔 화면 설정값
         * - contextPath, mgmtOfcNo, isAdmin을 꺼내기 위한 원본 객체
         */
        var config = window.facilityPageConfig || {};

        /*
         * contextPath
         * - 프로젝트 기본 경로
         * - 예: "" 또는 "/STEVEN_ZIPS"
         * - fetch 요청 주소와 화면 이동 주소 앞에 붙인다.
         */
        var contextPath = config.contextPath || "";

        /*
         * mgmtOfcNo
         * - 현재 조회 중인 관리사무소 번호
         * - 모든 목록/필터/화면 이동 URL에 들어간다.
         */
        var mgmtOfcNo = config.mgmtOfcNo || "";

        /*
         * isAdmin
         * - 현재 로그인 사용자가 ADMIN인지 여부
         * - ADMIN은 조회만 가능하므로 수정 화면 이동을 막기 위해 사용한다.
         */
        var isAdmin = config.isAdmin === true || config.isAdmin === "true";

        /*
         * currentTab
         * - 현재 선택된 시설 탭
         * - ALL    : 전체시설 탭
         * - PUBLIC : 편의시설 탭
         * - 목록 조회 시 facilityKind 파라미터로 서버에 보낸다.
         */
        var currentTab = "ALL";

        /*
         * currentList
         * - 서버에서 조회한 현재 시설 목록 배열
         * - AG Grid에 넣는 데이터이면서 자동완성과 엑셀 다운로드에서도 재사용한다.
         */
        var currentList = [];

        /*
         * suggestTimer
         * - 검색어 자동완성용 타이머
         * - 사용자가 키를 입력할 때마다 바로 실행하지 않고 0.18초 뒤에 한 번만 실행하기 위해 사용한다.
         */
        var suggestTimer = null;

        /*
         * PUBLIC_TYPE_CODES
         * - 편의시설로 취급할 시설유형 코드 목록
         * - 전체시설 탭에서는 이 코드들을 각각 보여주지 않고 “편의시설” 옵션 하나로 합친다.
         */
        var PUBLIC_TYPE_CODES = ["PLAY", "GYM", "STUDY", "MEET", "GUEST", "SENIOR", "PUB_ETC"];

        /* ============================================================
           2. 공통 함수
           - 여러 함수에서 반복해서 쓰는 짧은 도우미 함수
        ============================================================ */

        /**
         * id로 DOM 요소 찾기
         * - document.getElementById(...)를 짧게 쓰기 위한 함수
         * - 예: el("filterKeyword")
         */
        function el(id) {
            return document.getElementById(id);
        }

        /**
         * 시설 API 주소 만들기
         * - JSON 데이터를 주고받는 Controller 주소용
         * - 예: apiUrl("list/12") → /manager/facility/list/12
         */
        function apiUrl(path) {
            return contextPath + "/manager/facility/" + path;
        }

        /**
         * 시설 JSP 화면 이동 주소 만들기
         * - 등록/수정/상세 JSP로 이동할 때 사용
         * - 현재는 apiUrl과 같은 앞주소를 쓰지만, 의미를 구분하려고 따로 둔다.
         */
        function pageUrl(path) {
            return contextPath + "/manager/facility/" + path;
        }

        /**
         * 알림 출력
         * - 프로젝트 공통 showAlert가 있으면 그것을 사용
         * - 없으면 기본 alert 사용
         */
        function alertMessage(message) {
            if (typeof showAlert === "function") {
                showAlert(message);
                return;
            }
            alert(message);
        }

        /**
         * HTML 특수문자 변환
         * - 자동완성 HTML을 문자열로 만들 때 XSS 방지용으로 사용
         * - 사용자가 입력하거나 DB에서 온 값을 HTML에 직접 넣기 전에 거친다.
         */
        function escapeHtml(value) {
            if (value == null) return "";
            return String(value)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        /**
         * CSRF 헤더 만들기
         * - Spring Security CSRF가 켜져 있을 때 fetch 요청에 필요한 헤더
         * - JSP의 <sec:csrfMetaTags/>가 만든 meta 태그에서 token/header 이름을 읽는다.
         */
        function getCsrfHeaders() {
            var tokenMeta = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};

            if (tokenMeta && headerMeta) {
                headers[headerMeta.getAttribute("content")] = tokenMeta.getAttribute("content");
            }

            return headers;
        }

        /**
         * GET 방식 JSON 요청
         * - 목록 조회, 시설유형 조회 등에 사용
         * - 서버가 success:false를 주면 catch로 넘기기 위해 Error를 발생시킨다.
         */
        async function getJson(url) {
            var response = await fetch(url, {
                method: "GET",
                headers: getCsrfHeaders()
            });

            var data = await response.json();

            if (!response.ok || data.success === false) {
                throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            }

            return data;
        }

        /**
         * 여러 이름 중 실제 값 읽기
         * - 서버에서 Map으로 내려오면 CODE처럼 대문자 키가 올 수 있고,
         *   DTO/VO로 내려오면 code 같은 camelCase 키가 올 수 있다.
         * - 그 차이를 흡수하려고 후보 key 목록을 순서대로 확인한다.
         */
        function readValue(row, keyList) {
            row = row || {};

            for (var i = 0; i < keyList.length; i++) {
                if (row[keyList[i]] != null) {
                    return row[keyList[i]];
                }
            }

            return "";
        }

        /* ============================================================
           3. 페이지 이동
           - list.jsp에서는 등록/수정/상세 화면을 직접 열지 않고 이동만 한다.
        ============================================================ */

        /** 시설 등록 화면 이동 */
        function moveRegisterPage() {
            location.href = pageUrl("register/" + encodeURIComponent(mgmtOfcNo));
        }

        /** 시설 상세 화면 이동 */
        function moveDetailPage(facilityNo) {
            location.href = pageUrl(
                "detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)
            );
        }

        /** 시설 수정 화면 이동 */
        function moveUpdatePage(facilityNo) {
            if (isAdmin) {
                alertMessage("관리자는 조회만 가능합니다.");
                return;
            }

            location.href = pageUrl(
                "update-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)
            );
        }

        /* ============================================================
           4. 검색 조건
           - 현재 필터 값을 읽고 URLSearchParams로 만든다.
        ============================================================ */

        /**
         * 현재 검색 조건 수집
         * - 서버 목록 조회 API에 붙일 query string 생성
         * - 예: facilityKind=ALL&useYn=Y&keyword=승강기
         */
        function getSearchParams() {
            var params = new URLSearchParams();

            params.append("facilityKind", currentTab);

            if (el("filterFacTy").value) {
                params.append("facilityTyCd", el("filterFacTy").value);
            }
            if (el("filterUseYn").value) {
                params.append("useYn", el("filterUseYn").value);
            }
            if (el("filterDong").value) {
                params.append("dongNo", el("filterDong").value);
            }
            if (el("filterKeyword").value.trim()) {
                params.append("keyword", el("filterKeyword").value.trim());
            }

            return params;
        }

        /** 검색 조건 초기화 후 목록 재조회 */
        function resetSearch() {
            el("filterFacTy").value = "";
            el("filterUseYn").value = "";
            el("filterDong").value = "";
            el("filterKeyword").value = "";

            closeSuggestList();
            FacilityGrid.reset();
            loadFacilityList();
        }

        /**
         * 목록 상단 설명 문구 만들기
         * - 예: 시설종류: 전체시설 · 운영상태: 사용 가능 · 검색어: 승강기
         * - 실제 조회 조건을 사용자가 볼 수 있게 보여주는 용도
         */
        function makeFilterText() {
            var labels = [];
            var typeSelect = el("filterFacTy");
            var useYnSelect = el("filterUseYn");
            var dongSelect = el("filterDong");
            var keyword = el("filterKeyword").value.trim();

            labels.push("시설종류: " + (currentTab === "PUBLIC" ? "편의시설" : "전체시설"));

            if (typeSelect.value) {
                labels.push("시설유형: " + typeSelect.options[typeSelect.selectedIndex].text);
            }
            if (useYnSelect.value) {
                labels.push("활성여부: " + useYnSelect.options[useYnSelect.selectedIndex].text);
            }
            if (dongSelect.value) {
                labels.push("동: " + dongSelect.options[dongSelect.selectedIndex].text);
            }
            if (keyword) {
                labels.push("검색어: " + keyword);
            }

            return labels.join(" · ");
        }

        /* ============================================================
           5. 탭 / 시설유형 필터
           - 전체시설 탭과 편의시설 탭의 시설유형 select 구성이 다르다.
        ============================================================ */

        /**
         * 편의시설 운영관리 버튼 표시 갱신
         * - 전체시설 탭에서는 숨김 처리
         * - 편의시설 탭에서는 표시 처리
         */
        function updatePublicManageButton() {
            /* 운영관리 버튼 요소 */
            var manageBtn = el("publicFacilityManageBtn");

            /* 버튼 요소 없음 방어 */
            if (!manageBtn) return;

            /* 편의시설 탭 기준 표시 여부 */
            manageBtn.style.display = currentTab === "PUBLIC" ? "inline-flex" : "none";
        }

        /**
         * 편의시설 운영관리 화면 이동
         * - 운영시간/예약/요금 등은 시설자산이 아니라 공용시설 운영관리에서 처리
         */
        function movePublicFacilityManagePage() {
            location.href = contextPath + "/manager/publicFacilityList";
        }

        /**
         * 탭 변경
         * - currentTab 값을 바꾼다.
         * - 탭 버튼 active 표시를 바꾼다.
         * - 시설유형 필터를 탭에 맞게 다시 그린다.
         * - 목록을 다시 조회한다.
         */
        async function changeTab(tabName) {
            currentTab = tabName === "PUBLIC" ? "PUBLIC" : "ALL";

            /* 편의시설 탭 전용 운영관리 버튼 표시 갱신 */
            updatePublicManageButton();

            document.querySelectorAll(".facility-tab-btn").forEach(function (button) {
                button.classList.toggle("active", button.dataset.kind === currentTab);
            });

            el("filterFacTy").value = "";
            closeSuggestList();
            FacilityGrid.reset();

            await loadFacilityTypeFilter();
            await loadFacilityList();
        }

        /**
         * 시설유형 필터 목록 조회 및 화면 출력
         * - 전체시설 탭: 일반시설 유형 + “편의시설” 옵션 1개
         * - 편의시설 탭: 편의시설 세부 유형 목록
         */
        async function loadFacilityTypeFilter() {
            var select = el("filterFacTy");
            var url = apiUrl(
                "type/list/" + encodeURIComponent(mgmtOfcNo) + "?facilityKind=" + encodeURIComponent(currentTab)
            );

            try {
                var result = await getJson(url);
                var typeList = result.typeList || result.list || [];

                select.innerHTML = '<option value="">전체</option>';

                if (currentTab === "ALL") {
                    drawAllTabTypeOptions(select, typeList);
                    return;
                }

                drawPublicTabTypeOptions(select, typeList);
            } catch (e) {
                console.error(e);
                select.innerHTML = '<option value="">전체</option>';
            }
        }

        /**
         * 전체시설 탭 시설유형 select 구성
         * - 일반시설 코드는 optgroup 안에 그대로 표시
         * - 편의시설 코드는 각각 보여주지 않고 마지막에 “편의시설” 1개로 표시
         */
        function drawAllTabTypeOptions(select, typeList) {
            var normalGroup = document.createElement("optgroup");
            var hasPublicType = false;

            normalGroup.label = "일반시설";

            typeList.forEach(function (item) {
                var code = readValue(item, ["code", "CODE", "codeNoCd", "CODE_NO_CD"]);
                var name = readValue(item, ["codeNm", "CODENM", "CODE_NM", "codeName", "CODE_NAME"]);
                var kind = readValue(item, ["facilityKind", "FACILITYKIND", "FACILITY_KIND", "facility_kind"]);

                if (!code) return;

                if (isPublicType(code, kind)) {
                    hasPublicType = true;
                    return;
                }

                normalGroup.appendChild(makeOption(code, name || code));
            });

            if (normalGroup.children.length > 0) {
                select.appendChild(normalGroup);
            }

            if (hasPublicType) {
                select.appendChild(makeOption("_PUBLIC_", "편의시설"));
            }
        }

        /** 편의시설 탭 시설유형 select 구성 */
        function drawPublicTabTypeOptions(select, typeList) {
            typeList.forEach(function (item) {
                var code = readValue(item, ["code", "CODE", "codeNoCd", "CODE_NO_CD"]);
                var name = readValue(item, ["codeNm", "CODENM", "CODE_NM", "codeName", "CODE_NAME"]);

                if (!code) return;
                select.appendChild(makeOption(code, name || code));
            });
        }

        /** 해당 시설유형 코드가 편의시설인지 확인 */
        function isPublicType(code, kind) {
            code = String(code || "").toUpperCase();
            kind = String(kind || "").toUpperCase();

            return kind === "PUBLIC" || PUBLIC_TYPE_CODES.indexOf(code) > -1;
        }

        /** select option 생성 */
        function makeOption(value, text) {
            var option = document.createElement("option");
            option.value = value;
            option.textContent = text;
            return option;
        }

        /* ============================================================
           6. 목록 / 현황 카드
           - 서버에서 시설 목록을 가져와 AG Grid와 현황 카드를 갱신한다.
        ============================================================ */

        /**
         * 시설 목록 조회
         * - 현재 선택된 탭/필터/검색어를 서버로 보낸다.
         * - 받은 목록을 currentList에 저장한다.
         * - AG Grid와 현황 카드 값을 갱신한다.
         */
        async function loadFacilityList() {
            var params = getSearchParams();
            var url = apiUrl("list/" + encodeURIComponent(mgmtOfcNo));

            if (params.toString()) {
                url += "?" + params.toString();
            }

            try {
                var result = await getJson(url);
                currentList = result.list || result.facilityList || [];

                FacilityGrid.setRows(currentList);
                updateListHeader(currentList.length);
                updateStats(currentList, result.stats || {});
            } catch (e) {
                console.error(e);
                alertMessage(e.message || "시설 목록 조회 중 오류가 발생했습니다.");

                currentList = [];
                FacilityGrid.setRows([]);
                updateListHeader(0);
                updateStats([], {});
            }
        }

        /** 목록 제목 옆 건수와 조건 설명 갱신 */
        function updateListHeader(count) {
            el("facilityCount").textContent = (count || 0) + "건";
            el("resultDesc").textContent = makeFilterText();
        }

        /**
         * 현황 카드 갱신
         * - 서버에서 stats가 오면 그 값을 우선 사용
         * - stats가 없으면 현재 목록 currentList 기준으로 화면에서 계산
         */
        function updateStats(list, stats) {
            stats = stats || {};
            list = list || [];

            var dongCnt = stats.dongCnt != null ? stats.dongCnt : countDongFacility(list);
            var commonLocCnt = stats.commonLocCnt != null ? stats.commonLocCnt : countCommonFacility(list);
            var disabledTotal = stats.disabledTotal != null ? stats.disabledTotal : countDisabledFacility(list);
            var disabledToday = stats.disabledToday != null ? Number(stats.disabledToday) : 0;

            el("statTotal").textContent = list.length;
            el("statDong").textContent = dongCnt;
            el("statCommonLoc").textContent = commonLocCnt;
            el("statDisabled").textContent = disabledTotal;
            el("statDisabledToday").textContent = disabledToday > 0 ? "오늘 " + disabledToday + "건 추가" : "";
        }

        /** 동 번호가 있는 시설 수 계산 */
        function countDongFacility(list) {
            return list.filter(function (row) {
                return row.dongNo;
            }).length;
        }

        /** 동 번호가 없는 공용 위치 시설 수 계산 */
        function countCommonFacility(list) {
            return list.filter(function (row) {
                return !row.dongNo;
            }).length;
        }

        /** 사용여부가 N인 이용불가 시설 수 계산 */
        function countDisabledFacility(list) {
            return list.filter(function (row) {
                return row.useYn === "N";
            }).length;
        }

        /* ============================================================
           7. 자동완성
           - 현재 조회된 목록(currentList) 안에서만 후보를 보여준다.
        ============================================================ */

        /**
         * 자동완성 실행 예약
         * - input 이벤트마다 바로 검색하지 않고 180ms 뒤에 실행
         * - 빠르게 타이핑할 때 불필요한 반복 실행 방지
         */
        function scheduleSuggest() {
            clearTimeout(suggestTimer);

            suggestTimer = setTimeout(function () {
                showSuggestList(el("filterKeyword").value);
            }, 180);
        }

        /**
         * 자동완성 목록 표시
         * - 검색어가 2글자 미만이면 닫기
         * - currentList에서 시설번호/시설명/유형/위치 등이 일치하는 최대 5건 표시
         */
        function showSuggestList(keyword) {
            var area = el("facilitySuggestList");
            var key = String(keyword || "").trim().toLowerCase();

            if (key.length < 2) {
                closeSuggestList();
                return;
            }

            var matched = currentList.filter(function (row) {
                return makeSearchText(row).indexOf(key) > -1;
            }).slice(0, 5);

            if (matched.length === 0) {
                area.innerHTML = '<div class="suggest-empty">일치하는 시설 후보가 없습니다.</div>';
                area.classList.add("open");
                return;
            }

            area.innerHTML = matched.map(makeSuggestHtml).join("");
            area.classList.add("open");
        }

        /** 자동완성 영역 닫기 */
        function closeSuggestList() {
            var area = el("facilitySuggestList");
            area.classList.remove("open");
            area.innerHTML = "";
        }

        /**
         * 자동완성 검색용 문자열 만들기
         * - 한 시설 row의 여러 컬럼을 하나의 문자열로 합친다.
         * - 검색어가 이 문자열 안에 포함되면 자동완성 후보로 표시한다.
         */
        function makeSearchText(row) {
            return [
                row.facilityNo,
                row.facilityNm,
                row.facilityTyNm,
                row.facilityTyCd,
                row.locCn,
                row.dongNo,
                row.useYn === "N" ? "비활성" : "활성"
            ].join(" ").toLowerCase();
        }

        /** 자동완성 후보 1건 HTML 생성 */
        function makeSuggestHtml(row) {
            var facilityNo = row.facilityNo || "";
            var facilityNm = row.facilityNm || "-";
            var locCn = row.locCn || "위치 정보 없음";

            return '<button type="button" class="suggest-item" data-action="selectSuggest" data-keyword="' + escapeHtml(facilityNo) + '">'
                + '<div class="suggest-main">'
                + '<span class="suggest-no">' + escapeHtml(facilityNo) + '</span>'
                + '<span>' + escapeHtml(facilityNm) + '</span>'
                + '</div>'
                + '<div class="suggest-sub">' + escapeHtml(locCn) + '</div>'
                + '</button>';
        }

        /**
         * 시설 활성여부 전환 요청
         * - 활성 시설은 비활성 처리
         * - 비활성 시설은 활성 처리
         * - 서버 API 주소가 프로젝트와 다르면 Controller 매핑명에 맞춰 path만 수정
         */
        async function toggleFacilityUseYn(facilityNo, currentUseYn) {
            /* 시설번호 없음 방어 */
            if (!facilityNo) return;

            /* ADMIN 쓰기 방어 */
            if (isAdmin) {
                alertMessage("관리자는 조회만 가능합니다.");
                return;
            }

            /* 다음 활성여부 값 */
            var nextUseYn = currentUseYn === "N" ? "Y" : "N";

            /* 사용자 확인 문구 */
            var confirmMessage = nextUseYn === "N"
                ? "해당 시설을 비활성 처리하시겠습니까?"
                : "해당 시설을 활성 처리하시겠습니까?";

            /* 취소 처리 */
            if (!confirm(confirmMessage)) return;

            try {
                /* 서버 활성여부 변경 요청 */
                var response = await fetch(apiUrl("use-yn/update"), {
                    method: "POST",
                    headers: Object.assign({
                        "Content-Type": "application/json"
                    }, getCsrfHeaders()),
                    body: JSON.stringify({
                        facilityNo: facilityNo,
                        useYn: nextUseYn
                    })
                });

                /* 응답 JSON */
                var result = await response.json();

                /* 실패 응답 처리 */
                if (!response.ok || result.success === false) {
                    throw new Error(result.message || "활성여부 변경 중 오류가 발생했습니다.");
                }

                /* 완료 알림 */
                alertMessage(nextUseYn === "N" ? "비활성 처리되었습니다." : "활성 처리되었습니다.");

                /* 목록 재조회 */
                loadFacilityList();
            } catch (e) {
                console.error(e);
                alertMessage(e.message || "활성여부 변경 중 오류가 발생했습니다.");
            }
        }

        /* ============================================================
           8. 엑셀 다운로드
           - 실제 다운로드 기능은 mngr-facility-grid.js의 FacilityGrid.exportExcel 사용
        ============================================================ */

        /** 현재 목록 엑셀/CSV 다운로드 */
        function exportExcel() {
            if (currentList.length === 0) {
                alertMessage("다운로드할 시설 목록이 없습니다.");
                return;
            }

            FacilityGrid.exportExcel("시설자산_목록.csv");
        }

        /* ============================================================
           9. 이벤트 처리
           - HTML의 data-action 값을 보고 어떤 동작을 할지 결정.
        ============================================================ */

        /**
         * 클릭 이벤트 처리
         * - 등록/상세/수정/검색/초기화/탭/엑셀/자동완성 선택 버튼 처리
         */
        function handleClick(event) {
            var button = event.target.closest("[data-action]");
            if (!button) return;

            var action = button.dataset.action;
            var facilityNo = button.dataset.rowKey || button.dataset.keyword;

            if (action === "openRegister") {
                moveRegisterPage();
                return;
            }

            if (action === "detail") {
                moveDetailPage(facilityNo);
                return;
            }

            if (action === "edit") {
                moveUpdatePage(facilityNo);
                return;
            }

            if (action === "searchFacility") {
                closeSuggestList();
                loadFacilityList();
                return;
            }

            if (action === "resetFacility") {
                resetSearch();
                return;
            }

            if (action === "setFacilityTab") {
                changeTab(button.dataset.kind);
                return;
            }

            if (action === "exportExcel") {
                exportExcel();
                return;
            }

            if (action === "movePublicFacilityManage") {
                movePublicFacilityManagePage();
                return;
            }

            if (action === "toggleUseYn") {
                toggleFacilityUseYn(facilityNo, button.dataset.useYn);
                return;
            }

            if (action === "selectSuggest") {
                el("filterKeyword").value = button.dataset.keyword || "";
                closeSuggestList();
                loadFacilityList();
            }
        }

        /**
         * select 변경 이벤트 처리
         * - 시설유형/운영상태/동 필터 변경 시 목록을 다시 조회한다.
         */
        function handleChange(event) {
            if (event.target.id === "filterFacTy") {
                handleTypeFilterChange(event.target.value);
                return;
            }

            if (event.target.id === "filterUseYn" || event.target.id === "filterDong") {
                closeSuggestList();
                loadFacilityList();
            }
        }

        /**
         * 시설유형 필터 변경 처리
         * - 전체시설 탭에서 “편의시설” 옵션을 선택하면 편의시설 탭으로 이동한다.
         * - 그 외에는 현재 탭에서 목록만 다시 조회한다.
         */
        function handleTypeFilterChange(value) {
            if (currentTab === "ALL" && value === "_PUBLIC_") {
                changeTab("PUBLIC");
                return;
            }

            closeSuggestList();
            loadFacilityList();
        }

        /**
         * 이벤트 연결
         * - 목록 화면에서 발생하는 클릭/변경/검색 입력 이벤트를 함수와 연결한다.
         */
        function bindEvents() {
            el("facilityPage").addEventListener("click", handleClick);
            el("facilityPage").addEventListener("change", handleChange);

            el("filterKeyword").addEventListener("input", scheduleSuggest);
            el("filterKeyword").addEventListener("keyup", function (event) {
                if (event.key === "Enter") {
                    closeSuggestList();
                    loadFacilityList();
                }
                if (event.key === "Escape") {
                    closeSuggestList();
                }
            });

            document.addEventListener("click", function (event) {
                if (!event.target.closest(".facility-search-field")) {
                    closeSuggestList();
                }
            });

            window.addEventListener("resize", function () {
                FacilityGrid.refreshSize();
            });
        }

        /* ============================================================
           10. 초기 실행
           - 화면 로딩이 끝난 뒤 그리드 초기화, 이벤트 연결, 첫 목록 조회를 실행한다.
        ============================================================ */

        document.addEventListener("DOMContentLoaded", function () {
            FacilityGrid.init("facilityGrid");
            bindEvents();
            updatePublicManageButton();
            loadFacilityTypeFilter().then(loadFacilityList);
        });

    })();
</script>
</body>
</html>
