<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<%--
    계약 등록/수정 공용 폼
    - mode 값 기준으로 등록/수정 구분
    - 등록: mode = insert
    - 수정: mode = update
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

        /* ── 폼 ── */
        #contractFormPage .form-grid {
            display:grid;
            grid-template-columns:repeat(4,minmax(0,1fr));
            gap:12px 14px;
        }
        #contractFormPage .form-grid.cols-2 { grid-template-columns:repeat(2,minmax(0,1fr)); }
        #contractFormPage .form-field { display:flex; flex-direction:column; gap:5px; min-width:0; }
        #contractFormPage .form-field.full { grid-column:1 / -1; }
        #contractFormPage .form-field.half { grid-column:span 2; }
        #contractFormPage .field-label {
            display:block;
            font-size:11px; font-weight:800; color:var(--text-sec);
        }
        #contractFormPage .required { color:#dc2626; margin-left:2px; }
        #contractFormPage .field-help { font-size:11px; color:var(--text-ter); line-height:1.45; margin-top:2px; }

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

        /* ── 협력업체 선택 + 신규 등록 버튼 ── */
        #contractFormPage .partner-select-row {
            display:grid;
            grid-template-columns:minmax(0,1fr) auto;
            gap:7px;
            align-items:center;
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
            grid-template-columns:1fr 110px 82px;
            align-items:center;
            min-height:40px;
            padding:0 10px;
            border-bottom:1px solid #eef1f3;
            font-size:12px;
        }
        #contractFormPage .file-row:last-child { border-bottom:none; }
        #contractFormPage .file-name { font-weight:700; color:#1f2d23; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #contractFormPage .file-meta { color:#66736a; font-size:11px; text-align:center; }

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
            #contractFormPage .form-grid { grid-template-columns:repeat(2,minmax(0,1fr)); }
            #contractFormPage .choice-layout { grid-template-columns:1fr; }
        }
        @media(max-width:760px) {
            #contractFormPage .form-grid,
            #contractFormPage .form-grid.cols-2 { grid-template-columns:1fr; }
            #contractFormPage .form-field.half { grid-column:1; }
            #contractFormPage .page-header { flex-direction:column; align-items:flex-start; gap:8px; }
            #contractFormPage .form-actions { justify-content:flex-start; flex-wrap:wrap; }
        }
    </style>
</head>

<body>

<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/facility/contract/list/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="${mode eq 'update' ? '계약 수정' : '계약 등록'}" />

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
                                <c:when test="${mode eq 'update'}">계약 수정</c:when>
                                <c:otherwise>계약 등록</c:otherwise>
                            </c:choose>
                        </h2>
                        <p>협력업체 계약 기본정보, 대상 시설, 검침 설정, 계약서 파일을 등록합니다.</p>
                    </div>

                    <div class="page-actions">
                        <a class="btn" href="${ctx}/manager/facility/contract/list/${mgmtOfcNo}">
                            <span class="material-symbols-rounded">arrow_back</span>목록
                        </a>
                    </div>
                </div>

                <form id="contractForm"
                      method="post"
                      enctype="multipart/form-data"
                      action="${ctx}/manager/facility/contract/${mode eq 'update' ? 'update' : 'insert'}/${mgmtOfcNo}">
                    <sec:csrfInput/>

                    <%-- 수정 시 계약번호와 파일그룹번호 유지 --%>
                    <input type="hidden" name="contNo" value="${contract.contNo}">
                    <input type="hidden" name="fileGroupNo" value="${contract.fileGroupNo}">
                    <input type="hidden" id="formMode" value="${empty mode ? 'insert' : mode}">

                    <%-- 계약 기본정보 --%>
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">description</span>계약 기본정보</h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-grid">
                                <c:if test="${mode eq 'update'}">
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
                                        <option value="">선택</option>
                                        <option value="MAINT"   <c:if test="${contract.contTyCd eq 'MAINT'}">selected</c:if>>유지보수</option>
                                        <option value="REPAIR"  <c:if test="${contract.contTyCd eq 'REPAIR'}">selected</c:if>>보수공사</option>
                                        <option value="INSTALL" <c:if test="${contract.contTyCd eq 'INSTALL'}">selected</c:if>>설치공사</option>
                                        <option value="SERVICE" <c:if test="${contract.contTyCd eq 'SERVICE'}">selected</c:if>>용역</option>
                                        <option value="METER"   <c:if test="${contract.contTyCd eq 'METER'}">selected</c:if>>검침</option>
                                        <option value="ETC"     <c:if test="${contract.contTyCd eq 'ETC'}">selected</c:if>>기타</option>
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
                                        <option value="PRIVATE"   <c:if test="${empty contract.bidTyCd or contract.bidTyCd eq 'PRIVATE'}">selected</c:if>>수의계약</option>
                                        <option value="OPEN"      <c:if test="${contract.bidTyCd eq 'OPEN'}">selected</c:if>>일반경쟁</option>
                                        <option value="LIMIT"     <c:if test="${contract.bidTyCd eq 'LIMIT'}">selected</c:if>>제한경쟁</option>
                                        <option value="DESIGNATE" <c:if test="${contract.bidTyCd eq 'DESIGNATE'}">selected</c:if>>지명경쟁</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="contSttsCd">계약상태</label>
                                    <select class="form-select" id="contSttsCd" name="contSttsCd">
                                        <option value="ING"  <c:if test="${empty contract.contSttsCd or contract.contSttsCd eq 'ING'}">selected</c:if>>진행중</option>
                                        <option value="EXP"  <c:if test="${contract.contSttsCd eq 'EXP'}">selected</c:if>>만료</option>
                                        <option value="CNL"  <c:if test="${contract.contSttsCd eq 'CNL'}">selected</c:if>>해지</option>
                                        <option value="WAIT" <c:if test="${contract.contSttsCd eq 'WAIT'}">selected</c:if>>대기</option>
                                    </select>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="contAmt">계약금액<span class="required">*</span></label>
                                    <input type="number" class="form-input" id="contAmt" name="contAmt"
                                           value="${contract.contAmt}" min="0" placeholder="숫자만 입력" required>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="contDt">계약일자</label>
                                    <input type="date" class="form-input" id="contDt" name="contDt" value="${contract.contDt}">
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="contBgngDt">계약시작일<span class="required">*</span></label>
                                    <input type="date" class="form-input" id="contBgngDt" name="contBgngDt" value="${contract.contBgngDt}" required>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="contEndDt">계약종료일</label>
                                    <input type="date" class="form-input" id="contEndDt" name="contEndDt" value="${contract.contEndDt}">
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="pymtDt">지급예정일</label>
                                    <input type="date" class="form-input" id="pymtDt" name="pymtDt" value="${contract.pymtDt}">
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- 협력업체 --%>
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">business</span>협력업체</h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-grid cols-2">
                                <div class="form-field">
                                    <label class="field-label" for="partnerNo">협력업체<span class="required">*</span></label>
                                    <div class="partner-select-row">
                                        <select class="form-select" id="partnerNo" name="partnerNo" required>
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

                                            <%-- 화면 확인용 샘플 : DB 연결 후 제거 가능 --%>
                                            <c:if test="${empty partnerList}">
                                                <option value="PTR3002" data-name="SH승강기관리" data-biz="승강기 유지보수" data-pic="김현우" data-tel="010-3002-3002" <c:if test="${empty contract.partnerNo or contract.partnerNo eq 'PTR3002'}">selected</c:if>>SH승강기관리 (승강기 유지보수)</option>
                                                <option value="PTR3003" data-name="SH성산 설비검침대행" data-biz="전기·수도·가스 검침" data-pic="박검침" data-tel="010-3003-3003" <c:if test="${contract.partnerNo eq 'PTR3003'}">selected</c:if>>SH성산 설비검침대행 (전기·수도·가스 검침)</option>
                                            </c:if>
                                        </select>

                                        <button type="button" class="btn" id="openPartnerRegisterModalBtn">
                                            <span class="material-symbols-rounded">add_business</span>
                                            신규 업체
                                        </button>
                                    </div>

                                    <div class="partner-guide">
                                        <span class="material-symbols-rounded">info</span>
                                        <span>
                                            계약 대상 업체가 목록에 없으면 신규 협력업체를 등록한 뒤 다시 선택하세요.
                                            등록 후 계약 폼으로 돌아오며, 작성 중인 계약 내용은 저장되지 않으니 업체 등록을 먼저 진행하는 것을 권장합니다.
                                        </span>
                                    </div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label">선택 업체 정보</label>
                                    <input type="text" class="form-input" id="partnerSummary" readonly placeholder="협력업체를 선택하면 담당자 정보가 표시됩니다.">
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

                                        <%-- 화면 확인용 샘플 : DB 연결 후 제거 가능 --%>
                                        <c:if test="${empty facilityList}">
                                            <label class="choice-row" data-facility-row data-search-text="fac1001 1호기 승강기 elv 101동 승강기홀">
                                                <input type="checkbox" name="targetFacilityNoList" value="FAC1001" checked>
                                                <span>
                                                    <span class="choice-main">1호기 승강기</span>
                                                    <span class="choice-sub">FAC1001 · ELV · 101동 승강기홀</span>
                                                </span>
                                            </label>
                                            <label class="choice-row" data-facility-row data-search-text="fac3001 2호기 승강기 elv 102동 승강기홀">
                                                <input type="checkbox" name="targetFacilityNoList" value="FAC3001">
                                                <span>
                                                    <span class="choice-main">2호기 승강기</span>
                                                    <span class="choice-sub">FAC3001 · ELV · 102동 승강기홀</span>
                                                </span>
                                            </label>
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

                    <%-- 검침 설정 : 대상구분이 검침일 때 UTILITY_PROVIDER 생성/수정용 --%>
                    <div class="panel is-hidden" id="meterSettingPanel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">electric_meter</span>검침 설정</h3>
                        </div>

                        <div class="panel-body">
                            <input type="hidden" name="utilityProviderNo" value="${contract.utilityProviderNo}">

                            <div class="form-grid cols-2">
                                <div class="form-field">
                                    <label class="field-label" for="csvIdntfKey">CSV 식별키</label>
                                    <div class="partner-select-row">
                                        <input type="text" class="form-input" id="csvIdntfKey" name="csvIdntfKey"
                                               value="${fn:escapeXml(contract.csvIdntfKey)}"
                                               placeholder="예: CSV_A10023118_PTR3003">
                                        <button type="button" class="btn" id="makeCsvKeyBtn">자동생성</button>
                                    </div>
                                    <div class="field-help">검침 CSV 업로드 시 공급/검침 설정을 식별하는 값입니다. 자동생성 규칙은 CSV_단지번호_협력업체번호입니다.</div>
                                </div>

                                <div class="form-field">
                                    <label class="field-label" for="extCustNo">외부 고객번호</label>
                                    <input type="text" class="form-input" id="extCustNo" name="extCustNo"
                                           value="${fn:escapeXml(contract.extCustNo)}"
                                           placeholder="예: CUST-A12185003-003">
                                    <div class="field-help">한전/수도/가스 공급기관 또는 대행업체 고객번호입니다.</div>
                                </div>

                                <div class="form-field full">
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
                            <div class="form-grid">
                                <div class="form-field full">
                                    <label class="field-label" for="contCn">계약내용</label>
                                    <textarea class="form-textarea" id="contCn" name="contCn"
                                              placeholder="계약 범위, 주요 조건, 작업 내용을 입력하세요.">${fn:escapeXml(contract.contCn)}</textarea>
                                </div>

                                <div class="form-field full">
                                    <label class="field-label" for="rmrkCn">비고</label>
                                    <textarea class="form-textarea" id="rmrkCn" name="rmrkCn"
                                              placeholder="내부 참고사항을 입력하세요.">${fn:escapeXml(contract.rmrkCn)}</textarea>
                                </div>
                            </div>
                        </div>
                    </div>

                    <%-- 계약서 첨부파일 --%>
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title"><span class="material-symbols-rounded">attach_file</span>계약서 첨부파일</h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-grid">
                                <div class="form-field full">
                                    <label class="field-label" for="contractFiles">계약서 파일</label>
                                    <input type="file" class="form-input" id="contractFiles" name="contractFiles" multiple>
                                    <div class="field-help">계약서, 견적서, 산출내역서 등 계약 관련 파일을 첨부합니다. FACILITY_CONTRACT.FILE_GROUP_NO 기준으로 저장합니다.</div>
                                </div>

                                <c:if test="${mode eq 'update'}">
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
                                                            <div class="file-meta">
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

                    <%-- 저장 버튼 --%>
                    <div class="form-actions">
                        <a href="${ctx}/manager/facility/contract/list/${mgmtOfcNo}" class="btn">취소</a>
                        <button type="submit" class="btn btn-primary">
                            <span class="material-symbols-rounded">save</span>
                            <c:choose>
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
            aptCmplexNo: '${not empty office.aptCmplexNo ? office.aptCmplexNo : contract.aptCmplexNo}'
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
            var facilitySearchInput = document.getElementById('facilitySearchInput');
            var contractForm = document.getElementById('contractForm');
            var partnerRegisterOpenBtn = document.getElementById('openPartnerRegisterModalBtn');
            var partnerRegisterCloseBtn = document.getElementById('closePartnerRegisterModalBtn');
            var partnerRegisterCancelBtn = document.getElementById('cancelPartnerRegisterModalBtn');
            var partnerRegisterModal = document.getElementById('contractPartnerRegisterModal');
            var makeCsvKeyBtn = document.getElementById('makeCsvKeyBtn');

            /* 대상구분 변경 이벤트 */
            if (targetSelect) {
                targetSelect.addEventListener('change', toggleTargetPanels);

                /* 계약유형 변경 이벤트 */
                var contTyCdSelect = document.getElementById('contTyCd');
                if (contTyCdSelect) {
                    contTyCdSelect.addEventListener('change', toggleTargetPanels);
                }
            }

            /* 협력업체 변경 이벤트 */
            if (partnerSelect) {
                partnerSelect.addEventListener('change', updatePartnerSummary);
            }

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
            updatePartnerSummary();
            renderSelectedFacilities();
        });

        /* ============================================================
           CSV 식별키 자동생성
           - 검침 계약 저장 시 UTILITY_PROVIDER.CSV_IDNTF_KEY로 저장될 값
           - 규칙: CSV_단지번호_협력업체번호
        ============================================================ */
        function makeCsvIdntfKey() {
            var partnerSelect = document.getElementById('partnerNo');
            var csvInput = document.getElementById('csvIdntfKey');

            if (!partnerSelect || !csvInput) return;

            if (!partnerSelect.value) {
                alertMessage('CSV 식별키를 만들려면 협력업체를 먼저 선택하세요.');
                partnerSelect.focus();
                return;
            }

            var aptCmplexNo = contractFormConfig.aptCmplexNo || 'APT';
            var partnerNo = partnerSelect.value;

            csvInput.value = 'CSV_' + aptCmplexNo + '_' + partnerNo;
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
            var contTyCdSelect  = document.getElementById('contTyCd');
            var targetSelect    = document.getElementById('contTargetCd');
            var targetFacilityPanel = document.getElementById('targetFacilityPanel');
            var meterSettingPanel   = document.getElementById('meterSettingPanel');

            if (!targetSelect) return;

            /* 계약유형이 검침이면 대상구분 자동 고정 */
            if (contTyCdSelect && contTyCdSelect.value === 'METER') {
                targetSelect.value    = 'METER';
                targetSelect.disabled = true;
            } else {
                targetSelect.disabled = false;
            }

            var targetValue = targetSelect.value;

            if (targetFacilityPanel) {
                if (targetValue === 'FACILITY') {
                    targetFacilityPanel.classList.remove('is-hidden');
                } else {
                    targetFacilityPanel.classList.add('is-hidden');
                }
            }

            if (meterSettingPanel) {
                if (targetValue === 'METER') {
                    meterSettingPanel.classList.remove('is-hidden');
                } else {
                    meterSettingPanel.classList.add('is-hidden');
                }
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
                box.innerHTML = '<div class="empty-row">선택된 시설이 없습니다.</div>';
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
           저장 전 검증
        ============================================================ */
        function validateBeforeSubmit(event) {
            var targetSelect = document.getElementById('contTargetCd');
            var contNm = document.getElementById('contNm');
            var partnerNo = document.getElementById('partnerNo');
            var contAmt = document.getElementById('contAmt');
            var contBgngDt = document.getElementById('contBgngDt');

            if (!contNm || !contNm.value.trim()) {
                alertMessage('계약명을 입력하세요.');
                contNm.focus();
                event.preventDefault();
                return;
            }

            if (!partnerNo || !partnerNo.value) {
                alertMessage('협력업체를 선택하세요.');
                partnerNo.focus();
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
                var csvIdntfKey = document.getElementById('csvIdntfKey');

                if (!csvIdntfKey || !csvIdntfKey.value.trim()) {
                    alertMessage('검침 계약은 CSV 식별키를 입력해야 합니다.');
                    csvIdntfKey.focus();
                    event.preventDefault();
                    return;
                }
            }

            if (targetSelect && targetSelect.value === 'FACILITY') {
                var checkedList = document.querySelectorAll('input[name="targetFacilityNoList"]:checked');

                if (checkedList.length === 0) {
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
