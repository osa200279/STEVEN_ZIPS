<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 공고 관리</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralAside.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralHeader.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/centralCommon.css" />
    <script defer src="<%= request.getContextPath() %>/js/centralAside.js"></script>
    <script defer src="<%= request.getContextPath() %>/js/centralHeader.js"></script>
    <style id="page-style">
      /* announcement.jsp 전용 — 서류 목록, 체크박스 그룹 */
      /* tab-panel, step-*, err-msg, is-error → centralCommon.css 제공 */

      .doc-list { display: flex; flex-direction: column; gap: 8px; }
      .doc-item {
        display: flex; align-items: center; gap: 8px; font-size: 13px;
        padding: 10px 14px; background: var(--green-bg); border-radius: 8px; color: var(--text-primary);
      }
      .doc-icon { color: var(--green); font-size: 18px; }

      .cb-group { display: flex; flex-wrap: wrap; gap: 12px; }
      .cb-group label { display: flex; align-items: center; gap: 6px; font-size: 13px; cursor: pointer; }
    </style>
  </head>
  <body>
    <aside class="sidebar" id="sidebar">
      <div class="sidebar-logo">
        <div class="logo-mark">
          <div class="logo-icon" id="logoIcon"><span class="material-symbols-rounded">home_work</span></div>
          <div class="logo-text">
            <h1>우리집맵핑</h1>
            <p>중앙관리 시스템</p>
          </div>
        </div>
        <button class="collapse-btn" onclick="toggleSidebar()" data-tooltip="사이드바 접기"><span class="material-symbols-rounded">left_panel_close</span></button>
      </div>
      <nav class="sidebar-nav">
        <div class="nav-group">
          <a class="nav-item" data-page="대시보드" data-parent="대시보드"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="<%= request.getContextPath() %>/conManagement/buildSearch" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/buildRegister" class="nav-item"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/residentList" class="nav-item"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a href="<%= request.getContextPath() %>/conManagement/contractList.do" class="nav-item"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/statistics" class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a href="<%= request.getContextPath() %>/conManagement/civilCom" class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/ai" class="nav-item"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/announcement" class="nav-item active"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/notice" class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a href="<%= request.getContextPath() %>/conManagement/facility" class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/subAdmin" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">하위관리자 계정</span></a>
        </div>
      </nav>
      <div class="admin-card">
        <div class="admin-avatar"><span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span></div>
        <div class="admin-info">
          <p>중앙관리자</p>
          <span>클로드 최고</span>
        </div>
        <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto"><span class="material-symbols-rounded">logout</span></button>
      </div>
    </aside>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span>민원·소통</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">공고 관리</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
          <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
        </div>
      </div>

      <div class="main-content">
        <div class="page-header">
          <div>
            <div class="page-title">공고 관리</div>
            <div class="page-subtitle">입주자 모집·공고를 등록·수정하고 진행 상태를 한눈에 관리합니다.</div>
          </div>
          <div class="page-header__right">
            <button class="c-btn c-btn--primary" onclick="openRegister()"><span class="material-symbols-rounded">add</span>공고 등록</button>
          </div>
        </div>

        <!-- 탭1: 목록 -->
        <div id="tab0" class="tab-panel is-active">
          <div class="c-card c-card--divide" style="margin-bottom: 16px">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">검색 조건</div>
                <div class="c-card__sub">조건을 입력하면 공고 목록이 필터링됩니다.</div>
              </div>
              <div class="c-card__actions">
                <button class="c-btn c-btn--ghost" onclick="resetFilter()"><span class="material-symbols-rounded">refresh</span>초기화</button>
                <button class="c-btn c-btn--primary" onclick="doFilter()"><span class="material-symbols-rounded">search</span>검색</button>
              </div>
            </div>
            <div class="c-card__body c-filter-row">
              <div class="c-field" style="flex: 1; min-width: 200px">
                <label class="c-label">공고 제목</label>
                <input type="text" class="c-input" id="f-title" placeholder="제목 검색" />
              </div>
              <div class="c-field" style="min-width: 160px">
                <label class="c-label">단지</label>
                <select class="c-select" id="f-site">
                  <option value="">단지 전체</option>
                  <option>강남 센트럴</option>
                  <option>한강 리버뷰</option>
                  <option>자이 아파트</option>
                </select>
              </div>
              <div class="c-field" style="min-width: 130px">
                <label class="c-label">시작일</label>
                <input type="date" class="c-input" id="f-from" />
              </div>
              <div class="c-field" style="min-width: 130px">
                <label class="c-label">종료일</label>
                <input type="date" class="c-input" id="f-to" />
              </div>
              <div class="c-field" style="min-width: 120px">
                <label class="c-label">상태</label>
                <select class="c-select" id="f-status">
                  <option value="">전체</option>
                  <option>진행중</option>
                  <option>마감</option>
                  <option>예정</option>
                </select>
              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">공고 목록</div>
                <div class="c-card__sub">총 <span id="list-count" style="color: var(--accent); font-weight: 800">0</span>건 · 페이지당 10건</div>
              </div>
            </div>
            <div class="c-table-wrap">
              <table class="c-table">
                <thead>
                  <tr>
                    <th>공고 제목</th>
                    <th style="width: 120px">단지</th>
                    <th style="width: 200px">모집 기간</th>
                    <th style="width: 100px">공급</th>
                    <th>제출 서류</th>
                    <th style="width: 90px">상태</th>
                  </tr>
                </thead>
                <tbody id="list-body"></tbody>
              </table>
            </div>
            <div class="c-card__footer" style="justify-content: center">
              <div class="c-pagination" id="pagination"></div>
            </div>
          </div>
        </div>

        <!-- 탭2: 등록/수정 폼 -->
        <div id="tab1" class="tab-panel">
          <div class="c-card c-card--divide" style="max-width: 720px">
            <div class="c-card__header">
              <div>
                <div class="c-card__title" id="form-title">입주자 모집 공고 등록</div>
                <div class="c-card__sub">필수 항목(<span style="color: var(--red)">*</span>)을 모두 입력해주세요.</div>
              </div>
            </div>
            <div class="c-card__body">
              <div class="c-field">
                <label class="c-label">공고 제목 <span style="color: var(--red)">*</span></label>
                <input type="text" id="f-ftitle" class="c-input" placeholder="공고 제목을 입력하세요" />
                <div class="err-msg" id="e-ftitle"></div>
              </div>
              <div class="c-field">
                <label class="c-label">단지 <span style="color: var(--red)">*</span></label>
                <select id="f-fsite" class="c-select">
                  <option value="">단지 선택</option>
                  <option>강남 센트럴</option>
                  <option>한강 리버뷰</option>
                  <option>자이 아파트</option>
                </select>
                <div class="err-msg" id="e-fsite"></div>
              </div>
              <div class="c-field">
                <label class="c-label">모집 기간 <span style="color: var(--red)">*</span></label>
                <div style="display: flex; gap: 8px; align-items: center">
                  <input type="date" id="f-fstart" class="c-input" style="flex: 1" />
                  <span style="color: var(--text-tertiary)">~</span>
                  <input type="date" id="f-fend" class="c-input" style="flex: 1" />
                </div>
                <div class="err-msg" id="e-fdate"></div>
              </div>
              <div class="c-field">
                <label class="c-label">공급 세대수 <span style="color: var(--red)">*</span></label>
                <input type="number" id="f-funit" class="c-input" placeholder="세대수 입력" style="width: 200px" min="1" />
                <div class="err-msg" id="e-funit"></div>
              </div>
              <div class="c-field">
                <label class="c-label">제출 서류</label>
                <div class="cb-group">
                  <label><input type="checkbox" name="docs" value="신분증 사본" /> 신분증 사본</label>
                  <label><input type="checkbox" name="docs" value="주민등록등본" /> 주민등록등본</label>
                  <label><input type="checkbox" name="docs" value="가족관계증명서" /> 가족관계증명서</label>
                  <label><input type="checkbox" name="docs" value="소득증명서" /> 소득증명서</label>
                  <label><input type="checkbox" name="docs" value="근로소득원천징수영수증" /> 근로소득원천징수영수증</label>
                </div>
              </div>
            </div>
            <div class="c-card__footer">
              <button class="c-btn c-btn--ghost" onclick="switchTab(0, document.querySelectorAll('.c-tab-btn')[0])">취소</button>
              <button class="c-btn c-btn--primary" id="form-submit-btn" onclick="submitForm()"><span class="material-symbols-rounded">check</span>등록</button>
            </div>
          </div>
        </div>

        <!-- 탭3: 안내 -->
        <div id="tab2" class="tab-panel">
          <div class="c-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px">
            <div class="c-card c-card--divide">
              <div class="c-card__header"><div class="c-card__title">입주자 모집 절차</div></div>
              <div class="c-card__body">
                <div class="c-step-list">
                  <div class="c-step-item">
                    <div class="c-step-num">1</div>
                    <div class="c-step-text"><strong>공고 등록</strong><span>관리자가 모집 공고를 등록하고 신청 기간을 설정합니다.</span></div>
                  </div>
                  <div class="c-step-item">
                    <div class="c-step-num">2</div>
                    <div class="c-step-text"><strong>신청 접수</strong><span>신청 기간 내 입주 희망자가 온라인 또는 방문으로 신청서를 제출합니다.</span></div>
                  </div>
                  <div class="c-step-item">
                    <div class="c-step-num">3</div>
                    <div class="c-step-text"><strong>서류 심사</strong><span>제출된 서류를 바탕으로 자격 요건 및 우선순위를 심사합니다.</span></div>
                  </div>
                  <div class="c-step-item">
                    <div class="c-step-num">4</div>
                    <div class="c-step-text"><strong>결과 발표</strong><span>심사 결과를 공지하고 당첨자에게 개별 통보합니다.</span></div>
                  </div>
                </div>
              </div>
            </div>
            <div class="c-card c-card--divide">
              <div class="c-card__header"><div class="c-card__title">제출 서류 안내</div></div>
              <div class="c-card__body">
                <div class="doc-list">
                  <div class="doc-item"><span class="material-symbols-rounded doc-icon">check_circle</span>신분증 사본</div>
                  <div class="doc-item"><span class="material-symbols-rounded doc-icon">check_circle</span>주민등록등본</div>
                  <div class="doc-item"><span class="material-symbols-rounded doc-icon">check_circle</span>가족관계증명서</div>
                  <div class="doc-item"><span class="material-symbols-rounded doc-icon">check_circle</span>소득증명서</div>
                  <div class="doc-item"><span class="material-symbols-rounded doc-icon">check_circle</span>근로소득원천징수영수증</div>
                </div>
                <div style="font-size: 12px; color: var(--text-tertiary); margin-top: 16px; padding-top: 14px; border-top: 1px solid var(--border)">
                  ※ 제출 서류는 단지별로 상이할 수 있으며, 공고 내용을 반드시 확인해 주세요.
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="detail-modal" onclick="closeOutside(event)">
      <div class="c-modal">
        <div class="c-modal__header">
          <h4 class="c-modal__title">공고 상세 정보</h4>
          <button class="c-modal__close" onclick="closeModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body" id="modal-content"></div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--danger" onclick="deleteFromModal()">삭제</button>
          <button class="c-btn" onclick="editFromModal()">수정</button>
          <button class="c-btn c-btn--ghost" onclick="closeModal()">닫기</button>
        </div>
      </div>
    </div>

    <script id="page-script">
      const TODAY = new Date("2026-04-22");
      function calcStatus(start, end) {
        const s = new Date(start), e = new Date(end);
        if (TODAY < s) return "예정";
        if (TODAY > e) return "마감";
        return "진행중";
      }
      function badgeHtml(status) {
        const map = { 진행중: "c-badge--active", 마감: "c-badge--neutral", 예정: "c-badge--pending" };
        return '<span class="c-badge ' + (map[status] || "") + '">' + status + '</span>';
      }

      let posts = [];
      const sites = ["강남 센트럴", "한강 리버뷰", "자이 아파트"];
      for (let i = 1; i <= 24; i++) {
        const m = ((i * 2) % 6) + 1;
        const d = ((i * 5) % 25) + 1;
        const start = "2026-0" + m + "-" + String(d).padStart(2, "0");
        const endM = m + (i % 2);
        const end = "2026-0" + endM + "-" + String(((d + 14) % 28) + 1).padStart(2, "0");
        posts.push({
          id: i,
          title: ["입주자 모집 공고", "특별 공급 공고", "재모집 공고", "신규 분양 공고"][i % 4] + " #" + i,
          site: sites[i % sites.length],
          start, end,
          units: 50 + (i * 17) % 200,
          docs: ["신분증 사본·주민등록등본", "소득증명서·주민등록등본", "계약서·신분증 사본"][i % 3],
        });
      }
      let nextId = posts.length + 1;
      let editId = null;
      const PAGE_SIZE = 10;
      let currentPage = 1;
      let filtered = posts.slice();

      function renderList() {
        const tbody = document.getElementById("list-body");
        const start = (currentPage - 1) * PAGE_SIZE;
        const slice = filtered.slice(start, start + PAGE_SIZE);
        if (slice.length === 0) {
          tbody.innerHTML = '<tr><td colspan="6"><div class="c-empty"><div class="c-empty__title">조회된 공고가 없습니다</div><div class="c-empty__sub">다른 조건으로 검색해보세요.</div></div></td></tr>';
        } else {
          tbody.innerHTML = slice.map((p) => {
            const st = calcStatus(p.start, p.end);
            return '<tr style="cursor:pointer" onclick="openDetail(' + p.id + ')">'
              + '<td style="font-weight:600">' + p.title + '</td>'
              + '<td>' + p.site + '</td>'
              + '<td style="color:var(--text-secondary)">' + p.start + ' ~ ' + p.end + '</td>'
              + '<td>' + p.units + '세대</td>'
              + '<td style="color:var(--text-secondary); font-size: 12px">' + p.docs + '</td>'
              + '<td>' + badgeHtml(st) + '</td>'
              + '</tr>';
          }).join("");
        }
        document.getElementById("list-count").textContent = filtered.length;
        renderPagination();
      }

      function renderPagination() {
        const el = document.getElementById("pagination");
        const last = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE));
        if (last <= 1) { el.innerHTML = ""; return; }
        const btn = (label, page, opts) => {
          const cls = ["c-pagination__btn"];
          if (opts && opts.active) cls.push("is-active");
          if (opts && opts.disabled) cls.push("is-disabled");
          return '<button class="' + cls.join(" ") + '" data-page="' + page + '">' + label + '</button>';
        };
        let html = "";
        html += btn('<span class="material-symbols-rounded">chevron_left</span>', currentPage - 1, { disabled: currentPage === 1 });
        for (let i = 1; i <= last; i++) html += btn(i, i, { active: i === currentPage });
        html += btn('<span class="material-symbols-rounded">chevron_right</span>', currentPage + 1, { disabled: currentPage === last });
        el.innerHTML = html;
        el.querySelectorAll(".c-pagination__btn").forEach((b) => {
          b.addEventListener("click", () => {
            if (b.classList.contains("is-disabled") || b.classList.contains("is-active")) return;
            currentPage = Number(b.dataset.page);
            renderList();
          });
        });
      }

      function doFilter() {
        const title = document.getElementById("f-title").value.trim().toLowerCase();
        const site = document.getElementById("f-site").value;
        const from = document.getElementById("f-from").value;
        const to = document.getElementById("f-to").value;
        const stat = document.getElementById("f-status").value;
        filtered = posts.filter((p) => {
          if (title && !p.title.toLowerCase().includes(title)) return false;
          if (site && p.site !== site) return false;
          if (from && p.start < from) return false;
          if (to && p.end > to) return false;
          if (stat && calcStatus(p.start, p.end) !== stat) return false;
          return true;
        });
        currentPage = 1;
        renderList();
      }
      function resetFilter() {
        ["f-title", "f-from", "f-to"].forEach((id) => (document.getElementById(id).value = ""));
        ["f-site", "f-status"].forEach((id) => (document.getElementById(id).value = ""));
        filtered = posts.slice();
        currentPage = 1;
        renderList();
      }
      function deletePost(id) {
        if (!confirm("해당 공고를 삭제하시겠습니까?")) return;
        posts = posts.filter((p) => p.id !== id);
        doFilter();
      }
      let openedId = null;
      function openDetail(id) {
        openedId = id;
        const p = posts.find((x) => x.id === id);
        if (!p) return;
        const st = calcStatus(p.start, p.end);
        document.getElementById("modal-content").innerHTML = ''
          + '<div style="display: grid; grid-template-columns: 110px 1fr; gap: 10px 14px; font-size: 13px">'
          + '<div style="font-weight:700;color:var(--text-secondary)">공고 제목</div><div>' + p.title + '</div>'
          + '<div style="font-weight:700;color:var(--text-secondary)">단지</div><div>' + p.site + '</div>'
          + '<div style="font-weight:700;color:var(--text-secondary)">모집 기간</div><div>' + p.start + ' ~ ' + p.end + '</div>'
          + '<div style="font-weight:700;color:var(--text-secondary)">공급 세대수</div><div>' + p.units + '세대</div>'
          + '<div style="font-weight:700;color:var(--text-secondary)">제출 서류</div><div>' + p.docs + '</div>'
          + '<div style="font-weight:700;color:var(--text-secondary)">상태</div><div>' + badgeHtml(st) + '</div>'
          + '</div>';
        document.getElementById("detail-modal").classList.remove("is-hidden");
      }
      function closeModal() { document.getElementById("detail-modal").classList.add("is-hidden"); openedId = null; }
      function closeOutside(e) { if (e.target === document.getElementById("detail-modal")) closeModal(); }
      function deleteFromModal() { if (openedId !== null) { closeModal(); deletePost(openedId); } }
      function editFromModal() { if (openedId !== null) { closeModal(); openEdit(openedId); } }

      function openRegister() {
        editId = null; clearForm();
        document.getElementById("form-title").textContent = "입주자 모집 공고 등록";
        document.getElementById("form-submit-btn").innerHTML = '<span class="material-symbols-rounded">check</span>등록';
        switchTab(1, document.querySelectorAll(".c-tab-btn")[1]);
      }
      function openEdit(id) {
        const p = posts.find((x) => x.id === id);
        if (!p) return;
        editId = id; clearForm();
        document.getElementById("f-ftitle").value = p.title;
        document.getElementById("f-fsite").value = p.site;
        document.getElementById("f-fstart").value = p.start;
        document.getElementById("f-fend").value = p.end;
        document.getElementById("f-funit").value = p.units;
        const rawDocs = p.docs.split("·");
        document.querySelectorAll("input[name='docs']").forEach((cb) => {
          cb.checked = rawDocs.includes(cb.value);
        });
        document.getElementById("form-title").textContent = "입주자 모집 공고 수정";
        document.getElementById("form-submit-btn").innerHTML = '<span class="material-symbols-rounded">check</span>수정';
        switchTab(1, document.querySelectorAll(".c-tab-btn")[1]);
      }
      function clearForm() {
        ["f-ftitle", "f-fstart", "f-fend", "f-funit", "f-fsite"].forEach((id) => (document.getElementById(id).value = ""));
        document.querySelectorAll("input[name='docs']").forEach((cb) => (cb.checked = false));
        ["e-ftitle", "e-fsite", "e-fdate", "e-funit"].forEach((id) => (document.getElementById(id).textContent = ""));
        ["f-ftitle", "f-fsite", "f-fstart", "f-fend", "f-funit"].forEach((id) => document.getElementById(id).classList.remove("is-error"));
      }
      function submitForm() {
        let valid = true;
        const title = document.getElementById("f-ftitle").value.trim();
        const site = document.getElementById("f-fsite").value;
        const start = document.getElementById("f-fstart").value;
        const end = document.getElementById("f-fend").value;
        const units = document.getElementById("f-funit").value;
        const docs = Array.from(document.querySelectorAll("input[name='docs']:checked")).map((c) => c.value).join("·") || "—";

        const setErr = (field, msgEl, msg) => {
          document.getElementById(field).classList.add("is-error");
          document.getElementById(msgEl).textContent = msg;
          valid = false;
        };
        const clearErr = (field, msgEl) => {
          document.getElementById(field).classList.remove("is-error");
          document.getElementById(msgEl).textContent = "";
        };

        title ? clearErr("f-ftitle", "e-ftitle") : setErr("f-ftitle", "e-ftitle", "공고 제목을 입력하세요.");
        site ? clearErr("f-fsite", "e-fsite") : setErr("f-fsite", "e-fsite", "단지를 선택하세요.");
        (units && units >= 1) ? clearErr("f-funit", "e-funit") : setErr("f-funit", "e-funit", "세대수를 입력하세요.");

        if (!start || !end) { document.getElementById("e-fdate").textContent = "기간을 모두 입력하세요."; valid = false; }
        else if (end < start) { document.getElementById("e-fdate").textContent = "종료일은 시작일 이후여야 합니다."; valid = false; }
        else { document.getElementById("e-fdate").textContent = ""; }

        if (!valid) return;

        if (editId) {
          const p = posts.find((x) => x.id === editId);
          Object.assign(p, { title, site, start, end, units: +units, docs });
        } else {
          posts.unshift({ id: nextId++, title, site, start, end, units: +units, docs });
        }
        filtered = posts.slice();
        currentPage = 1;
        renderList();
        switchTab(0, document.querySelectorAll(".c-tab-btn")[0]);
      }

      function switchTab(idx, btn) {
        document.querySelectorAll(".c-tab-btn").forEach((b) => b.classList.remove("is-active"));
        document.querySelectorAll(".tab-panel").forEach((p) => p.classList.remove("is-active"));
        btn.classList.add("is-active");
        document.getElementById("tab" + idx).classList.add("is-active");
      }

      renderList();
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
