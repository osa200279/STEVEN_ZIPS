<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>검침 이력 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        /* 페이지 토큰 */
        #meterPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e; font-family:'Noto Sans KR',sans-serif; }

        /* 페이지 헤더 */
        #meterPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #meterPage .page-title-block p { color:#6b7a6e; font-size:12px; }

        /* 공통 버튼 */
        #meterPage .btn { display:inline-flex; align-items:center; justify-content:center; gap:4px; min-height:32px; height:32px; padding:0 11px; border-radius:4px; border:1px solid var(--line); background:#fff; color:#39443d; font-size:12px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box; }
        #meterPage .btn:hover { background:#f4f7f4; }
        #meterPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #meterPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #meterPage .btn-ghost { background:#fff; color:#374151; }
        #meterPage .btn .material-symbols-rounded { font-size:15px; }
        #meterPage .btn-sm { height:28px; min-height:28px; padding:0 9px; font-size:11px; }
        #meterPage .btn-edit { background:var(--accent); border-color:var(--accent); color:#fff; }
        #meterPage .btn-edit:hover { background:var(--accent-hover); border-color:var(--accent-hover); color:#fff; }

        /* 알림 */
        #meterPage .alert { display:flex; align-items:center; gap:8px; padding:10px 14px; margin-bottom:12px; border-radius:4px; font-size:12px; font-weight:700; }
        #meterPage .alert-success { background:#ecfdf3; border:1px solid #bbf7d0; color:#166534; }
        #meterPage .alert-error { background:#fef2f2; border:1px solid #fecaca; color:#991b1b; }

        /* 검침 탭 */
        #meterPage .meter-tab-wrap { margin-top:12px; }
        #meterPage .meter-tab-input { position:absolute; width:1px; height:1px; overflow:hidden; clip:rect(0,0,0,0); white-space:nowrap; border:0; }
        #meterPage .meter-tab-labels { display:flex; gap:24px; width:100%; padding:0; margin-bottom:18px; background:transparent; border:none; border-bottom:1px solid var(--line); border-radius:0; }
        #meterPage .meter-tab-label { position:relative; display:flex; align-items:center; gap:6px; min-height:42px; padding:0 2px; border:none; border-radius:0; background:transparent; color:#6b7280; font-size:13px; font-weight:700; font-family:inherit; cursor:pointer; transition:.15s; box-sizing:border-box; }
        #meterPage .meter-tab-label:hover { color:#111827; }
        #meterPage .meter-tab-label .material-symbols-rounded { font-size:16px; color:#9ca3af; }
        #meterPage .meter-tab-content { display:block; }
        #meterPage .meter-tab-panel { display:none; margin-bottom:0; }
        #meterPage #meterTabComplex:checked ~ .meter-tab-labels label[for="meterTabComplex"],
        #meterPage #meterTabFacility:checked ~ .meter-tab-labels label[for="meterTabFacility"] { background:transparent; color:#111827; box-shadow:none; }
        #meterPage #meterTabComplex:checked ~ .meter-tab-labels label[for="meterTabComplex"]::after,
        #meterPage #meterTabFacility:checked ~ .meter-tab-labels label[for="meterTabFacility"]::after { content:""; position:absolute; left:0; right:0; bottom:-1px; height:2px; background:var(--accent); }
        #meterPage #meterTabComplex:checked ~ .meter-tab-labels label[for="meterTabComplex"] .material-symbols-rounded,
        #meterPage #meterTabFacility:checked ~ .meter-tab-labels label[for="meterTabFacility"] .material-symbols-rounded { color:var(--accent); }
        #meterPage #meterTabComplex:checked ~ .meter-tab-content #complexMeterPanel,
        #meterPage #meterTabFacility:checked ~ .meter-tab-content #facilityMeterPanel { display:block; }

        /* 섹션 패널 */
        #meterPage .meter-section { margin-bottom:18px; }
        #meterPage .meter-section:last-child { margin-bottom:0; }
        #meterPage .section-heading { display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin:0 0 8px; }
        #meterPage .section-title-wrap { display:flex; flex-direction:column; gap:3px; }
        #meterPage .section-title { display:flex; align-items:center; gap:6px; margin:0; color:var(--text-head); font-size:15px; font-weight:800; }
        #meterPage .section-title .material-symbols-rounded { font-size:18px; color:var(--accent); }
        #meterPage .section-desc { margin:0; color:#718075; font-size:11px; }
        #meterPage .section-actions { display:flex; align-items:center; justify-content:flex-end; gap:7px; }

        /* 공통 패널 */
        #meterPage .panel { border-radius:6px; border:1px solid var(--line); background:#fff; margin:0 0 10px; }
        #meterPage .panel:last-child { margin-bottom:0; }
        #meterPage .panel-list { overflow:hidden; }
        #meterPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:#fff; }
        #meterPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #meterPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #meterPage .panel-body { padding:14px 16px 16px; }

        /* 필터 */
        #meterPage .filter-grid { display:grid; grid-template-columns:1.2fr .8fr .75fr 1.45fr minmax(220px,2fr) auto; gap:8px 12px; align-items:end; }
        #meterPage .complex-filter-grid { grid-template-columns:1.2fr .8fr .75fr 1.45fr minmax(220px,2fr) auto; }
        #meterPage .field-label { display:block; margin-bottom:5px; font-size:11px; font-weight:800; color:var(--text-sec); }
        #meterPage .form-select, #meterPage .form-input, #meterPage .form-textarea { width:100%; box-sizing:border-box; border:1px solid var(--line); background:#fff; border-radius:4px; font-family:'Noto Sans KR',sans-serif; color:#1f2d23; }
        #meterPage .form-select, #meterPage .form-input { height:32px; padding:0 9px; font-size:12px; }
        #meterPage .form-textarea { min-height:78px; padding:8px 9px; font-size:12px; resize:vertical; }
        #meterPage .form-select:focus, #meterPage .form-input:focus, #meterPage .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px rgba(46,92,56,.08); outline:none; }
        #meterPage .date-range-inputs { display:grid; grid-template-columns:minmax(0,1fr) auto minmax(0,1fr); align-items:center; gap:5px; }
        #meterPage .date-filter-sep { color:#9ca3af; font-size:12px; text-align:center; }
        #meterPage .search-wrap { position:relative; }
        #meterPage .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #meterPage .search-wrap input { padding-left:30px; }
        #meterPage .filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }

        /* 목록 */
        #meterPage .list-head-left { display:flex; align-items:center; gap:8px; }
        #meterPage .list-head-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; margin-left:auto; }
        #meterPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #meterPage .table-wrap { overflow-x:auto; margin:0 -1px; }
        #meterPage .tbl { width:100%; min-width:1420px; border-collapse:collapse; table-layout:fixed; }
        #meterPage .tbl th { height:38px; padding:0 8px; background:var(--th-bg); border-bottom:1px solid var(--line); color:var(--text-sec); font-size:12px; font-weight:800; text-align:center; box-sizing:border-box; }
        #meterPage .tbl td { height:43px; padding:6px 8px; border-bottom:1px solid #eef1f3; color:#243027; font-size:12px; text-align:center; vertical-align:middle; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; box-sizing:border-box; }
        #meterPage .tbl tr:last-child td { border-bottom:none; }
        #meterPage .tbl tr:hover td { background:#f8fbf8; }
        #meterPage .tbl .td-left { text-align:left; }
        #meterPage .tbl .td-right { text-align:right; }
        #meterPage .tbl .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .meter-main { font-weight:800; color:#1f2d23; }
        #meterPage .meter-sub { margin-top:2px; font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .meter-no { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .td-unit { text-align:center !important; }
        #meterPage .unit-value { display:inline-flex; align-items:baseline; justify-content:center; gap:3px; min-width:76px; }
        #meterPage .unit-label { color:#8a9a8e; font-size:10px; font-weight:700; }
        #meterPage .partner-cell { padding-left:10px !important; }
        #meterPage .facility-cell { padding-right:4px !important; }
        #meterPage .ho-cell { padding-left:4px !important; }
        #meterPage .row-actions { display:flex; align-items:center; justify-content:center; gap:5px; }
        #meterPage .empty-row { height:86px; color:var(--text-ter); font-size:13px; text-align:center !important; }

        /* 페이지네이션 */
        #meterPage .pagination-wrap { display:flex; align-items:center; justify-content:space-between; gap:10px; padding:11px 16px; border-top:1px solid var(--line); background:var(--surface-sub); }
        #meterPage .pagination-info { font-size:11px; color:var(--text-ter); white-space:nowrap; }
        #meterPage .pagination { display:flex; align-items:center; justify-content:flex-end; gap:4px; }
        #meterPage .page-btn { min-width:34px; height:32px; padding:0 10px; border:1px solid var(--line); border-radius:4px; background:#fff; color:#4b5563; font-size:12px; font-weight:700; cursor:pointer; }
        #meterPage .page-btn-nav { min-width:46px; }
        #meterPage .page-btn:hover:not(:disabled) { background:#f4f7f4; color:var(--accent); }
        #meterPage .page-btn.active { background:var(--accent); border-color:var(--accent); color:#fff; }
        #meterPage .page-btn:disabled { opacity:.45; cursor:not-allowed; }

        /* 컬럼 너비 */
        #meterPage .col-no { width:4%; }
        #meterPage .col-meter-no { width:10%; }
        #meterPage .col-meter-date { width:8%; }
        #meterPage .col-meter-ty { width:8%; }
        #meterPage .col-complex-unit { width:15%; }
        #meterPage .col-facility { width:16%; }
        #meterPage .col-ho { width:10%; }
        #meterPage .col-complex-value { width:10%; }
        #meterPage .col-facility-value { width:9%; }
        #meterPage .col-complex-usage { width:9%; }
        #meterPage .col-facility-usage { width:9%; }
        #meterPage .col-result { width:7%; }
        #meterPage .col-complex-partner { width:17%; }
        #meterPage .col-facility-partner { width:11%; }
        #meterPage .col-action { width:7%; }

        /* 상태 배지 */
        #meterPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #meterPage .badge-normal { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #meterPage .badge-error { background:#fee2e2; color:#7f1d1d; border-color:#fecaca; }
        #meterPage .badge-miss { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #meterPage .badge-gray { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #meterPage .need-check { display:block; margin-top:3px; font-size:10px; color:#b45309; font-weight:800; }

        /* 모달 */
        #meterPage .modal-overlay { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.35); box-sizing:border-box; }
        #meterPage .modal-overlay.open, #meterPage .modal-overlay.is-open { display:flex; }
        #meterPage .modal { width:min(720px,96vw); max-height:88vh; display:flex; flex-direction:column; background:#fff; border:1px solid var(--line); border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22); overflow:hidden; }
        #meterPage .modal.modal-sm { width:min(600px,96vw); }
        #meterPage .modal-header { display:flex; align-items:center; justify-content:space-between; min-height:48px; padding:0 18px; border-bottom:1px solid var(--line); background:var(--text-head); }
        #meterPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #meterPage .modal-close { border:0; background:rgba(255,255,255,.12); cursor:pointer; color:rgba(255,255,255,.75); width:28px; height:28px; border-radius:4px; display:flex; align-items:center; justify-content:center; }
        #meterPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #meterPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #meterPage .field-help { margin-top:6px; color:#64748b; font-size:12px; line-height:1.35; }
        #meterPage .lookup-row { display:flex; gap:8px; align-items:center; }
        #meterPage .lookup-row .form-input { flex:1; }
        #meterPage .modal-footer { display:flex; justify-content:flex-end; gap:8px; padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub); }
        #meterPage .unit-suffix { margin-left:6px; color:#6b7280; font-size:12px; font-weight:600; }
        #meterPage .readonly-box.is-hidden-section, #meterPage .is-hidden-section { display:none !important; }

        /* 모달 폼 */
        #meterPage .form-section { margin-bottom:18px; }
        #meterPage .form-section:last-child { margin-bottom:0; }
        #meterPage .form-section-title { display:flex; align-items:center; gap:5px; margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid var(--line); color:var(--text-head); font-size:12px; font-weight:800; }
        #meterPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #meterPage .form-row { display:grid; gap:10px 12px; margin-bottom:10px; }
        #meterPage .form-row.cols-2 { grid-template-columns:1fr 1fr; }
        #meterPage .form-row.cols-3 { grid-template-columns:1fr 1fr 1fr; }
        #meterPage .form-field { display:flex; flex-direction:column; gap:4px; }
        #meterPage .field-help { font-size:11px; color:var(--text-ter); line-height:1.45; margin-top:2px; }
        #meterPage .readonly-box { min-height:32px; display:flex; align-items:center; padding:0 9px; border:1px solid #e5e7eb; border-radius:4px; background:#f8fafc; color:#374151; font-size:12px; box-sizing:border-box; }
        #meterPage .readonly-box.multiline { min-height:60px; align-items:flex-start; padding:8px 9px; white-space:pre-wrap; word-break:break-all; }
        #meterPage .column-box { border:1px solid #e5e7eb; border-radius:4px; background:#f8fafc; padding:10px; color:#4b5563; font-size:11px; line-height:1.6; }
        #meterPage .column-box code { font-family:'Consolas','SF Mono',monospace; color:#1f2d23; }

        /* 계약 정보 박스 */
        #meterPage .contract-info-box { margin-top:10px; padding:10px 12px; background:#f0f4f1; border:1px solid #c9d9cc; border-radius:4px; font-size:11px; color:#374151; line-height:1.7; display:none; }
        #meterPage .contract-info-box.visible { display:block; }
        #meterPage .contract-info-label { font-weight:800; color:var(--text-sec); margin-right:4px; }

        /* 반응형 */
        @media(max-width:1200px) { #meterPage .filter-grid { grid-template-columns:repeat(3,minmax(0,1fr)); } }
        @media(max-width:760px) {
            #meterPage .filter-grid { grid-template-columns:1fr; }
            #meterPage .form-row.cols-2, #meterPage .form-row.cols-3 { grid-template-columns:1fr; }
            #meterPage .panel-header, #meterPage .section-heading { flex-direction:column; align-items:flex-start; gap:8px; }
            #meterPage .section-actions { width:100%; justify-content:flex-start; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="meterPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>검침 이력 관리</h2>
                        <p>단지별 검침과 시설 검침 이력을 탭으로 구분하여 조회합니다.</p>
                    </div>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">
                        <span class="material-symbols-rounded">check_circle</span>
                            ${successMessage}
                    </div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <span class="material-symbols-rounded">error</span>
                            ${errorMessage}
                    </div>
                </c:if>

                <%-- 검침 탭 영역 --%>
                <div class="meter-tab-wrap">
                    <input type="radio" class="meter-tab-input" name="meterTab" id="meterTabComplex" checked>
                    <input type="radio" class="meter-tab-input" name="meterTab" id="meterTabFacility">

                    <div class="meter-tab-labels" role="tablist" aria-label="검침 구분">
                        <label class="meter-tab-label" for="meterTabComplex" role="tab">
                            <span class="material-symbols-rounded">apartment</span>단지별 검침
                        </label>
                        <label class="meter-tab-label" for="meterTabFacility" role="tab">
                            <span class="material-symbols-rounded">electric_meter</span>시설 검침
                        </label>
                    </div>

                    <div class="meter-tab-content">

                        <%-- ===== 단지별 검침 패널 ===== --%>
                        <section class="meter-section complex-meter-section meter-tab-panel" id="complexMeterPanel">
                            <div class="section-heading">
                                <div class="section-title-wrap">
                                    <h3 class="section-title"><span class="material-symbols-rounded">apartment</span>단지별 검침</h3>
                                    <p class="section-desc">동·호 기준 검침 이력을 조회합니다.</p>
                                </div>
                            </div>

                            <div class="panel">
                                <div class="panel-header">
                                    <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>단지별 검침 검색 조건</h3>
                                </div>
                                <div class="panel-body">
                                    <form method="get" action="${ctx}/manager/meter/hstry/${mgmtOfcNo}" id="complexSearchForm">
                                        <div class="filter-grid complex-filter-grid">
                                            <div class="form-field">
                                                <label class="field-label" for="complexUtilityProviderNo">공급/검침 업체</label>
                                                <select class="form-select" id="complexUtilityProviderNo" name="complexUtilityProviderNo">
                                                    <option value="">전체</option>
                                                    <c:forEach var="provider" items="${providerList}">
                                                        <c:choose>
                                                            <c:when test="${empty provider.utilityProviderNo}">
                                                                <option value="" disabled>[설정 필요] ${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${provider.utilityProviderNo}" <c:if test="${complexSearch.utilityProviderNo eq provider.utilityProviderNo}">selected</c:if>>
                                                                    <c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                                </option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="complexMeterTyCd">검침유형</label>
                                                <select class="form-select" id="complexMeterTyCd" name="complexMeterTyCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${meterTyCodeList}">
                                                        <option value="${code.codeNoCd}" <c:if test="${complexSearch.meterTyCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="complexMeterRsltCd">결과</label>
                                                <select class="form-select" id="complexMeterRsltCd" name="complexMeterRsltCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${rsltCodeList}">
                                                        <option value="${code.codeNoCd}" <c:if test="${complexSearch.meterRsltCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">검침일자</label>
                                                <div class="date-range-inputs">
                                                    <input type="date" class="form-input" id="complexStartDt" name="complexStartDt" value="${complexSearch.startDt}">
                                                    <span class="date-filter-sep">~</span>
                                                    <input type="date" class="form-input" id="complexEndDt" name="complexEndDt" value="${complexSearch.endDt}">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="complexKeyword">동/호 검색</label>
                                                <div class="search-wrap">
                                                    <span class="material-symbols-rounded">search</span>
                                                    <input type="text" class="form-input" id="complexKeyword" name="complexKeyword" value="${complexSearch.keyword}" placeholder="동, 호번호, 검침번호">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">&nbsp;</label>
                                                <div class="filter-actions">
                                                    <button type="submit" class="btn btn-primary">검색</button>
                                                    <a href="${ctx}/manager/meter/hstry/${mgmtOfcNo}" class="btn">초기화</a>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="panel panel-list">
                                <div class="panel-header">
                                    <div class="list-head-left">
                                        <h3 class="panel-title"><span class="material-symbols-rounded">format_list_bulleted</span>단지별 검침 목록</h3>
                                        <span class="list-count">총 ${fn:length(complexMeterList)}건</span>
                                    </div>
                                    <div class="list-head-right">
                                        <button type="button" class="btn btn-ghost" id="openComplexInsertModalBtn">
                                            <span class="material-symbols-rounded">add</span>단지별 검침 등록
                                        </button>
                                        <button type="button" class="btn btn-primary" id="openComplexUploadModalBtn">
                                            <span class="material-symbols-rounded">upload_file</span>단지별 검침 CSV 업로드
                                        </button>
                                    </div>
                                </div>
                                <div class="table-wrap">
                                    <table class="tbl">
                                        <colgroup>
                                            <col class="col-no"><col class="col-meter-no"><col class="col-meter-ty"><col class="col-meter-date">
                                            <col class="col-complex-unit"><col class="col-complex-value"><col class="col-complex-value">
                                            <col class="col-complex-usage"><col class="col-result"><col class="col-complex-partner"><col class="col-action">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>번호</th><th>검침번호</th><th>검침유형</th><th>검침일자</th>
                                            <th class="td-left">동/호</th><th>이전값</th><th>현재값</th>
                                            <th>사용량</th><th>결과</th><th class="td-left">업체</th><th>관리</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${empty complexMeterList}">
                                                <tr><td colspan="11" class="empty-row">조회된 단지별 검침 이력이 없습니다.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="row" items="${complexMeterList}" varStatus="status">
                                                    <tr class="js-page-row" data-page-target="complex">
                                                        <c:set var="meterUnit" value="" />
                                                        <c:if test="${row.meterTyCd eq 'ELEC'}"><c:set var="meterUnit" value="kWh" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'GAS' or row.meterTyCd eq 'WATER'}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'HEAT'}"><c:set var="meterUnit" value="Gcal" /></c:if>
                                                        <c:if test="${empty meterUnit and (row.facilityTyCd eq 'ELC' or fn:contains(row.facilityTyNm, '전기'))}"><c:set var="meterUnit" value="kWh" /></c:if>
                                                        <c:if test="${empty meterUnit and (row.facilityTyCd eq 'GAS' or fn:contains(row.facilityTyNm, '가스'))}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <c:if test="${empty meterUnit and (row.facilityTyCd eq 'WTR' or fn:contains(row.facilityTyNm, '급수') or fn:contains(row.facilityTyNm, '수도'))}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <c:set var="hoParts" value="${fn:split(row.hoNo, '_')}" />
                                                        <td class="mono">${fn:length(complexMeterList) - status.index}</td>
                                                        <td class="meter-no">${row.meterHstryNo}</td>
                                                        <td><span class="badge badge-gray">${empty row.meterTyNm ? '-' : row.meterTyNm}</span></td>
                                                        <td><fmt:formatDate value="${row.meterDt}" pattern="yyyy.MM.dd"/></td>
                                                        <td class="td-left">
                                                            <c:choose>
                                                                <c:when test="${fn:length(hoParts) ge 3}">
                                                                    <div class="meter-main">${hoParts[1]}동 ${hoParts[2]}호</div>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="meter-main">${empty row.hoNo ? '-' : row.hoNo}</div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.preVal}" pattern="#,#0.##"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal}" pattern="#,#0.##"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal - row.preVal}" pattern="#,#0.##"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${row.meterRsltCd eq 'NORMAL'}"><span class="badge badge-normal">${row.meterRsltNm}</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'ERROR'}"><span class="badge badge-error">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'MISS'}"><span class="badge badge-miss">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:otherwise><span class="badge badge-gray">${empty row.meterRsltCd ? '-' : row.meterRsltCd}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="td-left partner-cell"><div>${row.partnerNm}</div></td>
                                                        <td>
                                                            <div class="row-actions">
                                                                <button type="button" class="btn btn-sm btn-ghost js-detail-btn" data-meter-hstry-no="${row.meterHstryNo}">상세</button>
                                                                <button type="button" class="btn btn-sm btn-edit js-edit-btn" data-meter-hstry-no="${row.meterHstryNo}">수정</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="pagination-wrap" data-pagination-target="complex">
                                    <div class="pagination-info" id="complexPaginationInfo">총 0건</div>
                                    <div class="pagination" id="complexPagination"></div>
                                </div>
                            </div>
                        </section>

                        <%-- ===== 시설 검침 패널 ===== --%>
                        <section class="meter-section facility-meter-section meter-tab-panel" id="facilityMeterPanel">
                            <div class="section-heading">
                                <div class="section-title-wrap">
                                    <h3 class="section-title"><span class="material-symbols-rounded">electric_meter</span>시설 검침</h3>
                                    <p class="section-desc">시설자산 기준 검침 이력을 조회합니다.</p>
                                </div>
                            </div>

                            <div class="panel">
                                <div class="panel-header">
                                    <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>시설 검침 검색 조건</h3>
                                </div>
                                <div class="panel-body">
                                    <form method="get" action="${ctx}/manager/meter/hstry/${mgmtOfcNo}" id="facilitySearchForm">
                                        <div class="filter-grid">
                                            <div class="form-field">
                                                <label class="field-label" for="filterUtilityProviderNo">공급/검침 업체</label>
                                                <select class="form-select" id="filterUtilityProviderNo" name="utilityProviderNo">
                                                    <option value="">전체</option>
                                                    <c:forEach var="provider" items="${providerList}">
                                                        <c:choose>
                                                            <c:when test="${empty provider.utilityProviderNo}">
                                                                <option value="" disabled>[설정 필요] ${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if></option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${provider.utilityProviderNo}" <c:if test="${search.utilityProviderNo eq provider.utilityProviderNo}">selected</c:if>>
                                                                    <c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                                </option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="filterMeterTyCd">검침유형</label>
                                                <select class="form-select" id="filterMeterTyCd" name="meterTyCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${meterTyCodeList}">
                                                        <option value="${code.codeNoCd}" <c:if test="${search.meterTyCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="filterMeterRsltCd">결과</label>
                                                <select class="form-select" id="filterMeterRsltCd" name="meterRsltCd">
                                                    <option value="">전체</option>
                                                    <c:forEach var="code" items="${rsltCodeList}">
                                                        <option value="${code.codeNoCd}" <c:if test="${search.meterRsltCd eq code.codeNoCd}">selected</c:if>>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">검침일자</label>
                                                <div class="date-range-inputs">
                                                    <input type="date" class="form-input" id="filterStartDt" name="startDt" value="${search.startDt}">
                                                    <span class="date-filter-sep">~</span>
                                                    <input type="date" class="form-input" id="filterEndDt" name="endDt" value="${search.endDt}">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label" for="filterKeyword">시설 검색</label>
                                                <div class="search-wrap">
                                                    <span class="material-symbols-rounded">search</span>
                                                    <input type="text" class="form-input" id="filterKeyword" name="keyword" value="${search.keyword}" placeholder="시설명, 시설번호, 검침번호">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">&nbsp;</label>
                                                <div class="filter-actions">
                                                    <button type="submit" class="btn btn-primary">검색</button>
                                                    <a href="${ctx}/manager/meter/hstry/${mgmtOfcNo}" class="btn">초기화</a>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="panel panel-list">
                                <div class="panel-header">
                                    <div class="list-head-left">
                                        <h3 class="panel-title"><span class="material-symbols-rounded">format_list_bulleted</span>시설 검침 목록</h3>
                                        <span class="list-count">총 ${fn:length(facilityMeterList)}건</span>
                                    </div>
                                    <div class="list-head-right">
                                        <button type="button" class="btn btn-ghost" id="openFacilityInsertModalBtn">
                                            <span class="material-symbols-rounded">add</span>시설 검침 등록
                                        </button>
                                        <button type="button" class="btn btn-primary" id="openFacilityUploadModalBtn">
                                            <span class="material-symbols-rounded">upload_file</span>시설 검침 CSV 업로드
                                        </button>
                                    </div>
                                </div>
                                <div class="table-wrap">
                                    <table class="tbl">
                                        <colgroup>
                                            <col class="col-no"><col class="col-meter-no"><col class="col-meter-ty"><col class="col-meter-date">
                                            <col class="col-facility"><col class="col-facility-value"><col class="col-facility-value">
                                            <col class="col-facility-usage"><col class="col-result"><col class="col-facility-partner"><col class="col-action">
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>번호</th><th>검침번호</th><th>검침유형</th><th>검침일자</th>
                                            <th class="td-left">시설</th><th>이전값</th><th>현재값</th>
                                            <th>사용량</th><th>결과</th><th class="td-left">업체</th><th>관리</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:choose>
                                            <c:when test="${empty facilityMeterList}">
                                                <tr><td colspan="11" class="empty-row">조회된 시설 검침 이력이 없습니다.</td></tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="row" items="${facilityMeterList}" varStatus="status">
                                                    <tr class="js-page-row" data-page-target="facility">
                                                        <c:set var="meterUnit" value="" />
                                                        <c:if test="${row.meterTyCd eq 'ELEC'}"><c:set var="meterUnit" value="kWh" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'GAS' or row.meterTyCd eq 'WATER'}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <c:if test="${row.meterTyCd eq 'HEAT'}"><c:set var="meterUnit" value="Gcal" /></c:if>
                                                        <c:if test="${empty meterUnit and (row.facilityTyCd eq 'ELC' or fn:contains(row.facilityTyNm, '전기'))}"><c:set var="meterUnit" value="kWh" /></c:if>
                                                        <c:if test="${empty meterUnit and (row.facilityTyCd eq 'GAS' or fn:contains(row.facilityTyNm, '가스'))}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <c:if test="${empty meterUnit and (row.facilityTyCd eq 'WTR' or fn:contains(row.facilityTyNm, '급수') or fn:contains(row.facilityTyNm, '수도'))}"><c:set var="meterUnit" value="㎥" /></c:if>
                                                        <td class="mono">${fn:length(facilityMeterList) - status.index}</td>
                                                        <td class="meter-no">${row.meterHstryNo}</td>
                                                        <td><span class="badge badge-gray">${empty row.meterTyNm ? '-' : row.meterTyNm}</span></td>
                                                        <td><fmt:formatDate value="${row.meterDt}" pattern="yyyy.MM.dd"/></td>
                                                        <td class="td-left facility-cell">
                                                            <div class="meter-main">${row.facilityNm}</div>
                                                            <div class="meter-sub">${row.facilityNo} · ${row.facilityTyNm}</div>
                                                        </td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.preVal}" pattern="#,#0.##"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal}" pattern="#,#0.##"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td class="td-unit"><span class="unit-value"><fmt:formatNumber value="${row.currVal - row.preVal}" pattern="#,#0.##"/><span class="unit-label">${meterUnit}</span></span></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${row.meterRsltCd eq 'NORMAL'}"><span class="badge badge-normal">${row.meterRsltNm}</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'ERROR'}"><span class="badge badge-error">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:when test="${row.meterRsltCd eq 'MISS'}"><span class="badge badge-miss">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
                                                                <c:otherwise><span class="badge badge-gray">${empty row.meterRsltCd ? '-' : row.meterRsltCd}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="td-left partner-cell"><div>${row.partnerNm}</div></td>
                                                        <td>
                                                            <div class="row-actions">
                                                                <button type="button" class="btn btn-sm btn-ghost js-detail-btn" data-meter-hstry-no="${row.meterHstryNo}">상세</button>
                                                                <button type="button" class="btn btn-sm btn-edit js-edit-btn" data-meter-hstry-no="${row.meterHstryNo}">수정</button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="pagination-wrap" data-pagination-target="facility">
                                    <div class="pagination-info" id="facilityPaginationInfo">총 0건</div>
                                    <div class="pagination" id="facilityPagination"></div>
                                </div>
                            </div>
                        </section>

                    </div>
                </div>

                <%-- ===== 단지별 CSV 업로드 모달 ===== --%>
                <div class="modal-overlay" id="complexUploadModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">단지별 검침 CSV 업로드</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="complexUploadModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="post" action="${ctx}/manager/meter/hstry/upload/${mgmtOfcNo}" enctype="multipart/form-data" id="complexMeterCsvUploadForm">
                            <sec:csrfInput/>
                            <input type="hidden" name="meterScope" value="COMPLEX">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>업로드 파일 선택</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="complexUploadUtilityProviderNo">공급/검침 계약</label>
                                            <select class="form-select" id="complexUploadUtilityProviderNo" name="utilityProviderNo" required>
                                                <option value="">선택</option>
                                                <c:forEach var="provider" items="${providerList}">
                                                    <option value="${provider.utilityProviderNo}"
                                                            <c:if test="${empty provider.utilityProviderNo}">disabled</c:if>
                                                            data-meter-ty-cd="${provider.meterTyCd}"
                                                            data-meter-ty-nm="${provider.meterTyNm}"
                                                            data-cont-nm="${provider.contNm}"
                                                            data-cont-cn="${provider.contCn}"
                                                            data-cont-bgng-dt="${provider.contBgngDt}"
                                                            data-cont-end-dt="${provider.contEndDt}">
                                                        <c:choose><c:when test="${empty provider.utilityProviderNo}">[설정 필요] </c:when><c:otherwise><c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if></c:otherwise></c:choose>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                        <c:if test="${not empty provider.contBgngDt}"> (${provider.contBgngDt} ~ <c:choose><c:when test="${not empty provider.contEndDt}">${provider.contEndDt}</c:when><c:otherwise>진행중</c:otherwise></c:choose>)</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <%-- 선택한 계약 정보 표시 영역 --%>
                                            <div class="contract-info-box" id="complexContractInfoBox">
                                                <span class="contract-info-label">계약내용</span><span id="complexContractCn">-</span>
                                            </div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label" for="complexCsvFile">CSV 파일</label>
                                            <input type="file" class="form-input" id="complexCsvFile" name="csvFile" accept=".csv,text/csv" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>CSV 컬럼 안내</div>
                                    <div class="column-box"><code>csv_idntf_key, ext_cust_no, facility_no, ho_no, meter_dt, pre_val, curr_val, meter_cn, meter_rslt_cd</code></div>
                                    <div class="field-help" style="margin-top:6px;">ho_no는 세대번호(예: APT_1_101), csv_idntf_key / ext_cust_no는 선택한 계약의 설정값과 일치해야 합니다.</div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="complexUploadModal">취소</button>
                                <button type="submit" class="btn btn-primary">업로드</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- ===== 시설 CSV 업로드 모달 ===== --%>
                <div class="modal-overlay" id="facilityUploadModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">시설 검침 CSV 업로드</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="facilityUploadModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="post" action="${ctx}/manager/meter/hstry/upload/${mgmtOfcNo}" enctype="multipart/form-data" id="facilityMeterCsvUploadForm">
                            <sec:csrfInput/>
                            <input type="hidden" name="meterScope" value="FACILITY">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>업로드 파일 선택</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="facilityUploadUtilityProviderNo">공급/검침 계약</label>
                                            <select class="form-select" id="facilityUploadUtilityProviderNo" name="utilityProviderNo" required>
                                                <option value="">선택</option>
                                                <c:forEach var="provider" items="${providerList}">
                                                    <option value="${provider.utilityProviderNo}"
                                                            <c:if test="${empty provider.utilityProviderNo}">disabled</c:if>
                                                            data-meter-ty-cd="${provider.meterTyCd}"
                                                            data-meter-ty-nm="${provider.meterTyNm}"
                                                            data-cont-nm="${provider.contNm}"
                                                            data-cont-cn="${provider.contCn}"
                                                            data-cont-bgng-dt="${provider.contBgngDt}"
                                                            data-cont-end-dt="${provider.contEndDt}">
                                                        <c:choose><c:when test="${empty provider.utilityProviderNo}">[설정 필요] </c:when><c:otherwise><c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if></c:otherwise></c:choose>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                        <c:if test="${not empty provider.contBgngDt}"> (${provider.contBgngDt} ~ <c:choose><c:when test="${not empty provider.contEndDt}">${provider.contEndDt}</c:when><c:otherwise>진행중</c:otherwise></c:choose>)</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="contract-info-box" id="facilityContractInfoBox">
                                                <span class="contract-info-label">계약내용</span><span id="facilityContractCn">-</span>
                                            </div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label" for="facilityCsvFile">CSV 파일</label>
                                            <input type="file" class="form-input" id="facilityCsvFile" name="csvFile" accept=".csv,text/csv" required>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>CSV 컬럼 안내</div>
                                    <div class="column-box"><code>csv_idntf_key, ext_cust_no, facility_no, meter_dt, pre_val, curr_val, meter_cn, meter_rslt_cd</code></div>
                                    <div class="field-help" style="margin-top:6px;">시설 검침은 ho_no 없이 facility_no만 사용합니다. csv_idntf_key / ext_cust_no는 선택한 계약의 설정값과 일치해야 합니다.</div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="facilityUploadModal">취소</button>
                                <button type="submit" class="btn btn-primary">업로드</button>
                            </div>
                        </form>
                    </div>
                </div>



                <%-- ===== 단지별 수동 등록 모달 ===== --%>
                <div class="modal-overlay" id="complexInsertModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">단지별 검침 등록</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="complexInsertModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="post" action="${ctx}/manager/meter/hstry/insert/${mgmtOfcNo}" id="complexMeterInsertForm">
                            <sec:csrfInput/>
                            <input type="hidden" name="meterScope" value="COMPLEX">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">add</span>기본 정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="complexInsertUtilityProviderNo">공급/검침 계약</label>
                                            <select class="form-select" id="complexInsertUtilityProviderNo" name="utilityProviderNo" required>
                                                <option value="">선택</option>
                                                <c:forEach var="provider" items="${providerList}">
                                                    <option value="${provider.utilityProviderNo}"
                                                            <c:if test="${empty provider.utilityProviderNo}">disabled</c:if>
                                                            data-meter-ty-cd="${provider.meterTyCd}"
                                                            data-meter-ty-nm="${provider.meterTyNm}">
                                                        <c:choose><c:when test="${empty provider.utilityProviderNo}">[설정 필요] </c:when><c:otherwise><c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if></c:otherwise></c:choose>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="field-help" id="complexInsertMeterTypeGuide">검침 계약을 선택하면 유형과 단위가 표시됩니다.</div>
                                        </div>
                                        <input type="hidden" id="complexInsertFacilityNo" name="facilityNo">
                                        <input type="hidden" id="complexInsertHoNo" name="hoNo">
                                        <div class="form-field">
                                            <label class="field-label" for="complexInsertDongNo">동</label>
                                            <select class="form-select" id="complexInsertDongNo" required>
                                                <option value="">동 선택</option>
                                                <c:forEach var="dong" items="${dongList}">
                                                    <option value="${dong.dongNo}">${dong.dongNo}동</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label" for="complexInsertHoInput">호</label>
                                            <input type="text" class="form-input" id="complexInsertHoInput" list="complexHoDatalist" placeholder="예: 1502" required>
                                            <datalist id="complexHoDatalist"></datalist>
                                        </div>
                                        <div class="form-field"><label class="field-label" for="complexInsertMeterDt">검침일자</label><input type="date" class="form-input" id="complexInsertMeterDt" name="meterDt" required></div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">edit</span>검침 값</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label" for="complexInsertPreVal">이전값 <span class="unit-suffix js-complex-unit">-</span></label><input type="number" step="0.01" class="form-input" id="complexInsertPreVal" name="preVal" required></div>
                                        <div class="form-field"><label class="field-label" for="complexInsertCurrVal">현재값 <span class="unit-suffix js-complex-unit">-</span></label><input type="number" step="0.01" class="form-input" id="complexInsertCurrVal" name="currVal" required></div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="complexInsertMeterRsltCd">결과</label>
                                            <select class="form-select" id="complexInsertMeterRsltCd" name="meterRsltCd" required>
                                                <option value="">선택</option>
                                                <c:forEach var="code" items="${rsltCodeList}"><option value="${code.codeNoCd}">${code.codeName}</option></c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row"><div class="form-field"><label class="field-label" for="complexInsertMeterCn">검침내용</label><textarea class="form-textarea" id="complexInsertMeterCn" name="meterCn" placeholder="검침 내용 또는 특이사항"></textarea></div></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="complexInsertModal">취소</button>
                                <button type="submit" class="btn btn-primary">등록</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- ===== 시설 수동 등록 모달 ===== --%>
                <div class="modal-overlay" id="facilityInsertModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">시설 검침 등록</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="facilityInsertModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="post" action="${ctx}/manager/meter/hstry/insert/${mgmtOfcNo}" id="facilityMeterInsertForm">
                            <sec:csrfInput/>
                            <input type="hidden" name="meterScope" value="FACILITY">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">add</span>기본 정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="facilityInsertUtilityProviderNo">공급/검침 계약</label>
                                            <select class="form-select" id="facilityInsertUtilityProviderNo" name="utilityProviderNo" required>
                                                <option value="">선택</option>
                                                <c:forEach var="provider" items="${providerList}">
                                                    <option value="${provider.utilityProviderNo}"
                                                            <c:if test="${empty provider.utilityProviderNo}">disabled</c:if>
                                                            data-meter-ty-cd="${provider.meterTyCd}"
                                                            data-meter-ty-nm="${provider.meterTyNm}">
                                                        <c:choose><c:when test="${empty provider.utilityProviderNo}">[설정 필요] </c:when><c:otherwise><c:if test="${not empty provider.meterTyNm}">[${provider.meterTyNm}] </c:if></c:otherwise></c:choose>${provider.partnerNm}<c:if test="${not empty provider.contNm}"> / ${provider.contNm}</c:if>
                                                    </option>
                                                </c:forEach>
                                            </select>
                                            <div class="field-help" id="facilityInsertMeterTypeGuide">검침 계약을 선택하면 유형과 단위가 표시됩니다.</div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label" for="facilityInsertFacilityNo">시설번호</label>
                                            <div class="lookup-row">
                                                <input type="text" class="form-input" id="facilityInsertFacilityNo" name="facilityNo" placeholder="예: FAC1001" required>
                                                <button type="button" class="btn btn-sm btn-ghost" id="facilityLookupBtn">확인</button>
                                            </div>
                                            <div class="field-help">시설번호 입력 후 확인하면 시설명/유형/위치가 표시됩니다.</div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label" for="facilityInsertMeterDt">검침일자</label>
                                            <input type="date" class="form-input" id="facilityInsertMeterDt" name="meterDt" required>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-field">
                                            <label class="field-label">선택 시설 정보</label>
                                            <div class="readonly-box" id="facilityInsertFacilityInfo">시설번호를 입력하고 확인해주세요.</div>
                                        </div>
                                    </div>
                                    <input type="hidden" id="facilityInsertValidFacilityNo" value="">
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">edit</span>검침 값</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="facilityInsertPreVal">이전값 <span class="unit-suffix js-facility-unit">-</span></label>
                                            <input type="number" step="0.01" class="form-input" id="facilityInsertPreVal" name="preVal" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label" for="facilityInsertCurrVal">현재값 <span class="unit-suffix js-facility-unit">-</span></label>
                                            <input type="number" step="0.01" class="form-input" id="facilityInsertCurrVal" name="currVal" required>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="facilityInsertMeterRsltCd">결과</label>
                                            <select class="form-select" id="facilityInsertMeterRsltCd" name="meterRsltCd" required>
                                                <option value="">선택</option>
                                                <c:forEach var="code" items="${rsltCodeList}"><option value="${code.codeNoCd}">${code.codeName}</option></c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-field">
                                            <label class="field-label" for="facilityInsertMeterCn">검침내용</label>
                                            <textarea class="form-textarea" id="facilityInsertMeterCn" name="meterCn" placeholder="검침 내용 또는 특이사항"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="facilityInsertModal">취소</button>
                                <button type="submit" class="btn btn-primary">등록</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- ===== 상세 모달 ===== --%>
                <div class="modal-overlay" id="meterDetailModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">검침 이력 상세</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="meterDetailModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <%-- 검침 정보 --%>
                            <div class="form-section">
                                <div class="form-section-title"><span class="material-symbols-rounded">electric_meter</span>검침 정보</div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">검침이력번호</label><div class="readonly-box" id="detailMeterHstryNo">-</div></div>
                                    <div class="form-field"><label class="field-label">검침유형</label><div class="readonly-box" id="detailMeterTyNm">-</div></div>
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">검침일자</label><div class="readonly-box" id="detailMeterDt">-</div></div>
                                    <div class="form-field"><label class="field-label">결과</label><div class="readonly-box" id="detailMeterRsltNm">-</div></div>
                                </div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">이전값</label><div class="readonly-box" id="detailPreVal">-</div></div>
                                    <div class="form-field"><label class="field-label">현재값</label><div class="readonly-box" id="detailCurrVal">-</div></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-field"><label class="field-label">검침내용</label><div class="readonly-box multiline" id="detailMeterCn">-</div></div>
                                </div>
                            </div>
                            <%-- 단지 검침 대상 정보 --%>
                            <div class="form-section" id="detailComplexTargetSection">
                                <div class="form-section-title"><span class="material-symbols-rounded">apartment</span>단지 검침 대상</div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">동</label><div class="readonly-box" id="detailDongNo">-</div></div>
                                    <div class="form-field"><label class="field-label">호</label><div class="readonly-box" id="detailHoNo">-</div></div>
                                </div>
                            </div>
                            <%-- 시설 검침 대상 정보 --%>
                            <div class="form-section" id="detailFacilityTargetSection">
                                <div class="form-section-title"><span class="material-symbols-rounded">domain</span>시설 검침 대상</div>
                                <div class="form-row cols-2">
                                    <div class="form-field"><label class="field-label">시설명</label><div class="readonly-box" id="detailFacilityNm">-</div></div>
                                    <div class="form-field"><label class="field-label">시설유형</label><div class="readonly-box" id="detailFacilityTyNm">-</div></div>
                                </div>
                                <div class="form-row">
                                    <div class="form-field"><label class="field-label">상세위치</label><div class="readonly-box" id="detailLocCn">-</div></div>
                                </div>
                            </div>
                            <%-- 업체 정보 : 상세 모달에서는 업체명/담당자/연락처만 한 줄로 간단히 표시 --%>
                            <div class="form-section">
                                <div class="form-section-title"><span class="material-symbols-rounded">handshake</span>업체 정보</div>
                                <div class="form-row">
                                    <div class="form-field"><label class="field-label">업체</label><div class="readonly-box" id="detailPartnerSummary">-</div></div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn js-modal-close" data-modal-id="meterDetailModal">닫기</button>
                        </div>
                    </div>
                </div>

                <%-- ===== 수정 모달 ===== --%>
                <div class="modal-overlay" id="meterEditModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">검침 이력 수정</h3>
                            <button type="button" class="modal-close js-modal-close" data-modal-id="meterEditModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form method="post" action="${ctx}/manager/meter/hstry/update/${mgmtOfcNo}" id="meterEditForm">
                            <sec:csrfInput/>
                            <input type="hidden" name="meterHstryNo" id="editMeterHstryNo">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">lock</span>변경 불가 정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label">검침번호</label><div class="readonly-box" id="editReadonlyMeterHstryNo">-</div></div>
                                        <div class="form-field"><label class="field-label">검침유형</label><div class="readonly-box" id="editReadonlyMeterTyNm">-</div></div>
                                        <div class="form-field" id="editFacilityTargetRow"><label class="field-label">시설</label><div class="readonly-box" id="editReadonlyFacilityNm">-</div></div>
                                        <div class="form-field" id="editComplexTargetRow"><label class="field-label">동/호</label><div class="readonly-box" id="editReadonlyHoNo">-</div></div>
                                        <div class="form-field"><label class="field-label">업체</label><div class="readonly-box" id="editReadonlyPartnerNm">-</div></div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">edit</span>수정 정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label" for="editMeterDt">검침일자</label><input type="date" class="form-input" name="meterDt" id="editMeterDt" required></div>
                                        <div class="form-field">
                                            <label class="field-label" for="editMeterRsltCd">결과</label>
                                            <select class="form-select" name="meterRsltCd" id="editMeterRsltCd" required>
                                                <option value="">선택</option>
                                                <c:forEach var="code" items="${rsltCodeList}">
                                                    <option value="${code.codeNoCd}">${code.codeName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label" for="editPreVal">이전값 <span class="unit-suffix" id="editUnitLabel1">-</span></label><input type="number" step="0.01" class="form-input" name="preVal" id="editPreVal" required></div>
                                        <div class="form-field"><label class="field-label" for="editCurrVal">현재값 <span class="unit-suffix" id="editUnitLabel2">-</span></label><input type="number" step="0.01" class="form-input" name="currVal" id="editCurrVal" required></div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-field"><label class="field-label" for="editMeterCn">검침내용</label><textarea class="form-textarea" name="meterCn" id="editMeterCn"></textarea></div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="meterEditModal">취소</button>
                                <button type="submit" class="btn btn-primary">저장</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div><%-- /meterPage --%>
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        var ctx = '${ctx}';
        var mgmtOfcNo = '${mgmtOfcNo}';

        /* 단지 검침 등록용 동/호 후보 목록 */
        var complexUnitList = [
            <c:forEach var="row" items="${complexMeterList}" varStatus="st">
            <c:set var="hoPartsForJs" value="${fn:split(row.hoNo, '_')}" />
            <c:if test="${fn:length(hoPartsForJs) ge 3}">
            { dong: '${hoPartsForJs[1]}', ho: '${hoPartsForJs[2]}' }<c:if test="${not st.last}">,</c:if>
            </c:if>
            </c:forEach>
        ];

        /* ============================================================
           모달 열기/닫기
        ============================================================ */
        function openMeterModal(modalId) {
            if (window.openModal) { window.openModal(modalId); return; }
            var modal = document.getElementById(modalId);
            if (modal) modal.classList.add('open');
        }

        function closeMeterModal(modalId) {
            if (window.closeModal) { window.closeModal(modalId); }
            else {
                var modal = document.getElementById(modalId);
                if (modal) modal.classList.remove('open');
            }
            var modalForm = document.querySelector('#' + modalId + ' form');
            if (modalForm) modalForm.reset();
            /* 계약 정보 박스 초기화 */
            var infoBox = document.querySelector('#' + modalId + ' .contract-info-box');
            if (infoBox) infoBox.classList.remove('visible');
        }

        /* 공통 닫기 이벤트 */
        document.querySelectorAll('.js-modal-close').forEach(function (btn) {
            btn.addEventListener('click', function () { closeMeterModal(btn.getAttribute('data-modal-id')); });
        });
        document.querySelectorAll('.modal-overlay').forEach(function (overlay) {
            overlay.addEventListener('click', function (e) { if (e.target === overlay) closeMeterModal(overlay.id); });
        });

        /* ============================================================
           업로드 모달 열기 버튼
        ============================================================ */
        var complexUploadBtn = document.getElementById('openComplexUploadModalBtn');
        var facilityUploadBtn = document.getElementById('openFacilityUploadModalBtn');
        var complexInsertBtn = document.getElementById('openComplexInsertModalBtn');
        var facilityInsertBtn = document.getElementById('openFacilityInsertModalBtn');
        if (complexUploadBtn) complexUploadBtn.addEventListener('click', function () { openMeterModal('complexUploadModal'); });
        if (facilityUploadBtn) facilityUploadBtn.addEventListener('click', function () { openMeterModal('facilityUploadModal'); });
        if (complexInsertBtn) complexInsertBtn.addEventListener('click', function () { openMeterModal('complexInsertModal'); });
        if (facilityInsertBtn) facilityInsertBtn.addEventListener('click', function () { openMeterModal('facilityInsertModal'); });

        /* ============================================================
           업로드 모달 - 계약 선택 시 계약 내용 표시
        ============================================================ */
        function bindProviderSelect(selectId, infoBoxId, contCnId) {
            var sel = document.getElementById(selectId);
            var box = document.getElementById(infoBoxId);
            var cnEl = document.getElementById(contCnId);
            if (!sel || !box || !cnEl) return;

            sel.addEventListener('change', function () {
                var opt = sel.options[sel.selectedIndex];
                var contCn = opt ? opt.getAttribute('data-cont-cn') : '';
                if (contCn) {
                    cnEl.textContent = contCn;
                    box.classList.add('visible');
                } else {
                    box.classList.remove('visible');
                }
            });
        }

        bindProviderSelect('complexUploadUtilityProviderNo', 'complexContractInfoBox', 'complexContractCn');
        bindProviderSelect('facilityUploadUtilityProviderNo', 'facilityContractInfoBox', 'facilityContractCn');

        /* ============================================================
           날짜/값 표시 유틸
        ============================================================ */
        function toDateInputValue(value) {
            if (!value) return '';
            if (typeof value === 'string' && value.length >= 10) return value.substring(0, 10);
            return '';
        }

        function toDisplayValue(value) {
            return (value == null || value === '') ? '-' : String(value);
        }

        /* ho_no 표시 변환
           - DB 값 예: A12127003_4_1502
           - 화면 표시: 4동 / 1502호 또는 4동 1502호 */
        function parseHoNo(hoNo) {
            if (!hoNo) return { dong: '', ho: '', text: '' };

            var raw = String(hoNo);
            var parts = raw.split('_');

            // 단지코드_동_호 형태이면 사람이 읽기 좋은 동/호로 변환
            if (parts.length >= 3) {
                var dong = parts[1];
                var ho = parts[2];
                return {
                    dong: dong + '동',
                    ho: ho + '호',
                    text: dong + '동 ' + ho + '호'
                };
            }

            // 이미 사람이 읽는 형태로 들어온 값이면 그대로 사용
            return { dong: '', ho: raw, text: raw };
        }

        /* 검침유형 표시 보정
           - meter_ty_cd 업데이트 전 데이터도 상세에서 최대한 구분되도록 보정 */
        function getMeterTypeText(row) {
            if (row.meterTyNm) return row.meterTyNm;
            if (row.meterTyCd) return row.meterTyCd;

            var source = ((row.utilityProviderNo || '') + ' ' + (row.meterCn || '')).toUpperCase();
            if (source.indexOf('ELC') > -1 || source.indexOf('ELEC') > -1 || source.indexOf('전기') > -1) return '전기계량';
            if (source.indexOf('WTR') > -1 || source.indexOf('WATER') > -1 || source.indexOf('수도') > -1 || source.indexOf('급수') > -1) return '수도계량';
            if (source.indexOf('GAS') > -1 || source.indexOf('가스') > -1) return '가스계량';
            if (source.indexOf('HEAT') > -1 || source.indexOf('난방') > -1) return '난방계량';

            return '-';
        }


        /* 검침유형별 단위 표시 */
        function getMeterUnitByCd(meterTyCd) {
            if (meterTyCd === 'ELEC') return 'kWh';
            if (meterTyCd === 'WATER' || meterTyCd === 'GAS') return '㎥';
            if (meterTyCd === 'HEAT') return 'Gcal';
            return '';
        }

        function getMeterUnit(row) {
            var unit = getMeterUnitByCd(row.meterTyCd);
            if (unit) return unit;

            var source = ((row.meterTyNm || '') + ' ' + (row.utilityProviderNo || '') + ' ' + (row.meterCn || '')).toUpperCase();
            if (source.indexOf('ELC') > -1 || source.indexOf('ELEC') > -1 || source.indexOf('전기') > -1) return 'kWh';
            if (source.indexOf('WTR') > -1 || source.indexOf('WATER') > -1 || source.indexOf('수도') > -1 || source.indexOf('급수') > -1) return '㎥';
            if (source.indexOf('GAS') > -1 || source.indexOf('가스') > -1) return '㎥';
            if (source.indexOf('HEAT') > -1 || source.indexOf('난방') > -1) return 'Gcal';
            return '';
        }

        function setDisplay(elId, value) {
            var el = document.getElementById(elId);
            if (el) el.textContent = toDisplayValue(value);
        }

        function showElement(elId, show) {
            var el = document.getElementById(elId);
            if (el) el.style.display = show ? '' : 'none';
        }

        /* 업체 요약 표시
           - 상세 모달에서는 계약번호/계약명까지 늘리지 않고 업체명, 담당자, 연락처만 한 줄로 표시 */
        function getPartnerSummary(row) {
            var values = [];
            if (row.partnerNm) values.push(row.partnerNm);
            if (row.picNm) values.push('담당자 ' + row.picNm);
            if (row.picTelno) values.push(row.picTelno);
            return values.length ? values.join(' / ') : '-';
        }

        /* ============================================================
           상세 모달 값 세팅
        ============================================================ */
        function fillDetailModal(row) {
            /* 검침 정보 */
            var unit = getMeterUnit(row);
            setDisplay('detailMeterHstryNo', row.meterHstryNo);
            setDisplay('detailMeterTyNm', getMeterTypeText(row));
            setDisplay('detailMeterDt', toDateInputValue(row.meterDt));
            setDisplay('detailPreVal', (row.preVal == null ? '-' : row.preVal) + (unit ? ' ' + unit : ''));
            setDisplay('detailCurrVal', (row.currVal == null ? '-' : row.currVal) + (unit ? ' ' + unit : ''));
            setDisplay('detailMeterRsltNm', row.meterRsltNm || row.meterRsltCd);
            setDisplay('detailMeterCn', row.meterCn);

            /* 시설 검침 / 단지 검침 대상 정보 분리 */
            if (row.hoNo) {
                var hoInfo = parseHoNo(row.hoNo);
                showElement('detailComplexTargetSection', true);
                showElement('detailFacilityTargetSection', false);
                setDisplay('detailDongNo', hoInfo.dong || row.dongNo);
                setDisplay('detailHoNo', hoInfo.ho || row.hoNo);
            } else {
                showElement('detailComplexTargetSection', false);
                showElement('detailFacilityTargetSection', true);
                setDisplay('detailFacilityNm', row.facilityNm);
                setDisplay('detailFacilityTyNm', row.facilityTyNm);
                setDisplay('detailLocCn', row.locCn);
            }

            /* 업체 정보 */
            setDisplay('detailPartnerSummary', getPartnerSummary(row));
        }

        /* ============================================================
           수정 모달 값 세팅
        ============================================================ */
        function fillEditModal(row) {
            /* 읽기전용 표시 */
            var unit = getMeterUnit(row);
            setDisplay('editReadonlyMeterHstryNo', row.meterHstryNo);
            setDisplay('editReadonlyMeterTyNm', getMeterTypeText(row));
            setDisplay('editReadonlyFacilityNm', row.facilityNm);
            setDisplay('editReadonlyHoNo', row.hoNo ? parseHoNo(row.hoNo).text : '-');
            setDisplay('editReadonlyPartnerNm', row.partnerNm);
            showElement('editComplexTargetRow', !!row.hoNo);
            showElement('editFacilityTargetRow', !row.hoNo);
            setDisplay('editUnitLabel1', unit || '-');
            setDisplay('editUnitLabel2', unit || '-');
            /* 수정 가능 필드 */
            document.getElementById('editMeterHstryNo').value  = row.meterHstryNo || '';
            document.getElementById('editMeterDt').value       = toDateInputValue(row.meterDt);
            document.getElementById('editPreVal').value        = row.preVal == null ? '' : row.preVal;
            document.getElementById('editCurrVal').value       = row.currVal == null ? '' : row.currVal;
            document.getElementById('editMeterRsltCd').value   = row.meterRsltCd || '';
            document.getElementById('editMeterCn').value       = row.meterCn || '';
        }

        /* ============================================================
           검침 이력 상세 API 조회
        ============================================================ */
        function fetchMeterDetail(meterHstryNo, callback) {
            fetch(ctx + '/manager/meter/hstry/detail/' + mgmtOfcNo + '/' + encodeURIComponent(meterHstryNo), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
                .then(function (res) {
                    if (!res.ok) throw new Error('검침 이력 조회 실패');
                    return res.json();
                })
                .then(function (result) {
                    if (!result.success) throw new Error(result.message || '검침 이력 조회 실패');
                    callback(result.meterHstry || result.meter || result.data);
                })
                .catch(function (err) { alert(err.message); });
        }

        /* ============================================================
           상세/수정 버튼 이벤트
        ============================================================ */
        document.querySelectorAll('.js-detail-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                fetchMeterDetail(btn.getAttribute('data-meter-hstry-no'), function (row) {
                    fillDetailModal(row || {});
                    openMeterModal('meterDetailModal');
                });
            });
        });

        document.querySelectorAll('.js-edit-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                fetchMeterDetail(btn.getAttribute('data-meter-hstry-no'), function (row) {
                    fillEditModal(row || {});
                    openMeterModal('meterEditModal');
                });
            });
        });

        /* ============================================================
           단지/시설 등록 모달 보조 처리
        ============================================================ */
        function refreshUnitBySelect(selectId, selector, guideId) {
            var sel = document.getElementById(selectId);
            if (!sel) return;
            var opt = sel.options[sel.selectedIndex];
            var tyNm = opt ? (opt.getAttribute('data-meter-ty-nm') || '') : '';
            var tyCd = opt ? (opt.getAttribute('data-meter-ty-cd') || '') : '';
            var unit = getMeterUnitByCd(tyCd);

            // 검침유형별 단위 표시 갱신
            document.querySelectorAll(selector).forEach(function (el) { el.textContent = unit || '-'; });

            // 등록 모달에서 사용자가 어떤 검침인지 바로 알 수 있도록 안내 문구 갱신
            if (guideId) {
                var guide = document.getElementById(guideId);
                if (guide) {
                    guide.textContent = tyNm ? ('선택 유형: ' + tyNm + (unit ? ' / 단위: ' + unit : '')) : '검침 계약을 선택하면 유형과 단위가 표시됩니다.';
                }
            }
        }

        function populateDongSelect() {
            var dongEl = document.getElementById('complexInsertDongNo');
            if (!dongEl) return;

            // 서버에서 내려준 동 목록이 있으면 그대로 사용하고, 없을 때만 현재 목록 데이터에서 보강함
            if (dongEl.options.length > 1) return;

            var unique = {};
            complexUnitList.forEach(function (item) { if (item.dong) unique[item.dong] = true; });
            Object.keys(unique).sort(function (a, b) { return Number(a) - Number(b); }).forEach(function (dong) {
                var opt = document.createElement('option');
                opt.value = dong;
                opt.textContent = dong + '동';
                dongEl.appendChild(opt);
            });
        }

        function renderHoOptions(list) {
            var dongEl = document.getElementById('complexInsertDongNo');
            var listEl = document.getElementById('complexHoDatalist');
            if (!listEl) return;

            var dong = dongEl ? dongEl.value : '';
            listEl.innerHTML = '';
            (list || []).forEach(function (item) {
                var ho = item.hoNo || item.ho || item.HONO || item.HO_NO;
                if (!ho) return;
                var opt = document.createElement('option');
                opt.value = ho;
                opt.label = dong ? (dong + '동 ' + ho + '호') : (ho + '호');
                listEl.appendChild(opt);
            });
        }

        function refreshHoDatalist() {
            var dongEl = document.getElementById('complexInsertDongNo');
            var hoInput = document.getElementById('complexInsertHoInput');
            var dong = dongEl ? dongEl.value : '';
            var keyword = hoInput ? hoInput.value.replace('호', '').trim() : '';

            // 서버 API로 동/호 후보를 조회함. 실패 시 현재 화면 데이터 기반 후보로 대체함
            if (dong) {
                fetch(ctx + '/manager/meter/hstry/ho-suggest/' + mgmtOfcNo + '?dongNo=' + encodeURIComponent(dong) + '&keyword=' + encodeURIComponent(keyword), {
                    method: 'GET',
                    headers: { 'Accept': 'application/json' }
                })
                    .then(function (res) { return res.ok ? res.json() : Promise.reject(); })
                    .then(function (result) {
                        if (result && result.success) {
                            renderHoOptions(result.hoList || []);
                        } else {
                            renderHoOptionsByPageData(dong, keyword);
                        }
                    })
                    .catch(function () { renderHoOptionsByPageData(dong, keyword); });
                return;
            }

            renderHoOptionsByPageData(dong, keyword);
        }

        function renderHoOptionsByPageData(dong, keyword) {
            var listEl = document.getElementById('complexHoDatalist');
            if (!listEl) return;

            var unique = {};
            listEl.innerHTML = '';
            complexUnitList.forEach(function (item) {
                if (dong && item.dong !== dong) return;
                if (keyword && String(item.ho).indexOf(keyword) !== 0) return;
                if (item.ho) unique[item.ho] = true;
            });
            Object.keys(unique).sort(function (a, b) { return Number(a) - Number(b); }).forEach(function (ho) {
                var opt = document.createElement('option');
                opt.value = ho;
                opt.label = dong ? (dong + '동 ' + ho + '호') : (ho + '호');
                listEl.appendChild(opt);
            });
        }

        function lookupFacilityInfo() {
            var input = document.getElementById('facilityInsertFacilityNo');
            var valid = document.getElementById('facilityInsertValidFacilityNo');
            var info = document.getElementById('facilityInsertFacilityInfo');
            if (!input || !info) return;

            var facilityNo = input.value.trim();
            if (valid) valid.value = '';
            if (!facilityNo) {
                info.textContent = '시설번호를 입력하고 확인해주세요.';
                return;
            }

            info.textContent = '시설 정보를 확인하는 중입니다.';
            fetch(ctx + '/manager/meter/hstry/facility/' + mgmtOfcNo + '?facilityNo=' + encodeURIComponent(facilityNo), {
                method: 'GET',
                headers: { 'Accept': 'application/json' }
            })
                .then(function (res) {
                    if (!res.ok) throw new Error('시설 정보 조회 실패');
                    return res.json();
                })
                .then(function (result) {
                    if (!result.success) throw new Error(result.message || '시설 정보를 찾을 수 없습니다.');
                    var f = result.facility || {};
                    if (valid) valid.value = f.facilityNo || facilityNo;
                    info.textContent = (f.facilityNo || facilityNo) + ' / ' + (f.facilityNm || '-') + ' / ' + (f.facilityTyNm || '-') + ' / ' + (f.locCn || '-');
                })
                .catch(function (err) {
                    if (valid) valid.value = '';
                    info.textContent = err.message;
                });
        }

        function bindComplexInsertForm() {
            var form = document.getElementById('complexMeterInsertForm');
            var provider = document.getElementById('complexInsertUtilityProviderNo');
            var dong = document.getElementById('complexInsertDongNo');
            var hoInput = document.getElementById('complexInsertHoInput');
            var hoHidden = document.getElementById('complexInsertHoNo');
            var facilityHidden = document.getElementById('complexInsertFacilityNo');
            if (!form) return;

            if (provider) {
                provider.addEventListener('change', function () {
                    refreshUnitBySelect('complexInsertUtilityProviderNo', '.js-complex-unit', 'complexInsertMeterTypeGuide');
                    if (facilityHidden) facilityHidden.value = provider.value || '';
                });
            }
            populateDongSelect();
            if (dong) dong.addEventListener('change', refreshHoDatalist);
            if (hoInput) hoInput.addEventListener('input', refreshHoDatalist);
            refreshHoDatalist();

            form.addEventListener('submit', function (e) {
                var dongVal = dong ? dong.value : '';
                var hoVal = hoInput ? hoInput.value.replace('호', '').trim() : '';
                if (!dongVal || !hoVal) {
                    e.preventDefault();
                    alert('동과 호를 입력해주세요.');
                    return;
                }
                // 화면은 4동/1502호 기준, 서버에서 단지번호_동_호 형태로 정규화함
                hoHidden.value = dongVal + '_' + hoVal;
                if (facilityHidden && !facilityHidden.value && provider) facilityHidden.value = provider.value || '';
            });
        }

        function bindFacilityInsertForm() {
            var form = document.getElementById('facilityMeterInsertForm');
            var provider = document.getElementById('facilityInsertUtilityProviderNo');
            var facilityInput = document.getElementById('facilityInsertFacilityNo');
            var lookupBtn = document.getElementById('facilityLookupBtn');
            var valid = document.getElementById('facilityInsertValidFacilityNo');
            if (!form) return;

            if (provider) {
                provider.addEventListener('change', function () {
                    refreshUnitBySelect('facilityInsertUtilityProviderNo', '.js-facility-unit', 'facilityInsertMeterTypeGuide');
                });
            }
            if (lookupBtn) lookupBtn.addEventListener('click', lookupFacilityInfo);
            if (facilityInput) {
                facilityInput.addEventListener('blur', lookupFacilityInfo);
                facilityInput.addEventListener('input', function () {
                    if (valid) valid.value = '';
                    setDisplay('facilityInsertFacilityInfo', '시설번호를 입력하고 확인해주세요.');
                });
            }

            form.addEventListener('submit', function (e) {
                var inputVal = facilityInput ? facilityInput.value.trim() : '';
                var validVal = valid ? valid.value : '';
                if (!inputVal) {
                    e.preventDefault();
                    alert('시설번호를 입력해주세요.');
                    return;
                }
                if (valid && validVal !== inputVal) {
                    e.preventDefault();
                    alert('시설번호 확인 버튼으로 시설 정보를 먼저 확인해주세요.');
                }
            });
        }

        bindComplexInsertForm();
        bindFacilityInsertForm();

        /* ============================================================
           페이지네이션
        ============================================================ */
        function initMeterPagination(targetName) {
            var pageSize = 10;
            var currentPage = 1;
            var rows = Array.prototype.slice.call(document.querySelectorAll('.js-page-row[data-page-target="' + targetName + '"]'));
            var pagination = document.getElementById(targetName + 'Pagination');
            var paginationInfo = document.getElementById(targetName + 'PaginationInfo');
            var paginationWrap = document.querySelector('[data-pagination-target="' + targetName + '"]');
            var totalCount = rows.length;
            var totalPage = Math.ceil(totalCount / pageSize);

            if (!pagination || !paginationInfo || !paginationWrap) return;

            if (totalCount === 0) { paginationWrap.style.display = 'none'; return; }
            paginationWrap.style.display = 'flex';

            function renderRows() {
                var s = (currentPage - 1) * pageSize;
                var e = s + pageSize;
                rows.forEach(function (r, i) { r.style.display = (i >= s && i < e) ? '' : 'none'; });
                paginationInfo.textContent = '총 ' + totalCount + '건 · ' + currentPage + ' / ' + totalPage + '페이지';
            }

            function createBtn(label, pageNo, disabled, active) {
                var b = document.createElement('button');
                b.type = 'button';
                b.className = 'page-btn' + ((label === '이전' || label === '다음') ? ' page-btn-nav' : '') + (active ? ' active' : '');
                b.textContent = label;
                b.disabled = disabled;
                b.addEventListener('click', function () { currentPage = pageNo; render(); });
                return b;
            }

            function render() {
                renderRows();
                pagination.innerHTML = '';
                pagination.appendChild(createBtn('이전', Math.max(1, currentPage - 1), currentPage === 1, false));
                var sp = Math.max(1, currentPage - 2);
                var ep = Math.min(totalPage, sp + 4);
                sp = Math.max(1, ep - 4);
                for (var p = sp; p <= ep; p++) pagination.appendChild(createBtn(String(p), p, false, p === currentPage));
                pagination.appendChild(createBtn('다음', Math.min(totalPage, currentPage + 1), currentPage === totalPage, false));
            }

            render();
        }

        initMeterPagination('complex');
        initMeterPagination('facility');

    })();
</script>
</body>
</html>
