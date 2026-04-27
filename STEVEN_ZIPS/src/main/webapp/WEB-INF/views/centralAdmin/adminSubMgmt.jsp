<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>

    <%--  합친 후 삭제예정 --%>
    <meta charset="UTF-8">
    <title>단지 관리자 계정 관리</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" rel="stylesheet">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralCommon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralHeader.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralAside.css">

    <style>
        body {
            margin: 0;
            background: #f8faf9;
            font-family: 'Noto Sans KR', sans-serif;
        }

        .admin-layout {
            display: flex;
            min-height: 100vh;
        }

        .admin-main {
            flex: 1;
            min-width: 0;
            display: flex;
            flex-direction: column;
        }

        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
            background: #f8faf9;
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
            color: #777;
            margin-bottom: 18px;
        }

        .breadcrumb a {
            color: #777;
            text-decoration: none;
        }

        .breadcrumb .cur {
            color: #2d5a3d;
            font-weight: 700;
        }

        .page-title-row {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            border-bottom: 2px solid #2d5a3d;
            padding-bottom: 14px;
            margin-bottom: 16px;
        }

        .page-title {
            font-size: 22px;
            font-weight: 800;
            margin: 0;
        }

        .page-desc {
            font-size: 13px;
            line-height: 1.8;
            color: #777;
            margin: 0 0 24px;
        }

        .btn-row-right {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
        }

        .hero-card,
        .panel {
            background: #fff;
            border: 1px solid #dde8e2;
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, .05);
        }

        .hero-card {
            padding: 24px 28px;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #2d5a3d, #386a4d);
            color: #fff;
        }

        .hero-card h2 {
            margin: 0 0 8px;
            font-size: 20px;
        }

        .hero-card p {
            margin: 0;
            font-size: 13px;
            color: rgba(255,255,255,.82);
        }

        .chip-row {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-top: 14px;
        }

        .chip {
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            background: rgba(255,255,255,.18);
            color: #fff;
        }

        .stats-grid,
        .role-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 24px;
        }

        .stat-card,
        .role-card {
            background: #fff;
            border: 1px solid #dde8e2;
            border-radius: 14px;
            padding: 18px;
        }

        .stat-label {
            color: #777;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: 800;
            color: #2d5a3d;
        }

        .stat-sub {
            margin-top: 6px;
            font-size: 12px;
            color: #777;
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
            border-bottom: 1px solid #dde8e2;
        }

        .section-hd h3 {
            margin: 0;
            font-size: 15px;
            font-weight: 800;
        }

        .section-hd span {
            font-size: 12px;
            color: #777;
        }

        .section-title-left {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .role-code {
            display: inline-flex;
            margin-bottom: 10px;
            padding: 4px 10px;
            border-radius: 999px;
            background: #edf5ef;
            color: #2d5a3d;
            font-size: 11px;
            font-weight: 800;
        }

        .role-card h4 {
            margin: 0 0 8px;
            font-size: 15px;
        }

        .role-card p {
            margin: 0;
            font-size: 12px;
            line-height: 1.7;
            color: #777;
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
            color: #777;
            font-size: 19px;
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
            border: none;
            cursor: pointer;
            white-space: nowrap;
        }

        .btn-main { background: #2d5a3d; color: #fff; }
        .btn-sub { background: #edf5ef; color: #2d5a3d; }
        .btn-danger { background: #b64444; color: #fff; }
        .btn-ghost {
            background: #fff;
            color: #444;
            border: 1px solid #dde8e2;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
            background: #fff;
        }

        .data-table thead th {
            background: #f4f9f6;
            color: #444;
            padding: 12px 14px;
            text-align: left;
            font-weight: 700;
            border-bottom: 1px solid #dde8e2;
            white-space: nowrap;
        }

        .data-table tbody td {
            padding: 13px 14px;
            border-bottom: 1px solid #edf0eb;
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
            color: #2d5a3d;
        }

        .user-name {
            font-weight: 800;
        }

        .user-id {
            font-size: 11px;
            color: #777;
        }

        .badge {
            display: inline-flex;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 800;
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
        }

        .icon-btn-sm {
            width: 31px;
            height: 31px;
            border-radius: 8px;
            border: 1px solid #dde8e2;
            background: #fff;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
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
        }

        .toggle-track {
            position: absolute;
            inset: 0;
            background: #d9ddd5;
            border-radius: 999px;
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
        }

        .toggle-wrap input:checked ~ .toggle-track {
            background: #2d5a3d;
        }

        .toggle-wrap input:checked ~ .toggle-thumb {
            left: 19px;
        }

        .toggle-lbl {
            font-size: 12px;
            font-weight: 800;
            color: #2d5a3d;
        }

        .table-footer {
            display: flex;
            justify-content: space-between;
            padding-top: 14px;
            margin-top: 12px;
            border-top: 1px solid #dde8e2;
            color: #777;
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
            overflow: hidden;
        }

        .modal-hd,
        .modal-body,
        .modal-ft {
            padding: 20px 24px;
        }

        .modal-hd,
        .modal-ft {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #dde8e2;
        }

        .modal-ft {
            justify-content: flex-end;
            gap: 8px;
            border-top: 1px solid #dde8e2;
            border-bottom: none;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 150px 1fr;
            border-top: 1px solid #dde8e2;
            border-left: 1px solid #dde8e2;
        }

        .form-grid .th,
        .form-grid .td {
            padding: 13px 14px;
            border-right: 1px solid #dde8e2;
            border-bottom: 1px solid #dde8e2;
            font-size: 13px;
        }

        .form-grid .th {
            background: #f4f9f6;
            font-weight: 800;
        }
    </style>
</head>

<body>

<div class="admin-layout">

    <%@ include file="/WEB-INF/views/centralAdmin/centralAside.jsp" %>

    <div class="admin-main">

        <%@ include file="/WEB-INF/views/centralAdmin/centralHeader.jsp" %>

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
                    <h2>단지 관리자 계정 승인 및 상태 관리</h2>
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
                                        <span class="toggle-lbl" style="color:#777;">비활성</span>
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
</div>

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
        label.style.color = isActive ? '#2d5a3d' : '#777';
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