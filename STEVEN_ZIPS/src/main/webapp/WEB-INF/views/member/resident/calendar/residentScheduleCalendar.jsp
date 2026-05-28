<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우리 단지 일정</title>

    <sec:csrfMetaTags/>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif !important;
            background: var(--bg);
            color: var(--text-dark);
            margin: 0;
        }

        .material-symbols-rounded {
            font-family: 'Material Symbols Rounded' !important;
        }

        .material-symbols-outlined {
            font-family: 'Material Symbols Outlined' !important;
        }

        .main-shell {
            display: flex;
            align-items: stretch;
            width: 100%;
            min-height: calc(100vh - 114px);
            margin-top: 114px;
            background: var(--bg);
        }

        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
        }

        .page-content-wrap {
            max-width: 1080px;
            width: 100%;
            margin: 0 auto;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--text-light);
            margin-bottom: 18px;
        }

        .breadcrumb a {
            color: var(--text-light);
            text-decoration: none;
        }

        .breadcrumb .cur {
            color: var(--green-dark);
            font-weight: 700;
        }

        .page-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-dark);
            padding-bottom: 14px;
            border-bottom: 2px solid var(--green-dark);
            margin-bottom: 16px;
            letter-spacing: -0.4px;
        }

        .calendar-hero {
            background: linear-gradient(135deg, var(--green-dark), #386a4d);
            color: #fff;
            border-radius: 14px;
            padding: 18px 28px 16px;
            margin-bottom: 16px;
            border: 1px solid var(--border);
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
        }

        .calendar-hero h2 {
            font-size: 18px;
            margin: 0 0 6px;
            font-weight: 800;
        }

        .calendar-hero p {
            margin: 0;
            font-size: 12px;
            line-height: 1.6;
            color: rgba(255, 255, 255, 0.82);
        }

        .stat-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 20px;
        }

        .stat-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            min-height: 88px;
            padding: 14px 18px;
            display: flex;
            align-items: center;
            gap: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
        }

        .stat-icon {
            width: 46px;
            height: 46px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            flex-shrink: 0;
        }

        .stat-icon.green { background: #1f7a55; }
        .stat-icon.blue { background: #2563eb; }
        .stat-icon.yellow { background: #d99b1f; }
        .stat-icon.purple { background: #7c3aed; }

        .stat-icon .material-symbols-rounded {
            font-size: 26px;
        }

        .stat-value {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-dark);
        }

        .stat-label {
            margin-top: 4px;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-light);
        }

        .card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
            padding: 20px;
            margin-bottom: 20px;
        }

        .section-hd {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border);
        }

        .section-hd h3 {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .section-hd span {
            font-size: 12px;
            color: var(--text-light);
        }

        .tab-bar {
            display: flex;
            align-items: center;
            gap: 22px;
            margin: 0 0 18px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
        }

        .tab-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            height: 34px;
            padding: 0;
            border: none;
            border-radius: 0;
            background: transparent;
            color: var(--text-mid);
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
        }

        .tab-btn.active {
            color: var(--green-dark);
            background: transparent;
            border-bottom: 2px solid var(--green-dark);
        }

        .search-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
            padding: 14px;
            margin-bottom: 18px;
        }

        .filter-row {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 0;
            flex-wrap: wrap;
        }

        .calendar-search-input {
            height: 38px;
            border: 1px solid #d7dce1;
            border-radius: 8px;
            padding: 0 14px;
            background: #fff;
            color: #374151;
            font-size: 13px;
            font-weight: 500;
            box-sizing: border-box;
            outline: none;
            transition: border-color 0.2s ease;
        }

        select.calendar-search-input {
            width: 150px;
            cursor: pointer;

            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;

            padding-right: 38px;

            background-color: #fff;

            /*
             * select 화살표 직접 추가
             */
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='18' height='18' fill='none' stroke='%236b7280' stroke-width='2' viewBox='0 0 24 24'%3E%3Cpath d='m6 9 6 6 6-6'/%3E%3C/svg%3E");

            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
        }

        .calendar-search-input::placeholder {
            color: #9ca3af;
            font-size: 13px;
        }

        .calendar-search-input:focus {
            border-color: #b8c0c8;
            box-shadow: none;
        }
        input.calendar-search-input,
        select.calendar-search-input {
            border: 1px solid #d7dce1 !important;
            box-shadow: none !important;
            border-radius: 8px;
        }

        .btn-main {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-width: 72px;
            height: 36px;
            border: none;
            border-radius: 5px;
            padding: 0 16px;
            background: #006b4f;
            color: #fff;
            font-size: 13px;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-main .material-symbols-rounded {
            font-size: 18px;
            font-weight: 700;
        }

        .btn-ghost {
            min-width: 58px;
            height: 34px;
            border-radius: 8px;
            padding: 0 14px;
            font-size: 12px;
            background: #fff;
            color: var(--text-mid);
            border: 1px solid var(--border);
        }

        .calendar-nav .btn-ghost {
            min-width: 58px;
            width: 58px;
            padding: 0;
        }

        .btn-mini {
            min-width: 34px;
            height: 34px;
            border-radius: 10px;
            padding: 0 10px;
            font-size: 12px;
            background: #fff;
            border: 1px solid var(--border);
            color: var(--text-mid);
        }

        .calendar-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 14px;
        }

        .calendar-nav {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .calendar-title {
            min-width: 115px;
            text-align: center;
            font-size: 18px;
            font-weight: 800;
            color: #172033;
        }

        .legend-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
            margin: 10px 0 14px;
            font-size: 12px;
            color: #64748b;
        }

        .legend-dot {
            width: 9px;
            height: 9px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 4px;
        }

        .legend-dot.NOTICE { background: #2563eb; }
        .legend-dot.EVENT { background: #16a34a; }
        .legend-dot.VACATION { background: #7c3aed; }
        .legend-dot.CONSTRUCTION { background: #ea580c; }
        .legend-dot.METER { background: #0891b2; }
        .legend-dot.CHECK { background: #64748b; }

        .apt-calendar {
            table-layout: fixed;
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-top: 2px solid #2563eb;
        }

        .apt-calendar th {
            height: 36px;
            text-align: center;
            font-size: 12px;
            font-weight: 800;
            border: 1px solid #e5e7eb;
            background: #f8fafc;
        }

        .apt-calendar td {
            height: 128px;
            vertical-align: top;
            padding: 8px 7px;
            border: 1px solid #e5e7eb;
            background: #fff;
        }

        .apt-calendar td.other-month {
            background: #fafafa;
        }

        .apt-calendar td.today {
            background: #f0f7ff;
        }

        .day-num {
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 5px;
            color: #334155;
        }

        .sun .day-num {
            color: #dc2626;
        }

        .sat .day-num {
            color: #2563eb;
        }

        .schedule-chip {
            display: block;
            width: 100%;
            max-width: 100%;
            border: 1px solid currentColor;
            background: #fff;
            border-radius: 999px;
            padding: 2px 7px;
            margin-bottom: 3px;
            font-size: 10px;
            line-height: 16px;
            font-weight: 700;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: pointer;
            box-sizing: border-box;
        }

        .schedule-chip.NOTICE { color: #2563eb; }
        .schedule-chip.EVENT { color: #16a34a; }
        .schedule-chip.VACATION { color: #7c3aed; }
        .schedule-chip.CONSTRUCTION { color: #ea580c; }
        .schedule-chip.METER { color: #0891b2; }
        .schedule-chip.CHECK { color: #64748b; }

        .more-count {
            margin-top: 3px;
            font-size: 10px;
            color: #475569;
            text-align: center;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
        }

        .data-table thead th {
            text-align: center;
            background: #f3f3f3;
            color: #111827;
            padding: 12px 14px;
            font-weight: 700;
            border-top: 2px solid #333;
            border-bottom: 1px solid var(--border);
        }

        .data-table tbody td {
            padding: 13px 14px;
            border-bottom: 1px solid #edf0eb;
            color: var(--text-dark);
            vertical-align: middle;
            text-align: center;
            white-space: nowrap;
        }

        .data-table tbody tr:last-child td {
            border-bottom: none;
        }

        .data-table .td-title {
            text-align: left;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .schedule-list-detail {
            border: none;
            background: transparent;
            padding: 0;
            color: var(--text-dark);
            font-weight: 700;
            cursor: pointer;
            max-width: 100%;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .schedule-list-detail:hover {
            color: var(--green-dark);
            text-decoration: underline;
        }

        .modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, .45);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-backdrop.active {
            display: flex;
        }

        .modal-card {
            width: 460px;
            max-width: calc(100vw - 32px);
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(15, 23, 42, .25);
            overflow: hidden;
        }

        .modal-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 18px;
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-title {
            font-size: 16px;
            font-weight: 800;
        }

        .modal-body {
            padding: 18px;
        }

        .detail-row {
            margin-bottom: 12px;
            font-size: 14px;
            color: #334155;
        }

        .detail-label {
            display: block;
            font-size: 12px;
            font-weight: 800;
            margin-bottom: 5px;
            color: #64748b;
        }

        .modal-foot {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            padding: 14px 18px;
            border-top: 1px solid #e5e7eb;
        }

        @media (max-width: 1200px) {
            .stat-row {
                grid-template-columns: repeat(2, 1fr);
            }

            .filter-row {
                flex-wrap: wrap;
            }
        }

        @media (max-width: 900px) {
            .main-shell {
                flex-direction: column;
            }

            .content-area {
                padding: 24px 18px 48px;
            }

            .page-content-wrap {
                max-width: 100%;
            }

            .stat-row {
                grid-template-columns: 1fr;
            }

            input.calendar-search-input,
            select.calendar-search-input {
                width: 100%;
            }

            .calendar-topbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .calendar-nav {
                width: 100%;
                justify-content: flex-start;
                flex-wrap: wrap;
            }
        }

        /*
     * 초기화 버튼
     * 검색버튼보다 연한 회색 스타일로 처리.
     */
        .btn-reset {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-width: 86px;
            height: 38px;
            border-radius: 8px;
            border: 1px solid #d7dce1;
            background: #fff;
            color: #4b5563;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .btn-reset:hover {
            background: #f3f4f6;
        }

        .btn-reset .material-symbols-rounded {
            font-size: 18px;
        }
    </style>
</head>

<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>

<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>

    <main class="content-area">
        <div class="page-content-wrap" id="residentScheduleCalendarPage">

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">관리사무소</a>
                <span>›</span>
                <span class="cur">우리 단지 일정</span>
            </div>

            <h1 class="page-title">우리 단지 일정</h1>

            <section class="calendar-hero">
                <h2>단지 일정 캘린더</h2>
                <p>
                    우리 아파트의 공지, 행사, 공사, 검침, 점검, 직원 휴가 일정을
                    월별 캘린더와 목록으로 확인할 수 있습니다.
                </p>
            </section>

            <div class="stat-row">
                <div class="stat-card">
                    <div class="stat-icon green">
                        <span class="material-symbols-rounded">event_available</span>
                    </div>
                    <div>
                        <div class="stat-value" id="totalCnt">0</div>
                        <div class="stat-label">전체 일정</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon blue">
                        <span class="material-symbols-rounded">today</span>
                    </div>
                    <div>
                        <div class="stat-value" id="todayCnt">0</div>
                        <div class="stat-label">오늘 일정</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon yellow">
                        <span class="material-symbols-rounded">calendar_month</span>
                    </div>
                    <div>
                        <div class="stat-value" id="monthCnt">0</div>
                        <div class="stat-label">이번 달 일정</div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon purple">
                        <span class="material-symbols-rounded">badge</span>
                    </div>
                    <div>
                        <div class="stat-value" id="vacationCnt">0</div>
                        <div class="stat-label">직원 휴가</div>
                    </div>
                </div>
            </div>

            <div class="tab-bar">
                <button type="button" class="tab-btn active" data-tab="calendar">
                    <span class="material-symbols-rounded">calendar_month</span>
                    달력
                </button>

                <button type="button" class="tab-btn" data-tab="list">
                    <span class="material-symbols-rounded">list_alt</span>
                    전체 목록
                </button>
            </div>

            <section class="search-card">
                <div class="filter-row">

                    <select id="scheduleTy" class="calendar-search-input">
                        <option value="ALL">전체 유형</option>
                        <option value="NOTICE">공지</option>
                        <option value="EVENT">행사</option>
                        <option value="VACATION">직원휴가</option>
                        <option value="CONSTRUCTION">공사</option>
                        <option value="METER">검침</option>
                        <option value="CHECK">점검</option>
                    </select>

                    <input type="text"
                           id="keyword"
                           class="calendar-search-input"
                           placeholder="일정명, 내용, 위치, 직원명 검색">

                    <button type="button" class="btn-main" id="searchBtn">
                        <span class="material-symbols-rounded">search</span>
                        검색
                    </button>

                    <!-- 초기화 버튼 추가 -->
                    <button type="button" class="btn-reset" id="resetBtn">
                        <span class="material-symbols-rounded">refresh</span>
                        초기화
                    </button>

                </div>
            </section>

            <section class="card tab-panel active" id="calendarPanel">
                <div class="section-hd calendar-topbar">
                    <h3>
                        <span class="material-symbols-rounded">calendar_month</span>
                        월간 일정
                    </h3>

                    <div class="calendar-nav">
                        <button type="button" class="btn-mini" id="prevMonthBtn">
                            <span class="material-symbols-rounded">chevron_left</span>
                        </button>

                        <strong class="calendar-title" id="calendarTitle"></strong>

                        <button type="button" class="btn-mini" id="nextMonthBtn">
                            <span class="material-symbols-rounded">chevron_right</span>
                        </button>

                        <button type="button" class="btn-ghost" id="todayBtn">
                            오늘
                        </button>
                    </div>
                </div>

                <div class="legend-row">
                    <span><i class="legend-dot NOTICE"></i>공지</span>
                    <span><i class="legend-dot EVENT"></i>행사</span>
                    <span><i class="legend-dot VACATION"></i>직원휴가</span>
                    <span><i class="legend-dot CONSTRUCTION"></i>공사</span>
                    <span><i class="legend-dot METER"></i>검침</span>
                    <span><i class="legend-dot CHECK"></i>점검</span>
                </div>

                <table class="apt-calendar">
                    <thead>
                    <tr>
                        <th style="color:#dc2626;">일</th>
                        <th>월</th>
                        <th>화</th>
                        <th>수</th>
                        <th>목</th>
                        <th>금</th>
                        <th style="color:#2563eb;">토</th>
                    </tr>
                    </thead>
                    <tbody id="calendarBody"></tbody>
                </table>
            </section>

            <section class="card tab-panel" id="listPanel" style="display:none;">
                <div class="section-hd">
                    <h3>
                        <span class="material-symbols-rounded">list_alt</span>
                        전체 일정 목록
                    </h3>
                    <span>현재 조회 월 기준 목록입니다.</span>
                </div>

                <table class="data-table schedule-list-table">
                    <thead>
                    <tr>
                        <th style="width:70px;">유형</th>
                        <th>일정명</th>
                        <th style="width:180px;">기간</th>
                        <th style="width:140px;">위치</th>
                        <th style="width:100px;">등록자/직원</th>
                    </tr>
                    </thead>
                    <tbody id="scheduleListBody">
                    <tr>
                        <td colspan="5">조회된 일정이 없습니다.</td>
                    </tr>
                    </tbody>
                </table>
            </section>

        </div>
    </main>
</div>

<div class="modal-backdrop" id="detailModal">
    <div class="modal-card">
        <div class="modal-head">
            <div class="modal-title" id="detailTitle">일정 상세</div>
        </div>

        <div class="modal-body">
            <div class="detail-row">
                <span class="detail-label">유형</span>
                <span id="detailType">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">기간</span>
                <span id="detailPeriod">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">위치</span>
                <span id="detailLoc">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">등록자/직원</span>
                <span id="detailPerson">-</span>
            </div>

            <div class="detail-row">
                <span class="detail-label">내용</span>
                <span id="detailCn">-</span>
            </div>
        </div>

        <div class="modal-foot">
            <button type="button" class="btn-ghost" id="closeDetailFootBtn">
                닫기
            </button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
    (function () {
        const contextPath = '${pageContext.request.contextPath}';
        const aptCmplexNo = '${aptCmplexNo}';

        let currentDate = new Date();
        let scheduleList = [];

        const calendarTitle = document.getElementById('calendarTitle');
        const calendarBody = document.getElementById('calendarBody');
        const scheduleListBody = document.getElementById('scheduleListBody');

        /*
         * pad 함수
         * 숫자를 2자리 문자열로 맞춘다.
         * 예: 1 -> 01
         */
        function pad(num) {
            return String(num).padStart(2, '0');
        }

        /*
         * 날짜를 YYYY-MM-DD 형식으로 변환한다.
         */
        function formatDate(date) {
            return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate());
        }

        /*
         * escapeHtml이란?
         * HTML 태그가 화면에서 실행되지 않도록 문자로 바꾸는 함수.
         * 왜 사용? DB 값에 태그가 들어와도 안전하게 출력하기 위해.
         */
        function escapeHtml(value) {
            if (value === null || value === undefined) {
                return '';
            }

            return String(value).replace(/[&<>"]/g, function (s) {
                return {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;'
                }[s];
            });
        }

        /*
         * 현재 월의 시작일과 종료일을 구한다.
         */
        function getMonthRange() {
            const first = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
            const last = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);

            return {
                start: formatDate(first),
                end: formatDate(last)
            };
        }

        /*
         * 일정 목록 + 통계 조회
         *
         * fetch란?
         * JavaScript에서 서버로 요청을 보내는 기능.
         * 왜 사용? 화면 새로고침 없이 캘린더 일정만 다시 조회하기 위해.
         */
        function loadSchedule() {
            const range = getMonthRange();

            const params = new URLSearchParams();
            params.append('monthStartDt', range.start);
            params.append('monthEndDt', range.end);
            params.append('scheduleTy', document.getElementById('scheduleTy').value);
            params.append('keyword', document.getElementById('keyword').value.trim());

            fetch(contextPath + '/resident/calendar/' + aptCmplexNo + '/list?' + params.toString())
                .then(function (res) {
                    return res.json();
                })
                .then(function (data) {
                    scheduleList = Array.isArray(data) ? data : [];

                    renderCalendar();
                    renderList();
                })
                .catch(function () {
                    alert('일정 조회 중 오류가 발생했습니다.');
                });

            fetch(contextPath + '/resident/calendar/' + aptCmplexNo + '/stat?' + params.toString())
                .then(function (res) {
                    return res.json();
                })
                .then(function (stat) {
                    renderStat(stat || {});
                })
                .catch(function () {
                    renderStat({});
                });
        }

        /*
         * 상단 통계 카드 출력
         */
        function renderStat(stat) {
            document.getElementById('totalCnt').textContent = stat.totalCnt || 0;
            document.getElementById('todayCnt').textContent = stat.todayCnt || 0;
            document.getElementById('monthCnt').textContent = stat.monthCnt || 0;
            document.getElementById('vacationCnt').textContent = stat.vacationCnt || 0;
        }

        /*
         * 달력 출력
         */
        function renderCalendar() {
            const year = currentDate.getFullYear();
            const month = currentDate.getMonth();

            calendarTitle.textContent = year + '년 ' + (month + 1) + '월';

            const firstDay = new Date(year, month, 1);
            const startDate = new Date(year, month, 1 - firstDay.getDay());
            const todayStr = formatDate(new Date());

            let html = '';

            for (let week = 0; week < 6; week++) {
                html += '<tr>';

                for (let day = 0; day < 7; day++) {
                    const cellDate = new Date(startDate);
                    cellDate.setDate(startDate.getDate() + (week * 7) + day);

                    const dateStr = formatDate(cellDate);
                    const isOther = cellDate.getMonth() !== month;
                    const dayClass = day === 0 ? 'sun' : (day === 6 ? 'sat' : '');
                    const todayClass = dateStr === todayStr ? 'today' : '';
                    const items = getSchedulesByDate(dateStr);

                    html += '<td class="' + dayClass + ' ' + todayClass + (isOther ? ' other-month' : '') + '">';
                    html += '<div class="day-num">' + cellDate.getDate() + '</div>';

                    items.slice(0, 5).forEach(function (item) {
                        html += '<button type="button"'
                            + ' class="schedule-chip ' + escapeHtml(item.scheduleTy) + '"'
                            + ' title="' + escapeHtml(item.scheduleTtl) + '"'
                            + ' data-schedule-no="' + escapeHtml(item.scheduleNo) + '">';
                        html += escapeHtml(item.scheduleTtl);
                        html += '</button>';
                    });

                    if (items.length > 5) {
                        html += '<div class="more-count">전체 +' + (items.length - 5) + '</div>';
                    }

                    html += '</td>';
                }

                html += '</tr>';
            }

            calendarBody.innerHTML = html;

            document.querySelectorAll('.schedule-chip').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    const scheduleNo = btn.dataset.scheduleNo;

                    const selected = scheduleList.find(function (item) {
                        return String(item.scheduleNo) === String(scheduleNo);
                    });

                    if (selected) {
                        openDetailModal(selected);
                    }
                });
            });
        }

        /*
         * 해당 날짜에 포함되는 일정 찾기
         */
        function getSchedulesByDate(dateStr) {
            return scheduleList.filter(function (item) {
                return item.startDt <= dateStr && item.endDt >= dateStr;
            });
        }

        /*
         * 전체 목록 출력
         */
        function renderList() {
            if (!scheduleList.length) {
                scheduleListBody.innerHTML = '<tr><td colspan="5">조회된 일정이 없습니다.</td></tr>';
                return;
            }

            scheduleListBody.innerHTML = scheduleList.map(function (item) {
                const period = item.startDt === item.endDt
                    ? item.startDt
                    : item.startDt + ' ~ ' + item.endDt;

                const person = item.userNm || item.rgtrId || '-';

                return '<tr>'
                    + '<td>' + escapeHtml(item.scheduleTyNm) + '</td>'
                    + '<td class="td-title">'
                    + '<button type="button" class="schedule-list-detail" data-schedule-no="' + escapeHtml(item.scheduleNo) + '">'
                    + escapeHtml(item.scheduleTtl)
                    + '</button>'
                    + '</td>'
                    + '<td>' + escapeHtml(period) + '</td>'
                    + '<td>' + escapeHtml(item.locCn || '-') + '</td>'
                    + '<td>' + escapeHtml(person) + '</td>'
                    + '</tr>';
            }).join('');

            document.querySelectorAll('.schedule-list-detail').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    const scheduleNo = btn.dataset.scheduleNo;

                    const selected = scheduleList.find(function (item) {
                        return String(item.scheduleNo) === String(scheduleNo);
                    });

                    if (selected) {
                        openDetailModal(selected);
                    }
                });
            });
        }

        /*
         * 일정 상세 모달 열기
         */
        function openDetailModal(item) {
            const period = item.startDt === item.endDt
                ? item.startDt
                : item.startDt + ' ~ ' + item.endDt;

            const person = item.userNm || item.rgtrId || '-';

            document.getElementById('detailTitle').textContent = item.scheduleTtl || '일정 상세';
            document.getElementById('detailType').textContent = item.scheduleTyNm || '-';
            document.getElementById('detailPeriod').textContent = period || '-';
            document.getElementById('detailLoc').textContent = item.locCn || '-';
            document.getElementById('detailPerson').textContent = person;
            document.getElementById('detailCn').textContent = item.scheduleCn || '-';

            document.getElementById('detailModal').classList.add('active');
        }

        /*
         * 일정 상세 모달 닫기
         */
        function closeDetailModal() {
            document.getElementById('detailModal').classList.remove('active');
        }

        document.getElementById('prevMonthBtn').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() - 1);
            loadSchedule();
        });

        document.getElementById('nextMonthBtn').addEventListener('click', function () {
            currentDate.setMonth(currentDate.getMonth() + 1);
            loadSchedule();
        });

        document.getElementById('todayBtn').addEventListener('click', function () {
            currentDate = new Date();
            loadSchedule();
        });

        document.getElementById('searchBtn').addEventListener('click', loadSchedule);

        document.getElementById('keyword').addEventListener('keydown', function (e) {
            if (e.key === 'Enter') {
                loadSchedule();
            }
        });

        document.querySelectorAll('.tab-btn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.querySelectorAll('.tab-btn').forEach(function (b) {
                    b.classList.remove('active');
                });

                btn.classList.add('active');

                const tab = btn.dataset.tab;

                document.getElementById('calendarPanel').style.display = tab === 'calendar' ? 'block' : 'none';
                document.getElementById('calendarPanel').classList.toggle('active', tab === 'calendar');

                document.getElementById('listPanel').style.display = tab === 'list' ? 'block' : 'none';
                document.getElementById('listPanel').classList.toggle('active', tab === 'list');
            });
        });

        document.getElementById('closeDetailFootBtn').addEventListener('click', closeDetailModal);

        document.getElementById('detailModal').addEventListener('click', function (e) {
            if (e.target.id === 'detailModal') {
                closeDetailModal();
            }
        });

        /*
         * 검색조건 초기화
         */
        const resetBtn = document.getElementById('resetBtn');

        if (resetBtn) {
            resetBtn.addEventListener('click', function () {
                document.getElementById('scheduleTy').value = 'ALL';
                document.getElementById('keyword').value = '';

                loadSchedule();
            });
        }

        loadSchedule();
    })();

</script>
</body>
</html>