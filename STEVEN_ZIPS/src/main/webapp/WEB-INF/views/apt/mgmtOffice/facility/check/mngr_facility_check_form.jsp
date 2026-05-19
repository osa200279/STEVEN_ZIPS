<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isAdmin" value="false" />
<sec:authorize access="hasRole('ADMIN')"><c:set var="isAdmin" value="true" /></sec:authorize>
<c:set var="isUpdate" value="${formMode eq 'update'}" />
<c:set var="isLocked" value="${isAdmin or isUpdate}" />
<%-- update 모드 form action --%>
<c:set var="formAction" value="${ctx}/manager/checkHistory/register/${mgmtOfcNo}" />
<c:if test="${isUpdate}">
    <c:set var="formAction" value="${ctx}/manager/checkHistory/update/${mgmtOfcNo}/${check.facChkHstryNo}" />
</c:if>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isUpdate ? '시설 점검 이력 수정' : '시설 점검 이력 등록'}</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">
    <style>
        #fchPage {
            --acc:#2e5c38; --acc-h:#1f4027; --acc-l:#e8f0ea;
            --line:#d7dce2; --bg:#fff; --soft:#f8faf8;
            --th:#f4f6f4; --head:#1a2e1e; --sub:#6b7a6e; --muted:#9ca3af;
            font-family:'Noto Sans KR',sans-serif;
        }
        #fchPage .btn {
            display:inline-flex; align-items:center; justify-content:center;
            gap:4px; height:32px; padding:0 12px; border-radius:4px;
            border:1px solid var(--line); background:var(--bg); color:#39443d;
            font-size:12px; font-weight:700; cursor:pointer; text-decoration:none; box-sizing:border-box;
        }
        #fchPage .btn:hover { background:#f4f7f4; }
        #fchPage .btn-primary { background:var(--acc); border-color:var(--acc); color:#fff; }
        #fchPage .btn-primary:hover { background:var(--acc-h); border-color:var(--acc-h); }
        #fchPage .btn .material-symbols-rounded { font-size:15px; }
        #fchPage .panel { margin-bottom:14px; border:1px solid var(--line); border-radius:8px; background:var(--bg); overflow:hidden; }
        #fchPage .panel-body { padding:18px 22px; }
        #fchPage .section-title { display:flex; align-items:center; gap:6px; margin:0 0 14px; padding-bottom:10px; border-bottom:1px solid var(--line); color:var(--head); font-size:13px; font-weight:800; }
        #fchPage .section-title .material-symbols-rounded { font-size:17px; color:var(--acc); }
        #fchPage .title-sub { margin-left:auto; color:var(--muted); font-size:11px; font-weight:400; }

        /* 상단 대상 카드 */
        #fchPage .target-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        #fchPage .target-card { border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #fchPage .target-head { display:flex; align-items:center; justify-content:space-between; min-height:38px; padding:0 12px; border-bottom:1px solid var(--line); background:var(--soft); }
        #fchPage .target-title { display:flex; align-items:center; gap:6px; color:var(--head); font-size:12px; font-weight:800; }
        #fchPage .target-title .material-symbols-rounded { font-size:16px; color:var(--acc); }
        #fchPage .target-fixed { color:#7a887d; font-size:11px; font-weight:700; }
        #fchPage .target-locked { display:flex; align-items:center; gap:3px; color:#9ca3af; font-size:11px; font-weight:700; }
        #fchPage .target-locked .material-symbols-rounded { font-size:13px; }
        #fchPage .target-body { padding:12px 14px; }
        #fchPage .empty-state { display:flex; flex-direction:column; align-items:center; justify-content:center; min-height:110px; padding:14px; border:1px dashed #cfd8d1; border-radius:5px; background:#fbfcfb; text-align:center; }
        #fchPage .empty-state .material-symbols-rounded { font-size:26px; color:#9aa8a0; margin-bottom:6px; }
        #fchPage .empty-state p { margin:0 0 10px; color:#6f7d72; font-size:12px; font-weight:700; }
        #fchPage .selected-state { min-height:110px; }
        #fchPage .selected-actions { display:flex; justify-content:flex-end; margin-top:10px; }
        #fchPage .info-tbl { width:100%; border-collapse:collapse; table-layout:fixed; }
        #fchPage .info-tbl th { width:68px; height:34px; padding:0 8px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); background:var(--th); color:#27382b; font-size:11px; font-weight:800; text-align:left; white-space:nowrap; }
        #fchPage .info-tbl td { height:34px; padding:0 10px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); color:#111827; font-size:12px; font-weight:600; word-break:break-word; }
        #fchPage .info-tbl th:nth-child(3) { border-left:1px solid var(--line); }
        #fchPage .info-tbl td:last-child { border-right:none; }
        #fchPage .info-tbl tr:last-child th, #fchPage .info-tbl tr:last-child td { border-bottom:none; }

        /* 하단 2분할 */
        #fchPage .history-layout { display:grid; grid-template-columns:40% minmax(0,1fr); gap:16px; }
        #fchPage .list-area { border-right:1px solid var(--line); padding-right:16px; }
        #fchPage .area-title { display:flex; align-items:center; gap:5px; margin-bottom:8px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #fchPage .area-title .material-symbols-rounded { font-size:15px; color:var(--acc); }

        /* 필터 한 줄 */
        #fchPage .history-filter { display:flex; align-items:flex-end; gap:6px; margin-bottom:8px; padding:10px; border:1px solid var(--line); border-radius:6px; background:#fbfcfb; }
        #fchPage .history-filter>.f-field { flex:1; min-width:0; }
        #fchPage .history-filter>.f-btns  { flex:none; display:flex; gap:5px; }
        #fchPage .field-label { display:block; margin-bottom:4px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #fchPage .form-select, #fchPage .form-input { width:100%; height:30px; padding:0 8px; border:1px solid var(--line); border-radius:4px; background:var(--bg); color:#1f2d23; font-size:12px; box-sizing:border-box; }
        #fchPage .form-select:focus, #fchPage .form-input:focus { border-color:var(--acc); outline:none; box-shadow:0 0 0 2px rgba(46,92,56,.08); }
        #fchPage .history-filter .btn { height:30px; }

        /* 이력 목록 */
        #fchPage .history-list { height:440px; overflow-y:auto; border:1px solid var(--line); border-radius:6px; background:var(--bg); padding:8px; box-sizing:border-box; }
        #fchPage .history-empty { display:flex; align-items:center; justify-content:center; min-height:100px; color:#7a887d; font-size:12px; font-weight:700; text-align:center; }
        #fchPage .history-item { display:grid; grid-template-columns:82px minmax(0,1fr); gap:8px; width:100%; margin-bottom:6px; padding:9px 10px; border:1px solid var(--line); border-radius:6px; background:var(--bg); color:inherit; text-align:left; font-family:inherit; cursor:pointer; box-sizing:border-box; }
        #fchPage .history-item:last-child { margin-bottom:0; }
        #fchPage .history-item:hover     { border-color:#bdd7c5; background:#f8fcf9; }
        #fchPage .history-item.is-active { border-color:var(--acc); background:var(--acc-l); }
        #fchPage .h-date    { color:#111827; font-size:12px; font-weight:800; line-height:1.4; }
        #fchPage .h-main    { min-width:0; }
        #fchPage .h-meta    { display:flex; align-items:center; gap:5px; margin-bottom:4px; }
        #fchPage .h-type    { color:#39443d; font-size:11px; font-weight:800; }
        #fchPage .h-partner { display:block; color:#6b7280; font-size:11px; margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #fchPage .h-cn      { display:block; color:#374151; font-size:11px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #fchPage .badge { display:inline-flex; align-items:center; justify-content:center; min-height:18px; padding:0 6px; border-radius:3px; font-size:10px; font-weight:700; border:1px solid transparent; white-space:nowrap; }
        #fchPage .badge-wait  { background:#f3f4f6; color:#4b5563; border-color:#d1d5db; }
        #fchPage .badge-ing   { background:#dbeafe; color:#1e3a5f; border-color:#93c5fd; }
        #fchPage .badge-done  { background:#e8f1eb; color:#1f5a35; border-color:#bdd7c5; }
        #fchPage .badge-fault { background:#fee2e2; color:#7f1d1d; border-color:#fca5a5; }

        /* 오른쪽 공용 폼 */
        #fchPage .form-panel { border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #fchPage .form-panel-head { display:flex; align-items:center; min-height:40px; padding:0 14px; border-bottom:1px solid var(--line); background:var(--soft); }
        #fchPage .form-panel-title { display:flex; align-items:center; gap:6px; margin:0; color:var(--head); font-size:13px; font-weight:900; }
        #fchPage .form-panel-title .material-symbols-rounded { font-size:16px; color:var(--acc); }
        #fchPage .form-panel-body { padding:16px; }
        #fchPage .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px 12px; }
        #fchPage .form-grid .full { grid-column:1 / -1; }
        #fchPage .form-label { display:block; margin-bottom:4px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #fchPage .required { color:#b91c1c; }
        #fchPage .form-field-input, #fchPage .form-field-select { width:100%; height:34px; padding:0 9px; border:1px solid var(--line); border-radius:4px; background:var(--bg); color:#1f2d23; font-size:12px; box-sizing:border-box; }
        #fchPage .form-field-input:focus, #fchPage .form-field-select:focus { border-color:var(--acc); outline:none; box-shadow:0 0 0 2px rgba(46,92,56,.08); }
        #fchPage .form-field-input[readonly], #fchPage .form-field-select[disabled], #fchPage .form-field-input[disabled] { background:var(--soft); color:#6b7280; cursor:default; }
        #fchPage .form-textarea { width:100%; padding:9px; border:1px solid var(--line); border-radius:4px; background:var(--bg); color:#1f2d23; font-size:12px; line-height:1.55; resize:vertical; box-sizing:border-box; min-height:120px; }
        #fchPage .form-textarea.short { min-height:70px; }
        #fchPage .form-textarea:focus { border-color:var(--acc); outline:none; box-shadow:0 0 0 2px rgba(46,92,56,.08); }
        #fchPage .form-textarea[readonly], #fchPage .form-textarea[disabled] { background:var(--soft); color:#6b7280; cursor:default; }
        #fchPage .readonly-box { height:34px; display:flex; align-items:center; padding:0 9px; border:1px solid var(--line); border-radius:4px; background:var(--soft); color:#6b7280; font-size:12px; box-sizing:border-box; }
        #fchPage .mono { font-family:'Consolas','SF Mono',monospace; font-size:11px; }
        #fchPage .form-action-bar { display:flex; justify-content:flex-end; align-items:center; gap:8px; margin-top:14px; }

        /* split 카드 (detail과 동일한 구조) */
        #fchPage .split-panel { border:1px solid var(--line); border-radius:6px; overflow:hidden; background:var(--bg); }
        #fchPage .split-head  { display:flex; align-items:center; justify-content:space-between; min-height:42px; padding:0 14px; border-bottom:1px solid var(--line); background:var(--soft); }
        #fchPage .split-title { display:flex; align-items:center; gap:6px; color:var(--head); font-size:13px; font-weight:800; }
        #fchPage .split-title .material-symbols-rounded { color:var(--acc); font-size:17px; }
        #fchPage .split-desc  { color:var(--muted); font-size:11px; }
        #fchPage .split-body  { padding:10px; }

        /* 유틸 */
        #fchPage .is-hidden { display:none !important; }
        #fchPage .ellipsis  { display:block; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

        /* 모달 */
        #fchPage .modal-overlay { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.35); box-sizing:border-box; }
        #fchPage .modal-overlay.open, #fchPage .modal-overlay.is-open { display:flex; }
        #fchPage .modal { width:min(920px,96vw); max-height:84vh; display:flex; flex-direction:column; background:var(--bg); border:1px solid var(--line); border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.25); overflow:hidden; }
        #fchPage .modal-header { display:flex; align-items:center; justify-content:space-between; padding:14px 16px; border-bottom:1px solid var(--line); }
        #fchPage .modal-title { margin:0; color:var(--head); font-size:14px; font-weight:900; }
        #fchPage .modal-close { border:0; background:transparent; cursor:pointer; color:#66736a; }
        #fchPage .modal-body { padding:14px 16px; overflow:hidden; }
        #fchPage .modal-filter-grid { display:grid; grid-template-columns:repeat(3,minmax(0,1fr)); gap:8px 10px; margin-bottom:10px; }
        #fchPage .modal-filter-grid .form-field.full { grid-column:1 / -1; }
        #fchPage .modal-filter-actions { display:flex; justify-content:flex-end; gap:6px; margin-bottom:10px; }
        #fchPage .modal-table-wrap { max-height:400px; overflow-y:auto; border:1px solid var(--line); border-radius:5px; }
        #fchPage .modal-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #fchPage .modal-table th { position:sticky; top:0; z-index:1; height:34px; padding:0 8px; background:var(--th); border-bottom:1px solid var(--line); color:#4a5c4e; font-size:12px; font-weight:800; text-align:center; }
        #fchPage .modal-table td { height:36px; padding:4px 8px; border-bottom:1px solid #eef1f3; font-size:12px; text-align:center; }
        #fchPage .modal-table .td-left { text-align:left; }

        @media(max-width:1100px) {
            #fchPage .target-grid, #fchPage .history-layout { grid-template-columns:1fr; }
            #fchPage .list-area { border-right:none; padding-right:0; }
        }
        @media(max-width:760px) {
            #fchPage .form-grid { grid-template-columns:1fr; }
            #fchPage .history-filter { flex-wrap:wrap; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref"    value="${ctx}/manager/checkHistory/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent"  value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="시설 점검 이력" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="fchPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>${isUpdate ? '시설 점검 이력 수정' : '시설 점검 이력 등록'}</h2>
                        <p>
                            <c:choose>
                                <c:when test="${isUpdate}">오정보 정정 목적의 수정입니다. 시설과 협력업체는 변경할 수 없습니다.</c:when>
                                <c:otherwise>시설을 선택하고 기존 이력을 확인하면서 새 점검 이력을 등록합니다.</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <c:if test="${isAdmin}">
                    <div style="margin-bottom:12px;padding:10px 14px;border:1px solid #fca5a5;border-radius:6px;background:#fff5f5;color:#7f1d1d;font-size:12px;font-weight:700;">
                        <span class="material-symbols-rounded" style="vertical-align:middle;font-size:15px;">lock</span>
                        ADMIN 계정은 조회만 가능하며 저장은 제한됩니다.
                    </div>
                </c:if>

                <form id="checkForm" method="post" action="${formAction}">
                    <sec:csrfInput/>
                    <input type="hidden" id="facilityNo" name="facilityNo" value="${check.facilityNo}">
                    <input type="hidden" id="partnerNo"  name="partnerNo"  value="${check.partnerNo}">
                    <c:if test="${isUpdate}">
                        <input type="hidden" name="facChkHstryNo" value="${check.facChkHstryNo}">
                    </c:if>

                    <%-- ── 상단: 시설 / 협력업체 ── --%>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="section-title">
                                <span class="material-symbols-rounded">apartment</span>대상 정보
                                <span class="title-sub">
                                    <c:choose>
                                        <c:when test="${isUpdate}">수정 모드에서는 시설과 협력업체를 변경할 수 없습니다.</c:when>
                                        <c:otherwise>시설과 협력업체를 선택합니다.</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="target-grid">

                                <%-- 시설 카드 --%>
                                <div class="target-card">
                                    <div class="target-head">
                                        <div class="target-title">
                                            <span class="material-symbols-rounded">domain</span>시설 정보
                                        </div>
                                        <c:choose>
                                            <c:when test="${isLocked}">
                                                <span class="target-locked">
                                                    <span class="material-symbols-rounded">lock</span>변경 불가
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="target-fixed">필수 선택</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="target-body">
                                        <%-- 선택 전 (등록 모드 + 시설 없을 때만) --%>
                                        <c:if test="${not isLocked}">
                                            <div id="facilityEmptyState" class="empty-state ${empty check.facilityNo ? '' : 'is-hidden'}">
                                                <span class="material-symbols-rounded">apartment</span>
                                                <p>점검 이력을 등록할 시설을 선택하세요.</p>
                                                <button type="button" class="btn btn-primary" id="openFacilityModalBtn">
                                                    <span class="material-symbols-rounded">link</span>시설 선택
                                                </button>
                                            </div>
                                        </c:if>
                                        <%-- 선택 후 --%>
                                        <div id="facilitySelectedState" class="${(not isLocked and empty check.facilityNo) ? 'selected-state is-hidden' : 'selected-state'}">
                                            <table class="info-tbl">
                                                <tr>
                                                    <th>시설명</th>
                                                    <td><span id="facilityNmText">${empty check.facilityNm ? '-' : check.facilityNm}</span></td>
                                                    <th>시설번호</th>
                                                    <td><span id="facilityNoText" class="mono">${empty check.facilityNo ? '-' : check.facilityNo}</span></td>
                                                </tr>
                                                <tr>
                                                    <th>시설유형</th>
                                                    <td><span id="facilityTyText">${empty check.facilityTyNm ? '-' : check.facilityTyNm}</span></td>
                                                    <th>사용여부</th>
                                                    <td><span id="facilityUseYnText">${check.useYn eq 'Y' ? '사용' : empty check.useYn ? '-' : '미사용'}</span></td>
                                                </tr>
                                                <tr>
                                                    <th>위치</th>
                                                    <td><span id="facilityLocText" class="ellipsis">${empty check.locCn ? '-' : check.locCn}</span></td>
                                                    <th>설치일자</th>
                                                    <td><span id="facilityInstlDtText">${empty check.instlDt ? '-' : check.instlDt}</span></td>
                                                </tr>
                                            </table>
                                            <c:if test="${not isLocked}">
                                                <div class="selected-actions">
                                                    <button type="button" class="btn" id="reopenFacilityModalBtn">다시 선택</button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <%-- 협력업체 카드 --%>
                                <div class="target-card">
                                    <div class="target-head">
                                        <div class="target-title">
                                            <span class="material-symbols-rounded">handshake</span>협력업체 정보
                                        </div>
                                        <c:choose>
                                            <c:when test="${isLocked}">
                                                <span class="target-locked">
                                                    <span class="material-symbols-rounded">lock</span>변경 불가
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="target-fixed">필수 선택</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="target-body">
                                        <c:if test="${not isLocked}">
                                            <div id="partnerEmptyState" class="empty-state ${empty check.partnerNo ? '' : 'is-hidden'}">
                                                <span class="material-symbols-rounded">business_center</span>
                                                <p>점검을 진행한 협력업체를 선택하세요.</p>
                                                <button type="button" class="btn btn-primary" id="openPartnerModalBtn">
                                                    <span class="material-symbols-rounded">search</span>협력업체 선택
                                                </button>
                                            </div>
                                        </c:if>
                                        <div id="partnerSelectedState" class="${(not isLocked and empty check.partnerNo) ? 'selected-state is-hidden' : 'selected-state'}">
                                            <table class="info-tbl">
                                                <tr>
                                                    <th>업체명</th>
                                                    <td><span id="partnerNmText">${empty check.partnerNm ? '-' : check.partnerNm}</span></td>
                                                    <th>업체번호</th>
                                                    <td><span id="partnerNoText" class="mono">${empty check.partnerNo ? '-' : check.partnerNo}</span></td>
                                                </tr>
                                                <tr>
                                                    <th>업종</th>
                                                    <td><span id="bizTyText" class="ellipsis">${empty check.bizTyNm ? '-' : check.bizTyNm}</span></td>
                                                    <th>담당자</th>
                                                    <td><span id="partnerPicNmText">${empty check.picNm ? '-' : check.picNm}</span></td>
                                                </tr>
                                                <tr>
                                                    <th>연락처</th>
                                                    <td><span id="partnerPicTelText">${empty check.picTelno ? '-' : check.picTelno}</span></td>
                                                    <th>이메일</th>
                                                    <td><span id="partnerEmailText" class="ellipsis">${empty check.picEmail ? '-' : check.picEmail}</span></td>
                                                </tr>
                                            </table>
                                            <c:if test="${not isLocked}">
                                                <div class="selected-actions">
                                                    <button type="button" class="btn" id="reopenPartnerModalBtn">다시 선택</button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                            </div><%-- /target-grid --%>
                        </div>
                    </div><%-- /상단 패널 --%>

                    <%-- ── 하단: 이력 목록 + 공용 폼 ── --%>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="section-title">
                                <span class="material-symbols-rounded">fact_check</span>점검 이력
                                <span class="title-sub">
                                    <c:choose>
                                        <c:when test="${isUpdate}">수정할 이력을 선택하세요.</c:when>
                                        <c:otherwise>왼쪽 이력을 클릭하면 오른쪽에 상세가 표시됩니다.</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="history-layout">

                                <%-- 왼쪽: 이력 목록 --%>
                                <div class="list-area">
                                    <div class="split-panel">
                                        <div class="split-head">
                                            <div class="split-title">
                                                <span class="material-symbols-rounded">history</span>같은 시설의 점검 이력
                                            </div>
                                            <span class="split-desc">간략 이력</span>
                                        </div>
                                        <div class="split-body">
                                            <div class="history-filter">
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterChkTyCd">점검유형</label>
                                                    <select class="form-select" id="historyFilterChkTyCd">
                                                        <option value="">전체</option>
                                                        <c:forEach var="code" items="${checkTypeList}">
                                                            <option value="${code.codeNoCd}">${code.codeName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterChkSttsCd">점검상태</label>
                                                    <select class="form-select" id="historyFilterChkSttsCd">
                                                        <option value="">전체</option>
                                                        <c:forEach var="code" items="${checkStatusList}">
                                                            <option value="${code.codeNoCd}">${code.codeName}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="f-field">
                                                    <label class="field-label" for="historyFilterKeyword">검색어</label>
                                                    <input type="text" class="form-input" id="historyFilterKeyword" placeholder="내용·업체명">
                                                </div>
                                                <div class="f-btns">
                                                    <button type="button" class="btn btn-primary" id="historySearchBtn">검색</button>
                                                    <button type="button" class="btn" id="historyResetBtn">초기화</button>
                                                </div>
                                            </div>
                                            <div class="history-list" id="facilityHistoryList">
                                                <div class="history-empty">시설을 선택하면 기존 점검 이력이 표시됩니다.</div>
                                            </div>
                                        </div><%-- /split-body --%>
                                    </div><%-- /split-panel --%>
                                </div><%-- /list-area --%>

                                <%-- 오른쪽: 등록/수정 폼 + 기존 이력 상세 표시 --%>
                                <div class="form-panel">
                                    <div class="split-head">
                                        <div class="split-title">
                                            <span class="material-symbols-rounded">article</span>
                                            <span id="historyFormTitle">현재 점검 결과</span>
                                        </div>
                                    </div>
                                    <div class="form-panel-body">
                                        <%-- 이력번호 + 시설번호 --%>
                                        <div class="form-grid" style="margin-bottom:10px;">
                                            <div id="baseHistoryRow" class="is-hidden">
                                                <label class="form-label">기준이력번호</label>
                                                <div class="readonly-box mono" id="baseHistoryNoText">-</div>
                                            </div>
                                            <div>
                                                <label class="form-label">시설번호</label>
                                                <div class="readonly-box mono" id="formFacilityNoText">${empty check.facilityNo ? '-' : check.facilityNo}</div>
                                            </div>
                                            <div id="currentHistoryRow">
                                                <label class="form-label">이력번호</label>
                                                <div class="readonly-box mono" id="currentHistoryNoText">-</div>
                                            </div>
                                        </div>
                                        <%-- 입력 필드 --%>
                                        <div class="form-grid">
                                            <div>
                                                <label class="form-label" for="chkTyCd">점검유형 <span class="required">*</span></label>
                                                <select class="form-field-select" id="chkTyCd" name="chkTyCd" disabled>
                                                    <option value="">선택</option>
                                                    <c:forEach var="code" items="${checkTypeList}">
                                                        <option value="${code.codeNoCd}" ${check.chkTyCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div>
                                                <label class="form-label" for="chkSttsCd">점검상태 <span class="required">*</span></label>
                                                <select class="form-field-select" id="chkSttsCd" name="chkSttsCd" disabled>
                                                    <option value="">선택</option>
                                                    <c:forEach var="code" items="${checkStatusList}">
                                                        <option value="${code.codeNoCd}" ${check.chkSttsCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="full">
                                                <label class="form-label" for="chkDt">점검일자 <span class="required">*</span></label>
                                                <input type="date" class="form-field-input" id="chkDt" name="chkDt" value="${check.chkDt}" readonly>
                                            </div>
                                            <div class="full">
                                                <label class="form-label" for="chkCn">점검내용 <span class="required">*</span></label>
                                                <textarea class="form-textarea" id="chkCn" name="chkCn" readonly>${check.chkCn}</textarea>
                                            </div>
                                            <div class="full">
                                                <label class="form-label" for="rmk">비고</label>
                                                <textarea class="form-textarea short" id="rmk" name="rmk" readonly>${check.rmk}</textarea>
                                            </div>
                                        </div>
                                        <%-- 안내 메시지 (오정보 수정 모드 진입 시 표시) --%>
                                        <div id="correctNotice" class="is-hidden" style="margin-top:10px;padding:9px 12px;border:1px solid #fca5a5;border-radius:5px;background:#fff5f5;color:#7f1d1d;font-size:11px;line-height:1.6;">
                                            <strong>오정보 정정 목적의 수정입니다.</strong><br>
                                            점검 이력은 수정하지 않는 것을 원칙으로 합니다.<br>
                                            잘못 입력된 정보를 정정하는 경우에만 사용하세요.
                                        </div>
                                        <%-- 버튼 바 --%>
                                        <div class="form-action-bar">
                                            <a class="btn" href="${ctx}/manager/checkHistory/${mgmtOfcNo}">목록</a>
                                            <button type="button" class="btn is-hidden" id="cancelFollowBtn">취소</button>
                                            <c:if test="${not isAdmin}">
                                                <button type="button" class="btn btn-primary is-hidden" id="openFollowBtn">
                                                    <span class="material-symbols-rounded">edit_note</span>후속 등록
                                                </button>
                                                <button type="button" class="btn is-hidden" id="openCorrectBtn">오정보 수정</button>
                                                <button type="submit" class="btn btn-primary is-hidden" id="saveHistoryBtn">저장</button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div><%-- /form-panel --%>

                            </div><%-- /history-layout --%>
                        </div>
                    </div><%-- /하단 패널 --%>

                </form>

                <%-- 선택 모달 (등록 모드일 때만) --%>
                <c:if test="${not isLocked}">
                    <%@ include file="/WEB-INF/views/apt/mgmtOffice/facility/check/facility_check_select_modal.jspf" %>
                </c:if>

            </div><%-- /fchPage --%>
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        /* ── 화면 설정값 ── */
        var CTX       = '${ctx}';
        var OFC_NO    = '${mgmtOfcNo}';
        var IS_ADMIN  = ${isAdmin};
        var IS_UPDATE = ${isUpdate};  /* 수정 모드(URL 진입) 여부 */
        var REGISTER_ACTION = CTX + '/manager/checkHistory/register/' + OFC_NO;
        var UPDATE_ACTION_PREFIX = CTX + '/manager/checkHistory/update/' + OFC_NO + '/';
        var currentMode = IS_UPDATE ? 'update' : 'register';
        var selectedHistory = null;

        /* ── 화면 상태값 ── */
        var allList = [];   /* 전체 이력 원본 — AJAX 응답 기준 */
        var latest  = null; /* 최신 이력 — 후속 등록 기준, 항상 allList[0] */

        /* ════════════════════════════
           DOM 헬퍼
        ════════════════════════════ */
        /* ID 기준 단일 요소 반환 */
        function el(id)         { return document.getElementById(id); }
        /* textContent 설정 — 빈값이면 '-' 표시 */
        function setText(id, v) { var e = el(id); if (e) e.textContent = (v === null || v === undefined || String(v).trim() === '') ? '-' : String(v); }
        /* value 설정 */
        function setVal(id, v)  { var e = el(id); if (e) e.value = v || ''; }
        /* is-hidden 클래스 제거 */
        function show(id)       { var e = el(id); if (e) e.classList.remove('is-hidden'); }
        /* is-hidden 클래스 추가 */
        function hide(id)       { var e = el(id); if (e) e.classList.add('is-hidden'); }

        /* 입력 필드 readonly/disabled 일괄 전환 */
        function setReadonly(flag) {
            /* textarea, date input — readonly 속성 */
            ['chkDt', 'chkCn', 'rmk'].forEach(function (id) {
                var e = el(id);
                if (!e) return;
                flag ? e.setAttribute('readonly', '') : e.removeAttribute('readonly');
            });
            /* select — disabled 속성 */
            ['chkTyCd', 'chkSttsCd'].forEach(function (id) {
                var e = el(id);
                if (e) e.disabled = flag;
            });
        }

        /* 폼 입력값 전체 초기화 */
        function clearForm() {
            ['chkTyCd', 'chkSttsCd', 'chkDt', 'chkCn', 'rmk'].forEach(function (id) { setVal(id, ''); });
        }

        /* 이력 객체 값으로 폼 채우기 */
        function fillForm(h) {
            setVal('chkTyCd',   h.chkTyCd   || '');
            setVal('chkSttsCd', h.chkSttsCd || '');
            setVal('chkDt',     h.chkDt     || '');
            setVal('chkCn',     h.chkCn     || '');
            setVal('rmk',       h.rmk       || '');
        }

        /* ════════════════════════════
           모달 열기/닫기 — manager-common.js 우선 사용
        ════════════════════════════ */
        function openModal(id)  { if (window.openModal)  window.openModal(id);  else { var m = el(id); if (m) m.classList.add('open'); } }
        function closeModal(id) { if (window.closeModal) window.closeModal(id); else { var m = el(id); if (m) m.classList.remove('open'); } }

        /* ════════════════════════════
           AJAX JSON GET
        ════════════════════════════ */
        function fetchJson(url) {
            return fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                .then(function (r) { if (!r.ok) throw new Error(r.status); return r.json(); });
        }

        /* HTML 특수문자 이스케이프 */
        function esc(v) {
            return String(v === null || v === undefined ? '' : v)
                .replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')
                .replace(/"/g,'&quot;').replace(/'/g,'&#039;');
        }

        /* 점검상태 코드 → 배지 CSS 클래스 반환 */
        function badgeCls(cd) {
            if (cd === 'ING')   return 'badge-ing';
            if (cd === 'DONE')  return 'badge-done';
            if (cd === 'FAULT') return 'badge-fault';
            return 'badge-wait';
        }

        /* URLSearchParams 쿼리 문자열 생성 — 빈값 제외 */
        function buildQuery(params) {
            var q = new URLSearchParams();
            Object.keys(params).forEach(function (k) { if (params[k]) q.append(k, params[k]); });
            return q.toString();
        }

        /* ════════════════════════════
           왼쪽 이력 목록 렌더링
        ════════════════════════════ */
        function renderList(list) {
            var box = el('facilityHistoryList');
            if (!list || list.length === 0) {
                box.innerHTML = '<div class="history-empty">이 시설의 점검 이력이 없습니다.</div>';
                return;
            }
            box.innerHTML = list.map(function (h) {
                return '<button type="button" class="history-item" data-no="' + esc(h.facChkHstryNo) + '">'
                    + '<div class="h-date">' + esc(h.chkDt) + '</div>'
                    + '<div class="h-main">'
                    +   '<div class="h-meta">'
                    +     '<span class="h-type">' + esc(h.chkTyNm) + '</span>'
                    +     '<span class="badge ' + badgeCls(h.chkSttsCd) + '">' + esc(h.chkSttsNm) + '</span>'
                    +   '</div>'
                    +   '<span class="h-partner">' + esc(h.partnerNm) + '</span>'
                    +   '<span class="h-cn">'      + esc(h.chkCn)     + '</span>'
                    + '</div>'
                    + '</button>';
            }).join('');
        }

        /* 클릭된 이력 카드 활성 표시 */
        function markActive(no) {
            document.querySelectorAll('#facilityHistoryList .history-item').forEach(function (btn) {
                btn.classList.toggle('is-active', btn.dataset.no === no);
            });
        }

        /* ════════════════════════════
           시설 선택 후 이력 AJAX 로드
        ════════════════════════════ */
        function loadHistory(facilityNo) {
            el('facilityHistoryList').innerHTML = '<div class="history-empty">불러오는 중...</div>';
            setMode('empty');

            fetchJson(CTX + '/manager/checkHistory/history/list/'
                + encodeURIComponent(OFC_NO) + '/' + encodeURIComponent(facilityNo))
                .then(function (data) {
                    allList = (data && data.success ? data.historyList : []) || [];
                    latest  = allList.length > 0 ? allList[0] : null;
                    renderList(allList);

                    if (IS_UPDATE) {
                        /* 수정 진입 — 기본은 오정보 수정 폼이 아니라 기존 이력 상세 확인 상태 */
                        var initNo = '${check.facChkHstryNo}';
                        var initH  = allList.filter(function (h) { return h.facChkHstryNo === initNo; })[0] || latest || null;
                        if (initH) {
                            setMode('detail', initH);
                            markActive(initH.facChkHstryNo);
                        } else {
                            setMode('detail');
                        }
                        return;
                    }

                    /* 등록 진입 — 기존 이력이 있든 없든 오른쪽은 항상 신규 등록 폼 유지 */
                    setMode('register');
                })
                .catch(function () {
                    el('facilityHistoryList').innerHTML = '<div class="history-empty">이력 조회 중 오류가 발생했습니다.</div>';
                    if (!IS_UPDATE) setMode('register');
                });
        }

        /* ════════════════════════════
           오른쪽 폼 모드 전환
           empty    — 시설 미선택 초기 상태
           register — 신규 점검 이력 등록 폼, 저장 시 INSERT
           detail   — 기존 이력 카드 클릭 후 읽기 전용 상세 표시
           follow   — 수정 화면에서 기존 이력을 기준으로 새 이력 INSERT
           update   — 오정보 정정 수정 폼, 저장 시 UPDATE
        ════════════════════════════ */
        function setFormAction(actionUrl, historyNo) {
            var form = el('checkForm');
            if (form) form.setAttribute('action', actionUrl);

            var hiddenNo = document.querySelector('input[name="facChkHstryNo"]');
            if (hiddenNo) {
                hiddenNo.disabled = actionUrl === REGISTER_ACTION;
                if (historyNo) hiddenNo.value = historyNo;
            }
        }

        function setCancelButtonText(text) {
            var btn = el('cancelFollowBtn');
            if (btn) btn.textContent = text;
        }

        function setMode(mode, history) {
            currentMode = mode;
            selectedHistory = history || selectedHistory || null;

            /* 버튼/안내 전체 숨김 후 모드별 필요한 것만 표시 */
            hide('openFollowBtn');
            hide('cancelFollowBtn');
            hide('saveHistoryBtn');
            hide('openCorrectBtn');
            hide('correctNotice');
            hide('baseHistoryRow');
            setReadonly(true);

            var fNo = el('facilityNo').value;

            if (mode === 'empty') {
                /* 시설 미선택 — 안내 문구만 표시 */
                selectedHistory = null;
                setFormAction(IS_UPDATE ? UPDATE_ACTION_PREFIX + encodeURIComponent('${check.facChkHstryNo}') : REGISTER_ACTION);
                setText('historyFormTitle', '시설 선택 대기');
                setText('formFacilityNoText', '-');
                setText('currentHistoryNoText', '-');
                clearForm();
            }
            else if (mode === 'register') {
                /* 등록 화면 기본 상태 — 기존 이력 유무와 관계없이 새 이력 INSERT */
                selectedHistory = null;
                setFormAction(REGISTER_ACTION);
                setText('historyFormTitle', '시설 점검 이력 등록');
                setText('formFacilityNoText', fNo);
                setText('currentHistoryNoText', '신규');
                clearForm();
                setReadonly(false);
                document.querySelectorAll('#facilityHistoryList .history-item').forEach(function (btn) { btn.classList.remove('is-active'); });
                if (!IS_ADMIN) { show('saveHistoryBtn'); el('saveHistoryBtn').textContent = '등록'; }
            }
            else if (mode === 'detail') {
                /* 이력 카드 클릭 — 읽기 전용 상세 표시, register 모드에서도 기존 내용 확인 가능 */
                var h = history || {};
                selectedHistory = h;
                setFormAction(IS_UPDATE && h.facChkHstryNo ? UPDATE_ACTION_PREFIX + encodeURIComponent(h.facChkHstryNo) : REGISTER_ACTION, h.facChkHstryNo);
                setText('historyFormTitle', '기존 점검 이력 상세');
                setText('formFacilityNoText', fNo);
                setText('currentHistoryNoText', h.facChkHstryNo || '-');
                fillForm(h);

                if (!IS_ADMIN && !IS_UPDATE) {
                    /* 등록 화면에서는 상세 확인 후 다시 신규 등록 폼으로 돌아갈 수 있게 함 */
                    setCancelButtonText('신규 등록으로 돌아가기');
                    show('cancelFollowBtn');
                }

                if (!IS_ADMIN && IS_UPDATE) {
                    /* 수정 화면에서는 선택 이력을 기준으로 수정/후속등록 가능 */
                    show('openFollowBtn');
                    show('openCorrectBtn');
                }
            }
            else if (mode === 'follow') {
                /* 후속이력 등록 — 수정 화면에서 선택/수정 중인 이력을 기준으로 새 이력 INSERT */
                var base = selectedHistory || history || latest || {};
                var baseNo = base.facChkHstryNo || '';
                setFormAction(REGISTER_ACTION);
                setText('historyFormTitle', '후속이력 등록');
                setText('formFacilityNoText', fNo);
                setText('currentHistoryNoText', '신규');
                setText('baseHistoryNoText', baseNo);
                show('baseHistoryRow');
                clearForm();
                setVal('rmk', baseNo ? '기준이력 ' + baseNo + ' 후속 조치' : '');
                setReadonly(false);
                if (!IS_ADMIN) { show('saveHistoryBtn'); el('saveHistoryBtn').textContent = '후속 등록'; }
                setCancelButtonText(IS_UPDATE ? '수정으로 돌아가기' : '취소');
                show('cancelFollowBtn');
            }
            else if (mode === 'update') {
                /* 오정보 수정 — 선택한 이력 값으로 폼 채우고 편집 가능 상태 */
                var uh = history || selectedHistory || {};
                selectedHistory = uh;
                setFormAction(UPDATE_ACTION_PREFIX + encodeURIComponent(uh.facChkHstryNo || '${check.facChkHstryNo}'), uh.facChkHstryNo || '${check.facChkHstryNo}');
                setText('historyFormTitle', '점검 이력 수정');
                setText('formFacilityNoText', fNo);
                setText('currentHistoryNoText', uh.facChkHstryNo || '${check.facChkHstryNo}' || '-');
                fillForm(uh);
                setReadonly(false);
                show('correctNotice');
                setCancelButtonText('취소');
                show('cancelFollowBtn');
                if (!IS_ADMIN) { show('saveHistoryBtn'); el('saveHistoryBtn').textContent = '수정 저장'; }
            }
        }

        /* ════════════════════════════
           이력 필터 — 클라이언트 사이드
        ════════════════════════════ */
        /* 필터 조건 적용 후 목록 재렌더링 */
        function applyFilter() {
            var ty = el('historyFilterChkTyCd').value;
            var st = el('historyFilterChkSttsCd').value;
            var kw = el('historyFilterKeyword').value.trim().toLowerCase();

            var filtered = allList.filter(function (h) {
                var kwOk = !kw || [h.chkCn, h.rmk, h.partnerNm].join(' ').toLowerCase().indexOf(kw) > -1;
                return (!ty || h.chkTyCd === ty) && (!st || h.chkSttsCd === st) && kwOk;
            });

            if (filtered.length === 0) {
                el('facilityHistoryList').innerHTML = '<div class="history-empty">검색 결과가 없습니다.</div>';
                if (!IS_UPDATE) setMode('register');
            } else {
                renderList(filtered);
                if (IS_UPDATE) {
                    setMode('detail', filtered[0]);
                    markActive(filtered[0].facChkHstryNo);
                } else {
                    setMode('register');
                }
            }
        }

        /* 필터 초기화 후 전체 목록 복원 */
        function resetFilter() {
            setVal('historyFilterChkTyCd',   '');
            setVal('historyFilterChkSttsCd', '');
            setVal('historyFilterKeyword',   '');
            renderList(allList);
            if (IS_UPDATE && allList.length > 0) {
                var backNo = selectedHistory && selectedHistory.facChkHstryNo ? selectedHistory.facChkHstryNo : allList[0].facChkHstryNo;
                var backH = allList.filter(function (h) { return h.facChkHstryNo === backNo; })[0] || allList[0];
                setMode('detail', backH);
                markActive(backH.facChkHstryNo);
            } else {
                setMode('register');
            }
        }

        /* ════════════════════════════
           시설 선택 모달 — AJAX 재검색 후 tbody 갱신
           (초기 목록은 facility_check_select_modal.jspf 서버 렌더링)
        ════════════════════════════ */
        function searchFacility() {
            var q = buildQuery({
                facilityTyCd:       el('facilityFilterType')  ? el('facilityFilterType').value  : '',
                dongNo:             el('facilityFilterDong')  ? el('facilityFilterDong').value  : '',
                facilityUseYn:      el('facilityFilterUseYn') ? el('facilityFilterUseYn').value : '',
                facilityLocCn:      el('facilityFilterLoc')   ? el('facilityFilterLoc').value   : '',
                facilitySearchWord: el('facilityModalSearch') ? el('facilityModalSearch').value : ''
            });
            fetchJson(CTX + '/manager/checkHistory/facility/search/' + encodeURIComponent(OFC_NO) + (q ? '?' + q : ''))
                .then(function (d) { renderFacilityTbody(d && d.success ? d.facilityList : []); })
                .catch(function ()  { renderFacilityTbody([]); });
        }

        /* 협력업체 선택 모달 — AJAX 재검색 후 tbody 갱신 */
        function searchPartner() {
            var q = buildQuery({
                bizTyNm:           el('partnerFilterBizTy')  ? el('partnerFilterBizTy').value  : '',
                partnerUseYn:      el('partnerFilterUseYn')  ? el('partnerFilterUseYn').value  : '',
                picNm:             el('partnerFilterPicNm')  ? el('partnerFilterPicNm').value  : '',
                partnerSearchWord: el('partnerModalSearch')  ? el('partnerModalSearch').value  : ''
            });
            fetchJson(CTX + '/manager/checkHistory/partner/search/' + encodeURIComponent(OFC_NO) + (q ? '?' + q : ''))
                .then(function (d) { renderPartnerTbody(d && d.success ? d.partnerList : []); })
                .catch(function ()  { renderPartnerTbody([]); });
        }

        /* 시설 모달 tbody 행 생성 및 교체 */
        function renderFacilityTbody(list) {
            var tb = el('facilityModalTbody');
            if (!tb) return;
            if (!list || !list.length) { tb.innerHTML = '<tr><td colspan="6">검색된 시설이 없습니다.</td></tr>'; return; }
            tb.innerHTML = list.map(function (f) {
                return '<tr class="facility-modal-row"'
                    + ' data-facility-no="' + esc(f.facilityNo)   + '"'
                    + ' data-facility-nm="' + esc(f.facilityNm)   + '"'
                    + ' data-facility-ty="' + esc(f.facilityTyNm) + '"'
                    + ' data-loc-cn="'      + esc(f.locCn)        + '"'
                    + ' data-use-yn="'      + esc(f.useYn)        + '"'
                    + ' data-instl-dt="'    + esc(f.instlDt)      + '">'
                    + '<td>' + esc(f.facilityNo) + '</td>'
                    + '<td class="td-left">' + esc(f.facilityNm)   + '</td>'
                    + '<td>' + esc(f.facilityTyNm) + '</td>'
                    + '<td class="td-left">' + esc(f.locCn)        + '</td>'
                    + '<td>' + (f.useYn === 'Y' ? 'Y' : 'N')       + '</td>'
                    + '<td><button type="button" class="btn select-facility-btn">선택</button></td>'
                    + '</tr>';
            }).join('');
        }

        /* 협력업체 모달 tbody 행 생성 및 교체 */
        function renderPartnerTbody(list) {
            var tb = el('partnerModalTbody');
            if (!tb) return;
            if (!list || !list.length) { tb.innerHTML = '<tr><td colspan="6">검색된 협력업체가 없습니다.</td></tr>'; return; }
            tb.innerHTML = list.map(function (p) {
                return '<tr class="partner-modal-row"'
                    + ' data-partner-no="'  + esc(p.partnerNo) + '"'
                    + ' data-partner-nm="'  + esc(p.partnerNm) + '"'
                    + ' data-biz-ty="'      + esc(p.bizTyNm)   + '"'
                    + ' data-pic-nm="'      + esc(p.picNm)     + '"'
                    + ' data-pic-telno="'   + esc(p.picTelno)  + '"'
                    + ' data-pic-email="'   + esc(p.picEmail)  + '">'
                    + '<td>' + esc(p.partnerNo) + '</td>'
                    + '<td class="td-left">' + esc(p.partnerNm) + '</td>'
                    + '<td>' + esc(p.bizTyNm)  + '</td>'
                    + '<td>' + esc(p.picNm)    + '</td>'
                    + '<td>' + esc(p.picTelno) + '</td>'
                    + '<td><button type="button" class="btn select-partner-btn">선택</button></td>'
                    + '</tr>';
            }).join('');
        }

        /* ════════════════════════════
           시설 선택 처리
           — 모달 행 클릭 시 상단 카드 갱신 + 이력 로드
        ════════════════════════════ */
        function selectFacility(btn) {
            var row   = btn.closest('.facility-modal-row');
            if (!row) return;
            var useYn = row.dataset.useYn;

            /* 상단 시설 카드 갱신 */
            setVal('facilityNo', row.dataset.facilityNo);
            setText('facilityNoText',      row.dataset.facilityNo);
            setText('facilityNmText',      row.dataset.facilityNm);
            setText('facilityTyText',      row.dataset.facilityTy);
            setText('facilityLocText',     row.dataset.locCn);
            setText('facilityInstlDtText', row.dataset.instlDt);
            setText('facilityUseYnText',   useYn === 'Y' ? '사용' : useYn === 'N' ? '미사용' : '-');
            setText('formFacilityNoText',  row.dataset.facilityNo);

            /* 선택 상태 전환 및 모달 닫기 */
            el('facilityEmptyState').classList.add('is-hidden');
            el('facilitySelectedState').classList.remove('is-hidden');
            closeModal('facilityModal');

            /* 선택 시설 이력 AJAX 로드 */
            loadHistory(row.dataset.facilityNo);
        }

        /* ════════════════════════════
           협력업체 선택 처리
           — 모달 행 클릭 시 상단 카드 갱신
        ════════════════════════════ */
        function selectPartner(btn) {
            var row = btn.closest('.partner-modal-row');
            if (!row) return;

            /* 상단 협력업체 카드 갱신 */
            setVal('partnerNo', row.dataset.partnerNo);
            setText('partnerNoText',     row.dataset.partnerNo);
            setText('partnerNmText',     row.dataset.partnerNm);
            setText('bizTyText',         row.dataset.bizTy);
            setText('partnerPicNmText',  row.dataset.picNm);
            setText('partnerPicTelText', row.dataset.picTelno);
            setText('partnerEmailText',  row.dataset.picEmail);

            el('partnerEmptyState').classList.add('is-hidden');
            el('partnerSelectedState').classList.remove('is-hidden');
            closeModal('partnerModal');
        }

        /* ════════════════════════════
           클릭 이벤트 위임
        ════════════════════════════ */
        document.addEventListener('click', function (e) {
            var t = e.target;

            /* 시설 모달 열기 */
            if (t.closest('#openFacilityModalBtn, #reopenFacilityModalBtn')) { openModal('facilityModal'); return; }
            /* 시설 모달 검색 */
            if (t.closest('#facilitySearchBtn')) { searchFacility(); return; }
            /* 시설 모달 초기화 */
            if (t.closest('#facilitySearchResetBtn')) {
                ['facilityFilterType','facilityFilterDong','facilityFilterUseYn','facilityFilterLoc','facilityModalSearch']
                    .forEach(function (id) { setVal(id, ''); });
                searchFacility(); return;
            }
            /* 시설 선택 */
            var sfBtn = t.closest('.select-facility-btn');
            if (sfBtn) { selectFacility(sfBtn); return; }

            /* 협력업체 모달 열기 */
            if (t.closest('#openPartnerModalBtn, #reopenPartnerModalBtn')) { openModal('partnerModal'); return; }
            /* 협력업체 모달 검색 */
            if (t.closest('#partnerSearchBtn')) { searchPartner(); return; }
            /* 협력업체 모달 초기화 */
            if (t.closest('#partnerSearchResetBtn')) {
                ['partnerFilterBizTy','partnerFilterUseYn','partnerFilterPicNm','partnerModalSearch']
                    .forEach(function (id) { setVal(id, ''); });
                searchPartner(); return;
            }
            /* 협력업체 선택 */
            var spBtn = t.closest('.select-partner-btn');
            if (spBtn) { selectPartner(spBtn); return; }

            /* 이력 카드 클릭 — 등록 모드에서도 기존 이력 상세 확인 가능 */
            var hItem = t.closest('.history-item');
            if (hItem) {
                var no    = hItem.dataset.no;
                var found = allList.filter(function (h) { return h.facChkHstryNo === no; })[0];
                if (found) { setMode('detail', found); markActive(no); }
                return;
            }

            /* 이력 필터 검색 */
            if (t.closest('#historySearchBtn')) { applyFilter(); return; }
            /* 이력 필터 초기화 */
            if (t.closest('#historyResetBtn'))  { resetFilter(); return; }

            /* 후속 등록 버튼 — 수정 화면에서 새 이력 INSERT 모드 진입 */
            if (t.closest('#openFollowBtn')) { setMode('follow', selectedHistory || latest); return; }

            /* 오정보 수정 버튼 — 현재 선택 이력 기준 update 모드 진입 */
            if (t.closest('#openCorrectBtn')) {
                var activeCard = document.querySelector('#facilityHistoryList .history-item.is-active');
                var curH = activeCard
                    ? allList.filter(function (h) { return h.facChkHstryNo === activeCard.dataset.no; })[0]
                    : (selectedHistory || latest || null);
                if (curH) { setMode('update', curH); markActive(curH.facChkHstryNo); }
                return;
            }

            /* 취소 버튼 */
            if (t.closest('#cancelFollowBtn')) {
                if (!IS_UPDATE) {
                    /* 등록 화면 상세 확인 후 신규 등록 폼 복귀 */
                    setMode('register');
                    return;
                }

                if (currentMode === 'follow' || currentMode === 'update') {
                    /* 수정 화면 후속/오정보 수정 취소 — 기준 이력 상세 확인 상태로 복귀 */
                    var backTarget = selectedHistory || latest;
                    if (backTarget) { setMode('detail', backTarget); markActive(backTarget.facChkHstryNo); }
                    return;
                }

                history.back();
                return;
            }
        });

        /* ════════════════════════════
           키보드 Enter 처리
        ════════════════════════════ */
        document.addEventListener('keydown', function (e) {
            if (e.key !== 'Enter') return;
            var id = e.target && e.target.id;
            /* 이력 필터 검색어 */
            if (id === 'historyFilterKeyword') { e.preventDefault(); applyFilter();    return; }
            /* 시설 모달 검색어 */
            if (id === 'facilityModalSearch')  { e.preventDefault(); searchFacility(); return; }
            /* 협력업체 모달 검색어 */
            if (id === 'partnerModalSearch')   { e.preventDefault(); searchPartner();  return; }
        });

        /* ════════════════════════════
           폼 submit 전 검증
        ════════════════════════════ */
        el('checkForm').addEventListener('submit', function (e) {
            if (IS_ADMIN)                    { alert('ADMIN 계정은 저장할 수 없습니다.');    e.preventDefault(); return; }
            if (!el('facilityNo').value)     { alert('점검 대상 시설을 선택해 주세요.');     e.preventDefault(); return; }
            if (!el('partnerNo').value)      { alert('협력업체를 선택해 주세요.');           e.preventDefault(); return; }
            if (!el('chkTyCd').value)        { alert('점검유형을 선택해 주세요.');           e.preventDefault(); return; }
            if (!el('chkSttsCd').value)      { alert('점검상태를 선택해 주세요.');           e.preventDefault(); return; }
            if (!el('chkDt').value)          { alert('점검일자를 입력해 주세요.');           e.preventDefault(); return; }
            if (!el('chkCn').value.trim())   { alert('점검내용을 입력해 주세요.');           e.preventDefault(); return; }
        });

        /* ════════════════════════════
           초기 화면 상태 설정
        ════════════════════════════ */
        (function init() {
            /* select 중복 옵션 제거 — 시설유형/동 select는 facilityList 루프로 중복 생성됨 */
            function dedupSelect(selectId) {
                var select = el(selectId);
                if (!select) return;
                var seen = {};
                Array.prototype.slice.call(select.options).forEach(function (opt) {
                    if (!opt.value) return;
                    if (seen[opt.value]) { opt.parentNode.removeChild(opt); return; }
                    seen[opt.value] = true;
                });
            }
            dedupSelect('facilityFilterType');
            dedupSelect('facilityFilterDong');

            var initNo = el('facilityNo').value;
            if (initNo) {
                /* facilityNo가 있으면 (수정 진입 또는 상세에서 후속등록 진입) 이력 바로 로드 */
                if (el('facilityEmptyState'))    el('facilityEmptyState').classList.add('is-hidden');
                if (el('facilitySelectedState')) el('facilitySelectedState').classList.remove('is-hidden');
                loadHistory(initNo);
            } else {
                /* 신규 등록 진입 — 시설 선택 안내 상태 */
                setMode('empty');
            }
        }());

    }());
</script>
</body>
</html>
