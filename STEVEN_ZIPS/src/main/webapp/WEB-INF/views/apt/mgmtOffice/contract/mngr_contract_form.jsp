<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="isTerminateMode" value="${param.mode eq 'terminate' or mode eq 'terminate'}" />
<fmt:formatDate value="${contract.contDt}" pattern="yyyy-MM-dd" var="contDtValue"/>
<fmt:formatDate value="${contract.contBgngDt}" pattern="yyyy-MM-dd" var="contBgngDtValue"/>
<fmt:formatDate value="${contract.contEndDt}" pattern="yyyy-MM-dd" var="contEndDtValue"/>
<fmt:formatDate value="${contract.pymtDt}" pattern="yyyy-MM-dd" var="pymtDtValue"/>

<%--
    계약 등록/수정 공용 폼
    - mode 값 기준으로 등록/수정 구분
    - 등록: mode = insert
    - 수정: mode = update
    - 해지: param.mode = terminate 또는 mode = terminate
    - 해지 모드는 기존 계약정보를 잠그고 계약상태/해지 사유만 저장하도록 유도
    - 계약서 첨부파일은 FACILITY_CONTRACT.FILE_GROUP_NO 기준으로 연결
    - 상세 조회는 목록 JSP의 모달에서 처리
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${isTerminateMode}">계약 해지</c:when>
            <c:when test="${mode eq 'update'}">계약 수정</c:when>
            <c:otherwise>계약 등록</c:otherwise>
        </c:choose>
    </title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${ctx}/css/office-layout.css">
    <link rel="stylesheet" href="${ctx}/css/manager/manager-common.css">

    <style>
        /* ── 토큰 : 목록 화면과 같은 색감 기준 ── */
        #contractFormPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2;
            --th-bg:#f0f2ef;
            --text-head:#1a2e1e; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
            font-family:'Noto Sans KR',sans-serif;
        }

        /* ── 페이지 헤더 ── */
        #contractFormPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #contractFormPage .page-title-block p  { color:#6b7a6e; font-size:12px; }

        /* ── 버튼 ── */
        #contractFormPage .btn {
            display:inline-flex; align-items:center; justify-content:center; gap:4px;
            min-height:32px; height:32px; padding:0 11px;
            border-radius:4px; border:1px solid var(--line);
            background:#fff; color:#39443d;
            font-size:12px; font-weight:700;
            cursor:pointer; text-decoration:none; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif;
        }
        #contractFormPage .btn:hover { background:#f4f7f4; }
        #contractFormPage .btn-primary { background:var(--accent); border-color:var(--accent); color:#fff; }
        #contractFormPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #contractFormPage .btn-danger { background:#fff; border-color:#fecaca; color:#991b1b; }
        #contractFormPage .btn-danger:hover { background:#fef2f2; }
        #contractFormPage .btn-danger-solid { background:#b91c1c; border-color:#b91c1c; color:#fff; }
        #contractFormPage .btn-danger-solid:hover { background:#991b1b; border-color:#991b1b; color:#fff; }
        #contractFormPage .btn .material-symbols-rounded { font-size:15px; }

        /* ── 패널 ── */
        #contractFormPage .panel {
            border-radius:6px; border:1px solid var(--line);
            background:#fff; margin:0 0 12px;
            overflow:hidden;
        }
        #contractFormPage .panel:last-of-type { margin-bottom:0; }
        #contractFormPage .panel-header {
            display:flex; align-items:center; justify-content:space-between;
            padding:13px 16px; border-bottom:1px solid var(--line);
            background:#fff;
        }
        #contractFormPage .panel-title {
            display:flex; align-items:center; gap:6px;
            margin:0; font-size:13px; font-weight:800; color:var(--text-head);
        }
        #contractFormPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #contractFormPage .panel-body { padding:16px; }

        /* ── 상단 기본정보/협력업체 병렬 영역 ── */
        #contractFormPage .contract-top-row {
            display:grid;
            grid-template-columns:minmax(0,1.25fr) minmax(420px,1fr);
            gap:12px;
            align-items:stretch;
            margin-bottom:20px; /* 상단 기본정보/협력업체 묶음과 대상 시설 패널 사이 간격 */
        }
        #contractFormPage .contract-top-row .panel {
            height:100%;
            display:flex;
            flex-direction:column;
            margin-bottom:0; /* 간격은 contract-top-row에서만 관리 */
        }
        #contractFormPage .contract-top-row .panel-body { flex:1; }
        #contractFormPage .partner-panel .form-grid { grid-template-columns:1fr; }
        #contractFormPage .partner-panel .panel-body { display:flex; flex-direction:column; gap:12px; }
        #contractFormPage .partner-panel .partner-select-row { grid-template-columns:minmax(0,1fr) auto; }
        #contractFormPage .partner-file-section { margin-top:2px; padding-top:12px; border-top:1px solid var(--line); }
        #contractFormPage .partner-sub-title { display:flex; align-items:center; gap:5px; margin-bottom:10px; font-size:12px; font-weight:800; color:var(--text-head); }
        #contractFormPage .partner-sub-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #contractFormPage .partner-file-section .form-grid { grid-template-columns:1fr; gap:10px; }

        /* ── 폼 ── */
        #contractFormPage .form-grid {
            display:grid;
            grid-template-columns:repeat(4,minmax(0,1fr));
            gap:12px 14px;
        }
        #contractFormPage .form-grid.cols-2 { grid-template-columns:repeat(2,minmax(0,1fr)); }
        #contractFormPage .partner-panel .form-grid.cols-2 { grid-template-columns:1fr; }
        #contractFormPage .form-field { display:flex; flex-direction:column; gap:5px; min-width:0; }
        #contractFormPage .form-field.full { grid-column:1 / -1; }
        #contractFormPage .form-field.half { grid-column:span 2; }
        #contractFormPage .field-label {
            display:block;
            font-size:11px; font-weight:800; color:var(--text-sec);
        }
        #contractFormPage .required { color:#dc2626; margin-left:2px; }
        #contractFormPage .field-help { font-size:11px; color:var(--text-ter); line-height:1.45; margin-top:2px; }

        /* ── 해지 모드 안내/잠금 표시 ── */
        #contractFormPage .terminate-guide {
            display:flex; align-items:flex-start; gap:8px;
            margin-bottom:12px; padding:12px 14px;
            border:1px solid #fed7aa; border-radius:6px;
            background:#fff7ed; color:#7c2d12;
            font-size:12px; line-height:1.55;
        }
        #contractFormPage .terminate-guide .material-symbols-rounded { font-size:18px; color:#c2410c; margin-top:1px; flex-shrink:0; }
        #contractFormPage .terminate-guide strong { display:block; margin-bottom:2px; font-size:12px; font-weight:800; color:#7c2d12; }
        #contractFormPage .terminate-locked .form-input[readonly],
        #contractFormPage .terminate-locked .form-textarea[readonly],
        #contractFormPage .terminate-locked .readonly-control {
            background:#f8f9fb !important;
            color:#6b7280 !important;
            cursor:not-allowed !important;
        }
        #contractFormPage .terminate-locked .readonly-choice { cursor:not-allowed; opacity:.72; }

        #contractFormPage .form-select,
        #contractFormPage .form-input,
        #contractFormPage .form-textarea {
            font-size:12px;
            border:1px solid var(--line); background:#fff;
            border-radius:4px; padding:0 9px;
            width:100%; box-sizing:border-box;
            font-family:'Noto Sans KR',sans-serif; color:#1f2d23;
        }
        #contractFormPage .form-select,
        #contractFormPage .form-input { height:32px; }
        #contractFormPage .form-textarea {
            min-height:92px;
            padding:9px;
            resize:vertical;
            line-height:1.55;
        }
        #contractFormPage .form-select:focus,
        #contractFormPage .form-input:focus,
        #contractFormPage .form-textarea:focus {
            border-color:var(--accent);
            box-shadow:0 0 0 2px rgba(46,92,56,.08);
            outline:none;
        }
        #contractFormPage .form-input[readonly] { background:#f8f9fb; color:#6b7280; }


        /* ── 검침 설정 : 검침 종류 / CSV 식별키 / 외부 고객번호 한 줄 배치 ── */
        #contractFormPage .meter-setting-grid {
            display:grid;
            grid-template-columns:160px minmax(360px,1fr) 320px;
            gap:12px 14px;
            align-items:start;
        }
        #contractFormPage .meter-setting-grid .meter-kind-field,
        #contractFormPage .meter-setting-grid .meter-csv-field,
        #contractFormPage .meter-setting-grid .meter-ext-field {
            min-width:0;
        }
        #contractFormPage .meter-setting-grid .meter-rmrk-field {
            grid-column:1 / -1;
        }
        #contractFormPage .meter-csv-input-row {
            display:grid;
            grid-template-columns:minmax(0,1fr) auto;
            gap:7px;
            align-items:center;
        }

        /* ── 계약내용/비고 비율 : 계약내용을 더 넓게 표시 ── */
        #contractFormPage .contract-content-grid {
            display:grid;
            grid-template-columns:minmax(0,2fr) minmax(260px,1fr);
            gap:12px 14px;
        }
        #contractFormPage .contract-content-grid .form-textarea { min-height:124px; }

        /* ── 협력업체 선택 + 신규 등록 버튼 ── */
        #contractFormPage .partner-select-row {
            display:grid;
            grid-template-columns:minmax(0,1fr) auto;
            gap:7px;
            align-items:center;
        }
        #contractFormPage .partner-search-wrap {
            position:relative;
            min-width:0;
        }
        #contractFormPage .partner-native-select {
            display:none;
        }
        #contractFormPage .partner-search-list {
            display:none;
            position:absolute;
            left:0;
            right:0;
            top:calc(100% + 4px);
            z-index:30;
            max-height:220px;
            overflow-y:auto;
            border:1px solid var(--line);
            border-radius:4px;
            background:#fff;
            box-shadow:0 8px 18px rgba(15,23,42,.12);
        }
        #contractFormPage .partner-search-list.open {
            display:block;
        }
        #contractFormPage .partner-search-row {
            width:100%;
            border:0;
            border-bottom:1px solid #eef1f3;
            background:#fff;
            padding:9px 10px;
            text-align:left;
            cursor:pointer;
            font-family:'Noto Sans KR',sans-serif;
        }
        #contractFormPage .partner-search-row:last-child {
            border-bottom:none;
        }
        #contractFormPage .partner-search-row:hover,
        #contractFormPage .partner-search-row.is-active {
            background:#f8fbf8;
        }
        #contractFormPage .partner-search-main {
            display:block;
            font-size:12px;
            font-weight:800;
            color:#1f2937;
        }
        #contractFormPage .partner-search-sub {
            display:block;
            margin-top:3px;
            font-size:11px;
            color:#7a8a7d;
            white-space:nowrap;
            overflow:hidden;
            text-overflow:ellipsis;
        }
        #contractFormPage .partner-search-empty {
            padding:14px 10px;
            font-size:12px;
            color:var(--text-ter);
            text-align:center;
        }
        #contractFormPage .partner-guide {
            display:flex;
            align-items:flex-start;
            gap:7px;
            margin-top:7px;
            padding:9px 10px;
            border:1px solid #d7dce2;
            border-radius:4px;
            background:#f8f9fb;
            color:#6b7a6e;
            font-size:11px;
            line-height:1.5;
        }
        #contractFormPage .partner-guide .material-symbols-rounded {
            font-size:15px;
            color:var(--accent);
            margin-top:1px;
            flex-shrink:0;
        }

        /* ── 선택 영역 ── */
        #contractFormPage .choice-layout {
            display:grid;
            grid-template-columns:1fr 1fr;
            gap:12px;
        }
        #contractFormPage .choice-box {
            min-height:260px;
            border:1px solid var(--line);
            border-radius:4px;
            background:#fff;
            overflow:hidden;
        }
        #contractFormPage .choice-head {
            display:flex; align-items:center; gap:8px;
            min-height:42px;
            padding:9px 10px;
            border-bottom:1px solid var(--line);
            background:var(--surface-sub);
        }
        #contractFormPage .choice-title {
            font-size:12px; font-weight:800; color:var(--text-sec);
            white-space:nowrap;
        }
        #contractFormPage .choice-head .form-input { flex:1; height:30px; }
        #contractFormPage .choice-list { max-height:292px; overflow-y:auto; }
        #contractFormPage .choice-row {
            display:flex; align-items:flex-start; gap:8px;
            padding:9px 10px;
            border-bottom:1px solid #edf0ed;
            cursor:pointer;
        }
        #contractFormPage .choice-row:last-child { border-bottom:none; }
        #contractFormPage .choice-row:hover { background:#f8fbf8; }
        #contractFormPage .choice-row input { margin-top:3px; }
        #contractFormPage .choice-main { display:block; font-size:12px; font-weight:800; color:#1f2937; }
        #contractFormPage .choice-sub { display:block; margin-top:3px; font-size:11px; color:#7a8a7d; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #contractFormPage .empty-row { padding:36px 12px; color:var(--text-ter); font-size:13px; text-align:center; }

        /* ── 파일 목록 ── */
        #contractFormPage .file-list {
            border:1px solid var(--line);
            border-radius:4px;
            overflow:hidden;
            background:#fff;
        }
        #contractFormPage .file-row {
            display:grid;
            grid-template-columns:1fr 96px 128px;
            align-items:center;
            min-height:40px;
            padding:0 10px;
            border-bottom:1px solid #eef1f3;
            font-size:12px;
        }
        #contractFormPage .file-row:last-child { border-bottom:none; }
        #contractFormPage .file-name { font-weight:700; color:#1f2d23; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #contractFormPage .file-meta { color:#66736a; font-size:11px; text-align:center; }
        #contractFormPage .file-actions { display:flex; align-items:center; justify-content:center; gap:8px; white-space:nowrap; }
        #contractFormPage .file-view-link { height:26px; min-height:26px; padding:0 8px; font-size:11px; }
        #contractFormPage .selected-file-list { margin-top:8px; border:1px solid var(--line); border-radius:4px; overflow:hidden; background:#fff; }
        #contractFormPage .selected-file-row { display:grid; grid-template-columns:1fr 86px 66px; align-items:center; min-height:34px; padding:0 9px; border-bottom:1px solid #eef1f3; font-size:12px; }
        #contractFormPage .selected-file-row:last-child { border-bottom:none; }
        #contractFormPage .selected-file-name { font-weight:700; color:#1f2d23; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #contractFormPage .selected-file-meta { color:#66736a; font-size:11px; text-align:center; white-space:nowrap; }

        /* ── 하단 버튼 ── */
        #contractFormPage .form-actions {
            display:flex;
            align-items:center;
            justify-content:flex-end;
            gap:8px;
            padding:14px 16px;
            border:1px solid var(--line);
            border-radius:6px;
            background:var(--surface-sub);
        }

        /* ── 협력업체 등록 모달 ── */
        #contractFormPage .modal-overlay {
            display:none; position:fixed; inset:0; z-index:1000;
            align-items:center; justify-content:center; padding:24px;
            background:rgba(15,23,42,.35); box-sizing:border-box;
        }
        #contractFormPage .modal-overlay.open,
        #contractFormPage .modal-overlay.is-open { display:flex; }
        #contractFormPage .modal {
            width:min(680px,96vw); max-height:88vh;
            display:flex; flex-direction:column;
            background:#fff; border:1px solid var(--line);
            border-radius:8px; box-shadow:0 18px 45px rgba(15,23,42,.22);
            overflow:hidden;
        }
        #contractFormPage .modal-header {
            display:flex; align-items:center; justify-content:space-between;
            min-height:48px; padding:0 18px;
            border-bottom:1px solid var(--line); background:var(--text-head);
        }
        #contractFormPage .modal-title { margin:0; color:#fff; font-size:14px; font-weight:700; }
        #contractFormPage .modal-close {
            border:0; background:rgba(255,255,255,.12); cursor:pointer;
            color:rgba(255,255,255,.75); width:28px; height:28px;
            border-radius:4px; display:flex; align-items:center; justify-content:center;
        }
        #contractFormPage .modal-close:hover { background:rgba(255,255,255,.2); }
        #contractFormPage .modal-body { padding:18px; overflow-y:auto; flex:1; }
        #contractFormPage .modal-footer {
            display:flex; justify-content:flex-end; gap:8px;
            padding:12px 18px; border-top:1px solid var(--line); background:var(--surface-sub);
        }

        #contractFormPage .is-hidden { display:none !important; }

        @media(max-width:1200px) {
            #contractFormPage .contract-top-row { grid-template-columns:1fr; }
            #contractFormPage .form-grid { grid-template-columns:repeat(2,minmax(0,1fr)); }
            #contractFormPage .choice-layout { grid-template-columns:1fr; }
            #contractFormPage .meter-setting-grid { grid-template-columns:1fr; }
            #contractFormPage .meter-setting-grid .meter-rmrk-field { grid-column:1; }
        }
        @media(max-width:760px) {
            #contractFormPage .form-grid,
            #contractFormPage .form-grid.cols-2,
            #contractFormPage .contract-content-grid { grid-template-columns:1fr; }
            #contractFormPage .form-field.half { grid-column:1; }
            #contractFormPage .page-header { flex-direction:column; align-items:flex-start; gap:8px; }
            #contractFormPage .form-actions { justify-content:flex-start; flex-wrap:wrap; }
        }
    </style>
</head>

<body>

<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/facility/contract/list/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="${isTerminateMode ? '계약 해지' : (mode eq 'update' ? '계약 수정' : '계약 등록')}" />

<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="contractFormPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>
                            <c:choose>
                                <c:when test="${isTerminateMode}">계약 해지</c:when>
                                <c:when test="${mode eq 'update'}">계약 수정</c:when>
                                <c:otherwise>계약 등록</c:otherwise>
                            </c:choose>
                        </h2>
                        <p>
                            <c:choose>
                                <c:when test="${isTerminateMode}">계약 정보를 확인하고 해지 사유를 남긴 뒤 계약상태를 해지로 저장합니다.</c:when>
                                <c:otherwise>협력업체 계약 기본정보, 대상 시설, 검침 설정, 계약서 파일을 등록합니다.</c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div class="page-actions">
                        <a class="btn" href="${ctx}/manager/facility/contract/list/${mgmtOfcNo}">
                            <span class="material-symbols-rounded">arrow_back</span>목록
                        </a>
                    </div>
                </div>

                <form id="contractForm"
                      class="${isTerminateMode ? 'terminate-locked' : ''}"
                      data-terminate-mode="${isTerminateMode ? 'Y' : 'N'}"
                      method="post"
                      enctype="multipart/form-data"
                      action="${ctx}/manager/facility/contract/${(mode eq 'update' or isTerminateMode) ? 'update' : 'insert'}/${mgmtOfcNo}">
                    <sec:csrfInput/>

                    <%-- 수정 시 계약번호와 파일그룹번호 유지 --%>
                    <input type="hidden" name="contNo" value="${contract.contNo}">
                    <input type="hidden" name="fileGroupNo" value="${contract.fileGroupNo}">
                    <input type="hidden" id="formMode" value="${isTerminateMode ? 'terminate' : (empty mode ? 'insert' : mode)}">

                    <c:if test="${isTerminateMode}">
                        <div class="terminate-guide">
                            <span class="material-symbols-rounded">warning</span>
                            <span>
                                <strong>계약 해지 처리</strong>
                                해지 모드에서는 기존 계약정보를 변경하지 않도록 대부분의 입력값을 잠급니다. 계약상태는 해지로 저장되며, 계약내용 또는 비고에 해지 사유와 내부 메모를 남겨주세요.
                            </span>
                        </div>
                    </c:if>

                    <%-- 계약 기본정보 / 협력업체 : 같은 높이의 병렬 패널 --%>
                    <div class="contract-top-row">
                        <%-- 계약 기본정보 --%>
                        <div class="panel contract-basic-panel">
                            <div class="panel-header">
                                <h3 class="panel-title"><span class="material-symbols-rounded">description</span>계약 기본정보</h3>
                            </div>

                            <div class="panel-body">
                                <div class="form-grid cols-2">
                                    <c:if test="${mode eq 'update' or isTerminateMode}">
                                        <div class="form-field">
                                            <label class="field-label">계약번호</label>
                                            <input type="text" class="form-input" value="${contract.contNo}" readonly>
                                        </div>
                                    </c:if>

                                    <div class="form-field half">
                                        <label class="field-label" for="contNm">계약명<span class="required">*</span></label>
                                        <input type="text" class="form-input" id="contNm" name="contNm"
                                               value="${fn:escapeXml(contract.contNm)}"
                                               placeholder="예: 승강기 정기 유지보수 계약" required>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="contTyCd">계약유형<span class="required">*</span></label>
                                        <select class="form-select" id="contTyCd" name="contTyCd" required>
                                            <option value="">계약유형 선택</option>
                                            <c:forEach var="type" items="${contractTypeList}">
                                                <option value="${type.code}" <c:if test="${contract.contTyCd eq type.code}">selected</c:if>>
                                                    <c:out value="${type.codeNm}"/>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="contTargetCd">대상구분<span class="required">*</span></label>
                                        <select class="form-select" id="contTargetCd" name="contTargetCd" required>
                                            <option value="FACILITY" <c:if test="${empty contract.contTargetCd or contract.contTargetCd eq 'FACILITY'}">selected</c:if>>시설</option>
                                            <option value="COMMON"   <c:if test="${contract.contTargetCd eq 'COMMON'}">selected</c:if>>단지공통</option>
                                            <option value="METER"    <c:if test="${contract.contTargetCd eq 'METER'}">selected</c:if>>검침</option>
                                            <option value="ETC"      <c:if test="${contract.contTargetCd eq 'ETC'}">selected</c:if>>기타</option>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="bidTyCd">입찰유형<span class="required">*</span></label>
                                        <select class="form-select" id="bidTyCd" name="bidTyCd" required>
                                            <option value="PRT" <c:if test="${empty contract.bidTyCd or contract.bidTyCd eq 'PRT'}">selected</c:if>>수의계약</option>
                                            <option value="GEN" <c:if test="${contract.bidTyCd eq 'GEN'}">selected</c:if>>일반경쟁입찰</option>
                                            <option value="LIM" <c:if test="${contract.bidTyCd eq 'LIM'}">selected</c:if>>제한경쟁입찰</option>
                                            <option value="SEL" <c:if test="${contract.bidTyCd eq 'SEL'}">selected</c:if>>지명경쟁입찰</option>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="contSttsCd">계약상태</label>
                                        <select class="form-select" id="contSttsCd" name="contSttsCd">
                                            <option value="DRAFT"  <c:if test="${contract.contSttsCd eq 'DRAFT'}">selected</c:if>>작성중</option>
                                            <option value="ACTIVE" <c:if test="${not isTerminateMode and (empty contract.contSttsCd or contract.contSttsCd eq 'ACTIVE')}">selected</c:if>>진행중</option>
                                            <option value="END"    <c:if test="${not isTerminateMode and contract.contSttsCd eq 'END'}">selected</c:if>>종료</option>
                                            <option value="TERM"   <c:if test="${isTerminateMode or contract.contSttsCd eq 'TERM'}">selected</c:if>>해지</option>
                                        </select>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="contAmt">계약금액<span class="required">*</span></label>
                                        <input type="number" class="form-input" id="contAmt" name="contAmt"
                                               value="${contract.contAmt}" min="0" placeholder="숫자만 입력" required>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="contDt">계약일자</label>
                                        <input type="date" class="form-input" id="contDt" name="contDt" value="${contDtValue}">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="contBgngDt">계약시작일<span class="required">*</span></label>
                                        <input type="date" class="form-input" id="contBgngDt" name="contBgngDt" value="${contBgngDtValue}" required>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="contEndDt">계약종료일</label>
                                        <input type="date" class="form-input" id="contEndDt" name="contEndDt" value="${contEndDtValue}">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label" for="pymtDt">지급예정일</label>
                                        <input type="date" class="form-input" id="pymtDt" name="pymtDt" value="${pymtDtValue}">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <%-- 협력업체 --%>
                        <div class="panel partner-panel">
                            <div class="panel-header">
                                <h3 class="panel-title"><span class="material-symbols-rounded">business</span>협력업체</h3>
                            </div>

                            <div class="panel-body">
                                <div class="form-grid cols-2">
                                    <div class="form-field">
                                        <label class="field-label" for="partnerNo">협력업체<span class="required">*</span></label>
                                        <div class="partner-select-row">
                                            <%-- 실제 제출값은 select의 partnerNo를 사용하고, 화면에서는 검색 input으로 선택한다. --%>
                                            <div class="partner-search-wrap">
                                                <input type="text"
                                                       class="form-input"
                                                       id="partnerSearchInput"
                                                       autocomplete="off"
                                                       placeholder="업체명, 업종, 담당자, 연락처 검색"
                                                       required>
                                                <div class="partner-search-list" id="partnerSearchList"></div>

                                                <select class="form-select partner-native-select" id="partnerNo" name="partnerNo" tabindex="-1">
                                                    <option value="">협력업체 선택</option>
                                                    <c:forEach var="partner" items="${partnerList}">
                                                        <option value="${partner.partnerNo}"
                                                                data-name="${fn:escapeXml(partner.partnerNm)}"
                                                                data-biz="${fn:escapeXml(partner.bizTyNm)}"
                                                                data-pic="${fn:escapeXml(partner.picNm)}"
                                                                data-tel="${fn:escapeXml(partner.picTelno)}"
                                                                <c:if test="${contract.partnerNo eq partner.partnerNo}">selected</c:if>>
                                                                ${partner.partnerNm} (${partner.bizTyNm})
                                                        </option>
                                                    </c:forEach>
                                                    <c:if test="${empty partnerList}">
                                                        <option value="" disabled>등록 가능한 협력업체가 없습니다.</option>
                                                    </c:if>
                                                </select>
                                            </div>

                                            <button type="button" class="btn" id="openPartnerRegisterModalBtn">
                                                <span class="material-symbols-rounded">add_business</span>
                                                신규 업체
                                            </button>
                                        </div>


                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">선택 업체 정보</label>
                                        <input type="text" class="form-input" id="partnerSummary" readonly placeholder="협력업체를 선택하면 담당자 정보가 표시됩니다.">
                                    </div>

                                    <div class="partner-guide">
                                        <span class="material-symbols-rounded">info</span>
                                        <span>
                                            계약 대상 업체가 목록에 없으면 신규 협력업체를 등록한 뒤 다시 선택하세요.
                                            등록 후 계약 폼으로 돌아오며, 작성 중인 계약 내용은 저장되지 않으니 업체 등록을 먼저 진행하는 것을 권장합니다.
                                        </span>
                                    </div>
                                </div>

                                <%-- 계약서 첨부파일 : 협력업체 패널 하단 배치 --%>
                                <div class="partner-file-section">
                                    <div class="partner-sub-title">
                                        <span class="material-symbols-rounded">attach_file</span>계약서 첨부파일
                                    </div>
                                    <div class="form-grid">
                                        <div class="form-field full">
                                            <label class="field-label" for="contractFiles">계약서 파일</label>
                                            <input type="file" class="form-input" id="contractFiles" name="contractFiles" multiple>
                                            <div class="field-help">계약서 관련 파일을 첨부합니다. 파일을 선택하면 아래에 선택한 파일명이 표시됩니다.</div>
                                            <div class="selected-file-list is-hidden" id="selectedContractFileList"></div>
                                        </div>

                                        <c:if test="${mode eq 'update' or isTerminateMode}">
                                            <div class="form-field full">
                                                <label class="field-label">기존 첨부파일</label>

                                                <c:choose>
                                                    <c:when test="${not empty contract.fileList}">
                                                        <div class="file-list">
                                                            <c:forEach var="file" items="${contract.fileList}">
                                                                <div class="file-row">
                                                                    <div class="file-name"><c:out value="${file.fileOgName}"/></div>
                                                                    <div class="file-meta">
                                                                        <c:choose>
                                                                            <c:when test="${file.fileSize ge 1048576}">
                                                                                <fmt:formatNumber value="${file.fileSize / 1048576}" pattern="#,##0.0"/>MB
                                                                            </c:when>
                                                                            <c:when test="${file.fileSize ge 1024}">
                                                                                <fmt:formatNumber value="${file.fileSize / 1024}" pattern="#,##0.0"/>KB
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:out value="${file.fileSize}"/>B
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                    <div class="file-actions">
                                                                            <%-- 수정 화면 기존 첨부파일은 보기 버튼으로 새 창에서 확인 --%>
                                                                        <c:url var="fileViewUrl" value="/manager/facility/contract/file/view">
                                                                            <c:param name="fileGroupNo" value="${file.fileGroupNo}" />
                                                                            <c:param name="fileSaveUuid" value="${file.fileSaveUuid}" />
                                                                        </c:url>
                                                                        <a class="btn file-view-link" href="${fileViewUrl}" target="_blank" rel="noopener">보기</a>
                                                                        <label>
                                                                            <input type="checkbox" name="deleteFileSaveUuidList" value="${file.fileSaveUuid}">
                                                                            삭제
                                                                        </label>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="empty-row">등록된 첨부파일이 없습니다.</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </c:if>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- 대상 시설 : 대상구분이 시설일 때만 사용 --%>
                    <div class="panel" id="targetFacilityPanel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">apartment</span>대상 시설</h3>
                        </div>

                        <div class="panel-body">
                            <div class="choice-layout">
                                <div class="choice-box">
                                    <div class="choice-head">
                                        <span class="choice-title">시설 선택</span>
                                        <input type="text" class="form-input" id="facilitySearchInput" placeholder="시설명, 번호, 유형 검색">
                                    </div>

                                    <div class="choice-list" id="facilityChoiceList">
                                        <c:forEach var="facility" items="${facilityList}">
                                            <c:set var="checkedYn" value="N" />
                                            <c:forEach var="target" items="${contract.targetFacilityList}">
                                                <c:if test="${target.facilityNo eq facility.facilityNo}">
                                                    <c:set var="checkedYn" value="Y" />
                                                </c:if>
                                            </c:forEach>

                                            <label class="choice-row"
                                                   data-facility-row
                                                   data-search-text="${fn:toLowerCase(facility.facilityNo)} ${fn:toLowerCase(facility.facilityNm)} ${fn:toLowerCase(facility.facilityTyCd)} ${fn:toLowerCase(facility.facilityTyNm)} ${fn:toLowerCase(facility.facilityLocationText)}">
                                                <input type="checkbox" name="targetFacilityNoList" value="${facility.facilityNo}" <c:if test="${checkedYn eq 'Y'}">checked</c:if>>
                                                <span>
                                                    <span class="choice-main"><c:out value="${facility.facilityNm}"/></span>
                                                    <span class="choice-sub">
                                                        <c:out value="${facility.facilityNo}"/> ·
                                                        <c:out value="${empty facility.facilityTyNm ? facility.facilityTyCd : facility.facilityTyNm}"/> ·
                                                        <c:out value="${facility.facilityLocationText}"/>
                                                    </span>
                                                </span>
                                            </label>
                                        </c:forEach>
                                        <c:if test="${empty facilityList}">
                                            <div class="empty-row">선택 가능한 시설이 없습니다.</div>
                                        </c:if>
                                    </div>
                                </div>

                                <div class="choice-box">
                                    <div class="choice-head">
                                        <span class="choice-title">선택된 시설</span>
                                    </div>

                                    <div class="choice-list" id="selectedFacilityList">
                                        <div class="empty-row">선택된 시설이 없습니다.</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- 설치공사 안내 : 설치공사는 시설 등록 후 계약 연결 가능 --%>
                    <div class="panel is-hidden" id="installGuidePanel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">construction</span>설치공사 계약 안내</h3>
                        </div>

                        <div class="panel-body">
                            <div class="partner-guide">
                                <span class="material-symbols-rounded">info</span>
                                <span>
                                    설치공사는 시설이 아직 등록되지 않은 상태에서도 계약을 먼저 저장할 수 있습니다.
                                    이후 시설자산 등록 화면에서 해당 설치공사 계약을 선택하면 신규 시설과 연결됩니다.
                                </span>
                            </div>
                        </div>
                    </div>

                    <%-- 검침 설정 : 대상구분이 검침일 때 UTILITY_PROVIDER 생성/수정용 --%>
                    <div class="panel is-hidden" id="meterSettingPanel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">electric_meter</span>검침 설정</h3>
                        </div>

                        <div class="panel-body">
                            <input type="hidden" name="utilityProviderNo" value="${contract.utilityProviderNo}">

                            <div class="meter-setting-grid">
                                <div class="form-field meter-kind-field">
                                    <label class="field-label" for="meterTyCd">검침 종류<span class="required">*</span></label>
                                    <select class="form-select" id="meterTyCd" name="meterTyCd">
                                        <option value="">선택</option>
                                        <option value="ELEC" <c:if test="${contract.meterTyCd eq 'ELEC'}">selected</c:if>>전기</option>
                                        <option value="WATER" <c:if test="${contract.meterTyCd eq 'WATER'}">selected</c:if>>수도</option>
                                        <option value="GAS" <c:if test="${contract.meterTyCd eq 'GAS'}">selected</c:if>>가스</option>
                                    </select>
                                    <div class="field-help">전기, 수도, 가스 중 선택합니다.</div>
                                </div>

                                <div class="form-field meter-csv-field">
                                    <label class="field-label" for="csvIdntfKey">CSV 식별키</label>
                                    <div class="meter-csv-input-row">
                                        <input type="text" class="form-input" id="csvIdntfKey" name="csvIdntfKey"
                                               value="${fn:escapeXml(contract.csvIdntfKey)}"
                                               placeholder="예: CSV_A12185003_ELEC">
                                        <button type="button" class="btn" id="makeCsvKeyBtn">자동생성</button>
                                    </div>
                                    <div class="field-help">검침 CSV 업로드 시 공급/검침 설정을 식별하는 값입니다.</div>
                                </div>

                                <div class="form-field meter-ext-field">
                                    <label class="field-label" for="extCustNo">외부 고객번호</label>
                                    <input type="text" class="form-input" id="extCustNo" name="extCustNo"
                                           value="${fn:escapeXml(contract.extCustNo)}"
                                           placeholder="예: CUST-A12185003-ELEC">
                                    <div class="field-help">외부 기관에서 별도로 부여한 고객번호가 있을 때만 입력합니다.</div>
                                </div>

                                <div class="form-field meter-rmrk-field">
                                    <label class="field-label" for="utilityRmrkCn">검침 설정 비고</label>
                                    <textarea class="form-textarea" id="utilityRmrkCn" name="utilityRmrkCn"
                                              placeholder="검침 계약과 공급/검침 설정에 대한 참고사항을 입력하세요.">${fn:escapeXml(contract.utilityRmrkCn)}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- 계약 내용 --%>
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">notes</span>계약 내용</h3>
                        </div>

                        <div class="panel-body">
                            <div class="contract-content-grid">
                                <div class="form-field">
                                    <label class="field-label" for="contCn">
                                        <c:choose>
                                            <c:when test="${isTerminateMode}">해지 메모</c:when>
                                            <c:otherwise>계약내용</c:otherwise>
                                        </c:choose>
                                    </label>
                                    <textarea class="form-textarea" id="contCn" name="contCn"
                                              placeholder="${isTerminateMode ? '해지 처리와 관련된 내부 메모를 입력하세요.' : '계약 범위, 주요 조건, 작업 내용을 입력하세요.'}">${fn:escapeXml(contract.contCn)}</textarea>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="rmrkCn">
                                        <c:choose>
                                            <c:when test="${isTerminateMode}">해지 사유/비고<span class="required">*</span></c:when>
                                            <c:otherwise>비고</c:otherwise>
                                        </c:choose>
                                    </label>
                                    <textarea class="form-textarea" id="rmrkCn" name="rmrkCn"
                                              placeholder="${isTerminateMode ? '예: 업체 요청에 따른 중도 해지, 계약 조건 변경으로 해지 처리' : '내부 참고사항을 입력하세요.'}">${fn:escapeXml(contract.rmrkCn)}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- 저장 버튼 --%>
                    <div class="form-actions">
                        <a href="${ctx}/manager/facility/contract/list/${mgmtOfcNo}" class="btn">취소</a>
                        <button type="submit" class="btn ${isTerminateMode ? 'btn-danger-solid' : 'btn-primary'}">
                            <span class="material-symbols-rounded">save</span>
                            <c:choose>
                                <c:when test="${isTerminateMode}">해지 처리</c:when>
                                <c:when test="${mode eq 'update'}">수정 저장</c:when>
                                <c:otherwise>계약 등록</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>

                <%-- 신규 협력업체 등록 모달
                     - 기존 PartnerController.insert를 사용한다.
                     - returnType=contractForm이면 등록 후 계약 등록 폼으로 돌아온다.
                --%>
                <div class="modal-overlay" id="contractPartnerRegisterModal">
                    <div class="modal">
                        <div class="modal-header">
                            <h3 class="modal-title">신규 협력업체 등록</h3>
                            <button type="button" class="modal-close" id="closePartnerRegisterModalBtn">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <form id="contractPartnerRegisterForm"
                              method="post"
                              action="${ctx}/manager/facility/partner/insert/${mgmtOfcNo}">
                            <sec:csrfInput/>
                            <input type="hidden" name="returnType" value="contractForm">

                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">store</span>
                                        업체 기본 정보
                                    </div>

                                    <div class="form-grid cols-2">
                                        <div class="form-field">
                                            <label class="field-label" for="newPartnerNm">업체명<span class="required">*</span></label>
                                            <input type="text" class="form-input" id="newPartnerNm" name="partnerNm"
                                                   placeholder="예: (주)대한엘리베이터" required>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label" for="newBizTyNm">업종<span class="required">*</span></label>
                                            <input type="text" class="form-input" id="newBizTyNm" name="bizTyNm"
                                                   placeholder="예: 승강기 유지보수" required>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label" for="newBizrno">사업자등록번호<span class="required">*</span></label>
                                            <input type="text" class="form-input" id="newBizrno" name="bizrno"
                                                   placeholder="000-00-00000" maxlength="12" required>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label" for="newPicNm">담당자명</label>
                                            <input type="text" class="form-input" id="newPicNm" name="picNm"
                                                   placeholder="예: 홍길동">
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label" for="newPicTelno">담당자 연락처</label>
                                            <input type="text" class="form-input" id="newPicTelno" name="picTelno"
                                                   placeholder="010-0000-0000">
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label" for="newPicEmail">담당자 이메일</label>
                                            <input type="email" class="form-input" id="newPicEmail" name="picEmail"
                                                   placeholder="example@company.com">
                                        </div>
                                    </div>

                                    <div class="partner-guide">
                                        <span class="material-symbols-rounded">info</span>
                                        <span>
                                            협력업체 등록 후 계약 등록 폼으로 돌아옵니다.
                                            돌아온 뒤 협력업체 목록에서 방금 등록한 업체를 선택하세요.
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn" id="cancelPartnerRegisterModalBtn">취소</button>
                                <button type="submit" class="btn btn-primary">
                                    <span class="material-symbols-rounded">save</span>
                                    협력업체 등록
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

            </div><!-- /contractFormPage -->
        </main>
    </div>
</div>

<script src="${ctx}/js/manager/manager-common.js"></script>
<script>
    (function () {
        'use strict';

        /* ============================================================
           계약 폼 설정값
           - office는 IManagerModelService.addManagerViewModel에서 내려주는 공통 model 값
           - CSV 식별키 자동생성에 단지번호를 사용
        ============================================================ */
        var contractFormConfig = {
            aptCmplexNo: '${not empty office.aptCmplexNo ? office.aptCmplexNo : contract.aptCmplexNo}',
            isTerminateMode: ${isTerminateMode ? 'true' : 'false'}
        };

        /* ============================================================
           계약 등록/수정 공용 폼 스크립트
           - 대상구분에 따라 대상시설/검침설정 영역 표시
           - 협력업체 선택 시 담당자 요약 표시
           - 시설 체크박스 선택 결과 표시
        ============================================================ */

        document.addEventListener('DOMContentLoaded', function () {
            var targetSelect = document.getElementById('contTargetCd');
            var partnerSelect = document.getElementById('partnerNo');
            var partnerSearchInput = document.getElementById('partnerSearchInput');
            var partnerSearchList = document.getElementById('partnerSearchList');
            var facilitySearchInput = document.getElementById('facilitySearchInput');
            var contractForm = document.getElementById('contractForm');
            var partnerRegisterOpenBtn = document.getElementById('openPartnerRegisterModalBtn');
            var partnerRegisterCloseBtn = document.getElementById('closePartnerRegisterModalBtn');
            var partnerRegisterCancelBtn = document.getElementById('cancelPartnerRegisterModalBtn');
            var partnerRegisterModal = document.getElementById('contractPartnerRegisterModal');
            var makeCsvKeyBtn = document.getElementById('makeCsvKeyBtn');
            var contractFilesInput = document.getElementById('contractFiles');

            /* 대상구분 변경 이벤트 */
            if (targetSelect) {
                targetSelect.addEventListener('change', toggleTargetPanels);

                /* 계약유형 변경 이벤트 */
                var contTyCdSelect = document.getElementById('contTyCd');
                if (contTyCdSelect) {
                    contTyCdSelect.addEventListener('change', toggleTargetPanels);
                }
            }

            /* 협력업체 검색/선택 이벤트 */
            if (partnerSelect) {
                partnerSelect.addEventListener('change', function () {
                    syncPartnerSearchInput();
                    updatePartnerSummary();
                });
            }

            if (partnerSearchInput) {
                partnerSearchInput.addEventListener('input', filterPartnerChoices);
                partnerSearchInput.addEventListener('focus', filterPartnerChoices);
                partnerSearchInput.addEventListener('keydown', handlePartnerSearchKeydown);
            }

            if (partnerSearchList) {
                partnerSearchList.addEventListener('mousedown', selectPartnerFromSearch);
            }

            document.addEventListener('click', closePartnerSearchListByOutsideClick);

            /* 시설 검색 이벤트 */
            if (facilitySearchInput) {
                facilitySearchInput.addEventListener('input', filterFacilityChoices);
            }

            /* 시설 선택 이벤트 */
            document.addEventListener('change', function (event) {
                if (event.target && event.target.name === 'targetFacilityNoList') {
                    renderSelectedFacilities();
                }
            });

            /* CSV 식별키 자동생성 버튼 */
            if (makeCsvKeyBtn) {
                makeCsvKeyBtn.addEventListener('click', makeCsvIdntfKey);
            }

            /* 새 첨부파일 선택 목록 표시 */
            if (contractFilesInput) {
                contractFilesInput.addEventListener('change', renderSelectedContractFiles);
                renderSelectedContractFiles();
            }

            /* 저장 전 최소 검증 */
            if (contractForm) {
                contractForm.addEventListener('submit', validateBeforeSubmit);
            }

            /* 신규 협력업체 등록 모달 열기 */
            if (partnerRegisterOpenBtn) {
                partnerRegisterOpenBtn.addEventListener('click', openPartnerRegisterModal);
            }

            /* 신규 협력업체 등록 모달 닫기 */
            if (partnerRegisterCloseBtn) {
                partnerRegisterCloseBtn.addEventListener('click', closePartnerRegisterModal);
            }

            if (partnerRegisterCancelBtn) {
                partnerRegisterCancelBtn.addEventListener('click', closePartnerRegisterModal);
            }

            if (partnerRegisterModal) {
                partnerRegisterModal.addEventListener('click', function (event) {
                    if (event.target === partnerRegisterModal) {
                        closePartnerRegisterModal();
                    }
                });
            }

            toggleTargetPanels();
            syncPartnerSearchInput();
            updatePartnerSummary();
            renderSelectedFacilities();
            applyTerminateMode();
        });

        /* ============================================================
           해지 모드 화면 잠금
           - disabled는 제출값이 빠질 수 있으므로 select/checkbox는 클릭만 막는다.
           - 계약내용/비고는 해지 사유 기록을 위해 수정 가능하게 둔다.
        ============================================================ */
        function applyTerminateMode() {
            if (!contractFormConfig.isTerminateMode) return;

            var statusSelect = document.getElementById('contSttsCd');
            var readonlyInputIds = [
                'contNm', 'contAmt', 'contDt', 'contBgngDt', 'contEndDt', 'pymtDt',
                'partnerSearchInput', 'partnerSummary', 'csvIdntfKey', 'extCustNo', 'utilityRmrkCn'
            ];
            var readonlySelectIds = ['contTyCd', 'contTargetCd', 'bidTyCd', 'contSttsCd', 'partnerNo', 'meterTyCd'];

            if (statusSelect) {
                statusSelect.value = 'TERM';
            }

            readonlyInputIds.forEach(function (id) {
                var element = document.getElementById(id);
                if (element) {
                    element.readOnly = true;
                    element.classList.add('readonly-control');
                }
            });

            readonlySelectIds.forEach(function (id) {
                var element = document.getElementById(id);
                if (element) {
                    element.classList.add('readonly-control');
                    element.addEventListener('mousedown', preventReadonlyChange);
                    element.addEventListener('keydown', preventReadonlyChange);
                }
            });

            document.querySelectorAll('input[name="targetFacilityNoList"]').forEach(function (checkbox) {
                checkbox.classList.add('readonly-choice');
                checkbox.addEventListener('click', preventReadonlyChange);
            });

            document.querySelectorAll('input[name="deleteFileSaveUuidList"]').forEach(function (checkbox) {
                checkbox.disabled = true;
            });

            var contractFiles = document.getElementById('contractFiles');
            if (contractFiles) {
                contractFiles.disabled = true;
                contractFiles.classList.add('readonly-control');
            }

            var makeCsvKeyBtn = document.getElementById('makeCsvKeyBtn');
            if (makeCsvKeyBtn) {
                makeCsvKeyBtn.disabled = true;
            }

            var partnerRegisterBtn = document.getElementById('openPartnerRegisterModalBtn');
            if (partnerRegisterBtn) {
                partnerRegisterBtn.disabled = true;
            }
        }

        function preventReadonlyChange(event) {
            event.preventDefault();
            event.stopPropagation();

            if (event.currentTarget && typeof event.currentTarget.blur === 'function') {
                event.currentTarget.blur();
            }
        }

        /* ============================================================
           CSV 식별키 자동생성
           - 검침 계약 저장 시 UTILITY_PROVIDER.CSV_IDNTF_KEY로 저장될 값
           - 협력업체번호가 아니라 검침 종류(METER_TY_CD)를 기준으로 만든다.
           - 규칙: CSV_단지번호_검침종류
        ============================================================ */
        function makeCsvIdntfKey() {
            var meterTySelect = document.getElementById('meterTyCd');
            var csvInput = document.getElementById('csvIdntfKey');
            var extCustInput = document.getElementById('extCustNo');

            if (!meterTySelect || !csvInput) return;

            if (!meterTySelect.value) {
                alertMessage('CSV 식별키를 만들려면 검침 종류를 먼저 선택하세요.');
                meterTySelect.focus();
                return;
            }

            var aptCmplexNo = contractFormConfig.aptCmplexNo || 'APT';
            var meterTyCd = meterTySelect.value;

            // 검침 종류 기준 CSV 식별키 생성
            csvInput.value = 'CSV_' + aptCmplexNo + '_' + meterTyCd;

            // 외부 고객번호가 비어 있으면 같은 기준으로 자동 보조값을 채운다.
            if (extCustInput && !extCustInput.value.trim()) {
                extCustInput.value = 'CUST-' + aptCmplexNo + '-' + meterTyCd;
            }
        }

        /* ============================================================
           협력업체 검색 선택
           - 서버 추가 조회 없이 JSP에 내려온 partner option을 기준으로 필터링한다.
           - 사용자가 결과를 클릭하면 실제 제출값인 partnerNo select 값이 세팅된다.
        ============================================================ */
        function getPartnerOptions() {
            var select = document.getElementById('partnerNo');

            if (!select) return [];

            return Array.prototype.slice.call(select.options || []).filter(function (option) {
                return !!option.value;
            });
        }

        function syncPartnerSearchInput() {
            var select = document.getElementById('partnerNo');
            var input = document.getElementById('partnerSearchInput');

            if (!select || !input) return;

            var option = select.options[select.selectedIndex];

            if (!option || !option.value) {
                input.value = '';
                return;
            }

            input.value = getPartnerOptionLabel(option);
        }

        function filterPartnerChoices() {
            var input = document.getElementById('partnerSearchInput');
            var list = document.getElementById('partnerSearchList');

            if (!input || !list) return;

            var keyword = String(input.value || '').toLowerCase().trim();
            var options = getPartnerOptions();
            var matchedOptions = options.filter(function (option) {
                return getPartnerSearchText(option).indexOf(keyword) > -1;
            }).slice(0, 12);

            renderPartnerSearchList(matchedOptions, keyword);
        }

        function renderPartnerSearchList(options, keyword) {
            var list = document.getElementById('partnerSearchList');

            if (!list) return;

            if (options.length === 0) {
                list.innerHTML = '<div class="partner-search-empty">검색된 협력업체가 없습니다.</div>';
                list.classList.add('open');
                return;
            }

            var html = '';

            options.forEach(function (option, index) {
                var name = option.dataset.name || getPartnerOptionLabel(option);
                var biz = option.dataset.biz || '';
                var pic = option.dataset.pic || '';
                var tel = option.dataset.tel || '';
                var subText = [];

                if (biz) subText.push(biz);
                if (pic) subText.push('담당자 ' + pic);
                if (tel) subText.push(tel);

                html += '<button type="button" class="partner-search-row' + (index === 0 ? ' is-active' : '') + '" data-partner-value="' + escapeHtml(option.value) + '">';
                html += '    <span class="partner-search-main">' + escapeHtml(name) + '</span>';
                html += '    <span class="partner-search-sub">' + escapeHtml(subText.join(' / ') || '상세 정보 없음') + '</span>';
                html += '</button>';
            });

            list.innerHTML = html;
            list.classList.add('open');
        }

        function selectPartnerFromSearch(event) {
            var row = event.target.closest('.partner-search-row');

            if (!row) return;

            var select = document.getElementById('partnerNo');
            var list = document.getElementById('partnerSearchList');

            if (!select) return;

            select.value = row.dataset.partnerValue || '';
            syncPartnerSearchInput();
            updatePartnerSummary();

            if (list) {
                list.classList.remove('open');
            }
        }

        function handlePartnerSearchKeydown(event) {
            var list = document.getElementById('partnerSearchList');

            if (!list || !list.classList.contains('open')) return;

            var rows = Array.prototype.slice.call(list.querySelectorAll('.partner-search-row'));

            if (rows.length === 0) return;

            var activeIndex = rows.findIndex(function (row) {
                return row.classList.contains('is-active');
            });

            if (event.key === 'ArrowDown') {
                event.preventDefault();
                setActivePartnerSearchRow(rows, activeIndex + 1);
            }

            if (event.key === 'ArrowUp') {
                event.preventDefault();
                setActivePartnerSearchRow(rows, activeIndex - 1);
            }

            if (event.key === 'Enter') {
                event.preventDefault();
                rows[Math.max(activeIndex, 0)].dispatchEvent(new MouseEvent('mousedown', { bubbles: true }));
            }

            if (event.key === 'Escape') {
                list.classList.remove('open');
            }
        }

        function setActivePartnerSearchRow(rows, index) {
            var safeIndex = index;

            if (safeIndex < 0) safeIndex = rows.length - 1;
            if (safeIndex >= rows.length) safeIndex = 0;

            rows.forEach(function (row) {
                row.classList.remove('is-active');
            });

            rows[safeIndex].classList.add('is-active');
            rows[safeIndex].scrollIntoView({ block: 'nearest' });
        }

        function closePartnerSearchListByOutsideClick(event) {
            var wrap = event.target.closest('.partner-search-wrap');
            var list = document.getElementById('partnerSearchList');

            if (!wrap && list) {
                list.classList.remove('open');
            }
        }

        function getPartnerSearchText(option) {
            return [
                option.value,
                option.dataset.name,
                option.dataset.biz,
                option.dataset.pic,
                option.dataset.tel,
                option.textContent
            ].join(' ').toLowerCase();
        }

        function getPartnerOptionLabel(option) {
            return (option.dataset.name || String(option.textContent || '').trim()).trim();
        }

        /* ============================================================
           신규 협력업체 등록 모달 제어
        ============================================================ */
        function openPartnerRegisterModal() {
            if (typeof window.openModal === 'function') {
                window.openModal('contractPartnerRegisterModal');
                return;
            }

            var modal = document.getElementById('contractPartnerRegisterModal');
            if (modal) {
                modal.classList.add('open');
            }
        }

        function closePartnerRegisterModal() {
            if (typeof window.closeModal === 'function') {
                window.closeModal('contractPartnerRegisterModal');
            } else {
                var modal = document.getElementById('contractPartnerRegisterModal');
                if (modal) {
                    modal.classList.remove('open');
                }
            }

            var form = document.getElementById('contractPartnerRegisterForm');
            if (form) {
                form.reset();
            }
        }

        /* ============================================================
           대상구분별 패널 제어
        ============================================================ */
        function toggleTargetPanels() {
            var contTyCdSelect = document.getElementById('contTyCd');
            var targetSelect = document.getElementById('contTargetCd');
            var targetFacilityPanel = document.getElementById('targetFacilityPanel');
            var meterSettingPanel = document.getElementById('meterSettingPanel');
            var installGuidePanel = document.getElementById('installGuidePanel');

            if (!targetSelect) return;

            var contTyCd = contTyCdSelect ? contTyCdSelect.value : '';
            var targetValue = targetSelect.value;

            /* 일단 전부 숨긴 뒤 필요한 영역만 다시 연다. */
            if (targetFacilityPanel) targetFacilityPanel.classList.add('is-hidden');
            if (meterSettingPanel) meterSettingPanel.classList.add('is-hidden');
            if (installGuidePanel) installGuidePanel.classList.add('is-hidden');

            /* 해지 모드에서는 기존 계약의 대상구분을 변경하지 않는다. */
            if (contractFormConfig.isTerminateMode) {
                if (targetValue === 'FACILITY' && targetFacilityPanel) {
                    targetFacilityPanel.classList.remove('is-hidden');
                }
                if (targetValue === 'METER' && meterSettingPanel) {
                    meterSettingPanel.classList.remove('is-hidden');
                }
                return;
            }

            /* 설치공사: 대상 시설 선택 대신 안내만 표시한다. */
            if (contTyCd === 'INSTALL') {
                targetSelect.value = 'FACILITY';

                if (installGuidePanel) {
                    installGuidePanel.classList.remove('is-hidden');
                }

                return;
            }

            /* 검침: 검침 설정을 바로 입력할 수 있게 대상구분을 검침으로 맞춘다. */
            if (contTyCd === 'METER') {
                targetSelect.value = 'METER';
                targetValue = 'METER';
            }

            /* 유지보수/보수공사: 기존 시설을 대상으로 보는 흐름이다. */
            if (contTyCd === 'MAINT' || contTyCd === 'REPAIR') {
                targetSelect.value = 'FACILITY';
                targetValue = 'FACILITY';
            }

            /* 용역/기타는 강제로 숨기지 않고 대상구분 선택값을 그대로 따른다. */
            if (targetValue === 'FACILITY' && targetFacilityPanel) {
                targetFacilityPanel.classList.remove('is-hidden');
            }

            if (targetValue === 'METER' && meterSettingPanel) {
                meterSettingPanel.classList.remove('is-hidden');
            }
        }

        /* ============================================================
           협력업체 요약 표시
        ============================================================ */
        function updatePartnerSummary() {
            var select = document.getElementById('partnerNo');
            var summary = document.getElementById('partnerSummary');

            if (!select || !summary) return;

            var option = select.options[select.selectedIndex];

            if (!option || !option.value) {
                summary.value = '';
                return;
            }

            var biz = option.dataset.biz || '';
            var pic = option.dataset.pic || '';
            var tel = option.dataset.tel || '';

            summary.value = biz
                + (pic ? ' / 담당자 ' + pic : '')
                + (tel ? ' / ' + tel : '');
        }

        /* ============================================================
           시설 검색
        ============================================================ */
        function filterFacilityChoices() {
            var input = document.getElementById('facilitySearchInput');
            var keyword = input ? String(input.value || '').toLowerCase() : '';

            document.querySelectorAll('[data-facility-row]').forEach(function (row) {
                var text = row.dataset.searchText || '';
                row.style.display = text.indexOf(keyword) > -1 ? '' : 'none';
            });
        }

        /* ============================================================
           선택된 시설 표시
        ============================================================ */
        function renderSelectedFacilities() {
            var box = document.getElementById('selectedFacilityList');

            if (!box) return;

            var checkedList = document.querySelectorAll('input[name="targetFacilityNoList"]:checked');

            if (checkedList.length === 0) {
                var contTyCdSelect = document.getElementById('contTyCd');

                if (contTyCdSelect && contTyCdSelect.value === 'INSTALL') {
                    box.innerHTML = '<div class="empty-row">설치공사는 시설 등록 후 연결할 수 있습니다.</div>';
                } else {
                    box.innerHTML = '<div class="empty-row">선택된 시설이 없습니다.</div>';
                }

                return;
            }

            var html = '';

            checkedList.forEach(function (input) {
                var row = input.closest('[data-facility-row]');
                var main = row ? row.querySelector('.choice-main') : null;
                var sub = row ? row.querySelector('.choice-sub') : null;

                html += '<div class="choice-row">';
                html += '    <span>';
                html += '        <span class="choice-main">' + escapeHtml(main ? main.textContent : input.value) + '</span>';
                html += '        <span class="choice-sub">' + escapeHtml(sub ? sub.textContent : input.value) + '</span>';
                html += '    </span>';
                html += '</div>';
            });

            box.innerHTML = html;
        }

        /* ============================================================
           새 첨부파일 선택 목록 표시
           - 브라우저 기본 파일 input은 선택 파일명을 한 줄로만 보여준다.
           - 여러 파일 선택 시 사용자가 확인할 수 있도록 파일명/크기/유형을 별도 목록으로 표시한다.
        ============================================================ */
        function renderSelectedContractFiles() {
            var input = document.getElementById('contractFiles');
            var box = document.getElementById('selectedContractFileList');

            if (!input || !box) return;

            var files = Array.prototype.slice.call(input.files || []);

            if (files.length === 0) {
                box.classList.add('is-hidden');
                box.innerHTML = '';
                return;
            }

            var html = '';

            files.forEach(function (file) {
                var ext = getSelectedFileExt(file.name);

                html += '<div class="selected-file-row">';
                html += '    <div class="selected-file-name">' + escapeHtml(file.name) + '</div>';
                html += '    <div class="selected-file-meta">' + formatFileSize(file.size) + '</div>';
                html += '    <div class="selected-file-meta">' + escapeHtml(ext ? ext.toUpperCase() : '-') + '</div>';
                html += '</div>';
            });

            box.innerHTML = html;
            box.classList.remove('is-hidden');
        }

        function getSelectedFileExt(fileName) {
            if (!fileName || fileName.indexOf('.') === -1) return '';
            return fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
        }

        function formatFileSize(value) {
            var size = Number(value || 0);

            if (size >= 1024 * 1024) {
                return (size / 1024 / 1024).toFixed(1) + 'MB';
            }

            if (size >= 1024) {
                return (size / 1024).toFixed(1) + 'KB';
            }

            return size + 'B';
        }

        /* ============================================================
           저장 전 검증
        ============================================================ */
        function validateBeforeSubmit(event) {
            var targetSelect = document.getElementById('contTargetCd');
            var contNm = document.getElementById('contNm');
            var partnerNo = document.getElementById('partnerNo');
            var contAmt = document.getElementById('contAmt');
            var contBgngDt = document.getElementById('contBgngDt');

            if (contractFormConfig.isTerminateMode) {
                var statusSelect = document.getElementById('contSttsCd');
                var contCn = document.getElementById('contCn');
                var rmrkCn = document.getElementById('rmrkCn');

                if (statusSelect) {
                    statusSelect.value = 'TERM';
                }

                if ((!contCn || !contCn.value.trim()) && (!rmrkCn || !rmrkCn.value.trim())) {
                    alertMessage('해지 사유나 해지 메모를 입력하세요.');
                    if (rmrkCn) {
                        rmrkCn.focus();
                    }
                    event.preventDefault();
                    return;
                }
            }

            if (!contNm || !contNm.value.trim()) {
                alertMessage('계약명을 입력하세요.');
                contNm.focus();
                event.preventDefault();
                return;
            }

            if (!partnerNo || !partnerNo.value) {
                var partnerSearchInput = document.getElementById('partnerSearchInput');

                alertMessage('협력업체를 선택하세요.');

                if (partnerSearchInput) {
                    partnerSearchInput.focus();
                } else if (partnerNo) {
                    partnerNo.focus();
                }

                event.preventDefault();
                return;
            }

            if (!contAmt || !contAmt.value) {
                alertMessage('계약금액을 입력하세요.');
                contAmt.focus();
                event.preventDefault();
                return;
            }

            if (!contBgngDt || !contBgngDt.value) {
                alertMessage('계약시작일을 입력하세요.');
                contBgngDt.focus();
                event.preventDefault();
                return;
            }

            if (targetSelect && targetSelect.value === 'METER') {
                var meterTyCd = document.getElementById('meterTyCd');
                var csvIdntfKey = document.getElementById('csvIdntfKey');

                if (!meterTyCd || !meterTyCd.value) {
                    alertMessage('검침 계약은 검침 종류를 선택해야 합니다.');
                    if (meterTyCd) {
                        meterTyCd.focus();
                    }
                    event.preventDefault();
                    return;
                }

                if (!csvIdntfKey || !csvIdntfKey.value.trim()) {
                    alertMessage('검침 계약은 CSV 식별키를 입력해야 합니다.');
                    csvIdntfKey.focus();
                    event.preventDefault();
                    return;
                }
            }

            if (targetSelect && targetSelect.value === 'FACILITY') {
                var checkedList = document.querySelectorAll('input[name="targetFacilityNoList"]:checked');
                var contTyCdSelect = document.getElementById('contTyCd');
                var isInstallContract = contTyCdSelect && contTyCdSelect.value === 'INSTALL';

                if (!isInstallContract && checkedList.length === 0) {
                    alertMessage('대상 시설을 하나 이상 선택하세요.');
                    event.preventDefault();
                    return;
                }
            }
        }

        /* ============================================================
           보조 함수
        ============================================================ */
        function alertMessage(message) {
            if (typeof window.showAlert === 'function') {
                window.showAlert(message);
                return;
            }

            alert(message);
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
