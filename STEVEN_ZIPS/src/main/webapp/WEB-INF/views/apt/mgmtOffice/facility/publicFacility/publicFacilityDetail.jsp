<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공용시설 상세</title>

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
        #publicFacilityDetailPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityDetailPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }

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
            display:none; align-items:flex-start; gap:10px;
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
        #publicFacilityDetailPage .img-cell {
            aspect-ratio:4/3; border-radius:6px; overflow:hidden;
            border:1px solid var(--line); background:var(--surface-sub);
            display:flex; align-items:center; justify-content:center;
        }
        #publicFacilityDetailPage .img-cell img { width:100%; height:100%; object-fit:cover; }
        #publicFacilityDetailPage .img-empty {
            grid-column:1/-1; padding:20px 0;
            font-size:12px; color:var(--text-ter); text-align:center;
        }

        /* 공용아이템 테이블 — 헤더 배경 없이 하단 선만 */
        #publicFacilityDetailPage .item-table { width:100%; border-collapse:collapse; border-top:1px solid var(--line); margin-top:4px; }
        #publicFacilityDetailPage .item-table th {
            padding:8px 10px;
            border-bottom:1px solid var(--line);
            font-size:11px; font-weight:800; color:var(--text-ter);
            text-align:left; background:none;
        }
        #publicFacilityDetailPage .item-table td { padding:9px 10px; border-bottom:1px solid var(--line); font-size:12px; color:var(--text-pri); vertical-align:middle; }
        #publicFacilityDetailPage .item-table tbody tr:last-child td { border-bottom:none; }
        #publicFacilityDetailPage .item-table tbody tr { cursor:pointer; transition:background .1s; }
        #publicFacilityDetailPage .item-table tbody tr:hover { background:var(--surface-sub); }
        #publicFacilityDetailPage .item-empty { text-align:center; color:var(--text-ter); padding:16px 0; cursor:default !important; }
        #publicFacilityDetailPage .item-table tbody tr:hover .item-empty { background:none; }

        /* 행 이동 화살표 */
        #publicFacilityDetailPage .item-arrow { color:var(--text-ter); font-size:16px; vertical-align:middle; }
        #publicFacilityDetailPage .item-table tbody tr:hover .item-arrow { color:var(--accent); }

        /* 아이템 상태 배지 */
        #publicFacilityDetailPage .stts-badge { display:inline-flex; align-items:center; padding:2px 8px; border-radius:999px; font-size:11px; font-weight:700; }
        #publicFacilityDetailPage .stts-open   { background:#dceee0; color:#1f7a3f; }
        #publicFacilityDetailPage .stts-use    { background:#dbeafe; color:#1e3a5f; }
        #publicFacilityDetailPage .stts-repair { background:#fef9c3; color:#854d0e; }
        #publicFacilityDetailPage .stts-close  { background:#fee2e2; color:#b42318; }

        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
        }
    </style>

    <script>
        <sec:authorize access="hasRole('ADMIN')" var="facilityAdmin" />
        window.publicFacilityDetailConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            cmnFacilityNo: "${cmnFacilityNo}",
            isAdmin: ${facilityAdmin}
        };
    </script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="publicFacilityDetailPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>공용시설 상세</h2>
                        <p>시설자산(FACILITY)과 공용시설(PUBLIC_FACILITY) 정보를 확인합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">info</span>공용시설 정보</h3>
                    </div>

                    <div class="panel-body">

                        <%-- 비활성 안내 --%>
                        <div class="disabled-notice" id="detailDisabledSection">
                            <span class="material-symbols-rounded">warning</span>
                            <div id="detailDisabledReason"></div>
                        </div>

                        <div class="facility-modal-cols">

                            <%-- 좌측: 시설자산 정보 + 공용시설 운영정보 + 시설 안내/비고 --%>
                            <div class="facility-modal-col-left">

                                <%-- 시설자산 정보 (축약) --%>
                                <div class="form-section" style="margin-bottom:14px;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">apartment</span>시설자산 정보
                                        <a href="#" class="facility-link" id="dtlFacilityLink">
                                            시설 상세 <span class="material-symbols-rounded">arrow_forward</span>
                                        </a>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">시설번호</label>
                                            <input type="text" class="form-input" id="dtlFacilityNo" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">동</label>
                                            <input type="text" class="form-input" id="dtlDongNo" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">상세위치</label>
                                            <input type="text" class="form-input" id="dtlLocCn" readonly>
                                        </div>
                                    </div>
                                </div>

                                <%-- 공용시설 운영정보 (readonly) --%>
                                <div class="form-section" style="margin-bottom:14px;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">meeting_room</span>공용시설 운영정보
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">공용시설번호</label>
                                            <input type="text" class="form-input" id="dtlCmnFacilityNo" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">공용시설명</label>
                                            <input type="text" class="form-input" id="dtlCmnNm" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">예약 가능 여부</label>
                                            <input type="text" class="form-input" id="dtlRsvYn" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">이용요금</label>
                                            <input type="text" class="form-input" id="dtlAmt" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">운영시간</label>
                                            <input type="text" class="form-input" id="dtlOprHr" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">등록일자</label>
                                            <input type="text" class="form-input" id="dtlRegDt" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">수정일자</label>
                                            <input type="text" class="form-input" id="dtlMdfDt" readonly>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">활성여부</label>
                                            <div id="dtlUseYnBadge" style="margin-top:5px;"></div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 시설 안내/비고 (readonly) --%>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">description</span>시설 안내/비고
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <textarea class="form-textarea" id="dtlCn" rows="4" readonly></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%-- 우측: 사진 + 공용아이템 목록 --%>
                            <div class="facility-modal-col-right">

                                <%-- 사진 --%>
                                <div class="form-section" style="margin-bottom:14px;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">photo_library</span>시설 사진
                                    </div>
                                    <div class="img-grid" id="dtlImgGrid"></div>
                                </div>

                                <%-- 공용아이템 목록 --%>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">inventory_2</span>공용아이템 목록
                                    </div>
                                    <table class="item-table">
                                        <thead>
                                        <tr>
                                            <th>자원번호</th>
                                            <th>자원명</th>
                                            <th>상태</th>
                                            <th></th>
                                        </tr>
                                        </thead>
                                        <tbody id="dtlItemBody"></tbody>
                                    </table>
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
        var config        = window.publicFacilityDetailConfig || {};
        var contextPath   = config.contextPath   || "";
        var mgmtOfcNo     = config.mgmtOfcNo     || "";
        var cmnFacilityNo = config.cmnFacilityNo || "";

        function getEl(id) { return document.getElementById(id); }
        function alertMessage(msg) { if (typeof showAlert === "function") showAlert(msg); else alert(msg); }

        function getCsrfHeaders() {
            var tokenMeta  = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
            return headers;
        }

        async function getJson(url) {
            var response = await fetch(url, { method:"GET", headers:getCsrfHeaders() });
            var data = await response.json();
            if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            return data;
        }

        /* ── 포맷 함수 ── */
        function rsvYnLabel(val) { return val === "Y" ? "예약제" : val === "N" ? "자유이용" : "-"; }
        function formatDongNo(value) {
            if (!value) return "공용";
            var idx = String(value).lastIndexOf("_");
            return idx > -1 ? String(value).slice(idx + 1) : String(value);
        }
        function formatAmt(value) {
            if (value == null || value === "") return "무료";
            var n = Number(value);
            return isNaN(n) ? "-" : n === 0 ? "무료" : n.toLocaleString() + "원";
        }
        function formatDate(value) { return value ? String(value).slice(0, 10) : "-"; }
        function escapeHtml(v) {
            if (v == null) return "";
            return String(v).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/"/g,"&quot;");
        }
        function sttsBadge(cd) {
            var map = {
                OPEN:   { cls:"stts-open",   label:"사용가능" },
                USE:    { cls:"stts-use",     label:"사용중"   },
                REPAIR: { cls:"stts-repair",  label:"점검중"   },
                CLOSE:  { cls:"stts-close",   label:"사용중지" }
            };
            var s = map[cd] || { cls:"", label: cd || "-" };
            return '<span class="stts-badge ' + s.cls + '">' + s.label + '</span>';
        }

        /* ── 비활성 안내 ── */
        function renderDisabledNotice(detail) {
            var section = getEl("detailDisabledSection");
            if (detail.useYn !== "N") { section.style.display = "none"; return; }
            section.style.display = "flex";
            getEl("detailDisabledReason").innerHTML = "이 시설은 현재 <strong>비활성</strong> 상태입니다.";
        }

        /* ── 시설자산 정보 ── */
        function renderFacilityInfo(detail) {
            getEl("dtlFacilityNo").value = detail.facilityNo || "-";
            getEl("dtlDongNo").value     = formatDongNo(detail.dongNo);
            getEl("dtlLocCn").value      = detail.locCn      || "";

            var link = getEl("dtlFacilityLink");
            if (detail.facilityNo) {
                link.href = contextPath + "/manager/facility/detail-page/"
                    + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(detail.facilityNo);
            }
        }

        /* ── 공용시설 운영정보 ── */
        function renderCmnInfo(detail) {
            getEl("dtlCmnFacilityNo").value = detail.cmnFacilityNo    || "-";
            getEl("dtlCmnNm").value         = detail.cmnFacilityNm    || "";
            getEl("dtlRsvYn").value         = rsvYnLabel(detail.cmnFacilityRsvYn);
            getEl("dtlAmt").value           = formatAmt(detail.cmnFacilityAmt);
            getEl("dtlOprHr").value         = detail.cmnFacilityOprHr || "";
            getEl("dtlRegDt").value         = formatDate(detail.regDt);
            getEl("dtlMdfDt").value         = formatDate(detail.mdfDt);
            getEl("dtlCn").value            = detail.cmnFacilityCn    || "";

            getEl("dtlUseYnBadge").innerHTML = detail.useYn === "N"
                ? '<span class="badge badge-use-n">비활성</span>'
                : '<span class="badge badge-use-y">활성</span>';
        }

        /* ── 사진 ── */
        function renderImages(fileList) {
            var grid = getEl("dtlImgGrid");
            if (!fileList || fileList.length === 0) {
                grid.innerHTML = '<div class="img-empty">등록된 사진이 없습니다.</div>';
                return;
            }
            grid.innerHTML = fileList.map(function (file) {
                var src = file.viewUrl || file.fileUrl
                    || (contextPath + "/file/view/" + encodeURIComponent(file.fileSaveUuid || ""));
                return '<div class="img-cell"><img src="' + escapeHtml(src) + '" alt="시설사진"></div>';
            }).join("");
        }

        /* ── 공용아이템 목록 ── */
        function renderItemList(itemList) {
            var tbody = getEl("dtlItemBody");
            if (!itemList || itemList.length === 0) {
                tbody.innerHTML = '<tr><td class="item-empty" colspan="4">등록된 자원이 없습니다.</td></tr>';
                return;
            }
            tbody.innerHTML = itemList.map(function (item) {
                var itemNo = escapeHtml(item.cmnFacilityItemNo || "");
                return '<tr data-item-no="' + itemNo + '">'
                    + '<td>' + itemNo + '</td>'
                    + '<td>' + escapeHtml(item.cmnFacilityItemNm || "-") + '</td>'
                    + '<td>' + sttsBadge(item.cmnFacilitySttsCd) + '</td>'
                    + '<td style="width:28px;text-align:center;">'
                    + '<span class="material-symbols-rounded item-arrow">chevron_right</span>'
                    + '</td>'
                    + '</tr>';
            }).join("");

            /* 행 클릭 시 아이템 관리 페이지 이동 */
            tbody.addEventListener("click", function (e) {
                var row = e.target.closest("tr[data-item-no]");
                if (!row) return;
                var itemNo = row.dataset.itemNo;
                if (itemNo) {
                    location.href = contextPath + "/manager/publicItem/detail-page/"
                        + encodeURIComponent(itemNo);
                }
            });
        }

        /* ── 전체 렌더링 ── */
        function renderDetail(result) {
            var detail = result.detail || result || {};
            renderDisabledNotice(detail);
            renderFacilityInfo(detail);
            renderCmnInfo(detail);
            renderImages(result.fileList || []);
            renderItemList(detail.itemList || []);
        }

        /* ── 초기 실행 ── */
        document.addEventListener("DOMContentLoaded", function () {
            getEl("backToListBtn").addEventListener("click", function () {
                location.href = contextPath + "/manager/publicFacilityList";
            });

            var editBtn = getEl("detailEditBtn");
            if (editBtn) {
                editBtn.addEventListener("click", function () {
                    location.href = contextPath + "/manager/publicFacility/update-page/"
                        + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo);
                });
            }

            getJson(contextPath + "/manager/publicFacility/detail/"
                + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo))
                .then(renderDetail)
                .catch(function (err) {
                    console.error(err);
                    alertMessage(err.message || "상세 정보를 불러오지 못했습니다.");
                });
        });
    })();
</script>
</body>
</html>
