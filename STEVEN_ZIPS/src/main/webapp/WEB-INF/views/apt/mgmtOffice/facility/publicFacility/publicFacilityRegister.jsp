<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설 등록</title>
    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #publicFacilityPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f3f5f3; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #publicFacilityPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityPage .page-title-block p  { color:var(--text-sec); font-size:12px; }
        #publicFacilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityPage .panel-body .form-input, #publicFacilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #publicFacilityPage .panel-body .form-input:focus, #publicFacilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityPage .panel-body .form-input[readonly] { background:var(--surface-sub); color:var(--text-pri); opacity:1; cursor:default; }
        #publicFacilityPage .panel-body .form-input:disabled, #publicFacilityPage .panel-body .form-select:disabled { background:#f4f5f6; color:#9ca3af; cursor:not-allowed; }
        #publicFacilityPage .panel-body .form-textarea { font-size:12px; border-color:var(--line); border-radius:4px; resize:vertical; }
        #publicFacilityPage .panel-body .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityPage .btn { border-radius:4px; }
        #publicFacilityPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:var(--text-sec); line-height:1.6; }
        #publicFacilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #publicFacilityPage .form-guide-line { margin-bottom:12px; padding:9px 11px; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; background:#f8f9fb; color:var(--text-sec); font-size:12px; line-height:1.5; }
        #publicFacilityPage .field-help { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.5; }
        .form-section-title { display:flex; align-items:center; gap:4px; font-size:11px; font-weight:800; color:var(--text-sec,#4a5c4e); letter-spacing:0; text-transform:none; margin-bottom:10px; }
        .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent,#2e5c38); }

        /* 2컬럼 레이아웃 — 좌우 동일 높이 */
        .facility-modal-cols { display:grid; grid-template-columns:calc(50% - 10px) calc(50% - 10px); gap:0 20px; align-items:stretch; }
        .facility-modal-col-left { border-right:1px solid var(--line,#d7dce2); display:flex; flex-direction:column; padding-right:20px; min-width:0; overflow:hidden; }
        .facility-modal-col-right { display:flex; flex-direction:column; padding-left:0; min-width:0; }
        .facility-col-label { font-size:11px; font-weight:700; color:#8a9a8e; letter-spacing:.4px; text-transform:uppercase; padding-bottom:8px; border-bottom:1px solid var(--line,#d7dce2); margin-bottom:14px; }

        /* 우측 컬럼 마지막 섹션이 남은 공간을 채우도록 */
        .facility-modal-col-right > .form-section:last-child { }

        /* 시설자산 연결 영역 */
        #publicFacilityPage .asset-link-section { padding:12px; border:1px solid var(--line); border-radius:4px; background:#f8f9fb; }
        #publicFacilityPage .asset-link-section .form-section-title { margin-bottom:10px; }
        #publicFacilityPage .asset-link-section .form-input,
        #publicFacilityPage .asset-link-section .form-select { background:#fff; }
        #publicFacilityPage .asset-link-section .selected-facility-box.is-selected { background:#fff; }
        #publicFacilityPage .asset-link-section .selected-empty { min-height:78px; }
        #publicFacilityPage .asset-link-section .field-help { color:var(--text-ter); }

        /* 등록 방식 탭 */
        #publicFacilityPage .mode-tabs { display:grid; grid-template-columns:1fr 1fr; gap:6px; margin-bottom:14px; }
        #publicFacilityPage .mode-tab { display:flex; align-items:center; justify-content:center; gap:5px; height:34px; border:1px solid var(--line); border-radius:4px; background:var(--surface); color:var(--text-sec); font-size:12px; font-weight:600; cursor:pointer; }
        #publicFacilityPage .mode-tab .material-symbols-rounded { font-size:16px; }
        #publicFacilityPage .mode-tab.is-active { border-color:var(--accent); background:var(--accent-light); color:var(--accent); font-weight:700; }
        #publicFacilityPage .mode-panel { display:none; }
        #publicFacilityPage .mode-panel.is-active { display:block; }

        /* 선택된 시설자산 요약 */
        #publicFacilityPage .selected-facility-box { border:none; border-radius:0; background:none; padding:0; }
        #publicFacilityPage .selected-facility-box.is-selected { border:1px solid var(--line); border-radius:4px; padding:12px; }
        #publicFacilityPage .selected-empty { display:flex; align-items:center; justify-content:center; flex-direction:column; gap:5px; min-height:92px; color:var(--text-ter); font-size:12px; text-align:center; }
        #publicFacilityPage .selected-empty .material-symbols-rounded { font-size:24px; color:#a7b2aa; }
        #publicFacilityPage .selected-summary { display:none; }
        #publicFacilityPage .selected-summary.is-active { display:block; }
        #publicFacilityPage .selected-head { display:flex; align-items:center; justify-content:space-between; gap:8px; margin-bottom:10px; }
        #publicFacilityPage .selected-name { font-size:13px; font-weight:700; color:var(--text-pri); }
        #publicFacilityPage .selected-code { font-size:11px; color:var(--text-ter); }
        #publicFacilityPage .selected-grid { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:10px; }
        #publicFacilityPage .selected-item { min-height:44px; padding:8px 9px; border:1px solid var(--line); border-radius:4px; background:var(--surface-sub); }
        #publicFacilityPage .selected-label { display:block; margin-bottom:3px; font-size:10px; font-weight:600; color:var(--text-ter); }
        #publicFacilityPage .selected-value { display:block; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; font-size:12px; font-weight:500; color:var(--text-pri); }

        /* 선택 완료 후 시설자산 요약 */
        #publicFacilityPage .selected-facility-box.is-selected { padding:10px 12px; background:#fff; }
        #publicFacilityPage .selected-line-box { display:flex; align-items:center; justify-content:space-between; gap:10px; min-height:34px; }
        #publicFacilityPage .selected-line-main { min-width:0; display:flex; align-items:center; gap:7px; color:var(--text-sec); font-size:12px; font-weight:500; line-height:1.45; white-space:nowrap; overflow:hidden; }
        #publicFacilityPage .selected-line-main .material-symbols-rounded { flex-shrink:0; font-size:16px; color:#9aa5a0; }
        #publicFacilityPage .selected-line-text { display:block; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .selected-line-box .btn { flex-shrink:0; height:28px; min-height:28px; padding:0 10px; font-size:11px; }
        #publicFacilityPage .selected-hidden-values { display:none; }

        /* 시설자산 선택 모달 */
        .facility-select-modal { display:none !important; position:fixed !important; inset:0 !important; z-index:9500 !important; background:rgba(16,24,20,.48); align-items:center; justify-content:center; padding:28px; box-sizing:border-box; }
        .facility-select-modal.is-open { display:flex !important; }
        #publicFacilityPage .facility-select-box { width:min(920px, 94vw); max-height:86vh; display:flex; flex-direction:column; border-radius:3px; background:#fff; border:1px solid rgba(215,220,226,.95); box-shadow:0 22px 52px rgba(0,0,0,.22); overflow:hidden; }
        #publicFacilityPage .facility-select-head { display:flex; align-items:center; justify-content:space-between; gap:12px; padding:15px 18px; border-bottom:1px solid var(--line); background:var(--surface); }
        #publicFacilityPage .facility-select-title { display:flex; align-items:center; gap:7px; margin:0; font-size:14px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .facility-select-title .material-symbols-rounded { color:var(--accent); font-size:18px; }
        #publicFacilityPage .facility-select-close { width:30px; height:30px; border:0; border-radius:4px; background:transparent; color:#4b5563; cursor:pointer; }
        #publicFacilityPage .facility-select-close:hover { background:#edf2ee; color:var(--accent); }
        #publicFacilityPage .facility-select-body { padding:14px 16px 16px; overflow:auto; }
        #publicFacilityPage .candidate-summary-row { display:flex; align-items:center; justify-content:flex-start; gap:6px; margin-bottom:10px; }
        #publicFacilityPage .candidate-count { display:inline-flex; align-items:center; gap:5px; height:28px; padding:0 10px; border:1px solid var(--line); border-radius:4px; background:var(--surface-sub); font-size:12px; color:var(--text-sec); }
        #publicFacilityPage .candidate-count strong { color:var(--accent); font-weight:800; }
        #publicFacilityPage .candidate-filter { display:grid; grid-template-columns:1.4fr .9fr .9fr auto; gap:7px; margin-bottom:10px; padding:10px; border:1px solid var(--line); border-radius:6px; background:var(--surface-sub); }
        #publicFacilityPage .candidate-table-wrap { border:1px solid var(--line); border-radius:6px; overflow:hidden; background:#fff; }
        #publicFacilityPage .candidate-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #publicFacilityPage .candidate-table th { height:34px; padding:0 10px; border-bottom:1px solid var(--line); background:#f3f5f3; color:var(--text-sec); font-size:11px; font-weight:600; text-align:left; }
        #publicFacilityPage .candidate-table td { height:42px; padding:7px 10px; border-bottom:1px solid var(--line); color:var(--text-pri); font-size:12px; vertical-align:middle; }
        #publicFacilityPage .candidate-table tbody tr:last-child td { border-bottom:0; }
        #publicFacilityPage .candidate-table tbody tr:hover { background:var(--accent-dim); }
        #publicFacilityPage .candidate-table .candidate-hidden { display:none; }
        #publicFacilityPage .candidate-table .cell-center { text-align:center; }
        #publicFacilityPage .candidate-name-main { display:block; font-size:12px; font-weight:600; color:var(--text-pri); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .candidate-name-sub { display:block; margin-top:2px; font-size:11px; color:var(--text-ter); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .candidate-empty-row td { height:68px; text-align:center; color:var(--text-ter); }
        #publicFacilityPage .badge-mini { display:inline-flex; align-items:center; height:22px; padding:0 8px; border-radius:4px; font-size:11px; font-weight:600; }
        #publicFacilityPage .badge-use-y { background:#dceee0; color:#1f7a3f; }
        #publicFacilityPage .badge-use-n { background:#fee2e2; color:#b42318; }

        /* 사진 업로드 */
        #publicFacilityPage .file-upload-box { border:1px dashed var(--line); border-radius:4px; padding:12px; background:#fafcfb; }
        #publicFacilityPage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:800; color:var(--text-sec); }
        #publicFacilityPage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #publicFacilityPage .file-upload-desc { font-size:11px; color:var(--text-ter); line-height:1.5; }
        #publicFacilityPage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #publicFacilityPage .file-preview-item { position:relative; min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #publicFacilityPage .file-preview-item img { width:100%; height:92px; object-fit:cover; display:block; cursor:zoom-in; }
        #publicFacilityPage .file-preview-name { padding:6px 7px; font-size:11px; color:var(--text-sec); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; border-top:1px solid var(--line); }
        #publicFacilityPage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:var(--text-ter); }
        #publicFacilityPage .file-manage-list { display:flex; flex-direction:column; gap:7px; margin-top:8px; }
        #publicFacilityPage .file-manage-row { display:flex; align-items:center; gap:10px; padding:8px 10px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #publicFacilityPage .file-thumb { width:48px; height:48px; border-radius:4px; border:1px solid var(--line); object-fit:cover; background:#f4f7f4; flex-shrink:0; cursor:zoom-in; }
        #publicFacilityPage .file-info { min-width:0; flex:1; }
        #publicFacilityPage .file-name { font-size:12px; font-weight:700; color:#111827; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #publicFacilityPage .file-meta { margin-top:2px; font-size:11px; color:var(--text-ter); }
        #publicFacilityPage .file-delete-check { display:inline-flex; align-items:center; gap:4px; font-size:11px; color:#7f1d1d; font-weight:700; }
        #publicFacilityPage .file-delete-check input { width:14px; height:14px; }

        /* 운영시간 입력 */
        #publicFacilityPage .opr-time-box { display:flex; flex-direction:column; gap:8px; padding:10px; border:1px solid var(--line); border-radius:4px; background:#fafcfb; }
        #publicFacilityPage .opr-time-row { display:grid; grid-template-columns:64px minmax(0,1fr) 64px minmax(0,.7fr) 16px minmax(0,.7fr); gap:7px; align-items:center; }
        #publicFacilityPage .opr-day-range { display:grid; grid-template-columns:minmax(0,1fr) 16px minmax(0,1fr); gap:7px; align-items:center; min-width:0; }
        #publicFacilityPage .opr-time-label { font-size:11px; font-weight:600; color:var(--text-sec); white-space:nowrap; }
        #publicFacilityPage .opr-time-separator { text-align:center; font-size:12px; font-weight:500; color:var(--text-ter); }
        #publicFacilityPage .opr-preview-row { display:grid; grid-template-columns:64px 1fr; gap:7px; align-items:center; }
        #publicFacilityPage .opr-preview { min-height:30px; padding:6px 9px; display:flex; align-items:center; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; font-weight:700; color:var(--text-pri); }
        #publicFacilityPage .opr-preview.is-empty { color:var(--text-ter); font-weight:500; }
        #publicFacilityPage .opr-time-notice { min-height:17px; padding-left:71px; font-size:11px; line-height:1.5; color:#b45309; }
        #publicFacilityPage .opr-time-notice:empty { display:none; }
        @media (max-width:1100px) {
            #publicFacilityPage .opr-time-row { grid-template-columns:64px minmax(0,1fr); }
            #publicFacilityPage .opr-preview-row { grid-template-columns:64px minmax(0,1fr); }
            #publicFacilityPage .opr-time-notice { padding-left:71px; }
        }

        /* 새 시설자산 위치 선택 인라인 */
        #publicFacilityPage .location-select-row { display:grid; grid-template-columns:1.1fr .75fr .75fr .75fr; gap:8px; align-items:end; }
        #publicFacilityPage .location-help-row { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.5; }
        #publicFacilityPage .location-detail-row { margin-top:10px; }
        @media (max-width:900px) {
            #publicFacilityPage .location-select-row { grid-template-columns:1fr 1fr; }
        }

        /* 편의시설 자원 안내 */
        #publicFacilityPage .item-guide-list { display:flex; flex-direction:column; gap:10px; margin-top:8px; }
        #publicFacilityPage .item-guide-row { display:flex; align-items:center; justify-content:space-between; gap:14px; padding:11px 12px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #publicFacilityPage .item-guide-main { font-size:12px; font-weight:600; color:var(--text-pri); }
        #publicFacilityPage .item-guide-sub { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.55; }
        #publicFacilityPage .item-guide-badge { display:inline-flex; align-items:center; height:24px; padding:0 9px; border-radius:4px; background:var(--accent-light); color:var(--accent); font-size:11px; font-weight:600; white-space:nowrap; }

        @media (max-width:1180px) {
            #publicFacilityPage .opr-operation-grid,
            #publicFacilityPage .opr-operation-grid.is-custom-active { grid-template-columns:1fr; grid-template-areas:"day" "custom" "time"; }
            #publicFacilityPage .opr-day-type-control,
            #publicFacilityPage .opr-time-control,
            #publicFacilityPage .opr-custom-day-row { max-width:none; min-width:0; }
            #publicFacilityPage .opr-preview-row { grid-template-columns:64px 1fr; }
            #publicFacilityPage .opr-time-notice { padding-left:71px; }
        }
        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
            #publicFacilityPage .candidate-filter { grid-template-columns:1fr; }
            #publicFacilityPage .selected-grid { grid-template-columns:1fr; }
        }
    </style>

    <script>
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            preselectFacilityNo: "${param.facilityNo}"
        };
    </script>
</head>
<body>
<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/publicFacility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="편의시설 관리" />
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
        <main class="main-content">
            <div class="office-page" id="publicFacilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설 등록</h2>
                        <p>기존 시설자산을 운영관리 대상으로 연결하거나, 새 시설자산과 편의시설 운영정보를 함께 등록합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>편의시설 정보 입력</h3>
                    </div>

                    <form id="registerForm" method="post" action="${pageContext.request.contextPath}/manager/publicFacility/insert/${mgmtOfcNo}" enctype="multipart/form-data">
                        <sec:csrfInput/>
                        <input type="hidden" id="registerMode" name="registerMode" value="EXISTING">
                        <input type="hidden" id="selectedFacilityNo" name="facilityNo" value="${param.facilityNo}">
                        <input type="hidden" id="deleteFileUuids" name="deleteFileUuids">

                        <div class="panel-body">
                            <div class="facility-modal-cols">
                                <%-- 좌측: 시설자산 연결 + 운영정보 --%>
                                <div class="facility-modal-col-left">
                                    <%-- 안내 문구: 간결하게 정리 --%>
                                    <div class="form-guide-line">
                                        기존 시설자산에 연결하거나 새 시설자산을 함께 등록할 수 있습니다. 등록한 사진은 시설자산 관리에서도 함께 확인됩니다.
                                    </div>

                                    <div class="mode-tabs" role="tablist" aria-label="편의시설 등록 방식 선택">
                                        <button type="button" class="mode-tab is-active" data-mode="EXISTING" role="tab" aria-selected="true">
                                            <span class="material-symbols-rounded">link</span>기존 시설자산 연결
                                        </button>
                                        <button type="button" class="mode-tab" data-mode="NEW" role="tab" aria-selected="false">
                                            <span class="material-symbols-rounded">add_business</span>연결할 새 시설자산 등록
                                        </button>
                                    </div>

                                    <%-- 기존 시설자산 연결 탭 --%>
                                    <div class="mode-panel is-active" id="existingFacilityPanel" data-mode-panel="EXISTING">
                                        <div class="form-section asset-link-section" style="margin-bottom:14px;">
                                            <div class="form-section-title">
                                                <span class="material-symbols-rounded">fact_check</span>기존 시설자산 연결
                                            </div>

                                            <div class="selected-facility-box">
                                                <div class="selected-empty" id="selectedEmptyBox">
                                                    <span class="material-symbols-rounded">domain_add</span>
                                                    <div>편의시설 운영정보를 연결할 시설자산을 선택하세요.</div>
                                                    <button type="button" class="btn btn-secondary" id="openFacilityModalBtn">연결할 시설자산 선택</button>
                                                </div>

                                                <div class="selected-summary" id="selectedSummaryBox">
                                                    <div class="selected-line-box">
                                                        <div class="selected-line-main">
                                                            <span class="material-symbols-rounded">link</span>
                                                            <span class="selected-line-text" id="selectedAssetLineText" title="-">-</span>
                                                        </div>
                                                        <button type="button" class="btn btn-secondary" id="changeFacilityBtn">다시 선택</button>
                                                    </div>

                                                    <div class="selected-hidden-values" aria-hidden="true">
                                                        <span id="selectedFacilityNmText">-</span>
                                                        <span id="selectedFacilityNoText">-</span>
                                                        <span id="selectedFacilityTyText">-</span>
                                                        <span id="selectedLocationText">-</span>
                                                        <span id="selectedUseYnText">-</span>
                                                    </div>

                                                    <div class="field-help">등록한 사진은 연결된 시설자산의 사진으로 함께 관리됩니다.</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- 연결할 새 시설자산 등록 탭 --%>
                                    <div class="mode-panel" id="newFacilityPanel" data-mode-panel="NEW">
                                        <div class="form-section asset-link-section" style="margin-bottom:14px;">
                                            <div class="form-section-title">
                                                <span class="material-symbols-rounded">apartment</span>연결할 새 시설자산 정보
                                            </div>

                                            <div class="form-row cols-2">
                                                <div class="form-field">
                                                    <label class="field-label">시설명 <span class="req">*</span></label>
                                                    <input type="text" class="form-input" id="regFacilityNm" name="facilityNm" placeholder="예) 헬스장">
                                                </div>
                                                <div class="form-field">
                                                    <label class="field-label">시설유형</label>
                                                    <select class="form-select" id="regFacilityTyCd" name="facilityTyCd">
                                                        <c:forEach var="type" items="${publicFacilityTypeList}">
                                                            <option value="${type.code}">${type.codeNm}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="location-select-row">
                                                <div class="form-field">
                                                    <label class="field-label">위치 구분</label>
                                                    <select class="form-select" id="regLocationType" name="locationType">
                                                        <option value="COMMON">공용 위치</option>
                                                        <option value="DONG">동 위치</option>
                                                        <option value="HOUSEHOLD">세대 위치</option>
                                                    </select>
                                                </div>
                                                <div class="form-field" id="regDongField">
                                                    <label class="field-label">동</label>
                                                    <select class="form-select" id="regDongNo" name="dongNo">
                                                        <option value="">선택 안 함</option>
                                                        <c:forEach var="dong" items="${dongList}">
                                                            <option value="${dong.dongNo}">
                                                                <c:choose>
                                                                    <c:when test="${fn:contains(dong.dongNo, '_')}">${fn:substringAfter(dong.dongNo, '_')}</c:when>
                                                                    <c:when test="${not empty dong.dongNm}">${dong.dongNm}</c:when>
                                                                    <c:otherwise>${dong.dongNo}</c:otherwise>
                                                                </c:choose>
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="form-field">
                                                    <label class="field-label">층</label>
                                                    <select class="form-select" id="regFacilityFloor">
                                                        <option value="">선택</option>
                                                    </select>
                                                </div>
                                                <div class="form-field">
                                                    <label class="field-label">호</label>
                                                    <select class="form-select" id="regFacilityHo">
                                                        <option value="">선택</option>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="location-help-row">위치 구분에 따라 동·층·호가 활성화됩니다.</div>

                                            <div class="form-row cols-2 location-detail-row">
                                                <div class="form-field">
                                                    <label class="field-label">상세위치</label>
                                                    <input type="text" class="form-input" id="regLocCn" name="locCn" placeholder="예) 커뮤니티센터 2층">
                                                </div>
                                                <div class="form-field">
                                                    <label class="field-label">활성여부</label>
                                                    <select class="form-select" id="regUseYn" name="useYn">
                                                        <option value="Y">활성</option>
                                                        <option value="N">비활성</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- PUBLIC_FACILITY 운영정보 공통 영역 --%>
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">meeting_room</span>편의시설 기본/운영정보
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">편의시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="regCmnNm" name="cmnFacilityNm" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="regRsvYn" name="cmnFacilityRsvYn">
                                                    <option value="Y">예약 가능</option>
                                                    <option value="N">예약 불가</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="regAmt" name="cmnFacilityAmt" placeholder="0 (무료)" min="0">
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">운영요일/운영시간</label>
                                                <div class="opr-time-box">
                                                    <div class="opr-time-row">
                                                        <span class="opr-time-label">운영요일</span>
                                                        <div class="opr-day-range">
                                                            <select class="form-select" id="oprStartDay">
                                                                <option value="월" selected>월요일</option>
                                                                <option value="화">화요일</option>
                                                                <option value="수">수요일</option>
                                                                <option value="목">목요일</option>
                                                                <option value="금">금요일</option>
                                                                <option value="토">토요일</option>
                                                                <option value="일">일요일</option>
                                                            </select>
                                                            <span class="opr-time-separator">~</span>
                                                            <select class="form-select" id="oprEndDay">
                                                                <option value="월">월요일</option>
                                                                <option value="화">화요일</option>
                                                                <option value="수">수요일</option>
                                                                <option value="목">목요일</option>
                                                                <option value="금" selected>금요일</option>
                                                                <option value="토">토요일</option>
                                                                <option value="일">일요일</option>
                                                            </select>
                                                        </div>
                                                        <span class="opr-time-label">운영시간</span>
                                                        <input type="time" class="form-input" id="oprStartTime" step="60">
                                                        <span class="opr-time-separator">~</span>
                                                        <input type="time" class="form-input" id="oprEndTime" step="60">
                                                    </div>

                                                    <div class="opr-preview-row">
                                                        <span class="opr-time-label">저장값</span>
                                                        <div class="opr-preview is-empty" id="oprHrPreview">운영시간을 입력하면 자동으로 저장값이 생성됩니다.</div>
                                                    </div>
                                                    <div class="opr-time-notice" id="oprTimeNotice"></div>

                                                    <input type="hidden" id="regOprHr" name="cmnFacilityOprHr">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="regCn" name="cmnFacilityCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 우측: 사진 + 자원 안내 — flex 컬럼으로 좌측과 높이 맞춤 --%>
                                <div class="facility-modal-col-right">
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">image</span>시설 및 편의시설 사진
                                        </div>
                                        <div class="file-manage-list" id="regFileManageList" style="display:none;margin-bottom:8px;"></div>
                                        <div class="file-upload-box">
                                            <div class="file-upload-title"><span class="material-symbols-rounded">upload_file</span>사진 추가</div>
                                            <div class="file-upload-desc" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                            <input type="file" class="form-input" id="regImgInput" name="facilityFiles" accept="image/*" multiple>
                                            <div class="file-preview-list" id="regImgGrid" style="margin-top:8px;">
                                                <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- 편의시설 자원 안내: 사진 영역 아래로 밀어서 하단 고정 --%>
                                    <div class="form-section" style="margin-top:auto;padding-top:14px;">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">inventory_2</span>편의시설 자원
                                        </div>
                                        <div class="item-guide-list">
                                            <div class="item-guide-row">
                                                <div>
                                                    <div class="item-guide-main">자원 등록</div>
                                                    <div class="item-guide-sub">편의시설 저장 후 수정 화면에서 등록할 수 있습니다.</div>
                                                </div>
                                                <span class="item-guide-badge">저장 후 가능</span>
                                            </div>
                                            <div class="item-guide-row">
                                                <div>
                                                    <div class="item-guide-main">자원 목록</div>
                                                    <div class="item-guide-sub">수정 화면에서 이 편의시설에 연결된 자원을 확인할 수 있습니다.</div>
                                                </div>
                                                <span class="item-guide-badge">수정 화면 확인</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                                <button type="button" class="btn btn-secondary" id="backToListBtn">취소</button>
                                <button type="submit" class="btn btn-primary">저장</button>
                            </div>
                    </form>
                </div>

                <%-- 시설자산 선택 모달 --%>
                <div class="facility-select-modal" id="facilitySelectModal" aria-hidden="true">
                    <div class="facility-select-box" role="dialog" aria-modal="true" aria-label="시설자산 선택">
                        <div class="facility-select-head">
                            <h3 class="facility-select-title"><span class="material-symbols-rounded">domain_search</span>편의시설에 연결할 시설자산 선택</h3>
                            <button type="button" class="facility-select-close" id="closeFacilityModalBtn" aria-label="닫기">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="facility-select-body">
                            <div class="candidate-summary-row">
                                <div class="candidate-count" id="candidateTotalCount">전체 <strong><c:choose><c:when test="${not empty facilityCandidateList}">${fn:length(facilityCandidateList)}</c:when><c:otherwise>0</c:otherwise></c:choose></strong>건</div>
                                <div class="candidate-count" id="candidateVisibleCount">검색 결과 <strong>0</strong>건</div>
                            </div>

                            <div class="candidate-filter">
                                <input type="text" class="form-input" id="facilityKeyword" placeholder="시설명, 시설번호, 위치 검색">
                                <select class="form-select" id="facilityTypeFilter">
                                    <option value="">시설유형 전체</option>
                                    <c:forEach var="type" items="${publicFacilityTypeList}">
                                        <option value="${type.code}">${type.codeNm}</option>
                                    </c:forEach>
                                </select>
                                <select class="form-select" id="facilityDongFilter">
                                    <option value="">동 전체</option>
                                    <c:forEach var="dong" items="${dongList}">
                                        <option value="${dong.dongNo}">
                                            <c:choose>
                                                <c:when test="${fn:contains(dong.dongNo, '_')}">${fn:substringAfter(dong.dongNo, '_')}동</c:when>
                                                <c:when test="${not empty dong.dongNm}">${dong.dongNm}</c:when>
                                                <c:otherwise>${dong.dongNo}동</c:otherwise>
                                            </c:choose>
                                        </option>
                                    </c:forEach>
                                </select>
                                <button type="button" class="btn btn-secondary" id="facilityResetBtn">초기화</button>
                            </div>

                            <div class="candidate-table-wrap">
                                <table class="candidate-table">
                                    <colgroup>
                                        <col style="width:18%;">
                                        <col style="width:24%;">
                                        <col style="width:14%;">
                                        <col style="width:28%;">
                                        <col style="width:8%;">
                                        <col style="width:8%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>시설번호</th>
                                        <th>시설명</th>
                                        <th>시설유형</th>
                                        <th>위치</th>
                                        <th>사용</th>
                                        <th class="cell-center">선택</th>
                                    </tr>
                                    </thead>
                                    <tbody id="facilityCandidateBody">
                                    <c:choose>
                                        <c:when test="${not empty facilityCandidateList}">
                                            <c:forEach var="facility" items="${facilityCandidateList}">
                                                <tr class="candidate-row"
                                                    data-facility-no="${facility.facilityNo}"
                                                    data-facility-nm="${facility.facilityNm}"
                                                    data-facility-ty-cd="${facility.facilityTyCd}"
                                                    data-facility-ty-nm="${empty facility.facilityTyNm ? facility.facilityTyCd : facility.facilityTyNm}"
                                                    data-dong-no="${facility.dongNo}"
                                                    data-loc-cn="${facility.locCn}"
                                                    data-use-yn="${facility.useYn}">
                                                    <td>${facility.facilityNo}</td>
                                                    <td><span class="candidate-name-main">${facility.facilityNm}</span><span class="candidate-name-sub">운영관리 미등록</span></td>
                                                    <td>${empty facility.facilityTyNm ? facility.facilityTyCd : facility.facilityTyNm}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${empty facility.dongNo}">공용 위치</c:when>
                                                            <c:when test="${fn:contains(facility.dongNo, '_')}">${fn:substringAfter(facility.dongNo, '_')}동</c:when>
                                                            <c:otherwise>${facility.dongNo}동</c:otherwise>
                                                        </c:choose>
                                                        <c:if test="${not empty facility.locCn}"> · ${facility.locCn}</c:if>
                                                    </td>
                                                    <td>${facility.useYn eq 'N' ? '<span class="badge-mini badge-use-n">비활성</span>' : '<span class="badge-mini badge-use-y">활성</span>'}</td>
                                                    <td class="cell-center"><button type="button" class="btn btn-xs btn-detail" data-action="selectCandidate">선택</button></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                        </c:otherwise>
                                    </c:choose>
                                    <tr class="candidate-empty-row" id="candidateEmptyRow" style="display:none;"><td colspan="6">검색 조건에 맞는 운영관리 미등록 시설자산이 없습니다.</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/common-image-viewer.js"></script>

<script>
    (function () {
        var config = window.publicFacilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo  = config.mgmtOfcNo  || "";
        var preselectFacilityNo = config.preselectFacilityNo || "";

        function getEl(id) { return document.getElementById(id); }
        function listUrl() { return contextPath + "/manager/publicFacility/page/" + encodeURIComponent(mgmtOfcNo); }
        function alertMessage(msg) { if (typeof showAlert === "function") showAlert(msg); else alert(msg); }
        function getCsrfHeaders() {
            var tokenMeta  = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
            return headers;
        }
        async function requestJson(url, options) {
            var response = await fetch(url, options || {});
            var contentType = response.headers.get("content-type") || "";
            if (response.redirected || response.url.indexOf("/login.do") !== -1) {
                alertMessage("로그인이 필요합니다. 다시 로그인해주세요.");
                location.href = contextPath + "/login.do";
                throw new Error("login required");
            }
            if (contentType.indexOf("application/json") === -1) throw new Error("JSON 응답이 아닙니다.");
            var data = await response.json();
            if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            return data;
        }
        function postForm(url, formData) { return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData }); }
        function getJson(url) { return requestJson(url, { method:"GET", headers:getCsrfHeaders() }); }
        function resetSelect(select, placeholder) { if (select) select.innerHTML = '<option value="">' + placeholder + '</option>'; }

        function setRegisterMode(mode) {
            var isNewMode = mode === "NEW";
            getEl("registerMode").value = mode;
            document.querySelectorAll(".mode-tab").forEach(function (tab) {
                var active = tab.dataset.mode === mode;
                tab.classList.toggle("is-active", active);
                tab.setAttribute("aria-selected", active ? "true" : "false");
            });
            document.querySelectorAll(".mode-panel").forEach(function (panel) {
                panel.classList.toggle("is-active", panel.dataset.modePanel === mode);
            });
            ["regFacilityNm", "regFacilityTyCd", "regLocationType", "regDongNo", "regFacilityFloor", "regFacilityHo", "regLocCn", "regUseYn"].forEach(function (id) {
                var el = getEl(id);
                if (el) el.disabled = !isNewMode;
            });
            getEl("selectedFacilityNo").disabled = isNewMode;
            getEl("regFacilityNm").required = isNewMode;
            updateLocationType();
        }

        function updateLocationType() {
            var type = getEl("regLocationType").value;
            var isNewMode = getEl("registerMode").value === "NEW";
            var dongEl = getEl("regDongNo");
            var floorEl = getEl("regFacilityFloor");
            var hoEl = getEl("regFacilityHo");
            var locEl = getEl("regLocCn");
            if (type === "COMMON") {
                dongEl.value = ""; dongEl.disabled = true; floorEl.disabled = true; hoEl.disabled = true;
                resetSelect(floorEl, "선택"); resetSelect(hoEl, "선택");
                locEl.value = removeHouseholdPrefix(locEl.value);
                locEl.placeholder = "예) 중앙광장, 커뮤니티센터 2층"; return;
            }
            if (type === "DONG") {
                dongEl.disabled = !isNewMode; floorEl.disabled = true; hoEl.disabled = true;
                resetSelect(floorEl, "선택"); resetSelect(hoEl, "선택");
                locEl.value = removeHouseholdPrefix(locEl.value);
                locEl.placeholder = "예) 101동 1층 로비, 옥상"; return;
            }
            dongEl.disabled = !isNewMode; floorEl.disabled = !isNewMode; hoEl.disabled = !isNewMode;
            locEl.placeholder = "예) 세대 분전반, 수도계량기";
            updateHouseholdLocationText();
        }

        function removeHouseholdPrefix(text) {
            return String(text || "").replace(/^\s*\d+\s*층\s*/g, "").replace(/^\s*\d+\s*호\s*/g, "").trim();
        }

        function formatDongText(dongNo) {
            var value = String(dongNo || "").trim();
            if (!value) return "공용 위치";
            if (value.indexOf("_") > -1) value = value.substring(value.lastIndexOf("_") + 1);
            if (value.indexOf("동") > -1) return value;
            return value + "동";
        }

        function updateHouseholdLocationText() {
            if (getEl("regLocationType").value !== "HOUSEHOLD") return;
            var floor = getEl("regFacilityFloor").value;
            var ho = getEl("regFacilityHo").value;
            var locEl = getEl("regLocCn");
            var detailText = removeHouseholdPrefix(locEl.value);
            locEl.value = [floor ? floor + "층" : "", ho ? ho + "호" : "", detailText].filter(Boolean).join(" ");
        }

        async function loadFloorList() {
            var dongEl = getEl("regDongNo"); var floorEl = getEl("regFacilityFloor"); var hoEl = getEl("regFacilityHo");
            resetSelect(floorEl, "선택"); resetSelect(hoEl, "선택"); updateHouseholdLocationText();
            if (!dongEl.value) return;
            var result = await getJson(contextPath + "/manager/facility/location/floors/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongEl.value));
            var floorList = result.list || result.floorList || result || [];
            floorList.forEach(function (row) {
                var floor = row.floor || row.FLOOR; if (!floor) return;
                var option = document.createElement("option"); option.value = floor; option.textContent = floor; floorEl.appendChild(option);
            });
        }

        async function loadHoList() {
            var dongEl = getEl("regDongNo"); var floorEl = getEl("regFacilityFloor"); var hoEl = getEl("regFacilityHo");
            resetSelect(hoEl, "선택"); updateHouseholdLocationText();
            if (!dongEl.value || !floorEl.value) return;
            var result = await getJson(contextPath + "/manager/facility/location/rooms/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongEl.value) + "&floor=" + encodeURIComponent(floorEl.value));
            var hoList = result.list || result.roomList || result || [];
            hoList.forEach(function (row) {
                var ho = row.ho || row.HO; if (!ho) return;
                var option = document.createElement("option"); option.value = ho; option.textContent = ho; hoEl.appendChild(option);
            });
        }

        function buildNewFacilityLocationText() {
            var type = getEl("regLocationType").value;
            var locEl = getEl("regLocCn");
            if (type === "COMMON") { getEl("regDongNo").value = ""; return locEl.value; }
            if (type === "DONG") return removeHouseholdPrefix(locEl.value);
            updateHouseholdLocationText();
            return locEl.value;
        }

        function normalizeTimeValue(timeValue) { if (!timeValue) return ""; return String(timeValue).substring(0, 5); }

        function buildOperationDayText() {
            var startDay = getEl("oprStartDay").value;
            var endDay = getEl("oprEndDay").value;
            if (!startDay || !endDay) return "";
            if (startDay === "월" && endDay === "일") return "매일";
            if (startDay === "월" && endDay === "금") return "평일";
            if (startDay === "토" && endDay === "일") return "주말";
            if (startDay === endDay) return startDay;
            return startDay + "~" + endDay;
        }

        function updateOperationHourText() {
            var startTime = normalizeTimeValue(getEl("oprStartTime").value);
            var endTime = normalizeTimeValue(getEl("oprEndTime").value);
            var hiddenInput = getEl("regOprHr"); var preview = getEl("oprHrPreview"); var notice = getEl("oprTimeNotice");
            if (!startTime && !endTime) { hiddenInput.value = ""; preview.innerText = "운영시간을 입력하면 자동으로 저장값이 생성됩니다."; preview.classList.add("is-empty"); notice.innerText = ""; return; }
            if (!startTime || !endTime) { hiddenInput.value = ""; preview.innerText = "시작시간과 종료시간을 모두 입력해야 저장됩니다."; preview.classList.add("is-empty"); notice.innerText = ""; return; }
            var dayText = buildOperationDayText();
            var operationText = dayText + " " + startTime + "~" + endTime;
            hiddenInput.value = operationText; preview.innerText = operationText; preview.classList.remove("is-empty");
            if (startTime > endTime) { notice.innerText = "종료시간이 시작시간보다 빠르므로 다음날 종료되는 야간 운영으로 저장됩니다."; return; }
            if (startTime === endTime) { notice.innerText = "시작시간과 종료시간이 같아 24시간 운영 또는 별도 운영 기준으로 저장됩니다."; return; }
            notice.innerText = "";
        }

        function validateOperationHourInput() {
            var startTime = normalizeTimeValue(getEl("oprStartTime").value);
            var endTime = normalizeTimeValue(getEl("oprEndTime").value);
            if (!startTime && !endTime) return true;
            if (!startTime || !endTime) { alertMessage("운영시간은 시작시간과 종료시간을 모두 입력하세요."); return false; }
            return true;
        }

        function openFacilityModal() { getEl("facilitySelectModal").classList.add("is-open"); getEl("facilitySelectModal").setAttribute("aria-hidden", "false"); document.body.style.overflow = "hidden"; updateCandidateCount(); }

        function closeFacilityModal() {
            var modal = getEl("facilitySelectModal");
            var activeEl = document.activeElement;
            if (activeEl && modal.contains(activeEl)) activeEl.blur();
            modal.classList.remove("is-open"); modal.setAttribute("aria-hidden", "true"); document.body.style.overflow = "";
            var returnBtn = getEl("changeFacilityBtn") || getEl("openFacilityModalBtn");
            if (returnBtn && returnBtn.offsetParent !== null) returnBtn.focus();
        }

        function selectFacility(row) {
            if (!row) return;
            var facilityNo = row.dataset.facilityNo || "";
            var facilityNm = row.dataset.facilityNm || "";
            var facilityTyNm = row.dataset.facilityTyNm || row.dataset.facilityTyCd || "-";
            var dongNo = row.dataset.dongNo || "";
            var locCn = row.dataset.locCn || "";
            var useYn = row.dataset.useYn || "Y";
            var locationText = formatDongText(dongNo) + (locCn ? " · " + locCn : "");
            var assetLineText = [facilityNo || "-", facilityNm || "-", locationText || "-"].join(" · ");
            getEl("selectedFacilityNo").value = facilityNo;
            getEl("selectedFacilityNmText").innerText = facilityNm || "-";
            getEl("selectedFacilityNoText").innerText = facilityNo || "-";
            getEl("selectedFacilityTyText").innerText = facilityTyNm;
            getEl("selectedLocationText").innerText = locationText || "-";
            getEl("selectedUseYnText").innerText = useYn === "N" ? "비활성" : "활성";
            getEl("selectedAssetLineText").innerText = assetLineText;
            getEl("selectedAssetLineText").title = assetLineText;
            getEl("selectedEmptyBox").style.display = "none";
            getEl("selectedSummaryBox").classList.add("is-active");
            document.querySelector(".selected-facility-box").classList.add("is-selected");
            loadExistingFiles(facilityNo);
            closeFacilityModal();
        }

        function applyPreselectedFacility(facilityNo) {
            if (!facilityNo) return;
            var candidateRows = Array.from(document.querySelectorAll("#facilityCandidateBody .candidate-row"));
            var row = candidateRows.find(function (candidateRow) { return candidateRow.dataset.facilityNo === facilityNo; });
            if (row) { selectFacility(row); return; }
            getEl("selectedFacilityNo").value = facilityNo;
            getEl("selectedFacilityNoText").innerText = facilityNo;
            getEl("selectedFacilityNmText").innerText = "선택된 시설자산";
            getEl("selectedFacilityTyText").innerText = "-";
            getEl("selectedLocationText").innerText = "-";
            getEl("selectedUseYnText").innerText = "-";
            getEl("selectedAssetLineText").innerText = facilityNo + " · 선택된 시설자산 · -";
            getEl("selectedAssetLineText").title = facilityNo + " · 선택된 시설자산 · -";
            getEl("selectedEmptyBox").style.display = "none";
            getEl("selectedSummaryBox").classList.add("is-active");
            document.querySelector(".selected-facility-box").classList.add("is-selected");
            loadExistingFiles(facilityNo);
        }

        function lockFacilitySelection() {
            var changeBtn = getEl("changeFacilityBtn");
            if (changeBtn) { changeBtn.disabled = true; changeBtn.innerText = "연결 시설자산 고정"; changeBtn.title = "시설자산 목록에서 선택되어 들어온 시설은 변경할 수 없습니다."; }
        }

        function getFileImageUrl(file) {
            if (file.viewUrl) return file.viewUrl;
            if (file.fileUrl) return file.fileUrl;
            if (file.googleId) return contextPath + "/file/display/" + encodeURIComponent(file.googleId);
            return "";
        }

        async function loadExistingFiles(facilityNo) {
            var area = getEl("regFileManageList");
            area.style.display = ""; area.innerHTML = '<div class="file-preview-empty">기존 사진을 불러오는 중입니다.</div>';
            getEl("deleteFileUuids").value = "";
            try {
                var result = await requestJson(contextPath + "/manager/facility/detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo));
                var fileList = result.fileList || result.attachFileList || (result.facility && result.facility.fileList) || [];
                renderExistingFiles(fileList);
            } catch (err) { area.innerHTML = '<div class="file-preview-empty">기존 사진을 불러오지 못했습니다.</div>'; }
        }

        function renderExistingFiles(files) {
            var area = getEl("regFileManageList");
            if (!files || files.length === 0) { area.innerHTML = '<div class="file-preview-empty">기존 등록 사진이 없습니다.</div>'; return; }
            area.innerHTML = files.map(function (file) {
                var imgUrl = getFileImageUrl(file);
                var name = file.fileOgName || file.fileSaveUuid || "시설사진";
                var uuid = file.fileSaveUuid || "";
                var thumbHtml = imgUrl ? '<img class="file-thumb js-image-preview" src="' + imgUrl + '" alt="' + name + '">' : '<div class="file-thumb"></div>';
                return '<div class="file-manage-row">' + thumbHtml + '<div class="file-info"><div class="file-name">' + name + '</div><div class="file-meta">' + (file.fileExt || "image") + '</div></div>' + '<label class="file-delete-check"><input type="checkbox" class="js-delete-file-check" value="' + uuid + '">삭제</label>' + '</div>';
            }).join("");
        }

        function updateDeleteFileUuids() {
            var checked = Array.from(document.querySelectorAll(".js-delete-file-check:checked")).map(function (box) { return box.value; }).filter(Boolean);
            getEl("deleteFileUuids").value = checked.join(",");
        }

        function filterCandidateList() {
            var keyword = (getEl("facilityKeyword").value || "").toLowerCase().trim();
            var facilityTyCd = getEl("facilityTypeFilter").value || "";
            var dongNo = getEl("facilityDongFilter").value || "";
            document.querySelectorAll("#facilityCandidateBody .candidate-row").forEach(function (row) {
                var text = (row.innerText || "").toLowerCase();
                var matchKeyword = !keyword || text.indexOf(keyword) > -1;
                var matchType = !facilityTyCd || row.dataset.facilityTyCd === facilityTyCd;
                var matchDong = !dongNo || row.dataset.dongNo === dongNo;
                row.classList.toggle("candidate-hidden", !(matchKeyword && matchType && matchDong));
            });
            updateCandidateCount();
        }

        function updateCandidateCount() {
            var visibleCount = 0;
            document.querySelectorAll("#facilityCandidateBody .candidate-row").forEach(function (row) { if (!row.classList.contains("candidate-hidden")) visibleCount++; });
            getEl("candidateVisibleCount").innerHTML = "검색 결과 <strong>" + visibleCount + "</strong>건";
            getEl("candidateEmptyRow").style.display = visibleCount === 0 ? "table-row" : "none";
        }

        function resetCandidateFilter() { getEl("facilityKeyword").value = ""; getEl("facilityTypeFilter").value = ""; getEl("facilityDongFilter").value = ""; filterCandidateList(); }

        function previewSelectedFiles() {
            var fileInput = getEl("regImgInput"); var previewArea = getEl("regImgGrid");
            previewArea.innerHTML = "";
            if (!fileInput.files || fileInput.files.length === 0) { previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>'; return; }
            Array.from(fileInput.files).forEach(function (file) {
                var item = document.createElement("div"); item.className = "file-preview-item";
                if (file.type && file.type.indexOf("image/") === 0) {
                    var img = document.createElement("img"); img.alt = file.name; img.src = URL.createObjectURL(file);
                    if (window.CommonImageViewer) img.addEventListener("click", function () { CommonImageViewer.openUrl(this.src); });
                    item.appendChild(img);
                }
                var name = document.createElement("div"); name.className = "file-preview-name"; name.textContent = file.name;
                item.appendChild(name); previewArea.appendChild(item);
            });
        }

        async function saveRegister(event) {
            event.preventDefault();
            var mode = getEl("registerMode").value;
            var selectedFacilityNo = getEl("selectedFacilityNo").value;
            if (mode === "EXISTING" && !selectedFacilityNo) { alertMessage("연결할 기존 시설자산을 선택하세요."); return; }
            if (mode === "NEW" && !getEl("regFacilityNm").value.trim()) { alertMessage("시설명을 입력하세요."); return; }
            if (mode === "NEW" && getEl("regLocationType").value === "DONG" && !getEl("regDongNo").value) { alertMessage("동 기준 위치를 선택한 경우 동을 선택하세요."); return; }
            if (mode === "NEW" && getEl("regLocationType").value === "HOUSEHOLD" && !getEl("regDongNo").value) { alertMessage("세대 위치를 선택한 경우 동을 선택하세요."); return; }
            if (!getEl("regCmnNm").value.trim()) { alertMessage("편의시설명을 입력하세요."); return; }
            if (mode === "NEW") getEl("regLocCn").value = buildNewFacilityLocationText();
            updateOperationHourText();
            if (!validateOperationHourInput()) return;
            updateDeleteFileUuids();
            try {
                await postForm(contextPath + "/manager/publicFacility/insert/" + encodeURIComponent(mgmtOfcNo), new FormData(getEl("registerForm")));
                alertMessage("편의시설이 등록되었습니다.");
                location.href = listUrl();
            } catch (err) { console.error(err); alertMessage(err.message || "편의시설 등록 중 오류가 발생했습니다."); }
        }

        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".mode-tab").forEach(function (tab) { tab.addEventListener("click", function () { setRegisterMode(tab.dataset.mode || "EXISTING"); }); });
            getEl("openFacilityModalBtn").addEventListener("click", openFacilityModal);
            getEl("changeFacilityBtn").addEventListener("click", openFacilityModal);
            getEl("closeFacilityModalBtn").addEventListener("click", closeFacilityModal);
            getEl("facilitySelectModal").addEventListener("click", function (event) { if (event.target === getEl("facilitySelectModal")) closeFacilityModal(); });
            getEl("facilityCandidateBody").addEventListener("click", function (event) {
                var selectBtn = event.target.closest('[data-action="selectCandidate"]');
                var row = event.target.closest(".candidate-row");
                if (selectBtn && row) selectFacility(row);
            });
            getEl("facilityKeyword").addEventListener("keyup", filterCandidateList);
            getEl("facilityTypeFilter").addEventListener("change", filterCandidateList);
            getEl("facilityDongFilter").addEventListener("change", filterCandidateList);
            getEl("facilityResetBtn").addEventListener("click", resetCandidateFilter);
            getEl("regLocationType").addEventListener("change", function () { updateLocationType(); if (this.value === "HOUSEHOLD" && getEl("regDongNo").value) loadFloorList(); });
            getEl("regDongNo").addEventListener("change", function () { if (getEl("regLocationType").value === "HOUSEHOLD") loadFloorList(); });
            getEl("regFacilityFloor").addEventListener("change", loadHoList);
            getEl("regFacilityHo").addEventListener("change", updateHouseholdLocationText);
            ["oprStartDay", "oprEndDay", "oprStartTime", "oprEndTime"].forEach(function (id) { getEl(id).addEventListener("change", updateOperationHourText); getEl(id).addEventListener("input", updateOperationHourText); });
            getEl("regImgInput").addEventListener("change", previewSelectedFiles);
            document.addEventListener("change", function (e) { if (e.target.classList.contains("js-delete-file-check")) updateDeleteFileUuids(); });
            getEl("registerForm").addEventListener("submit", saveRegister);
            getEl("backToListBtn").addEventListener("click", function () { history.back(); });
            document.addEventListener("keydown", function (event) { if (event.key === "Escape") closeFacilityModal(); });
            setRegisterMode("EXISTING");
            updateCandidateCount();
            updateOperationHourText();
            if (window.CommonImageViewer) CommonImageViewer.bind("#regFileManageList");
            if (preselectFacilityNo) {
                applyPreselectedFacility(preselectFacilityNo);
                lockFacilitySelection();
                var modeTabs = document.querySelector(".mode-tabs");
                if (modeTabs) modeTabs.style.display = "none";
            }
        });
    })();
</script>
</body>
</html>
