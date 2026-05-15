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


        /* 이미지 클릭 확대 공통 */
        #facilityPage .js-image-preview {
            cursor: zoom-in;
        }

        .image-preview-modal {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: rgba(0, 0, 0, .76);
        }

        .image-preview-modal.is-open {
            display: flex;
        }

        .image-preview-modal img {
            max-width: 92vw;
            max-height: 88vh;
            object-fit: contain;
            border-radius: 6px;
            background: #fff;
        }

        .image-preview-close {
            position: absolute;
            top: 22px;
            right: 28px;
            border: 0;
            background: transparent;
            color: #fff;
            font-size: 38px;
            line-height: 1;
            cursor: pointer;
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
                                <%-- 하단 관련 이력 --%>
                                <div class="detail-link-row">
                                    <div class="detail-section" id="detailHistorySection">
                                        <h3 class="detail-section-title">
                                            <span class="material-symbols-rounded">history</span>최근 점검·보수 이력
                                            <a href="${pageContext.request.contextPath}/manager/checkHistory"
                                               id="historyMoreLink"
                                               style="margin-left:auto; font-size:11px; font-weight:800; color:var(--accent); text-decoration:none;">전체보기 →</a>
                                        </h3>
                                        <div class="detail-summary">
                                            <div id="detailHistoryBody"></div>
                                        </div>
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
                                            <a href="${pageContext.request.contextPath}/manager/publicFacility/list/${mgmtOfcNo}"
                                               id="publicFacilityNoticeLink">
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
<!-- 이미지 확대 모달 -->
<div id="imagePreviewModal" class="image-preview-modal">
    <button type="button" id="imagePreviewCloseBtn" class="image-preview-close" aria-label="이미지 확대 닫기">×</button>
    <img id="imagePreviewLargeImg" src="" alt="확대 이미지">
</div>
<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    /* ============================================================
       시설 상세 화면 스크립트

       역할
       - 시설 상세 API 조회
       - 시설 기본정보/위치정보/사진/연결정보 렌더링
       - 시설 사진 클릭 확대 모달 처리
       - 목록/수정 화면 이동 처리

       이미지 확대 방식
       - 사진 HTML 생성 시 onclick 속성 직접 부여
       - window.openFacilityImagePreview(this.src) 직접 호출
       - 닫기 버튼/검은 배경/ESC 키로 모달 닫기
    ============================================================ */
    (function () {
        /* ============================================================
           1. 기본 설정값
        ============================================================ */

        /* JSP에서 내려준 화면 설정 객체 */
        var config = window.facilityPageConfig || {};

        /* 프로젝트 context path 값 */
        var contextPath = config.contextPath || "";

        /* 현재 관리사무소 번호 값 */
        var mgmtOfcNo = config.mgmtOfcNo || "";

        /* 현재 시설 번호 값 */
        var facilityNo = config.facilityNo || "";

        /* 관리자 권한 여부 값 */
        var isAdmin = config.isAdmin === true || config.isAdmin === "true";

        /* ============================================================
           2. 공통 유틸 함수
        ============================================================ */

        /**
         * 시설 API 주소 생성
         * - /manager/facility 하위 API 호출 주소 생성
         */
        function apiUrl(path) {
            /* API 기본 주소와 세부 경로 결합값 */
            return contextPath + "/manager/facility/" + path;
        }

        /**
         * 목록 화면 주소 생성
         * - 상세 화면의 목록 버튼 이동 주소 생성
         */
        function listUrl() {
            /* 관리사무소 번호 포함 목록 주소값 */
            return contextPath + "/manager/facility/page/" + encodeURIComponent(mgmtOfcNo);
        }

        /**
         * 알림 메시지 출력
         * - 공통 showAlert 함수가 있으면 공통 알림 사용
         * - 없으면 기본 alert 사용
         */
        function alertMessage(message) {
            /* 공통 알림 함수 존재 여부 */
            var hasCommonAlert = typeof showAlert === "function";

            /* 공통 알림 출력 처리 */
            if (hasCommonAlert) {
                showAlert(message);
                return;
            }

            /* 기본 알림 출력 처리 */
            alert(message);
        }

        /**
         * HTML 특수문자 변환
         * - 문자열 기반 HTML 생성 시 XSS 방지 처리
         */
        function escapeHtml(value) {
            /* 빈 값 방어 처리 */
            if (value == null) {
                return "";
            }

            /* 문자열 변환값 */
            var text = String(value);

            /* HTML 특수문자 치환값 */
            return text
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/\"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        /**
         * 날짜 표시값 변환
         * - yyyy-MM-dd 형태의 앞 10자리만 표시
         */
        function formatDate(value) {
            /* 날짜 값 없음 처리 */
            if (!value) {
                return "";
            }

            /* 날짜 문자열 앞 10자리 반환값 */
            return String(value).slice(0, 10);
        }

        /**
         * 동 번호 표시값 변환
         * - 내부 키 값에 언더바가 있으면 뒤쪽 실제 동 번호만 표시
         * - 값이 없으면 공용 위치로 표시
         */
        function formatDongNo(value) {
            /* 공용 위치 표시 처리 */
            if (value == null || value === "") {
                return "공용";
            }

            /* 동 번호 문자열값 */
            var text = String(value);

            /* 마지막 언더바 위치값 */
            var idx = text.lastIndexOf("_");

            /* 표시용 동 번호값 */
            return idx > -1 ? text.slice(idx + 1) : text;
        }

        /**
         * 배지 HTML 생성
         * - 시설유형/활성여부 표시용 span 생성
         */
        function badge(cls, text) {
            /* 배지 클래스명 */
            var badgeClass = cls;

            /* 배지 표시 문구 */
            var badgeText = escapeHtml(text);

            /* 배지 HTML 반환값 */
            return '<span class="badge ' + badgeClass + '">' + badgeText + '</span>';
        }

        /**
         * 활성여부 배지 HTML 생성
         * - N이면 비활성 배지
         * - 그 외에는 활성 배지
         */
        function useYnBadge(useYn) {
            /* 비활성 여부값 */
            var isDisabled = useYn === "N";

            /* 활성여부 배지 반환값 */
            return isDisabled ? badge("badge-use-n", "비활성") : badge("badge-use-y", "활성");
        }

        /**
         * 상세 테이블 행 HTML 생성
         * - 라벨과 값을 th/td 한 줄로 생성
         */
        function tableRow(label, value) {
            /* 빈 값 표시 HTML */
            var emptyHtml = '<span class="detail-empty">-</span>';

            /* 실제 표시값 */
            var safeValue = value == null || value === "" ? emptyHtml : value;

            /* 테이블 행 HTML 반환값 */
            return '<tr><th>' + escapeHtml(label) + '</th><td>' + safeValue + '</td></tr>';
        }

        /**
         * 상세 응답에서 시설 객체 추출
         * - detail, facility, result 자체 순서로 사용
         */
        function getResultFacility(result) {
            /* 응답 기본값 */
            var data = result || {};

            /* 시설 상세 객체 반환값 */
            return data.detail || data.facility || data;
        }

        /**
         * 첨부파일 이미지 주소 추출
         * - viewUrl/fileUrl/googleId 순서로 표시 주소 생성
         */
        function getFileImageUrl(file) {
            /* 파일 객체 기본값 */
            var targetFile = file || {};

            /* viewUrl 우선 사용 처리 */
            if (targetFile.viewUrl) {
                return targetFile.viewUrl;
            }

            /* fileUrl 보조 사용 처리 */
            if (targetFile.fileUrl) {
                return targetFile.fileUrl;
            }

            /* googleId 기반 표시 URL 생성 처리 */
            if (targetFile.googleId) {
                return contextPath + "/file/display/" + encodeURIComponent(targetFile.googleId);
            }

            /* 이미지 주소 없음 반환값 */
            return "";
        }

        /**
         * CSRF 헤더 생성
         * - Spring Security csrf meta 태그 기준 헤더 구성
         */
        function getCsrfHeaders() {
            /* CSRF 토큰 meta 요소 */
            var tokenMeta = document.querySelector('meta[name="_csrf"]');

            /* CSRF 헤더명 meta 요소 */
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');

            /* 요청 헤더 객체 */
            var headers = {};

            /* CSRF meta 존재 시 헤더 추가 처리 */
            if (tokenMeta && headerMeta) {
                headers[headerMeta.content] = tokenMeta.content;
            }

            /* 헤더 객체 반환값 */
            return headers;
        }

        /**
         * GET JSON 요청 처리
         * - 시설 상세 API 호출 처리
         * - 실패 응답 메시지 예외 처리
         */
        async function getJson(url) {
            /* 서버 응답 객체 */
            var response = await fetch(url, {
                method: "GET",
                headers: getCsrfHeaders()
            });

            /* JSON 응답 데이터 */
            var data = await response.json();

            /* 실패 응답 여부 */
            var isFail = !response.ok || data.success === false;

            /* 실패 응답 예외 처리 */
            if (isFail) {
                throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            }

            /* 성공 데이터 반환값 */
            return data;
        }

        /* ============================================================
           3. 이미지 확대 모달 함수
        ============================================================ */

        /**
         * 이미지 확대 모달 열기 처리
         * - 사진 img onclick에서 직접 호출되는 전역 함수
         * - 전달받은 이미지 주소를 큰 이미지 영역에 반영
         */
        window.openFacilityImagePreview = function (imgSrc) {
            /* 이미지 확대 모달 요소 */
            var modal = document.getElementById("imagePreviewModal");

            /* 확대 이미지 요소 */
            var largeImg = document.getElementById("imagePreviewLargeImg");

            /* 필수 요소 존재 여부 */
            var hasRequiredElement = modal && largeImg && imgSrc;

            /* 필수 요소 없음 방어 처리 */
            if (!hasRequiredElement) {
                return;
            }

            /* 확대 이미지 주소 반영 처리 */
            largeImg.src = imgSrc;

            /* 모달 표시 클래스 추가 처리 */
            modal.classList.add("is-open");
        };

        /**
         * 이미지 확대 모달 닫기 처리
         * - 닫기 버튼/배경 클릭/ESC 입력에서 공통 사용
         * - 큰 이미지 주소 초기화 처리
         */
        window.closeFacilityImagePreview = function () {
            /* 이미지 확대 모달 요소 */
            var modal = document.getElementById("imagePreviewModal");

            /* 확대 이미지 요소 */
            var largeImg = document.getElementById("imagePreviewLargeImg");

            /* 필수 요소 존재 여부 */
            var hasRequiredElement = modal && largeImg;

            /* 필수 요소 없음 방어 처리 */
            if (!hasRequiredElement) {
                return;
            }

            /* 모달 표시 클래스 제거 처리 */
            modal.classList.remove("is-open");

            /* 확대 이미지 주소 초기화 처리 */
            largeImg.src = "";
        };

        /**
         * 이미지 확대 모달 닫기 이벤트 연결 처리
         * - 닫기 버튼 클릭 처리
         * - 검은 배경 클릭 처리
         * - ESC 키 입력 처리
         */
        function bindImagePreviewModal() {
            /* 이미지 확대 모달 요소 */
            var modal = document.getElementById("imagePreviewModal");

            /* 닫기 버튼 요소 */
            var closeBtn = document.getElementById("imagePreviewCloseBtn");

            /* 필수 요소 존재 여부 */
            var hasRequiredElement = modal && closeBtn;

            /* 필수 요소 없음 방어 처리 */
            if (!hasRequiredElement) {
                return;
            }

            /* 닫기 버튼 클릭 이벤트 연결 처리 */
            closeBtn.addEventListener("click", function () {
                window.closeFacilityImagePreview();
            });

            /* 검은 배경 클릭 이벤트 연결 처리 */
            modal.addEventListener("click", function (event) {
                /* 배경 클릭 여부 */
                var isBackdropClick = event.target === modal;

                /* 이미지 클릭 시 닫힘 방지 처리 */
                if (!isBackdropClick) {
                    return;
                }

                /* 모달 닫기 처리 */
                window.closeFacilityImagePreview();
            });

            /* ESC 키 입력 이벤트 연결 처리 */
            document.addEventListener("keydown", function (event) {
                /* ESC 키 여부 */
                var isEscapeKey = event.key === "Escape";

                /* ESC 외 키 입력 방어 처리 */
                if (!isEscapeKey) {
                    return;
                }

                /* 모달 닫기 처리 */
                window.closeFacilityImagePreview();
            });
        }

        /* ============================================================
           4. 상세 화면 렌더링 함수
        ============================================================ */

        /**
         * 시설 사진 렌더링 처리
         * - 등록된 시설 사진 목록 출력
         * - 이미지 태그에 onclick 직접 부여
         */
        function renderDetailFiles(files) {
            /* 시설 사진 목록 영역 */
            var area = document.getElementById("detailFileList");

            /* 사진 목록 없음 처리 */
            if (!files || files.length === 0) {
                area.innerHTML = '<div class="file-preview-empty">등록된 사진이 없습니다.</div>';
                return;
            }

            /* 사진 목록 HTML 생성 처리 */
            area.innerHTML = files.map(function (file) {
                /* 이미지 표시 주소 */
                var imgUrl = getFileImageUrl(file);

                /* 이미지 파일명 */
                var name = file.fileOgName || file.fileSaveUuid || "시설사진";

                /* 이미지 URL HTML 변환값 */
                var safeImgUrl = escapeHtml(imgUrl);

                /* 이미지 파일명 HTML 변환값 */
                var safeName = escapeHtml(name);

                /* 이미지 태그 HTML */
                var imgHtml = imgUrl
                    ? '<img class="js-image-preview" src="' + safeImgUrl + '" alt="' + safeName + '" onclick="window.openFacilityImagePreview(this.src)">'
                    : '';

                /* 이미지 카드 HTML 반환값 */
                return '<div class="file-preview-item">'
                    + imgHtml
                    + '<div class="file-preview-name">' + safeName + '</div>'
                    + '</div>';
            }).join("");
        }


        function renderRelatedHistory(historyList) {
            var area = document.getElementById("detailHistoryBody"); /* 이력 영역 */

            if (!historyList || historyList.length === 0) {
                area.innerHTML = '<div class="ds-empty">최근 점검·보수 이력이 없습니다.</div>';
                return;
            }

            area.innerHTML = historyList.slice(0, 3).map(function (history) {
                var historyNo = escapeHtml(history.facChkHstryNo || history.facChkHistNo || "-"); /* 이력번호 */
                var status = escapeHtml(history.chkSttsNm || history.chkSttsCd || "-");           /* 상태 */
                var content = escapeHtml(history.chkCn || "-");                                   /* 내용 */
                var date = escapeHtml(formatDate(history.chkDt) || "-");                          /* 점검일 */

                return '<div class="ds-row">'
                    + '<span class="ds-no">' + historyNo + '</span>'
                    + '<span class="ds-nm">[' + status + '] ' + content + '</span>'
                    + '<span class="ds-dt">' + date + '</span>'
                    + '</div>';
            }).join("");
        }


        /**
         * 시설 기본정보 렌더링 처리
         * - 시설번호/시설명/시설유형/활성여부 표시
         */
        function renderFacilityInfo(facility) {
            /* 시설 정보 테이블 본문 영역 */
            var area = document.getElementById("detailFacilityInfoBody");

            /* 시설유형 표시값 */
            var facilityTypeText = facility.facilityTyNm || facility.facilityTyCd || "-";

            /* 시설 정보 HTML 출력 처리 */
            area.innerHTML = ""
                + tableRow("시설번호", escapeHtml(facility.facilityNo))
                + tableRow("시설명", escapeHtml(facility.facilityNm))
                + tableRow("시설유형", badge("badge-blue", facilityTypeText))
                + tableRow("활성여부", useYnBadge(facility.useYn));
        }

        /**
         * 위치 정보 렌더링 처리
         * - 위치구분/동/상세위치/설치일자 표시
         */
        function renderLocationInfo(facility) {
            /* 위치 정보 테이블 본문 영역 */
            var area = document.getElementById("detailLocationInfoBody");

            /* 위치구분 표시값 */
            var locationTypeText = facility.dongNo ? "동 위치" : "공용 위치";

            /* 동 표시값 */
            var dongText = formatDongNo(facility.dongNo);

            /* 상세위치 표시값 */
            var locText = facility.locCn || "-";

            /* 설치일자 표시값 */
            var installDateText = formatDate(facility.instlDt) || "-";

            /* 위치 정보 HTML 출력 처리 */
            area.innerHTML = ""
                + tableRow("위치구분", escapeHtml(locationTypeText))
                + tableRow("동", escapeHtml(dongText))
                + tableRow("상세위치", escapeHtml(locText))
                + tableRow("설치일자", escapeHtml(installDateText));
        }

        /**
         * 비활성 안내 렌더링 처리
         * - 시설 useYn이 N일 때만 안내 영역 표시
         */
        function renderDisabledNotice(facility) {
            /* 비활성 안내 영역 */
            var section = document.getElementById("detailDisabledSection");

            /* 비활성 안내 내용 영역 */
            var reason = document.getElementById("detailDisabledReason");

            /* 활성 상태 여부 */
            var isActive = facility.useYn !== "N";

            /* 활성 상태 안내 숨김 처리 */
            if (isActive) {
                section.style.display = "none";
                reason.innerHTML = "";
                return;
            }

            /* 비활성 안내 표시 처리 */
            section.style.display = "flex";

            /* 비활성 안내 문구 출력 처리 */
            reason.innerHTML = "이 시설은 현재 <strong>비활성</strong> 상태입니다. 기존 점검·계약·검침 연결 정보는 유지됩니다.";
        }

        /**
         * 편의시설 운영관리 안내 렌더링 처리
         * - 편의시설일 때만 운영관리 안내 표시
         */
        function renderPublicFacilityNotice(facility) {
            /* 편의시설 안내 영역 */
            var notice = document.getElementById("publicFacilityNotice");
            var link = document.getElementById("publicFacilityNoticeLink");

            /* 안내 영역 없음 방어 처리 */
            if (!notice) {
                return;
            }

            /* 편의시설 여부 */
            var isPublicFacility = facility.facilityKind === "PUBLIC";

            /* 편의시설 안내 표시 처리 */
            notice.style.display = isPublicFacility ? "flex" : "none";

            if (!isPublicFacility || !link) {
                return;
            }

            /*
             * 편의시설 운영관리 바로가기 상태별 분기
             * - 운영관리 등록 전: 기존 시설자산 선택 등록 화면으로 이동
             * - 운영관리 등록 후: 해당 공용시설 운영정보 수정 화면으로 이동
             */
            if (facility.publicOperRegisteredYn === "Y" && facility.cmnFacilityNo) {
                link.href = contextPath + "/manager/publicFacility/update-page/"
                    + encodeURIComponent(mgmtOfcNo) + "/"
                    + encodeURIComponent(facility.cmnFacilityNo);
                link.textContent = "등록된 운영관리 수정하기 →";
                return;
            }

            link.href = contextPath + "/manager/publicFacility/register/"
                + encodeURIComponent(mgmtOfcNo) + "?facilityNo="
                + encodeURIComponent(facility.facilityNo || "");
            link.textContent = "운영관리 등록하기 →";
        }

        /**
         * 수정 버튼 이벤트 연결 처리
         * - 관리자 권한은 수정 버튼 없음/조회 전용 처리
         * - 일반 관리자는 수정 화면으로 이동 처리
         */
        function bindEditButton(facility) {
            /* 수정 버튼 요소 */
            var editBtn = document.getElementById("detailEditBtnTop");

            /* 수정 버튼 없음 또는 관리자 여부 */
            var cannotEdit = !editBtn || isAdmin;

            /* 수정 불가 상태 방어 처리 */
            if (cannotEdit) {
                return;
            }

            /* 수정 버튼 문구 지정 처리 */
            editBtn.textContent = "수정";

            /* 수정 버튼 클릭 이벤트 연결 처리 */
            editBtn.onclick = function () {
                /* 수정 화면 이동 주소 */
                var updateUrl = contextPath + "/manager/facility/update-page/"
                    + encodeURIComponent(mgmtOfcNo) + "/"
                    + encodeURIComponent(facility.facilityNo);

                /* 수정 화면 이동 처리 */
                location.href = updateUrl;
            };
        }

        /**
         * 시설 상세 전체 렌더링 처리
         * - API 응답을 화면 각 영역에 분배 처리
         */
        function renderDetail(result) {
            /* 시설 상세 객체 */
            var facility = getResultFacility(result);

            /* 화면 제목 지정 처리 */
            document.getElementById("detailModalTitle").textContent = "시설 상세";

            /* 비활성 안내 렌더링 처리 */
            renderDisabledNotice(facility);

            /* 시설 기본정보 렌더링 처리 */
            renderFacilityInfo(facility);

            /* 위치 정보 렌더링 처리 */
            renderLocationInfo(facility);

            /* 시설 사진 렌더링 처리 */
            renderDetailFiles(result.fileList || result.attachFileList || facility.fileList || []);

            /* 최근 점검·보수 이력 렌더링 */
            renderRelatedHistory(result.recentHistoryList || result.recentCheckList || []);

            /* 편의시설 안내 렌더링 처리 */
            renderPublicFacilityNotice(facility);

            /* 수정 버튼 이벤트 연결 처리 */
            bindEditButton(facility);
        }

        /* ============================================================
           5. 초기 실행
        ============================================================ */

        /**
         * DOM 로딩 후 초기화 처리
         * - 이미지 모달 닫기 이벤트 연결
         * - 목록 버튼 이벤트 연결
         * - 시설 상세 API 조회 실행
         */
        document.addEventListener("DOMContentLoaded", function () {
            /* 이미지 확대 모달 이벤트 연결 처리 */
            bindImagePreviewModal();

            /* 목록 버튼 요소 */
            var backBtn = document.getElementById("backToListBtnTop");

            /* 목록 버튼 클릭 이벤트 연결 처리 */
            backBtn.addEventListener("click", function () {
                location.href = listUrl();
            });

            /* 상세 조회 API 주소 */
            var detailApiUrl = apiUrl("detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo));

            /* 상세 조회 실행 및 화면 렌더링 처리 */
            getJson(detailApiUrl)
                .then(renderDetail)
                .catch(function (err) {
                    /* 오류 로그 출력 처리 */
                    console.error(err);

                    /* 오류 알림 출력 처리 */
                    alertMessage(err.message || "상세 정보를 불러오지 못했습니다.");
                });
        });
    })();
</script>
<%-- 사이드바/헤더 현재 위치 설정 --%>
<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/facility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="시설 상세" />

<%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
</body>
</html>
