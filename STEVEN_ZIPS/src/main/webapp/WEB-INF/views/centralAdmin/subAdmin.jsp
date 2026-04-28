<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">

<%-- 1. 윗부분 검색처럼 계정 목록에 검색부분 글씨쓸때 자동검색되도록 바꾸기
     2. 체크박스 형식으로 승인반려할지?
     3. 제목도 좀 더 직관적으로 변경? - 화면정의서나 단위업무정의서 참고?
     4. CRUD 연결
--%>


<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>우리집맵핑 · 단지 관리자 계정</title>
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />
  <%--<script defer src="<%= request.getContextPath() %>/js/centralAside.js"></script>
  <script defer src="<%= request.getContextPath() %>/js/centralHeader.js"></script>--%>
  <style id="page-style">
    .role-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}
    .role-card{border:1.5px solid var(--border);border-radius:var(--r-md);padding:16px;cursor:default;transition:border-color .15s,box-shadow .15s;background:var(--card);position:relative}
    .role-card:hover{border-color:#c4c9d4}
    .role-card__top{display:flex;align-items:flex-start;justify-content:space-between;margin-bottom:10px}
    .role-card__icon{width:36px;height:36px;border-radius:9px;display:flex;align-items:center;justify-content:center}
    .role-card__icon .material-symbols-rounded{font-size:19px}
    .role-card__lv{font-size:10px;font-weight:700;padding:2px 8px;border-radius:99px}
    .role-card__title{font-size:13px;font-weight:800;color:var(--text-primary)}
    .role-card__desc{font-size:11.5px;color:var(--text-tertiary);margin:3px 0 10px;line-height:1.5}
    .role-card__perms{display:flex;flex-direction:column;gap:5px}
    .role-card__perm{display:flex;align-items:center;gap:6px;font-size:11.5px}
    .role-card__perm .material-symbols-rounded{font-size:14px;flex-shrink:0}
    .role-card__perm.yes{color:var(--text-secondary)} .role-card__perm.yes .material-symbols-rounded{color:var(--green)}
    .role-card__perm.no{color:var(--text-tertiary)} .role-card__perm.no .material-symbols-rounded{color:#d1d5db}
    .user-cell{display:flex;align-items:center;gap:10px}
    .user-avatar{width:32px;height:32px;border-radius:50%;flex-shrink:0;display:flex;align-items:center;justify-content:center;font-size:12px;font-weight:800}
    .user-name{font-size:13px;font-weight:700;color:var(--text-primary)} .user-id{font-size:11px;color:var(--text-tertiary);margin-top:1px}
    .toggle-wrap{position:relative;display:inline-block;width:36px;height:20px;cursor:pointer}
    .toggle-wrap input{opacity:0;width:0;height:0}
    .toggle-track{position:absolute;inset:0;background:#e2e5ea;border-radius:99px;transition:.18s}
    .toggle-thumb{position:absolute;width:14px;height:14px;border-radius:50%;background:#fff;top:3px;left:3px;transition:.18s;box-shadow:0 1px 3px rgba(0,0,0,.15)}
    .toggle-wrap input:checked~.toggle-track{background:var(--green)} .toggle-wrap input:checked~.toggle-thumb{left:19px}
    .row-inactive td:not(:last-child){opacity:.45}

    /* 단지 관리자 신청 계정 목록 --시작-- */
    /* 부모 기준 잡기 */
    .input-with-icon {
      position: relative;
      width: 200px;
    }

    /* input 오른쪽 공간 확보 */
    .input-with-icon .c-input {
      width: 100%;
      padding-right: 36px;
      /* 👉 이거 없으면 아이콘이랑 글자 겹침 */
    }

    /* 아이콘 위치 고정 */
    .search-icon {
      position: absolute;
      right: 10px;      /* 👉 오른쪽 안쪽 */
      top: 50%;
      transform: translateY(-50%);  /* 👉 수직 가운데 */

      font-size: 18px;
      color: #9ca3af;
      cursor: pointer;
    }

    /* ================================
 단지 관리자 신청 계정 목록
 - 두 번째 화면과 같은 카드/테이블 스타일
================================ */

    .panel {
      background: #fff;
      border: 1px solid #e5e7eb;
      border-radius: 14px;
      box-shadow: 0 1px 3px rgba(15, 23, 42, 0.08);
      margin-bottom: 16px;
      overflow: hidden;
    }

    .section-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 20px 10px;
    }

    .section-title-left {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .section-title-left .material-symbols-rounded {
      font-size: 18px;
      color: #64748b;
    }

    .section-title-left h3 {
      margin: 0;
      font-size: 14px;
      font-weight: 800;
      color: #111827;
    }

    .section-hd > span {
      font-size: 12px;
      color: #94a3b8;
    }

    .toolbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      padding: 0 20px 14px;
    }

    .search-row {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .search-box {
      position: relative;
      width: 220px;
    }

    .fake-input {
      width: 100%;
      height: 34px;
      padding: 0 34px 0 12px;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      font-size: 12px;
      outline: none;
    }

    .search-box .search-icon {
      position: absolute;
      right: 10px;
      top: 50%;
      transform: translateY(-50%);
      font-size: 17px;
      color: #94a3b8;
      cursor: pointer;
    }

    .select-box {
      position: relative;
      width: 110px;
    }

    .fake-select {
      width: 100%;
      height: 34px;
      padding: 0 30px 0 12px;
      border: 1px solid #e5e7eb;
      border-radius: 8px;
      font-size: 12px;
      background: #fff;
      appearance: none;
      outline: none;
    }

    .select-icon {
      position: absolute;
      right: 10px;
      top: 50%;
      transform: translateY(-50%);
      color: #94a3b8;
      pointer-events: none;
    }

    .btn-row-right {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .btn-sub,
    .btn-danger {
      height: 34px;
      padding: 0 12px;
      border-radius: 8px;
      font-size: 12px;
      font-weight: 700;
      display: inline-flex;
      align-items: center;
      gap: 4px;
      cursor: pointer;
    }

    .btn-sub {
      background: #f8fafc;
      border: 1px solid #cbd5e1;
      color: #334155;
    }

    .btn-danger {
      background: #fff1f2;
      border: 1px solid #fecdd3;
      color: #be123c;
    }

    .btn-sub .material-symbols-rounded,
    .btn-danger .material-symbols-rounded {
      font-size: 16px;
    }

    .data-table {
      width: 100%;
      border-collapse: collapse;
      table-layout: fixed;
    }

    .data-table thead th {
      background: #f8fafc;
      border-top: 1px solid #e5e7eb;
      border-bottom: 1px solid #e5e7eb;
      padding: 10px 12px;
      font-size: 12px;
      font-weight: 800;
      color: #475569;
      text-align: left;
    }

    .data-table tbody td {
      border-bottom: 1px solid #e5e7eb;
      padding: 12px;
      font-size: 12px;
      color: #334155;
      vertical-align: middle;
    }

    .data-table tbody tr:hover {
      background: #f9fafb;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      padding: 4px 8px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
    }

    .badge.info {
      background: #eef2ff;
      color: #4338ca;
    }

    .badge.wait {
      background: #fef3c7;
      color: #92400e;
    }

    .badge.ok {
      background: #dcfce7;
      color: #166534;
    }

    .badge.reject {
      background: #fee2e2;
      color: #991b1b;
    }

    .row-actions {
      display: flex;
      justify-content: flex-end;
      gap: 6px;
    }

    .icon-btn-sm {
      width: 28px;
      height: 28px;
      border: 1px solid #e5e7eb;
      border-radius: 7px;
      background: #fff;
      cursor: pointer;
    }

    .icon-btn-sm .material-symbols-rounded {
      font-size: 17px;
    }

    .icon-btn-sm.danger {
      color: #be123c;
    }

    .table-footer {
      display: flex;
      justify-content: space-between;
      padding: 12px 20px;
      font-size: 12px;
      color: #64748b;
    }

    .rqst-check {
      width: 15px;
      height: 15px;
      accent-color: #2563eb;
      cursor: pointer;
    }

    /* 단지 관리자 신청 계정 목록 --끝-- */

    /* 신청 계정 목록 상단 정렬 --시작-- */
    .rqst-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      padding: 16px 20px 10px;
    }

    .rqst-title h3 {
      margin: 0;
      font-size: 14px;
      font-weight: 800;
      color: #111827;
    }

    .rqst-summary {
      margin-top: 3px;
      font-size: 12px;
      color: #94a3b8;
    }

    /* 오른쪽 검색/필터/버튼 영역 */
    .rqst-toolbar-right {
      display: flex;
      flex-direction: column;
      align-items: flex-end;
      gap: 8px;
    }

    .rqst-search-row {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .rqst-button-row {
      display: flex;
      align-items: center;
      gap: 8px;
    }
    /* 신청 계정 목록 상단 정렬 --끝-- */

  </style>
</head>
<body>
<%@ include file="centralAside.jsp" %>

<div class="main-wrap">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="material-symbols-rounded" style="font-size: 14px">home</span>
      <span style="margin: 0 4px">/</span>
      <span>시설·시스템</span>
      <span style="margin: 0 4px">/</span>
      <span class="bc-current">단지관리자 계정</span>
    </div>
    <div class="topbar-actions">
      <button class="topbar-icon-btn" data-tooltip="알림">
        <span class="material-symbols-rounded">notifications</span>
        <div class="dot"></div>
      </button>
      <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
    </div>
  </div>

  <div class="main-content">
    <!-- 페이지 헤더 -->
    <div class="page-header">
      <div>
        <div class="page-title">단지 관리자 계정 관리</div>
        <div class="page-subtitle">단지별 계정 생성·매핑, 권한 레벨 설정 및 활성화 상태를 통합 제어합니다.</div>
      </div>

      <div class="page-header__right">
        <button class="c-btn c-btn--primary" type="button" onclick="exportAccountsToExcel()">
          <span class="material-symbols-rounded">download</span>
          엑셀 내보내기
        </button>
        <%--            <button class="c-btn c-btn--primary" onclick="openModal()">--%>
        <%--              <span class="material-symbols-rounded">person_add</span>신규 계정 생성--%>
        <%--            </button>--%>
      </div>
    </div>

    <!-- 권한 레벨 안내 (접기/펼치기) -->
    <div class="c-card c-card--divide" style="margin-bottom: 16px">
      <div class="c-card__header">
        <div>
          <div class="c-card__title">권한 레벨 안내</div>
          <div class="c-card__sub">가이드는 참고용입니다. 신규 계정 승인 시 신청된 권한으로 설정됩니다.</div>
        </div>
        <div class="c-card__actions">
          <button class="c-btn c-btn--ghost c-btn--sm" type="button" onclick="toggleRoleGuide()">
            <span class="material-symbols-rounded">unfold_more</span>권한 정의 보기
          </button>
        </div>
      </div>
      <div class="c-card__body" id="roleGuideBody" style="display:none">
        <div class="role-grid" id="roleGrid"></div>
      </div>
    </div>
    <%-- 단지관리자 직원 계정 승인 여부 --%>
    <section class="panel">
<%--      <div class="section-hd">--%>
<%--        <div class="section-title-left">--%>
<%--          &lt;%&ndash;              <span class="material-symbols-rounded">person_search</span>&ndash;%&gt;--%>
<%--          <h3>단지 관리자 신청 계정 목록</h3>--%>
<%--        </div>--%>
<%--        <span>승인/반려 처리</span>--%>
<%--      </div>--%>

<%--      <div class="toolbar">--%>
<%--        <div class="search-row">--%>
<%--          <div class="search-box">--%>
<%--            <input type="text" id="searchInput1" class="fake-input"--%>
<%--                   placeholder="이름, 아이디, 단지명 검색"--%>
<%--                   oninput="searchTable('rqstTable', this.value)">--%>
<%--            <span class="material-symbols-rounded search-icon"--%>
<%--                  onclick="searchBtnClick('rqstTable', 'searchInput1')">search</span>--%>
<%--          </div>--%>

<%--          <div class="select-box">--%>
<%--            <select class="fake-select" onchange="filterTable('rqstTable', this.value)">--%>
<%--              <option value="all">전체</option>--%>
<%--              <option value="wait">승인대기</option>--%>
<%--              <option value="ok">승인완료</option>--%>
<%--              <option value="reject">반려</option>--%>
<%--            </select>--%>
<%--            <span class="select-icon">▾</span>--%>
<%--          </div>--%>
<%--        </div>--%>

<%--        <div class="btn-row-right">--%>
<%--          <button type="button" class="btn-sub" onclick="openApprovalModal()">--%>
<%--            <span class="material-symbols-rounded">task_alt</span>--%>
<%--            선택 계정 승인--%>
<%--          </button>--%>
<%--          <button type="button" class="btn-danger" onclick="openRejectModal()">--%>
<%--            <span class="material-symbols-rounded">cancel</span>--%>
<%--            선택 계정 반려--%>
<%--          </button>--%>
<%--        </div>--%>
<%--      </div>--%>

  <div class="rqst-header">
    <%-- 왼쪽: 제목 + 통계
         통계란? 현재 신청 계정의 전체/승인대기/승인완료/반려 건수를 보여주는 요약 정보 --%>
    <div class="rqst-title">
      <h3>단지 관리자 신청 계정 목록</h3>
      <div class="rqst-summary" id="rqstSummary">
        총 3건 / 승인대기 2건 / 승인완료 1건 / 반려 0건
      </div>
    </div>

    <%-- 오른쪽: 검색/필터 + 버튼
         flex-direction: column;
         → 요소를 위아래로 배치할 때 사용
         왜 사용?
         → 검색 input은 위, 선택 승인/반려 버튼은 아래에 배치하기 위해 사용 --%>
    <div class="rqst-toolbar-right">
      <div class="rqst-search-row">
        <div class="search-box">
          <input type="text" id="searchInput1" class="fake-input"
                 placeholder="이름, 아이디, 단지명 검색"
                 oninput="searchTable('rqstTable', this.value)">
          <span class="material-symbols-rounded search-icon"
                onclick="searchBtnClick('rqstTable', 'searchInput1')">search</span>
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

      <div class="rqst-button-row">
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
  </div>

      <div style="overflow-x:auto;">
        <table class="data-table" id="rqstTable">
          <thead>
          <tr>
            <th style="width:44px;">
              <input type="checkbox" class="rqst-check" onclick="toggleAll('rqstTable', this)">
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
            <td><input type="checkbox" class="rqst-check row-check"></td>
            <td>
              <div class="user-cell">
                <div class="user-avatar" style="background:#dbeafe;color:#1d4ed8">김</div>
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
                <button type="button" class="icon-btn-sm" onclick="openApprovalModal(this)" title="승인">
                  <span class="material-symbols-rounded">check</span>
                </button>
                <button type="button" class="icon-btn-sm danger" onclick="openRejectModal(this)" title="반려">
                  <span class="material-symbols-rounded">close</span>
                </button>
              </div>
            </td>
          </tr>

          <tr data-status="wait" data-name="이회계 acct_lee 행복아파트">
            <td><input type="checkbox" class="rqst-check row-check"></td>
            <td>
              <div class="user-cell">
                <div class="user-avatar" style="background:#fef3c7;color:#92400e">이</div>
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
                <button type="button" class="icon-btn-sm" onclick="openApprovalModal(this)" title="승인">
                  <span class="material-symbols-rounded">check</span>
                </button>
                <button type="button" class="icon-btn-sm danger" onclick="openRejectModal(this)" title="반려">
                  <span class="material-symbols-rounded">close</span>
                </button>
              </div>
            </td>
          </tr>

          <tr data-status="ok" data-name="박행정 admin_park 희망빌라">
            <td><input type="checkbox" class="rqst-check row-check"></td>
            <td>
              <div class="user-cell">
                <div class="user-avatar" style="background:#dcfce7;color:#166534">박</div>
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
<%--                <button type="button" class="icon-btn-sm" title="상세">--%>
<%--                  <span class="material-symbols-rounded">visibility</span>--%>
<%--                </button>--%>
                <button type="button" class="icon-btn-sm" title="승인 계정 목록 추가" onclick="addApprovedAccount(this)">
                  <%--
                    move_to_inbox
    → 아래 목록으로 이동/보관한다는 의미가 더 직관적인 아이콘

                    왜 사용?
                    → 승인완료된 신청 계정을 아래 '계정 목록 및 활성화' 목록으로 내려보낸다는 의미를 주기 위해 사용
                  --%>
                    <span class="material-symbols-rounded">move_to_inbox</span>
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


    <!-- 계정 목록 -->
    <div class="c-card c-card--divide">
      <div class="c-card__header">
        <div>
          <div class="c-card__title">단지 관리자 계정 목록 및 활성화</div>
          <div class="c-card__sub" id="acctSubtitle">총 0건 / 1 페이지</div>
        </div>
        <div class="c-card__actions">
          <div class="input-with-icon">
            <input
                    type="search"
                    id="searchInput"
                    class="c-input"
                    placeholder="이름·아이디·단지 검색"
                    oninput="searchAccounts(this.value)"   <%-- 실시간 검색 --%>
                    onkeydown="handleSearchKey(event)"     <%-- 엔터도 지원 --%>
            />

            <!-- 돋보기 -->
            <span class="material-symbols-rounded search-icon"
                  onclick="handleSearchClick()">
                search
              </span>
          </div>

          <select class="c-select" style="width: 110px" onchange="filterStatus(this.value)">
            <option value="">전체</option>
            <option value="active">활성</option>
            <option value="inactive">비활성</option>
          </select>
          <select class="c-select" style="width: 110px" id="roleFilter" onchange="filterRole(this.value)">
            <option value="">전체 권한</option>
          </select>
        </div>
      </div>
      <div class="c-card__body" style="padding: 0">
        <div class="c-table-wrap">
          <table class="c-table">
            <thead>
            <tr>
              <th>관리자 정보</th>
              <th style="width: 180px">소속 단지</th>
              <th style="width: 130px">권한 레벨</th>
              <th style="width: 150px">최근 접속</th>
              <th style="width: 110px">활성화</th>
            </tr>
            </thead>
            <tbody id="acctTbody"></tbody>
          </table>
        </div>
        <div class="c-pagination" id="acctPagination"></div>
      </div>
    </div>
  </div>
</div>

<!-- 계정 상세 모달 -->
<div class="c-modal-overlay is-hidden" id="detailOverlay" onclick="if(event.target===this)closeAccountDetail()">
  <div class="c-modal">
    <div class="c-modal__header">
      <span id="detailAcctTitle">계정 상세</span>
      <button class="c-btn c-btn--ghost c-btn--sm" onclick="closeAccountDetail()"><span class="material-symbols-rounded">close</span>닫기</button>
    </div>
    <div class="c-modal__body">
      <div class="c-info-grid" id="detailAcctContent"></div>
    </div>
    <div class="c-modal__footer">
      <button class="c-btn c-btn--danger" onclick="deleteAccount()">계정 삭제</button>
      <button class="c-btn" onclick="closeAccountDetail()">비밀번호 재설정</button>
      <button class="c-btn" onclick="closeAccountDetail()">수정</button>
    </div>
  </div>
</div>

<%--    <!-- 신규 계정 생성 모달 (엑셀 내보내기)--> --%>
<%--    <div class="c-modal-overlay is-hidden" id="modalOverlay" onclick="closeModalOutside(event)">--%>
<%--      <div class="c-modal">--%>
<%--        <div class="c-modal__header">--%>
<%--          <div>--%>
<%--            <h4 class="c-modal__title">신규 계정 생성</h4>--%>
<%--            <p style="font-size: 12px; color: var(--text-tertiary); margin-top: 3px">계정을 생성하고 담당 단지에 즉시 매핑합니다.</p>--%>
<%--          </div>--%>
<%--          <button class="c-modal__close" onclick="closeModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>--%>
<%--        </div>--%>
<%--        <div class="c-modal__body">--%>
<%--          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">--%>
<%--            <div class="c-field">--%>
<%--              <label class="c-label">관리자 이름 <span class="req">*</span></label>--%>
<%--              <input class="c-input" type="text" placeholder="성명 입력" />--%>
<%--            </div>--%>
<%--            <div class="c-field">--%>
<%--              <label class="c-label">접속 아이디 <span class="req">*</span></label>--%>
<%--              <input class="c-input" type="text" placeholder="6자 이상 영문·숫자" />--%>
<%--            </div>--%>
<%--            <div class="c-field">--%>
<%--              <label class="c-label">임시 비밀번호 <span class="req">*</span></label>--%>
<%--              <input class="c-input" type="password" placeholder="초기 비밀번호" />--%>
<%--            </div>--%>
<%--            <div class="c-field">--%>
<%--              <label class="c-label">연락처</label>--%>
<%--              <input class="c-input" type="text" placeholder="010-0000-0000" />--%>
<%--            </div>--%>
<%--            <div class="c-field">--%>
<%--              <label class="c-label">소속 단지 <span class="req">*</span></label>--%>
<%--              <select class="c-select">--%>
<%--                <option value="">단지 선택</option>--%>
<%--                <option>A단지 · 행복아파트</option>--%>
<%--                <option>B단지 · 희망빌라</option>--%>
<%--                <option>C단지 · 미래아파트</option>--%>
<%--                <option>D단지 · 푸른마을</option>--%>
<%--              </select>--%>
<%--            </div>--%>
<%--            <div class="c-field">--%>
<%--              <label class="c-label">권한 레벨 <span class="req">*</span></label>--%>
<%--              <select class="c-select" id="roleSelect"></select>--%>
<%--            </div>--%>
<%--          </div>--%>
<%--        </div>--%>
<%--        <div class="c-modal__footer">--%>
<%--          <button class="c-btn c-btn--ghost" onclick="closeModal()">취소</button>--%>
<%--          <button class="c-btn c-btn--primary"><span class="material-symbols-rounded">person_add</span>계정 생성</button>--%>
<%--        </div>--%>
<%--      </div>--%>
<%--    </div>--%>

<script>
  const PAGE_SIZE=10;
  const ROLES=[
    {key:"관리소장",level:"HEAD",color:"blue",icon:"shield_person",title:"관리소장",desc:"단지 내 최상위 권한. 모든 메뉴 접근 가능",perms:[{ok:1,text:"전체 메뉴 열람·편집"},{ok:1,text:"계약·재무 처리"},{ok:1,text:"민원·공고 승인"}]},
    {key:"회계",level:"ACNT",color:"yellow",icon:"account_balance",title:"회계",desc:"재무 데이터 전담. 수납·정산 권한",perms:[{ok:1,text:"계약·재무 전체"},{ok:1,text:"수납 내역 수정"},{ok:0,text:"민원·시설 불가"}]},
    {key:"행정",level:"ADM",color:"green",icon:"edit_document",title:"행정",desc:"입주민 소통 전담. 민원·공고 처리",perms:[{ok:1,text:"입주민 관리 열람"},{ok:1,text:"민원·공고 처리"},{ok:0,text:"재무 접근 불가"}]},
    {key:"시설",level:"FAC",color:"orange",icon:"handyman",title:"시설",desc:"시설 점검 전담. 최소 접근 권한",perms:[{ok:1,text:"시설 민원·점검"},{ok:1,text:"점검 일지 작성"},{ok:0,text:"재무·계약 불가"}]},
  ];

  /* 하드코딩 데이터 - DB연결 후, 삭제 예정 --시작-- */
  const ACCOUNTS=[];(function(){
    const rows=[
      ["김관리","admin_kim","행복아파트 · A단지","관리소장","blue","2026-04-21","15:30",1,"김","#dbeafe","#1d4ed8"],
      ["이회계","acct_lee","행복아파트 · A단지","회계","yellow","2026-04-20","09:11",1,"이","#fef3c7","#92400e"],
      ["박행정","admin_park","희망빌라 · B단지","행정","green","2026-04-21","11:42",1,"박","#dcfce7","#166534"],
      ["최시설","facility_choi","미래아파트 · C단지","시설","orange","2026-03-10","08:00",0,"최","#f3f4f6","#9ca3af"],
      ["정관리","admin_jung","푸른마을 · D단지","관리소장","blue","2026-04-22","10:05",1,"정","#dbeafe","#1d4ed8"],
      ["한회계","acct_han","행복아파트 · E단지","회계","yellow","2026-04-19","16:33",1,"한","#fef3c7","#92400e"],
      ["강행정","admin_kang","희망빌라 · B단지","행정","green","2026-04-22","13:20",1,"강","#dcfce7","#166534"],
      ["윤시설","facility_yoon","미래아파트 · C단지","시설","orange","2026-04-21","08:30",1,"윤","#fed7aa","#c2410c"],
      ["신행정","admin_shin","푸른마을 · D단지","행정","green","2026-04-22","09:50",1,"신","#dcfce7","#166534"],
      ["임관리","admin_im","행복아파트 · F단지","관리소장","blue","2026-03-25","14:00",0,"임","#f3f4f6","#9ca3af"],
      ["오시설","facility_oh","푸른마을 · D단지","시설","orange","2026-04-22","07:55",1,"오","#fed7aa","#c2410c"],
      ["장회계","acct_jang","미래아파트 · C단지","회계","yellow","2026-04-21","17:00",1,"장","#fef3c7","#92400e"],
    ];
    rows.forEach((r,i)=>ACCOUNTS.push({id:i+1,name:r[0],uid:r[1],complex:r[2],role:r[3],roleColor:r[4],lastDate:r[5],lastTime:r[6],active:!!r[7],avatar:r[8],avatarBg:r[9],avatarColor:r[10]}));
  })();
  /* 하드코딩 데이터 - DB연결 후, 삭제 예정 --끝-- */

    <%--    DB 연결 후, 사용예정 --시작 --%>
    <%--      서버에서 내려준 계정 목록 데이터--%>
    <%--${accountListJson}--%>
    <%--    → Controller에서 Oracle DB 조회 결과를 JSON 문자열로 만들어 JSP에 전달한 값--%>
    <%--    JSON이란?--%>
    <%--    → JavaScript에서 바로 사용할 수 있는 데이터 형식--%>
    <%--    왜 사용?--%>
    <%--    → DB에서 가져온 목록을 JS 배열처럼 사용하기 위해--%>
    <%--    --%>
    <%--  const ACCOUNTS = ${accountListJson};
    DB 연결 후, 사용예정 --끝 --%>



  const ROLE_BG = { blue: "var(--blue-bg)", yellow: "var(--yellow-bg)", green: "var(--green-bg)", orange: "var(--orange-bg)" };
  const ROLE_FG = { blue: "var(--accent)", yellow: "var(--yellow)", green: "var(--green)", orange: "var(--orange)" };
  const ROLE_ICON = { 관리소장: "shield_person", 회계: "account_balance", 행정: "edit_document", 시설: "handyman" };

  function setDefaultRole(key) {
    const sel = document.getElementById("roleSelect");
    if (sel) sel.value = key;
  }

  function renderRoleGuide() {
    const grid = document.getElementById("roleGrid");
    if (!grid) return;

    grid.innerHTML = ROLES.map(function(r) {

      // 권한 상세 목록 HTML 생성
      const permHtml = r.perms.map(function(p) {
        return ''
                + '<div class="role-card__perm ' + (p.ok ? 'yes' : 'no') + '">'
                + '  <span class="material-symbols-rounded">'
                +      (p.ok ? 'check_circle' : 'remove_circle')
                + '  </span>'
                +    p.text
                + '</div>';
      }).join('');

      return ''
              + '<div class="role-card">'
              + '  <div class="role-card__top">'
              + '    <div class="role-card__icon" style="background: ' + ROLE_BG[r.color] + '">'
              + '      <span class="material-symbols-rounded" style="color: ' + ROLE_FG[r.color] + '">' + r.icon + '</span>'
              + '    </div>'
              + '    <span class="role-card__lv" style="background: ' + ROLE_BG[r.color] + '; color: ' + ROLE_FG[r.color] + '">' + r.level + '</span>'
              + '  </div>'
              + '  <div class="role-card__title">' + r.title + '</div>'
              + '  <div class="role-card__desc">' + r.desc + '</div>'
              + '  <div class="role-card__perms">'
              +      permHtml
              + '  </div>'
              + '</div>';
    }).join('');
  }

  function toggleRoleGuide() {
    const body = document.getElementById("roleGuideBody");
    if (!body) return;
    const isOpen = body.style.display !== "none";
    body.style.display = isOpen ? "none" : "";
  }

  function initRoleSelects() {
    const roleSelect = document.getElementById("roleSelect");
    if (roleSelect) {
      roleSelect.innerHTML =
              ROLES.map(r => `<option value="${r.key}">${r.title} (${r.level})</option>`).join("");
      roleSelect.addEventListener("change", () => setDefaultRole(roleSelect.value));
    }

    const roleFilter = document.getElementById("roleFilter");
    if (roleFilter) {
      // value="" 는 전체 조회를 의미함
      // filteredAccounts()에서 state.role 값이 비어 있으면 권한 필터를 적용하지 않음
      roleFilter.innerHTML =
              `<option value="">전체</option>` +
              ROLES.map(r => `<option value="${r.key}">${r.title}</option>`).join("");
    }
  }

  const state = { page: 1, q: "", status: "", role: "" };

  function filteredAccounts() {
    return ACCOUNTS.filter(a => {
      const inactiveText = a.active ? "active" : "inactive";
      if (state.status && state.status !== inactiveText) return false;
      if (state.role && a.role !== state.role) return false;
      if (state.q) {
        const k = (a.name + a.uid + a.complex).toLowerCase();
        if (!k.includes(state.q.toLowerCase())) return false;
      }
      return true;
    });
  }

  function renderAccounts() {
    const all = filteredAccounts();
    const last = Math.max(1, Math.ceil(all.length / PAGE_SIZE));
    if (state.page > last) state.page = last;
    const slice = all.slice((state.page-1)*PAGE_SIZE, state.page*PAGE_SIZE);

    const tbody = document.getElementById("acctTbody");
    tbody.innerHTML = slice.length ? slice.map(a => `
          <tr class="${a.active ? "" : "row-inactive"}" style="cursor:pointer" onclick="openAccountDetail(${a.id})">
            <td>
              <div class="user-cell">
                <div class="user-avatar" style="background:${a.avatarBg};color:${a.avatarColor}">${a.avatar}</div>
                <div>
                  <div class="user-name" style="${a.active ? "" : "color:var(--text-tertiary)"}">${a.name}</div>
                  <div class="user-id">${a.uid}</div>
                </div>
              </div>
            </td>
            <td class="muted">${a.complex}</td>
            <td>
              <span class="c-badge" style="background:${ROLE_BG[a.roleColor]};color:${ROLE_FG[a.roleColor]};gap:4px">
                <span class="material-symbols-rounded" style="font-size:12px">${ROLE_ICON[a.role]}</span>${a.role}
              </span>
            </td>
            <td class="muted">${a.lastDate} <span style="color:#d1d5db;font-size:11px">${a.lastTime}</span></td>
            <td onclick="event.stopPropagation()">
              <div style="display:flex;align-items:center;gap:8px">
                <label class="toggle-wrap">
                  <input type="checkbox" ${a.active ? "checked" : ""} onchange="toggleActive(${a.id}, this)" />
                  <div class="toggle-track"></div>
                  <div class="toggle-thumb"></div>
                </label>
                <span style="font-size:12px;font-weight:700;color:${a.active ? "var(--green)" : "var(--text-tertiary)"}">${a.active ? "활성" : "비활성"}</span>
              </div>
            </td>
          </tr>`).join("") : `<tr class="c-table__empty"><td colspan="5">조회된 계정이 없습니다.</td></tr>`;

    document.getElementById("acctSubtitle").textContent = `총 ${all.length}건 / ${state.page} 페이지`;
    renderPagination("acctPagination", all.length, state.page, last, p => { state.page = p; renderAccounts(); });
  }

  function renderPagination(id, total, current, last, onChange) {
    const el = document.getElementById(id);
    if (last <= 1) { el.innerHTML = ""; return; }
    const btn = (label, page, opts={}) => {
      const cls = ["c-pagination__btn"];
      if (opts.active) cls.push("is-active");
      if (opts.disabled) cls.push("is-disabled");
      return `<button class="${cls.join(" ")}" data-page="${page}">${label}</button>`;
    };
    let html = btn(`<span class="material-symbols-rounded">chevron_left</span>`, current-1, { disabled: current===1 });
    for (let i = 1; i <= last; i++) html += btn(i, i, { active: i === current });
    html += btn(`<span class="material-symbols-rounded">chevron_right</span>`, current+1, { disabled: current===last });
    el.innerHTML = html;
    el.querySelectorAll(".c-pagination__btn").forEach(b => {
      b.addEventListener("click", () => {
        if (b.classList.contains("is-disabled") || b.classList.contains("is-active")) return;
        onChange(Number(b.dataset.page));
      });
    });
  }

  function toggleActive(id, cb) {
    const a = ACCOUNTS.find(x => x.id === id);
    if (a) a.active = cb.checked;
    renderAccounts();
  }

  // 검색 실행 공통 함수
  function executeSearch() {
    const input = document.getElementById("searchInput");

    // input이 없으면 오류 방지
    if (!input) return;

    // trim() : 앞뒤 공백 제거
    // 예: " 김관리 " → "김관리"
    searchAccounts(input.value.trim());
  }

  // 엔터 키 검색
  function handleSearchKey(event) {
    if (event.key === "Enter") {
      executeSearch();
    }
  }

  // 돋보기 아이콘 클릭 검색
  function handleSearchClick() {
    executeSearch();
  }

  function searchAccounts(v) { state.q = v; state.page = 1; renderAccounts(); }
  function filterStatus(v) { state.status = v; state.page = 1; renderAccounts(); }
  function filterRole(v) { state.role = v; state.page = 1; renderAccounts(); }

  function openModal() { document.getElementById("modalOverlay").classList.remove("is-hidden"); }
  function closeModal() { document.getElementById("modalOverlay").classList.add("is-hidden"); }
  function closeModalOutside(e) { if (e.target === document.getElementById("modalOverlay")) closeModal(); }

  let currentAccountId = null;
  function openAccountDetail(id) {
    currentAccountId = id;
    const a = ACCOUNTS.find(x => x.id === id);
    if (!a) return;
    document.getElementById("detailAcctTitle").textContent = a.name + " — 계정 상세";
    document.getElementById("detailAcctContent").innerHTML = [
      ["관리자 이름", a.name], ["아이디", a.uid],
      ["소속 단지", a.complex], ["권한", a.role],
      ["최근 접속", a.lastDate + " " + a.lastTime],
      ["상태", a.active ? '<span class="c-badge c-badge--active">활성</span>' : '<span class="c-badge c-badge--neutral">비활성</span>'],
    ].map(([label, val]) =>
            '<div class="c-info-block"><div class="c-label">' + label + '</div><div class="c-value">' + val + '</div></div>'
    ).join("");
    document.getElementById("detailOverlay").classList.remove("is-hidden");
  }
  function closeAccountDetail() {
    document.getElementById("detailOverlay").classList.add("is-hidden");
    currentAccountId = null;
  }
  function deleteAccount() {
    if (!currentAccountId || !confirm("해당 계정을 삭제하시겠습니까?")) return;
    const idx = ACCOUNTS.findIndex(x => x.id === currentAccountId);
    if (idx > -1) ACCOUNTS.splice(idx, 1);
    closeAccountDetail();
    renderAccounts();
  }


  /* =========================================================
     신청 계정 목록 기능
     - 검색, 상태필터, 전체선택, 승인, 반려, 엑셀 내보내기
     ========================================================= */

  // 현재 신청 목록 검색어
  let rqstKeyword = "";

  // 현재 신청 목록 상태 필터
  let rqstStatus = "all";

  /*
    renderRequestTable()
    → 신청 계정 목록에서 검색어와 상태 필터를 동시에 적용하는 함수
  */
  function renderRequestTable() {
    const table = document.getElementById("rqstTable");
    if (!table) return;

    const rows = table.querySelectorAll("tbody tr");

    rows.forEach(function(row) {
      const rowStatus = row.dataset.status || "";
      const rowText = (row.dataset.name || row.innerText).toLowerCase();

      const keywordMatched = rowText.includes(rqstKeyword.toLowerCase());
      const statusMatched = rqstStatus === "all" || rowStatus === rqstStatus;

      row.style.display = keywordMatched && statusMatched ? "" : "none";
    });

    updateRequestCount();
  }

  /*
    searchTable()
    → 신청 계정 목록 검색 input 입력 시 실행
  */
  function searchTable(tableId, keyword) {
    rqstKeyword = (keyword || "").trim();
    renderRequestTable();
  }

  /*
    searchBtnClick()
    → 신청 계정 목록 돋보기 아이콘 클릭 시 실행
  */
  function searchBtnClick(tableId, inputId) {
    const input = document.getElementById(inputId);
    rqstKeyword = input ? input.value.trim() : "";
    renderRequestTable();
  }

  /*
    filterTable()
    → 전체 / 승인대기 / 승인완료 / 반려 필터
  */
  function filterTable(tableId, status) {
    rqstStatus = status || "all";
    renderRequestTable();
  }

  /*
    toggleAll()
    → 현재 화면에 보이는 신청 계정만 전체 선택
  */
  function toggleAll(tableId, checkbox) {
    const table = document.getElementById(tableId);
    if (!table) return;

    table.querySelectorAll("tbody tr").forEach(function(row) {
      if (row.style.display === "none") return;

      const cb = row.querySelector(".row-check");
      if (cb) cb.checked = checkbox.checked;
    });
  }

  /*
    getCheckedRequestRows()
    → 체크된 신청 계정 행을 배열로 가져오는 함수
  */
  function getCheckedRequestRows() {
    const table = document.getElementById("rqstTable");
    if (!table) return [];

    return Array.from(table.querySelectorAll("tbody tr")).filter(function(row) {
      const cb = row.querySelector(".row-check");
      return cb && cb.checked;
    });
  }

  /*
    getTargetRows()
    → 개별 승인/반려 버튼 클릭 시 해당 행만 처리
    → 상단 선택 승인/반려 버튼 클릭 시 체크된 행 처리
  */
  function getTargetRows(btn) {
    if (btn) {
      const row = btn.closest("tr");
      return row ? [row] : [];
    }

    return getCheckedRequestRows();
  }

  /*
    openApprovalModal()
    → 선택한 신청 계정 승인 처리
  */
  function openApprovalModal(btn) {
    const targetRows = getTargetRows(btn);

    if (targetRows.length === 0) {
      alert("승인할 계정을 선택해주세요.");
      return;
    }

    if (!confirm(targetRows.length + "건을 승인 처리하시겠습니까?")) {
      return;
    }

    targetRows.forEach(function(row) {
      row.dataset.status = "ok";

      const statusTd = row.children[5];
      statusTd.innerHTML = '<span class="badge ok">승인완료</span>';

      const actionTd = row.children[6];
      actionTd.innerHTML =
              '<div class="row-actions">' +
              '  <button type="button" class="icon-btn-sm" title="승인 계정 목록 추가" onclick="addApprovedAccount(this)">' +
              '<span class="material-symbols-rounded">move_to_inbox</span>' +
              '  </button>' +
              '</div>';

      const cb = row.querySelector(".row-check");
      if (cb) cb.checked = false;
    });

    const headCheck = document.querySelector("#rqstTable thead .rqst-check");
    if (headCheck) headCheck.checked = false;

    updateRequestCount();
    renderRequestTable();

    alert("승인 처리가 완료되었습니다.");
  }

  /*
    openRejectModal()
    → 선택한 신청 계정 반려 처리
  */
  function openRejectModal(btn) {
    const targetRows = getTargetRows(btn);

    if (targetRows.length === 0) {
      alert("반려할 계정을 선택해주세요.");
      return;
    }

    const reason = prompt("반려 사유를 입력해주세요.");

    if (reason === null) {
      return;
    }

    if (reason.trim() === "") {
      alert("반려 사유를 입력해야 합니다.");
      return;
    }

    targetRows.forEach(function(row) {
      row.dataset.status = "reject";
      row.dataset.rejectReason = reason.trim();

      const statusTd = row.children[5];
      statusTd.innerHTML = '<span class="badge reject">반려</span>';

      const actionTd = row.children[6];
      actionTd.innerHTML =
              '<div class="row-actions">' +
              '  <button type="button" class="icon-btn-sm danger" title="반려사유" onclick="showRejectReason(this)">' +
              '    <span class="material-symbols-rounded">visibility</span>' +
              '  </button>' +
              '</div>';

      const cb = row.querySelector(".row-check");
      if (cb) cb.checked = false;
    });

    const headCheck = document.querySelector("#rqstTable thead .rqst-check");
    if (headCheck) headCheck.checked = false;

    updateRequestCount();
    renderRequestTable();

    alert("반려 처리가 완료되었습니다.");
  }

  /*
    showRejectReason()
    → 반려 사유 확인
  */
  function showRejectReason(btn) {
    const row = btn.closest("tr");
    const reason = row.dataset.rejectReason || "등록된 반려 사유가 없습니다.";
    alert("반려 사유: " + reason);
  }

  /*
  addApprovedAccount()
  → 승인완료된 신청 계정을 아래 '계정 목록 및 활성화' 목록에 추가하는 함수

  함수란?
  → 특정 기능을 재사용하기 위해 이름을 붙여놓은 코드 묶음

  왜 사용?
  → 승인완료 행마다 같은 추가 로직을 반복 작성하지 않고,
    버튼 클릭 시 이 함수 하나만 실행하면 되게 하기 위해 사용
*/
  function addApprovedAccount(btn) {
    const row = btn.closest("tr");

    if (!row) return;

    /*
      dataset.status
      → tr 태그의 data-status 값을 가져옴
      예: <tr data-status="ok">
      여기서 row.dataset.status 값은 "ok"
    */
    if (row.dataset.status !== "ok") {
      alert("승인완료 상태의 계정만 추가할 수 있습니다.");
      return;
    }

    if (!confirm("승인 계정 목록에 추가하시겠습니까?")) {
      return;
    }

    const name = row.querySelector(".user-name")?.textContent.trim() || "";
    const uid = row.querySelector(".user-id")?.textContent.trim() || "";
    const complex = row.children[2]?.textContent.trim() || "";
    const role = row.children[3]?.innerText.trim() || "";

    /*
      중복 체크
      → 이미 아래 계정 목록에 같은 아이디가 있으면 다시 추가하지 않음

      왜 필요?
      → 같은 승인 계정을 여러 번 누르면 목록에 중복으로 들어가는 문제 방지
    */
    const exists = ACCOUNTS.some(function(account) {
      return account.uid === uid;
    });

    if (exists) {
      alert("이미 계정 목록에 추가된 계정입니다.");

      /*
        remove()
        → HTML 요소를 화면에서 제거하는 함수

        왜 사용?
        → 이미 아래 계정 목록에 추가된 신청 건은
          위 신청 목록에 계속 남아 있을 필요가 없기 때문에 삭제 처리함
      */
      row.remove();

      /*
        updateRequestCount()
        → 위 신청 목록의 총 건수/승인대기/승인완료/반려 건수를 다시 계산
      */
      updateRequestCount();

      /*
        renderRequestTable()
        → 현재 검색어/필터 조건을 다시 적용해서 화면을 정리
      */
      renderRequestTable();

      return;
    }

    const roleColorMap = {
      "관리소장": "blue",
      "회계": "yellow",
      "행정": "green",
      "시설": "orange"
    };

    const avatarBgMap = {
      "관리소장": "#dbeafe",
      "회계": "#fef3c7",
      "행정": "#dcfce7",
      "시설": "#fed7aa"
    };

    const avatarColorMap = {
      "관리소장": "#1d4ed8",
      "회계": "#92400e",
      "행정": "#166534",
      "시설": "#c2410c"
    };

    /*
      push()
      → 배열 마지막에 데이터를 추가하는 함수

      ACCOUNTS란?
      → 아래 '계정 목록 및 활성화' 테이블을 그릴 때 사용하는 데이터 배열
    */
    ACCOUNTS.push({
      id: ACCOUNTS.length + 1,
      name: name,
      uid: uid,
      complex: complex,
      role: role,
      roleColor: roleColorMap[role] || "green",
      lastDate: new Date().toISOString().slice(0, 10),
      lastTime: "00:00",
      active: true,
      avatar: name.substring(0, 1),
      avatarBg: avatarBgMap[role] || "#dcfce7",
      avatarColor: avatarColorMap[role] || "#166534"
    });

    /*
      renderAccounts()
      → ACCOUNTS 배열을 기준으로 아래 계정 목록 테이블을 다시 그림

      왜 필요?
      → 배열에 데이터만 추가하면 화면은 자동으로 바뀌지 않기 때문에
        화면을 다시 렌더링해야 함
    */
    renderAccounts();

    alert("계정 목록 및 활성화 목록에 추가되었습니다.");
  }

  /*
    updateRequestCount()
    → 신청 계정 목록 하단 건수 갱신
  */
  function updateRequestCount() {
    const table = document.getElementById("rqstTable");
    if (!table) return;

    const rows = Array.from(table.querySelectorAll("tbody tr"));
    const visibleRows = rows.filter(row => row.style.display !== "none");

    const total = rows.length;
    const wait = rows.filter(row => row.dataset.status === "wait").length;
    const ok = rows.filter(row => row.dataset.status === "ok").length;
    const reject = rows.filter(row => row.dataset.status === "reject").length;

    const footerTotal = document.querySelector(".table-footer span:first-child");
    if (footerTotal) {
      footerTotal.innerHTML = "총 <strong>" + visibleRows.length + "</strong>건 표시 중";
    }

    // const headerStatus = document.querySelector(".section-hd > span");
    // if (headerStatus) {
    //   headerStatus.textContent = "총 " + total + "건 / 승인대기 " + wait + "건 / 승인완료 " + ok + "건 / 반려 " + reject + "건";
    // }
    const rqstSummary = document.getElementById("rqstSummary");
    if (rqstSummary) {
      rqstSummary.textContent =
              "총 " + total + "건 / 승인대기 " + wait + "건 / 승인완료 " + ok + "건 / 반려 " + reject + "건";
    }

  }

  /*
    exportAccountsToExcel()
    → 계정 목록을 CSV 파일로 다운로드
    CSV란?
    → 엑셀에서 열 수 있는 콤마 구분 텍스트 파일
    왜 사용?
    → 서버 기능 없이 프론트 화면에서 간단히 엑셀 내보내기를 구현할 수 있음
  */
  function exportAccountsToExcel() {
    const header = ["관리자명", "아이디", "소속단지", "권한", "최근접속일", "최근접속시간", "상태"];

    const rows = ACCOUNTS.map(function(a) {
      return [
        a.name,
        a.uid,
        a.complex,
        a.role,
        a.lastDate,
        a.lastTime,
        a.active ? "활성" : "비활성"
      ];
    });

    const csvContent = [header].concat(rows)
            .map(function(row) {
              return row.map(function(cell) {
                return '"' + String(cell).replaceAll('"', '""') + '"';
              }).join(",");
            })
            .join("\n");

    const bom = "\uFEFF";
    const blob = new Blob([bom + csvContent], {
      type: "text/csv;charset=utf-8;"
    });

    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");

    a.href = url;
    a.download = "단지관리자_계정목록.csv";
    document.body.appendChild(a);
    a.click();

    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }

  initRoleSelects();
  setDefaultRole(ROLES[0].key);
  renderRoleGuide();
  renderAccounts();
  updateRequestCount();
</script>
<script>
  function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
  var logoIcon=document.getElementById("logoIcon");
  if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
</script>
</body>
</html>
