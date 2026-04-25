<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>단지 관리자 계정 관리 – 우리집맵핑</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <style>
        :root {
            --green-dark: #2d5a3d;
            --green-mid: #3d7a52;
            --green-light: #e8f2ec;
            --green-pale: #f4f9f6;
            --text-dark: #1a1a1a;
            --text-mid: #444;
            --text-light: #777;
            --border: #dde8e2;
            --white: #ffffff;
            --bg: #f8faf9;
            --admin-header-height: 64px;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Noto Sans KR', sans-serif !important;
            background: var(--bg) !important;
            color: var(--text-dark) !important;
        }

        /* 기존 headerLayout.jsp의 .site-header와 충돌 방지 */
        .site-header {
            display: none !important;
        }

        .material-symbols-rounded,
        .material-symbols-outlined {
            font-family: 'Material Symbols Rounded' !important;
            font-weight: normal;
            font-style: normal;
            font-size: 20px;
            line-height: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            vertical-align: middle;
            font-variation-settings:
                    'FILL' 0,
                    'wght' 400,
                    'GRAD' 0,
                    'opsz' 24;
        }

        .admin-page-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            height: var(--admin-header-height);
            background: #fff;
            border-bottom: 1px solid var(--border);
            z-index: 1200;
        }

        .admin-page-header-inner {
            height: 100%;
            padding: 0 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .admin-page-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            color: var(--green-dark);
        }

        .admin-page-logo strong {
            font-size: 17px;
            font-weight: 800;
        }

        .admin-page-logo p {
            margin: 2px 0 0;
            font-size: 9px;
            letter-spacing: 1.8px;
            color: var(--text-light);
        }

        .admin-page-user {
            display: flex;
            align-items: center;
            gap: 12px;
            text-align: right;
        }

        .admin-page-user strong {
            font-size: 13px;
            font-weight: 800;
        }

        .admin-page-user p {
            margin: 2px 0 0;
            font-size: 11px;
            color: var(--text-light);
        }

        .admin-page-user button {
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text-mid);
            border-radius: 10px;
            padding: 8px 12px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .main-shell {
            display: flex;
            align-items: stretch;
            width: 100%;
            min-height: calc(100vh - var(--admin-header-height));
            margin-top: var(--admin-header-height);
            background: var(--bg);
        }

        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
        }

        .page-content-wrap {
            max-width: 1180px;
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

        .page-title-row {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            border-bottom: 2px solid var(--green-dark);
            padding-bottom: 14px;
            margin-bottom: 16px;
        }

        .page-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-dark);
            margin: 0;
        }

        .page-desc {
            font-size: 13px;
            line-height: 1.8;
            color: var(--text-light);
            margin: 0 0 24px;
        }

        .btn-row-right {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            flex-wrap: wrap;
        }

        .hero-card,
        .panel {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, .05);
        }

        .hero-card {
            padding: 24px 28px;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--green-dark), #386a4d);
            color: #fff;
        }

        .hero-card h2 {
            font-size: 20px;
            margin: 0 0 8px;
        }

        .hero-card p {
            margin: 0;
            line-height: 1.8;
            color: rgba(255, 255, 255, .82);
            font-size: 13px;
        }

        .chip-row {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 14px;
        }

        .chip {
            display: inline-flex;
            align-items: center;
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            background: rgba(255, 255, 255, .18);
            color: #fff;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 24px;
        }

        .stat-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
        }

        .stat-label {
            color: var(--text-light);
            font-size: 12px;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 800;
            color: var(--green-dark);
        }

        .stat-sub {
            margin-top: 6px;
            font-size: 12px;
            color: var(--text-light);
        }

        .panel {
            padding: 20px;
            margin-bottom: 20px;
        }

        .section-hd {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            margin-bottom: 14px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--border);
        }

        .section-hd h3 {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
            color: var(--text-dark);
        }

        .section-hd span {
            font-size: 12px;
            color: var(--text-light);
        }

        .section-title-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .section-title-left .material-symbols-rounded {
            color: var(--green-dark);
        }

        .role-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
        }

        .role-card {
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 18px;
            background: #fff;
        }

        .role-code {
            display: inline-flex;
            margin-bottom: 10px;
            padding: 4px 10px;
            border-radius: 999px;
            background: #edf5ef;
            color: var(--green-dark);
            font-size: 11px;
            font-weight: 800;
        }

        .role-card h4 {
            margin: 0 0 8px;
            font-size: 15px;
            font-weight: 800;
        }

        .role-card p {
            margin: 0;
            font-size: 12px;
            line-height: 1.7;
            color: var(--text-light);
        }

        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 14px;
            flex-wrap: wrap;
        }

        .search-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .search-box,
        .select-box {
            position: relative;
            display: inline-flex;
            align-items: center;
        }

        .fake-input,
        .fake-select,
        .fake-textarea {
            border: 1px solid #d8ddd4;
            background: #fff;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 13px;
            color: var(--text-dark);
            box-sizing: border-box;
            font-family: inherit;
        }

        .fake-input {
            min-width: 240px;
            padding-right: 40px;
        }

        .fake-select {
            min-width: 140px;
            padding-right: 40px;
            appearance: none;
            -webkit-appearance: none;
            -moz-appearance: none;
        }

        .fake-textarea {
            width: 100%;
            min-height: 90px;
            resize: vertical;
        }

        .search-icon,
        .select-icon {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
            font-size: 19px;
        }

        .search-icon {
            cursor: pointer;
        }

        .select-icon {
            pointer-events: none;
        }

        .btn-main,
        .btn-sub,
        .btn-danger,
        .btn-ghost {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            min-width: 112px;
            padding: 10px 16px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 800;
            text-decoration: none;
            border: none;
            cursor: pointer;
            box-sizing: border-box;
            font-family: inherit;
            white-space: nowrap;
        }

        .btn-main {
            background: var(--green-dark);
            color: #fff;
        }

        .btn-sub {
            background: #edf5ef;
            color: var(--green-dark);
        }

        .btn-danger {
            background: #b64444;
            color: #fff;
        }

        .btn-ghost {
            background: #fff;
            color: var(--text-mid);
            border: 1px solid var(--border);
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
            background: var(--green-pale);
            color: var(--text-mid);
            padding: 12px 14px;
            text-align: left;
            font-weight: 700;
            border-bottom: 1px solid var(--border);
            white-space: nowrap;
        }

        .data-table tbody td {
            padding: 13px 14px;
            border-bottom: 1px solid #edf0eb;
            color: var(--text-dark);
            vertical-align: middle;
        }

        .data-table tbody tr:hover {
            background: #f8fbf8;
        }

        .user-cell {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .user-avatar {
            width: 34px;
            height: 34px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            background: #edf5ef;
            color: var(--green-dark);
            flex-shrink: 0;
        }

        .user-name {
            font-weight: 800;
        }

        .user-id {
            font-size: 11px;
            color: var(--text-light);
            margin-top: 1px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
            white-space: nowrap;
        }

        .badge.ok { background: #ecf7ef; color: #2f7a4d; }
        .badge.wait { background: #fff5df; color: #9a6b00; }
        .badge.danger { background: #fbe8e8; color: #a23a3a; }
        .badge.info { background: #edf4fb; color: #2d6688; }
        .badge.gray { background: #f2f4f0; color: #777; }

        .row-actions {
            display: flex;
            justify-content: flex-end;
            gap: 6px;
            flex-wrap: wrap;
        }

        .icon-btn-sm {
            width: 31px;
            height: 31px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: #fff;
            color: var(--text-mid);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }

        .icon-btn-sm:hover {
            background: #f4f8f5;
            color: var(--green-dark);
        }

        .icon-btn-sm.danger:hover {
            background: #fbe8e8;
            color: #a23a3a;
        }

        .toggle-cell {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .toggle-wrap {
            position: relative;
            display: inline-block;
            width: 38px;
            height: 22px;
            cursor: pointer;
        }

        .toggle-wrap input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-track {
            position: absolute;
            inset: 0;
            background: #d9ddd5;
            border-radius: 999px;
            transition: .2s;
        }

        .toggle-thumb {
            position: absolute;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: #fff;
            top: 3px;
            left: 3px;
            transition: .2s;
            box-shadow: 0 1px 3px rgba(0,0,0,.15);
        }

        .toggle-wrap input:checked ~ .toggle-track {
            background: var(--green-dark);
        }

        .toggle-wrap input:checked ~ .toggle-thumb {
            left: 19px;
        }

        .toggle-lbl {
            font-size: 12px;
            font-weight: 800;
            color: var(--green-dark);
        }

        .table-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding-top: 14px;
            margin-top: 12px;
            border-top: 1px solid var(--border);
            color: var(--text-light);
            font-size: 12px;
        }

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 36, .48);
            z-index: 9999;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .modal-overlay.open {
            display: flex;
        }

        .modal {
            width: 560px;
            max-width: 100%;
            background: #fff;
            border-radius: 16px;
            border: 1px solid var(--border);
            box-shadow: 0 18px 42px rgba(0,0,0,.18);
            overflow: hidden;
        }

        .modal-hd {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
            padding: 22px 24px 16px;
            border-bottom: 1px solid var(--border);
        }

        .modal-hd h4 {
            margin: 0 0 4px;
            font-size: 17px;
            font-weight: 800;
        }

        .modal-hd p {
            margin: 0;
            color: var(--text-light);
            font-size: 12px;
            line-height: 1.6;
        }

        .modal-body {
            padding: 22px 24px;
        }

        .modal-ft {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            padding: 16px 24px 22px;
            border-top: 1px solid var(--border);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 150px 1fr;
            border-top: 1px solid var(--border);
            border-left: 1px solid var(--border);
            overflow: hidden;
            border-radius: 12px;
        }

        .form-grid .th,
        .form-grid .td {
            padding: 13px 14px;
            border-right: 1px solid var(--border);
            border-bottom: 1px solid var(--border);
            font-size: 13px;
        }

        .form-grid .th {
            background: var(--green-pale);
            color: var(--text-mid);
            font-weight: 800;
        }

        @media (max-width: 1200px) {
            .stats-grid,
            .role-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 900px) {
            .main-shell {
                flex-direction: column;
            }

            .content-area {
                padding: 24px 18px 48px;
            }

            .page-title-row {
                flex-direction: column;
            }

            .stats-grid,
            .role-grid {
                grid-template-columns: 1fr;
            }

            .fake-input,
            .fake-select {
                min-width: 100%;
            }

            .search-box,
            .select-box {
                width: 100%;
            }

            .search-row {
                width: 100%;
            }

            .form-grid {
                grid-template-columns: 120px 1fr;
            }
        }
    </style>
</head>

<body>

<%@ include file="/WEB-INF/views/include/headerLayout.jsp" %>

<header class="admin-page-header">
    <div class="admin-page-header-inner">
        <div class="admin-page-logo">
            <span class="material-symbols-rounded">home_work</span>
            <div>
                <strong>우리집맵핑 관리자</strong>
                <p>ADMIN PORTAL</p>
            </div>
        </div>

        <div class="admin-page-user">
            <div>
                <strong>중앙관리자</strong>
                <p>SYSTEM ADMIN</p>
            </div>
            <button type="button">로그아웃</button>
        </div>
    </div>
</header>

<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/sidebarLayout.jsp" %>

    <main class="content-area">
        <div class="page-content-wrap">

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">시설·시스템</a>
                <span>›</span>
                <span class="cur">단지 관리자 계정 관리</span>
            </div>

            <div class="page-title-row">
                <div>
                    <h1 class="page-title">단지 관리자 계정 관리</h1>
                </div>
                <div class="btn-row-right">
                    <button type="button" class="btn-ghost">
                        <span class="material-symbols-rounded">download</span>
                        엑셀 내보내기
                    </button>
                </div>
            </div>

            <p class="page-desc">
                단지별 관리자의 계정 승인 및 상태, 권한 레벨을 통합 관리하는 화면입니다.
                승인 처리 시 MEMBER, MANAGER 정보와 연결하여 관리합니다.
            </p>

            <section class="hero-card">
                <h2>하위 관리자 계정 승인 및 상태 관리</h2>
                <p>신청 계정을 검토한 뒤 승인 또는 반려하고, 등록된 관리자 계정의 사용 상태를 관리합니다.</p>
                <div class="chip-row">
                    <span class="chip">승인 대기 3건</span>
                    <span class="chip">활성 계정 22건</span>
                    <span class="chip">비활성 계정 2건</span>
                </div>
            </section>

            <section class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">전체 계정</div>
                    <div class="stat-value">24</div>
                    <div class="stat-sub">이번 달 +2</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">활성 계정</div>
                    <div class="stat-value">22</div>
                    <div class="stat-sub">정상 운영 중</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">비활성 계정</div>
                    <div class="stat-value">2</div>
                    <div class="stat-sub">상태 확인 필요</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">관리 단지 수</div>
                    <div class="stat-value">6</div>
                    <div class="stat-sub">전체 운영</div>
                </div>
            </section>

            <section class="panel">
                <div class="section-hd">
                    <div class="section-title-left">
                        <span class="material-symbols-rounded">shield_person</span>
                        <h3>권한 레벨 정의</h3>
                    </div>
                    <span>공통코드 DUTY_CD 기준</span>
                </div>

                <div class="role-grid">
                    <div class="role-card">
                        <span class="role-code">HEAD</span>
                        <h4>관리소장</h4>
                        <p>단지 내 최상위 관리 권한입니다. 계정, 민원, 시설, 재무 메뉴를 전체 관리합니다.</p>
                    </div>
                    <div class="role-card">
                        <span class="role-code">ACNT</span>
                        <h4>회계</h4>
                        <p>관리비, 수납, 정산 등 재무 업무를 담당하는 권한입니다.</p>
                    </div>
                    <div class="role-card">
                        <span class="role-code">ADM</span>
                        <h4>행정</h4>
                        <p>입주민 관리, 민원, 문의, 공고 등 행정 업무를 담당하는 권한입니다.</p>
                    </div>
                    <div class="role-card">
                        <span class="role-code">FAC</span>
                        <h4>시설</h4>
                        <p>시설 점검, 보수 이력, 시설 민원 처리를 담당하는 권한입니다.</p>
                    </div>
                </div>
            </section>

            <section class="panel">
                <div class="section-hd">
                    <div class="section-title-left">
                        <span class="material-symbols-rounded">person_search</span>
                        <h3>단지 관리자 신청 계정 목록</h3>
                    </div>
                    <span>승인/반려 처리</span>
                </div>

                <div class="toolbar">
                    <div class="search-row">
                        <div class="search-box">
                            <input type="text" id="searchInput" class="fake-input"
                                   placeholder="이름, 아이디, 단지명 검색"
                                   oninput="searchTable('rqstTable', this.value)">
                            <span class="material-symbols-rounded search-icon"
                                  onclick="searchBtnClick('rqstTable', 'searchInput')">search</span>
                        </div>

                        <div class="select-box">
                            <select class="fake-select" onchange="filterTable('rqstTable', this.value)">
                                <option value="all">전체</option>
                                <option value="wait">승인대기</option>
                                <option value="ok">승인완료</option>
                                <option value="reject">반려</option>
                            </select>
                            <span class="select-icon">▾</span>
                        </div>
                    </div>

                    <div class="btn-row-right">
                        <button type="button" class="btn-sub" onclick="openApprovalModal()">
                            <span class="material-symbols-rounded">task_alt</span>
                            선택 계정 승인
                        </button>
                        <button type="button" class="btn-danger" onclick="openRejectModal()">
                            <span class="material-symbols-rounded">cancel</span>
                            선택 계정 반려
                        </button>
                    </div>
                </div>

                <div style="overflow-x:auto;">
                    <table class="data-table" id="rqstTable">
                        <thead>
                        <tr>
                            <th style="width:44px;">
                                <input type="checkbox" onclick="toggleAll('rqstTable', this)">
                            </th>
                            <th>신청자 정보</th>
                            <th>소속 단지</th>
                            <th>신청 직무</th>
                            <th>신청일자</th>
                            <th>처리상태</th>
                            <th style="text-align:right;">관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr data-status="wait" data-name="김관리 admin_kim 행복아파트">
                            <td><input type="checkbox" class="row-check"></td>
                            <td>
                                <div class="user-cell">
                                    <div class="user-avatar">김</div>
                                    <div>
                                        <div class="user-name">김관리</div>
                                        <div class="user-id">admin_kim</div>
                                    </div>
                                </div>
                            </td>
                            <td>행복아파트 · A단지</td>
                            <td><span class="badge info">관리소장</span></td>
                            <td>2026-04-21</td>
                            <td><span class="badge wait">승인대기</span></td>
                            <td>
                                <div class="row-actions">
                                    <button type="button" class="icon-btn-sm" onclick="openApprovalModal()" title="승인">
                                        <span class="material-symbols-rounded">check</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm danger" onclick="openRejectModal()" title="반려">
                                        <span class="material-symbols-rounded">close</span>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr data-status="wait" data-name="이회계 acct_lee 행복아파트">
                            <td><input type="checkbox" class="row-check"></td>
                            <td>
                                <div class="user-cell">
                                    <div class="user-avatar">이</div>
                                    <div>
                                        <div class="user-name">이회계</div>
                                        <div class="user-id">acct_lee</div>
                                    </div>
                                </div>
                            </td>
                            <td>행복아파트 · A단지</td>
                            <td><span class="badge info">회계</span></td>
                            <td>2026-04-20</td>
                            <td><span class="badge wait">승인대기</span></td>
                            <td>
                                <div class="row-actions">
                                    <button type="button" class="icon-btn-sm" onclick="openApprovalModal()" title="승인">
                                        <span class="material-symbols-rounded">check</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm danger" onclick="openRejectModal()" title="반려">
                                        <span class="material-symbols-rounded">close</span>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr data-status="ok" data-name="박행정 admin_park 희망빌라">
                            <td><input type="checkbox" class="row-check"></td>
                            <td>
                                <div class="user-cell">
                                    <div class="user-avatar">박</div>
                                    <div>
                                        <div class="user-name">박행정</div>
                                        <div class="user-id">admin_park</div>
                                    </div>
                                </div>
                            </td>
                            <td>희망빌라 · B단지</td>
                            <td><span class="badge info">행정</span></td>
                            <td>2026-04-18</td>
                            <td><span class="badge ok">승인완료</span></td>
                            <td>
                                <div class="row-actions">
                                    <button type="button" class="icon-btn-sm" title="상세">
                                        <span class="material-symbols-rounded">visibility</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="table-footer">
                    <span>총 <strong>3</strong>건 표시 중</span>
                    <span>체크 후 승인/반려 버튼을 누르면 모달창이 열립니다.</span>
                </div>
            </section>

            <section class="panel">
                <div class="section-hd">
                    <div class="section-title-left">
                        <span class="material-symbols-rounded">manage_accounts</span>
                        <h3>단지 관리자 계정 상태 관리</h3>
                    </div>
                    <span>활성/비활성 관리</span>
                </div>

                <div class="toolbar">
                    <div class="search-row">
                        <div class="search-box">
                            <input type="text" id="searchInput2" class="fake-input"
                                   placeholder="이름, 아이디, 단지명 검색"
                                   oninput="searchTable('accountTable', this.value)">
                            <span class="material-symbols-rounded search-icon"
                                  onclick="searchBtnClick('accountTable', 'searchInput2')">search</span>
                        </div>

                        <div class="select-box">
                            <select class="fake-select" onchange="filterTable('accountTable', this.value)">
                                <option value="all">전체</option>
                                <option value="active">활성</option>
                                <option value="inactive">비활성</option>
                            </select>
                            <span class="select-icon">▾</span>
                        </div>
                    </div>

                    <button type="button" class="btn-sub" onclick="openStatusModal()">
                        <span class="material-symbols-rounded">settings_account_box</span>
                        선택 계정 상태 변경
                    </button>
                </div>

                <div style="overflow-x:auto;">
                    <table class="data-table" id="accountTable">
                        <thead>
                        <tr>
                            <th style="width:44px;">
                                <input type="checkbox" onclick="toggleAll('accountTable', this)">
                            </th>
                            <th>관리자 정보</th>
                            <th>소속 단지</th>
                            <th>권한 레벨</th>
                            <th>최근 접속</th>
                            <th>상태</th>
                            <th style="text-align:right;">관리</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr data-status="active" data-name="김관리 admin_kim 행복아파트">
                            <td><input type="checkbox" class="row-check"></td>
                            <td>
                                <div class="user-cell">
                                    <div class="user-avatar">김</div>
                                    <div>
                                        <div class="user-name">김관리</div>
                                        <div class="user-id">admin_kim</div>
                                    </div>
                                </div>
                            </td>
                            <td>행복아파트 · A단지</td>
                            <td><span class="badge info">관리소장</span></td>
                            <td>2026-04-21 15:30</td>
                            <td>
                                <div class="toggle-cell">
                                    <label class="toggle-wrap">
                                        <input type="checkbox" checked onchange="onToggle(this)">
                                        <span class="toggle-track"></span>
                                        <span class="toggle-thumb"></span>
                                    </label>
                                    <span class="toggle-lbl">활성</span>
                                </div>
                            </td>
                            <td>
                                <div class="row-actions">
                                    <button type="button" class="icon-btn-sm" title="수정">
                                        <span class="material-symbols-rounded">edit_square</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm" title="권한 변경">
                                        <span class="material-symbols-rounded">manage_accounts</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm danger" title="삭제">
                                        <span class="material-symbols-rounded">delete</span>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr data-status="active" data-name="이회계 acct_lee 행복아파트">
                            <td><input type="checkbox" class="row-check"></td>
                            <td>
                                <div class="user-cell">
                                    <div class="user-avatar">이</div>
                                    <div>
                                        <div class="user-name">이회계</div>
                                        <div class="user-id">acct_lee</div>
                                    </div>
                                </div>
                            </td>
                            <td>행복아파트 · A단지</td>
                            <td><span class="badge info">회계</span></td>
                            <td>2026-04-20 09:11</td>
                            <td>
                                <div class="toggle-cell">
                                    <label class="toggle-wrap">
                                        <input type="checkbox" checked onchange="onToggle(this)">
                                        <span class="toggle-track"></span>
                                        <span class="toggle-thumb"></span>
                                    </label>
                                    <span class="toggle-lbl">활성</span>
                                </div>
                            </td>
                            <td>
                                <div class="row-actions">
                                    <button type="button" class="icon-btn-sm" title="수정">
                                        <span class="material-symbols-rounded">edit_square</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm" title="권한 변경">
                                        <span class="material-symbols-rounded">manage_accounts</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm danger" title="삭제">
                                        <span class="material-symbols-rounded">delete</span>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <tr data-status="inactive" data-name="최시설 facility_choi 미래아파트">
                            <td><input type="checkbox" class="row-check"></td>
                            <td>
                                <div class="user-cell">
                                    <div class="user-avatar">최</div>
                                    <div>
                                        <div class="user-name">최시설</div>
                                        <div class="user-id">facility_choi</div>
                                    </div>
                                </div>
                            </td>
                            <td>미래아파트 · C단지</td>
                            <td><span class="badge gray">시설</span></td>
                            <td>2026-03-10 08:00</td>
                            <td>
                                <div class="toggle-cell">
                                    <label class="toggle-wrap">
                                        <input type="checkbox" onchange="onToggle(this)">
                                        <span class="toggle-track"></span>
                                        <span class="toggle-thumb"></span>
                                    </label>
                                    <span class="toggle-lbl" style="color:var(--text-light);">비활성</span>
                                </div>
                            </td>
                            <td>
                                <div class="row-actions">
                                    <button type="button" class="icon-btn-sm" title="수정">
                                        <span class="material-symbols-rounded">edit_square</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm" title="권한 변경">
                                        <span class="material-symbols-rounded">manage_accounts</span>
                                    </button>
                                    <button type="button" class="icon-btn-sm danger" title="삭제">
                                        <span class="material-symbols-rounded">delete</span>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>

                <div class="table-footer">
                    <span>총 <strong>3</strong>개 계정 표시 중</span>
                    <span>상태 토글은 추후 AJAX로 서버 반영 가능</span>
                </div>
            </section>
        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/footerLayout.jsp" %>

<div class="modal-overlay" id="approvalModal" onclick="closeModalOutside(event, 'approvalModal')">
    <div class="modal">
        <div class="modal-hd">
            <div>
                <h4>단지 관리자 계정 승인</h4>
                <p>선택한 신청 계정을 승인 처리합니다.</p>
            </div>
            <button type="button" class="icon-btn-sm" onclick="closeModal('approvalModal')">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>
        <div class="modal-body">
            <div class="form-grid">
                <div class="th">승인 처리</div>
                <div class="td">선택한 신청 계정을 승인합니다.</div>
                <div class="th">권한 직무</div>
                <div class="td">
                    <select class="fake-select" style="width:100%;">
                        <option value="HEAD">관리소장</option>
                        <option value="ACNT">회계</option>
                        <option value="ADM">행정</option>
                        <option value="FAC">시설</option>
                    </select>
                </div>
                <div class="th">비고</div>
                <div class="td">
                    <textarea class="fake-textarea" placeholder="승인 관련 비고를 입력하세요."></textarea>
                </div>
            </div>
        </div>
        <div class="modal-ft">
            <button type="button" class="btn-ghost" onclick="closeModal('approvalModal')">취소</button>
            <button type="button" class="btn-main">승인 처리</button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="rejectModal" onclick="closeModalOutside(event, 'rejectModal')">
    <div class="modal">
        <div class="modal-hd">
            <div>
                <h4>단지 관리자 계정 반려</h4>
                <p>선택한 신청 계정을 반려 처리합니다.</p>
            </div>
            <button type="button" class="icon-btn-sm" onclick="closeModal('rejectModal')">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>
        <div class="modal-body">
            <div class="form-grid">
                <div class="th">처리상태</div>
                <div class="td"><span class="badge danger">반려</span></div>
                <div class="th">반려사유</div>
                <div class="td">
                    <textarea class="fake-textarea" placeholder="반려 사유를 입력하세요."></textarea>
                </div>
            </div>
        </div>
        <div class="modal-ft">
            <button type="button" class="btn-ghost" onclick="closeModal('rejectModal')">취소</button>
            <button type="button" class="btn-danger">반려 처리</button>
        </div>
    </div>
</div>

<div class="modal-overlay" id="statusModal" onclick="closeModalOutside(event, 'statusModal')">
    <div class="modal">
        <div class="modal-hd">
            <div>
                <h4>계정 상태 변경</h4>
                <p>선택한 관리자 계정의 사용 여부를 변경합니다.</p>
            </div>
            <button type="button" class="icon-btn-sm" onclick="closeModal('statusModal')">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>
        <div class="modal-body">
            <div class="form-grid">
                <div class="th">변경 상태</div>
                <div class="td">
                    <select class="fake-select" style="width:100%;">
                        <option value="Y">활성</option>
                        <option value="N">비활성</option>
                    </select>
                </div>
                <div class="th">처리 비고</div>
                <div class="td">
                    <textarea class="fake-textarea" placeholder="상태 변경 사유를 입력하세요."></textarea>
                </div>
            </div>
        </div>
        <div class="modal-ft">
            <button type="button" class="btn-ghost" onclick="closeModal('statusModal')">취소</button>
            <button type="button" class="btn-main">상태 변경</button>
        </div>
    </div>
</div>

<script>
    function toggleAll(tableId, masterCheck) {
        const table = document.getElementById(tableId);
        if (!table) return;

        table.querySelectorAll('tbody tr').forEach(function (row) {
            if (row.style.display !== 'none') {
                const check = row.querySelector('.row-check');
                if (check) check.checked = masterCheck.checked;
            }
        });
    }

    function searchTable(tableId, keyword) {
        const table = document.getElementById(tableId);
        if (!table) return;

        const q = (keyword || '').toLowerCase();

        table.querySelectorAll('tbody tr').forEach(function (row) {
            const name = (row.dataset.name || '').toLowerCase();
            row.style.display = name.includes(q) ? '' : 'none';
        });
    }

    function filterTable(tableId, status) {
        const table = document.getElementById(tableId);
        if (!table) return;

        table.querySelectorAll('tbody tr').forEach(function (row) {
            row.style.display = (status === 'all' || row.dataset.status === status) ? '' : 'none';
        });
    }

    function searchBtnClick(tableId, inputId) {
        const input = document.getElementById(inputId);
        if (!input) return;

        searchTable(tableId, input.value);
    }

    function onToggle(check) {
        const row = check.closest('tr');
        const label = row.querySelector('.toggle-lbl');
        const isActive = check.checked;

        row.dataset.status = isActive ? 'active' : 'inactive';
        label.textContent = isActive ? '활성' : '비활성';
        label.style.color = isActive ? 'var(--green-dark)' : 'var(--text-light)';
    }

    function openApprovalModal() {
        document.getElementById('approvalModal').classList.add('open');
    }

    function openRejectModal() {
        document.getElementById('rejectModal').classList.add('open');
    }

    function openStatusModal() {
        document.getElementById('statusModal').classList.add('open');
    }

    function closeModal(modalId) {
        document.getElementById(modalId).classList.remove('open');
    }

    function closeModalOutside(event, modalId) {
        if (event.target.id === modalId) {
            closeModal(modalId);
        }
    }
</script>

</body>
</html>