<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isUpdate" value="${formMode eq 'update'}" />
<c:set var="isAdmin" value="false" />
<sec:authorize access="hasRole('ADMIN')">
    <c:set var="isAdmin" value="true" />
</sec:authorize>

<c:choose>
    <c:when test="${isUpdate}">
        <c:set var="formAction" value="${ctx}/manager/checkHistory/update/${mgmtOfcNo}/${check.facChkHstryNo}" />
    </c:when>
    <c:otherwise>
        <c:set var="formAction" value="${ctx}/manager/checkHistory/register/${mgmtOfcNo}" />
    </c:otherwise>
</c:choose>

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
        #facilityCheckPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --surface:#fff; --line:#d7dce2; --th-bg:#f4f6f4; --soft:#f8faf8; --text-head:#1a2e1e; --text-sub:#6b7a6e; --text-ter:#9ca3af; }
        #facilityCheckPage .page-title-block h2 { color:var(--text-head); font-size:20px; letter-spacing:-.5px; margin:0; }
        #facilityCheckPage .page-title-block p { color:var(--text-sub); font-size:12px; margin-top:6px; }

        /* 공통 패널 */
        #facilityCheckPage .panel { border:1px solid var(--line); border-radius:8px; background:var(--surface); overflow:hidden; margin:0; }
        #facilityCheckPage .panel + .panel { margin-top:14px; }
        #facilityCheckPage .panel-body { padding:18px 22px; }

        /* 섹션 제목 */
        #facilityCheckPage .section-title { display:flex; align-items:center; gap:6px; margin:0 0 12px; padding-bottom:10px; border-bottom:1px solid var(--line); font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityCheckPage .section-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityCheckPage .section-title .title-sub { margin-left:auto; color:var(--text-ter); font-size:11px; font-weight:400; }

        /* 대상 정보: 상세 화면과 같은 시설/협력업체 분리 카드 */
        #facilityCheckPage .target-grid { display:grid; grid-template-columns:1fr 1fr; gap:14px; }
        #facilityCheckPage .target-card { border:1px solid var(--line); border-radius:6px; overflow:hidden; background:#fff; }
        #facilityCheckPage .target-head { display:flex; align-items:center; justify-content:space-between; gap:10px; min-height:38px; padding:0 12px; border-bottom:1px solid var(--line); background:var(--soft); }
        #facilityCheckPage .target-title { display:flex; align-items:center; gap:6px; color:var(--text-head); font-size:12px; font-weight:800; }
        #facilityCheckPage .target-title .material-symbols-rounded { color:var(--accent); font-size:16px; }
        #facilityCheckPage .target-action { display:inline-flex; align-items:center; gap:3px; min-height:28px; height:28px; padding:0 9px; border:0; background:transparent; color:var(--accent); font-size:11px; font-weight:800; cursor:pointer; text-decoration:none; white-space:nowrap; }
        #facilityCheckPage .target-action:hover { color:var(--accent-hover); text-decoration:underline; }
        #facilityCheckPage .target-action .material-symbols-rounded { font-size:14px; }
        #facilityCheckPage .target-fixed { color:#7a887d; font-size:11px; font-weight:700; }

        /* 대상 정보 내부 3줄 2열 표 */
        #facilityCheckPage .info-compact { width:100%; border-collapse:collapse; table-layout:fixed; }
        #facilityCheckPage .info-compact th { width:74px; height:39px; padding:0 10px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); background:var(--th-bg); color:#27382b; font-size:11px; font-weight:800; text-align:left; vertical-align:middle; white-space:nowrap; }
        #facilityCheckPage .info-compact td { height:39px; padding:0 12px; border-right:1px solid var(--line); border-bottom:1px solid var(--line); color:#111827; font-size:12px; font-weight:600; vertical-align:middle; word-break:break-word; }
        #facilityCheckPage .info-compact th:nth-child(3) { border-left:1px solid var(--line); }
        #facilityCheckPage .info-compact td:last-child { border-right:none; }
        #facilityCheckPage .info-compact tr:last-child th,
        #facilityCheckPage .info-compact tr:last-child td { border-bottom:none; }
        #facilityCheckPage .info-compact .mono { font-family:'Consolas','SF Mono',monospace; color:#6b7280; font-size:11px; font-weight:500; }
        #facilityCheckPage .info-compact .ellipsis { display:block; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityCheckPage .detail-empty { color:var(--text-ter); font-weight:400; }

        /* 점검 정보 폼 */
        #facilityCheckPage .check-form-grid { display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:12px 14px; }
        #facilityCheckPage .form-field.full { grid-column:1 / -1; }
        #facilityCheckPage .field-label { display:block; margin-bottom:5px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #facilityCheckPage .required { color:#b91c1c; font-weight:900; }
        #facilityCheckPage .form-input,
        #facilityCheckPage .form-select,
        #facilityCheckPage .form-textarea { width:100%; border:1px solid var(--line); border-radius:4px; background:#fff; color:#1f2d23; font-size:12px; box-sizing:border-box; }
        #facilityCheckPage .form-input,
        #facilityCheckPage .form-select { height:34px; padding:0 9px; }
        #facilityCheckPage .form-textarea { min-height:168px; padding:10px; resize:vertical; line-height:1.55; }
        #facilityCheckPage .form-textarea.note { min-height:86px; }
        #facilityCheckPage .form-input:focus,
        #facilityCheckPage .form-select:focus,
        #facilityCheckPage .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px rgba(46,92,56,.08); outline:none; }

        /* 안내 */
        #facilityCheckPage .form-hint { margin-top:12px; padding:9px 11px; border:1px solid #e6eaee; border-radius:5px; background:#fbfcfb; color:#7a887d; font-size:11px; line-height:1.5; }
        /* 점검 이력 기본 정보 */
        #facilityCheckPage .history-base-table { width:100%; border-collapse:collapse; table-layout:fixed; border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #facilityCheckPage .history-base-table th { width:110px; height:39px; padding:0 10px; border-right:1px solid var(--line); background:var(--th-bg); color:#27382b; font-size:11px; font-weight:800; text-align:left; white-space:nowrap; }
        #facilityCheckPage .history-base-table td { height:39px; padding:0 12px; border-right:1px solid var(--line); color:#111827; font-size:12px; font-weight:600; }
        #facilityCheckPage .history-base-table td:last-child { border-right:none; }
        #facilityCheckPage .history-base-table .mono { font-family:'Consolas','SF Mono',monospace; color:#6b7280; font-size:11px; font-weight:500; }
        #facilityCheckPage .history-base-inline { margin-bottom:14px; }
        /* 점검 정보: 한 줄 안에서 이력 정보 / 입력 정보 분리 */
        /* 점검 정보: 상세 화면 톤에 맞춘 좌측 이력 / 우측 입력 */
        #facilityCheckPage .check-info-row { display:grid; grid-template-columns:34% minmax(0, 1fr); gap:16px; align-items:stretch; }
        #facilityCheckPage .check-history-area { min-width:0; padding-right:16px; border-right:1px solid var(--line); }
        #facilityCheckPage .check-input-area { min-width:0; }
        #facilityCheckPage .check-column-title { display:flex; align-items:center; gap:5px; margin-bottom:10px; color:#4a5c4e; font-size:11px; font-weight:800; }
        #facilityCheckPage .check-column-title .material-symbols-rounded { color:var(--accent); font-size:15px; }
        #facilityCheckPage .check-title-note { margin-left:auto; color:var(--text-ter); font-size:11px; font-weight:500; }
        #facilityCheckPage .facility-history-list { max-height:402px; overflow-y:auto; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #facilityCheckPage .facility-history-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #facilityCheckPage .facility-history-table th { height:34px; padding:0 7px; border-bottom:1px solid var(--line); background:var(--th-bg); color:#4a5c4e; font-size:11px; font-weight:800; text-align:center; white-space:nowrap; }
        #facilityCheckPage .facility-history-table td { height:38px; padding:6px 7px; border-bottom:1px solid #eef1f3; color:#243027; font-size:11px; text-align:center; vertical-align:middle; }
        #facilityCheckPage .facility-history-table tr:last-child td { border-bottom:none; }
        #facilityCheckPage .facility-history-table .is-current td { font-weight:800; }
        #facilityCheckPage .history-inline-row { display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:10px; margin-bottom:12px; }
        #facilityCheckPage .history-inline-item { display:flex; align-items:center; min-height:34px; border:1px solid #e6eaee; border-radius:4px; background:#fbfcfb; overflow:hidden; }
        #facilityCheckPage .history-inline-label { flex:0 0 104px; align-self:stretch; display:flex; align-items:center; padding:0 10px; border-right:1px solid #e6eaee; background:#f4f6f4; color:#4a5c4e; font-size:11px; font-weight:800; white-space:nowrap; }
        #facilityCheckPage .history-inline-value { min-width:0; padding:0 11px; color:#1f2d23; font-size:12px; font-weight:700; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #facilityCheckPage .history-inline-value.mono { font-family:'Consolas','SF Mono',monospace; color:#6b7280; font-size:11px; font-weight:700; }
        #facilityCheckPage .form-action-bar { display:flex; justify-content:flex-end; align-items:center; gap:8px; width:100%; margin-top:14px; padding:0 0 8px; box-sizing:border-box; }
        #facilityCheckPage .form-action-bar .btn { min-width:60px; }
        /* 선택 모달 */
        #facilityCheckPage .modal-overlay { display:none; position:fixed; inset:0; z-index:1000; align-items:center; justify-content:center; padding:24px; background:rgba(15,23,42,.35); box-sizing:border-box; }
        #facilityCheckPage .modal-overlay.is-open { display:flex; }
        #facilityCheckPage .modal { width:min(920px, 96vw); max-height:84vh; display:flex; flex-direction:column; background:#fff; border:1px solid var(--line); border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.25); overflow:hidden; }
        #facilityCheckPage .modal-header { display:flex; align-items:center; justify-content:space-between; padding:14px 16px; border-bottom:1px solid var(--line); }
        #facilityCheckPage .modal-title { margin:0; color:var(--text-head); font-size:14px; font-weight:900; }
        #facilityCheckPage .modal-close { border:0; background:transparent; cursor:pointer; color:#66736a; }
        #facilityCheckPage .modal-body { padding:14px 16px; overflow:hidden; }
        #facilityCheckPage .modal-search { margin-bottom:10px; }
        #facilityCheckPage .modal-table-wrap { max-height:420px; overflow-y:auto; border:1px solid var(--line); border-radius:5px; }
        #facilityCheckPage .modal-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #facilityCheckPage .modal-table th { position:sticky; top:0; z-index:1; height:36px; padding:0 8px; background:var(--th-bg); border-bottom:1px solid var(--line); color:#4a5c4e; font-size:12px; font-weight:800; text-align:center; }
        #facilityCheckPage .modal-table td { height:38px; padding:6px 8px; border-bottom:1px solid #eef1f3; font-size:12px; text-align:center; }
        #facilityCheckPage .modal-table .td-left { text-align:left; }
        #facilityCheckPage .modal-table .btn { min-height:26px; height:26px; padding:0 9px; font-size:11px; }

        @media (max-width:1100px) {
            #facilityCheckPage .target-grid { grid-template-columns:1fr; }
        }
        @media (max-width:760px) {
            #facilityCheckPage .info-compact th,
            #facilityCheckPage .info-compact td { display:block; width:100%; border-right:none; }
            #facilityCheckPage .info-compact th:nth-child(3) { border-left:none; }
            #facilityCheckPage .check-form-grid { grid-template-columns:1fr; }
            #facilityCheckPage .form-action-bar { flex-wrap:wrap; }
            #facilityCheckPage .check-info-row { grid-template-columns:1fr; }
            #facilityCheckPage .check-history-area { padding-right:0; border-right:none; }
            #facilityCheckPage .history-inline-row { grid-template-columns:1fr; }
            #facilityCheckPage .check-info-row { grid-template-columns:1fr; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${ctx}/manager/checkHistory/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="시설 점검 이력" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="facilityCheckPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>${isUpdate ? '시설 점검 이력 수정' : '시설 점검 이력 등록'}</h2>
                        <p>${isUpdate ? '대상 정보를 확인하고 점검 결과를 수정합니다.' : '점검 대상과 협력업체를 선택한 뒤 점검 결과를 입력합니다.'}</p>
                    </div>
                    <div class="page-actions"></div>
                </div>

                <c:if test="${isAdmin}">
                    <div class="readonly-notice">
                        <span class="material-symbols-rounded">lock</span>
                        ADMIN 계정은 시설 점검 이력 조회만 가능하며 등록/수정 저장은 제한됩니다.
                    </div>
                </c:if>

                <form id="checkForm" method="post" action="${formAction}">
                    <sec:csrfInput/>
                    <input type="hidden" name="facilityNo" id="facilityNo" value="${check.facilityNo}">
                    <input type="hidden" name="partnerNo" id="partnerNo" value="${check.partnerNo}">

                    <%-- 대상 정보 --%>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="section-title">
                                <span class="material-symbols-rounded">apartment</span>대상 정보
                                <span class="title-sub">시설과 협력업체를 분리해 확인합니다.</span>
                            </div>

                            <div class="target-grid">
                                <%-- 시설 정보 --%>
                                <div class="target-card">
                                    <div class="target-head">
                                        <div class="target-title">
                                            <span class="material-symbols-rounded">domain</span>시설 정보
                                        </div>
                                        <c:choose>
                                            <c:when test="${isAdmin}">
                                                <span class="target-fixed">조회 전용</span>
                                            </c:when>
                                            <c:when test="${isUpdate}">
                                                <span class="target-fixed">시설 변경 불가</span>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="target-action" id="openFacilityModalBtn">
                                                    시설 검색 <span class="material-symbols-rounded">arrow_forward</span>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <table class="info-compact">
                                        <tr>
                                            <th>시설명</th>
                                            <td><span id="facilityNmText">${empty check.facilityNm ? '<span class="detail-empty">시설을 선택해 주세요.</span>' : check.facilityNm}</span></td>
                                            <th>시설번호</th>
                                            <td><span class="mono" id="facilityNoText">${empty check.facilityNo ? '-' : check.facilityNo}</span></td>
                                        </tr>
                                        <tr>
                                            <th>시설유형</th>
                                            <td><span id="facilityTyText">${empty check.facilityTyNm ? '<span class="detail-empty">-</span>' : check.facilityTyNm}</span></td>
                                            <th>사용여부</th>
                                            <td><span id="facilityUseYnText">${empty check.useYn ? '-' : check.useYn eq 'Y' ? '사용' : '미사용'}</span></td>
                                        </tr>
                                        <tr>
                                            <th>위치</th>
                                            <td><span class="ellipsis" id="facilityLocText">${empty check.locCn ? '-' : check.locCn}</span></td>
                                            <th>설치일자</th>
                                            <td><span id="facilityInstlDtText">${empty check.instlDt ? '-' : check.instlDt}</span></td>
                                        </tr>
                                    </table>
                                </div>

                                <%-- 협력업체 정보 --%>
                                <div class="target-card">
                                    <div class="target-head">
                                        <div class="target-title">
                                            <span class="material-symbols-rounded">handshake</span>협력업체 정보
                                        </div>
                                        <c:choose>
                                            <c:when test="${isAdmin}">
                                                <span class="target-fixed">조회 전용</span>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="target-action" id="openPartnerModalBtn">
                                                    업체 검색 <span class="material-symbols-rounded">arrow_forward</span>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <table class="info-compact">
                                        <tr>
                                            <th>업체명</th>
                                            <td><span id="partnerNmText">${empty check.partnerNm ? '<span class="detail-empty">협력업체를 선택해 주세요.</span>' : check.partnerNm}</span></td>
                                            <th>업체번호</th>
                                            <td><span class="mono" id="partnerNoText">${empty check.partnerNo ? '-' : check.partnerNo}</span></td>
                                        </tr>
                                        <tr>
                                            <th>업종</th>
                                            <td><span class="ellipsis" id="bizTyText">${empty check.bizTyNm ? '-' : check.bizTyNm}</span></td>
                                            <th>담당자</th>
                                            <td><span id="partnerPicNmText">${empty check.picNm ? '-' : check.picNm}</span></td>
                                        </tr>
                                        <tr>
                                            <th>연락처</th>
                                            <td><span id="partnerPicTelText">${empty check.picTelno ? '-' : check.picTelno}</span></td>
                                            <th>이메일</th>
                                            <td><span class="ellipsis" id="partnerEmailText">${empty check.picEmail ? '-' : check.picEmail}</span></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>

                            <div class="form-hint">
                                시설 점검 이력은 선택한 시설 기준으로 저장됩니다. 등록 후 시설 자체는 변경하지 않고, 필요 시 협력업체와 점검 정보만 수정합니다.
                            </div>
                        </div>
                    </div>

                    <%-- 점검 정보 --%>
                    <div class="panel">
                        <div class="panel-body">
                            <div class="section-title">
                                <span class="material-symbols-rounded">edit_note</span>점검 정보
                                <span class="title-sub">${isUpdate ? '자동 기록 정보와 기존 점검 결과를 함께 확인합니다.' : '자동 생성 정보와 새 점검 결과를 함께 입력합니다.'}</span>
                            </div>


                            <div class="check-info-row">
                                <%-- 왼쪽: 선택된 시설의 기존 점검 이력 --%>
                                <div class="check-history-area">
                                    <div class="check-column-title">
                                        <span class="material-symbols-rounded">history</span>시설 점검 이력
                                    </div>

                                    <div class="facility-history-list">
                                        <table class="facility-history-table">
                                            <colgroup>
                                                <col style="width:36%;">
                                                <col style="width:34%;">
                                                <col style="width:30%;">
                                            </colgroup>
                                            <thead>
                                            <tr>
                                                <th>점검일자</th>
                                                <th>점검유형</th>
                                                <th>상태</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:choose>
                                                <c:when test="${not empty sameFacilityCheckList}">
                                                    <c:forEach var="history" items="${sameFacilityCheckList}">
                                                        <%-- 등록/수정 화면에서는 참고용 목록이므로 클릭 이동 없음 --%>
                                                        <tr class="${history.facChkHstryNo eq check.facChkHstryNo ? 'is-current' : ''}">
                                                            <td>${empty history.chkDt ? '-' : history.chkDt}</td>
                                                            <td>${empty history.chkTyNm ? '-' : history.chkTyNm}</td>
                                                            <td>
                                                                <span class="badge ${history.chkSttsCd eq 'WAIT' ? 'badge-wait' : history.chkSttsCd eq 'ING' ? 'badge-ing' : history.chkSttsCd eq 'DONE' ? 'badge-done' : history.chkSttsCd eq 'FAULT' ? 'badge-fault' : 'badge-wait'}">
                                                                        ${empty history.chkSttsNm ? '-' : history.chkSttsNm}
                                                                </span>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- 화면 확인용 샘플 이력 1건 --%>
                                                    <tr>
                                                        <td>2026-05-10</td>
                                                        <td>보수점검</td>
                                                        <td><span class="badge badge-fault">이상발견</span></td>
                                                    </tr>
                                                </c:otherwise>
                                            </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <%-- 오른쪽: 현재 등록/수정 입력 정보 --%>
                                <div class="check-input-area">
                                    <div class="check-column-title">
                                        <span class="material-symbols-rounded">edit_note</span>입력 정보
                                        <span class="check-title-note">점검이력번호와 등록·수정일자는 자동 관리됩니다.</span>
                                    </div>

                                    <%-- 자동 기록 정보: 점검유형 앞 한 줄 배치 --%>
                                    <div class="history-inline-row">
                                        <div class="history-inline-item">
                                            <span class="history-inline-label">점검이력번호</span>
                                            <span class="history-inline-value mono">
                                                <c:choose>
                                                    <c:when test="${isUpdate}">
                                                        ${check.facChkHstryNo}
                                                    </c:when>
                                                    <c:otherwise>
                                                        등록 후 자동 생성
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="history-inline-item">
                                            <span class="history-inline-label">이력 등록일자</span>
                                            <span class="history-inline-value">
                                                <c:choose>
                                                    <c:when test="${isUpdate and not empty check.regDt}">
                                                        ${check.regDt}
                                                    </c:when>
                                                    <c:otherwise>
                                                        등록 시 자동 기록
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>

                                        <div class="history-inline-item">
                                            <span class="history-inline-label">이력 수정일자</span>
                                            <span class="history-inline-value">
                                                <c:choose>
                                                    <c:when test="${isUpdate and not empty check.mdfDt}">
                                                        ${check.mdfDt}
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>

                                    <div class="check-form-grid">
                                        <div class="form-field">
                                            <label class="field-label">점검유형 <span class="required">*</span></label>
                                            <select class="form-select" name="chkTyCd" id="chkTyCd" required ${isAdmin ? 'disabled' : ''}>
                                                <option value="">선택</option>
                                                <c:forEach var="code" items="${checkTypeList}">
                                                    <option value="${code.codeNoCd}" ${check.chkTyCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">점검상태 <span class="required">*</span></label>
                                            <select class="form-select" name="chkSttsCd" id="chkSttsCd" required ${isAdmin ? 'disabled' : ''}>
                                                <option value="">선택</option>
                                                <c:forEach var="code" items="${checkStatusList}">
                                                    <option value="${code.codeNoCd}" ${check.chkSttsCd eq code.codeNoCd ? 'selected' : ''}>${code.codeName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">점검일자 <span class="required">*</span></label>
                                            <input type="date" class="form-input" name="chkDt" id="chkDt" value="${check.chkDt}" required ${isAdmin ? 'disabled' : ''}>
                                        </div>
                                        <div class="form-field full">
                                            <label class="field-label">점검내용 <span class="required">*</span></label>
                                            <textarea class="form-textarea" name="chkCn" id="chkCn" required ${isAdmin ? 'disabled' : ''}>${check.chkCn}</textarea>
                                        </div>
                                        <div class="form-field full">
                                            <label class="field-label">비고</label>
                                            <textarea class="form-textarea note" name="rmk" id="rmk" ${isAdmin ? 'disabled' : ''}>${check.rmk}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="form-action-bar">
                        <c:choose>
                            <c:when test="${isUpdate}">
                                <a class="btn" href="${ctx}/manager/checkHistory/detail/${mgmtOfcNo}/${check.facChkHstryNo}">취소</a>
                            </c:when>
                            <c:otherwise>
                                <a class="btn" href="${ctx}/manager/checkHistory/${mgmtOfcNo}">취소</a>
                            </c:otherwise>
                        </c:choose>

                        <c:if test="${not isAdmin}">
                            <button type="submit" class="btn btn-primary">${isUpdate ? '저장' : '등록'}</button>
                        </c:if>
                    </div>
                </form>

                <%-- 시설 선택 모달 --%>
                <div class="modal-overlay" id="facilityModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">시설 선택</h3>
                            <button type="button" class="modal-close" data-close-modal="facilityModal"><span class="material-symbols-rounded">close</span></button>
                        </div>
                        <div class="modal-body">
                            <input type="text" class="form-input modal-search" id="facilityModalSearch" placeholder="시설번호, 시설명, 시설유형, 위치 검색">
                            <div class="modal-table-wrap">
                                <table class="modal-table">
                                    <colgroup>
                                        <col style="width:16%;"><col style="width:22%;"><col style="width:15%;"><col style="width:25%;"><col style="width:10%;"><col style="width:12%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>시설번호</th>
                                        <th>시설명</th>
                                        <th>시설유형</th>
                                        <th>위치</th>
                                        <th>사용</th>
                                        <th>선택</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="facility" items="${facilityList}">
                                        <tr class="facility-modal-row"
                                            data-key="${facility.facilityNo} ${facility.facilityNm} ${facility.facilityTyNm} ${facility.locCn}"
                                            data-facility-no="${facility.facilityNo}"
                                            data-facility-nm="${facility.facilityNm}"
                                            data-facility-ty="${facility.facilityTyNm}"
                                            data-loc-cn="${facility.locCn}"
                                            data-use-yn="${facility.useYn}"
                                            data-instl-dt="${facility.instlDt}">
                                            <td>${facility.facilityNo}</td>
                                            <td class="td-left">${facility.facilityNm}</td>
                                            <td>${facility.facilityTyNm}</td>
                                            <td class="td-left">${empty facility.locCn ? '-' : facility.locCn}</td>
                                            <td>${facility.useYn eq 'Y' ? 'Y' : 'N'}</td>
                                            <td><button type="button" class="btn select-facility-btn">선택</button></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <%-- 협력업체 선택 모달 --%>
                <div class="modal-overlay" id="partnerModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">협력업체 선택</h3>
                            <button type="button" class="modal-close" data-close-modal="partnerModal"><span class="material-symbols-rounded">close</span></button>
                        </div>
                        <div class="modal-body">
                            <input type="text" class="form-input modal-search" id="partnerModalSearch" placeholder="업체번호, 업체명, 업종, 담당자 검색">
                            <div class="modal-table-wrap">
                                <table class="modal-table">
                                    <colgroup>
                                        <col style="width:16%;"><col style="width:25%;"><col style="width:19%;"><col style="width:14%;"><col style="width:14%;"><col style="width:12%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>업체번호</th>
                                        <th>업체명</th>
                                        <th>업종</th>
                                        <th>담당자</th>
                                        <th>연락처</th>
                                        <th>선택</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="partner" items="${partnerList}">
                                        <tr class="partner-modal-row"
                                            data-key="${partner.partnerNo} ${partner.partnerNm} ${partner.bizTyNm} ${partner.picNm} ${partner.picTelno}"
                                            data-partner-no="${partner.partnerNo}"
                                            data-partner-nm="${partner.partnerNm}"
                                            data-biz-ty="${partner.bizTyNm}"
                                            data-pic-nm="${partner.picNm}"
                                            data-pic-telno="${partner.picTelno}"
                                            data-pic-email="${partner.picEmail}">
                                            <td>${partner.partnerNo}</td>
                                            <td class="td-left">${partner.partnerNm}</td>
                                            <td>${empty partner.bizTyNm ? '-' : partner.bizTyNm}</td>
                                            <td>${empty partner.picNm ? '-' : partner.picNm}</td>
                                            <td>${empty partner.picTelno ? '-' : partner.picTelno}</td>
                                            <td><button type="button" class="btn select-partner-btn">선택</button></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        var form = document.getElementById("checkForm");

        /* 모달 열기 함수 */
        function openModal(id) {
            var modal = document.getElementById(id);
            if (modal) modal.classList.add("is-open");
        }

        /* 모달 닫기 함수 */
        function closeModal(id) {
            var modal = document.getElementById(id);
            if (modal) modal.classList.remove("is-open");
        }

        /* 모달 행 검색 필터 함수 */
        function filterRows(inputId, rowSelector) {
            var keyword = document.getElementById(inputId).value.toLowerCase().trim();

            document.querySelectorAll(rowSelector).forEach(function (row) {
                var key = (row.getAttribute("data-key") || "").toLowerCase();
                row.style.display = !keyword || key.indexOf(keyword) > -1 ? "" : "none";
            });
        }

        /* 텍스트 값 보정 함수 */
        function safeText(value, fallback) {
            return value && value.trim() ? value : (fallback || "-");
        }

        /* 시설 검색 버튼 */
        var openFacilityBtn = document.getElementById("openFacilityModalBtn");
        if (openFacilityBtn) {
            openFacilityBtn.addEventListener("click", function () {
                openModal("facilityModal");
            });
        }

        /* 업체 검색 버튼 */
        var openPartnerBtn = document.getElementById("openPartnerModalBtn");
        if (openPartnerBtn) {
            openPartnerBtn.addEventListener("click", function () {
                openModal("partnerModal");
            });
        }

        /* 모달 닫기 버튼 */
        document.querySelectorAll("[data-close-modal]").forEach(function (btn) {
            btn.addEventListener("click", function () {
                closeModal(btn.getAttribute("data-close-modal"));
            });
        });

        /* 모달 배경 클릭 닫기 */
        document.querySelectorAll(".modal-overlay").forEach(function (overlay) {
            overlay.addEventListener("click", function (event) {
                if (event.target === overlay) {
                    closeModal(overlay.id);
                }
            });
        });

        /* 시설 모달 검색 */
        var facilitySearch = document.getElementById("facilityModalSearch");
        if (facilitySearch) {
            facilitySearch.addEventListener("input", function () {
                filterRows("facilityModalSearch", ".facility-modal-row");
            });
        }

        /* 업체 모달 검색 */
        document.getElementById("partnerModalSearch").addEventListener("input", function () {
            filterRows("partnerModalSearch", ".partner-modal-row");
        });

        /* 시설 선택 처리 */
        document.querySelectorAll(".select-facility-btn").forEach(function (btn) {
            btn.addEventListener("click", function () {
                var row = btn.closest(".facility-modal-row");
                var facilityNo = row.getAttribute("data-facility-no") || "";
                var facilityNm = row.getAttribute("data-facility-nm") || "";
                var facilityTy = row.getAttribute("data-facility-ty") || "";
                var locCn = row.getAttribute("data-loc-cn") || "";
                var useYn = row.getAttribute("data-use-yn") || "";
                var instlDt = row.getAttribute("data-instl-dt") || "";

                document.getElementById("facilityNo").value = facilityNo;
                document.getElementById("facilityNoText").textContent = safeText(facilityNo);
                document.getElementById("facilityNmText").textContent = safeText(facilityNm, "시설을 선택해 주세요.");
                document.getElementById("facilityTyText").textContent = safeText(facilityTy);
                document.getElementById("facilityUseYnText").textContent = useYn === "Y" ? "사용" : (useYn === "N" ? "미사용" : "-");
                document.getElementById("facilityLocText").textContent = safeText(locCn);
                document.getElementById("facilityInstlDtText").textContent = safeText(instlDt);

                closeModal("facilityModal");
            });
        });

        /* 업체 선택 처리 */
        document.querySelectorAll(".select-partner-btn").forEach(function (btn) {
            btn.addEventListener("click", function () {
                var row = btn.closest(".partner-modal-row");
                var partnerNo = row.getAttribute("data-partner-no") || "";
                var partnerNm = row.getAttribute("data-partner-nm") || "";
                var bizTy = row.getAttribute("data-biz-ty") || "";
                var picNm = row.getAttribute("data-pic-nm") || "";
                var picTelno = row.getAttribute("data-pic-telno") || "";
                var picEmail = row.getAttribute("data-pic-email") || "";

                document.getElementById("partnerNo").value = partnerNo;
                document.getElementById("partnerNoText").textContent = safeText(partnerNo);
                document.getElementById("partnerNmText").textContent = safeText(partnerNm, "협력업체를 선택해 주세요.");
                document.getElementById("bizTyText").textContent = safeText(bizTy);
                document.getElementById("partnerPicNmText").textContent = safeText(picNm);
                document.getElementById("partnerPicTelText").textContent = safeText(picTelno);
                document.getElementById("partnerEmailText").textContent = safeText(picEmail);

                closeModal("partnerModal");
            });
        });

        /* 저장 전 필수 선택 검증 */
        form.addEventListener("submit", function (event) {
            if (${isAdmin}) {
                alert("ADMIN 계정은 등록/수정 저장을 할 수 없습니다.");
                event.preventDefault();
                return;
            }

            if (!document.getElementById("facilityNo").value) {
                alert("점검 대상 시설을 선택해 주세요.");
                event.preventDefault();
                return;
            }

            if (!document.getElementById("partnerNo").value) {
                alert("협력업체를 선택해 주세요.");
                event.preventDefault();
            }
        });
    });
</script>
</body>
</html>
