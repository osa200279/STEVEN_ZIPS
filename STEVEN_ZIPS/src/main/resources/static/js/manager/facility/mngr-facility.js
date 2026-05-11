/**
 * ============================================================
 * mngr-facility.js
 * 시설자산 관리 화면 전용 스크립트
 *
 * 기준
 * - JSP id/class/CSS 구조 변경 금지
 * - 등록·수정은 파일 업로드가 있어 FormData 전송
 * - Controller 주소 기준: /manager/facility/...
 * - 시설유형 정정은 prompt() 아닌 수정 모달 내 잠금해제 방식으로 처리
 *
 * 로드 순서 (JSP)
 *   mngr-facility-grid.js → mngr-facility-modal.js → mngr-facility.js
 *
 * 파일 분리 구조
 * - mngr-facility-grid.js  : AG Grid 컬럼·렌더러·그리드 API
 * - mngr-facility-modal.js : 등록·수정·상세 모달, 위치처리, 저장, 정정
 * - mngr-facility.js       : 초기화, API 유틸, 검색·필터·탭, 자동완성, CSV
 *
 * 공유 상태 (window._facilityState)
 * - currentFacilityNo  : 현재 열린 모달의 시설번호
 * - currentFacility    : 현재 열린 모달의 시설 VO
 * - correctionUnlocked : 시설유형 정정 잠금해제 여부
 *
 * 공용 유틸 (window.FacilityUtil)
 * - mngr-facility-modal.js 에서 util() 로 참조
 * ============================================================
 */

(function () {

    /* ── 페이지 공통 변수 ──────────────────────────────── */
    var page = null; // facilityPage 루트 요소
    var form = null; // facilityForm 폼 요소

    var currentList   = []; // 목록 조회 결과 캐시 (자동완성용)
    var suggestTimer  = null; // 자동완성 디바운스 타이머
    var SUGGEST_LIMIT = 5;    // 자동완성 최대 표시 건수

    /* facilityPageConfig: JSP 에서 주입 */
    var config      = window.facilityPageConfig || {};
    var contextPath = config.contextPath || "";
    var mgmtOfcNo   = config.mgmtOfcNo   || "";

    /* 현재 선택된 시설종류 탭: ALL(전체시설) / PUBLIC(편의시설) */
    var currentFacilityKind = "ALL";

    var isAdmin = config.isAdmin === true || config.isAdmin === "true";

    /* ── 공유 상태 초기화 (window._facilityState) ─────── */
    /*
     * mngr-facility-modal.js 에서 state() 로 읽고 쓴다.
     * 이 파일이 마지막으로 로드되므로 여기서 초기화한다.
     */
    window._facilityState = {
        currentFacilityNo:  null,
        currentFacility:    null,
        correctionUnlocked: false
    };

    /* ── API 유틸 ─────────────────────────────────────── */

    function apiUrl(path) {
        return contextPath + "/manager/facility/" + path;
    }

    function getCsrfHeaders() {
        var tokenMeta  = document.querySelector('meta[name="_csrf"]');
        var headerMeta = document.querySelector('meta[name="_csrf_header"]');
        var headers    = {};

        if (tokenMeta && headerMeta) {
            headers[headerMeta.getAttribute("content")] = tokenMeta.getAttribute("content");
        }

        return headers;
    }

    function alertMessage(message) {
        if (typeof showAlert === "function") {
            showAlert(message);
            return;
        }
        alert(message);
    }

    async function requestJson(url, options) {
        var response    = await fetch(url, options || {});
        var contentType = response.headers.get("content-type") || "";
        var data        = contentType.indexOf("application/json") > -1
            ? await response.json()
            : {};

        if (!response.ok || data.success === false) {
            throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
        }

        return data;
    }

    function getJson(url) {
        return requestJson(url, {
            method:  "GET",
            headers: getCsrfHeaders()
        });
    }

    function postJson(url, body) {
        var headers = getCsrfHeaders();
        headers["Content-Type"] = "application/json";

        return requestJson(url, {
            method:  "POST",
            headers: headers,
            body:    JSON.stringify(body || {})
        });
    }

    function postForm(url, formData) {
        return requestJson(url, {
            method:  "POST",
            headers: getCsrfHeaders(),
            body:    formData
        });
    }

    /* ── 화면 유틸 ─────────────────────────────────────── */

    function escapeHtml(value) {
        if (value == null) return "";
        return String(value)
            .replace(/&/g,  "&amp;")
            .replace(/</g,  "&lt;")
            .replace(/>/g,  "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g,  "&#39;");
    }

    function badge(cls, text) {
        return '<span class="badge ' + cls + '">' + escapeHtml(text) + '</span>';
    }

    function codeBadge(codeMap, code) {
        var entry = codeMap && codeMap[String(code || "").toUpperCase()];
        return entry ? badge(entry[0], entry[1]) : badge("badge-gray", code || "-");
    }

    function useYnBadge(useYn) {
        return useYn === "N"
            ? badge("badge-use-n", "사용 불가")
            : badge("badge-use-y", "사용 가능");
    }

    function detailItem(label, value) {
        return '<div class="mngr-detail-item">'
            + '<div class="mngr-detail-label">' + escapeHtml(label) + '</div>'
            + '<div class="mngr-detail-value">' + (value == null || value === "" ? "-" : value) + '</div>'
            + '</div>';
    }

    function formatDate(value) {
        if (!value) return "";
        return String(value).slice(0, 10);
    }

    function formatDongNo(value) {
        if (value == null || value === "") return "공용";

        var text = String(value);
        var idx  = text.lastIndexOf("_");
        var dong = idx > -1 ? text.slice(idx + 1) : text;

        return dong || "공용";
    }

    function setUseYnValue(value) {
        var normalized = value === "N" ? "N" : "Y";
        var hidden     = document.getElementById("useYn");
        var toggle     = document.getElementById("useYnToggle");
        var statusText = document.getElementById("useYnStatusText");

        if (hidden)     hidden.value   = normalized;
        if (toggle)     toggle.checked = normalized === "Y";
        if (statusText) {
            statusText.textContent = normalized === "Y" ? "사용 가능" : "사용 불가";
            statusText.classList.toggle("is-off", normalized === "N");
        }
    }

    function getResultFacility(result) {
        return result.detail || result.facility || result || {};
    }

    function getFacilityKindText(kind) {
        if (kind === "ALL") return "전체시설";
        return kind === "PUBLIC" ? "편의시설" : "일반시설";
    }

    function getMapValue(row, keyList) {
        row = row || {};

        for (var i = 0; i < keyList.length; i++) {
            var key = keyList[i];
            if (row[key] != null) return row[key];
        }

        return "";
    }

    /* ── window.FacilityUtil 노출 ──────────────────────── */
    /*
     * mngr-facility-modal.js 가 먼저 로드되지만
     * util() 호출은 실제 함수 실행 시점(DOMContentLoaded 이후)에 이루어지므로
     * 이 시점에 window.FacilityUtil 이 설정되어 있으면 된다.
     */
    window.FacilityUtil = {
        /* API */
        apiUrl:   apiUrl,
        getJson:  getJson,
        postJson: postJson,
        postForm: postForm,

        /* 설정값 접근 */
        isAdmin:     function () { return isAdmin; },
        mgmtOfcNo:   function () { return mgmtOfcNo; },
        contextPath: function () { return contextPath; },

        /* 화면 유틸 */
        escapeHtml:          escapeHtml,
        badge:               badge,
        codeBadge:           codeBadge,
        useYnBadge:          useYnBadge,
        detailItem:          detailItem,
        formatDate:          formatDate,
        formatDongNo:        formatDongNo,
        setUseYnValue:       setUseYnValue,
        getResultFacility:   getResultFacility,
        getFacilityKindText: getFacilityKindText,
        getMapValue:         getMapValue,
        alertMessage:        alertMessage,

        /* 목록 조회 (modal 저장 완료 후 목록 갱신용) */
        loadFacilityList: function () { return loadFacilityList(); }
    };

    /* ── 시설유형 필터 옵션 구성 ───────────────────────── */

    /**
     * 전체시설 탭
     * - 일반시설 유형은 개별 옵션으로 표시한다.
     * - 편의시설 세부 유형은 펼치지 않고 "편의시설" 하나의 옵션으로만 표시한다.
     *
     * 편의시설 탭
     * - 실제 PUBLIC_FACILITY 에 연결된 편의시설 유형만 표시한다.
     */
    async function renderFacilityTypeFilter() {
        var select = document.getElementById("filterFacTy");
        if (!select) return;

        var selectedValue = select.value;

        try {
            var url = apiUrl(
                "type/list/"
                + encodeURIComponent(mgmtOfcNo)
                + "?facilityKind="
                + encodeURIComponent(currentFacilityKind)
            );

            var result = await getJson(url);
            var list   = result.typeList || result.list || [];

            select.innerHTML = '<option value="">전체</option>';

            if (currentFacilityKind === "ALL") {
                var normalGroup   = document.createElement("optgroup");
                var hasPublicType = false;

                normalGroup.label = "일반시설";

                list.forEach(function (item) {
                    var code = getMapValue(item, ["code", "CODE", "codeNoCd", "CODE_NO_CD"]);
                    var name = getMapValue(item, ["codeNm", "CODENM", "codeName", "CODE_NAME"]);
                    var kind = getMapValue(item, ["facilityKind", "FACILITYKIND", "facility_kind", "FACILITY_KIND"]);

                    if (!code) return;

                    if (kind === "PUBLIC") {
                        hasPublicType = true;
                        return;
                    }

                    var option         = document.createElement("option");
                    option.value       = code;
                    option.textContent = name || code;
                    normalGroup.appendChild(option);
                });

                if (normalGroup.children.length > 0) select.appendChild(normalGroup);

                if (hasPublicType) {
                    var publicOption         = document.createElement("option");
                    publicOption.value       = "_PUBLIC_";
                    publicOption.textContent = "편의시설";
                    select.appendChild(publicOption);
                }
            }

            if (currentFacilityKind === "PUBLIC") {
                list.forEach(function (item) {
                    var code = getMapValue(item, ["code", "CODE", "codeNoCd", "CODE_NO_CD"]);
                    var name = getMapValue(item, ["codeNm", "CODENM", "codeName", "CODE_NAME"]);

                    if (!code) return;

                    var option         = document.createElement("option");
                    option.value       = code;
                    option.textContent = name || code;
                    select.appendChild(option);
                });
            }

            var exists = Array.from(select.options).some(function (opt) {
                return opt.value === selectedValue;
            });

            select.value = exists ? selectedValue : "";

        } catch (e) {
            console.error(e);
            select.innerHTML = '<option value="">전체</option>';
        }
    }

    /* ── 탭 ────────────────────────────────────────────── */

    function updateFacilityTabs() {
        var buttons = page ? page.querySelectorAll(".facility-tab-btn") : [];

        buttons.forEach(function (button) {
            button.classList.toggle("active", button.dataset.kind === currentFacilityKind);
        });
    }

    async function setFacilityTab(kind) {
        currentFacilityKind = kind === "PUBLIC" ? "PUBLIC" : "ALL";
        updateFacilityTabs();
        closeSuggestList();
        FacilityGrid.reset();

        await renderFacilityTypeFilter();
        await loadFacilityList();
    }

    /* ── 검색 ──────────────────────────────────────────── */

    function collectSearchParam() {
        var params = new URLSearchParams();

        var facilityTyCd = document.getElementById("filterFacTy").value;
        var useYn        = document.getElementById("filterUseYn")  ? document.getElementById("filterUseYn").value  : "";
        var dongNo       = document.getElementById("filterDong")    ? document.getElementById("filterDong").value   : "";
        var keyword      = document.getElementById("filterKeyword").value.trim();

        params.append("facilityKind", currentFacilityKind);

        if (facilityTyCd) params.append("facilityTyCd", facilityTyCd);
        if (useYn)        params.append("useYn",        useYn);
        if (dongNo)       params.append("dongNo",       dongNo);
        if (keyword)      params.append("keyword",      keyword);

        return params;
    }

    function getFilterSummaryText() {
        var labels     = ["시설종류: " + getFacilityKindText(currentFacilityKind)];
        var facilityTy = document.getElementById("filterFacTy");
        var useYn      = document.getElementById("filterUseYn");
        var dong       = document.getElementById("filterDong");
        var keyword    = document.getElementById("filterKeyword").value.trim();

        if (facilityTy && facilityTy.value) labels.push("시설유형: " + facilityTy.options[facilityTy.selectedIndex].text);
        if (useYn      && useYn.value)      labels.push("운영상태: " + useYn.options[useYn.selectedIndex].text);
        if (dong       && dong.value)       labels.push("동: "      + dong.options[dong.selectedIndex].text);
        if (keyword)                        labels.push("검색어: "   + keyword);

        return labels.length ? labels.join(" · ") : "전체 조건";
    }

    function updateListHeader(count) {
        document.getElementById("facilityCount").textContent = (count || 0) + "건";
        document.getElementById("resultDesc").textContent    = getFilterSummaryText();
    }

    /* ── 현황 카드 갱신 ────────────────────────────────── */

    function updateStats(list, stats) {
        stats = stats || {};
        list  = list  || [];

        var dongCnt = stats.dongCnt != null
            ? stats.dongCnt
            : list.filter(function (row) { return row.dongNo && row.dongNo !== "공용"; }).length;

        var commonLocCnt = stats.commonLocCnt != null
            ? stats.commonLocCnt
            : list.filter(function (row) { return !row.dongNo || row.dongNo === "공용"; }).length;

        var disabledTotal = stats.disabledTotal != null
            ? stats.disabledTotal
            : list.filter(function (row) { return row.useYn === "N"; }).length;

        var disabledToday = stats.disabledToday != null ? Number(stats.disabledToday) : null;

        if (document.getElementById("statDong"))      document.getElementById("statDong").textContent      = dongCnt;
        if (document.getElementById("statCommonLoc")) document.getElementById("statCommonLoc").textContent = commonLocCnt;
        if (document.getElementById("statDisabled"))  document.getElementById("statDisabled").textContent  = disabledTotal;

        var todayEl = document.getElementById("statDisabledToday");
        if (todayEl) {
            todayEl.textContent = disabledToday != null && disabledToday > 0
                ? "오늘 " + disabledToday + "건 추가"
                : "";
        }
    }

    function updateTotalFacilityCount(list) {
        document.getElementById("statTotal").textContent = (list || []).length;
    }

    /* ── 목록 조회 ─────────────────────────────────────── */

    async function loadFacilityList() {
        var params = collectSearchParam();
        var url    = apiUrl("list/" + encodeURIComponent(mgmtOfcNo));

        if (params.toString()) url += "?" + params.toString();

        try {
            var result = await getJson(url);
            var list   = result.list || result.facilityList || [];

            currentList = list;
            FacilityGrid.setRows(list);
            updateListHeader(list.length);
            updateStats(list, result.stats || {});
            updateTotalFacilityCount(list);
        } catch (e) {
            console.error(e);
            alertMessage(e.message || "시설 목록 조회 중 오류가 발생했습니다.");
            FacilityGrid.setRows([]);
            updateListHeader(0);
            updateStats([], {});
            updateTotalFacilityCount([]);
        }
    }

    /* ── 상세 조회 ─────────────────────────────────────── */

    async function loadFacilityDetail(facilityNo) {
        try {
            var url    = apiUrl("detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo));
            var result = await getJson(url);
            FacilityModal.openDetailModal(result);
        } catch (e) {
            console.error(e);
            alertMessage(e.message || "시설 상세 조회 중 오류가 발생했습니다.");
        }
    }

    /* ── 자동완성 ──────────────────────────────────────── */

    function normalize(value) {
        return String(value == null ? "" : value).toLowerCase();
    }

    function matchesCurrentSelectFilters(row) {
        var facilityTyCd = document.getElementById("filterFacTy") ? document.getElementById("filterFacTy").value : "";
        var useYn        = document.getElementById("filterUseYn") ? document.getElementById("filterUseYn").value : "";
        var dongNo       = document.getElementById("filterDong")   ? document.getElementById("filterDong").value  : "";

        if (currentFacilityKind !== "ALL" && row.facilityKind && row.facilityKind !== currentFacilityKind) return false;
        if (facilityTyCd && row.facilityTyCd !== facilityTyCd) return false;
        if (useYn        && row.useYn        !== useYn)        return false;
        if (dongNo === "_COMMON_" && row.dongNo)               return false;
        if (dongNo && dongNo !== "_COMMON_" && row.dongNo !== dongNo) return false;

        return true;
    }

    function getFacilitySearchText(row) {
        var values = [
            row.facilityNo,
            row.facilityNm,
            row.facilityKindNm,
            row.facilityTyCd,
            row.facilityTyNm,
            row.useYn === "N" ? "사용 불가" : "사용 가능",
            row.dongNo,
            row.locCn,
            formatDate(row.instlDt)
        ];

        Object.keys(row || {}).forEach(function (key) {
            var value = row[key];
            if (value == null) return;
            if (typeof value === "string" || typeof value === "number") values.push(value);
        });

        return values.map(normalize).join(" ");
    }

    function closeSuggestList() {
        var area = document.getElementById("facilitySuggestList");
        if (area) {
            area.classList.remove("open");
            area.innerHTML = "";
        }
    }

    function renderSuggestList(keyword) {
        var area = document.getElementById("facilitySuggestList");
        if (!area) return;

        keyword = String(keyword || "").trim();

        if (keyword.length < 2) {
            closeSuggestList();
            return;
        }

        var key        = normalize(keyword);
        var sourceList = currentList && currentList.length
            ? currentList
            : (FacilityGrid.getRows ? FacilityGrid.getRows() : []);

        var matched = sourceList.filter(function (row) {
            return matchesCurrentSelectFilters(row) && getFacilitySearchText(row).indexOf(key) > -1;
        });
        var preview = matched.slice(0, SUGGEST_LIMIT);

        if (!preview.length) {
            area.innerHTML = '<div class="suggest-empty">일치하는 시설 후보가 없습니다.</div>';
            area.classList.add("open");
            return;
        }

        area.innerHTML = preview.map(function (row) {
                var facilityNo = row.facilityNo || "-";
                var facilityNm = row.facilityNm || "-";
                var locCn      = row.locCn      || "위치 정보 없음";

                return '<button type="button" class="suggest-item" data-action="selectSuggest" data-keyword="' + escapeHtml(facilityNo) + '">'
                    + '<div class="suggest-main"><span class="suggest-no">' + escapeHtml(facilityNo) + '</span><span>' + escapeHtml(facilityNm) + '</span></div>'
                    + '<div class="suggest-sub">' + escapeHtml(locCn) + '</div>'
                    + '</button>';
            }).join("")
            + (matched.length > SUGGEST_LIMIT
                ? '<div class="suggest-more">외 ' + (matched.length - SUGGEST_LIMIT) + '건 더 있음 · 검색하면 목록에서 전체 확인</div>'
                : "");

        area.classList.add("open");
    }

    function scheduleSuggest() {
        var keyword = document.getElementById("filterKeyword");
        if (!keyword) return;

        clearTimeout(suggestTimer);
        suggestTimer = setTimeout(function () {
            renderSuggestList(keyword.value);
        }, 180);
    }

    /* ── CSV 내보내기 ──────────────────────────────────── */

    function getCodeText(codeMap, code) {
        var entry = codeMap && codeMap[String(code || "").toUpperCase()];
        return entry ? entry[1] : (code || "-");
    }

    function csvValue(value) {
        value = value == null ? "" : String(value);
        return '"' + value.replace(/"/g, '""') + '"';
    }

    function downloadCsv(fileName, headerList, rowList) {
        var lines = [];

        /*
         * Excel 용 구분자 선언
         * 한국어 Windows Excel 에서 CSV 를 열 때 쉼표 구분을 못 잡는 경우 방지
         */
        lines.push("sep=,");
        lines.push(headerList.map(csvValue).join(","));

        rowList.forEach(function (row) {
            lines.push([
                row.facilityNo || "",
                row.facilityNm || "",
                row.facilityKindNm || getFacilityKindText(row.facilityKind),
                row.facilityTyNm || getCodeText(AgRenderer.CODE.FACILITY_TY, row.facilityTyCd),
                row.useYn === "N" ? "사용 불가" : "사용 가능",
                formatDongNo(row.dongNo),
                row.locCn  || "",
                formatDate(row.instlDt) || ""
            ].map(csvValue).join(","));
        });

        var blob = new Blob(["\ufeff" + lines.join("\r\n")], {
            type: "application/vnd.ms-excel;charset=utf-8;"
        });
        var url  = URL.createObjectURL(blob);
        var link = document.createElement("a");

        link.href     = url;
        link.download = fileName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }

    function exportFacilityExcel() {
        if (!currentList || currentList.length === 0) {
            alertMessage("다운로드할 시설 목록이 없습니다.");
            return;
        }

        downloadCsv("시설자산_목록.xls", [
            "시설번호", "시설명", "시설종류", "시설유형", "운영상태", "동", "상세위치", "설치일자"
        ], currentList);
    }

    /* ── 필터 초기화 ───────────────────────────────────── */

    function resetSearch() {
        document.getElementById("filterFacTy").value   = "";
        if (document.getElementById("filterDong"))  document.getElementById("filterDong").value  = "";
        if (document.getElementById("filterUseYn")) document.getElementById("filterUseYn").value = "";
        document.getElementById("filterKeyword").value  = "";
        closeSuggestList();
        FacilityGrid.reset();
        loadFacilityList();
    }

    /* ── 이벤트 바인딩 ─────────────────────────────────── */

    function bindClickEvents() {
        page.addEventListener("click", function (e) {
            var btn = e.target.closest("[data-action]");
            if (!btn) return;

            var action = btn.dataset.action;

            if (action === "openRegister")   FacilityModal.openRegisterModal();
            if (action === "searchFacility") loadFacilityList();
            if (action === "resetFacility")  resetSearch();
            if (action === "setFacilityTab") setFacilityTab(btn.dataset.kind);
            if (action === "exportExcel")    exportFacilityExcel();
            if (action === "selectSuggest") {
                document.getElementById("filterKeyword").value = btn.dataset.keyword || "";
                closeSuggestList();
                loadFacilityList();
            }
            if (action === "openCorrection") FacilityModal.openCorrection();
            if (action === "detail") {
                loadFacilityDetail(btn.dataset.rowKey);
            }
            if (action === "edit") {
                if (isAdmin) {
                    alertMessage("관리자는 조회만 가능합니다.");
                    return;
                }
                FacilityModal.openEditModal(btn.dataset.rowKey);
            }
            if (action === "goPublicFacility") {
                if (confirm("편의시설 정보는 편의시설 관리 화면에서 수정합니다. 이동하시겠습니까?")) {
                    location.href = contextPath + "/manager/publicFacilityList";
                }
            }
            if (action === "editFromDetail") {
                closeModal("facilityDetailModal");
                FacilityModal.openEditModal(btn.dataset.facilityNo || btn.dataset.rowKey);
            }
        });
    }

    function bindSearchEvents() {
        page.addEventListener("change", function (event) {

            /* 위치구분·동·층·호 관련 change 는 FacilityModal 에 위임 */
            if (["locationType", "dongNo", "facilityFloor", "facilityHo"].indexOf(event.target.id) > -1) {
                FacilityModal.handleChange(event);
                return;
            }

            /*
             * 시설유형 필터 변경
             * - 전체시설 탭에서 "편의시설" 선택 시 탭 전환
             */
            if (event.target.id === "filterFacTy") {
                if (currentFacilityKind === "ALL" && event.target.value === "_PUBLIC_") {
                    setFacilityTab("PUBLIC");
                    return;
                }
                closeSuggestList();
                loadFacilityList();
                return;
            }

            if (["filterUseYn", "filterDong"].indexOf(event.target.id) > -1) {
                closeSuggestList();
                loadFacilityList();
            }
        });

        page.addEventListener("input", function (event) {
            if (event.target.id === "filterKeyword") scheduleSuggest();
        });

        page.addEventListener("focusin", function (event) {
            if (event.target.id === "filterKeyword") scheduleSuggest();
        });

        page.addEventListener("keyup", function (e) {
            if (e.target.id === "filterKeyword") {
                if (e.key === "Enter")  { closeSuggestList(); loadFacilityList(); }
                if (e.key === "Escape") { closeSuggestList(); }
            }
        });

        document.addEventListener("click", function (event) {
            if (!event.target.closest(".facility-search-field")) closeSuggestList();
        });
    }

    function bindFileEvents() {
        var fileInput       = document.getElementById("facilityFiles");
        var previewArea     = document.getElementById("facilityFilePreview");
        var deleteFileUuids = document.getElementById("deleteFileUuids");
        var useYnToggle     = document.getElementById("useYnToggle");
        var useYnHidden     = document.getElementById("useYn");

        if (useYnToggle && useYnHidden) {
            useYnToggle.addEventListener("change", function () {
                setUseYnValue(useYnToggle.checked ? "Y" : "N");
            });
        }

        if (fileInput && previewArea) {
            fileInput.addEventListener("change", function () {
                previewArea.innerHTML = "";

                if (!fileInput.files || fileInput.files.length === 0) {
                    previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
                    return;
                }

                Array.from(fileInput.files).forEach(function (file) {
                    var item       = document.createElement("div");
                    item.className = "file-preview-item";

                    if (file.type && file.type.indexOf("image/") === 0) {
                        var img = document.createElement("img");
                        img.alt = file.name;
                        img.src = URL.createObjectURL(file);
                        item.appendChild(img);
                    }

                    var name         = document.createElement("div");
                    name.className   = "file-preview-name";
                    name.textContent = file.name;
                    item.appendChild(name);

                    previewArea.appendChild(item);
                });
            });
        }

        document.addEventListener("change", function (event) {
            if (!event.target.classList.contains("js-delete-file-check")) return;

            var checkedValues = Array.from(document.querySelectorAll(".js-delete-file-check:checked"))
                .map(function (checkbox) { return checkbox.value; })
                .filter(function (value) { return value != null && value !== ""; });

            if (deleteFileUuids) deleteFileUuids.value = checkedValues.join(",");
        });
    }

    function bindEvents() {
        bindClickEvents();
        bindSearchEvents();
        bindFileEvents();
        form.addEventListener("submit", FacilityModal.saveFacility);
        window.addEventListener("resize", function () { FacilityGrid.refreshSize(); });
    }

    /* ── 초기화 ────────────────────────────────────────── */

    async function init() {
        page = document.getElementById("facilityPage");

        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        form = document.getElementById("facilityForm");

        FacilityGrid.init("facilityGrid");
        updateFacilityTabs();

        bindEvents();

        await renderFacilityTypeFilter();
        await loadFacilityList();
    }

    document.addEventListener("DOMContentLoaded", init);

})();
