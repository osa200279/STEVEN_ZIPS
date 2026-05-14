<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설(공용) 상세</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #publicFacilityDetailPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb;
            --line:#d7dce2; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
        }
        #publicFacilityDetailPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityDetailPage .page-title-block p  { color:var(--text-sec); font-size:12px; }

        /* 패널 */
        #publicFacilityDetailPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityDetailPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityDetailPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityDetailPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityDetailPage .panel-body { padding:14px 16px 16px; background:var(--surface); }

        /* readonly 필드 */
        #publicFacilityDetailPage .form-input[readonly],
        #publicFacilityDetailPage .form-textarea[readonly] {
            font-size:12px; border-color:var(--line);
            background:var(--surface-sub); color:var(--text-pri);
            border-radius:4px; opacity:1; cursor:default;
        }
        #publicFacilityDetailPage .form-input[readonly] { height:32px; }
        #publicFacilityDetailPage .form-textarea[readonly] { resize:none; }

        /* 버튼 */
        #publicFacilityDetailPage .btn { border-radius:4px; }
        #publicFacilityDetailPage .btn-primary   { background:var(--accent); border-color:var(--accent); }
        #publicFacilityDetailPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityDetailPage .btn-danger    { background:#ef4444; border-color:#ef4444; color:#fff; }
        #publicFacilityDetailPage .btn-danger:hover { background:#dc2626; border-color:#dc2626; }

        /* 섹션 타이틀 */
        .form-section-title { display:flex; align-items:center; gap:4px; font-size:11px; font-weight:800; color:var(--text-sec,#4a5c4e); letter-spacing:0; text-transform:none; margin-bottom:10px; }
        .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent,#2e5c38); }

        /* 2컬럼 레이아웃 */
        .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line,#d7dce2); }
        .facility-modal-col-right { padding-left:20px; }

        /* 배지 */
        #publicFacilityDetailPage .badge { display:inline-flex; align-items:center; padding:3px 9px; border-radius:999px; font-size:11px; font-weight:700; line-height:1.4; }
        #publicFacilityDetailPage .badge-use-y { background:#dceee0; color:#1f7a3f; }
        #publicFacilityDetailPage .badge-use-y::before { content:""; width:6px; height:6px; border-radius:50%; background:#22c55e; margin-right:5px; }
        #publicFacilityDetailPage .badge-use-n { background:#fee2e2; color:#b42318; }
        #publicFacilityDetailPage .badge-use-n::before { content:""; width:6px; height:6px; border-radius:50%; background:#ef4444; margin-right:5px; }

        /* 비활성 안내 */
        #publicFacilityDetailPage .disabled-notice {
            display:flex; align-items:flex-start; gap:10px;
            margin-bottom:14px; padding:11px 13px;
            border:1px solid #fed7aa; border-left:3px solid #f59e0b;
            border-radius:0 4px 4px 0; background:#fff7ed;
            color:#7c2d12; font-size:12px; line-height:1.6;
        }
        #publicFacilityDetailPage .disabled-notice .material-symbols-rounded { color:#f59e0b; font-size:18px; flex-shrink:0; margin-top:1px; }

        /* 시설자산 링크 */
        #publicFacilityDetailPage .facility-link {
            display:inline-flex; align-items:center; gap:3px;
            font-size:11px; font-weight:800; color:var(--accent);
            text-decoration:none; margin-left:auto;
        }
        #publicFacilityDetailPage .facility-link:hover { color:var(--accent-hover); }
        #publicFacilityDetailPage .facility-link .material-symbols-rounded { font-size:13px; }

        /* 사진 그리드 */
        #publicFacilityDetailPage .img-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; }
        #publicFacilityDetailPage .img-cell { aspect-ratio:4/3; border-radius:6px; overflow:hidden; border:1px solid var(--line); background:var(--surface-sub); display:flex; align-items:center; justify-content:center; }
        #publicFacilityDetailPage .img-cell img { width:100%; height:100%; object-fit:cover; cursor:zoom-in; }
        #publicFacilityDetailPage .img-empty { grid-column:1/-1; padding:20px 0; font-size:12px; color:var(--text-ter); text-align:center; }

        /* 공용아이템 테이블 */
        #publicFacilityDetailPage .item-table { width:100%; border-collapse:collapse; border-top:1px solid var(--line); margin-top:4px; }
        #publicFacilityDetailPage .item-table th { padding:8px 10px; border-bottom:1px solid var(--line); font-size:11px; font-weight:800; color:var(--text-ter); text-align:left; background:none; }
        #publicFacilityDetailPage .item-table td { padding:9px 10px; border-bottom:1px solid var(--line); font-size:12px; color:var(--text-pri); vertical-align:middle; }
        #publicFacilityDetailPage .item-table tbody tr:last-child td { border-bottom:none; }
        #publicFacilityDetailPage .item-table tbody tr { cursor:pointer; transition:background .1s; }
        #publicFacilityDetailPage .item-table tbody tr:hover { background:var(--surface-sub); }
        #publicFacilityDetailPage .item-empty { text-align:center; color:var(--text-ter); padding:16px 0; cursor:default !important; }

        /* 행 이동 화살표 */
        #publicFacilityDetailPage .item-arrow { color:var(--text-ter); font-size:16px; vertical-align:middle; }
        #publicFacilityDetailPage .item-table tbody tr:hover .item-arrow { color:var(--accent); }

        /* 아이템 상태 배지 */
        #publicFacilityDetailPage .stts-badge { display:inline-flex; align-items:center; padding:2px 8px; border-radius:999px; font-size:11px; font-weight:700; }
        #publicFacilityDetailPage .stts-open   { background:#dceee0; color:#1f7a3f; }
        #publicFacilityDetailPage .stts-use    { background:#dbeafe; color:#1e3a5f; }
        #publicFacilityDetailPage .stts-repair { background:#fef9c3; color:#854d0e; }
        #publicFacilityDetailPage .stts-close  { background:#fee2e2; color:#b42318; }


        /* 인라인 편집 */
        #publicFacilityDetailPage .item-table tr { cursor:default; }
        #publicFacilityDetailPage .item-table .item-input { height:28px; font-size:12px; border:1px solid var(--line); border-radius:4px; padding:0 8px; width:100%; box-sizing:border-box; }
        #publicFacilityDetailPage .item-table .item-input:focus { border-color:var(--accent); outline:none; }
        #publicFacilityDetailPage .item-table .item-select { height:28px; font-size:12px; border:1px solid var(--line); border-radius:4px; padding:0 6px; width:100%; box-sizing:border-box; }
        #publicFacilityDetailPage .item-table .item-select:focus { border-color:var(--accent); outline:none; }
        #publicFacilityDetailPage .row-btn { height:26px; padding:0 8px; font-size:11px; border-radius:4px; cursor:pointer; border:1px solid var(--line); background:#fff; color:var(--text-sec); }
        #publicFacilityDetailPage .row-btn:hover { border-color:var(--accent); color:var(--accent); }
        #publicFacilityDetailPage .row-btn-danger { border-color:#fca5a5; color:#b42318; }
        #publicFacilityDetailPage .row-btn-danger:hover { background:#fee2e2; }
        #publicFacilityDetailPage .row-btn-primary { border-color:var(--accent); background:var(--accent); color:#fff; }
        #publicFacilityDetailPage .row-btn-primary:hover { background:var(--accent-hover); }
        #publicFacilityDetailPage .item-add-btn { display:flex; align-items:center; justify-content:center; gap:4px; margin-top:8px; font-size:12px; color:var(--accent); background:none; border:1px dashed var(--accent); border-radius:4px; padding:5px 10px; cursor:pointer; width:100%; box-sizing:border-box; }
        #publicFacilityDetailPage .item-add-btn:hover { background:var(--accent-light); }

        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/publicFacility/list/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="편의시설(공용) 관리" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="publicFacilityDetailPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설(공용) 상세</h2>
                        <p>시설자산(FACILITY)과 편의시설(공용) 운영정보(PUBLIC_FACILITY)를 확인합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">info</span>
                            편의시설(공용) 정보
                        </h3>
                    </div>

                    <div class="panel-body">

                        <%-- 비활성 안내 --%>
                        <c:if test="${detail.useYn eq 'N'}">
                            <div class="disabled-notice">
                                <span class="material-symbols-rounded">warning</span>
                                <div>이 시설은 현재 <strong>비활성</strong> 상태입니다.</div>
                            </div>
                        </c:if>

                        <div class="facility-modal-cols">

                            <%-- 좌측: 시설자산 정보 + 공용시설 운영정보 + 시설 안내/비고 --%>
                            <div class="facility-modal-col-left">

                                <%-- 시설자산 정보 --%>
                                <div class="form-section" style="margin-bottom:14px;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">apartment</span>
                                        시설자산 정보
                                        <c:if test="${not empty detail.facilityNo}">
                                            <a href="${pageContext.request.contextPath}/manager/facility/detail-page/${mgmtOfcNo}/${detail.facilityNo}"
                                               class="facility-link">
                                                시설 상세
                                                <span class="material-symbols-rounded">arrow_forward</span>
                                            </a>
                                        </c:if>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">시설번호</label>
                                            <input type="text" class="form-input" value="${detail.facilityNo}" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">동</label>
                                            <input type="text" class="form-input" value="${empty detail.dongNo ? '공용' : detail.dongNo}" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">상세위치</label>
                                            <input type="text" class="form-input" value="${detail.locCn}" readonly>
                                        </div>
                                    </div>
                                </div>

                                <%-- 공용시설 운영정보 --%>
                                <div class="form-section" style="margin-bottom:14px;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">meeting_room</span>
                                        편의시설(공용) 운영정보
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">편의시설(공용)번호</label>
                                            <input type="text" class="form-input" value="${detail.cmnFacilityNo}" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">편의시설(공용)명</label>
                                            <input type="text" class="form-input" value="${detail.cmnFacilityNm}" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">예약 가능 여부</label>
                                            <input type="text" class="form-input"
                                                   value="${detail.cmnFacilityRsvYn eq 'Y' ? '예약제' : detail.cmnFacilityRsvYn eq 'N' ? '자유이용' : '-'}"
                                                   readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">이용요금</label>
                                            <input type="text" class="form-input"
                                                   value="${empty detail.cmnFacilityAmt or detail.cmnFacilityAmt == 0 ? '무료' : detail.cmnFacilityAmt}"
                                                   readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">운영시간</label>
                                            <input type="text" class="form-input" value="${detail.cmnFacilityOprHr}" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">등록일자</label>
                                            <input type="text" class="form-input"
                                                   value="${empty detail.regDt ? '-' : fn:substring(detail.regDt, 0, 10)}"
                                                   readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">수정일자</label>
                                            <input type="text" class="form-input"
                                                   value="${empty detail.mdfDt ? '-' : fn:substring(detail.mdfDt, 0, 10)}"
                                                   readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">활성여부</label>
                                            <div style="margin-top:5px;">
                                                <c:choose>
                                                    <c:when test="${detail.useYn eq 'N'}">
                                                        <span class="badge badge-use-n">비활성</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-use-y">활성</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 시설 안내/비고 --%>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">description</span>
                                        시설 안내/비고
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <textarea class="form-textarea" rows="4" readonly>${detail.cmnFacilityCn}</textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%-- 우측: 사진 + 공용아이템 목록 --%>
                            <div class="facility-modal-col-right">

                                <%-- 시설 사진 --%>
                                <div class="form-section" style="margin-bottom:14px;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">photo_library</span>
                                        시설 사진
                                    </div>
                                    <div class="img-grid" id="dtlImgGrid">
                                        <c:choose>
                                            <c:when test="${not empty fileList}">
                                                <c:forEach var="file" items="${fileList}">
                                                    <div class="img-cell">
                                                        <c:choose>
                                                            <c:when test="${not empty file.googleId}">
                                                                <img src="${pageContext.request.contextPath}/file/display/${file.googleId}"
                                                                     alt="${file.fileOgName}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="img-empty">이미지를 표시할 수 없습니다.</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="img-empty">등록된 사진이 없습니다.</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <%-- 편의시설 자원 목록 (인라인 편집) --%>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">inventory_2</span>
                                        편의시설 자원 목록
                                    </div>

                                    <table class="item-table">
                                        <colgroup>
                                            <col style="width:110px;">
                                            <col>
                                            <col style="width:120px;">
                                            <sec:authorize access="!hasRole('ADMIN')">
                                                <col style="width:130px;">
                                            </sec:authorize>
                                        </colgroup>
                                        <thead>
                                        <tr>
                                            <th>자원번호</th>
                                            <th style="text-align:left;padding-left:10px;">자원명</th>
                                            <th>상태</th>
                                            <sec:authorize access="!hasRole('ADMIN')">
                                                <th>관리</th>
                                            </sec:authorize>
                                        </tr>
                                        </thead>
                                        <tbody id="dtlItemBody">
                                        <c:choose>
                                            <c:when test="${not empty itemList}">
                                                <c:forEach var="item" items="${itemList}">
                                                    <tr data-item-no="${item.cmnFacilityItemNo}" data-item-nm="${item.itemNm}" data-stts="${item.cmnFacilitySttsCd}">
                                                        <td style="text-align:center;">${item.cmnFacilityItemNo}</td>
                                                        <td style="padding-left:10px;">${item.itemNm}</td>
                                                        <td style="text-align:center;">
                                                            <c:choose>
                                                                <c:when test="${item.cmnFacilitySttsCd eq 'OPEN'}"><span class="stts-badge stts-open">사용가능</span></c:when>
                                                                <c:when test="${item.cmnFacilitySttsCd eq 'USE'}"><span class="stts-badge stts-use">사용중</span></c:when>
                                                                <c:when test="${item.cmnFacilitySttsCd eq 'REPAIR'}"><span class="stts-badge stts-repair">점검중</span></c:when>
                                                                <c:when test="${item.cmnFacilitySttsCd eq 'CLOSE'}"><span class="stts-badge stts-close">사용중지</span></c:when>
                                                                <c:otherwise><span class="stts-badge">${item.cmnFacilitySttsCd}</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <sec:authorize access="!hasRole('ADMIN')">
                                                            <td style="text-align:center;">
                                                                <div style="display:flex;gap:4px;justify-content:center;">
                                                                    <button type="button" class="row-btn" data-action="edit">수정</button>
                                                                    <button type="button" class="row-btn row-btn-danger" data-action="delete">삭제</button>
                                                                </div>
                                                            </td>
                                                        </sec:authorize>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr id="emptyRow">
                                                    <td class="item-empty" colspan="4">등록된 자원이 없습니다.</td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                        </tbody>
                                    </table>
                                    <sec:authorize access="!hasRole('ADMIN')">
                                        <button type="button" class="item-add-btn" id="itemAddBtn">
                                            <span class="material-symbols-rounded" style="font-size:16px;">add</span> 자원 추가
                                        </button>
                                    </sec:authorize>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>

                <div class="page-actions" style="justify-content:flex-end; margin-top:14px;">
                    <button type="button" class="btn btn-secondary" id="backToListBtn">목록</button>
                    <sec:authorize access="!hasRole('ADMIN')">
                        <button type="button" class="btn btn-primary" id="detailEditBtn">수정</button>
                    </sec:authorize>
                </div>

            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    (function () {
        var contextPath   = "${pageContext.request.contextPath}";
        var mgmtOfcNo     = "${mgmtOfcNo}";
        var cmnFacilityNo = "${detail.cmnFacilityNo}";

        /* CSRF */
        function getCsrfHeaders() {
            var token  = document.querySelector('meta[name="_csrf"]');
            var header = document.querySelector('meta[name="_csrf_header"]');
            var h = { "Content-Type": "application/json" };
            if (token && header) h[header.content] = token.content;
            return h;
        }

        /* fetch JSON */
        async function fetchJson(url, options) {
            var res = await fetch(url, options);
            if (!res.ok) throw new Error("서버 오류: " + res.status);
            return res.json();
        }

        /* 상태 배지 HTML */
        function sttsBadge(cd) {
            var map = { OPEN:["stts-open","사용가능"], USE:["stts-use","사용중"], REPAIR:["stts-repair","점검중"], CLOSE:["stts-close","사용중지"] };
            var s = map[cd]; if (!s) return cd || "-";
            return '<span class="stts-badge ' + s[0] + '">' + s[1] + '</span>';
        }

        /* 빈 행 제거 */
        function removeEmptyRow() {
            var e = document.getElementById("emptyRow");
            if (e) e.remove();
        }

        /* 등록 행 추가 */
        function addInsertRow() {
            removeEmptyRow();
            var tbody = document.getElementById("dtlItemBody");
            if (tbody.querySelector("tr.insert-row")) return;
            var tr = document.createElement("tr");
            tr.className = "insert-row";
            tr.innerHTML =
                '<td style="text-align:center;color:#8a9a8e;font-size:11px;">자동생성</td>' +
                '<td><input type="text" class="item-input" id="newItemNm" placeholder="자원명 입력" maxlength="100"></td>' +
                '<td><select class="item-select" id="newItemStts">' +
                '<option value="OPEN">사용가능</option><option value="USE">사용중</option>' +
                '<option value="REPAIR">점검중</option><option value="CLOSE">사용중지</option>' +
                '</select></td>' +
                '<td><div style="display:flex;gap:4px;justify-content:center;">' +
                '<button type="button" class="row-btn row-btn-primary" id="newItemSaveBtn">저장</button>' +
                '<button type="button" class="row-btn" id="newItemCancelBtn">취소</button>' +
                '</div></td>';
            tbody.appendChild(tr);
            document.getElementById("newItemNm").focus();

            document.getElementById("newItemSaveBtn").addEventListener("click", saveInsert);
            document.getElementById("newItemCancelBtn").addEventListener("click", cancelInsert);
        }

        /* 등록 취소 */
        function cancelInsert() {
            var tr = document.querySelector("tr.insert-row");
            if (tr) tr.remove();
            if (!document.getElementById("dtlItemBody").querySelector("tr[data-item-no]")) {
                document.getElementById("dtlItemBody").innerHTML =
                    '<tr id="emptyRow"><td class="item-empty" colspan="4">등록된 자원이 없습니다.</td></tr>';
            }
        }

        /* 등록 저장 */
        async function saveInsert() {
            var nm = (document.getElementById("newItemNm").value || "").trim();
            if (!nm) { alert("자원명을 입력하세요."); return; }
            var stts = document.getElementById("newItemStts").value;
            try {
                var data = await fetchJson(
                    contextPath + "/manager/publicFacility/item/insert/" + encodeURIComponent(mgmtOfcNo),
                    { method:"POST", headers:getCsrfHeaders(), body:JSON.stringify({ cmnFacilityNo:cmnFacilityNo, itemNm:nm, cmnFacilitySttsCd:stts }) }
                );
                if (data.success) { location.reload(); }
                else { alert(data.message || "등록에 실패했습니다."); }
            } catch(e) { alert("등록 중 오류가 발생했습니다."); }
        }

        /* 수정 행 전환 */
        function startEdit(tr) {
            if (tr.querySelector(".item-input")) return;
            var itemNo = tr.getAttribute("data-item-no");
            var itemNm = tr.getAttribute("data-item-nm");
            var stts   = tr.getAttribute("data-stts");
            tr.innerHTML =
                '<td style="text-align:center;font-size:12px;">' + itemNo + '</td>' +
                '<td><input type="text" class="item-input edit-nm" value="' + itemNm + '" maxlength="100"></td>' +
                '<td><select class="item-select edit-stts">' +
                '<option value="OPEN"' + (stts==='OPEN'?' selected':'') + '>사용가능</option>' +
                '<option value="USE"' + (stts==='USE'?' selected':'') + '>사용중</option>' +
                '<option value="REPAIR"' + (stts==='REPAIR'?' selected':'') + '>점검중</option>' +
                '<option value="CLOSE"' + (stts==='CLOSE'?' selected':'') + '>사용중지</option>' +
                '</select></td>' +
                '<td><div style="display:flex;gap:4px;justify-content:center;">' +
                '<button type="button" class="row-btn row-btn-primary" data-action="save">저장</button>' +
                '<button type="button" class="row-btn" data-action="cancel">취소</button>' +
                '</div></td>';
            tr.querySelector(".edit-nm").focus();
        }

        /* 수정 취소 - 행 원복 */
        function cancelEdit(tr) {
            var itemNo = tr.getAttribute("data-item-no");
            var itemNm = tr.getAttribute("data-item-nm");
            var stts   = tr.getAttribute("data-stts");
            tr.innerHTML =
                '<td style="text-align:center;font-size:12px;">' + itemNo + '</td>' +
                '<td style="padding-left:10px;">' + itemNm + '</td>' +
                '<td style="text-align:center;">' + sttsBadge(stts) + '</td>' +
                '<td><div style="display:flex;gap:4px;justify-content:center;">' +
                '<button type="button" class="row-btn" data-action="edit">수정</button>' +
                '<button type="button" class="row-btn row-btn-danger" data-action="delete">삭제</button>' +
                '</div></td>';
        }

        /* 수정 저장 */
        async function saveEdit(tr) {
            var itemNo = tr.getAttribute("data-item-no");
            var nm     = (tr.querySelector(".edit-nm").value || "").trim();
            var stts   = tr.querySelector(".edit-stts").value;
            if (!nm) { alert("자원명을 입력하세요."); return; }
            try {
                var data = await fetchJson(
                    contextPath + "/manager/publicFacility/item/update/" + encodeURIComponent(mgmtOfcNo),
                    { method:"POST", headers:getCsrfHeaders(), body:JSON.stringify({ cmnFacilityItemNo:itemNo, cmnFacilityNo:cmnFacilityNo, itemNm:nm, cmnFacilitySttsCd:stts }) }
                );
                if (data.success) {
                    tr.setAttribute("data-item-nm", nm);
                    tr.setAttribute("data-stts", stts);
                    cancelEdit(tr);
                } else { alert(data.message || "수정에 실패했습니다."); }
            } catch(e) { alert("수정 중 오류가 발생했습니다."); }
        }

        /* 삭제 */
        async function deleteItem(tr) {
            if (!confirm("이 자원을 삭제하시겠습니까?")) return;
            var itemNo = tr.getAttribute("data-item-no");
            try {
                var data = await fetchJson(
                    contextPath + "/manager/publicFacility/item/delete/" + encodeURIComponent(mgmtOfcNo),
                    { method:"POST", headers:getCsrfHeaders(), body:JSON.stringify({ cmnFacilityItemNo:itemNo }) }
                );
                if (data.success) { tr.remove(); }
                else { alert(data.message || "삭제에 실패했습니다."); }
            } catch(e) { alert("삭제 중 오류가 발생했습니다."); }
        }

        document.addEventListener("DOMContentLoaded", function () {

            /* 자원 추가 버튼 */
            var addBtn = document.getElementById("itemAddBtn");
            if (addBtn) addBtn.addEventListener("click", addInsertRow);

            /* 테이블 이벤트 위임 */
            var tbody = document.getElementById("dtlItemBody");
            if (tbody) {
                tbody.addEventListener("click", function (e) {
                    var btn = e.target.closest("button[data-action]");
                    if (!btn) return;
                    var action = btn.getAttribute("data-action");
                    var tr = btn.closest("tr");
                    if (action === "edit")   startEdit(tr);
                    if (action === "cancel") cancelEdit(tr);
                    if (action === "save")   saveEdit(tr);
                    if (action === "delete") deleteItem(tr);
                });
            }

            /* 목록 버튼 */
            var backBtn = document.getElementById("backToListBtn");
            if (backBtn) {
                backBtn.addEventListener("click", function () {
                    location.href = contextPath + "/manager/publicFacility/list/" + encodeURIComponent(mgmtOfcNo);
                });
            }

            /* 수정 버튼 */
            var editBtn = document.getElementById("detailEditBtn");
            if (editBtn) {
                editBtn.addEventListener("click", function () {
                    location.href = contextPath + "/manager/publicFacility/update-page/"
                        + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo);
                });
            }

            /* 공통 이미지 확대 모듈 */
            if (window.CommonImageViewer && typeof window.CommonImageViewer.bind === "function") {
                window.CommonImageViewer.bind("#dtlImgGrid");
            }
        });
    })();
</script>
</body>
</html>
