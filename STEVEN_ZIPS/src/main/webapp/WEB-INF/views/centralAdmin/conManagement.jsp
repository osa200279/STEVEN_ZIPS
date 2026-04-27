<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 계약 관리</title>
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
      /* conManagement.jsp 전용 */
      /* c-so-overlay, c-slideover, c-so__head, c-so__body, c-so__footer, c-so__section-title → centralCommon.css 제공 */
      /* c-info-grid, c-info-block → centralCommon.css 제공 */
      .file-row {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px 14px;
        background: var(--gray-soft);
        border-radius: var(--r-sm);
      }
      .file-row + .file-row { margin-top: 6px; }
      .file-name {
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 8px;
        color: var(--text-primary);
      }
      .so-textarea {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid var(--border);
        border-radius: var(--r-sm);
        font-size: 13px;
        font-family: inherit;
        resize: vertical;
        outline: none;
        color: var(--text-primary);
      }
      .so-textarea:focus { border-color: var(--accent); }
      .so-textarea.is-error { border-color: var(--red); }
      .file-upload-row { display: flex; align-items: center; gap: 12px; }
      .file-label {
        display: inline-flex;
        align-items: center;
        height: 34px;
        padding: 0 14px;
        border: 1px solid var(--border);
        border-radius: 8px;
        font-size: 12px;
        font-weight: 600;
        color: var(--text-secondary);
        cursor: pointer;
        background: var(--gray-soft);
        white-space: nowrap;
      }
      .file-label:hover { background: var(--border); }
      .file-label input[type="file"] { display: none; }
      .file-fname { font-size: 12px; color: var(--text-tertiary); }
      .form-err { font-size: 11px; color: var(--red); min-height: 14px; }
      .req { color: var(--red); }
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
        <button class="collapse-btn" onclick="toggleSidebar()" data-tooltip="사이드바 접기">
          <span class="material-symbols-rounded">left_panel_close</span>
        </button>
      </div>
      <nav class="sidebar-nav">
        <div class="nav-group">
          <a class="nav-item" data-page="대시보드" data-parent="대시보드"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="<%= request.getContextPath() %>/conManagement/buildSearch" class="nav-item" data-page="매물 통합 검색" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/buildRegister" class="nav-item" data-page="건물 등록 및 열람" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/residentList" class="nav-item" data-page="입주민 관리" data-parent="건물·입주민"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a href="<%= request.getContextPath() %>/conManagement/contractList.do" class="nav-item active" data-page="계약 관리" data-parent="계약·재무"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/statistics" class="nav-item" data-page="통계" data-parent="계약·재무"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a href="<%= request.getContextPath() %>/conManagement/civilCom" class="nav-item" data-page="민원 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/ai" class="nav-item" data-page="문의 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/announcement" class="nav-item" data-page="공고 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/notice" class="nav-item" data-page="통합 게시판 관리" data-parent="민원·소통"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a href="<%= request.getContextPath() %>/conManagement/facility" class="nav-item" data-page="시설 관리" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/proHistory" class="nav-item" data-page="비정상 세대 관리" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
          <a href="<%= request.getContextPath() %>/conManagement/subAdmin" class="nav-item" data-page="하위관리자 계정" data-parent="시설·시스템"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">하위관리자 계정</span></a>
        </div>
      </nav>
      <div class="admin-card">
        <div class="admin-avatar"><span class="material-symbols-rounded" style="color: #fff; font-size: 18px">person</span></div>
        <div class="admin-info">
          <p>중앙관리자</p>
          <span>클로드 최고</span>
        </div>
        <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink: 0; margin-left: auto">
          <span class="material-symbols-rounded">logout</span>
        </button>
      </div>
    </aside>

    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span id="bc-parent">계약·재무</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current" id="bc-current">계약 관리</span>
        </div>
        <div class="topbar-actions">
          <button class="topbar-icon-btn" data-tooltip="알림">
            <span class="material-symbols-rounded">notifications</span>
            <div class="dot"></div>
          </button>
          <button class="topbar-icon-btn" data-tooltip="설정">
            <span class="material-symbols-rounded">settings</span>
          </button>
        </div>
      </div>

      <div class="main-content" id="page-content">
        <div class="page-header">
          <div>
            <div class="page-title">계약 관리</div>
            <div class="page-subtitle">전·월세 계약 신청을 검토하고 오프라인 계약을 직접 등록합니다.</div>
          </div>
          <div class="page-header__right">
            <button class="c-btn" data-tooltip="목록을 엑셀로 내려받기">
              <span class="material-symbols-rounded">table_view</span>엑셀 출력하기
            </button>
            <button class="c-btn c-btn--primary" onclick="openRegisterModal()">
              <span class="material-symbols-rounded">add</span>계약 등록
            </button>
          </div>
        </div>

        <!-- 필터 -->
        <div class="c-card c-card--divide" style="margin-bottom: 16px">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">검색 조건</div>
              <div class="c-card__sub">조건을 입력하면 계약 목록이 필터링됩니다.</div>
            </div>
            <div class="c-card__actions">
              <button class="c-btn c-btn--ghost" onclick="resetFilter()"><span class="material-symbols-rounded">refresh</span>초기화</button>
              <button class="c-btn c-btn--primary" onclick="filterTable()"><span class="material-symbols-rounded">search</span>검색</button>
            </div>
          </div>
          <div class="c-card__body c-filter-row">
            <div class="c-field" style="min-width: 140px">
              <label class="c-label">계약 유형</label>
              <select class="c-select" id="f-type">
                <option value="">전체 계약</option>
                <option value="전세">전세계약</option>
                <option value="월세">월세계약</option>
              </select>
            </div>
            <div class="c-field" style="min-width: 200px">
              <label class="c-label">회원 ID</label>
              <input type="text" class="c-input" id="f-user" placeholder="회원 ID 검색" />
            </div>
            <div class="c-field" style="min-width: 140px">
              <label class="c-label">상태</label>
              <select class="c-select" id="f-status">
                <option value="">전체 상태</option>
                <option value="승인대기">승인대기</option>
                <option value="승인">승인</option>
                <option value="반려">반려</option>
              </select>
            </div>
          </div>
        </div>

        <!-- 테이블 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">계약 목록</div>
              <div class="c-card__sub">총 <span id="total-count" style="color: var(--accent); font-weight: 800">0</span>건 · 페이지당 10건</div>
            </div>
          </div>
          <div class="c-table-wrap">
            <table class="c-table" id="contract-table">
              <thead>
                <tr>
                  <th>계약번호</th>
                  <th>유형</th>
                  <th>회원 ID</th>
                  <th>아파트</th>
                  <th>계약일</th>
                  <th>상태</th>
                </tr>
              </thead>
              <tbody id="table-body"></tbody>
            </table>
          </div>
          <div class="c-card__footer" style="justify-content: center">
            <div class="c-pagination" id="pagination"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- 계약 등록 모달 -->
    <div class="c-modal-overlay is-hidden" id="registerOverlay" onclick="if(event.target===this)closeRegisterModal()">
      <div class="c-modal c-modal--lg" role="dialog" aria-modal="true" aria-labelledby="reg-title">
        <div class="c-modal__header">
          <h3 class="c-modal__title" id="reg-title">계약 등록</h3>
          <button class="c-modal__close" onclick="closeRegisterModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body">
          <div style="display: flex; flex-direction: column; gap: 16px">
            <div class="c-card c-card--divide">
              <div class="c-card__header"><div class="c-card__title">계약 기본 정보</div></div>
              <div class="c-card__body">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px">
                  <div class="c-field">
                    <label class="c-label">회원 ID <span class="req">*</span></label>
                    <input type="text" id="r-user" class="c-input" placeholder="회원 ID 입력" />
                    <span class="form-err" id="err-user"></span>
                  </div>
                  <div class="c-field">
                    <label class="c-label">아파트 <span class="req">*</span></label>
                    <select id="r-apt" class="c-select">
                      <option value="">아파트 선택</option>
                      <option>레미안 아파트</option>
                      <option>자이 아파트</option>
                      <option>푸르지오 아파트</option>
                    </select>
                    <span class="form-err" id="err-apt"></span>
                  </div>
                  <div class="c-field">
                    <label class="c-label">계약 유형 <span class="req">*</span></label>
                    <select id="r-type" class="c-select">
                      <option value="">선택</option>
                      <option value="전세">전세계약</option>
                      <option value="월세">월세계약</option>
                    </select>
                    <span class="form-err" id="err-type"></span>
                  </div>
                  <div class="c-field">
                    <label class="c-label">계약 상태</label>
                    <input type="text" class="c-input" value="승인대기" disabled style="background: var(--gray-soft); color: var(--text-tertiary); cursor: not-allowed" />
                  </div>
                </div>
              </div>
            </div>

            <div class="c-card c-card--divide">
              <div class="c-card__header"><div class="c-card__title">계약 정보</div></div>
              <div class="c-card__body">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px">
                  <div class="c-field">
                    <label class="c-label">계약 금액</label>
                    <input type="number" id="r-amount" class="c-input" placeholder="원 단위 입력" min="0" />
                  </div>
                  <div class="c-field">
                    <label class="c-label">보증금</label>
                    <input type="number" id="r-deposit" class="c-input" placeholder="원 단위 입력" min="0" />
                  </div>
                  <div class="c-field">
                    <label class="c-label">계약 시작일</label>
                    <input type="date" id="r-start" class="c-input" />
                  </div>
                  <div class="c-field">
                    <label class="c-label">계약 종료일</label>
                    <input type="date" id="r-end" class="c-input" />
                    <span class="form-err" id="err-date"></span>
                  </div>
                </div>
              </div>
            </div>

            <div class="c-card c-card--divide">
              <div class="c-card__header"><div class="c-card__title">계약 서류 업로드</div></div>
              <div class="c-card__body">
                <div style="display: flex; flex-direction: column; gap: 10px">
                  <div class="file-upload-row">
                    <label class="c-label" style="width: 90px; flex-shrink: 0">계약서</label>
                    <label class="file-label">
                      <input type="file" id="r-file1" accept=".pdf,.doc,.docx" onchange="showFileName(this, 'fname1')" />
                      <span class="material-symbols-rounded" style="font-size: 16px; margin-right: 5px">upload</span>파일 선택
                    </label>
                    <span class="file-fname" id="fname1">선택된 파일 없음</span>
                  </div>
                  <div class="file-upload-row">
                    <label class="c-label" style="width: 90px; flex-shrink: 0">신분증</label>
                    <label class="file-label">
                      <input type="file" id="r-file2" accept=".pdf,.doc,.docx" onchange="showFileName(this, 'fname2')" />
                      <span class="material-symbols-rounded" style="font-size: 16px; margin-right: 5px">upload</span>파일 선택
                    </label>
                    <span class="file-fname" id="fname2">선택된 파일 없음</span>
                  </div>
                  <div class="file-upload-row">
                    <label class="c-label" style="width: 90px; flex-shrink: 0">추가 서류</label>
                    <label class="file-label">
                      <input type="file" id="r-file3" accept=".pdf,.doc,.docx" onchange="showFileName(this, 'fname3')" />
                      <span class="material-symbols-rounded" style="font-size: 16px; margin-right: 5px">upload</span>파일 선택
                    </label>
                    <span class="file-fname" id="fname3">선택된 파일 없음</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="c-modal__footer" style="justify-content: flex-end">
          <button class="c-btn c-btn--ghost" onclick="closeRegisterModal()">닫기</button>
          <button class="c-btn c-btn--primary" onclick="submitRegister()"><span class="material-symbols-rounded">check</span>계약 등록</button>
        </div>
      </div>
    </div>

    <!-- 계약 상세 모달 -->
    <div class="c-modal-overlay is-hidden" id="overlay" onclick="if(event.target===this)closePanel()">
      <div class="c-modal c-modal--lg" role="dialog" aria-modal="true" aria-labelledby="so-title">
        <div class="c-modal__header">
          <h3 class="c-modal__title" id="so-title">계약 상세</h3>
          <button class="c-modal__close" onclick="closePanel()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body">
          <div>
            <div class="c-so__section-title">계약 정보</div>
            <div class="c-info-grid" id="so-info"></div>
          </div>
          <div style="margin-top: 14px">
            <div class="c-so__section-title">첨부 서류</div>
            <div id="so-files"></div>
          </div>
          <div id="so-reject-section" style="margin-top: 14px">
            <div class="c-so__section-title">반려 사유</div>
            <textarea class="c-textarea" id="so-reason" rows="3" placeholder="반려 시 사유를 입력하세요"></textarea>
          </div>
        </div>
        <div class="c-modal__footer" id="so-footer"></div>
      </div>
    </div>

    <script id="page-script">
      const CONTRACTS = [];
      const APTS = ["레미안 아파트", "자이 아파트", "푸르지오 아파트", "힐스테이트", "롯데캐슬"];
      const TYPES = ["전세", "월세"];
      const STATUSES = ["승인대기", "승인", "승인", "반려", "승인"];
      for (let i = 1; i <= 38; i++) {
        const t = TYPES[i % 2];
        const s = STATUSES[i % STATUSES.length];
        const a = APTS[i % APTS.length];
        CONTRACTS.push({
          id: "CTR-" + String(i).padStart(3, "0"),
          type: t,
          user: "user" + (100 + i),
          apt: a,
          date: "2026-0" + (((i - 1) % 4) + 1) + "-" + String(((i * 3) % 27) + 1).padStart(2, "0"),
          status: s,
          amount: t === "전세" ? "3억 " + ((i * 1300) % 9000) + "만원" : "월 " + (60 + (i % 40)) + "만원",
          deposit: t === "전세" ? "3억 " + ((i * 1300) % 9000) + "만원" : (1000 + i * 300) + "만원",
          start: "2026-05-01",
          end: "2028-04-30",
          files: ["계약서.pdf", "신분증.pdf", "등기부등본.pdf"],
        });
      }

      const STATUS_BADGE = { 승인대기: "c-badge--pending", 승인: "c-badge--active", 반려: "c-badge--danger" };

      let currentIdx = null;
      const PAGE_SIZE = 10;
      let currentPage = 1;
      let filtered = CONTRACTS.slice();

      function renderTable() {
        const tbody = document.getElementById("table-body");
        const start = (currentPage - 1) * PAGE_SIZE;
        const slice = filtered.slice(start, start + PAGE_SIZE);
        if (slice.length === 0) {
          tbody.innerHTML = '<tr><td colspan="6"><div class="c-empty"><div class="c-empty__title">조회된 계약이 없습니다</div><div class="c-empty__sub">조건을 변경하여 다시 검색해주세요.</div></div></td></tr>';
        } else {
          tbody.innerHTML = slice
            .map((c) => {
              const idx = CONTRACTS.indexOf(c);
              return '<tr style="cursor:pointer" onclick="openPanel(' + idx + ')"><td style="font-weight:700">' + c.id + '</td>'
                + '<td>' + c.type + '계약</td>'
                + '<td>' + c.user + '</td>'
                + '<td>' + c.apt + '</td>'
                + '<td style="color: var(--text-secondary)">' + c.date + '</td>'
                + '<td><span class="c-badge ' + STATUS_BADGE[c.status] + '">' + c.status + '</span></td></tr>';
            })
            .join("");
        }
        document.getElementById("total-count").textContent = filtered.length;
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
            renderTable();
          });
        });
      }

      function filterTable() {
        const type = document.getElementById("f-type").value;
        const user = document.getElementById("f-user").value.trim().toLowerCase();
        const status = document.getElementById("f-status").value;
        filtered = CONTRACTS.filter((c) => (!type || c.type === type) && (!user || c.user.toLowerCase().includes(user)) && (!status || c.status === status));
        currentPage = 1;
        renderTable();
      }

      function resetFilter() {
        document.getElementById("f-type").value = "";
        document.getElementById("f-user").value = "";
        document.getElementById("f-status").value = "";
        filtered = CONTRACTS.slice();
        currentPage = 1;
        renderTable();
      }

      function openPanel(idx) {
        currentIdx = idx;
        const c = CONTRACTS[idx];
        document.getElementById("so-reason").value = "";
        document.getElementById("so-reason").classList.remove("is-error");

        document.getElementById("so-info").innerHTML = [
          ["계약번호", c.id],
          ["계약 유형", c.type + "계약"],
          ["회원 ID", c.user],
          ["아파트", c.apt],
          ["계약 금액", c.amount],
          ["보증금", c.deposit],
          ["계약 기간", c.start + " ~ " + c.end],
          ["현재 상태", '<span class="c-badge ' + STATUS_BADGE[c.status] + '">' + c.status + '</span>'],
        ]
          .map((row) => '<div class="c-info-block"><div class="c-info-field__label">' + row[0] + '</div><div class="c-info-field__val">' + row[1] + '</div></div>')
          .join("");

        document.getElementById("so-files").innerHTML = c.files
          .map((f) => '<div class="file-row"><span class="file-name"><span class="material-symbols-rounded" style="font-size:18px;color:var(--text-tertiary)">description</span>' + f + '</span><button class="c-btn c-btn--ghost c-btn--sm" onclick="alert(\'파일 보기: ' + f + '\')">보기</button></div>')
          .join("");

        document.getElementById("so-reject-section").style.display = c.status === "승인" ? "none" : "";

        const footer = document.getElementById("so-footer");
        footer.innerHTML = c.status === "승인대기"
          ? '<button class="c-btn c-btn--danger" onclick="doReject()"><span class="material-symbols-rounded">close</span>반려</button><button class="c-btn c-btn--primary" onclick="doApprove()"><span class="material-symbols-rounded">check</span>승인</button>'
          : '<button class="c-btn c-btn--ghost" onclick="closePanel()" style="flex:1">닫기</button>';

        document.getElementById("overlay").classList.remove("is-hidden");
      }

      function closePanel() {
        document.getElementById("overlay").classList.add("is-hidden");
      }

      function doApprove() {
        if (!confirm("승인하시겠습니까?")) return;
        CONTRACTS[currentIdx].status = "승인";
        filterTable();
        closePanel();
      }

      function doReject() {
        const reason = document.getElementById("so-reason").value.trim();
        if (!reason) {
          document.getElementById("so-reason").classList.add("is-error");
          document.getElementById("so-reason").focus();
          return;
        }
        CONTRACTS[currentIdx].status = "반려";
        filterTable();
        closePanel();
      }

      function showFileName(input, targetId) {
        const el = document.getElementById(targetId);
        el.textContent = input.files[0] ? input.files[0].name : "선택된 파일 없음";
        el.style.color = input.files[0] ? "var(--text-primary)" : "var(--text-tertiary)";
      }

      function submitRegister() {
        const user = document.getElementById("r-user").value.trim();
        const apt = document.getElementById("r-apt").value;
        const type = document.getElementById("r-type").value;
        const start = document.getElementById("r-start").value;
        const end = document.getElementById("r-end").value;
        let valid = true;

        const setErr = (id, errId, msg) => {
          const el = document.getElementById(id);
          const err = document.getElementById(errId);
          const empty = !el.value.trim();
          el.style.borderColor = empty ? "var(--red)" : "";
          err.textContent = empty ? msg : "";
          if (empty) valid = false;
        };

        [
          ["r-user", "err-user", "회원 ID를 입력해주세요"],
          ["r-apt", "err-apt", "아파트를 선택해주세요"],
          ["r-type", "err-type", "계약 유형을 선택해주세요"],
        ].forEach((row) => setErr(row[0], row[1], row[2]));

        const errDate = document.getElementById("err-date");
        const endEl = document.getElementById("r-end");
        if (start && end && end < start) {
          endEl.style.borderColor = "var(--red)";
          errDate.textContent = "종료일은 시작일 이후여야 합니다";
          valid = false;
        } else {
          endEl.style.borderColor = "";
          errDate.textContent = "";
        }

        if (!valid) return;

        const newId = "CTR-" + String(CONTRACTS.length + 1).padStart(3, "0");
        const today = new Date().toISOString().slice(0, 10);
        CONTRACTS.unshift({
          id: newId, type, user, apt, date: today, status: "승인대기",
          amount: document.getElementById("r-amount").value ? Number(document.getElementById("r-amount").value).toLocaleString() + "원" : "-",
          deposit: document.getElementById("r-deposit").value ? Number(document.getElementById("r-deposit").value).toLocaleString() + "원" : "-",
          start: start || "-", end: end || "-",
          files: ["계약서.pdf", "신분증.pdf", "추가서류.pdf"],
        });

        ["r-user", "r-apt", "r-type", "r-amount", "r-deposit", "r-start", "r-end"].forEach((id) => (document.getElementById(id).value = ""));
        ["r-file1", "r-file2", "r-file3"].forEach((id, i) => {
          document.getElementById(id).value = "";
          document.getElementById("fname" + (i + 1)).textContent = "선택된 파일 없음";
          document.getElementById("fname" + (i + 1)).style.color = "";
        });

        filterTable();
        alert("계약이 등록되었습니다.");
        closeRegisterModal();
      }
      function openRegisterModal() {
        document.getElementById("registerOverlay").classList.remove("is-hidden");
      }
      function closeRegisterModal() {
        document.getElementById("registerOverlay").classList.add("is-hidden");
      }

      renderTable();
    </script>
    <script>
      /* 사이드바 접기/펴기: .sidebar에 collapsed 클래스 토글 */
      function toggleSidebar() {
        var sidebar = document.getElementById("sidebar");
        if (sidebar) {
          sidebar.classList.toggle("collapsed");
        }
      }
      var logoIcon = document.getElementById("logoIcon");
      if (logoIcon) {
        logoIcon.addEventListener("click", function () {
          var sidebar = document.getElementById("sidebar");
          if (sidebar && sidebar.classList.contains("collapsed")) {
            toggleSidebar();
          }
        });
      }
    </script>
  </body>
</html>
