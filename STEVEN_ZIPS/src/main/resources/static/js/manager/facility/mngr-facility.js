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
 * ============================================================
 */

(function () {

    /* ── 페이지 공통 변수 ──────────────────────────────── */
    var page          = null;   // facilityPage 루트 요소
    var form          = null;   // facilityForm 폼 요소
    var correctionBtn = null;   // 시설유형 정정 버튼

    var currentFacilityNo = null; // 현재 열린 모달의 시설번호
    var currentFacility   = null; // 현재 열린 모달의 시설 VO
    var currentList       = [];   // 목록 조회 결과 캐시 (자동완성용)
    var suggestTimer      = null; // 자동완성 디바운스 타이머
    var SUGGEST_LIMIT     = 5;    // 자동완성 최대 표시 건수

    /* 시설유형 정정 상태 */
    var correctionUnlocked = false; // 잠금해제 여부 (서버 검증 통과 시 true)

    /* facilityPageConfig: JSP에서 주입 */
    var config      = window.facilityPageConfig || {};
    var contextPath = config.contextPath || "";   // 컨텍스트 경로
    var mgmtOfcNo   = config.mgmtOfcNo   || "";  // 관리사무소 번호

    /* 현재 선택된 시설종류 탭: FACILITY(일반시설) / PUBLIC(편의시설) */
    var currentFacilityKind = "FACILITY";

    /*
     * ADMIN 여부 판별
     * JSP의 sec:authorize 결과는 Boolean / "true" 두 형태 모두 가능
     */
    var isAdmin = config.isAdmin === true || config.isAdmin === "true";

    /* ── API 유틸 ─────────────────────────────────────── */

    /* API 경로 조합 */
    function apiUrl(path) {
        return contextPath + "/manager/facility/" + path;
    }

    /* CSRF 토큰 헤더 */
    function getCsrfHeaders() {
        var tokenMeta  = document.querySelector('meta[name="_csrf"]');        // CSRF 토큰값
        var headerMeta = document.querySelector('meta[name="_csrf_header"]'); // CSRF 헤더명
        var headers    = {};

        if (tokenMeta && headerMeta) {
            headers[headerMeta.getAttribute("content")] = tokenMeta.getAttribute("content");
        }

        return headers;
    }

    /* 알림 메시지 (공통 showAlert 함수 우선, 없으면 alert) */
    function alertMessage(message) {
        if (typeof showAlert === "function") {
            showAlert(message);
            return;
        }
        alert(message);
    }

    /* 공통 fetch 래퍼 (JSON 응답 기준) */
    async function requestJson(url, options) {
        var response    = await fetch(url, options || {});
        var contentType = response.headers.get("content-type") || ""; // 응답 Content-Type
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

    /* multipart/form-data 전송 (파일 업로드용) */
    function postForm(url, formData) {
        return requestJson(url, {
            method:  "POST",
            headers: getCsrfHeaders(),
            body:    formData
        });
    }

    /* ── 화면 유틸 ─────────────────────────────────────── */

    /* XSS 방지 HTML 이스케이프 */
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

    /* 공통코드 맵 기준 배지 생성 */
    function codeBadge(codeMap, code) {
        var entry = codeMap && codeMap[String(code || "").toUpperCase()]; // 코드 맵 항목
        return entry ? badge(entry[0], entry[1]) : badge("badge-gray", code || "-");
    }

    /* USE_YN 배지 */
    function useYnBadge(useYn) {
        return useYn === "N"
            ? badge("badge-use-n", "사용 불가")
            : badge("badge-use-y", "사용 가능");
    }

    /* 검침 연결 여부 배지 */
    function meterLinkedBadge(yn) {
        return yn === "Y"
            ? badge("badge-teal", "연결")
            : badge("badge-gray", "미연결");
    }

    /* 상세 항목 HTML (라벨 + 값) */
    function detailItem(label, value) {
        return '<div class="mngr-detail-item">'
            + '<div class="mngr-detail-label">' + escapeHtml(label) + '</div>'
            + '<div class="mngr-detail-value">' + (value == null || value === "" ? "-" : value) + '</div>'
            + '</div>';
    }

    /* Date/String → yyyy-MM-dd 형식 */
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

        if (hidden) hidden.value = normalized;
        if (toggle) toggle.checked = normalized === "Y";
        if (statusText) {
            statusText.textContent = normalized === "Y" ? "사용 가능" : "사용 불가";
            statusText.classList.toggle("is-off", normalized === "N");
        }
    }

    /* 상세 조회 결과에서 시설 VO 추출 */
    function getResultFacility(result) {
        return result.detail || result.facility || result || {};
    }

    /* 시설종류 코드 → 화면 표시명 */
    function getFacilityKindText(kind) {
        return kind === "PUBLIC" ? "편의시설" : "일반시설";
    }

    /* 시설종류 탭 활성화 표시 */
    function updateFacilityTabs() {
        var buttons = page ? page.querySelectorAll(".facility-tab-btn") : [];

        buttons.forEach(function (button) {
            button.classList.toggle("active", button.dataset.kind === currentFacilityKind);
        });
    }

    /* 시설종류 탭 변경 */
    function setFacilityTab(kind) {
        currentFacilityKind = kind === "PUBLIC" ? "PUBLIC" : "FACILITY";
        updateFacilityTabs();
        closeSuggestList();
        FacilityGrid.reset();
        loadFacilityList();
    }

    /* ── 검색 ──────────────────────────────────────────── */

    /* 검색 조건 URLSearchParams 구성 */
    function collectSearchParam() {
        var params = new URLSearchParams();

        params.append("facilityKind", currentFacilityKind); // 상단 탭 기준 시설종류

        var facilityTyCd = document.getElementById("filterFacTy").value;                         // 시설유형
        var useYn        = document.getElementById("filterUseYn")  ? document.getElementById("filterUseYn").value  : ""; // 사용여부
        var dongNo       = document.getElementById("filterDong")    ? document.getElementById("filterDong").value   : ""; // 동번호
        var keyword      = document.getElementById("filterKeyword").value.trim();                  // 통합 검색어

        if (facilityTyCd) params.append("facilityTyCd", facilityTyCd);
        if (useYn)        params.append("useYn",        useYn);
        if (dongNo)       params.append("dongNo",       dongNo);
        if (keyword)      params.append("keyword",      keyword);

        return params;
    }

    /* 검색 조건 요약 텍스트 (목록 헤더 표시용) */
    function getFilterSummaryText() {
        var labels     = ["시설종류: " + getFacilityKindText(currentFacilityKind)];
        var facilityTy = document.getElementById("filterFacTy");  // 시설유형 셀렉트
        var useYn      = document.getElementById("filterUseYn");   // 사용여부 셀렉트
        var dong       = document.getElementById("filterDong");    // 동 셀렉트
        var keyword    = document.getElementById("filterKeyword").value.trim(); // 검색어

        if (facilityTy && facilityTy.value) labels.push("시설유형: " + facilityTy.options[facilityTy.selectedIndex].text);
        if (useYn      && useYn.value)      labels.push("운영상태: " + useYn.options[useYn.selectedIndex].text);
        if (dong       && dong.value)       labels.push("동: "      + dong.options[dong.selectedIndex].text);
        if (keyword)                        labels.push("검색어: "   + keyword);

        return labels.length ? labels.join(" · ") : "전체 조건";
    }

    /* 목록 헤더 건수 + 조건 텍스트 갱신 */
    function updateListHeader(count) {
        document.getElementById("facilityCount").textContent = (count || 0) + "건";
        document.getElementById("resultDesc").textContent    = getFilterSummaryText();
    }

    /* 현황 카드 갱신 */
    function updateStats(list, stats) {
        stats = stats || {};
        list  = list  || [];

        var dongCnt = stats.dongCnt != null
            ? stats.dongCnt
            : list.filter(function (row) {
                return row.dongNo && row.dongNo !== "공용";
            }).length;

        var commonLocCnt = stats.commonLocCnt != null
            ? stats.commonLocCnt
            : list.filter(function (row) {
                return !row.dongNo || row.dongNo === "공용";
            }).length;

        var disabledTotal = stats.disabledTotal != null
            ? stats.disabledTotal
            : list.filter(function (row) { return row.useYn === "N"; }).length;

        var disabledToday = stats.disabledToday != null ? Number(stats.disabledToday) : null;

        if (document.getElementById("statDong")) {
            document.getElementById("statDong").textContent = dongCnt;
        }
        if (document.getElementById("statCommonLoc")) {
            document.getElementById("statCommonLoc").textContent = commonLocCnt;
        }
        if (document.getElementById("statDisabled")) {
            document.getElementById("statDisabled").textContent = disabledTotal;

            var todayEl = document.getElementById("statDisabledToday");
            if (todayEl) {
                todayEl.textContent = disabledToday != null && disabledToday > 0
                    ? "오늘 " + disabledToday + "건 추가"
                    : "";
            }
        }
    }

    /* 탭과 무관한 전체 시설 총수 카드 갱신 */
    function updateTotalFacilityCount(list) {
        document.getElementById("statTotal").textContent = (list || []).length;
    }

    /* 탭과 무관한 전체 시설 총수 조회 */
    async function loadTotalFacilityCount() {
        try {
            var params = collectSearchParam();
            params.set("facilityKind", "ALL");

            var url = apiUrl("list/" + encodeURIComponent(mgmtOfcNo));
            var queryString = params.toString();

            if (queryString) {
                url += "?" + queryString;
            }

            var result = await getJson(url);
            var list = result.list || result.facilityList || [];

            updateTotalFacilityCount(list);
        } catch (e) {
            console.error(e);
        }
    }

    /* ── 목록 조회 ─────────────────────────────────────── */

    async function loadFacilityList() {
        var params = collectSearchParam();                                       // 검색 조건
        var url    = apiUrl("list/" + encodeURIComponent(mgmtOfcNo));           // 목록 API URL

        if (params.toString()) {
            url += "?" + params.toString();
        }

        try {
            var result = await getJson(url);
            var list   = result.list || result.facilityList || []; // 시설 목록

            currentList = list;
            FacilityGrid.setRows(list);
            updateListHeader(list.length);
            updateStats(list, result.stats || {});
            await loadTotalFacilityCount();
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
            openDetailModal(result);
        } catch (e) {
            console.error(e);
            alertMessage(e.message || "시설 상세 조회 중 오류가 발생했습니다.");
        }
    }

    /* ── 수정 모드 ─────────────────────────────────────── */

    /**
     * 수정 모드 진입/해제
     *
     * is-edit-mode 클래스 토글로 JSP CSS가 잠금 문구 표시/숨김 처리
     * 시설유형 드롭다운은 기본 잠금 → 정정 버튼 클릭 후 서버 검증 통과 시 해제
     */
    function setEditMode(isEdit) {
        page.classList.toggle("is-edit-mode", isEdit);

        /* 시설유형: 수정 모드 진입 시 잠금, 해제 모드 시 활성화 */
        document.getElementById("facilityTyCd").disabled = isEdit;

        page.classList.remove("is-correction-unlocked");

        /* 정정 버튼: CSS .correction-inline-btn으로 표시/숨김 제어하므로 JS style 조작 불필요 */
        if (correctionBtn) {
            correctionBtn.style.display = "";  // CSS is-edit-mode 클래스로 제어
        }

        /* 수정 모드 나갈 때 정정 잠금 초기화 */
        if (!isEdit) {
            correctionUnlocked = false;
        }
    }

    /* ── 파일 영역 초기화 ──────────────────────────────── */

    function clearFileAreas() {
        var fileInput      = document.getElementById("facilityFiles");          // 파일 input
        var previewArea    = document.getElementById("facilityFilePreview");    // 신규 미리보기 영역
        var manageArea     = document.getElementById("facilityFileManageList"); // 기존 파일 관리 영역
        var deleteFileUuids = document.getElementById("deleteFileUuids");       // 삭제 UUID hidden

        if (fileInput)       fileInput.value = "";
        if (deleteFileUuids) deleteFileUuids.value = "";
        if (previewArea)     previewArea.innerHTML  = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
        if (manageArea)      manageArea.innerHTML   = '<div class="file-preview-empty">기존 등록 사진은 상세 조회 후 수정 모드에서 표시됩니다.</div>';
    }

    /* 폼 전체 초기화 */
    function clearForm() {
        form.reset();
        currentFacilityNo  = null;
        currentFacility    = null;
        correctionUnlocked = false;

        document.getElementById("facilityNo").value    = "";
        document.getElementById("fileGroupNo").value   = "";
        document.getElementById("useYn").value         = "Y";
        setUseYnValue("Y");
        page.classList.remove("is-correction-unlocked");

        var correctionGuide = document.getElementById("correctionGuide");
        if (correctionGuide) correctionGuide.style.display = "none";

        clearFileAreas();
    }

    /* ── 등록 모달 ─────────────────────────────────────── */

    function openRegisterModal() {
        /* ADMIN 직접 호출 방어 (JSP에서 버튼 숨김과 별개로 한 번 더 차단) */
        if (isAdmin) {
            alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        clearForm();
        document.getElementById("facilityModalTitle").textContent = "시설 등록";
        setEditMode(false);
        openModal("facilityModal");
    }

    /* ── 수정 모달 ─────────────────────────────────────── */

    /* 수정 폼에 기존 시설 정보 채우기 */
    function fillFacilityForm(facility) {
        document.getElementById("facilityNo").value    = facility.facilityNo    || "";
        document.getElementById("facilityNm").value    = facility.facilityNm    || "";
        document.getElementById("facilityTyCd").value  = facility.facilityTyCd  || "";
        document.getElementById("instlDt").value       = formatDate(facility.instlDt);
        document.getElementById("dongNo").value        = facility.dongNo        || "";
        document.getElementById("locCn").value         = facility.locCn         || "";
        document.getElementById("fileGroupNo").value   = facility.fileGroupNo   || "";
        document.getElementById("useYn").value         = facility.useYn         || "Y";

        setUseYnValue(facility.useYn || "Y");
    }

    async function openEditModal(facilityNo) {
        /* ADMIN 직접 호출 방어 */
        if (isAdmin) {
            alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        try {
            var url      = apiUrl("detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo));
            var result   = await getJson(url);
            var facility = getResultFacility(result); // 시설 상세 VO

            clearForm();
            currentFacilityNo = facility.facilityNo;
            currentFacility   = facility;

            document.getElementById("facilityModalTitle").textContent = "시설 수정";
            fillFacilityForm(facility);
            renderManageFiles(result.fileList || result.attachFileList || facility.fileList || []);
            setEditMode(true);
            openModal("facilityModal");
        } catch (e) {
            console.error(e);
            alertMessage(e.message || "시설 수정 정보 조회 중 오류가 발생했습니다.");
        }
    }

    /* ── 저장 ──────────────────────────────────────────── */

    /* 등록·수정 공통 FormData 구성 */
    function makeFacilityFormData() {
        var formData        = new FormData(form);
        var useYnHidden     = document.getElementById("useYn");          // 사용여부 hidden
        var deleteFileUuids = document.getElementById("deleteFileUuids"); // 삭제 UUID hidden

        if (useYnHidden) {
            formData.set("useYn", useYnHidden.value || "Y");
        }

        if (currentFacilityNo) {
            formData.set("facilityNo", currentFacilityNo);
        }

        /* 파일그룹번호: 기존 시설에 사진이 있을 때만 전달 */
        if (currentFacility && currentFacility.fileGroupNo) {
            formData.set("fileGroupNo", currentFacility.fileGroupNo);
        } else {
            formData.delete("fileGroupNo");
        }

        if (!formData.get("instlDt")) {
            formData.delete("instlDt");
        }

        /* 삭제할 기존 사진 UUID 목록 (쉼표 구분) */
        if (deleteFileUuids) {
            formData.set("deleteFileUuids", deleteFileUuids.value || "");
        }

        return formData;
    }

    async function saveFacility(e) {
        e.preventDefault();

        /* ADMIN 저장 요청 차단 */
        if (isAdmin) {
            alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        var facilityNm   = document.getElementById("facilityNm").value.trim(); // 시설명
        var facilityTyCd = document.getElementById("facilityTyCd").value;       // 시설유형
        var isEdit       = !!currentFacilityNo;                                 // 수정 여부

        if (!facilityNm) {
            alertMessage("시설명을 입력하세요.");
            return;
        }

        if (!isEdit && !facilityTyCd) {
            alertMessage("시설유형을 선택하세요.");
            return;
        }

        try {
            var formData = makeFacilityFormData();

            if (isEdit && correctionUnlocked) {
                /*
                 * 시설유형 정정 모드
                 * openCorrection에서 잠금 해제 후 저장 버튼 클릭 시 진입
                 * 일반 수정 API가 아닌 정정 전용 API로 호출
                 */
                await postJson(
                    apiUrl("type/correct/" + encodeURIComponent(mgmtOfcNo)),
                    {
                        facilityNo:   currentFacilityNo, // 정정 대상 시설번호
                        facilityTyCd: facilityTyCd        // 변경할 시설유형코드
                    }
                );
                alertMessage("시설유형이 정정되었습니다.");
            } else if (isEdit) {
                /* 일반 수정 */
                await postForm(apiUrl("update/" + encodeURIComponent(mgmtOfcNo)), formData);
                alertMessage("시설 정보가 수정되었습니다.");
            } else {
                /* 신규 등록 */
                await postForm(apiUrl("insert/" + encodeURIComponent(mgmtOfcNo)), formData);
                alertMessage("시설이 등록되었습니다.");
            }

            closeModal("facilityModal");
            setEditMode(false);
            await loadFacilityList();
        } catch (e) {
            console.error(e);
            alertMessage(e.message || "저장 중 오류가 발생했습니다.");
        }
    }

    /* ── 시설유형 정정 ─────────────────────────────────── */

    /**
     * 시설유형 정정 버튼 클릭 처리
     *
     * 1단계: 잠금 상태
     *        → GET /type/correct/check/{mgmtOfcNo}/{facilityNo} 로 연결 데이터 검증
     *        → 연결 데이터 없으면 facilityTyCd 드롭다운 잠금 해제 + 안내 문구 표시
     *        → 연결 데이터 있으면 변경 불가 메시지 표시
     *
     * 2단계: 잠금해제 상태
     *        → 저장 버튼 클릭 시 POST /type/correct/{mgmtOfcNo} 로 실제 정정 처리
     *        → saveFacility 내부에서 correctionUnlocked 플래그 기준으로 분기
     */
    async function openCorrection() {
        /* ADMIN 차단 */
        if (isAdmin) {
            alertMessage("관리자는 조회만 가능합니다.");
            return;
        }

        if (!currentFacilityNo) return;

        /* 이미 잠금해제 상태면 안내만 표시 */
        if (correctionUnlocked) {
            alertMessage("시설유형 드롭다운에서 변경할 유형을 선택하고 저장하세요.");
            return;
        }

        try {
            /*
             * 정정 가능 여부 조회 (GET)
             * 실제 변경 없이 연결 데이터 존재 여부만 확인
             * 연결 데이터 있으면 success: false 반환
             */
            var checkUrl = apiUrl(
                "type/correct/check/"
                + encodeURIComponent(mgmtOfcNo)
                + "/"
                + encodeURIComponent(currentFacilityNo)
            ); // 정정 가능 여부 조회 URL

            var result = await getJson(checkUrl); // 조회 결과

            if (!result.success) {
                /* 연결 데이터 있음: 정정 불가 */
                alertMessage(result.message || "계약·점검·검침 데이터가 연결된 시설은 시설유형을 변경할 수 없습니다.");
                return;
            }

            /* 연결 데이터 없음: 드롭다운 잠금 해제 */
            correctionUnlocked = true;
            document.getElementById("facilityTyCd").disabled = false;
            page.classList.add("is-correction-unlocked");

            /* 정정 안내 문구 표시 */
            var guideEl = document.getElementById("correctionGuide"); // 정정 안내 문구 요소
            if (guideEl) guideEl.style.display = "";

            alertMessage(result.message || "정정 가능한 시설입니다. 변경할 시설유형을 선택하고 저장하세요.");

        } catch (e) {
            console.error(e);
            alertMessage(e.message || "시설유형 정정 가능 여부 확인 중 오류가 발생했습니다.");
        }
    }

    /* ── 상세 모달 ─────────────────────────────────────── */

    function openDetailModal(result) {
        var facility = getResultFacility(result);       // 시설 VO
        var contract = result.latestContract  || null;  // 최근 계약 1건
        var checks   = result.recentCheckList || [];    // 최근 점검이력 3건
        var meter    = result.meterInfo       || null;  // 검침 연결 정보

        /* 이용불가 사유 섹션 */
        var disabledSec = document.getElementById("detailDisabledSection"); // 이용불가 섹션
        if (disabledSec) {
            if (facility.useYn === "N" && facility.latestFaultDt) {
                disabledSec.style.display = "";

                var chkUrl    = contextPath + "/manager/checkHistory?facilityNo=" + encodeURIComponent(facility.facilityNo);
                var faultDate = formatDate(facility.latestFaultDt);                            // 이상발견 점검일자
                var faultType = escapeHtml(facility.latestFaultTyCd || "점검");               // 이상발견 점검유형

                var reasonEl = document.getElementById("detailDisabledReason"); // 이용불가 사유 요소
                if (reasonEl) {
                    reasonEl.innerHTML = '<strong>' + faultDate + ' · ' + faultType + ' · 이상발견</strong>'
                        + ' 으로 이용불가 처리되었습니다.'
                        + '<a href="' + chkUrl + '">점검이력에서 확인 &rarr;</a>';
                }
            } else {
                disabledSec.style.display = "none";
            }
        }

        /* 기본정보 그리드 */
        document.getElementById("detailModalTitle").textContent = (facility.facilityNm || "시설") + " · 상세";
        var detailEditBtn = document.getElementById("detailEditBtn"); // 수정하기 버튼
        if (detailEditBtn) detailEditBtn.dataset.facilityNo = facility.facilityNo;

        document.getElementById("detailBasicGrid").innerHTML = ""
            + detailItem("시설번호",       escapeHtml(facility.facilityNo))
            + detailItem("시설명",         escapeHtml(facility.facilityNm))
            + detailItem("시설종류",       badge("badge-teal", facility.facilityKindNm || getFacilityKindText(facility.facilityKind)))
            + detailItem("시설유형",       badge("badge-blue", facility.facilityTyNm || facility.facilityTyCd || "-"))
            + detailItem("운영상태",       useYnBadge(facility.useYn))
            + detailItem("검침 연결 여부", badge("badge-gray", "추후 연동"))
            + detailItem("동",             escapeHtml(formatDongNo(facility.dongNo)))
            + detailItem("상세위치",       escapeHtml(facility.locCn  || "-"))
            + detailItem("설치일자",       escapeHtml(formatDate(facility.instlDt) || "-"));

        renderDetailFiles(result.fileList || result.attachFileList || facility.fileList || []);
        renderLatestContract(contract);
        renderRecentChecks(checks);
        renderMeterInfo(meter);
        openModal("facilityDetailModal");
    }

    /* ── 파일 렌더 ─────────────────────────────────────── */

    /* Google Drive 이미지 URL 추출 */
    function getFileImageUrl(file) {
        if (file.viewUrl)  return file.viewUrl;
        if (file.fileUrl)  return file.fileUrl;
        if (file.googleId) return contextPath + "/file/display/" + encodeURIComponent(file.googleId);
        return "";
    }

    /* 상세 모달 파일 목록 렌더 (읽기전용) */
    function renderDetailFiles(files) {
        var area = document.getElementById("detailFileList"); // 상세 파일 목록 영역
        if (!area) return;

        if (!files || files.length === 0) {
            area.innerHTML = '<div class="file-preview-empty">등록된 사진이 없습니다.</div>';
            return;
        }

        area.innerHTML = files.map(function (file) {
            var imgUrl = getFileImageUrl(file);                             // 이미지 URL
            var name   = file.fileOgName || file.fileSaveUuid || "시설사진"; // 파일명

            return '<div class="file-preview-item">'
                + (imgUrl ? '<img src="' + escapeHtml(imgUrl) + '" alt="' + escapeHtml(name) + '">' : "")
                + '<div class="file-preview-name">' + escapeHtml(name) + '</div>'
                + '</div>';
        }).join("");
    }

    /* 수정 모달 기존 파일 관리 영역 렌더 (삭제 체크박스 포함) */
    function renderManageFiles(files) {
        var area = document.getElementById("facilityFileManageList"); // 기존 파일 관리 영역
        if (!area) return;

        if (!files || files.length === 0) {
            area.innerHTML = '<div class="file-preview-empty">기존 등록 사진이 없습니다.</div>';
            return;
        }

        area.innerHTML = files.map(function (file) {
            var imgUrl = getFileImageUrl(file);
            var name   = file.fileOgName || file.fileSaveUuid || "시설사진"; // 파일명
            var uuid   = file.fileSaveUuid || "";                             // 저장 UUID (삭제 키)

            return '<div class="file-manage-row">'
                + (imgUrl
                    ? '<img class="file-thumb" src="' + escapeHtml(imgUrl) + '" alt="' + escapeHtml(name) + '">'
                    : '<div class="file-thumb"></div>')
                + '<div class="file-info">'
                + '<div class="file-name">' + escapeHtml(name) + '</div>'
                + '<div class="file-meta">' + escapeHtml(file.fileExt || "image") + '</div>'
                + '</div>'
                + '<div class="file-actions">'
                + '<label class="file-delete-check">'
                + '<input type="checkbox" class="js-delete-file-check" value="' + escapeHtml(uuid) + '">삭제'
                + '</label>'
                + '</div>'
                + '</div>';
        }).join("");
    }

    /* ── 상세 섹션 렌더 ────────────────────────────────── */

    /* 최근 계약 1건 렌더 */
    function renderLatestContract(contract) {
        var body = document.getElementById("detailContBody"); // 계약 섹션 body

        if (!contract) {
            body.innerHTML = '<div class="ds-empty">등록된 계약이 없습니다.</div>';
            return;
        }

        body.innerHTML = '<div class="ds-row">'
            + '<span class="ds-no">' + escapeHtml(contract.contNo    || "-") + '</span>'
            + '<span class="ds-nm">' + escapeHtml(contract.contNm    || "-") + '</span>'
            + '<span>'               + codeBadge(AgRenderer.CODE.CONTRACT_STTS, contract.contSttsCd) + '</span>'
            + '<span class="ds-dt">' + escapeHtml(contract.partnerNm || "-") + '</span>'
            + '<span class="ds-dt">' + escapeHtml(formatDate(contract.contEndDt) || "-") + '</span>'
            + '</div>';
    }

    /* 최근 점검이력 3건 렌더 */
    function renderRecentChecks(checks) {
        var body = document.getElementById("detailChkBody"); // 점검이력 섹션 body

        if (!checks || !checks.length) {
            body.innerHTML = '<div class="ds-empty">점검이력이 없습니다.</div>';
            return;
        }

        body.innerHTML = checks.slice(0, 3).map(function (check) {
            return '<div class="ds-row">'
                + '<span class="ds-no">' + escapeHtml(check.facChkHstryNo || "-") + '</span>'
                + '<span class="ds-dt">' + escapeHtml(formatDate(check.chkDt) || "-") + '</span>'
                + '<span>'               + codeBadge(AgRenderer.CODE.CHECK_TY,   check.chkTyCd)   + '</span>'
                + '<span>'               + codeBadge(AgRenderer.CODE.CHECK_STTS, check.chkSttsCd) + '</span>'
                + '<span class="ds-nm" style="font-weight:400;color:#6b7a6e;">'
                +   escapeHtml(check.chkCn || "-")
                + '</span>'
                + '</div>';
        }).join("");
    }

    /* 검침 연결 정보 렌더 */
    function renderMeterInfo(meter) {
        var body = document.getElementById("detailMeterBody"); // 검침 섹션 body

        if (!meter) {
            body.innerHTML = '<div class="ds-empty">검침 연결 정보가 없습니다.</div>';
            return;
        }

        body.innerHTML = '<div class="ds-row">'
            + '<span class="ds-no">' + escapeHtml(meter.meterWrkNo   || meter.meterHstryNo || "-") + '</span>'
            + '<span class="ds-nm">' + escapeHtml(meter.partnerNm    || meter.providerNm   || "검침 연결") + '</span>'
            + '<span>'               + badge("badge-teal", meter.meterTyNm  || meter.meterTyCd  || "검침") + '</span>'
            + '<span>'               + badge("badge-blue", meter.meterMethodNm || meter.meterMethod || "연결") + '</span>'
            + '</div>';
    }

    /* ── 자동완성 ──────────────────────────────────────── */

    /* 소문자 정규화 */
    function normalize(value) {
        return String(value == null ? "" : value).toLowerCase();
    }

    /* 현재 셀렉트 필터 조건과 일치 여부 확인 */
    function matchesCurrentSelectFilters(row) {
        var facilityTyCd = document.getElementById("filterFacTy")  ? document.getElementById("filterFacTy").value  : "";
        var useYn        = document.getElementById("filterUseYn")   ? document.getElementById("filterUseYn").value  : "";
        var dongNo       = document.getElementById("filterDong")    ? document.getElementById("filterDong").value   : "";

        if (row.facilityKind && row.facilityKind !== currentFacilityKind)       return false;
        if (facilityTyCd && row.facilityTyCd !== facilityTyCd)                 return false;
        if (useYn        && row.useYn        !== useYn)                        return false;
        if (dongNo === "_COMMON_" && row.dongNo)                               return false;
        if (dongNo && dongNo !== "_COMMON_" && row.dongNo !== dongNo)          return false;

        return true;
    }

    /* 자동완성 검색 텍스트 생성 (시설번호+시설명+위치) */
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
            if (typeof value === "string" || typeof value === "number") {
                values.push(value);
            }
        });

        return values.map(normalize).join(" ");
    }

    /* 자동완성 목록 닫기 */
    function closeSuggestList() {
        var area = document.getElementById("facilitySuggestList"); // 자동완성 드롭다운
        if (area) {
            area.classList.remove("open");
            area.innerHTML = "";
        }
    }

    /* 자동완성 목록 렌더 */
    function renderSuggestList(keyword) {
        var area = document.getElementById("facilitySuggestList"); // 자동완성 드롭다운
        if (!area) return;

        keyword = String(keyword || "").trim();

        /* 2자 미만이면 자동완성 닫기 */
        if (keyword.length < 2) {
            closeSuggestList();
            return;
        }

        /*
         * 현재 셀렉트 필터 조건 반영 후 키워드 일치 항목 추출
         * 후보 최대 SUGGEST_LIMIT건 표시, 전체 결과는 AG Grid에서 확인
         */
        var key     = normalize(keyword);                                   // 소문자 검색어
        var sourceList = currentList && currentList.length
            ? currentList
            : (FacilityGrid.getRows ? FacilityGrid.getRows() : []);

        var matched = sourceList.filter(function (row) {
            return matchesCurrentSelectFilters(row) && getFacilitySearchText(row).indexOf(key) > -1;
        });
        var preview = matched.slice(0, SUGGEST_LIMIT);                      // 미리보기 목록

        if (!preview.length) {
            area.innerHTML = '<div class="suggest-empty">일치하는 시설 후보가 없습니다.</div>';
            area.classList.add("open");
            return;
        }

        area.innerHTML = preview.map(function (row) {
                var facilityNo = row.facilityNo || "-"; // 시설번호
                var facilityNm = row.facilityNm || "-"; // 시설명
                var locCn      = row.locCn      || "위치 정보 없음"; // 상세위치

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

    /* 자동완성 디바운스 스케줄링 (180ms) */
    function scheduleSuggest() {
        var keyword = document.getElementById("filterKeyword"); // 검색어 input
        if (!keyword) return;

        clearTimeout(suggestTimer);
        suggestTimer = setTimeout(function () {
            renderSuggestList(keyword.value);
        }, 180);
    }

    /* ── CSV 내보내기 ──────────────────────────────────── */

    /* 공통코드 맵에서 텍스트 추출 */
    function getCodeText(codeMap, code) {
        var entry = codeMap && codeMap[String(code || "").toUpperCase()]; // 코드 맵 항목
        return entry ? entry[1] : (code || "-");
    }

    /* CSV 셀값 이스케이프 */
    function csvValue(value) {
        value = value == null ? "" : String(value);
        return '"' + value.replace(/"/g, '""') + '"';
    }

    /* CSV 파일 다운로드 */
    function downloadCsv(fileName, headerList, rowList) {
        var lines = [];

        /*
         * Excel용 구분자 선언
         * - 한국어 Windows Excel에서 CSV를 열 때 쉼표 구분을 못 잡는 경우가 있어서 추가
         * - 이 줄이 있으면 Excel이 쉼표(,) 기준으로 컬럼을 나눠서 읽음
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

        /*
         * 브라우저에서 직접 CSV 생성
         * BOM(\ufeff) 추가로 엑셀 한글 깨짐 방지
         */
        var blob = new Blob(["\ufeff" + lines.join("\r\n")], {
            type: "application/vnd.ms-excel;charset=utf-8;"
        });
        var url  = URL.createObjectURL(blob);  // Blob URL
        var link = document.createElement("a");

        link.href     = url;
        link.download = fileName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(url);
    }

    /* 현재 목록 CSV 내보내기 */
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
        document.getElementById("filterFacTy").value = "";
        if (document.getElementById("filterDong"))   document.getElementById("filterDong").value   = "";
        if (document.getElementById("filterUseYn"))  document.getElementById("filterUseYn").value  = "";
        document.getElementById("filterKeyword").value = "";
        closeSuggestList();
        FacilityGrid.reset();
        loadFacilityList();
    }

    /* ── 이벤트 바인딩 ─────────────────────────────────── */

    function bindClickEvents() {
        page.addEventListener("click", function (e) {

            var btn = e.target.closest("[data-action]"); // 클릭된 액션 버튼
            if (!btn) return;

            var action = btn.dataset.action; // 액션 코드

            if (action === "openRegister")   openRegisterModal();
            if (action === "searchFacility") loadFacilityList();
            if (action === "resetFacility")  resetSearch();
            if (action === "setFacilityTab") setFacilityTab(btn.dataset.kind);
            if (action === "exportExcel")    exportFacilityExcel();
            if (action === "selectSuggest") {
                document.getElementById("filterKeyword").value = btn.dataset.keyword || "";
                closeSuggestList();
                loadFacilityList();
            }
            if (action === "openCorrection") openCorrection();
            if (action === "detail") {
                loadFacilityDetail(btn.dataset.rowKey);
            }
            if (action === "edit") {
                if (isAdmin) {
                    alertMessage("관리자는 조회만 가능합니다.");
                    return;
                }
                openEditModal(btn.dataset.rowKey);
            }
            if (action === "editFromDetail") {
                closeModal("facilityDetailModal");
                openEditModal(btn.dataset.facilityNo || btn.dataset.rowKey);
            }
        });
    }

    /* 검색 셀렉트 자동 조회 + 키워드 자동완성 이벤트 */
    function bindSearchEvents() {
        page.addEventListener("change", function (event) {
            if (["filterFacTy", "filterUseYn", "filterDong"].indexOf(event.target.id) > -1) {
                closeSuggestList();
                loadFacilityList();
            }
        });

        page.addEventListener("input", function (event) {
            if (event.target.id === "filterKeyword") {
                scheduleSuggest();
            }
        });

        page.addEventListener("focusin", function (event) {
            if (event.target.id === "filterKeyword") {
                scheduleSuggest();
            }
        });

        page.addEventListener("keyup", function (e) {
            if (e.target.id === "filterKeyword") {
                if (e.key === "Enter")  { closeSuggestList(); loadFacilityList(); }
                if (e.key === "Escape") { closeSuggestList(); }
            }
        });

        /* 검색 영역 외 클릭 시 자동완성 닫기 */
        document.addEventListener("click", function (event) {
            if (!event.target.closest(".facility-search-field")) closeSuggestList();
        });
    }

    /* 파일 업로드 + 사용여부 변경 이벤트 */
    function bindFileEvents() {
        var fileInput       = document.getElementById("facilityFiles");          // 파일 input
        var previewArea     = document.getElementById("facilityFilePreview");    // 신규 미리보기 영역
        var deleteFileUuids = document.getElementById("deleteFileUuids");        // 삭제 UUID hidden
        var useYnToggle     = document.getElementById("useYnToggle");            // 사용여부 토글
        var useYnHidden     = document.getElementById("useYn");                  // 사용여부 hidden

        /* 사용여부 토글 → hidden 동기화 */
        if (useYnToggle && useYnHidden) {
            useYnToggle.addEventListener("change", function () {
                setUseYnValue(useYnToggle.checked ? "Y" : "N");
            });
        }

        /* 파일 선택 → 미리보기 렌더 */
        if (fileInput && previewArea) {
            fileInput.addEventListener("change", function () {
                previewArea.innerHTML = "";

                if (!fileInput.files || fileInput.files.length === 0) {
                    previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
                    return;
                }

                Array.from(fileInput.files).forEach(function (file) {
                    var item = document.createElement("div");
                    item.className = "file-preview-item";

                    if (file.type && file.type.indexOf("image/") === 0) {
                        var img   = document.createElement("img");
                        img.alt   = file.name;
                        img.src   = URL.createObjectURL(file); // Blob 미리보기 URL
                        item.appendChild(img);
                    }

                    var name       = document.createElement("div");
                    name.className = "file-preview-name";
                    name.textContent = file.name;
                    item.appendChild(name);

                    previewArea.appendChild(item);
                });
            });
        }

        /* 기존 파일 삭제 체크박스 → deleteFileUuids hidden 동기화 */
        document.addEventListener("change", function (event) {
            if (!event.target.classList.contains("js-delete-file-check")) return;

            var checkedValues = Array.from(document.querySelectorAll(".js-delete-file-check:checked"))
                .map(function (checkbox) { return checkbox.value; })
                .filter(function (value) { return value != null && value !== ""; }); // 빈값 제외

            if (deleteFileUuids) {
                deleteFileUuids.value = checkedValues.join(",");
            }
        });
    }

    function bindEvents() {
        bindClickEvents();
        bindSearchEvents();
        bindFileEvents();
        form.addEventListener("submit", saveFacility);
        window.addEventListener("resize", function () { FacilityGrid.refreshSize(); });
    }

    /* ── 초기화 ────────────────────────────────────────── */

    function init() {
        page = document.getElementById("facilityPage"); // 페이지 루트

        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        form          = document.getElementById("facilityForm");          // 폼
        correctionBtn = document.getElementById("facilityCorrectionBtn"); // 시설유형 정정 버튼

        FacilityGrid.init("facilityGrid");
        updateFacilityTabs();

        bindEvents();
        loadFacilityList();
    }

    document.addEventListener("DOMContentLoaded", init);

})();
