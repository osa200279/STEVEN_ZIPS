<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시설 상세</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #facilityPage {
            --accent: #2e5c38;
            --accent-light: #e8f0ea;
            --accent-dim: rgba(38,92,48,.08);
            --surface: #fff;
            --line: #d7dce2;
            --th-bg: #f4f6f4;
            --text-head: #1a2e1e;
            --text-sub: #6b7a6e;
        }

        #facilityPage .page-title-block h2 { color: var(--text-head); font-size: 20px; letter-spacing: -.5px; margin: 0; }
        #facilityPage .page-title-block p  { color: var(--text-sub); font-size: 12px; margin-top: 6px; }

        /* 카드 */
        #facilityPage .detail-card      { border: 1px solid var(--line); border-radius: 8px; background: var(--surface); overflow: hidden; }
        #facilityPage .detail-card-body { padding: 24px 28px 28px; }

        /* 버튼 */
        #facilityPage .btn               { border-radius: 4px; min-height: 34px; font-size: 12px; padding: 0 14px; }
        #facilityPage .btn-primary       { background: var(--accent); border-color: var(--accent); }
        #facilityPage .btn-primary:hover { background: #1a3d1f; border-color: #1a3d1f; }

        /* 섹션 소제목: register의 form-section-title과 동일 */
        #facilityPage .detail-section-title {
            display: flex;
            align-items: center;
            gap: 6px;
            margin: 0 0 12px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--line);
            font-size: 13px;
            font-weight: 800;
            color: var(--text-head);
        }
        #facilityPage .detail-section-title .material-symbols-rounded { font-size: 17px; color: var(--accent); }
        #facilityPage .detail-section { margin-bottom: 24px; }
        #facilityPage .detail-section:last-child { margin-bottom: 0; }

        /* 좌우 2분할: register의 facility-modal-cols와 동일 */
        #facilityPage .detail-cols      { display: grid; grid-template-columns: 1fr 1fr; gap: 0; }
        #facilityPage .detail-col-left  { padding-right: 28px; border-right: 1px solid var(--line); }
        #facilityPage .detail-col-right { padding-left: 28px; }

        /* 라벨/값 테이블 */
        #facilityPage .detail-table            { width: 100%; border-top: 1px solid var(--line); border-collapse: collapse; table-layout: fixed; }
        #facilityPage .detail-table th         { width: 90px; padding: 11px 12px; border-bottom: 1px solid var(--line); background: var(--th-bg); color: #27382b; font-size: 12px; font-weight: 800; text-align: left; vertical-align: middle; }
        #facilityPage .detail-table td         { padding: 11px 14px; border-bottom: 1px solid var(--line); color: #111827; font-size: 12px; font-weight: 600; vertical-align: middle; word-break: break-all; }
        #facilityPage .detail-empty            { color: #9ca3af; font-weight: 500; }

        /* 배지 */
        #facilityPage .badge       { display: inline-flex; align-items: center; justify-content: center; min-height: 22px; padding: 0 8px; border-radius: 4px; font-size: 11px; font-weight: 800; line-height: 1; border: 1px solid transparent; }
        #facilityPage .badge-blue  { background: #dbeafe; color: #1e3a5f; border-color: #bfdbfe; }
        #facilityPage .badge-use-y { background: #dceee0; color: #1f7a3f; border-color: #c7e4cf; }
        #facilityPage .badge-use-y::before { content: ""; width: 7px; height: 7px; margin-right: 6px; border-radius: 50%; background: #22c55e; }
        #facilityPage .badge-use-n { background: #fee2e2; color: #b42318; border-color: #fecaca; }
        #facilityPage .badge-use-n::before { content: ""; width: 7px; height: 7px; margin-right: 6px; border-radius: 50%; background: #ef4444; }

        /* 사진 */
        #facilityPage .file-preview-list     { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px; }
        #facilityPage .file-preview-item     { border: 1px solid var(--line); border-radius: 6px; background: #fafcfb; overflow: hidden; }
        #facilityPage .file-preview-item img { display: block; width: 100%; height: 110px; object-fit: cover; border-bottom: 1px solid var(--line); }
        #facilityPage .file-preview-name     { padding: 8px 10px; font-size: 11px; color: #4a5c4e; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        #facilityPage .file-preview-empty    { grid-column: 1 / -1; padding: 14px 16px; border: 1px solid var(--line); border-radius: 6px; background: #fff; font-size: 12px; color: #9caa9e; }

        /* 비활성 안내 */
        #facilityPage .disabled-notice {
            display: none;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 20px;
            padding: 13px 15px;
            border: 1px solid #fed7aa;
            border-left: 3px solid #f59e0b;
            border-radius: 0 4px 4px 0;
            background: #fff7ed;
            color: #7c2d12;
            font-size: 12px;
            line-height: 1.6;
        }
        #facilityPage .disabled-notice .material-symbols-rounded { color: #f59e0b; font-size: 18px; flex-shrink: 0; margin-top: 1px; }

        /* 시설정보 + 위치정보 나란히 */
        #facilityPage .detail-info-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px; }

        /* 하단 연결정보 1열씩 세로 쌓기 */
        #facilityPage .detail-link-row { display: flex; flex-direction: column; gap: 20px; }
        #facilityPage .detail-link-row .detail-section { margin-bottom: 0; }

        /* 안내 박스 */
        #facilityPage .notice-box { display: flex; gap: 10px; padding: 13px 15px; background: #f7faf7; border: 1px solid var(--line); border-left: 3px solid var(--accent); border-radius: 0 4px 4px 0; font-size: 12px; color: #4a5c4e; line-height: 1.7; }
        #facilityPage .notice-box .material-symbols-rounded { color: var(--accent); font-size: 17px; flex-shrink: 0; margin-top: 2px; }

        /* 편의시설 운영관리 안내 */
        #facilityPage #publicFacilityNotice { margin-top: 10px; display: none; }
        #facilityPage #publicFacilityNotice a { color: var(--accent); font-weight: 800; text-decoration: none; }

        /* 하단 연결 정보 — 상단과 동일한 detail-cols 구조 사용으로 별도 스타일 불필요 */
        #facilityPage .ds-row {
            display: grid;
            grid-template-columns: minmax(72px, .55fr) minmax(0, 1fr) auto;
            gap: 10px;
            align-items: center;
            min-height: 44px;
            padding: 10px 12px;
            border-bottom: 1px solid var(--line);
            font-size: 12px;
        }
        #facilityPage .ds-row:last-child { border-bottom: none; }
        #facilityPage .ds-no   { color: #6b7280; font-family: 'SF Mono','Consolas',monospace; font-size: 11px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        #facilityPage .ds-nm   { color: #111827; font-weight: 700; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        #facilityPage .ds-dt   { color: #9ca3af; font-family: 'SF Mono','Consolas',monospace; font-size: 11px; white-space: nowrap; }
        #facilityPage .ds-empty { display: flex; align-items: center; min-height: 48px; padding: 0 14px; color: #9ca3af; font-size: 12px; }

        /* 하단 버튼 */
        #facilityPage .detail-actions { display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px; }

        @media (max-width: 900px) {
            #facilityPage .detail-cols      { grid-template-columns: 1fr; }
            #facilityPage .detail-col-left  { padding-right: 0; border-right: none; border-bottom: 1px solid var(--line); padding-bottom: 24px; margin-bottom: 24px; }
            #facilityPage .detail-col-right { padding-left: 0; }
            #facilityPage .detail-link-row  { grid-template-columns: 1fr; }
        }
        @media (max-width: 600px) {
            #facilityPage .detail-info-row  { grid-template-columns: 1fr; }
            #facilityPage .file-preview-list { grid-template-columns: 1fr; }
        }
    </style>

    <script>
        <sec:authorize access="hasRole('ADMIN')" var="facilityAdmin" />
        window.facilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            facilityNo: "${facilityNo}",
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
            <div class="office-page" id="facilityPage">

                <%-- 화면 상단 제목 영역 --%>
                <div class="page-header">
                    <div class="page-title-block">
                        <h2 id="detailModalTitle">시설 상세</h2>
                        <p>시설 기본정보와 사진, 연결 정보를 확인합니다.</p>
                    </div>
                </div>

                <%-- 상세 본문 카드 --%>
                <div class="detail-card">
                    <div class="detail-card-body">

                        <%-- 비활성 사유 안내 영역 --%>
                        <div class="disabled-notice" id="detailDisabledSection">
                            <span class="material-symbols-rounded">warning</span>
                            <div id="detailDisabledReason"></div>
                        </div>

                        <%-- 상단: 시설정보+위치정보 나란히(왼쪽) / 사진+안내(오른쪽) --%>
                        <div class="detail-cols">
                            <div class="detail-col-left">

                                <div class="detail-info-row">
                                    <div class="detail-section">
                                        <h3 class="detail-section-title">
                                            <span class="material-symbols-rounded">apartment</span>시설 정보
                                        </h3>
                                        <table class="detail-table">
                                            <tbody id="detailFacilityInfoBody"></tbody>
                                        </table>
                                    </div>
                                    <div class="detail-section">
                                        <h3 class="detail-section-title">
                                            <span class="material-symbols-rounded">location_on</span>위치 정보
                                        </h3>
                                        <table class="detail-table">
                                            <tbody id="detailLocationInfoBody"></tbody>
                                        </table>
                                    </div>
                                </div>

                                <%-- 하단 연결 정보 3개 --%>
                                <div class="detail-link-row">
                                    <div class="detail-section" id="detailContSection">
                                        <h3 class="detail-section-title">
                                            <span class="material-symbols-rounded">description</span>최근 계약 정보
                                            <a href="${pageContext.request.contextPath}/manager/facility/contractList" id="contMoreLink" style="margin-left:auto; font-size:11px; font-weight:800; color:var(--accent); text-decoration:none;">전체보기 →</a>
                                        </h3>
                                        <div class="detail-summary"><div id="detailContBody"></div></div>
                                    </div>
                                    <div class="detail-section" id="detailChkSection">
                                        <h3 class="detail-section-title">
                                            <span class="material-symbols-rounded">fact_check</span>최근 점검이력
                                            <a href="${pageContext.request.contextPath}/manager/checkHistory" id="chkMoreLink" style="margin-left:auto; font-size:11px; font-weight:800; color:var(--accent); text-decoration:none;">전체보기 →</a>
                                        </h3>
                                        <div class="detail-summary"><div id="detailChkBody"></div></div>
                                    </div>
                                    <div class="detail-section" id="detailMeterSection">
                                        <h3 class="detail-section-title">
                                            <span class="material-symbols-rounded">electric_meter</span>검침 연결 정보
                                            <a href="${pageContext.request.contextPath}/manager/checkHistory" style="margin-left:auto; font-size:11px; font-weight:800; color:var(--accent); text-decoration:none;">검침기록 보기 →</a>
                                        </h3>
                                        <div class="detail-summary"><div id="detailMeterBody"></div></div>
                                    </div>
                                </div>

                            </div>
                            <div class="detail-col-right">

                                <div class="detail-section" id="detailFileSection">
                                    <h3 class="detail-section-title">
                                        <span class="material-symbols-rounded">image</span>시설 사진
                                    </h3>
                                    <div class="file-preview-list" id="detailFileList">
                                        <div class="file-preview-empty">등록된 사진이 없습니다.</div>
                                    </div>
                                </div>

                                <div class="detail-section">
                                    <h3 class="detail-section-title">
                                        <span class="material-symbols-rounded">info</span>연결 정보 안내
                                    </h3>
                                    <div class="notice-box">
                                        <span class="material-symbols-rounded">info</span>
                                        <div>
                                            계약·점검·검침의 상세 내역은 각 전용 페이지에서 확인하세요.<br>
                                            · 계약 상세 → <a href="${pageContext.request.contextPath}/manager/facility/contractList" style="color:var(--accent);font-weight:700;">계약 관리</a><br>
                                            · 점검이력 → <a href="${pageContext.request.contextPath}/manager/checkHistory" style="color:var(--accent);font-weight:700;">유지보수·점검 이력</a><br>
                                            · 검침기록 → <a href="${pageContext.request.contextPath}/manager/facility/partnerList" style="color:var(--accent);font-weight:700;">협력업체 관리</a>
                                        </div>
                                    </div>

                                    <%-- 편의시설 운영관리 안내: 편의시설일 때만 JS에서 표시 --%>
                                    <div class="notice-box" id="publicFacilityNotice">
                                        <span class="material-symbols-rounded">campaign</span>
                                        <div>
                                            편의시설의 예약 가능 여부, 운영시간, 이용 안내 등 운영 정보는
                                            <strong>공용시설 관리 화면</strong>에서 별도로 관리합니다.<br>
                                            <a href="${pageContext.request.contextPath}/manager/publicFacilityList/${mgmtOfcNo}">
                                                운영관리 바로가기 →
                                            </a>
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>
                </div>

                <div class="detail-actions">
                    <button type="button" class="btn btn-secondary" id="backToListBtnTop">목록</button>
                    <sec:authorize access="!hasRole('ADMIN')">
                        <button type="button" class="btn btn-primary" id="detailEditBtnTop">수정</button>
                    </sec:authorize>
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
        var facilityNo = config.facilityNo || "";
        var isAdmin = config.isAdmin === true || config.isAdmin === "true";

        function apiUrl(path) {
            return contextPath + "/manager/facility/" + path;
        }

        function listUrl() {
            return contextPath + "/manager/facility/page/" + encodeURIComponent(mgmtOfcNo);
        }

        function alertMessage(message) {
            if (typeof showAlert === "function") { showAlert(message); return; }
            alert(message);
        }

        function escapeHtml(value) {
            if (value == null) return "";
            return String(value)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        function formatDate(value) {
            return value ? String(value).slice(0, 10) : "";
        }

        function formatDongNo(value) {
            if (value == null || value === "") return "공용";
            var text = String(value);
            var idx = text.lastIndexOf("_");
            return idx > -1 ? text.slice(idx + 1) : text;
        }

        function badge(cls, text) {
            return '<span class="badge ' + cls + '">' + escapeHtml(text) + '</span>';
        }

        function useYnBadge(useYn) {
            return useYn === "N" ? badge("badge-use-n", "비활성") : badge("badge-use-y", "활성");
        }

        function tableRow(label, value) {
            var safeValue = value == null || value === "" ? '<span class="detail-empty">-</span>' : value;
            return '<tr><th>' + escapeHtml(label) + '</th><td>' + safeValue + '</td></tr>';
        }

        function getResultFacility(result) {
            return result.detail || result.facility || result || {};
        }

        function getFileImageUrl(file) {
            if (file.viewUrl) return file.viewUrl;
            if (file.fileUrl) return file.fileUrl;
            if (file.googleId) return contextPath + "/file/display/" + encodeURIComponent(file.googleId);
            return "";
        }

        function getCsrfHeaders() {
            var tokenMeta = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) { headers[headerMeta.content] = tokenMeta.content; }
            return headers;
        }

        async function getJson(url) {
            var response = await fetch(url, { method: "GET", headers: getCsrfHeaders() });
            var data = await response.json();
            if (!response.ok || data.success === false) {
                throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            }
            return data;
        }

        function renderDetailFiles(files) {
            var area = document.getElementById("detailFileList");
            if (!files || files.length === 0) {
                area.innerHTML = '<div class="file-preview-empty">등록된 사진이 없습니다.</div>';
                return;
            }
            area.innerHTML = files.map(function (file) {
                var imgUrl = getFileImageUrl(file);
                var name = file.fileOgName || file.fileSaveUuid || "시설사진";
                return '<div class="file-preview-item">'
                    + (imgUrl ? '<img src="' + escapeHtml(imgUrl) + '" alt="' + escapeHtml(name) + '">' : '')
                    + '<div class="file-preview-name">' + escapeHtml(name) + '</div>'
                    + '</div>';
            }).join("");
        }

        function renderLatestContract(contract) {
            var area = document.getElementById("detailContBody");
            if (!contract) {
                area.innerHTML = '<div class="ds-empty">등록된 계약이 없습니다.</div>';
                return;
            }
            area.innerHTML = '<div class="ds-row">'
                + '<span class="ds-no">' + escapeHtml(contract.contNo || "-") + '</span>'
                + '<span class="ds-nm">' + escapeHtml(contract.contNm || "-") + '</span>'
                + '<span class="ds-dt">' + escapeHtml(formatDate(contract.contEndDt) || "-") + '</span>'
                + '</div>';
        }

        function renderRecentChecks(checks) {
            var area = document.getElementById("detailChkBody");
            if (!checks || checks.length === 0) {
                area.innerHTML = '<div class="ds-empty">점검이력이 없습니다.</div>';
                return;
            }
            area.innerHTML = checks.slice(0, 3).map(function (check) {
                return '<div class="ds-row">'
                    + '<span class="ds-no">' + escapeHtml(check.facChkHstryNo || "-") + '</span>'
                    + '<span class="ds-nm">' + escapeHtml(check.chkCn || "-") + '</span>'
                    + '<span class="ds-dt">' + escapeHtml(formatDate(check.chkDt) || "-") + '</span>'
                    + '</div>';
            }).join("");
        }

        function renderMeterInfo(meter) {
            var area = document.getElementById("detailMeterBody");
            if (!meter) {
                area.innerHTML = '<div class="ds-empty">검침 연결 정보가 없습니다.</div>';
                return;
            }
            area.innerHTML = '<div class="ds-row">'
                + '<span class="ds-no">' + escapeHtml(meter.meterWrkNo || meter.meterHstryNo || "-") + '</span>'
                + '<span class="ds-nm">' + escapeHtml(meter.partnerNm || meter.providerNm || "검침 연결") + '</span>'
                + '<span class="ds-dt">-</span>'
                + '</div>';
        }

        function renderFacilityInfo(facility) {
            document.getElementById("detailFacilityInfoBody").innerHTML = ""
                + tableRow("시설번호", escapeHtml(facility.facilityNo))
                + tableRow("시설명", escapeHtml(facility.facilityNm))
                + tableRow("시설유형", badge("badge-blue", facility.facilityTyNm || facility.facilityTyCd || "-"))
                + tableRow("활성여부", useYnBadge(facility.useYn));
        }

        function renderLocationInfo(facility) {
            document.getElementById("detailLocationInfoBody").innerHTML = ""
                + tableRow("위치구분", escapeHtml(facility.dongNo ? "동 위치" : "공용 위치"))
                + tableRow("동", escapeHtml(formatDongNo(facility.dongNo)))
                + tableRow("상세위치", escapeHtml(facility.locCn || "-"))
                + tableRow("설치일자", escapeHtml(formatDate(facility.instlDt) || "-"));
        }

        function renderDisabledNotice(facility) {
            var section = document.getElementById("detailDisabledSection");
            var reason = document.getElementById("detailDisabledReason");
            if (facility.useYn !== "N") {
                section.style.display = "none";
                reason.innerHTML = "";
                return;
            }
            section.style.display = "flex";
            reason.innerHTML = "이 시설은 현재 <strong>비활성</strong> 상태입니다. 기존 점검·계약·검침 연결 정보는 유지됩니다.";
        }

        function renderPublicFacilityNotice(facility) {
            var notice = document.getElementById("publicFacilityNotice");
            if (!notice) return;

            /* 편의시설일 때만 운영관리 안내 표시 */
            notice.style.display = facility.facilityKind === "PUBLIC" ? "flex" : "none";
        }

        function bindEditButton(facility) {
            var editBtn = document.getElementById("detailEditBtnTop");
            if (!editBtn || isAdmin) return;

            /* 상세 화면 공통 수정 버튼 문구 */
            editBtn.textContent = "수정";

            /* 시설 수정 화면 이동 */
            editBtn.onclick = function () {
                location.href = contextPath + "/manager/facility/update-page/"
                    + encodeURIComponent(mgmtOfcNo) + "/"
                    + encodeURIComponent(facility.facilityNo);
            };
        }

        function renderDetail(result) {
            var facility = getResultFacility(result);
            document.getElementById("detailModalTitle").textContent = "시설 상세";
            renderDisabledNotice(facility);
            renderFacilityInfo(facility);
            renderLocationInfo(facility);
            renderDetailFiles(result.fileList || result.attachFileList || facility.fileList || []);
            renderLatestContract(result.latestContract || null);
            renderRecentChecks(result.recentCheckList || []);
            renderMeterInfo(result.meterInfo || null);
            renderPublicFacilityNotice(facility);
            bindEditButton(facility);
        }

        document.addEventListener("DOMContentLoaded", function () {
            document.getElementById("backToListBtnTop").addEventListener("click", function () {
                location.href = listUrl();
            });

            getJson(apiUrl("detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo)))
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
