<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설 등록</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        /* 시설 등록 화면 전용 색상 */
        #facilityPage { --accent:#2e5c38; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --line:#d7dce2; --text-head:#1a2e1e; }

        /* 상단 제목 */
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }

        /* 패널 */
        #facilityPage .panel { margin:0; border:1px solid var(--line); border-radius:6px; box-shadow:none; }
        #facilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #facilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }

        /* 폼 요소 */
        #facilityPage .panel-body .form-input,
        #facilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #facilityPage .panel-body .form-input:focus,
        #facilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #facilityPage .panel-body .form-input:disabled,
        #facilityPage .panel-body .form-select:disabled { background:#f5f6f5; color:#aab4ac; cursor:not-allowed; }

        /* 버튼 */
        #facilityPage .btn { border-radius:4px; }
        #facilityPage .btn-primary { background:var(--accent); }
        #facilityPage .btn-primary:hover { background:#1a3d1f; }

        /* 안내/경고 박스 */
        #facilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:#4a5c4e; line-height:1.6; }
        #facilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #facilityPage .warn-inline { display:flex; align-items:flex-start; gap:7px; padding:8px 11px; margin-top:6px; margin-bottom:2px; background:#fffbf0; border:1px solid #e8c84a; border-left:3px solid #c9900a; border-radius:0 4px 4px 0; font-size:11px; color:#7a5c00; line-height:1.6; }
        #facilityPage .warn-inline .material-symbols-rounded { font-size:15px; color:#c9900a; flex-shrink:0; margin-top:1px; }
        #facilityPage .warn-inline strong { color:#5a3d00; }

        /* 좌우 컬럼 */
        #facilityPage .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        #facilityPage .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line); }
        #facilityPage .facility-modal-col-right { padding-left:20px; }
        #facilityPage .facility-col-label { margin-bottom:14px; padding-bottom:8px; border-bottom:1px solid var(--line); font-size:11px; font-weight:800; color:#8a9a8e; letter-spacing:.5px; text-transform:uppercase; }
        #facilityPage .form-section-title { display:flex; align-items:center; gap:4px; margin-bottom:10px; font-size:11px; font-weight:800; color:#4a5c4e; }
        #facilityPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }

        /* 파일 업로드 */
        #facilityPage .file-upload-box { padding:12px; border:1px dashed var(--line); border-radius:4px; background:#fafcfb; }
        #facilityPage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:800; color:#4a5c4e; }
        #facilityPage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #facilityPage .file-upload-desc { font-size:11px; color:#7a8a7d; line-height:1.5; }
        #facilityPage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #facilityPage .file-preview-item { min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #facilityPage .file-preview-item img { width:100%; height:92px; object-fit:contain; display:block; background:#f8fafc; }
        #facilityPage .file-preview-name { padding:6px 7px; border-top:1px solid var(--line); font-size:11px; color:#4a5c4e; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #facilityPage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:#9caa9e; }

        /* 위치 선택 */
        #facilityPage .location-select-row { display:grid; grid-template-columns:1.1fr .75fr .75fr 1.1fr; gap:10px; align-items:end; }
        #facilityPage .location-detail-row { margin-top:10px; }
        #facilityPage .location-help-row { margin-top:5px; font-size:11px; color:#9caa9e; line-height:1.5; }

        /* 반응형 */
        @media (max-width:900px) { #facilityPage .location-select-row { grid-template-columns:1fr 1fr; } }
        @media (max-width:760px) {
            #facilityPage .facility-modal-cols { grid-template-columns:1fr; }
            #facilityPage .facility-modal-col-left { padding-right:0; padding-bottom:16px; margin-bottom:16px; border-right:none; border-bottom:1px solid var(--line); }
            #facilityPage .facility-modal-col-right { padding-left:0; }
        }
    </style>

    <script>
        window.facilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}"
        };
    </script>
</head>
<body>

<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/facility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="시설 등록" />

<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>

        <main class="main-content">
            <div class="office-page" id="facilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>시설 등록</h2>
                        <p>시설 기본정보와 사진을 등록합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>시설 정보 입력</h3>
                    </div>

                    <form id="facilityForm" enctype="multipart/form-data">
                        <input type="hidden" id="useYn" name="useYn" value="Y">

                        <div class="panel-body">
                            <div class="form-section" style="margin-bottom:14px;">
                                <div class="notice-box">
                                    <span class="material-symbols-rounded">info</span>
                                    <div>시설 기본정보를 등록합니다. 헬스장·독서실 등 편의시설 운영정보는
                                        <a href="${pageContext.request.contextPath}/manager/publicFacility/page/${mgmtOfcNo}" style="color:#2e5c38;font-weight:700;">편의시설 관리</a>에서 진행합니다.
                                    </div>
                                </div>
                            </div>

                            <div class="facility-modal-cols">
                                <div class="facility-modal-col-left">
                                    <div class="facility-col-label">시설 정보</div>

                                    <div class="form-section" style="margin-bottom:14px;">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">apartment</span>시설 정보
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="facilityNm" name="facilityNm" placeholder="예) 1호기 승강기" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">시설유형 <span class="req">*</span></label>
                                                <select class="form-select" id="facilityTyCd" name="facilityTyCd" required>
                                                    <option value="">선택</option>
                                                    <optgroup label="일반시설">
                                                        <option value="ELV">승강기</option>
                                                        <option value="WTR">급수시설</option>
                                                        <option value="ELC">전기시설</option>
                                                        <option value="GAS">가스시설</option>
                                                        <option value="FIRE">소방시설</option>
                                                        <option value="SEC">보안시설</option>
                                                        <option value="ETC">기타시설</option>
                                                    </optgroup>
                                                    <optgroup label="편의시설">
                                                        <c:forEach var="type" items="${publicFacilityTypeList}">
                                                            <option value="${type.code}">${type.codeNm}</option>
                                                        </c:forEach>
                                                    </optgroup>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="warn-inline">
                                            <span class="material-symbols-rounded">warning</span>
                                            <div>시설유형은 <strong>계약·점검·검침 이력이 연결되면 변경이 어렵습니다.</strong> 정확하게 선택하세요.</div>
                                        </div>

                                        <div class="form-row cols-2" style="margin-top:8px;">
                                            <div class="form-field">
                                                <label class="field-label">설치일자</label>
                                                <input type="date" class="form-input" id="instlDt" name="instlDt">
                                            </div>
                                            <div class="form-field"></div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">location_on</span>위치 정보
                                        </div>

                                        <div class="location-select-row">
                                            <div class="form-field">
                                                <label class="field-label">위치구분 <span class="req">*</span></label>
                                                <select class="form-select" id="locationType">
                                                    <option value="COMMON">공용 위치</option>
                                                    <option value="DONG">동 위치</option>
                                                    <option value="HOUSEHOLD">세대 위치</option>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">동</label>
                                                <select class="form-select" id="dongNo" name="dongNo" disabled>
                                                    <option value="">선택</option>
                                                    <c:forEach var="dong" items="${dongList}">
                                                        <option value="${dong.dongNo}">
                                                                ${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">층</label>
                                                <select class="form-select" id="facilityFloor" disabled>
                                                    <option value="">선택</option>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">호</label>
                                                <select class="form-select" id="facilityHo" disabled>
                                                    <option value="">선택</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="location-help-row">구분에 따라 동·층·호가 활성화됩니다.</div>
                                        <div class="form-field location-detail-row">
                                            <label class="field-label">상세위치</label>
                                            <input type="text" class="form-input" id="locCn" name="locCn" placeholder="예) 1층 로비, 옥상, 지하주차장 B2 A구역">
                                        </div>
                                    </div>
                                </div>

                                <div class="facility-modal-col-right">
                                    <div class="facility-col-label">사진 &amp; 연결</div>

                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">image</span>시설 사진</div>
                                        <div class="file-upload-box">
                                            <div class="file-upload-title"><span class="material-symbols-rounded">upload_file</span>사진 등록</div>
                                            <div class="file-upload-desc" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                            <input type="file" class="form-input" id="facilityFiles" name="facilityFiles" accept="image/*" multiple>
                                            <div class="file-preview-list" id="facilityFilePreview" style="margin-top:8px;">
                                                <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">link</span>등록 후 연결 안내</div>
                                        <div class="notice-box">
                                            <span class="material-symbols-rounded">info</span>
                                            <div>이 화면에서는 기본정보만 등록합니다.<br>
                                                · 계약 체결 → <a href="${pageContext.request.contextPath}/manager/facility/contractList" style="color:#2e5c38;font-weight:700;">계약 관리</a><br>
                                                · 점검이력 → <a href="${pageContext.request.contextPath}/manager/checkHistory" style="color:#2e5c38;font-weight:700;">유지보수·점검 이력</a><br>
                                                · 검침 연결 → <a href="${pageContext.request.contextPath}/manager/facility/partnerList" style="color:#2e5c38;font-weight:700;">협력업체 관리</a></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                            <button type="button" class="btn btn-secondary" id="backToListBtn">취소</button>
                            <button type="submit" class="btn btn-primary">저장</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    (function () {
        var config = window.facilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo = config.mgmtOfcNo || "";

        function getEl(id) { return document.getElementById(id); }
        function apiUrl(path) { return contextPath + "/manager/facility/" + path; }
        function listUrl() { return contextPath + "/manager/facility/page/" + encodeURIComponent(mgmtOfcNo); }
        function alertMessage(message) { if (typeof showAlert === "function") showAlert(message); else alert(message); }

        function getCsrfHeaders() {
            var tokenMeta = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
            return headers;
        }

        async function requestJson(url, options) {
            var response = await fetch(url, options || {});
            var contentType = response.headers.get("content-type") || "";
            if (response.redirected || response.url.indexOf("/login.do") !== -1) {
                alertMessage("로그인이 필요합니다. 다시 로그인해주세요.");
                location.href = contextPath + "/login.do";
                throw new Error("login required");
            }
            if (contentType.indexOf("application/json") === -1) {
                throw new Error("JSON 응답이 아닙니다. 요청 URL 또는 로그인 상태를 확인해주세요.");
            }
            var data = await response.json();
            if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            return data;
        }

        function getJson(url) { return requestJson(url, { method:"GET", headers:getCsrfHeaders() }); }
        function postForm(url, formData) { return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData }); }

        function resetSelect(select, placeholder) {
            if (select) select.innerHTML = '<option value="">' + placeholder + '</option>';
        }

        function removeHouseholdPrefix(text) {
            return String(text || "").replace(/^\s*\d+\s*층\s*/g, "").replace(/^\s*\d+\s*호\s*/g, "").trim();
        }

        function updateHouseholdLocationText() {
            var locationType = getEl("locationType");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");
            var locCn = getEl("locCn");
            if (!locationType || locationType.value !== "HOUSEHOLD") return;

            var floorText = floorSelect.value ? floorSelect.value + "층" : "";
            var hoText = hoSelect.value ? hoSelect.value + "호" : "";
            var detailText = removeHouseholdPrefix(locCn.value);
            locCn.value = [floorText, hoText, detailText].filter(Boolean).join(" ");
        }

        function changeLocationTypeView() {
            var type = getEl("locationType").value;
            var dongNo = getEl("dongNo");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");
            var locCn = getEl("locCn");

            if (type === "COMMON") {
                dongNo.disabled = true; dongNo.value = "";
                floorSelect.disabled = true; resetSelect(floorSelect, "층 선택");
                hoSelect.disabled = true; resetSelect(hoSelect, "호 선택");
                locCn.placeholder = "예) 중앙광장, 지하1층 전기실, 관리동 옥상";
                locCn.value = removeHouseholdPrefix(locCn.value);
                return;
            }

            if (type === "DONG") {
                dongNo.disabled = false;
                floorSelect.disabled = true; resetSelect(floorSelect, "층 선택");
                hoSelect.disabled = true; resetSelect(hoSelect, "호 선택");
                locCn.placeholder = "예) 1층 로비, 옥상, EPS실";
                locCn.value = removeHouseholdPrefix(locCn.value);
                return;
            }

            dongNo.disabled = false;
            floorSelect.disabled = false;
            hoSelect.disabled = false;
            locCn.placeholder = "예) 세대 분전반, 수도계량기";
            updateHouseholdLocationText();
        }

        async function loadFloorList() {
            var dongNo = getEl("dongNo");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");

            resetSelect(floorSelect, "층 선택");
            resetSelect(hoSelect, "호 선택");
            updateHouseholdLocationText();

            if (!dongNo.value) return;

            var result = await getJson(apiUrl("location/floors/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongNo.value)));
            var floorList = result.list || result.floorList || result || [];

            floorList.forEach(function (row) {
                var floor = row.floor || row.FLOOR;
                if (!floor) return;
                var option = document.createElement("option");
                option.value = floor;
                option.textContent = floor;
                floorSelect.appendChild(option);
            });
        }

        async function loadHoList() {
            var dongNo = getEl("dongNo");
            var floorSelect = getEl("facilityFloor");
            var hoSelect = getEl("facilityHo");

            resetSelect(hoSelect, "호 선택");
            updateHouseholdLocationText();

            if (!dongNo.value || !floorSelect.value) return;

            var result = await getJson(apiUrl("location/rooms/" + encodeURIComponent(mgmtOfcNo) + "?dongNo=" + encodeURIComponent(dongNo.value) + "&floor=" + encodeURIComponent(floorSelect.value)));
            var hoList = result.list || result.roomList || result || [];

            hoList.forEach(function (row) {
                var ho = row.ho || row.HO;
                if (!ho) return;
                var option = document.createElement("option");
                option.value = ho;
                option.textContent = ho;
                hoSelect.appendChild(option);
            });
        }

        function buildLocationText() {
            var type = getEl("locationType").value;
            var locCn = getEl("locCn");
            var dongNo = getEl("dongNo");
            if (type === "COMMON") { dongNo.value = ""; return locCn.value; }
            if (type === "DONG") { return removeHouseholdPrefix(locCn.value); }
            updateHouseholdLocationText();
            return locCn.value;
        }

        function makeRegisterFormData() {
            // 기본 form 기준 FormData 생성
            // - input type="file"에 선택된 파일도 자동 포함
            var formData = new FormData(getEl("facilityForm"));

            // 위치구분에 따라 가공된 상세위치 반영
            formData.set("locCn", buildLocationText());

            // 등록 시 기본 사용여부 고정
            formData.set("useYn", "Y");

            // 설치일자가 비어 있으면 서버로 빈 문자열 전송 방지
            if (!formData.get("instlDt")) {
                formData.delete("instlDt");
            }

            return formData;
        }

        async function saveFacility(event) {
            event.preventDefault();
            if (!getEl("facilityNm").value.trim()) { alertMessage("시설명을 입력하세요."); return; }
            if (!getEl("facilityTyCd").value) { alertMessage("시설유형을 선택하세요."); return; }

            try {
                await postForm(apiUrl("insert/" + encodeURIComponent(mgmtOfcNo)), makeRegisterFormData());
                alertMessage("시설이 등록되었습니다.");
                location.href = listUrl();
            } catch (err) {
                console.error(err);
                alertMessage(err.message || "시설 등록 중 오류가 발생했습니다.");
            }
        }

        /* ============================================================
           파일 미리보기
           - 기본 파일 input의 FileList 기준으로 현재 선택된 파일만 표시
           - 파일을 다시 선택하면 브라우저 기본 동작에 따라 기존 선택은 교체
        ============================================================ */
        function renderSelectedFilePreview() {
            // 파일 input
            var fileInput = getEl("facilityFiles");

            // 미리보기 영역
            var previewArea = getEl("facilityFilePreview");

            // 필수 요소가 없으면 중단
            if (!fileInput || !previewArea) return;

            // 기존 미리보기 초기화
            previewArea.innerHTML = "";

            // 선택된 파일이 없으면 안내문구 표시
            if (!fileInput.files || fileInput.files.length === 0) {
                previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
                return;
            }

            // 현재 input에 선택된 파일 기준으로 미리보기 생성
            Array.from(fileInput.files).forEach(function (file) {
                // 미리보기 카드
                var wrapper = document.createElement("div");
                wrapper.className = "file-preview-item";

                // 이미지 파일이면 썸네일 표시
                if (file.type && file.type.indexOf("image/") === 0) {
                    var img = document.createElement("img");
                    img.alt = file.name;
                    img.src = URL.createObjectURL(file);

                    // 이미지 로드 후 임시 objectUrl 해제
                    img.onload = function () {
                        URL.revokeObjectURL(img.src);
                    };

                    wrapper.appendChild(img);
                }

                // 파일명 표시
                var nameEl = document.createElement("div");
                nameEl.className = "file-preview-name";
                nameEl.textContent = file.name;
                wrapper.appendChild(nameEl);

                // 미리보기 영역에 카드 추가
                previewArea.appendChild(wrapper);
            });
        }

        function previewSelectedFiles() {
            // 파일 선택 변경 시 input.files 기준으로 미리보기만 다시 그림
            renderSelectedFilePreview();
        }

        function bindEvents() {
            getEl("facilityForm").addEventListener("submit", saveFacility);
            getEl("backToListBtn").addEventListener("click", function () { location.href = listUrl(); });
            getEl("facilityFiles").addEventListener("change", previewSelectedFiles);

            getEl("locationType").addEventListener("change", function () {
                changeLocationTypeView();
                if (this.value === "HOUSEHOLD" || this.value === "DONG") loadFloorList();
            });

            getEl("dongNo").addEventListener("change", function () {
                if (getEl("locationType").value === "HOUSEHOLD") loadFloorList();
            });

            getEl("facilityFloor").addEventListener("change", loadHoList);
            getEl("facilityHo").addEventListener("change", updateHouseholdLocationText);
        }

        document.addEventListener("DOMContentLoaded", function () {
            bindEvents();
            changeLocationTypeView();
        });
    })();
</script>
</body>
</html>
