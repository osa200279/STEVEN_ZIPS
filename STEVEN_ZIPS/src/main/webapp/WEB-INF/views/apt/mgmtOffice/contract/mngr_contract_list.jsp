<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>계약 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        /* ── 토큰 : 검침 이력/시설 목록 계열 색감 기준 ── */
        #contractPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2;
            --th-bg:#f0f2ef;
            --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
            font-family:'Noto Sans KR',sans-serif;
        }

        /* ── 페이지 헤더 ── */
        #contractPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #contractPage .page-title-block p  { color:#6b7a6e; font-size:12px; }

        /* ── 공통 버튼 ── */
        #contractPage .btn {
            display:inline-flex; align-items:center; justify-content:center; gap:4px;
            min-height:32px; height:32px; padding:0 11px;
            border-radius:4px; border:1px solid var(--line);
            background:#fff; color:#39443d;
            font-size:12px; font-weight:700;
            cursor:pointer; text-decoration:none; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif;
        }
        #contractPage .btn:hover { background:#f4f7f4; }
        #contractPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #contractPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #contractPage .btn-xs { min-height:28px; height:28px; padding:0 10px; font-size:11px; }
        #contractPage .btn .material-symbols-rounded { font-size:15px; }

        /* ── 패널 ── */
        #contractPage .panel {
            border-radius:6px; border:1px solid var(--line);
            background:#fff; margin:0 0 12px;
        }
        #contractPage .panel:last-of-type { margin-bottom:0; }
        #contractPage .panel-list { overflow:hidden; }

        #contractPage .panel-header {
            display:flex; align-items:center; justify-content:space-between;
            padding:13px 16px; border-bottom:1px solid var(--line);
            background:#fff;
        }
        #contractPage .panel-title {
            display:flex; align-items:center; gap:6px;
            margin:0; font-size:13px; font-weight:800; color:var(--text-head);
        }
        #contractPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #contractPage .panel-body { padding:14px 16px 16px; }

        /* ── 필터 ── */
        #contractPage .filter-grid {
            display:grid;
            grid-template-columns:1fr 1fr 1.5fr 1.5fr minmax(260px,2fr) auto;
            gap:8px 12px; align-items:end;
        }
        #contractPage .field-label {
            display:block; margin-bottom:5px;
            font-size:11px; font-weight:800; color:var(--text-sec);
        }
        #contractPage .form-select,
        #contractPage .form-input {
            height:32px; font-size:12px;
            border:1px solid var(--line); background:#fff;
            border-radius:4px; padding:0 9px;
            width:100%; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif; color:#1f2d23;
        }
        #contractPage .form-select:focus,
        #contractPage .form-input:focus {
            border-color:var(--accent);
            box-shadow:0 0 0 2px rgba(46,92,56,.08);
            outline:none;
        }
        #contractPage .date-range-inputs {
            display:grid; grid-template-columns:minmax(0,1fr) auto minmax(0,1fr);
            align-items:center; gap:5px;
        }
        #contractPage .date-filter-sep { color:#9ca3af; font-size:12px; text-align:center; }
        #contractPage .search-wrap { position:relative; }
        #contractPage .search-wrap .material-symbols-rounded {
            position:absolute; left:9px; top:50%; transform:translateY(-50%);
            font-size:15px; color:#9caa9e; pointer-events:none;
        }
        #contractPage .search-wrap input { padding-left:30px; }
        #contractPage .filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }

        /* ── 현황 카드 ── */
        #contractPage .contract-summary-row {
            display:grid;
            grid-template-columns:repeat(4,minmax(0,1fr));
            gap:10px;
            margin-bottom:12px;
        }
        #contractPage .contract-summary-card {
            display:flex;
            align-items:center;
            gap:12px;
            min-height:74px;
            padding:14px 16px;
            border:1px solid var(--line);
            border-radius:6px;
            background:var(--surface);
            box-sizing:border-box;
        }
        #contractPage .contract-summary-card .summary-icon {
            display:inline-flex;
            align-items:center;
            justify-content:center;
            width:36px;
            height:36px;
            border-radius:6px;
            background:var(--accent-light);
            color:var(--accent);
            flex-shrink:0;
        }
        #contractPage .contract-summary-card .summary-icon .material-symbols-rounded { font-size:20px; }
        #contractPage .contract-summary-card .summary-label {
            margin-bottom:2px;
            font-size:11px;
            font-weight:700;
            color:#6b7a6e;
        }
        #contractPage .contract-summary-card .summary-value {
            font-size:22px;
            font-weight:800;
            color:var(--text-head);
            line-height:1;
        }
        #contractPage .contract-summary-card.primary {
            background:var(--accent);
            border-color:#1f4027;
        }
        #contractPage .contract-summary-card.primary .summary-icon {
            background:rgba(255,255,255,.14);
            color:#fff;
        }
        #contractPage .contract-summary-card.primary .summary-label { color:rgba(255,255,255,.72); }
        #contractPage .contract-summary-card.primary .summary-value { color:#fff; }

        /* ── 목록 헤더 ── */
        #contractPage .list-count {
            font-size:12px; font-weight:800; color:var(--accent);
            background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap;
        }
        #contractPage .list-head-left { display:flex; align-items:center; gap:8px; min-width:0; }
        #contractPage .list-head-right { display:flex; align-items:center; justify-content:flex-end; gap:7px; flex-shrink:0; }
        #contractPage .result-desc { font-size:11px; color:#7a8a7d; margin-left:8px; font-weight:500; }

        /* ── 목록 테이블 ── */
        #contractPage .table-wrap {
            overflow-x:auto;
            margin:0 -1px;
            padding:0;              /* 공통 manager-common.css의 table-wrap padding 제거 */
            background:#fff;
        }
        #contractPage .tbl {
            width:100%; min-width:100%;
            border-collapse:collapse; table-layout:fixed;
        }
        #contractPage .tbl th {
            height:38px; padding:0 8px;
            background:var(--th-bg); border-bottom:1px solid var(--line);
            color:var(--text-sec); font-size:12px; font-weight:800; text-align:center;
            white-space:nowrap;
        }
        #contractPage .tbl td {
            height:43px; padding:6px 8px;
            border-bottom:1px solid #eef1f3;
            color:#243027; font-size:12px;
            text-align:center; vertical-align:middle;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        #contractPage .tbl tr:last-child td { border-bottom:none; }
        #contractPage .tbl tr:hover td { background:#f8fbf8; }
        #contractPage .tbl .td-left { text-align:left; }
        #contractPage .tbl .td-right { text-align:right; }

        /* 관리 버튼 셀은 버튼 2개가 잘리지 않도록 overflow를 풀어둔다. */
        #contractPage .tbl td.col-action {
            overflow:visible;
            text-overflow:clip;
            padding-left:6px;
            padding-right:6px;
        }

        #contractPage .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #contractPage .contract-name { font-weight:800; color:#1f2d23; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #contractPage .contract-sub { margin-top:2px; font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #contractPage .partner-cell { padding-left:12px !important; }
        #contractPage .partner-name { font-weight:700; color:#243027; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #contractPage .grid-actions {
            display:inline-flex;
            align-items:center;
            justify-content:center;
            gap:5px;
            width:100%;
            white-space:nowrap;
        }

        /* ── 배지 ── */
        #contractPage .badge {
            display:inline-flex; align-items:center; justify-content:center;
            min-height:20px; padding:0 7px; border-radius:4px;
            font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap;
        }
        #contractPage .badge-green { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #contractPage .badge-blue { background:#dbeafe; color:#1e3a5f; border-color:#bfdbfe; }
        #contractPage .badge-yellow { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #contractPage .badge-gray { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #contractPage .badge-purple { background:#ede9fe; color:#4c1d95; border-color:#ddd6fe; }
        #contractPage .badge-orange { background:#ffedd5; color:#7c2d12; border-color:#fed7aa; }

        /* ── 빈 행 ── */
        #contractPage .empty-row { height:90px; color:var(--text-ter); font-size:13px; text-align:center !important; }

        /* ── 상세 모달 : 공통 openModal/closeModal 클래스 기준 ── */
        #contractPage .modal-overlay {
            display:none; position:fixed; inset:0; z-index:1000;
            align-items:center; justify-content:center; padding:24px;
            background:rgba(15,23,42,.35); box-sizing:border-box;
        }
        #contractPage .modal-overlay.open,
        #contractPage .modal-overlay.is-open { display:flex; }
        #contractPage .modal {
            width:min(900px,96vw); max-height:88vh;
            display:flex; flex-direction:column;
            background:#fff; border:1px solid var(--line);
            border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22);
            overflow:hidden;
        }
        #contractPage .modal-header {
            display:flex; align-items:center; justify-content:space-between;
            min-height:48px; padding:0 18px;
            border-bottom:1px solid var(--line); background:var(--text-head);
        }
        #contractPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #contractPage .modal-close {
            border:0; background:rgba(255,255,255,.12); cursor:pointer;
            color:rgba(255,255,255,.75); width:28px; height:28px;
            border-radius:4px; display:flex; align-items:center; justify-content:center;
        }
        #contractPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #contractPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #contractPage .modal-footer {
            display:flex; justify-content:flex-end; gap:8px;
            padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub);
        }

        /* ── 상세 모달 내부 ── */
        #contractPage .form-section { margin-bottom:18px; }
        #contractPage .form-section:last-child { margin-bottom:0; }
        #contractPage .form-section-title {
            display:flex; align-items:center; gap:5px;
            margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid var(--line);
            color:var(--text-head); font-size:12px; font-weight:800;
        }
        #contractPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }

        #contractPage .detail-grid {
            display:grid; grid-template-columns:140px 1fr 140px 1fr;
            border:1px solid var(--line); border-bottom:none;
            border-radius:4px; overflow:hidden;
        }
        #contractPage .detail-grid dt,
        #contractPage .detail-grid dd {
            min-height:36px; margin:0; padding:9px 11px;
            border-bottom:1px solid var(--line);
            font-size:12px; box-sizing:border-box;
        }
        #contractPage .detail-grid dt { background:var(--surface-sub); color:var(--text-sec); font-weight:800; }
        #contractPage .detail-grid dd { color:#1f2d23; }
        #contractPage .detail-grid .wide-label { grid-column:1; }
        #contractPage .detail-grid .wide-value { grid-column:2 / -1; white-space:pre-wrap; line-height:1.6; }

        #contractPage .target-table { width:100%; table-layout:fixed; border-collapse:collapse; font-size:12px; }
        #contractPage .target-table th {
            height:34px; padding:0 10px;
            background:var(--th-bg); border-bottom:1px solid var(--line);
            color:var(--text-sec); font-size:11px; font-weight:800; text-align:center;
        }
        #contractPage .target-table td {
            height:38px; padding:7px 10px; border-bottom:1px solid #eef1f3;
            color:#243027; text-align:center; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        #contractPage .target-table .td-left { text-align:left; }

        @media(max-width:1200px) {
            #contractPage .filter-grid { grid-template-columns:repeat(3,minmax(0,1fr)); }
        }
        @media(max-width:760px) {
            #contractPage .contract-summary-row { grid-template-columns:1fr 1fr; }
            #contractPage .filter-grid { grid-template-columns:1fr; }
            #contractPage .panel-header { flex-direction:column; align-items:flex-start; gap:8px; }
            #contractPage .list-head-right { width:100%; justify-content:flex-start; }
            #contractPage .detail-grid { grid-template-columns:120px 1fr; }
            #contractPage .detail-grid .wide-label { grid-column:1; }
            #contractPage .detail-grid .wide-value { grid-column:2; }
        }
    </style>
</head>

<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="contractPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>계약 관리</h2>
                        <p>협력업체와 연결된 시설 유지보수, 공사, 용역, 검침 계약을 관리합니다.</p>
                    </div>
                </div>

                <%-- 계약 현황 카드
                     - 최종값은 Controller에서 contractSummary로 내려주는 것을 기준으로 사용
                     - DB 연결 전 화면 확인을 위해 contractSummary가 없으면 샘플값을 표시
                --%>
                <div class="contract-summary-row">
                    <div class="contract-summary-card primary">
                        <div class="summary-icon"><span class="material-symbols-rounded">contract</span></div>
                        <div>
                            <div class="summary-label">전체 계약</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.totalCnt}">
                                        <c:out value="${contractSummary.totalCnt}"/>
                                    </c:when>
                                    <c:when test="${empty contractList}">1</c:when>
                                    <c:otherwise>
                                        <c:out value="${fn:length(contractList)}"/>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="contract-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">play_circle</span></div>
                        <div>
                            <div class="summary-label">진행중 계약</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.activeCnt}">
                                        <c:out value="${contractSummary.activeCnt}"/>
                                    </c:when>
                                    <c:when test="${empty contractList}">1</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="contract-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">event_upcoming</span></div>
                        <div>
                            <div class="summary-label">만료 예정</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.expireSoonCnt}">
                                        <c:out value="${contractSummary.expireSoonCnt}"/>
                                    </c:when>
                                    <c:when test="${empty contractList}">0</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="contract-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">event_busy</span></div>
                        <div>
                            <div class="summary-label">만료 계약</div>
                            <div class="summary-value">
                                <c:choose>
                                    <c:when test="${not empty contractSummary.expiredCnt}">
                                        <c:out value="${contractSummary.expiredCnt}"/>
                                    </c:when>
                                    <c:when test="${empty contractList}">0</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 검색 조건 패널 --%>
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>

                    <div class="panel-body">
                        <form method="get" action="${ctx}/manager/facility/contract/list/${mgmtOfcNo}" id="searchForm">
                            <div class="filter-grid">
                                <div class="form-field">
                                    <label class="field-label" for="filterContTyCd">계약유형</label>
                                    <select class="form-select" id="filterContTyCd" name="contTyCd">
                                        <option value="">전체</option>
                                        <option value="MAINT"   <c:if test="${search.contTyCd eq 'MAINT'}">selected</c:if>>유지보수</option>
                                        <option value="REPAIR"  <c:if test="${search.contTyCd eq 'REPAIR'}">selected</c:if>>보수공사</option>
                                        <option value="INSTALL" <c:if test="${search.contTyCd eq 'INSTALL'}">selected</c:if>>설치공사</option>
                                        <option value="SERVICE" <c:if test="${search.contTyCd eq 'SERVICE'}">selected</c:if>>용역</option>
                                        <option value="METER"   <c:if test="${search.contTyCd eq 'METER'}">selected</c:if>>검침</option>
                                        <option value="ETC"     <c:if test="${search.contTyCd eq 'ETC'}">selected</c:if>>기타</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="filterContTargetCd">대상구분</label>
                                    <select class="form-select" id="filterContTargetCd" name="contTargetCd">
                                        <option value="">전체</option>
                                        <option value="FACILITY" <c:if test="${search.contTargetCd eq 'FACILITY'}">selected</c:if>>시설</option>
                                        <option value="COMMON"   <c:if test="${search.contTargetCd eq 'COMMON'}">selected</c:if>>단지공통</option>
                                        <option value="METER"    <c:if test="${search.contTargetCd eq 'METER'}">selected</c:if>>검침</option>
                                        <option value="ETC"      <c:if test="${search.contTargetCd eq 'ETC'}">selected</c:if>>기타</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">계약시작일</label>
                                    <div class="date-range-inputs">
                                        <input type="date" class="form-input" id="filterStartDt" name="startDt" value="${search.startDt}">
                                        <span class="date-filter-sep">~</span>
                                        <input type="date" class="form-input" id="filterEndDt" name="endDt" value="${search.endDt}">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">계약종료일</label>
                                    <div class="date-range-inputs">
                                        <input type="date" class="form-input" id="filterEndStartDt" name="endStartDt" value="${search.endStartDt}">
                                        <span class="date-filter-sep">~</span>
                                        <input type="date" class="form-input" id="filterEndEndDt" name="endEndDt" value="${search.endEndDt}">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="filterKeyword">통합검색</label>
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" id="filterKeyword" name="keyword"
                                               value="${fn:escapeXml(search.keyword)}" placeholder="계약명, 업체명, 시설명 검색">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">&nbsp;</label>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">검색</button>
                                        <a href="${ctx}/manager/facility/contract/list/${mgmtOfcNo}" class="btn">초기화</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- 계약 목록 패널 --%>
                <div class="panel panel-list">
                    <div class="panel-header">
                        <div class="list-head-left">
                            <h3 class="panel-title"><span class="material-symbols-rounded">contract</span>계약 목록</h3>
                            <span class="list-count">총 <c:out value="${fn:length(contractList)}"/>건</span>
                            <span class="result-desc">시설 · 공사 · 용역 · 검침 계약</span>
                        </div>

                        <div class="list-head-right">
                            <a class="btn btn-primary" href="${ctx}/manager/facility/contract/form/${mgmtOfcNo}">
                                <span class="material-symbols-rounded">add</span>계약 등록
                            </a>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl">
                            <colgroup>
                                <col style="width:5%">
                                <col style="width:17%">
                                <col style="width:8%">
                                <col style="width:8%">
                                <col style="width:14%">
                                <col style="width:13%">
                                <col style="width:10%">
                                <col style="width:10%">
                                <col style="width:5%">
                                <col style="width:10%">
                            </colgroup>

                            <thead>
                            <tr>
                                <th>번호</th>
                                <th class="td-left">계약</th>
                                <th>계약유형</th>
                                <th>대상구분</th>
                                <th class="td-left">대상</th>
                                <th class="td-left">협력업체</th>
                                <th>계약금액</th>
                                <th>계약기간</th>
                                <th>파일</th>
                                <th>관리</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:choose>
                                <c:when test="${not empty contractList}">
                                    <c:forEach var="contract" items="${contractList}" varStatus="st">

                                        <%-- 계약유형 표시값 --%>
                                        <c:set var="contTyText" value="${contract.contTyCd}" />
                                        <c:set var="contTyBadge" value="badge-gray" />
                                        <c:choose>
                                            <c:when test="${contract.contTyCd eq 'MAINT'}"><c:set var="contTyText" value="유지보수"/><c:set var="contTyBadge" value="badge-green"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'REPAIR'}"><c:set var="contTyText" value="보수공사"/><c:set var="contTyBadge" value="badge-orange"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'INSTALL'}"><c:set var="contTyText" value="설치공사"/><c:set var="contTyBadge" value="badge-purple"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'SERVICE'}"><c:set var="contTyText" value="용역"/><c:set var="contTyBadge" value="badge-blue"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'METER'}"><c:set var="contTyText" value="검침"/><c:set var="contTyBadge" value="badge-yellow"/></c:when>
                                            <c:when test="${contract.contTyCd eq 'ETC'}"><c:set var="contTyText" value="기타"/><c:set var="contTyBadge" value="badge-gray"/></c:when>
                                        </c:choose>

                                        <%-- 대상구분 표시값 --%>
                                        <c:set var="targetText" value="${contract.contTargetCd}" />
                                        <c:set var="targetBadge" value="badge-gray" />
                                        <c:choose>
                                            <c:when test="${contract.contTargetCd eq 'FACILITY'}"><c:set var="targetText" value="시설"/><c:set var="targetBadge" value="badge-green"/></c:when>
                                            <c:when test="${contract.contTargetCd eq 'COMMON'}"><c:set var="targetText" value="단지공통"/><c:set var="targetBadge" value="badge-blue"/></c:when>
                                            <c:when test="${contract.contTargetCd eq 'METER'}"><c:set var="targetText" value="검침"/><c:set var="targetBadge" value="badge-yellow"/></c:when>
                                            <c:when test="${contract.contTargetCd eq 'ETC'}"><c:set var="targetText" value="기타"/><c:set var="targetBadge" value="badge-gray"/></c:when>
                                        </c:choose>

                                        <tr>
                                            <td class="mono">${fn:length(contractList) - st.index}</td>

                                            <td class="td-left">
                                                <div class="contract-name"><c:out value="${contract.contNm}"/></div>
                                                <div class="contract-sub"><c:out value="${contract.contNo}"/></div>
                                            </td>

                                            <td><span class="badge ${contTyBadge}">${contTyText}</span></td>

                                            <td><span class="badge ${targetBadge}">${targetText}</span></td>

                                            <td class="td-left">
                                                <c:choose>
                                                    <c:when test="${contract.targetCount gt 1}">
                                                        <c:out value="${contract.targetSummary}"/> 외 ${contract.targetCount - 1}건
                                                    </c:when>
                                                    <c:when test="${contract.targetCount eq 1}">
                                                        <c:out value="${contract.targetSummary}"/>
                                                    </c:when>
                                                    <c:when test="${contract.contTargetCd eq 'COMMON'}">
                                                        단지공통
                                                    </c:when>
                                                    <c:when test="${contract.contTargetCd eq 'METER'}">
                                                        검침 설정
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="td-left partner-cell">
                                                <div class="partner-name"><c:out value="${contract.partnerNm}"/></div>
                                                <div class="mono"><c:out value="${contract.partnerNo}"/></div>
                                            </td>

                                            <td class="td-right">
                                                <fmt:formatNumber value="${contract.contAmt}" pattern="#,###"/>원
                                            </td>

                                            <td class="mono">
                                                    <%-- Date 타입을 화면 표시용 날짜 형식으로 변환 --%>
                                                <fmt:formatDate value="${contract.contBgngDt}" pattern="yyyy.MM.dd"/><br>

                                                ~ <c:choose>
                                                <c:when test="${empty contract.contEndDt}">
                                                </c:when>
                                                <c:otherwise>
                                                    <fmt:formatDate value="${contract.contEndDt}" pattern="yyyy.MM.dd"/>
                                                </c:otherwise>
                                            </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${contract.fileCount gt 0}">
                                                        <span class="badge badge-blue">${contract.fileCount}개</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-gray">없음</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td class="col-action">
                                                <div class="grid-actions">
                                                    <button type="button" class="btn btn-xs" data-detail-cont-no="${contract.contNo}">상세</button>
                                                    <a class="btn btn-xs" href="${ctx}/manager/facility/contract/form/${mgmtOfcNo}/${contract.contNo}">수정</a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <%-- 화면 확인용 샘플 데이터 : DB 연결 후 제거 가능 --%>
                                    <tr>
                                        <td class="mono">1</td>
                                        <td class="td-left">
                                            <div class="contract-name">승강기 정기 유지보수 계약</div>
                                            <div class="contract-sub">CONT_TEST_001</div>
                                        </td>
                                        <td><span class="badge badge-green">유지보수</span></td>
                                        <td><span class="badge badge-green">시설</span></td>
                                        <td class="td-left">1호기 승강기 외 1건</td>
                                        <td class="td-left partner-cell">
                                            <div class="partner-name">SH승강기관리</div>
                                            <div class="mono">PTR3002</div>
                                        </td>
                                        <td class="td-right">3,000,000원</td>
                                        <td class="mono">2026.05.20<br>~ 미정</td>
                                        <td><span class="badge badge-blue">1개</span></td>
                                        <td class="col-action">
                                            <div class="grid-actions">
                                                <button type="button" class="btn btn-xs" data-detail-cont-no="CONT_TEST_001">상세</button>
                                                <a class="btn btn-xs" href="${ctx}/manager/facility/contract/form/${mgmtOfcNo}/CONT_TEST_001">수정</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <%-- 상세 모달 --%>
                <div class="modal-overlay" id="contractDetailModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">계약 상세</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <div class="modal-body">
                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">description</span>계약 기본정보
                                </div>

                                <dl class="detail-grid">
                                    <dt>계약번호</dt><dd id="detailContNo"></dd>
                                    <dt>계약명</dt><dd id="detailContNm"></dd>
                                    <dt>계약유형</dt><dd id="detailContTyCd"></dd>
                                    <dt>대상구분</dt><dd id="detailContTargetCd"></dd>
                                    <dt>입찰유형</dt><dd id="detailBidTyCd"></dd>
                                    <dt>계약금액</dt><dd id="detailContAmt"></dd>
                                    <dt>계약일자</dt><dd id="detailContDt"></dd>
                                    <dt>지급예정일</dt><dd id="detailPymtDt"></dd>
                                    <dt>계약기간</dt><dd id="detailContPeriod"></dd>
                                    <dt>협력업체</dt><dd id="detailPartner"></dd>
                                    <dt class="wide-label">계약내용</dt><dd class="wide-value" id="detailContCn"></dd>
                                    <dt class="wide-label">비고</dt><dd class="wide-value" id="detailRmrkCn"></dd>
                                </dl>
                            </div>

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">apartment</span>대상 정보
                                </div>
                                <div id="detailTargetList"></div>
                            </div>

                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">attach_file</span>첨부파일
                                </div>
                                <div id="detailFileList"></div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn" data-modal-close>닫기</button>
                        </div>
                    </div>
                </div>

            </div><!-- /contractPage -->
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        /* ============================================================
           계약 목록 화면 설정
           - 목록 JSP에서는 상세 조회만 처리
           - 등록/수정은 form.jsp로 이동
        ============================================================ */
        var contractConfig = {
            contextPath: '${ctx}',
            mgmtOfcNo: '${mgmtOfcNo}',
            detailUrl: '${ctx}/manager/facility/contract/detail/${mgmtOfcNo}/'
        };

        /* 계약유형 표시명 */
        var contTyMap = {
            MAINT: '유지보수',
            REPAIR: '보수공사',
            INSTALL: '설치공사',
            SERVICE: '용역',
            METER: '검침',
            ETC: '기타'
        };

        /* 대상구분 표시명 */
        var targetMap = {
            FACILITY: '시설',
            COMMON: '단지공통',
            METER: '검침',
            ETC: '기타'
        };

        /* 화면 확인용 샘플 상세 데이터 : DB 상세 API 연결 후 제거 가능 */
        var sampleContractMap = {
            CONT_TEST_001: {
                contNo: 'CONT_TEST_001',
                contNm: '승강기 정기 유지보수 계약',
                contTyCd: 'MAINT',
                contTargetCd: 'FACILITY',
                partnerNo: 'PTR3002',
                partnerNm: 'SH승강기관리',
                bidTyCd: 'PRIVATE',
                contAmt: 3000000,
                contDt: '2026.05.20',
                contBgngDt: '2026.05.20',
                contEndDt: '',
                pymtDt: '2026.06.10',
                contCn: '승강기 1호기, 2호기 정기 유지보수 계약입니다. 월 1회 정기점검과 긴급 출동 대응을 포함합니다.',
                rmrkCn: '화면 확인용 샘플 데이터입니다. DB 연결 후 삭제하세요.',
                targetFacilityList: [
                    { facilityNo: 'FAC1001', facilityNm: '1호기 승강기', facilityTyCd: 'ELV', locCn: '101동 승강기홀' },
                    { facilityNo: 'FAC3001', facilityNm: '2호기 승강기', facilityTyCd: 'ELV', locCn: '102동 승강기홀' }
                ],
                fileList: [
                    { fileNo: 'FILE_TEST_001', fileOgName: '승강기_유지보수_계약서.pdf', fileSize: 245760 }
                ]
            }
        };

        /* ============================================================
           초기 이벤트 연결
        ============================================================ */
        document.addEventListener('DOMContentLoaded', function () {
            var page = document.getElementById('contractPage');

            if (!page) return;

            page.addEventListener('click', function (event) {
                var detailBtn = event.target.closest('[data-detail-cont-no]');
                var fileBtn = event.target.closest('[data-file-no]');

                /* 상세 버튼 */
                if (detailBtn) {
                    openDetailModal(detailBtn.dataset.detailContNo);
                    return;
                }

                /* 파일 보기 버튼 */
                if (fileBtn) {
                    openContractFile(fileBtn.dataset.fileNo);
                    return;
                }
            });
        });

        /* ============================================================
           상세 모달 열기
        ============================================================ */
        async function openDetailModal(contNo) {
            try {
                /* 화면 확인용 샘플은 서버 요청 없이 상세 표시 */
                var contract = sampleContractMap[contNo];

                /* 실제 데이터는 상세 API 조회 */
                if (!contract) {
                    var res = await requestJson(contractConfig.detailUrl + encodeURIComponent(contNo));

                    if (!res.success) {
                        alertMessage(res.message || '계약 정보를 조회하지 못했습니다.');
                        return;
                    }

                    contract = res.contract || {};
                }

                /* 상세 기본정보 표시 */
                setText('detailContNo', contract.contNo);
                setText('detailContNm', contract.contNm);
                setText('detailContTyCd', contTyMap[contract.contTyCd] || contract.contTyCd);
                setText('detailContTargetCd', targetMap[contract.contTargetCd] || contract.contTargetCd);
                setText('detailBidTyCd', contract.bidTyCd);
                setText('detailContAmt', formatMoney(contract.contAmt));
                setText('detailContDt', contract.contDt);
                setText('detailPymtDt', contract.pymtDt);
                setText('detailContPeriod', empty(contract.contBgngDt) + ' ~ ' + (contract.contEndDt || '미정'));
                setText('detailPartner', empty(contract.partnerNm) + ' (' + empty(contract.partnerNo) + ')');
                setText('detailContCn', contract.contCn);
                setText('detailRmrkCn', contract.rmrkCn);

                /* 상세 하위 정보 표시 */
                renderDetailTargets(contract.targetFacilityList || [], contract.contTargetCd);
                renderDetailFiles(contract.fileList || []);

                /* 공통 모달 열기 */
                if (typeof window.openModal === 'function') {
                    window.openModal('contractDetailModal');
                } else {
                    document.getElementById('contractDetailModal').classList.add('open');
                }
            } catch (e) {
                alertMessage(e.message || '계약 정보를 조회하지 못했습니다.');
            }
        }

        /* ============================================================
           상세 대상 정보 렌더링
        ============================================================ */
        function renderDetailTargets(targetList, contTargetCd) {
            var box = document.getElementById('detailTargetList');

            if (!box) return;

            /* 단지공통/기타/검침처럼 시설 목록이 없는 계약 표시 */
            if (!targetList || targetList.length === 0) {
                if (contTargetCd === 'COMMON') {
                    box.innerHTML = '<div class="empty-row">단지공통 계약입니다.</div>';
                    return;
                }

                if (contTargetCd === 'METER') {
                    box.innerHTML = '<div class="empty-row">검침 계약입니다. 검침 설정 정보는 검침 관리 화면에서 확인합니다.</div>';
                    return;
                }

                box.innerHTML = '<div class="empty-row">등록된 대상 시설이 없습니다.</div>';
                return;
            }

            var html = '';
            html += '<table class="target-table">';
            html += '  <colgroup>';
            html += '      <col style="width:130px;">';
            html += '      <col style="width:180px;">';
            html += '      <col style="width:100px;">';
            html += '      <col>';
            html += '  </colgroup>';
            html += '  <thead>';
            html += '      <tr>';
            html += '          <th>시설번호</th>';
            html += '          <th>시설명</th>';
            html += '          <th>유형</th>';
            html += '          <th>위치</th>';
            html += '      </tr>';
            html += '  </thead>';
            html += '  <tbody>';

            targetList.forEach(function (facility) {
                html += '      <tr>';
                html += '          <td class="mono">' + escapeHtml(facility.facilityNo) + '</td>';
                html += '          <td class="td-left">' + escapeHtml(facility.facilityNm) + '</td>';
                html += '          <td>' + escapeHtml(facility.facilityTyCd) + '</td>';
                html += '          <td class="td-left">' + escapeHtml(facility.locCn || '위치 미등록') + '</td>';
                html += '      </tr>';
            });

            html += '  </tbody>';
            html += '</table>';

            box.innerHTML = html;
        }

        /* ============================================================
           상세 첨부파일 렌더링
        ============================================================ */
        function renderDetailFiles(fileList) {
            var box = document.getElementById('detailFileList');

            if (!box) return;

            if (!fileList || fileList.length === 0) {
                box.innerHTML = '<div class="empty-row">첨부된 계약서 파일이 없습니다.</div>';
                return;
            }

            var html = '';
            html += '<table class="target-table">';
            html += '  <colgroup>';
            html += '      <col>';
            html += '      <col style="width:120px;">';
            html += '      <col style="width:90px;">';
            html += '  </colgroup>';
            html += '  <thead>';
            html += '      <tr>';
            html += '          <th>파일명</th>';
            html += '          <th>크기</th>';
            html += '          <th>보기</th>';
            html += '      </tr>';
            html += '  </thead>';
            html += '  <tbody>';

            fileList.forEach(function (file) {
                var fileNo = file.fileNo || file.fileId || '';

                html += '      <tr>';
                html += '          <td class="td-left">' + escapeHtml(file.fileOgName || file.fileName || '') + '</td>';
                html += '          <td>' + formatFileSize(file.fileSize) + '</td>';
                html += '          <td><button type="button" class="btn btn-xs" data-file-no="' + escapeHtml(fileNo) + '">보기</button></td>';
                html += '      </tr>';
            });

            html += '  </tbody>';
            html += '</table>';

            box.innerHTML = html;
        }

        /* ============================================================
           첨부파일 보기
        ============================================================ */
        function openContractFile(fileNo) {
            if (!fileNo) {
                alertMessage('파일 번호가 없습니다.');
                return;
            }

            window.open(contractConfig.contextPath + '/file/view/' + encodeURIComponent(fileNo), '_blank');
        }

        /* ============================================================
           JSON 요청
        ============================================================ */
        async function requestJson(url) {
            if (typeof window.getJson === 'function') {
                return window.getJson(url);
            }

            var response = await fetch(url, { method:'GET' });
            var text = await response.text();
            var data = text ? JSON.parse(text) : {};

            if (!response.ok) {
                throw new Error(data.message || '요청 처리 중 오류가 발생했습니다.');
            }

            return data;
        }

        /* ============================================================
           공통 보조 함수
        ============================================================ */
        function setText(id, value) {
            var element = document.getElementById(id);
            if (element) {
                element.textContent = empty(value);
            }
        }

        function empty(value) {
            return value == null ? '' : value;
        }

        function alertMessage(message) {
            if (typeof window.showAlert === 'function') {
                window.showAlert(message);
                return;
            }
            alert(message);
        }

        function formatMoney(value) {
            if (value == null || value === '') return '';
            return Number(value).toLocaleString('ko-KR') + '원';
        }

        function formatFileSize(value) {
            if (value == null || value === '') return '-';

            var size = Number(value);

            if (size >= 1024 * 1024) {
                return (size / 1024 / 1024).toFixed(1) + 'MB';
            }

            if (size >= 1024) {
                return (size / 1024).toFixed(1) + 'KB';
            }

            return size + 'B';
        }

        function escapeHtml(value) {
            return String(value == null ? '' : value)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#039;');
        }
    })();
</script>
</body>
</html>
