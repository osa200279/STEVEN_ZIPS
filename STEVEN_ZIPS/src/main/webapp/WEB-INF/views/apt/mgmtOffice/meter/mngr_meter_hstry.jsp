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
        /* ── 토큰 ── */
        #meterPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2;
            --th-bg:#f0f2ef;
            --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
            font-family:'Noto Sans KR',sans-serif;
        }

        /* ── 페이지 헤더 ── */
        #meterPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #meterPage .page-title-block p  { color:#6b7a6e; font-size:12px; }

        /* ── 공통 버튼 ── */
        #meterPage .btn {
            display:inline-flex; align-items:center; justify-content:center; gap:4px;
            min-height:32px; height:32px; padding:0 11px;
            border-radius:4px; border:1px solid var(--line);
            background:#fff; color:#39443d;
            font-size:12px; font-weight:700;
            cursor:pointer; text-decoration:none; box-sizing:border-box;
        }
        #meterPage .btn:hover { background:#f4f7f4; }
        #meterPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #meterPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #meterPage .btn .material-symbols-rounded { font-size:15px; }

        /* ── 알림 ── */
        #meterPage .alert {
            display:flex; align-items:center; gap:8px;
            padding:10px 14px; margin-bottom:12px;
            border-radius:4px; font-size:12px; font-weight:700;
        }
        #meterPage .alert-success { background:#ecfdf3; border:1px solid #bbf7d0; color:#166534; }
        #meterPage .alert-error { background:#fef2f2; border:1px solid #fecaca; color:#991b1b; }

        /* ── 패널 ── */
        #meterPage .panel {
            border-radius:6px; border:1px solid var(--line);
            background:#fff; margin:0 0 12px;
        }
        #meterPage .panel:last-of-type { margin-bottom:0; }
        #meterPage .panel-list { overflow:hidden; }

        #meterPage .panel-header {
            display:flex; align-items:center; justify-content:space-between;
            padding:13px 16px; border-bottom:1px solid var(--line);
            background:#fff
        }
        #meterPage .panel-list .panel-header { padding:13px 16px; }
        #meterPage .panel-list .panel-header > div { padding-left:0 !important; }
        #meterPage .panel-title {
            display:flex; align-items:center; gap:6px;
            margin:0; font-size:13px; font-weight:800; color:var(--text-head);
        }
        #meterPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #meterPage .panel-body { padding:14px 16px 16px; }

        /* ── 필터 ── */
        #meterPage .filter-grid {
            display:grid;
            grid-template-columns:1.3fr .8fr 1.5fr minmax(230px,2fr) auto;
            gap:8px 12px; align-items:end;
        }
        #meterPage .field-label {
            display:block; margin-bottom:5px;
            font-size:11px; font-weight:800; color:var(--text-sec);
        }
        #meterPage .form-select,
        #meterPage .form-input {
            height:32px; font-size:12px;
            border:1px solid var(--line); background:#fff;
            border-radius:4px; padding:0 9px;
            width:100%; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif; color:#1f2d23;
        }
        #meterPage .form-select:focus,
        #meterPage .form-input:focus {
            border-color:var(--accent);
            box-shadow:0 0 0 2px rgba(46,92,56,.08);
            outline:none;
        }

        #meterPage .date-range-inputs {
            display:grid; grid-template-columns:minmax(0,1fr) auto minmax(0,1fr);
            align-items:center; gap:5px;
        }
        #meterPage .date-filter-sep { color:#9ca3af; font-size:12px; text-align:center; }

        #meterPage .search-wrap { position:relative; }
        #meterPage .search-wrap .material-symbols-rounded {
            position:absolute; left:9px; top:50%; transform:translateY(-50%);
            font-size:15px; color:#9caa9e; pointer-events:none;
        }
        #meterPage .search-wrap input { padding-left:30px; }

        #meterPage .filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }

        /* ── 목록 ── */
        #meterPage .list-count {
            font-size:12px; font-weight:800; color:var(--accent);
            background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap;
        }
        #meterPage .list-head-left {
            display:flex; align-items:center; gap:8px;
        }
        #meterPage .list-head-right {
            display:flex; align-items:center; justify-content:flex-end;
        }
        #meterPage .table-wrap { overflow-x:auto; margin:0 -1px; }
        #meterPage .tbl { width:100%; border-collapse:collapse; table-layout:fixed; }
        #meterPage .tbl th {
            height:38px; padding:0 8px;
            background:var(--th-bg); border-bottom:1px solid var(--line);
            color:var(--text-sec); font-size:12px; font-weight:800; text-align:center;
        }
        #meterPage .tbl td {
            height:43px; padding:6px 8px;
            border-bottom:1px solid #eef1f3;
            color:#243027; font-size:12px;
            text-align:center; vertical-align:middle;
            white-space:nowrap; overflow:hidden; text-overflow:ellipsis;
        }
        #meterPage .tbl tr:last-child td { border-bottom:none; }
        #meterPage .tbl tr:hover td { background:#f8fbf8; }
        #meterPage .tbl .td-left { text-align:left; }
        #meterPage .tbl .td-right { text-align:right; }
        #meterPage .tbl .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .facility-name { font-weight:800; color:#1f2d23; }
        #meterPage .facility-sub { margin-top:2px; font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #meterPage .meter-cn { text-align:left !important; }
        #meterPage .partner-cell { padding-left:12px !important; }

        /* 상태 배지 */
        #meterPage .badge {
            display:inline-flex; align-items:center; justify-content:center;
            min-height:20px; padding:0 7px; border-radius:4px;
            font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap;
        }
        #meterPage .badge-normal { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #meterPage .badge-error  { background:#fee2e2; color:#7f1d1d; border-color:#fecaca; }
        #meterPage .badge-miss   { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #meterPage .badge-gray   { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #meterPage .need-check { display:block; margin-top:3px; font-size:10px; color:#b45309; font-weight:800; }

        /* 빈 행 */
        #meterPage .empty-row { height:90px; color:var(--text-ter); font-size:13px; text-align:center !important; }

        /* ── 모달 ── */
        #meterPage .modal-overlay {
            display:none; position:fixed; inset:0; z-index:1000;
            align-items:center; justify-content:center; padding:24px;
            background:rgba(15,23,42,.35); box-sizing:border-box;
        }
        #meterPage .modal-overlay.open,
        #meterPage .modal-overlay.is-open { display:flex; }
        #meterPage .modal {
            width:min(720px,96vw); max-height:88vh;
            display:flex; flex-direction:column;
            background:#fff; border:1px solid var(--line);
            border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22);
            overflow:hidden;
        }
        #meterPage .modal-header {
            display:flex; align-items:center; justify-content:space-between;
            min-height:48px; padding:0 18px;
            border-bottom:1px solid var(--line); background:var(--text-head);
        }
        #meterPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #meterPage .modal-close {
            border:0; background:rgba(255,255,255,.12); cursor:pointer;
            color:rgba(255,255,255,.75); width:28px; height:28px;
            border-radius:4px; display:flex; align-items:center; justify-content:center;
        }
        #meterPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #meterPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #meterPage .modal-footer {
            display:flex; justify-content:flex-end; gap:8px;
            padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub);
        }

        /* 모달 폼 */
        #meterPage .form-section { margin-bottom:18px; }
        #meterPage .form-section:last-child { margin-bottom:0; }
        #meterPage .form-section-title {
            display:flex; align-items:center; gap:5px;
            margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid var(--line);
            color:var(--text-head); font-size:12px; font-weight:800;
        }
        #meterPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #meterPage .form-row { display:grid; gap:10px 12px; margin-bottom:10px; }
        #meterPage .form-row.cols-2 { grid-template-columns:1fr 1fr; }
        #meterPage .form-field { display:flex; flex-direction:column; gap:4px; }
        #meterPage .field-help { font-size:11px; color:var(--text-ter); line-height:1.45; margin-top:2px; }

        /* CSV 예시 */
        #meterPage .sample-box {
            background:#f8fafc; border:1px solid #e5e7eb;
            border-radius:4px; padding:10px;
            font-family:'Consolas','SF Mono',monospace;
            font-size:11px; line-height:1.6;
            overflow-x:auto; white-space:pre;
        }


        /* ── 반응형 ── */
        @media(max-width:1200px) {
            #meterPage .filter-grid { grid-template-columns:repeat(3,minmax(0,1fr)); }
        }
        @media(max-width:760px) {
            #meterPage .filter-grid { grid-template-columns:1fr; }
            #meterPage .form-row.cols-2 { grid-template-columns:1fr; }
            #meterPage .panel-header { flex-direction:column; align-items:flex-start; gap:8px; }
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
                        <p>CSV로 업로드된 전기·수도·가스 검침 이력을 조회합니다.</p>
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

                <%-- 검색 조건 패널 --%>
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${ctx}/manager/meter/hstry/${mgmtOfcNo}" id="searchForm">
                            <div class="filter-grid">
                                <div class="form-field">
                                    <label class="field-label" for="filterUtilityProviderNo">공급/검침 업체</label>
                                    <select class="form-select" id="filterUtilityProviderNo" name="utilityProviderNo">
                                        <option value="">전체</option>
                                        <c:forEach var="provider" items="${providerList}">
                                            <option value="${provider.utilityProviderNo}" <c:if test="${search.utilityProviderNo eq provider.utilityProviderNo}">selected</c:if>>
                                                    ${provider.partnerNm} (${provider.utilityProviderNo})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="filterMeterRsltCd">결과</label>
                                    <select class="form-select" id="filterMeterRsltCd" name="meterRsltCd">
                                        <option value="">전체</option>
                                        <c:forEach var="code" items="${rsltCodeList}">
                                            <option value="${code.codeNoCd}" <c:if test="${search.meterRsltCd eq code.codeNoCd}">selected</c:if>>
                                                    ${code.codeName}
                                            </option>
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
                                    <label class="field-label" for="filterKeyword">통합검색</label>
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" id="filterKeyword" name="keyword"
                                               value="${search.keyword}" placeholder="시설명, 시설번호, 호번호, 검침내용">
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

                <%-- 목록 패널 --%>
                <div class="panel panel-list">
                    <div class="panel-header">
                        <div class="list-head-left">
                            <h3 class="panel-title"><span class="material-symbols-rounded">electric_meter</span>검침 이력 목록</h3>
                            <span class="list-count">총 ${fn:length(meterList)}건</span>
                        </div>
                        <div class="list-head-right">
                            <button type="button" class="btn btn-primary" id="openUploadModalBtn">
                                <span class="material-symbols-rounded">upload_file</span>CSV 업로드
                            </button>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl">
                            <colgroup>
                                <col style="width:9%">
                                <col style="width:18%">
                                <col style="width:10%">
                                <col style="width:8%">
                                <col style="width:8%">
                                <col style="width:8%">
                                <col style="width:20%">
                                <col style="width:9%">
                                <col style="width:10%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>검침일자</th>
                                <th class="td-left">시설</th>
                                <th>호번호</th>
                                <th>이전값</th>
                                <th>현재값</th>
                                <th>사용량</th>
                                <th class="td-left">검침내용</th>
                                <th>결과</th>
                                <th class="td-left">업체</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty meterList}">
                                    <tr>
                                        <td colspan="9" class="empty-row">조회된 검침 이력이 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="row" items="${meterList}">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${row.meterDt}" pattern="yyyy.MM.dd"/>
                                            </td>
                                            <td class="td-left">
                                                <div class="facility-name">${row.facilityNm}</div>
                                                <div class="facility-sub">${row.facilityNo} · ${row.facilityTyNm}</div>
                                            </td>
                                            <td class="mono">${empty row.hoNo ? '-' : row.hoNo}</td>
                                            <td class="td-right">
                                                <fmt:formatNumber value="${row.preVal}" pattern="#,#0.##"/>
                                            </td>
                                            <td class="td-right">
                                                <fmt:formatNumber value="${row.currVal}" pattern="#,#0.##"/>
                                            </td>
                                            <td class="td-right">
                                                <fmt:formatNumber value="${row.currVal - row.preVal}" pattern="#,#0.##"/>
                                            </td>
                                            <td class="meter-cn">${row.meterCn}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${row.meterRsltCd eq 'NORMAL'}">
                                                        <span class="badge badge-normal">${row.meterRsltNm}</span>
                                                    </c:when>
                                                    <c:when test="${row.meterRsltCd eq 'ERROR'}">
                                                        <span class="badge badge-error">${row.meterRsltNm}</span>
                                                        <span class="need-check">확인 필요</span>
                                                    </c:when>
                                                    <c:when test="${row.meterRsltCd eq 'MISS'}">
                                                        <span class="badge badge-miss">${row.meterRsltNm}</span>
                                                        <span class="need-check">확인 필요</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-gray">${empty row.meterRsltCd ? '-' : row.meterRsltCd}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="td-left partner-cell">
                                                <div>${row.partnerNm}</div>
                                                <div class="mono">${row.utilityProviderNo}</div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <%-- CSV 업로드 모달 --%>
                <div class="modal-overlay" id="uploadModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">검침 CSV 업로드</h3>
                            <button type="button" class="modal-close" id="closeUploadModalBtn">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <form method="post" action="${ctx}/manager/meter/hstry/upload/${mgmtOfcNo}" enctype="multipart/form-data" id="meterCsvUploadForm">
                            <sec:csrfInput/>

                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>업로드 파일 선택</div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="utilityProviderNo">공급/검침 업체</label>
                                            <select class="form-select" id="utilityProviderNo" name="utilityProviderNo" required>
                                                <option value="">선택</option>
                                                <c:forEach var="provider" items="${providerList}">
                                                    <option value="${provider.utilityProviderNo}">
                                                            ${provider.partnerNm} / ${provider.csvIdntfKey} / ${provider.extCustNo}
                                                    </option>
                                                </c:forEach>
                                            </select>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label" for="csvFile">CSV 파일</label>
                                            <input type="file" class="form-input" id="csvFile" name="csvFile" accept=".csv,text/csv" required>
                                        </div>
                                    </div>

                                    <div class="field-help">
                                        CSV의 csv_idntf_key, ext_cust_no는 선택한 공급/검침 업체 설정값과 일치해야 합니다.
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>CSV 컬럼 예시</div>
                                    <div class="sample-box">csv_idntf_key,ext_cust_no,facility_no,ho_no,meter_dt,pre_val,curr_val,meter_cn,meter_rslt_cd
                                        CSV_A12185003_003,CUST-A12185003-003,FAC3203,A12185003_101_101,2026-05-19,1200,1285,101동 101호 전기 사용량 검침,NORMAL
                                        CSV_A12185003_003,CUST-A12185003-003,FAC3202,A12185003_101_103,2026-05-19,900,900,101동 103호 수도 검침 누락,MISS
                                        CSV_A12185003_003,CUST-A12185003-003,FAC3203,A12185003_101_102,2026-05-19,1300,1600,101동 102호 전기 사용량 오류 검침,ERROR</div>
                                    <div class="field-help">
                                        결과코드는 1차 구현에서 NORMAL, ERROR, MISS를 사용합니다. ERROR와 MISS는 목록에서 확인 필요로 표시합니다.
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn" id="cancelUploadModalBtn">취소</button>
                                <button type="submit" class="btn btn-primary">업로드</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div><!-- /meterPage -->
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        var modal = document.getElementById('uploadModal');
        var openBtn = document.getElementById('openUploadModalBtn');
        var closeBtn = document.getElementById('closeUploadModalBtn');
        var cancelBtn = document.getElementById('cancelUploadModalBtn');
        var form = document.getElementById('meterCsvUploadForm');

        /* CSV 업로드 모달 열기 */
        function openUploadModal() {
            if (window.openModal) {
                window.openModal('uploadModal');
                return;
            }

            modal.classList.add('open');
        }

        /* CSV 업로드 모달 닫기 */
        function closeUploadModal() {
            if (window.closeModal) {
                window.closeModal('uploadModal');
            } else {
                modal.classList.remove('open');
            }

            if (form) {
                form.reset();
            }
        }

        /* 업로드 버튼 이벤트 */
        if (openBtn) {
            openBtn.addEventListener('click', openUploadModal);
        }

        /* 닫기 버튼 이벤트 */
        if (closeBtn) {
            closeBtn.addEventListener('click', closeUploadModal);
        }

        /* 취소 버튼 이벤트 */
        if (cancelBtn) {
            cancelBtn.addEventListener('click', closeUploadModal);
        }

        /* 배경 클릭 닫기 이벤트 */
        if (modal) {
            modal.addEventListener('click', function (event) {
                if (event.target === modal) {
                    closeUploadModal();
                }
            });
        }
    })();
</script>
</body>
</html>
