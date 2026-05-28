<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:url var="meterResetUrl" value="/manager/meter/hstry/${mgmtOfcNo}" />

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
        #meterPage .table-wrap { overflow-x:visible; margin:0 -1px; }
        #meterPage .tbl { width:100%; min-width:0; border-collapse:collapse; table-layout:fixed; }
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
        #meterPage .col-complex-unit { width:12%; }
        #meterPage .col-facility { width:18%; }
        #meterPage .col-ho { width:10%; }
        #meterPage .col-complex-value { width:8%; }
        #meterPage .col-facility-value { width:8%; }
        #meterPage .col-complex-usage { width:8%; }
        #meterPage .col-facility-usage { width:8%; }
        #meterPage .col-result { width:7%; }
        #meterPage .col-complex-partner { width:17%; }
        #meterPage .col-facility-partner { width:11%; }
        #meterPage .col-action { width:10%; }

        /* 상태 배지 */
        #meterPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #meterPage .badge-normal { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #meterPage .badge-error { background:#fee2e2; color:#7f1d1d; border-color:#fecaca; }
        #meterPage .badge-miss { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #meterPage .badge-check { background:#ffedd5; color:#9a3412; border-color:#fed7aa; }
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

        /* CSV 확인 결과 */
        #meterPage .csv-preview-box { display:none; margin-top:10px; border:1px solid #c9d9cc; border-radius:6px; background:#f8fbf8; overflow:hidden; }
        #meterPage .csv-preview-box.visible { display:block; }
        #meterPage .csv-preview-head { padding:10px 12px; border-bottom:1px solid #d9e5dc; background:#f0f4f1; font-size:12px; font-weight:800; color:var(--text-head); }
        #meterPage .csv-preview-body { padding:10px 12px; }
        #meterPage .csv-preview-grid { display:grid; grid-template-columns:90px minmax(0,1fr); gap:6px 10px; margin-bottom:10px; font-size:11px; line-height:1.45; }
        #meterPage .csv-preview-label { color:#5f6f64; font-weight:800; }
        #meterPage .csv-preview-value { color:#1f2d23; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #meterPage .preview-table-wrap { overflow-x:auto; border:1px solid #e5e7eb; border-radius:4px; background:#fff; }
        #meterPage .preview-table { width:100%; border-collapse:collapse; min-width:640px; table-layout:fixed; }
        #meterPage .preview-table th, #meterPage .preview-table td { height:30px; padding:5px 7px; border-bottom:1px solid #eef1f3; font-size:11px; text-align:center; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #meterPage .preview-table th { background:#f3f5f4; color:#4b5b50; font-weight:800; }
        #meterPage .preview-msg { margin-top:8px; font-size:11px; line-height:1.45; color:#166534; font-weight:700; }
        #meterPage .preview-msg.error { color:#991b1b; }
        #meterPage .preview-msg.warn { color:#92400e; }

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

                <%-- 검침 탭 영역 --%>
                <div class="meter-tab-wrap">
                    <input type="radio" class="meter-tab-input" name="meterTab" id="meterTabComplex" <c:if test="${param.meterScope ne 'FACILITY'}">checked</c:if>>
                    <input type="radio" class="meter-tab-input" name="meterTab" id="meterTabFacility" <c:if test="${param.meterScope eq 'FACILITY'}">checked</c:if>>

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
                                        <%-- 협력업체 상세에서 넘어온 partnerNo 필터를 검색 후에도 유지함 --%>
                                        <input type="hidden" name="partnerNo" value="${complexSearch.partnerNo}">
                                        <%-- 검색 후에도 단지별 검침 탭을 유지함 --%>
                                        <input type="hidden" name="meterScope" value="COMPLEX">
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
                                                    <input type="text" class="form-input" id="complexKeyword" name="complexKeyword" value="${complexSearch.keyword}" placeholder="동, 호번호 또는 MH로 시작하는 검침번호">
                                                </div>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">&nbsp;</label>
                                                <div class="filter-actions">
                                                    <button type="submit" class="btn btn-primary">검색</button>
                                                    <a href="${meterResetUrl}" class="btn">초기화</a>
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
                                                                <c:when test="${row.meterRsltCd eq 'CHECK'}"><span class="badge badge-check">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
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
                                        <%-- 협력업체 상세에서 넘어온 partnerNo 필터를 검색 후에도 유지함 --%>
                                        <input type="hidden" name="partnerNo" value="${search.partnerNo}">
                                        <%-- 검색 후에도 시설 검침 탭을 유지함 --%>
                                        <input type="hidden" name="meterScope" value="FACILITY">
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
                                                    <a href="${meterResetUrl}" class="btn">초기화</a>
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
                                                                <c:when test="${row.meterRsltCd eq 'CHECK'}"><span class="badge badge-check">${row.meterRsltNm}</span><span class="need-check">확인 필요</span></c:when>
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
                            <input type="hidden" name="utilityProviderNo" id="complexMatchedUtilityProviderNo">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>CSV 파일 선택 및 자동 확인</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="complexCsvFile">CSV 파일</label>
                                            <input type="file" class="form-input" id="complexCsvFile" name="csvFile" accept=".csv,text/csv" required>
                                            <div class="field-help">파일을 선택한 뒤 CSV 확인을 누르면 식별키 기준으로 검침 설정과 계약 정보를 자동으로 찾습니다.</div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">파일 확인</label>
                                            <button type="button" class="btn btn-primary" id="complexPreviewBtn">
                                                <span class="material-symbols-rounded">fact_check</span>CSV 확인
                                            </button>
                                            <div class="field-help">단지별 CSV는 동/호 식별값이 포함되어야 합니다.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>CSV 안내</div>
                                    <div class="column-box">
                                        <strong>필수 값</strong><br>
                                        검침일자, 이전값, 현재값, 검침결과, 검침내용, 동/호 식별값<br><br>
                                        <strong>시스템 확인 값</strong><br>
                                        CSV 식별키와 외부 고객번호는 검침 업체가 제공한 파일이 어떤 검침 설정에 해당하는지 확인하는 값입니다.
                                    </div>
                                </div>
                                <div class="csv-preview-box" id="complexPreviewBox">
                                    <div class="csv-preview-head">CSV 확인 결과</div>
                                    <div class="csv-preview-body">
                                        <div class="csv-preview-grid" id="complexPreviewSummary"></div>
                                        <div class="preview-table-wrap">
                                            <table class="preview-table">
                                                <thead>
                                                <tr>
                                                    <th>행</th><th>검침유형</th><th>동/호</th><th>검침일자</th><th>이전값</th><th>현재값</th><th>결과</th>
                                                </tr>
                                                </thead>
                                                <tbody id="complexPreviewRows"></tbody>
                                            </table>
                                        </div>
                                        <div class="preview-msg" id="complexPreviewMessage">CSV를 확인해주세요.</div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="complexUploadModal">취소</button>
                                <button type="submit" class="btn btn-primary" id="complexUploadSubmitBtn" disabled>업로드</button>
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
                            <input type="hidden" name="utilityProviderNo" id="facilityMatchedUtilityProviderNo">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>CSV 파일 선택 및 자동 확인</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="facilityCsvFile">CSV 파일</label>
                                            <input type="file" class="form-input" id="facilityCsvFile" name="csvFile" accept=".csv,text/csv" required>
                                            <div class="field-help">파일을 선택한 뒤 CSV 확인을 누르면 식별키 기준으로 검침 설정과 계약 정보를 자동으로 찾습니다.</div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">파일 확인</label>
                                            <button type="button" class="btn btn-primary" id="facilityPreviewBtn">
                                                <span class="material-symbols-rounded">fact_check</span>CSV 확인
                                            </button>
                                            <div class="field-help">시설 CSV는 시설번호가 포함되어야 합니다.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>CSV 안내</div>
                                    <div class="column-box">
                                        <strong>필수 값</strong><br>
                                        검침일자, 이전값, 현재값, 검침결과, 검침내용, 시설번호<br><br>
                                        <strong>시스템 확인 값</strong><br>
                                        CSV 식별키와 외부 고객번호는 검침 업체가 제공한 파일이 어떤 검침 설정에 해당하는지 확인하는 값입니다.
                                    </div>
                                </div>
                                <div class="csv-preview-box" id="facilityPreviewBox">
                                    <div class="csv-preview-head">CSV 확인 결과</div>
                                    <div class="csv-preview-body">
                                        <div class="csv-preview-grid" id="facilityPreviewSummary"></div>
                                        <div class="preview-table-wrap">
                                            <table class="preview-table">
                                                <thead>
                                                <tr>
                                                    <th>행</th><th>검침유형</th><th>시설번호</th><th>검침일자</th><th>이전값</th><th>현재값</th><th>결과</th>
                                                </tr>
                                                </thead>
                                                <tbody id="facilityPreviewRows"></tbody>
                                            </table>
                                        </div>
                                        <div class="preview-msg" id="facilityPreviewMessage">CSV를 확인해주세요.</div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn js-modal-close" data-modal-id="facilityUploadModal">취소</button>
                                <button type="submit" class="btn btn-primary" id="facilityUploadSubmitBtn" disabled>업로드</button>
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


<%-- 처리 결과 메시지 보관 영역
     - JSP 값을 JavaScript 문자열에 직접 넣으면 줄바꿈/따옴표 때문에 SyntaxError가 날 수 있으므로 textarea에 보관한다. --%>
<div id="meterFlashMessage" style="display:none;">
    <textarea id="meterSuccessMessage"><c:out value="${successMessage}" /></textarea>
    <textarea id="meterErrorMessage"><c:out value="${errorMessage}" /></textarea>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        var ctx = '${ctx}';
        var mgmtOfcNo = '${mgmtOfcNo}';

        /* ============================================================
           처리 결과 알림
           - redirect 메시지는 hidden textarea에서 읽어 JS 문자열 깨짐을 방지한다.
        ============================================================ */
        function readFlashMessage(messageId) {
            var messageEl = document.getElementById(messageId);
            return messageEl ? messageEl.value.trim() : '';
        }

        var successMessage = readFlashMessage('meterSuccessMessage');
        var errorMessage = readFlashMessage('meterErrorMessage');

        if (successMessage) {
            alert(successMessage);
        }

        if (errorMessage) {
            alert(errorMessage);
        }

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
            // 업로드 모달은 닫을 때 CSV 확인 결과와 hidden 설정값도 초기화함
            if (modalId === 'complexUploadModal') resetPreview('complex');
            if (modalId === 'facilityUploadModal') resetPreview('facility');
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
        if (complexUploadBtn) complexUploadBtn.addEventListener('click', function () { openMeterModal('complexUploadModal'); });
        if (facilityUploadBtn) facilityUploadBtn.addEventListener('click', function () { openMeterModal('facilityUploadModal'); });

        /* ============================================================
           업로드 모달 - CSV 확인/자동 매칭
        ============================================================ */
        function getCsrfHeader() {
            var header = document.querySelector('meta[name="_csrf_header"]');
            return header ? header.getAttribute('content') : '';
        }

        function getCsrfToken() {
            var token = document.querySelector('meta[name="_csrf"]');
            return token ? token.getAttribute('content') : '';
        }

        function resetPreview(prefix) {
            var box = document.getElementById(prefix + 'PreviewBox');
            var summary = document.getElementById(prefix + 'PreviewSummary');
            var rows = document.getElementById(prefix + 'PreviewRows');
            var msg = document.getElementById(prefix + 'PreviewMessage');
            var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');
            var submit = document.getElementById(prefix + 'UploadSubmitBtn');

            if (box) box.classList.remove('visible');
            if (summary) summary.innerHTML = '';
            if (rows) rows.innerHTML = '';
            if (msg) {
                msg.className = 'preview-msg';
                msg.textContent = 'CSV를 확인해주세요.';
            }
            if (hidden) hidden.value = '';
            if (submit) submit.disabled = true;
        }

        function renderPreview(prefix, result) {
            var box = document.getElementById(prefix + 'PreviewBox');
            var summary = document.getElementById(prefix + 'PreviewSummary');
            var rows = document.getElementById(prefix + 'PreviewRows');
            var msg = document.getElementById(prefix + 'PreviewMessage');
            var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');
            var submit = document.getElementById(prefix + 'UploadSubmitBtn');

            if (hidden) hidden.value = result.utilityProviderNo || '';
            if (box) box.classList.add('visible');

            if (summary) {
                var typeText = result.meterTyNm || '-';
                var periodText = (result.contBgngDt || '-') + ' ~ ' + (result.contEndDt || '진행중');
                summary.innerHTML = ''
                    + '<div class="csv-preview-label">업체</div><div class="csv-preview-value">' + escapeHtml(result.partnerNm || '-') + '</div>'
                    + '<div class="csv-preview-label">계약</div><div class="csv-preview-value">' + escapeHtml(result.contNm || '-') + '</div>'
                    + '<div class="csv-preview-label">계약기간</div><div class="csv-preview-value">' + escapeHtml(periodText) + '</div>'
                    + '<div class="csv-preview-label">CSV 식별키</div><div class="csv-preview-value">' + escapeHtml(result.csvIdntfKey || '-') + '</div>'
                    + '<div class="csv-preview-label">외부 고객번호</div><div class="csv-preview-value">' + escapeHtml(result.extCustNo || '-') + '</div>'
                    + '<div class="csv-preview-label">검침유형</div><div class="csv-preview-value">' + escapeHtml(typeText) + '</div>'
                    + '<div class="csv-preview-label">총 행수</div><div class="csv-preview-value">' + escapeHtml(String(result.totalCnt || 0)) + '건</div>'
                    + '<div class="csv-preview-label">계약내용</div><div class="csv-preview-value">' + escapeHtml(result.contCn || '-') + '</div>';
            }

            if (rows) {
                rows.innerHTML = '';
                (result.previewRows || []).forEach(function (r) {
                    var target = prefix === 'complex' ? (r.hoNo || '-') : (r.facilityNo || '-');
                    var tr = document.createElement('tr');
                    tr.innerHTML = ''
                        + '<td>' + escapeHtml(r.lineNo || '-') + '</td>'
                        + '<td>' + escapeHtml(r.meterTyNm || '-') + '</td>'
                        + '<td>' + escapeHtml(target) + '</td>'
                        + '<td>' + escapeHtml(r.meterDt || '-') + '</td>'
                        + '<td>' + escapeHtml((r.preVal || '-') + (r.meterUnit && r.meterUnit !== '-' ? ' ' + r.meterUnit : '')) + '</td>'
                        + '<td>' + escapeHtml((r.currVal || '-') + (r.meterUnit && r.meterUnit !== '-' ? ' ' + r.meterUnit : '')) + '</td>'
                        + '<td>' + escapeHtml(r.meterRsltCd || '-') + '</td>';
                    rows.appendChild(tr);
                });
            }

            if (msg) {
                var warnings = result.warnings || [];
                if (warnings.length > 0) {
                    msg.className = 'preview-msg warn';
                    msg.textContent = warnings.slice(0, 3).join(' / ') + (warnings.length > 3 ? ' 외 ' + (warnings.length - 3) + '건' : '');
                } else {
                    msg.className = 'preview-msg';
                    msg.textContent = result.message || 'CSV 확인이 완료되었습니다. 업로드할 수 있습니다.';
                }
            }

            if (submit) submit.disabled = !result.uploadable;
        }

        function showPreviewError(prefix, message) {
            var box = document.getElementById(prefix + 'PreviewBox');
            var msg = document.getElementById(prefix + 'PreviewMessage');
            var submit = document.getElementById(prefix + 'UploadSubmitBtn');
            var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');

            if (box) box.classList.add('visible');
            if (msg) {
                msg.className = 'preview-msg error';
                msg.textContent = message || 'CSV 확인 중 오류가 발생했습니다.';
            }
            if (submit) submit.disabled = true;
            if (hidden) hidden.value = '';
        }

        function escapeHtml(value) {
            return String(value == null ? '' : value)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }

        function bindCsvPreview(prefix, formId, fileId, scope) {
            var form = document.getElementById(formId);
            var fileInput = document.getElementById(fileId);
            var previewBtn = document.getElementById(prefix + 'PreviewBtn');

            if (!form || !fileInput || !previewBtn) return;

            fileInput.addEventListener('change', function () { resetPreview(prefix); });

            previewBtn.addEventListener('click', function () {
                resetPreview(prefix);

                if (!fileInput.files || fileInput.files.length === 0) {
                    showPreviewError(prefix, 'CSV 파일을 먼저 선택해주세요.');
                    return;
                }

                var formData = new FormData();
                formData.append('meterScope', scope);
                formData.append('csvFile', fileInput.files[0]);

                var headers = { 'Accept': 'application/json' };
                var csrfHeader = getCsrfHeader();
                var csrfToken = getCsrfToken();
                if (csrfHeader && csrfToken) headers[csrfHeader] = csrfToken;

                previewBtn.disabled = true;
                previewBtn.textContent = '확인 중...';

                fetch(ctx + '/manager/meter/hstry/preview/' + mgmtOfcNo, {
                    method: 'POST',
                    headers: headers,
                    body: formData
                })
                    .then(function (res) { return res.json(); })
                    .then(function (result) {
                        if (!result.success) throw new Error(result.message || 'CSV 확인 실패');
                        renderPreview(prefix, result);
                    })
                    .catch(function (err) { showPreviewError(prefix, err.message); })
                    .finally(function () {
                        previewBtn.disabled = false;
                        previewBtn.innerHTML = '<span class="material-symbols-rounded">fact_check</span>CSV 확인';
                    });
            });

            form.addEventListener('submit', function (e) {
                var hidden = document.getElementById(prefix + 'MatchedUtilityProviderNo');
                if (!hidden || !hidden.value) {
                    e.preventDefault();
                    showPreviewError(prefix, 'CSV 확인을 먼저 완료해주세요.');
                }
            });
        }

        bindCsvPreview('complex', 'complexMeterCsvUploadForm', 'complexCsvFile', 'COMPLEX');
        bindCsvPreview('facility', 'facilityMeterCsvUploadForm', 'facilityCsvFile', 'FACILITY');

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

        /* 검침유형 표시
           - METER_HSTRY.METER_TY_CD와 공통코드명을 기준으로만 표시한다. */
        function getMeterTypeText(row) {
            if (row.meterTyNm) return row.meterTyNm;
            if (row.meterTyCd) return row.meterTyCd;
            return '-';
        }


        function getMeterUnitByCd(meterTyCd) {
            if (meterTyCd === 'ELEC') return 'kWh';
            if (meterTyCd === 'WATER' || meterTyCd === 'GAS') return '㎥';
            if (meterTyCd === 'HEAT') return 'Gcal';
            return '';
        }

        function getMeterUnit(row) {
            return getMeterUnitByCd(row.meterTyCd);
        }

        function getMeterScope(row) {
            var meterCn = row && row.meterCn ? String(row.meterCn) : '';

            // 신규 기준: METER_HSTRY.METER_SCOPE 컬럼값을 최우선으로 사용함
            if (row && row.meterScope) return row.meterScope;

            // 기존 더미 보정: scope 보정 전 데이터가 상세로 들어오는 경우만 예외적으로 판단함
            if (meterCn.indexOf('[단지검침]') === 0) return 'COMPLEX';
            if (meterCn.indexOf('[시설검침]') === 0) return 'FACILITY';

            // 세대 검침도 계량기 시설번호를 가지므로 facilityNo보다 hoNo를 먼저 확인해야 함
            if (row && row.hoNo) return 'COMPLEX';
            if (row && row.facilityNo) return 'FACILITY';

            return 'FACILITY';
        }

        function cleanMeterCn(value) {
            if (!value) return value;
            return String(value).replace(/^\[단지검침\]\s*/, '').replace(/^\[시설검침\]\s*/, '');
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
            setDisplay('detailMeterCn', cleanMeterCn(row.meterCn));

            /* 시설 검침 / 단지 검침 대상 정보 분리 */
            if (getMeterScope(row) === 'COMPLEX') {
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
            var scope = getMeterScope(row);
            showElement('editComplexTargetRow', scope === 'COMPLEX');
            showElement('editFacilityTargetRow', scope === 'FACILITY');
            setDisplay('editUnitLabel1', unit || '-');
            setDisplay('editUnitLabel2', unit || '-');
            /* 수정 가능 필드 */
            document.getElementById('editMeterHstryNo').value  = row.meterHstryNo || '';
            document.getElementById('editMeterDt').value       = toDateInputValue(row.meterDt);
            document.getElementById('editPreVal').value        = row.preVal == null ? '' : row.preVal;
            document.getElementById('editCurrVal').value       = row.currVal == null ? '' : row.currVal;
            document.getElementById('editMeterRsltCd').value   = row.meterRsltCd || '';
            document.getElementById('editMeterCn').value       = cleanMeterCn(row.meterCn) || '';
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


        /* ============================================================
           탭 직접 전환
           - 협력업체 상세에서 넘어온 partnerNo 조건은 다른 탭 클릭 시 제거
           - 선택한 탭만 유지하고 기본 목록으로 다시 조회
        ============================================================ */
        function moveMeterTab(scope) {
            var url = ctx + '/manager/meter/hstry/' + mgmtOfcNo + '?meterScope=' + encodeURIComponent(scope);
            location.href = url;
        }

        var complexTabLabel = document.querySelector('label[for="meterTabComplex"]');
        var facilityTabLabel = document.querySelector('label[for="meterTabFacility"]');

        if (complexTabLabel) {
            complexTabLabel.addEventListener('click', function (e) {
                if (new URLSearchParams(location.search).get('partnerNo')) {
                    e.preventDefault();
                    moveMeterTab('COMPLEX');
                }
            });
        }

        if (facilityTabLabel) {
            facilityTabLabel.addEventListener('click', function (e) {
                if (new URLSearchParams(location.search).get('partnerNo')) {
                    e.preventDefault();
                    moveMeterTab('FACILITY');
                }
            });
        }

        initMeterPagination('complex');
        initMeterPagination('facility');

    })();
</script>
</body>
</html>
