<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설 자원 현황</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #publicFacilityItemListPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb;
            --line:#d7dce2; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
        }
        #publicFacilityItemListPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityItemListPage .page-title-block p  { color:var(--text-sec); font-size:12px; }
        #publicFacilityItemListPage .btn { height:32px; border-radius:4px; font-size:12px; cursor:pointer; }
        #publicFacilityItemListPage .btn-primary   { background:var(--accent); border:1px solid var(--accent); color:#fff; }
        #publicFacilityItemListPage .btn-primary:hover { background:var(--accent-hover); }
        #publicFacilityItemListPage .btn-secondary { background:#fff; border:1px solid var(--line); color:var(--text-sec); }
        #publicFacilityItemListPage .btn-icon-text { display:inline-flex; align-items:center; gap:4px; }
        #publicFacilityItemListPage .btn-icon-text .material-symbols-rounded { font-size:16px; }

        /* 검색 패널 */
        #publicFacilityItemListPage .search-panel { border:1px solid var(--line); border-radius:6px; background:var(--surface-sub); padding:14px 16px; margin-bottom:14px; }
        #publicFacilityItemListPage .search-row { display:grid; grid-template-columns:1fr 1fr 1fr; gap:10px 14px; margin-bottom:10px; }
        #publicFacilityItemListPage .search-field label { display:block; font-size:11px; font-weight:800; color:var(--text-ter); margin-bottom:5px; }
        #publicFacilityItemListPage .search-prefix-wrap { display:flex; align-items:center; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #publicFacilityItemListPage .search-prefix { display:flex; align-items:center; height:32px; padding:0 8px; font-size:12px; font-weight:700; color:var(--accent); background:var(--accent-light); border-right:1px solid var(--line); white-space:nowrap; flex-shrink:0; }
        #publicFacilityItemListPage .search-prefix-wrap input { height:32px; border:none; outline:none; font-size:12px; padding:0 8px; flex:1; min-width:0; background:transparent; }
        #publicFacilityItemListPage .search-input { height:32px; width:100%; border:1px solid var(--line); border-radius:4px; font-size:12px; padding:0 10px; box-sizing:border-box; }
        #publicFacilityItemListPage .search-input:focus,
        #publicFacilityItemListPage .search-prefix-wrap:focus-within { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); outline:none; }
        #publicFacilityItemListPage .search-actions { display:flex; justify-content:flex-end; gap:6px; }

        /* 자동완성 드롭다운 */
        #publicFacilityItemListPage .suggest-wrap { position:relative; }
        #publicFacilityItemListPage .suggest-list {
            display:none; position:absolute; top:100%; left:0; right:0; z-index:100;
            background:#fff; border:1px solid var(--line); border-radius:4px;
            box-shadow:0 4px 12px rgba(0,0,0,.1); max-height:200px; overflow-y:auto;
            margin-top:2px;
        }
        #publicFacilityItemListPage .suggest-list.is-open { display:block; }
        #publicFacilityItemListPage .suggest-item {
            padding:7px 12px; font-size:12px; cursor:pointer;
            display:flex; align-items:center; justify-content:space-between;
            border-bottom:1px solid #f0f2f4;
        }
        #publicFacilityItemListPage .suggest-item:last-child { border-bottom:none; }
        #publicFacilityItemListPage .suggest-item:hover { background:var(--accent-light); }
        #publicFacilityItemListPage .suggest-main { font-weight:700; color:var(--text-pri); }
        #publicFacilityItemListPage .suggest-sub  { font-size:11px; color:var(--text-ter); margin-left:8px; }
        #publicFacilityItemListPage .suggest-empty { padding:10px 12px; font-size:12px; color:var(--text-ter); text-align:center; }

        /* 상태 필터 */
        #publicFacilityItemListPage .stts-filter { display:flex; gap:6px; margin-bottom:12px; flex-wrap:wrap; }
        #publicFacilityItemListPage .stts-filter-btn { display:inline-flex; align-items:center; gap:5px; height:30px; padding:0 12px; border-radius:999px; border:1px solid var(--line); background:var(--surface); color:var(--text-sec); font-size:12px; font-weight:700; cursor:pointer; transition:.15s; }
        #publicFacilityItemListPage .stts-filter-btn:hover { border-color:var(--accent); color:var(--accent); }
        #publicFacilityItemListPage .stts-filter-btn.is-active { border-color:var(--accent); background:var(--accent); color:#fff; }
        #publicFacilityItemListPage .stts-filter-btn .cnt { font-size:11px; opacity:.85; }

        /* 패널 */
        #publicFacilityItemListPage .panel { border-radius:6px; border:1px solid var(--line); margin:0; }
        #publicFacilityItemListPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityItemListPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityItemListPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityItemListPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityItemListPage .list-top { display:flex; align-items:center; justify-content:space-between; margin-bottom:10px; }
        #publicFacilityItemListPage .list-count { font-size:12px; color:var(--text-sec); }
        #publicFacilityItemListPage .list-count strong { color:var(--accent); }

        /* 테이블 */
        #publicFacilityItemListPage .table-wrap { border:1px solid var(--line); border-radius:6px; overflow:hidden; }
        #publicFacilityItemListPage table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #publicFacilityItemListPage th { height:40px; background:#f4f6f5; border-bottom:1px solid var(--line); color:var(--text-sec); font-size:12px; font-weight:800; text-align:center; }
        #publicFacilityItemListPage td { height:44px; border-bottom:1px solid #edf0f2; color:var(--text-pri); font-size:12px; text-align:center; vertical-align:middle; }
        #publicFacilityItemListPage tbody tr:last-child td { border-bottom:none; }
        #publicFacilityItemListPage tbody tr:hover td { background:#fafcfb; }
        #publicFacilityItemListPage .td-left { text-align:left; padding-left:12px; }

        /* 배지 */
        #publicFacilityItemListPage .badge { display:inline-flex; align-items:center; justify-content:center; min-width:60px; height:24px; padding:0 8px; border-radius:999px; font-size:11px; font-weight:800; }
        #publicFacilityItemListPage .badge-open   { background:#e8f0ea; color:#2e5c38; }
        #publicFacilityItemListPage .badge-use    { background:#e8eef9; color:#345995; }
        #publicFacilityItemListPage .badge-repair { background:#fff4df; color:#9a6a11; }
        #publicFacilityItemListPage .badge-close  { background:#f0f1f3; color:#5f6670; }

        /* 관리 버튼 */
        #publicFacilityItemListPage .btn-mini { height:28px; padding:0 9px; font-size:11px; border:1px solid var(--line); background:#fff; color:var(--text-sec); border-radius:4px; cursor:pointer; }
        #publicFacilityItemListPage .btn-mini:hover { border-color:var(--accent); color:var(--accent); background:var(--accent-dim); }

        /* 빈/로딩 행 */
        #publicFacilityItemListPage .empty-row td,
        #publicFacilityItemListPage .loading-row td { height:88px; color:var(--text-ter); text-align:center; }

        /* 페이징 */
        #publicFacilityItemListPage .paging { display:flex; align-items:center; justify-content:center; gap:4px; margin-top:14px; }
        #publicFacilityItemListPage .page-btn { display:inline-flex; align-items:center; justify-content:center; width:30px; height:30px; border-radius:4px; border:1px solid var(--line); background:#fff; font-size:12px; color:var(--text-sec); cursor:pointer; }
        #publicFacilityItemListPage .page-btn:hover { border-color:var(--accent); color:var(--accent); }
        #publicFacilityItemListPage .page-btn.is-active { background:var(--accent); border-color:var(--accent); color:#fff; font-weight:800; }
        #publicFacilityItemListPage .page-btn:disabled { opacity:.4; cursor:default; }
        #publicFacilityItemListPage .page-btn .material-symbols-rounded { font-size:16px; }
    </style>

    <script>
        window.itemListConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo:   "${mgmtOfcNo}",
            isAdmin:     ${isAdmin ? 'true' : 'false'}
        };
    </script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/publicFacility/page/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="편의시설 관리" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="publicFacilityItemListPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설 자원 현황</h2>
                        <p>전체 자원을 상태별로 조회합니다. 자원 등록·수정·삭제는 편의시설 상세에서 할 수 있습니다.</p>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary btn-icon-text" id="backToListBtn">
                            <span class="material-symbols-rounded">arrow_back</span>편의시설 목록
                        </button>
                    </div>
                </div>

                <%-- 검색 패널 --%>
                <div class="search-panel">
                    <div class="search-row">

                        <%-- 자원번호 검색 (ITEM 고정 + 숫자 입력 + 자동완성) --%>
                        <div class="search-field">
                            <label>자원번호</label>
                            <div class="suggest-wrap">
                                <div class="search-prefix-wrap" id="itemNoWrap">
                                    <span class="search-prefix">ITEM</span>
                                    <input type="text" id="searchItemNo" placeholder="번호 입력" maxlength="20" autocomplete="off">
                                </div>
                                <div class="suggest-list" id="suggestItemNo"></div>
                            </div>
                        </div>

                        <%-- 편의시설번호 검색 (CMN 고정 + 숫자 입력 + 자동완성) --%>
                        <div class="search-field">
                            <label>편의시설번호</label>
                            <div class="suggest-wrap">
                                <div class="search-prefix-wrap" id="facilityNoWrap">
                                    <span class="search-prefix">CMN</span>
                                    <input type="text" id="searchFacilityNo" placeholder="번호 입력" maxlength="20" autocomplete="off">
                                </div>
                                <div class="suggest-list" id="suggestFacilityNo"></div>
                            </div>
                        </div>

                        <%-- 자원명 검색 (자동완성) --%>
                        <div class="search-field">
                            <label>자원명</label>
                            <div class="suggest-wrap">
                                <input type="text" class="search-input" id="searchItemNm" placeholder="자원명 입력" maxlength="100" autocomplete="off">
                                <div class="suggest-list" id="suggestItemNm"></div>
                            </div>
                        </div>

                    </div>
                    <div class="search-actions">
                        <button type="button" class="btn btn-secondary" id="searchResetBtn">초기화</button>
                        <button type="button" class="btn btn-primary" id="searchBtn">검색</button>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">inventory_2</span>편의시설 자원 현황
                        </h3>
                    </div>
                    <div class="panel-body">

                        <%-- 상태 필터 --%>
                        <div class="stts-filter">
                            <button type="button" class="stts-filter-btn is-active" data-filter="ALL">전체 <span class="cnt" id="cntAll">0</span></button>
                            <button type="button" class="stts-filter-btn" data-filter="OPEN">사용가능 <span class="cnt" id="cntOpen">0</span></button>
                            <button type="button" class="stts-filter-btn" data-filter="USE">사용중 <span class="cnt" id="cntUse">0</span></button>
                            <button type="button" class="stts-filter-btn" data-filter="REPAIR">점검중 <span class="cnt" id="cntRepair">0</span></button>
                            <button type="button" class="stts-filter-btn" data-filter="CLOSE">사용중지 <span class="cnt" id="cntClose">0</span></button>
                        </div>

                        <div class="list-top">
                            <div class="list-count">전체 <strong id="totalCountEl">0</strong>건</div>
                        </div>

                        <div class="table-wrap">
                            <table>
                                <colgroup>
                                    <col style="width:55px;">
                                    <col style="width:130px;">
                                    <col>
                                    <col style="width:160px;">
                                    <col style="width:110px;">
                                    <col style="width:100px;">
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>번호</th>
                                    <th>자원번호</th>
                                    <th style="text-align:left;padding-left:12px;">자원명</th>
                                    <th>편의시설명</th>
                                    <th>상태</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody id="itemTbody">
                                <tr class="loading-row"><td colspan="6">조회 중...</td></tr>
                                </tbody>
                            </table>
                        </div>

                        <%-- 페이징 --%>
                        <div class="paging" id="pagingWrap"></div>

                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    (function () {
        var config      = window.itemListConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo   = config.mgmtOfcNo   || "";

        /* ============================================================
           검색 상태
        ============================================================ */
        var searchState = {
            itemNo:     "",   /* 자원번호 숫자 부분 */
            facilityNo: "",   /* 편의시설번호 숫자 부분 */
            itemNm:     "",   /* 자원명 */
            sttsCd:     "",   /* 상태코드 */
            page:       1,
            pageSize:   15
        };

        /* ============================================================
           DOM 유틸
        ============================================================ */
        function el(id) { return document.getElementById(id); }

        /* ============================================================
           상태 배지 HTML
        ============================================================ */
        function sttsBadge(cd) {
            var map = {
                OPEN:   ["badge-open",   "사용가능"],
                USE:    ["badge-use",    "사용중"],
                REPAIR: ["badge-repair", "점검중"],
                CLOSE:  ["badge-close",  "사용중지"]
            };
            var s = map[cd];
            if (!s) return '<span class="badge">-</span>';
            return '<span class="badge ' + s[0] + '">' + s[1] + '</span>';
        }

        /* ============================================================
           목록 조회
        ============================================================ */
        function loadList() {
            var tbody = el("itemTbody");
            tbody.innerHTML = '<tr class="loading-row"><td colspan="6">조회 중...</td></tr>';

            var url = contextPath + "/manager/publicFacility/item/paging/" + encodeURIComponent(mgmtOfcNo)
                + "?itemNo="     + encodeURIComponent(searchState.itemNo)
                + "&facilityNo=" + encodeURIComponent(searchState.facilityNo)
                + "&itemNm="     + encodeURIComponent(searchState.itemNm)
                + "&sttsCd="     + encodeURIComponent(searchState.sttsCd)
                + "&page="       + searchState.page
                + "&pageSize="   + searchState.pageSize;

            fetch(url)
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    if (!data.success) {
                        tbody.innerHTML = '<tr class="empty-row"><td colspan="6">조회 중 오류가 발생했습니다.</td></tr>';
                        return;
                    }
                    renderTable(data.list || [], data.totalCount || 0);
                    renderPaging(data.totalPages || 1, data.page || 1);
                    updateTotalCount(data.totalCount || 0);
                })
                .catch(function () {
                    tbody.innerHTML = '<tr class="empty-row"><td colspan="6">조회 중 오류가 발생했습니다.</td></tr>';
                });
        }

        /* ============================================================
           테이블 렌더링
        ============================================================ */
        function renderTable(list, totalCount) {
            var tbody = el("itemTbody");

            if (!list || list.length === 0) {
                tbody.innerHTML = '<tr class="empty-row"><td colspan="6">조회된 자원이 없습니다.</td></tr>';
                return;
            }

            /* 역순 번호 계산 */
            var startNo = totalCount - ((searchState.page - 1) * searchState.pageSize);

            var html = "";
            list.forEach(function (item, idx) {
                html += '<tr data-facility-no="' + (item.cmnFacilityNo || "") + '">'
                    + '<td>' + (startNo - idx) + '</td>'
                    + '<td style="font-size:11px;color:var(--text-ter);">' + (item.cmnFacilityItemNo || "-") + '</td>'
                    + '<td class="td-left">' + (item.itemNm || "-") + '</td>'
                    + '<td>' + (item.cmnFacilityNm || "-") + '</td>'
                    + '<td>' + sttsBadge(item.cmnFacilitySttsCd) + '</td>'
                    + '<td><button type="button" class="btn-mini" data-action="manage" data-facility-no="' + (item.cmnFacilityNo || "") + '">시설 상세</button></td>'
                    + '</tr>';
            });
            tbody.innerHTML = html;
        }

        /* ============================================================
           건수 / 상태 필터 카운트 업데이트
        ============================================================ */
        function updateTotalCount(total) {
            var el2 = el("totalCountEl");
            if (el2) el2.textContent = total;
        }

        /* ============================================================
           페이징 렌더링
        ============================================================ */
        function renderPaging(totalPages, currentPage) {
            var wrap = el("pagingWrap");
            if (!wrap) return;
            if (totalPages <= 1) { wrap.innerHTML = ""; return; }

            var html = "";
            var groupSize = 5;
            var groupStart = Math.floor((currentPage - 1) / groupSize) * groupSize + 1;
            var groupEnd   = Math.min(groupStart + groupSize - 1, totalPages);

            /* 이전 그룹 */
            html += '<button type="button" class="page-btn" data-page="' + Math.max(1, groupStart - 1) + '"'
                + (groupStart === 1 ? ' disabled' : '') + '>'
                + '<span class="material-symbols-rounded">chevron_left</span></button>';

            /* 페이지 번호 */
            for (var i = groupStart; i <= groupEnd; i++) {
                html += '<button type="button" class="page-btn' + (i === currentPage ? ' is-active' : '') + '" data-page="' + i + '">' + i + '</button>';
            }

            /* 다음 그룹 */
            html += '<button type="button" class="page-btn" data-page="' + Math.min(totalPages, groupEnd + 1) + '"'
                + (groupEnd === totalPages ? ' disabled' : '') + '>'
                + '<span class="material-symbols-rounded">chevron_right</span></button>';

            wrap.innerHTML = html;
        }

        /* ============================================================
           자동완성
        ============================================================ */
        var suggestTimers = {};

        function bindSuggest(inputId, suggestId, suggestType, isPrefix) {
            var input   = el(inputId);
            var suggest = el(suggestId);
            if (!input || !suggest) return;

            input.addEventListener("input", function () {
                var keyword = input.value.trim();

                /* 자동완성은 1글자 이상부터 */
                if (!keyword) { closeSuggest(suggestId); return; }

                /* 디바운스 200ms */
                clearTimeout(suggestTimers[inputId]);
                suggestTimers[inputId] = setTimeout(function () {
                    fetchSuggest(suggestType, keyword, suggest, input, isPrefix);
                }, 200);
            });

            /* 외부 클릭 시 드롭다운 닫기 */
            document.addEventListener("click", function (e) {
                if (!input.contains(e.target) && !suggest.contains(e.target)) {
                    closeSuggest(suggestId);
                }
            });
        }

        function fetchSuggest(suggestType, keyword, suggestEl, inputEl, isPrefix) {
            var url = contextPath + "/manager/publicFacility/item/suggest/" + encodeURIComponent(mgmtOfcNo)
                + "?suggestType=" + encodeURIComponent(suggestType)
                + "&keyword="     + encodeURIComponent(keyword);

            fetch(url)
                .then(function (res) { return res.json(); })
                .then(function (data) {
                    renderSuggest(data.list || [], suggestEl, inputEl, suggestType, isPrefix);
                })
                .catch(function () { closeSuggest(suggestEl.id); });
        }

        function renderSuggest(list, suggestEl, inputEl, suggestType, isPrefix) {
            if (!list || list.length === 0) {
                suggestEl.innerHTML = '<div class="suggest-empty">검색 결과가 없습니다.</div>';
                suggestEl.classList.add("is-open");
                return;
            }

            var html = "";
            list.forEach(function (item) {
                var main = "", sub = "";

                if (suggestType === "ITEM_NO") {
                    main = item.cmnFacilityItemNo || "";
                    sub  = item.itemNm || "";
                } else if (suggestType === "FACILITY_NO") {
                    main = item.cmnFacilityNo || "";
                    sub  = item.cmnFacilityNm || "";
                } else {
                    main = item.itemNm || "";
                    sub  = item.cmnFacilityNm || "";
                }

                html += '<div class="suggest-item" data-value="' + main + '" data-sub="' + sub + '">'
                    + '<span class="suggest-main">' + main + '</span>'
                    + '<span class="suggest-sub">' + sub + '</span>'
                    + '</div>';
            });

            suggestEl.innerHTML = html;
            suggestEl.classList.add("is-open");

            /* 항목 클릭 시 input에 값 세팅 */
            suggestEl.querySelectorAll(".suggest-item").forEach(function (item) {
                item.addEventListener("click", function () {
                    var val = item.getAttribute("data-value") || "";
                    /* 접두사 제거 후 숫자 부분만 input에 세팅 */
                    if (isPrefix) {
                        val = val.replace(/^(ITEM|CMN)/, "");
                    }
                    inputEl.value = val;
                    closeSuggest(suggestEl.id);
                });
            });
        }

        function closeSuggest(suggestId) {
            var s = el(suggestId);
            if (s) { s.classList.remove("is-open"); s.innerHTML = ""; }
        }

        /* ============================================================
           상태 필터 탭
        ============================================================ */
        function bindSttsFilter() {
            document.querySelectorAll(".stts-filter-btn").forEach(function (btn) {
                btn.addEventListener("click", function () {
                    document.querySelectorAll(".stts-filter-btn").forEach(function (b) { b.classList.remove("is-active"); });
                    btn.classList.add("is-active");
                    searchState.sttsCd = btn.getAttribute("data-filter") === "ALL" ? "" : btn.getAttribute("data-filter");
                    searchState.page   = 1;
                    loadList();
                });
            });
        }

        /* ============================================================
           검색 버튼
        ============================================================ */
        function bindSearch() {
            var searchBtn = el("searchBtn");
            var resetBtn  = el("searchResetBtn");

            if (searchBtn) {
                searchBtn.addEventListener("click", function () {
                    searchState.itemNo     = (el("searchItemNo").value     || "").trim();
                    searchState.facilityNo = (el("searchFacilityNo").value || "").trim();
                    searchState.itemNm     = (el("searchItemNm").value     || "").trim();
                    searchState.page       = 1;
                    loadList();
                });
            }

            if (resetBtn) {
                resetBtn.addEventListener("click", function () {
                    el("searchItemNo").value     = "";
                    el("searchFacilityNo").value = "";
                    el("searchItemNm").value     = "";
                    searchState.itemNo     = "";
                    searchState.facilityNo = "";
                    searchState.itemNm     = "";
                    searchState.sttsCd     = "";
                    searchState.page       = 1;
                    /* 상태 필터 전체로 초기화 */
                    document.querySelectorAll(".stts-filter-btn").forEach(function (b) { b.classList.remove("is-active"); });
                    document.querySelector(".stts-filter-btn[data-filter='ALL']").classList.add("is-active");
                    loadList();
                });
            }

            /* 엔터키 검색 */
            ["searchItemNo", "searchFacilityNo", "searchItemNm"].forEach(function (id) {
                var inp = el(id);
                if (inp) {
                    inp.addEventListener("keydown", function (e) {
                        if (e.key === "Enter") searchBtn && searchBtn.click();
                    });
                }
            });
        }

        /* ============================================================
           페이징 클릭
        ============================================================ */
        function bindPaging() {
            el("pagingWrap").addEventListener("click", function (e) {
                var btn = e.target.closest(".page-btn");
                if (!btn || btn.disabled) return;
                searchState.page = parseInt(btn.getAttribute("data-page"), 10);
                loadList();
            });
        }

        /* ============================================================
           테이블 시설 상세 이동
        ============================================================ */
        function bindTableActions() {
            el("itemTbody").addEventListener("click", function (e) {
                var btn = e.target.closest("button[data-action='manage']");
                if (!btn) return;
                var facilityNo = btn.getAttribute("data-facility-no");
                if (facilityNo) {
                    location.href = contextPath + "/manager/publicFacility/detail-page/"
                        + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo);
                }
            });
        }

        /* ============================================================
           뒤로 버튼
        ============================================================ */
        function bindBackBtn() {
            var backBtn = el("backToListBtn");
            if (backBtn) {
                backBtn.addEventListener("click", function () {
                    location.href = contextPath + "/manager/publicFacility/list/" + encodeURIComponent(mgmtOfcNo);
                });
            }
        }

        /* ============================================================
           초기 실행
        ============================================================ */
        document.addEventListener("DOMContentLoaded", function () {
            bindBackBtn();
            bindSttsFilter();
            bindSearch();
            bindPaging();
            bindTableActions();

            /* 자동완성 바인딩 */
            bindSuggest("searchItemNo",     "suggestItemNo",     "ITEM_NO",     true);
            bindSuggest("searchFacilityNo", "suggestFacilityNo", "FACILITY_NO", true);
            bindSuggest("searchItemNm",     "suggestItemNm",     "ITEM_NM",     false);

            /* 최초 목록 로드 */
            loadList();
        });

    })();
</script>
</body>
</html>
