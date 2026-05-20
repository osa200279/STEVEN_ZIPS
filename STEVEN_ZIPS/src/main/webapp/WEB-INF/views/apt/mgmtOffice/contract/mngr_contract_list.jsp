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
    <title>계약 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        /* ── 토큰 ── */
        #contractPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e; font-family:'Noto Sans KR',sans-serif; }

        /* ── 페이지 헤더 ── */
        #contractPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #contractPage .page-title-block p { color:#6b7a6e; font-size:12px; }

        /* ── 공통 버튼 ── */
        #contractPage .btn { display:inline-flex; align-items:center; justify-content:center; gap:4px; min-height:32px; height:32px; padding:0 11px; border-radius:4px; border:1px solid var(--line); background:#fff; color:#39443d; font-size:12px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box; }
        #contractPage .btn:hover { background:#f4f7f4; }
        #contractPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #contractPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #contractPage .btn .material-symbols-rounded { font-size:15px; }

        /* ── 알림 ── */
        #contractPage .alert { display:flex; align-items:center; gap:8px; padding:10px 14px; margin-bottom:12px; border-radius:4px; font-size:12px; font-weight:700; }
        #contractPage .alert-success { background:#ecfdf3; border:1px solid #bbf7d0; color:#166534; }
        #contractPage .alert-error { background:#fef2f2; border:1px solid #fecaca; color:#991b1b; }

        /* ── 현황 카드 ── */
        #contractPage .summary-grid { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:10px; margin-bottom:12px; }
        #contractPage .summary-card { display:flex; align-items:center; gap:12px; padding:14px 16px; border:1px solid var(--line); border-radius:6px; background:#fff; text-decoration:none; color:inherit; box-sizing:border-box; }
        #contractPage .summary-card:hover { background:#f4f7f4; }
        #contractPage .summary-card.is-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #contractPage .summary-icon { width:36px; height:36px; border-radius:6px; display:flex; align-items:center; justify-content:center; background:var(--accent-light); color:var(--accent); flex:0 0 auto; }
        #contractPage .summary-card.is-primary .summary-icon { background:rgba(255,255,255,.15); color:#fff; }
        #contractPage .summary-val { display:block; font-size:22px; font-weight:800; line-height:1; }
        #contractPage .summary-label { display:block; margin-top:3px; font-size:11px; color:#7a8a7d; }
        #contractPage .summary-card.is-primary .summary-label { color:rgba(255,255,255,.72); }

        /* ── 패널 ── */
        #contractPage .panel { border-radius:6px; border:1px solid var(--line); background:#fff; margin:0 0 12px; }
        #contractPage .panel:last-of-type { margin-bottom:0; }
        #contractPage .panel-list { overflow:hidden; }
        #contractPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:#fff; }
        #contractPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #contractPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #contractPage .panel-body { padding:14px 16px 16px; }

        /* ── 필터 ── */
        #contractPage .filter-grid { display:grid; grid-template-columns:.9fr .9fr .9fr .9fr minmax(240px,2fr) auto; gap:8px 12px; align-items:end; }
        #contractPage .field-label { display:block; margin-bottom:5px; font-size:11px; font-weight:800; color:var(--text-sec); }
        #contractPage .form-select, #contractPage .form-input { height:32px; font-size:12px; border:1px solid var(--line); background:#fff; border-radius:4px; padding:0 9px; width:100%; box-sizing:border-box; font-family:'Noto Sans KR',sans-serif; color:#1f2d23; }
        #contractPage .form-select:focus, #contractPage .form-input:focus { border-color:var(--accent); box-shadow:0 0 0 2px rgba(46,92,56,.08); outline:none; }
        #contractPage .search-wrap { position:relative; }
        #contractPage .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #contractPage .search-wrap input { padding-left:30px; }
        #contractPage .filter-actions { display:flex; justify-content:flex-end; gap:7px; white-space:nowrap; }

        /* ── 만료임박 ── */
        #contractPage .expire-list { display:grid; grid-template-columns:repeat(2,minmax(0,1fr)); gap:8px; }
        #contractPage .expire-item { display:flex; align-items:center; justify-content:space-between; gap:10px; padding:9px 10px; border:1px solid #fde68a; border-radius:4px; background:#fffbeb; font-size:12px; }
        #contractPage .expire-name { font-weight:800; color:#1f2d23; }
        #contractPage .expire-sub { margin-top:2px; color:#66736a; }

        /* ── 목록 ── */
        #contractPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #contractPage .list-head-left { display:flex; align-items:center; gap:8px; }
        #contractPage .list-head-right { display:flex; align-items:center; justify-content:flex-end; }
        #contractPage .table-wrap { overflow-x:auto; margin:0 -1px; }
        #contractPage .tbl { width:100%; border-collapse:collapse; table-layout:fixed; }
        #contractPage .tbl th { height:38px; padding:0 8px; background:var(--th-bg); border-bottom:1px solid var(--line); color:var(--text-sec); font-size:12px; font-weight:800; text-align:center; }
        #contractPage .tbl td { height:43px; padding:6px 8px; border-bottom:1px solid #eef1f3; color:#243027; font-size:12px; text-align:center; vertical-align:middle; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #contractPage .tbl tr:last-child td { border-bottom:none; }
        #contractPage .tbl tr:hover td { background:#f8fbf8; }
        #contractPage .tbl .td-left { text-align:left; }
        #contractPage .tbl .td-right { text-align:right; }
        #contractPage .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #contractPage .contract-name { font-weight:800; color:#1f2d23; }
        #contractPage .contract-sub { margin-top:2px; font-family:'Consolas','SF Mono',monospace; font-size:11px; color:#66736a; }
        #contractPage .empty-row { height:90px; color:var(--text-ter); font-size:13px; text-align:center !important; }

        /* ── 상태 배지 ── */
        #contractPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:20px; padding:0 7px; border-radius:4px; font-size:11px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #contractPage .badge-normal { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #contractPage .badge-warn { background:#fef3c7; color:#713f12; border-color:#fde68a; }
        #contractPage .badge-error { background:#fee2e2; color:#7f1d1d; border-color:#fecaca; }
        #contractPage .badge-blue { background:#dbeafe; color:#1e3a5f; border-color:#bfdbfe; }
        #contractPage .badge-gray { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }

        /* ── 모달 ── */
        #contractPage .modal-overlay { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.35); box-sizing:border-box; }
        #contractPage .modal-overlay.open, #contractPage .modal-overlay.is-open { display:flex; }
        #contractPage .modal { width:min(760px,96vw); max-height:88vh; display:flex; flex-direction:column; background:#fff; border:1px solid var(--line); border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22); overflow:hidden; }
        #contractPage .modal-header { display:flex; align-items:center; justify-content:space-between; min-height:48px; padding:0 18px; border-bottom:1px solid var(--line); background:var(--text-head); }
        #contractPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #contractPage .modal-close { border:0; background:rgba(255,255,255,.12); cursor:pointer; color:rgba(255,255,255,.75); width:28px; height:28px; border-radius:4px; display:flex; align-items:center; justify-content:center; }
        #contractPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #contractPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #contractPage .modal-footer { display:flex; justify-content:flex-end; gap:8px; padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub); }

        /* ── 모달 폼 ── */
        #contractPage .form-section { margin-bottom:18px; }
        #contractPage .form-section:last-child { margin-bottom:0; }
        #contractPage .form-section-title { display:flex; align-items:center; gap:5px; margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid var(--line); color:var(--text-head); font-size:12px; font-weight:800; }
        #contractPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #contractPage .form-row { display:grid; gap:10px 12px; margin-bottom:10px; }
        #contractPage .form-row.cols-2 { grid-template-columns:1fr 1fr; }
        #contractPage .form-field { display:flex; flex-direction:column; gap:4px; }
        #contractPage .field-help { font-size:11px; color:var(--text-ter); line-height:1.45; margin-top:2px; }
        #contractPage .form-textarea { width:100%; min-height:70px; border:1px solid var(--line); border-radius:4px; padding:9px; font-size:12px; resize:vertical; box-sizing:border-box; font-family:'Noto Sans KR',sans-serif; }

        /* ── 반응형 ── */
        @media(max-width:1300px) { #contractPage .filter-grid { grid-template-columns:repeat(3,minmax(0,1fr)); } #contractPage .summary-grid { grid-template-columns:repeat(2,minmax(0,1fr)); } }
        @media(max-width:760px) { #contractPage .filter-grid, #contractPage .summary-grid, #contractPage .expire-list { grid-template-columns:1fr; } #contractPage .form-row.cols-2 { grid-template-columns:1fr; } #contractPage .panel-header { flex-direction:column; align-items:flex-start; gap:8px; } }
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
                        <p>시설 계약, 만료임박, 재계약, 검침 설정을 관리합니다.</p>
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

                <%-- 현황 카드 --%>
                <div class="summary-grid">
                    <a class="summary-card is-primary" href="${ctx}/manager/contract/${mgmtOfcNo}">
                        <span class="summary-icon material-symbols-rounded">description</span>
                        <span><span class="summary-val">${empty stats.TOTALCNT ? 0 : stats.TOTALCNT}</span><span class="summary-label">전체 계약</span></span>
                    </a>
                    <a class="summary-card" href="${ctx}/manager/contract/${mgmtOfcNo}">
                        <span class="summary-icon material-symbols-rounded">verified</span>
                        <span><span class="summary-val">${empty stats.ACTIVECNT ? 0 : stats.ACTIVECNT}</span><span class="summary-label">진행중 계약</span></span>
                    </a>
                    <a class="summary-card" href="${ctx}/manager/contract/${mgmtOfcNo}?expireYn=Y">
                        <span class="summary-icon material-symbols-rounded">event_upcoming</span>
                        <span><span class="summary-val">${empty stats.EXPIRINGCNT ? 0 : stats.EXPIRINGCNT}</span><span class="summary-label">만료임박 계약</span></span>
                    </a>
                    <a class="summary-card" href="${ctx}/manager/contract/${mgmtOfcNo}?meterSettingYn=Y">
                        <span class="summary-icon material-symbols-rounded">upload_file</span>
                        <span><span class="summary-val">${empty stats.METERCNT ? 0 : stats.METERCNT}</span><span class="summary-label">검침설정 계약</span></span>
                    </a>
                </div>

                <%-- 검색 조건 패널 --%>
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <form method="get" action="${ctx}/manager/contract/${mgmtOfcNo}" id="searchForm">
                            <div class="filter-grid">
                                <div class="form-field">
                                    <label class="field-label" for="contSttsCd">계약상태</label>
                                    <select class="form-select" id="contSttsCd" name="contSttsCd">
                                        <option value="">전체</option>
                                        <c:forEach var="code" items="${statusList}">
                                            <option value="${code.CODE}" <c:if test="${search.contSttsCd eq code.CODE}">selected</c:if>>${code.NAME}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="bidTyCd">입찰유형</label>
                                    <select class="form-select" id="bidTyCd" name="bidTyCd">
                                        <option value="">전체</option>
                                        <c:forEach var="code" items="${bidTypeList}">
                                            <option value="${code.CODE}" <c:if test="${search.bidTyCd eq code.CODE}">selected</c:if>>${code.NAME}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="expireYn">만료상태</label>
                                    <select class="form-select" id="expireYn" name="expireYn">
                                        <option value="">전체</option>
                                        <option value="Y" <c:if test="${search.expireYn eq 'Y'}">selected</c:if>>만료임박</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="meterSettingYn">검침설정</label>
                                    <select class="form-select" id="meterSettingYn" name="meterSettingYn">
                                        <option value="">전체</option>
                                        <option value="Y" <c:if test="${search.meterSettingYn eq 'Y'}">selected</c:if>>설정 있음</option>
                                        <option value="N" <c:if test="${search.meterSettingYn eq 'N'}">selected</c:if>>설정 없음</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="keyword">통합검색</label>
                                    <div class="search-wrap">
                                        <span class="material-symbols-rounded">search</span>
                                        <input type="text" class="form-input" id="keyword" name="keyword" value="${search.keyword}" placeholder="계약번호, 계약명, 시설명, 업체명">
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">&nbsp;</label>
                                    <div class="filter-actions">
                                        <button type="submit" class="btn btn-primary">검색</button>
                                        <a href="${ctx}/manager/contract/${mgmtOfcNo}" class="btn">초기화</a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- 만료임박 계약 패널 --%>
                <c:if test="${not empty expiringList}">
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">event_upcoming</span>만료임박 계약</h3>
                        </div>
                        <div class="panel-body">
                            <div class="expire-list">
                                <c:forEach var="item" items="${expiringList}">
                                    <div class="expire-item">
                                        <div>
                                            <div class="expire-name">${item.contNm}</div>
                                            <div class="expire-sub">${item.partnerNm} / ${item.facilityNm}</div>
                                        </div>
                                        <span class="badge badge-warn">D-${item.expireDays}</span>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </c:if>

                <%-- 계약 목록 패널 --%>
                <div class="panel panel-list">
                    <div class="panel-header">
                        <div class="list-head-left">
                            <h3 class="panel-title"><span class="material-symbols-rounded">contract</span>계약 목록</h3>
                            <span class="list-count">총 ${fn:length(contractList)}건</span>
                        </div>
                        <div class="list-head-right">
                            <button type="button" class="btn btn-primary" data-modal-target="insertModal">
                                <span class="material-symbols-rounded">add</span>계약 등록
                            </button>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl">
                            <colgroup>
                                <col style="width:6%">
                                <col style="width:10%">
                                <col style="width:18%">
                                <col style="width:14%">
                                <col style="width:14%">
                                <col style="width:9%">
                                <col style="width:9%">
                                <col style="width:10%">
                                <col style="width:16%">
                                <col style="width:9%">
                                <col style="width:9%">
                                <col style="width:10%">
                                <col style="width:18%">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>계약번호</th>
                                <th class="td-left">계약명</th>
                                <th class="td-left">시설</th>
                                <th class="td-left">협력업체</th>
                                <th>입찰유형</th>
                                <th>계약상태</th>
                                <th>계약금액</th>
                                <th>계약기간</th>
                                <th>만료상태</th>
                                <th>지급예정일</th>
                                <th>검침설정</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty contractList}">
                                    <tr>
                                        <td colspan="13" class="empty-row">조회된 계약이 없습니다.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="contract" items="${contractList}" varStatus="st">
                                        <tr>
                                            <td>${fn:length(contractList) - st.index}</td>
                                            <td class="mono">${contract.contNo}</td>
                                            <td class="td-left">
                                                <div class="contract-name">${contract.contNm}</div>
                                                <div class="contract-sub">${contract.contNo}</div>
                                            </td>
                                            <td class="td-left">${contract.facilityNm}</td>
                                            <td class="td-left">${contract.partnerNm}</td>
                                            <td>${empty contract.bidTyNm ? contract.bidTyCd : contract.bidTyNm}</td>
                                            <td><span class="badge badge-gray">${empty contract.contSttsNm ? contract.contSttsCd : contract.contSttsNm}</span></td>
                                            <td class="td-right"><fmt:formatNumber value="${contract.contAmt}" pattern="#,#0"/> 원</td>
                                            <td>
                                                <fmt:formatDate value="${contract.contBgngDt}" pattern="yyyy.MM.dd"/> ~
                                                <fmt:formatDate value="${contract.contEndDt}" pattern="yyyy.MM.dd"/>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${contract.expireDays ge 0 and contract.expireDays le 7}"><span class="badge badge-warn">D-${contract.expireDays}</span></c:when>
                                                    <c:when test="${contract.expireDays lt 0}"><span class="badge badge-error">만료</span></c:when>
                                                    <c:otherwise><span class="badge badge-normal">정상</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td><fmt:formatDate value="${contract.pymtDt}" pattern="yyyy.MM.dd"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${contract.meterSettingYn eq 'Y'}"><span class="badge badge-blue">설정 있음</span></c:when>
                                                    <c:otherwise><span class="badge badge-gray">설정 없음</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <button class="btn" type="button" data-modal-target="editModal${st.index}">수정</button>
                                                <button class="btn" type="button" data-modal-target="utilityModal${st.index}">검침</button>
                                                <button class="btn" type="button" data-modal-target="renewModal${st.index}">재계약</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

                <%-- 계약 등록 모달 --%>
                <div class="modal-overlay" id="insertModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">계약 등록</h3>
                            <button type="button" class="modal-close" data-modal-close="insertModal"><span class="material-symbols-rounded">close</span></button>
                        </div>
                        <form method="post" action="${ctx}/manager/contract/insert/${mgmtOfcNo}">
                            <sec:csrfInput/>
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title"><span class="material-symbols-rounded">description</span>계약 기본정보</div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">시설</label>
                                            <select class="form-select" name="facilityNo" required>
                                                <option value="">선택</option>
                                                <c:forEach var="facility" items="${facilityList}">
                                                    <option value="${facility.facilityNo}">${facility.facilityNm}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">협력업체</label>
                                            <select class="form-select" name="partnerNo" required>
                                                <option value="">선택</option>
                                                <c:forEach var="partner" items="${partnerList}">
                                                    <option value="${partner.partnerNo}">${partner.partnerNm}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label">계약명</label><input class="form-input" type="text" name="contNm" placeholder="예: 승강기 유지보수 계약" required></div>
                                        <div class="form-field">
                                            <label class="field-label">입찰유형</label>
                                            <select class="form-select" name="bidTyCd" required>
                                                <option value="">선택</option>
                                                <c:forEach var="code" items="${bidTypeList}">
                                                    <option value="${code.CODE}">${code.NAME}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">계약상태</label>
                                            <select class="form-select" name="contSttsCd">
                                                <c:forEach var="code" items="${statusList}">
                                                    <option value="${code.CODE}">${code.NAME}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-field"><label class="field-label">계약금액</label><input class="form-input" type="number" name="contAmt" placeholder="예: 1200000"></div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label">계약일자</label><input class="form-input" type="date" name="contDt"></div>
                                        <div class="form-field"><label class="field-label">지급예정일</label><input class="form-input" type="date" name="pymtDt"></div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field"><label class="field-label">계약시작일</label><input class="form-input" type="date" name="contBgngDt" required></div>
                                        <div class="form-field"><label class="field-label">계약종료일</label><input class="form-input" type="date" name="contEndDt" required></div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn" data-modal-close="insertModal">취소</button>
                                <button type="submit" class="btn btn-primary">등록</button>
                            </div>
                        </form>
                    </div>
                </div>

                <%-- 계약별 모달 --%>
                <c:forEach var="contract" items="${contractList}" varStatus="st">
                    <fmt:formatDate value="${contract.contDt}" pattern="yyyy-MM-dd" var="editContDt"/>
                    <fmt:formatDate value="${contract.pymtDt}" pattern="yyyy-MM-dd" var="editPymtDt"/>
                    <fmt:formatDate value="${contract.contBgngDt}" pattern="yyyy-MM-dd" var="editBgngDt"/>
                    <fmt:formatDate value="${contract.contEndDt}" pattern="yyyy-MM-dd" var="editEndDt"/>

                    <%-- 계약 수정 모달 --%>
                    <div class="modal-overlay" id="editModal${st.index}">
                        <div class="modal">
                            <div class="modal-header">
                                <h3 class="modal-title">계약 수정</h3>
                                <button type="button" class="modal-close" data-modal-close="editModal${st.index}"><span class="material-symbols-rounded">close</span></button>
                            </div>
                            <form method="post" action="${ctx}/manager/contract/update/${mgmtOfcNo}">
                                <sec:csrfInput/>
                                <input type="hidden" name="contNo" value="${contract.contNo}">
                                <div class="modal-body">
                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">edit_note</span>계약 기본정보</div>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">시설</label>
                                                <select class="form-select" name="facilityNo" required>
                                                    <c:forEach var="facility" items="${facilityList}">
                                                        <option value="${facility.facilityNo}" <c:if test="${facility.facilityNo eq contract.facilityNo}">selected</c:if>>${facility.facilityNm}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">협력업체</label>
                                                <select class="form-select" name="partnerNo" required>
                                                    <c:forEach var="partner" items="${partnerList}">
                                                        <option value="${partner.partnerNo}" <c:if test="${partner.partnerNo eq contract.partnerNo}">selected</c:if>>${partner.partnerNm}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">계약명</label><input class="form-input" type="text" name="contNm" value="${contract.contNm}" required></div>
                                            <div class="form-field">
                                                <label class="field-label">입찰유형</label>
                                                <select class="form-select" name="bidTyCd" required>
                                                    <c:forEach var="code" items="${bidTypeList}">
                                                        <option value="${code.CODE}" <c:if test="${code.CODE eq contract.bidTyCd}">selected</c:if>>${code.NAME}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">계약상태</label>
                                                <select class="form-select" name="contSttsCd">
                                                    <c:forEach var="code" items="${statusList}">
                                                        <option value="${code.CODE}" <c:if test="${code.CODE eq contract.contSttsCd}">selected</c:if>>${code.NAME}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field"><label class="field-label">계약금액</label><input class="form-input" type="number" name="contAmt" value="${contract.contAmt}"></div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">계약일자</label><input class="form-input" type="date" name="contDt" value="${editContDt}"></div>
                                            <div class="form-field"><label class="field-label">지급예정일</label><input class="form-input" type="date" name="pymtDt" value="${editPymtDt}"></div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">계약시작일</label><input class="form-input" type="date" name="contBgngDt" value="${editBgngDt}" required></div>
                                            <div class="form-field"><label class="field-label">계약종료일</label><input class="form-input" type="date" name="contEndDt" value="${editEndDt}" required></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn" data-modal-close="editModal${st.index}">취소</button>
                                    <button type="submit" class="btn btn-primary">수정</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- 검침 설정 모달 --%>
                    <div class="modal-overlay" id="utilityModal${st.index}">
                        <div class="modal">
                            <div class="modal-header">
                                <h3 class="modal-title">검침 설정</h3>
                                <button type="button" class="modal-close" data-modal-close="utilityModal${st.index}"><span class="material-symbols-rounded">close</span></button>
                            </div>
                            <form method="post" action="${ctx}/manager/contract/utility/save/${mgmtOfcNo}">
                                <sec:csrfInput/>
                                <input type="hidden" name="contNo" value="${contract.contNo}">
                                <input type="hidden" name="partnerNo" value="${contract.partnerNo}">
                                <input type="hidden" name="utilityProviderNo" value="${contract.utilityProviderNo}">
                                <div class="modal-body">
                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">link</span>계약 연결정보</div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">계약번호</label><input class="form-input" type="text" value="${contract.contNo}" readonly></div>
                                            <div class="form-field"><label class="field-label">협력업체</label><input class="form-input" type="text" value="${contract.partnerNm}" readonly></div>
                                        </div>
                                    </div>
                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">upload_file</span>CSV 식별정보</div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">CSV 식별키</label><input class="form-input" type="text" name="csvIdntfKey" value="${contract.csvIdntfKey}" placeholder="예: ELEC_A10023118" required></div>
                                            <div class="form-field"><label class="field-label">외부 고객번호</label><input class="form-input" type="text" name="extCustNo" value="${contract.extCustNo}" placeholder="예: CUST-001" required></div>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">비고</label>
                                            <textarea class="form-textarea" name="utilityRmrkCn" placeholder="예: 전기 검침 CSV 설정">${contract.utilityRmrkCn}</textarea>
                                            <div class="field-help">CSV 파일의 csv_idntf_key, ext_cust_no 값과 일치해야 업로드할 수 있습니다.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn" data-modal-close="utilityModal${st.index}">취소</button>
                                    <button type="submit" class="btn btn-primary">저장</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <%-- 재계약 모달 --%>
                    <div class="modal-overlay" id="renewModal${st.index}">
                        <div class="modal">
                            <div class="modal-header">
                                <h3 class="modal-title">재계약 등록</h3>
                                <button type="button" class="modal-close" data-modal-close="renewModal${st.index}"><span class="material-symbols-rounded">close</span></button>
                            </div>
                            <form method="post" action="${ctx}/manager/contract/renew/${mgmtOfcNo}">
                                <sec:csrfInput/>
                                <div class="modal-body">
                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">autorenew</span>기존 계약 복사</div>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">시설</label>
                                                <select class="form-select" name="facilityNo" required>
                                                    <c:forEach var="facility" items="${facilityList}">
                                                        <option value="${facility.facilityNo}" <c:if test="${facility.facilityNo eq contract.facilityNo}">selected</c:if>>${facility.facilityNm}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">협력업체</label>
                                                <select class="form-select" name="partnerNo" required>
                                                    <c:forEach var="partner" items="${partnerList}">
                                                        <option value="${partner.partnerNo}" <c:if test="${partner.partnerNo eq contract.partnerNo}">selected</c:if>>${partner.partnerNm}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">계약명</label><input class="form-input" type="text" name="contNm" value="${contract.contNm}" required></div>
                                            <div class="form-field">
                                                <label class="field-label">입찰유형</label>
                                                <select class="form-select" name="bidTyCd" required>
                                                    <c:forEach var="code" items="${bidTypeList}">
                                                        <option value="${code.CODE}" <c:if test="${code.CODE eq contract.bidTyCd}">selected</c:if>>${code.NAME}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">계약상태</label>
                                                <select class="form-select" name="contSttsCd">
                                                    <c:forEach var="code" items="${statusList}">
                                                        <option value="${code.CODE}">${code.NAME}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field"><label class="field-label">계약금액</label><input class="form-input" type="number" name="contAmt" value="${contract.contAmt}"></div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">계약일자</label><input class="form-input" type="date" name="contDt"></div>
                                            <div class="form-field"><label class="field-label">지급예정일</label><input class="form-input" type="date" name="pymtDt"></div>
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field"><label class="field-label">계약시작일</label><input class="form-input" type="date" name="contBgngDt" required></div>
                                            <div class="form-field"><label class="field-label">계약종료일</label><input class="form-input" type="date" name="contEndDt" required></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn" data-modal-close="renewModal${st.index}">취소</button>
                                    <button type="submit" class="btn btn-primary">재계약 등록</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>

            </div><!-- /contractPage -->
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        /* 모달 열기 */
        function openContractModal(modalId) {
            var modal = document.getElementById(modalId);

            if (!modal) {
                return;
            }

            if (window.openModal) {
                window.openModal(modalId);
                return;
            }

            modal.classList.add('open');
        }

        /* 모달 닫기 */
        function closeContractModal(modalId) {
            var modal = document.getElementById(modalId);

            if (!modal) {
                return;
            }

            if (window.closeModal) {
                window.closeModal(modalId);
                return;
            }

            modal.classList.remove('open');
        }

        /* 모달 열기 버튼 이벤트 */
        document.querySelectorAll('[data-modal-target]').forEach(function (button) {
            button.addEventListener('click', function () {
                openContractModal(button.getAttribute('data-modal-target'));
            });
        });

        /* 모달 닫기 버튼 이벤트 */
        document.querySelectorAll('[data-modal-close]').forEach(function (button) {
            button.addEventListener('click', function () {
                closeContractModal(button.getAttribute('data-modal-close'));
            });
        });

        /* 모달 배경 클릭 이벤트 */
        document.querySelectorAll('#contractPage .modal-overlay').forEach(function (modal) {
            modal.addEventListener('click', function (event) {
                if (event.target === modal) {
                    closeContractModal(modal.id);
                }
            });
        });
    })();
</script>
</body>
</html>
