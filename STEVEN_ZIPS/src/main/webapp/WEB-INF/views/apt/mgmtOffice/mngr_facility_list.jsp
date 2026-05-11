<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리사무소</title>

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
        #facilityPage { --accent:#2e5c38; --accent-light:#e8f0ea; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; }
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }
        #facilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #facilityPage .panel + .panel { margin-top:14px; }
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
        #facilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #facilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #facilityPage .panel-body .form-row { margin-bottom:10px; }
        #facilityPage .panel-body .form-input, #facilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #facilityPage .panel-body .form-input:focus, #facilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #facilityPage .panel-body .btn { min-height:32px; font-size:12px; padding:0 13px; border-radius:4px; }
        #facilityPage .panel-body .page-actions { justify-content:flex-end; }
        #facilityPage .panel-body .search-wrap { position:relative; }
        #facilityPage .panel-body .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #facilityPage .panel-body .search-wrap input { padding-left:30px; width:100%; }
        #facilityPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #facilityPage .result-desc { font-size:11px; color:#7a8a7d; margin-left:8px; font-weight:500; }
        #facilityPage .facility-grid-wrap { padding:0; height:520px; }
        #facilityPage #facilityGrid { width:100%; height:100%; border:0; }
        #facilityPage .ag-theme-alpine { --ag-font-family:'Noto Sans KR',sans-serif; --ag-font-size:12px; --ag-header-background-color:#f0f2ef; --ag-header-foreground-color:#4a5c4e; --ag-border-color:#d7dce2; --ag-row-hover-color:#f4f7f4; --ag-selected-row-background-color:#edf6ef; }
        #facilityPage .ag-header-cell-label { justify-content:center; }
        #facilityPage .ag-cell { display:flex; align-items:center; }
        #facilityPage .cell-center { justify-content:center; text-align:center; }
        #facilityPage .td-bold { font-weight:600; color:#111827; }
        #facilityPage .td-mono { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#6b7a6e; }
        #facilityPage .td-empty { color:#9caa9e; }
        #facilityPage .grid-actions { display:inline-flex; gap:5px; align-items:center; justify-content:center; width:100%; }
        #facilityPage .badge { padding:2px 7px; border-radius:3px; font-size:11px; font-weight:700; }
        #facilityPage .badge-green { background:#dceee0; color:#1a3d1f; } #facilityPage .badge-yellow { background:#fef3c7; color:#713f12; } #facilityPage .badge-red { background:#fee2e2; color:#7f1d1d; } #facilityPage .badge-gray { background:#e9ece9; color:#374151; } #facilityPage .badge-blue { background:#dbeafe; color:#1e3a5f; } #facilityPage .badge-orange { background:#ffedd5; color:#7c2d12; } #facilityPage .badge-purple { background:#ede9fe; color:#4c1d95; } #facilityPage .badge-teal { background:#ccfbf1; color:#134e4a; }
        #facilityPage .btn { border-radius:4px; } #facilityPage .btn-primary { background:var(--accent); } #facilityPage .btn-primary:hover { background:#1a3d1f; }
        .modal { border-radius:6px !important; } .modal-header.primary { background:#1a2e1e; } .modal-header.primary .modal-title { color:#fff; } .modal-header.primary .modal-close { color:rgba(255,255,255,.6); border-color:rgba(255,255,255,.15); background:rgba(255,255,255,.08); } .modal-header.primary .modal-close:hover { background:rgba(255,255,255,.15); color:#fff; }
        .form-section-title { letter-spacing:0; text-transform:none; font-size:11px; font-weight:800; color:#4a5c4e; }
        #facilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:#4a5c4e; line-height:1.6; }
        #facilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; } #facilityPage .notice-box strong { color:#1a2e1e; } #facilityPage .notice-box ul { margin:4px 0 0; padding-left:16px; }
        #facilityPage .field-help { margin-top:5px; font-size:11px; color:#9caa9e; line-height:1.5; } #facilityPage .field-help.lock { display:none; color:#7c2d12; } #facilityPage.is-edit-mode .field-help.lock { display:block; } #facilityPage.is-edit-mode.is-correction-unlocked .field-help.lock { display:none; } #facilityPage.is-edit-mode .register-guide { display:none; } #facilityPage .edit-guide { display:none; } #facilityPage.is-edit-mode .edit-guide { display:flex; }
        #facilityPage .detail-summary { border:1px solid var(--line); border-radius:4px; overflow:hidden; margin-top:4px; } #facilityPage .detail-summary .ds-header { display:flex; align-items:center; justify-content:space-between; padding:8px 12px; background:var(--th-bg); border-bottom:1px solid var(--line); font-size:11px; font-weight:800; color:#4a5c4e; } #facilityPage .detail-summary .ds-header a { font-size:11px; font-weight:600; color:var(--accent); text-decoration:none; } #facilityPage .detail-summary .ds-header a:hover { text-decoration:underline; } #facilityPage .detail-summary .ds-row { display:flex; align-items:center; gap:10px; padding:8px 12px; border-bottom:1px solid var(--line); font-size:12px; } #facilityPage .detail-summary .ds-row:last-child { border-bottom:none; } #facilityPage .detail-summary .ds-row:hover { background:#f4f7f4; } #facilityPage .detail-summary .ds-no { font-family:monospace; font-size:11px; color:#9caa9e; min-width:70px; } #facilityPage .detail-summary .ds-nm { flex:1; font-weight:600; color:#111827; } #facilityPage .detail-summary .ds-dt { font-size:11px; color:#9caa9e; font-family:monospace; } #facilityPage .detail-summary .ds-empty { padding:14px 12px; font-size:12px; color:#9caa9e; }

        /* ============================================================
           시설 사진 업로드/관리 전용 스타일
           - 공통 CSS/JS는 그대로 사용
           - 이 화면에서만 쓰는 파일 영역 스타일만 JSP 내부에 둠
        ============================================================ */
        #facilityPage .file-upload-box { border:1px dashed var(--line); border-radius:4px; padding:12px; background:#fafcfb; }
        #facilityPage .file-upload-head { display:flex; align-items:center; justify-content:space-between; gap:10px; margin-bottom:8px; }
        #facilityPage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:800; color:#4a5c4e; }
        #facilityPage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #facilityPage .file-upload-desc { font-size:11px; color:#7a8a7d; line-height:1.5; }
        #facilityPage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #facilityPage .file-preview-item { position:relative; min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #facilityPage .file-preview-item img { width:100%; height:92px; object-fit:cover; display:block; }
        #facilityPage .file-preview-name { padding:6px 7px; font-size:11px; color:#4a5c4e; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; border-top:1px solid var(--line); }
        #facilityPage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:#9caa9e; }
        #facilityPage .file-manage-list { display:flex; flex-direction:column; gap:7px; margin-top:8px; }
        #facilityPage .file-manage-row { display:flex; align-items:center; gap:10px; padding:8px 10px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #facilityPage .file-thumb { width:48px; height:48px; border-radius:4px; border:1px solid var(--line); object-fit:cover; background:#f4f7f4; flex-shrink:0; }
        #facilityPage .file-info { min-width:0; flex:1; }
        #facilityPage .file-name { font-size:12px; font-weight:700; color:#111827; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .file-meta { margin-top:2px; font-size:11px; color:#9caa9e; }
        #facilityPage .file-actions { display:flex; align-items:center; gap:5px; flex-shrink:0; }
        #facilityPage .file-actions .btn { min-height:28px; padding:0 9px; font-size:11px; }
        #facilityPage .file-delete-check { display:inline-flex; align-items:center; gap:4px; font-size:11px; color:#7f1d1d; font-weight:700; }
        #facilityPage .file-delete-check input { width:14px; height:14px; }
        #facilityPage .badge-use-y { background:#dceee0; color:#1a3d1f; }
        #facilityPage .badge-use-n { background:#fee2e2; color:#7f1d1d; }

        /* ============================================================
           시설자산 목록/검색 전용 보정
           - 공통 manager-agGrid.css는 건드리지 않고 이 JSP 안에서만 적용
           - 검색 항목과 목록 컬럼을 맞추기 위해 검침/점검 필터는 제외
        ============================================================ */
        #facilityPage .facility-tab-row { display:flex; gap:24px; width:100%; padding:0; margin-bottom:18px; background:transparent; border:none; border-bottom:1px solid var(--line); border-radius:0; }
        #facilityPage .facility-tab-btn { position:relative; display:flex; align-items:center; gap:6px; min-height:42px; padding:0 2px; border:none; border-radius:0; background:transparent; color:#6b7280; font-size:13px; font-weight:700; font-family:inherit; cursor:pointer; transition:.15s; }
        #facilityPage .facility-tab-btn:hover { color:#111827; }
        #facilityPage .facility-tab-btn .material-symbols-rounded { font-size:16px; color:#9ca3af; }
        #facilityPage .facility-tab-btn.active { background:transparent; color:#111827; box-shadow:none; }
        #facilityPage .facility-tab-btn.active::after { content:""; position:absolute; left:0; right:0; bottom:-1px; height:2px; background:var(--accent); }
        #facilityPage .facility-tab-btn.active .material-symbols-rounded { color:var(--accent); }
        #facilityPage .facility-filter-grid { display:grid; grid-template-columns:1fr 1fr 1fr minmax(280px,1.4fr) auto; gap:10px; align-items:end; }
        #facilityPage .facility-filter-panel { overflow:visible; }
        #facilityPage .facility-filter-panel .panel-body { overflow:visible; }
        #facilityPage .facility-search-field { position:relative; min-width:0; z-index:20; }
        #facilityPage .facility-search-field .search-wrap { width:100%; position:relative; }
        #facilityPage .facility-search-suggest { display:none; position:absolute; left:0; right:0; top:calc(100% + 4px); z-index:60; max-height:292px; overflow:hidden; border:1px solid var(--line); border-radius:5px; background:#fff; box-shadow:0 8px 22px rgba(15,23,42,.12); }
        #facilityPage .facility-search-suggest.open { display:block; }
        #facilityPage .suggest-item { display:block; width:100%; padding:9px 11px; border:0; border-bottom:1px solid #edf0ed; background:#fff; text-align:left; cursor:pointer; font-family:inherit; }
        #facilityPage .suggest-item:hover { background:#f4f7f4; }
        #facilityPage .suggest-main { display:flex; align-items:center; gap:7px; font-size:12px; font-weight:800; color:#1f2937; }
        #facilityPage .suggest-no { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#2e5c38; }
        #facilityPage .suggest-sub { margin-top:3px; font-size:11px; color:#7a8a7d; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .suggest-more, #facilityPage .suggest-empty { padding:8px 11px; font-size:11px; color:#7a8a7d; background:#fafcfb; }
        #facilityPage .list-header-left { display:flex; align-items:center; gap:8px; min-width:0; }
        #facilityPage .list-header-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; flex-shrink:0; }
        #facilityPage .facility-grid-wrap { overflow:hidden; }
        #facilityPage .grid-ellipsis { display:block; max-width:100%; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityPage .grid-actions .btn { min-height:28px; height:28px; padding:0 10px; font-size:11px; border-radius:4px; }
        #facilityPage .list-header-right .btn,
        #facilityPage .facility-filter-grid .btn { min-height:32px; height:32px; padding:0 12px; font-size:12px; border-radius:4px; }
        #facilityPage .status-text { display:inline-flex; align-items:center; justify-content:center; gap:6px; font-size:12px; font-weight:700; line-height:1; white-space:nowrap; }
        #facilityPage .status-text::before { content:""; width:7px; height:7px; border-radius:50%; flex-shrink:0; }
        #facilityPage .status-text.is-available { color:#1f7a3f; }
        #facilityPage .status-text.is-available::before { background:#22c55e; }
        #facilityPage .status-text.is-disabled { color:#b42318; }
        #facilityPage .status-text.is-disabled::before { background:#ef4444; }

        /* 시설자산 화면 안의 배지만 작고 각진 태그 형태로 보정한다. */
        #facilityPage .ag-theme-alpine .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:600; line-height:20px; border:1px solid transparent; box-shadow:none; white-space:nowrap; }
        #facilityPage .ag-theme-alpine .badge-use-y { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #facilityPage .ag-theme-alpine .badge-use-n { background:#f3f4f6; color:#6b7280; border-color:#d1d5db; }
        #facilityPage .ag-theme-alpine .badge-teal { background:#eef8f6; color:#245e55; border-color:#c8e3dd; }

        /* ── wide 모달 2컬럼 (공용시설 패턴 동일) ── */
        .modal-wide { width:min(920px,96vw) !important; max-width:920px !important; }
        .modal-wide .modal-body { max-height:76vh; overflow-y:auto; }
        .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line,#d7dce2); }
        .facility-modal-col-right { padding-left:20px; }
        .facility-col-label { font-size:11px; font-weight:800; color:#8a9a8e; letter-spacing:.5px; text-transform:uppercase; padding-bottom:8px; border-bottom:1px solid var(--line,#d7dce2); margin-bottom:14px; }
        #facilityPage .facility-location-row { display:grid; grid-template-columns:minmax(110px,1fr) minmax(0,2fr); gap:14px; }
        #facilityPage .facility-date-row { display:grid; grid-template-columns:minmax(220px,320px); gap:14px; }
        #facilityPage .facility-edit-only { display:none; }
        #facilityPage.is-edit-mode .facility-edit-only { display:grid; }
        #facilityPage .facility-type-control { display:grid; grid-template-columns:minmax(0,1fr) auto; align-items:center; gap:8px; }
        #facilityPage .facility-correction-guide { margin-top:5px; }
        #facilityPage .correction-inline-btn { flex-shrink:0; white-space:nowrap; }
        #facilityPage.is-edit-mode .correction-inline-btn { display:inline-flex; }
        #facilityPage .facility-use-row { grid-template-columns:1fr; }
        #facilityPage .facility-use-control { display:flex; align-items:center; gap:10px; min-width:0; min-height:32px; }
        #facilityPage .facility-use-status { font-size:12px; font-weight:800; color:#1f5a35; white-space:nowrap; }
        #facilityPage .facility-use-status.is-off { color:#7f1d1d; }
        #facilityPage .use-toggle { position:relative; display:inline-flex; width:46px; height:24px; flex-shrink:0; }
        #facilityPage .use-toggle input { position:absolute; opacity:0; pointer-events:none; }
        #facilityPage .use-toggle-slider { position:absolute; inset:0; border-radius:999px; background:#d1d5db; border:1px solid #c5cad3; cursor:pointer; transition:background .16s ease,border-color .16s ease; }
        #facilityPage .use-toggle-slider::after { content:""; position:absolute; width:18px; height:18px; left:2px; top:2px; border-radius:50%; background:#fff; box-shadow:0 1px 3px rgba(15,23,42,.2); transition:transform .16s ease; }
        #facilityPage .use-toggle input:checked + .use-toggle-slider { background:#2e5c38; border-color:#2e5c38; }
        #facilityPage .use-toggle input:checked + .use-toggle-slider::after { transform:translateX(22px); }
        #facilityPage .facility-use-guide { margin-top:0; }

        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
            #facilityPage .facility-location-row,
            #facilityPage .facility-date-row,
            #facilityPage .facility-use-row,
            #facilityPage .facility-type-control { grid-template-columns:1fr; }
        }
    </style>


    <script>
        <sec:authorize access="hasRole('ADMIN')" var="facilityAdmin" />
        window.facilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            /* ADMIN은 조회 전용. JSP 버튼 렌더링과 JS 방어에서 함께 사용한다. */
            isAdmin: ${facilityAdmin}
        };
    </script>
    <script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/AgRenderer.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/facility/mngr-facility-grid.js?v=facility-ui-20260511-02"></script>
    <script src="${pageContext.request.contextPath}/js/manager/facility/mngr-facility.js?v=facility-ui-20260511-02"></script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="facilityPage">
                <div class="page-header">
                    <div class="page-title-block"><h2>시설자산 관리</h2><p>단지 내 시설자산 마스터 정보를 등록·조회·관리합니다</p></div>
                    <div class="page-actions"><%-- 목록 상단 오른쪽으로 등록/엑셀 버튼을 모아둔다. --%></div>
                </div>

                <div class="asset-summary-row">
                    <div class="asset-summary-card primary"><div class="summary-icon"><span class="material-symbols-rounded">apartment</span></div><div><div class="summary-label">전체 시설 총수</div><div class="summary-value" id="statTotal">0</div></div></div>
                    <div class="asset-summary-card"><div class="summary-icon"><span class="material-symbols-rounded">domain</span></div><div><div class="summary-label">동 지정 시설</div><div class="summary-value" id="statDong">0</div></div></div>
                    <div class="asset-summary-card"><div class="summary-icon"><span class="material-symbols-rounded">location_city</span></div><div><div class="summary-label">공용 위치 시설</div><div class="summary-value" id="statCommonLoc">0</div></div></div>
                    <%-- 이용불가 시설: USE_YN='N' 전체 + 오늘 FAULT 판정 건수 --%>
                    <div class="asset-summary-card"><div class="summary-icon"><span class="material-symbols-rounded">block</span></div><div><div class="summary-label">이용불가 시설</div><div class="summary-value" id="statDisabled">0</div><div style="font-size:11px;color:#9caa9e;margin-top:2px;" id="statDisabledToday"></div></div></div>
                </div>

                <%-- 시설종류 탭: 서버 API는 그대로 사용하고, JS에서 facilityKind 값만 바꿔 조회한다. --%>
                <div class="facility-tab-row tab-bar" role="tablist" aria-label="시설종류 선택">
                    <button type="button" class="facility-tab-btn tab-btn active" data-action="setFacilityTab" data-kind="FACILITY" id="facilityTabFacility">
                        <span class="material-symbols-rounded">engineering</span>일반시설
                    </button>
                    <button type="button" class="facility-tab-btn tab-btn" data-action="setFacilityTab" data-kind="PUBLIC" id="facilityTabPublic">
                        <span class="material-symbols-rounded">groups</span>편의시설
                    </button>
                </div>

                <div class="panel facility-filter-panel">
                    <div class="panel-header"><h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3></div>
                    <div class="panel-body">
                        <%--
                            검색 항목과 목록 컬럼 기준을 맞춘다.
                            - 위치 조건: 동
                            - 상태 조건: 운영상태
                            - 시설종류: 상단 탭(일반시설/편의시설)에서 선택
                            - 분류 조건: 시설유형
                            - 통합검색: 시설번호 / 시설명 / 상세위치
                        --%>
                        <div class="facility-filter-grid">
                            <div class="form-field"><label class="field-label">시설유형</label><select class="form-select" id="filterFacTy" name="facilityTyCd"><option value="">전체</option><option value="ELV">승강기</option><option value="WTR">급수시설</option><option value="ELC">전기시설</option><option value="GAS">가스시설</option><option value="FIRE">소방시설</option><option value="SEC">보안시설</option><option value="ETC">기타시설</option></select></div>
                            <div class="form-field"><label class="field-label">운영상태</label><select class="form-select" id="filterUseYn" name="useYn"><option value="">전체</option><option value="Y">사용 가능</option><option value="N">사용 불가</option></select></div>
                            <div class="form-field"><label class="field-label">동</label><select class="form-select" id="filterDong" name="dongNo"><option value="">전체</option><c:forEach var="dong" items="${dongList}"><option value="${dong.dongNo}">${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}</option></c:forEach><option value="_COMMON_">공용 위치</option></select></div>
                            <div class="form-field facility-search-field"><label class="field-label">시설 검색</label><div class="search-wrap"><span class="material-symbols-rounded">search</span><input type="text" class="form-input" id="filterKeyword" name="keyword" autocomplete="off" placeholder="시설번호 · 시설명 · 상세위치 검색"><div class="facility-search-suggest" id="facilitySuggestList"></div></div></div>
                            <div class="form-field"><label class="field-label">&nbsp;</label><div class="page-actions"><button type="button" class="btn btn-secondary btn-sm" data-action="resetFacility">초기화</button><button type="button" class="btn btn-primary btn-sm" data-action="searchFacility">검색</button></div></div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div class="list-header-left"><h3 class="panel-title"><span class="material-symbols-rounded">apartment</span>시설자산 목록</h3><span class="list-count" id="facilityCount">0건</span><span class="result-desc" id="resultDesc">전체 조건</span></div>
                        <div class="list-header-right">
                            <button type="button" class="btn btn-secondary btn-sm" data-action="exportExcel"><span class="material-symbols-rounded">download</span>엑셀 다운로드</button>
                            <%-- ADMIN은 조회 전용이므로 시설 등록 버튼을 렌더링하지 않는다. --%>
                            <sec:authorize access="!hasRole('ADMIN')">
                                <button type="button" class="btn btn-primary btn-sm" data-action="openRegister"><span class="material-symbols-rounded">add</span>시설 등록</button>
                            </sec:authorize>
                        </div>
                    </div>
                    <div class="facility-grid-wrap"><div id="facilityGrid" class="ag-theme-alpine"></div></div>
                    <%-- 편의시설 안내: 시설자산 목록에서 함께 조회되며, 상세 관리는 편의시설 관리 화면에서 진행한다. --%>
                    <div style="display:flex;align-items:center;gap:8px;padding:10px 16px;border-top:1px solid var(--line);background:#f8f9fb;font-size:12px;color:#6b7a6e;">
                        <span class="material-symbols-rounded" style="font-size:15px;color:#2e5c38;flex-shrink:0;">info</span>
                        헬스장·독서실 등 편의시설에 대한 운영 관리는 편의시설 관리에서 진행합니다.
                        <a href="${pageContext.request.contextPath}/manager/publicFacilityList" style="color:#2e5c38;font-weight:700;text-decoration:none;margin-left:4px;">편의시설 관리 →</a>
                    </div>
                </div>

                <%-- ══ 등록·수정 모달 (wide 2컬럼)
                     좌: 시설 기본정보 + 운영상태(수정 모드만)
                     우: 시설 사진 + 등록 후 연결 안내
                     시설유형 정정 버튼: 수정 모드에서 시설유형 필드 옆에 인라인 배치
                ══ --%>
                <div class="modal-overlay" id="facilityModal">
                    <div class="modal modal-wide">
                        <div class="modal-header primary">
                            <h3 class="modal-title" id="facilityModalTitle">시설 등록</h3>
                            <button type="button" class="modal-close" data-modal-close><span class="material-symbols-rounded">close</span></button>
                        </div>
                        <form id="facilityForm" enctype="multipart/form-data">
                            <input type="hidden" id="facilityNo" name="facilityNo">
                            <input type="hidden" id="fileGroupNo" name="fileGroupNo">
                            <input type="hidden" id="useYn" name="useYn" value="Y">
                            <div class="modal-body">

                                <%-- 등록 안내 (등록 모드에서만 표시) --%>
                                <div class="form-section register-guide" style="margin-bottom:14px;">
                                    <div class="notice-box">
                                        <span class="material-symbols-rounded">info</span>
                                        <div>시설 기본정보(시설명·시설유형·위치·설치일자)를 등록합니다.<br>
                                            <strong>시설유형은 계약·점검·검침 데이터가 연결되면 변경할 수 없으니 처음 등록 시 정확하게 선택하세요.</strong><br>
                                            헬스장·독서실 등 편의시설 등록은 <a href="${pageContext.request.contextPath}/manager/publicFacilityList" style="color:#2e5c38;font-weight:700;">편의시설 관리</a>에서 진행합니다.</div>
                                    </div>
                                </div>

                                <%-- 수정 안내 (수정 모드에서만 표시) --%>
                                <div class="form-section edit-guide" style="margin-bottom:14px;">
                                    <div class="notice-box">
                                        <span class="material-symbols-rounded">lock</span>
                                        <div><strong>오등록 보정 목적의 수정입니다</strong><br>
                                            시설명·설치일자·동·상세위치는 오등록 보정 목적으로만 수정합니다.<br>
                                            시설유형 변경이 필요한 경우 아래 시설유형 정정 버튼을 이용하세요.</div>
                                    </div>
                                </div>

                                <div class="facility-modal-cols">

                                    <%-- 좌: 시설 기본정보 --%>
                                    <div class="facility-modal-col-left">
                                        <div class="facility-col-label">시설 정보</div>

                                        <div class="form-section">
                                            <div class="form-section-title"><span class="material-symbols-rounded">apartment</span>시설 기본정보</div>

                                            <div class="form-row cols-1">
                                                <div class="form-field">
                                                    <label class="field-label">시설명 <span class="req">*</span></label>
                                                    <input type="text" class="form-input" id="facilityNm" name="facilityNm" placeholder="예) 1호기 승강기" required>
                                                </div>
                                            </div>

                                            <div class="form-row facility-location-row">
                                                <div class="form-field">
                                                    <label class="field-label">동 <small style="font-weight:400;color:#9caa9e;font-size:10px;">(없으면 공용 위치)</small></label>
                                                    <select class="form-select" id="dongNo" name="dongNo">
                                                        <option value="">선택 (없음)</option>
                                                        <c:forEach var="dong" items="${dongList}">
                                                            <option value="${dong.dongNo}">${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="form-field">
                                                    <label class="field-label">상세위치</label>
                                                    <input type="text" class="form-input" id="locCn" name="locCn" placeholder="예) 지하주차장 B2 A구역">
                                                </div>
                                            </div>

                                            <div class="form-row facility-date-row">
                                                <div class="form-field">
                                                    <label class="field-label">설치일자</label>
                                                    <input type="date" class="form-input" id="instlDt" name="instlDt">
                                                </div>
                                            </div>

                                            <div class="form-row cols-1">
                                                <div class="form-field">
                                                    <label class="field-label">시설유형 <span class="req">*</span></label>
                                                    <div class="facility-type-control">
                                                        <select class="form-select" id="facilityTyCd" name="facilityTyCd" required>
                                                            <option value="">선택</option>
                                                            <option value="ELV">ELV · 승강기</option>
                                                            <option value="WTR">WTR · 급수시설</option>
                                                            <option value="ELC">ELC · 전기시설</option>
                                                            <option value="GAS">GAS · 가스시설</option>
                                                            <option value="FIRE">FIRE · 소방시설</option>
                                                            <option value="SEC">SEC · 보안시설</option>
                                                            <option value="ETC">ETC · 기타시설</option>
                                                        </select>
                                                        <button type="button" class="btn btn-secondary btn-sm correction-inline-btn facility-edit-only" id="facilityCorrectionBtn" data-action="openCorrection">
                                                            <span class="material-symbols-rounded">edit_note</span>시설유형 정정
                                                        </button>
                                                    </div>
                                                    <div class="facility-correction-guide">
                                                        <div class="field-help">시설유형은 시설 분류 및 후속 관리 기준입니다.</div>
                                                        <div class="field-help lock">시설유형 정정이 필요하면 정정 버튼을 눌러 변경 가능 여부를 확인하세요.</div>
                                                        <div id="correctionGuide" style="display:none;">
                                                            <div class="field-help" style="color:#7c2d12;font-weight:700;">정정 가능 · 변경할 시설유형을 선택하고 저장하세요.</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="form-row facility-use-row facility-edit-only">
                                                <div class="form-field">
                                                    <label class="field-label">사용 가능 여부</label>
                                                    <div class="facility-use-control">
                                                        <label class="use-toggle" for="useYnToggle">
                                                            <input type="checkbox" id="useYnToggle" checked>
                                                            <span class="use-toggle-slider"></span>
                                                        </label>
                                                        <span class="facility-use-status" id="useYnStatusText">사용 가능</span>
                                                    </div>
                                                    <div class="field-help facility-use-guide">FAULT 판정 시 자동으로 사용 불가 처리됩니다. 복구 시 사용 가능으로 변경하세요.</div>
                                                </div>
                                            </div>
                                        </div>

                                    </div><%-- /facility-modal-col-left --%>

                                    <%-- 우: 시설 사진 + 연결 안내 --%>
                                    <div class="facility-modal-col-right">
                                        <div class="facility-col-label">사진 &amp; 연결</div>

                                        <div class="form-section">
                                            <div class="form-section-title"><span class="material-symbols-rounded">image</span>시설 사진</div>
                                            <div class="file-upload-box">
                                                <div class="file-upload-title"><span class="material-symbols-rounded">upload_file</span>사진 등록/추가</div>
                                                <div class="file-upload-desc" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                                <input type="file" class="form-input" id="facilityFiles" name="facilityFiles" accept="image/*" multiple>
                                                <div class="file-preview-list" id="facilityFilePreview" style="margin-top:8px;">
                                                    <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                                </div>
                                            </div>
                                            <%-- 기존 등록 사진 관리 (수정 모드에서만 의미 있음) --%>
                                            <div class="file-manage-list" id="facilityFileManageList" style="margin-top:8px;">
                                                <div class="file-preview-empty">기존 등록 사진은 수정 모드에서 표시됩니다.</div>
                                            </div>
                                            <input type="hidden" id="deleteFileUuids" name="deleteFileUuids">
                                        </div>

                                        <div class="form-section">
                                            <div class="form-section-title"><span class="material-symbols-rounded">link</span>등록 후 연결 안내</div>
                                            <div class="notice-box">
                                                <span class="material-symbols-rounded">info</span>
                                                <div>이 화면에서는 기본정보만 등록합니다.<br>
                                                    · 계약 체결 → <a href="${pageContext.request.contextPath}/manager/facility/contractList" style="color:#2e5c38;font-weight:700;">계약 관리</a><br>
                                                    · 점검이력 → <a href="${pageContext.request.contextPath}/manager/checkHistory" style="color:#2e5c38;font-weight:700;">유지보수·점검 이력</a><br>
                                                    · 검침 연결 → <a href="${pageContext.request.contextPath}/manager/facility/partnerList" style="color:#2e5c38;font-weight:700;">협력업체 관리</a></div>
                                            </div>
                                        </div>
                                    </div>

                                </div><%-- /facility-modal-cols --%>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-modal-close>취소</button>
                                <button type="submit" class="btn btn-primary" id="facilitySaveBtn">저장</button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="modal-overlay" id="facilityDetailModal">
                    <div class="modal modal-lg">
                        <div class="modal-header primary"><h3 class="modal-title" id="detailModalTitle">시설 상세</h3><button type="button" class="modal-close" data-modal-close><span class="material-symbols-rounded">close</span></button></div>
                        <div class="modal-body">
                            <%-- 이용불가 사유: USE_YN='N' 시설만 표시, JS에서 latestFaultDt 기준으로 노출 제어 --%>
                            <div class="form-section" id="detailDisabledSection" style="display:none;">
                                <div class="form-section-title"><span class="material-symbols-rounded">block</span>이용불가 사유</div>
                                <div style="display:flex;gap:10px;padding:11px 13px;background:#fff5f5;border-left:3px solid #ef4444;border-top:1px solid #fecaca;border-bottom:1px solid #fecaca;border-right:1px solid #fecaca;border-radius:0 4px 4px 0;font-size:12px;color:#7f1d1d;line-height:1.6;">
                                    <span class="material-symbols-rounded" style="color:#dc2626;font-size:17px;flex-shrink:0;margin-top:2px;">warning</span>
                                    <div id="detailDisabledReason"></div>
                                </div>
                            </div>
                            <div class="form-section"><div class="form-section-title"><span class="material-symbols-rounded">apartment</span>시설 기본정보</div><div class="mngr-detail-grid" id="detailBasicGrid"></div></div>
                            <div class="form-section" id="detailFileSection"><div class="form-section-title"><span class="material-symbols-rounded">image</span>시설 사진</div><div class="file-preview-list" id="detailFileList"><div class="file-preview-empty">등록된 사진이 없습니다.</div></div></div>
                            <div class="form-section" id="detailContSection"><div class="form-section-title"><span class="material-symbols-rounded">description</span>최근 계약 정보</div><div class="detail-summary"><div class="ds-header"><span>최신 계약 1건</span><a href="${pageContext.request.contextPath}/manager/facility/contractList" id="contMoreLink">전체보기 →</a></div><div class="ds-body" id="detailContBody"></div></div></div>
                            <div class="form-section" id="detailChkSection"><div class="form-section-title"><span class="material-symbols-rounded">fact_check</span>최근 점검이력</div><div class="detail-summary"><div class="ds-header"><span>최근 3건</span><a href="${pageContext.request.contextPath}/manager/checkHistory" id="chkMoreLink">전체보기 →</a></div><div class="ds-body" id="detailChkBody"></div></div></div>
                            <div class="form-section" id="detailMeterSection"><div class="form-section-title"><span class="material-symbols-rounded">electric_meter</span>검침 연결 정보</div><div class="detail-summary"><div class="ds-header"><span>검침 연결 정보</span><a href="${pageContext.request.contextPath}/manager/checkHistory">검침기록 보기 →</a></div><div class="ds-body" id="detailMeterBody"></div></div></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-modal-close>닫기</button>
                            <%-- ADMIN은 조회 전용이므로 상세 모달에서도 수정 진입 버튼을 숨긴다. --%>
                            <sec:authorize access="!hasRole('ADMIN')">
                                <button type="button" class="btn btn-primary" data-action="editFromDetail" id="detailEditBtn">수정하기</button>
                            </sec:authorize>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    /* ============================================================
       시설 사진 선택/삭제 표시 보조 스크립트
       - 실제 업로드/삭제 처리는 mngr-facility.js와 Controller/Service에서 처리
       - 이 스크립트는 화면 깨짐 없이 파일 미리보기와 삭제대상 hidden 값만 관리
    ============================================================ */
    document.addEventListener("DOMContentLoaded", function () {
        const fileInput = document.getElementById("facilityFiles");
        const previewArea = document.getElementById("facilityFilePreview");
        const deleteFileUuids = document.getElementById("deleteFileUuids");

        if (fileInput && previewArea) {
            fileInput.addEventListener("change", function () {
                previewArea.innerHTML = "";

                if (!fileInput.files || fileInput.files.length === 0) {
                    previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
                    return;
                }

                Array.from(fileInput.files).forEach(function (file) {
                    const item = document.createElement("div");
                    item.className = "file-preview-item";

                    if (file.type && file.type.indexOf("image/") === 0) {
                        const img = document.createElement("img");
                        img.alt = file.name;
                        img.src = URL.createObjectURL(file);
                        item.appendChild(img);
                    }

                    const name = document.createElement("div");
                    name.className = "file-preview-name";
                    name.textContent = file.name;
                    item.appendChild(name);

                    previewArea.appendChild(item);
                });
            });
        }

        document.addEventListener("change", function (event) {
            if (!event.target.classList.contains("js-delete-file-check")) return;

            const checkedValues = Array.from(document.querySelectorAll(".js-delete-file-check:checked"))
                .map(function (checkbox) { return checkbox.value; });

            if (deleteFileUuids) {
                deleteFileUuids.value = checkedValues.join(",");
            }아니
        });
    });
</script>
</body>
</html>
