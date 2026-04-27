<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="true"%>
<!doctype html>
<html lang="ko">
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
            <button class="c-btn c-btn--primary" onclick="openModal()">
              <span class="material-symbols-rounded">person_add</span>신규 계정 생성
            </button>
          </div>
        </div>

        <!-- 권한 레벨 안내 (접기/펼치기) -->
        <div class="c-card c-card--divide" style="margin-bottom: 16px">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">권한 레벨 안내</div>
              <div class="c-card__sub">가이드는 참고용입니다. 신규 계정 생성 시 기본 권한을 선택할 수 있습니다.</div>
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

        <!-- 계정 목록 -->
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">계정 목록 및 활성화</div>
              <div class="c-card__sub" id="acctSubtitle">총 0건 / 1 페이지</div>
            </div>
            <div class="c-card__actions">
              <input type="search" class="c-input" placeholder="이름·아이디·단지 검색" style="width: 200px" oninput="searchAccounts(this.value)" />
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

    <!-- 신규 계정 생성 모달 -->
    <div class="c-modal-overlay is-hidden" id="modalOverlay" onclick="closeModalOutside(event)">
      <div class="c-modal">
        <div class="c-modal__header">
          <div>
            <h4 class="c-modal__title">신규 계정 생성</h4>
            <p style="font-size: 12px; color: var(--text-tertiary); margin-top: 3px">계정을 생성하고 담당 단지에 즉시 매핑합니다.</p>
          </div>
          <button class="c-modal__close" onclick="closeModal()" aria-label="닫기"><span class="material-symbols-rounded">close</span></button>
        </div>
        <div class="c-modal__body">
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px;">
            <div class="c-field">
              <label class="c-label">관리자 이름 <span class="req">*</span></label>
              <input class="c-input" type="text" placeholder="성명 입력" />
            </div>
            <div class="c-field">
              <label class="c-label">접속 아이디 <span class="req">*</span></label>
              <input class="c-input" type="text" placeholder="6자 이상 영문·숫자" />
            </div>
            <div class="c-field">
              <label class="c-label">임시 비밀번호 <span class="req">*</span></label>
              <input class="c-input" type="password" placeholder="초기 비밀번호" />
            </div>
            <div class="c-field">
              <label class="c-label">연락처</label>
              <input class="c-input" type="text" placeholder="010-0000-0000" />
            </div>
            <div class="c-field">
              <label class="c-label">소속 단지 <span class="req">*</span></label>
              <select class="c-select">
                <option value="">단지 선택</option>
                <option>A단지 · 행복아파트</option>
                <option>B단지 · 희망빌라</option>
                <option>C단지 · 미래아파트</option>
                <option>D단지 · 푸른마을</option>
              </select>
            </div>
            <div class="c-field">
              <label class="c-label">권한 레벨 <span class="req">*</span></label>
              <select class="c-select" id="roleSelect"></select>
            </div>
          </div>
        </div>
        <div class="c-modal__footer">
          <button class="c-btn c-btn--ghost" onclick="closeModal()">취소</button>
          <button class="c-btn c-btn--primary"><span class="material-symbols-rounded">person_add</span>계정 생성</button>
        </div>
      </div>
    </div>

    <script>
      const PAGE_SIZE=10;
      const ROLES=[
        {key:"관리소장",level:4,color:"blue",icon:"shield_person",title:"관리소장",desc:"단지 내 최상위 권한. 모든 메뉴 접근 가능",perms:[{ok:1,text:"전체 메뉴 열람·편집"},{ok:1,text:"계약·재무 처리"},{ok:1,text:"민원·공고 승인"}]},
        {key:"회계",level:3,color:"yellow",icon:"account_balance",title:"회계",desc:"재무 데이터 전담. 수납·정산 권한",perms:[{ok:1,text:"계약·재무 전체"},{ok:1,text:"수납 내역 수정"},{ok:0,text:"민원·시설 불가"}]},
        {key:"행정",level:2,color:"green",icon:"edit_document",title:"행정",desc:"입주민 소통 전담. 민원·공고 처리",perms:[{ok:1,text:"입주민 관리 열람"},{ok:1,text:"민원·공고 처리"},{ok:0,text:"재무 접근 불가"}]},
        {key:"시설",level:1,color:"orange",icon:"handyman",title:"시설",desc:"시설 점검 전담. 최소 접근 권한",perms:[{ok:1,text:"시설 민원·점검"},{ok:1,text:"점검 일지 작성"},{ok:0,text:"재무·계약 불가"}]},
      ];
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
        grid.innerHTML = ROLES.map((r) => `
          <div class="role-card">
            <div class="role-card__top">
              <div class="role-card__icon" style="background: ${ROLE_BG[r.color]}">
                <span class="material-symbols-rounded" style="color: ${ROLE_FG[r.color]}">${r.icon}</span>
              </div>
              <span class="role-card__lv" style="background: ${ROLE_BG[r.color]}; color: ${ROLE_FG[r.color]}">Lv.${r.level}</span>
            </div>
            <div class="role-card__title">${r.title}</div>
            <div class="role-card__desc">${r.desc}</div>
            <div class="role-card__perms">
              ${r.perms.map(p => `
                <div class="role-card__perm ${p.ok ? "yes" : "no"}">
                  <span class="material-symbols-rounded">${p.ok ? "check_circle" : "remove_circle"}</span>${p.text}
                </div>
              `).join("")}
            </div>
          </div>
        `).join("");
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
          roleSelect.innerHTML = ROLES.map(r => `<option value="${r.key}">${r.title} (Lv.${r.level})</option>`).join("");
          roleSelect.addEventListener("change", () => setDefaultRole(roleSelect.value));
        }

        const roleFilter = document.getElementById("roleFilter");
        if (roleFilter) {
          const first = roleFilter.querySelector("option[value='']") ? "" : `<option value="">전체 권한</option>`;
          roleFilter.innerHTML = first + ROLES.map(r => `<option value="${r.key}">${r.title}</option>`).join("");
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

      initRoleSelects();
      setDefaultRole(ROLES[0].key);
      renderRoleGuide();
      renderAccounts();
    </script>
    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>
  </body>
</html>
