<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%> <%@ taglib prefix="c" uri="jakarta.tags.core"%> <%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!doctype html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
    <title>우리집맵핑 · 서식 관리</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralAside.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralHeader.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralCommon.css" />
    <script defer src="${pageContext.request.contextPath}/js/centralAside.js"></script>
    <script defer src="${pageContext.request.contextPath}/js/centralHeader.js"></script>
    <style>
      .doc-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 5px 10px;
        border-radius: 999px;
        background: var(--gray-soft);
        border: 1px solid var(--border);
        font-size: 12px;
        font-weight: 700;
        color: var(--text-secondary);
        white-space: nowrap;
      }
      .doc-chip.is-blue {
        background: var(--blue-bg);
        border-color: rgba(59, 130, 246, 0.25);
        color: #1d4ed8;
      }
      .doc-chip.is-green {
        background: var(--green-bg);
        border-color: rgba(22, 163, 74, 0.25);
        color: #15803d;
      }
      .doc-chip.is-orange {
        background: var(--orange-bg);
        border-color: rgba(249, 115, 22, 0.25);
        color: #c2410c;
      }

      .doc-actions {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 8px;
        flex-wrap: wrap;
      }

      .doc-preview {
        border: 1px solid var(--border);
        border-radius: var(--r-md);
        background: #fff;
        overflow: hidden;
        height: 520px;
      }
      .doc-preview iframe {
        width: 100%;
        height: 100%;
        border: 0;
        background: #fff;
      }

      .c-modal__body .form-err {
        display: block;
        margin-top: 6px;
        color: var(--red);
        font-size: 12px;
      }
      .is-hidden {
        display: none !important;
      }

      .file-fname {
        font-size: 12px;
        color: var(--text-tertiary);
        margin-left: 10px;
      }
    </style>
  </head>
  <body>
    <%-- ================================================================ SIDEBAR ================================================================ --%>
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
          <a class="nav-item"><span class="material-symbols-rounded nav-icon">grid_view</span><span class="nav-text">대시보드</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">건물 · 입주민</span>
          <a href="${pageContext.request.contextPath}/centralAdmin/buildSearch" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/buildRegister" class="nav-item"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/residentList" class="nav-item"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a href="${pageContext.request.contextPath}/centralAdmin/contractList.do" class="nav-item"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/contractDoc.do" class="nav-item"><span class="material-symbols-rounded nav-icon">description</span><span class="nav-text">서류 관리</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/contractForm.do" class="nav-item active"><span class="material-symbols-rounded nav-icon">edit_document</span><span class="nav-text">서식 관리</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/statistics" class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a href="${pageContext.request.contextPath}/centralAdmin/civilCom" class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/ai" class="nav-item"><span class="material-symbols-rounded nav-icon                                  ">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/announcement" class="nav-item"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/notice" class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a href="${pageContext.request.contextPath}/centralAdmin/facility" class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
          <a href="${pageContext.request.contextPath}/centralAdmin/subAdmin" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">하위관리자 계정</span></a>
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

    <%-- ================================================================ MAIN ================================================================ --%>
    <div class="main-wrap">
      <div class="topbar">
        <div class="breadcrumb">
          <span class="material-symbols-rounded" style="font-size: 14px">home</span>
          <span style="margin: 0 4px">/</span>
          <span>계약·재무</span>
          <span style="margin: 0 4px">/</span>
          <span class="bc-current">서식 관리</span>
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
        <div class="page-header">
          <div>
            <div class="page-title">서식 관리</div>
            <div class="page-subtitle">계약 진행에 필요한 표준 서식을 업로드·배포·버전 관리합니다.</div>
          </div>
          <div class="page-header__right">
            <button class="c-btn c-btn--primary" onclick="openDocModalForCreate()"><span class="material-symbols-rounded">upload</span>서식 등록</button>
          </div>
        </div>

        <%-- ================================================================ 필터 폼 (conManagement.jsp와 동일 레이아웃) ================================================================ --%>
        <form id="filterForm" method="get" action="${pageContext.request.contextPath}/centralAdmin/contractDoc">
          <input type="hidden" name="page" id="f-page" value="1" />
          <div class="c-card c-card--divide" style="margin-bottom: 16px">
            <div class="c-card__header">
              <div>
                <div class="c-card__title">검색 조건</div>
                <div class="c-card__sub">조건을 입력하면 서식 목록이 필터링됩니다.</div>
              </div>
              <div class="c-card__actions">
                <button type="button" class="c-btn c-btn--ghost" onclick="resetDocFilter()"><span class="material-symbols-rounded">refresh</span>초기화</button>
                <button type="button" class="c-btn c-btn--primary" onclick="applyDocFilter()"><span class="material-symbols-rounded">search</span>검색</button>
              </div>
            </div>
            <div class="c-card__body c-filter-row">
              <div class="c-field" style="min-width: 315px">
                <label class="c-label">서식명</label>
                <input type="text" class="c-input" id="f-doc-name" placeholder="예: 표준 임대차계약서" />
              </div>
              <div class="c-field" style="min-width: 315px">
                <label class="c-label">아파트 단지 명</label>
                <input type="text" class="c-input" id="f-doc-name" placeholder="예: 레미안 아파트" />
              </div>
              <div class="c-field" style="min-width: 315px">
                <label class="c-label">계약 유형</label>
                <select class="c-select" id="f-doc-ext">
                  <option value="">전체</option>
                  <option value="pdf">전세</option>
                  <option value="docx">월세</option>
                </select>
              </div>
            </div>
          </div>
        </form>

        <%-- ================================================================ 테이블 (conManagement.jsp와 동일 레이아웃) ================================================================ --%>
        <div class="c-card c-card--divide">
          <div class="c-card__header">
            <div>
              <div class="c-card__title">서식 목록</div>
              <div class="c-card__sub">총 <span style="color: var(--accent); font-weight: 800" id="docTotalCount">0</span>건</div>
            </div>
          </div>
          <div class="c-table-wrap">
            <table class="c-table" id="docTable">
              <thead>
                <tr>
                  <th style="width: 80px">서식번호</th>
                  <th style="width: 120px">서식명</th>
                  <th style="width: 150px">아파트 단지 명</th>
                  <th style="width: 120px">계약 유형</th>
                  <th style="width: 100px">등록일</th>
                  <th style="width: 100px">등록자</th>
                  <th style="width: 80px">관리</th>
                </tr>
              </thead>
              <tbody id="docTbody">
                <tr id="docEmptyRow">
                  <td colspan="7">
                    <div class="c-empty">
                      <div class="c-empty__title">등록된 서식이 없습니다</div>
                      <div class="c-empty__sub">우측 상단의 “서식 등록” 버튼으로 첫 서식을 추가해보세요.</div>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="c-card__footer" style="justify-content: center">
            <div class="c-pagination">
              <button type="button" class="c-pagination__btn is-disabled"><span class="material-symbols-rounded">chevron_left</span></button>
              <button type="button" class="c-pagination__btn is-active">1</button>
              <button type="button" class="c-pagination__btn is-disabled"><span class="material-symbols-rounded">chevron_right</span></button>
            </div>
          </div>
        </div>
      </div>
    </div>

    <%-- ================================================================ 서식 등록/수정 모달 (프론트 데모) TODO: 백엔드 연동 시 form action을 업로드/수정 컨트롤러로 교체 ================================================================ --%>
    <div class="c-modal-overlay is-hidden" id="docModalOverlay" onclick="if (event.target === this) closeDocModal();">
      <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">
        <div class="c-modal__header">
          <h3 class="c-modal__title" id="docModalTitle">서식 등록</h3>
          <button class="c-modal__close" onclick="closeDocModal()" aria-label="닫기">
            <span class="material-symbols-rounded">close</span>
          </button>
        </div>

        <div class="c-modal__body">
          <form
            id="docForm"
            onsubmit="
              event.preventDefault();
              submitDocForm();
            ">
            <input type="hidden" id="docId" value="" />

            <div style="display: flex; flex-direction: column; gap: 16px">
              <div class="c-card c-card--divide">
                <div class="c-card__header"><div class="c-card__title">기본 정보</div></div>
                <div class="c-card__body">
                  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 14px">
                    <div class="c-field">
                      <label class="c-label">구분 <span class="req">*</span></label>
                      <select id="d-cat" class="c-select">
                        <option value="">선택</option>
                        <option value="계약서"></option>
                        <option value="확인서/동의서">확인서/동의서</option>
                        <option value="안내문">안내문</option>
                        <option value="기타">기타</option>
                      </select>
                      <span class="form-err" id="err-d-cat"></span>
                    </div>
                    <div class="c-field">
                      <label class="c-label">서식명 <span class="req">*</span></label>
                      <input type="text" id="d-name" class="c-input" placeholder="예: 표준 임대차계약서" />
                      <span class="form-err" id="err-d-name"></span>
                    </div>
                    <div class="c-field" style="grid-column: 1 / span 2">
                      <label class="c-label">설명</label>
                      <textarea id="d-desc" class="c-input" style="min-height: 90px; resize: vertical" placeholder="서식 사용처/주의사항 등을 간단히 기록하세요."></textarea>
                    </div>
                  </div>
                </div>
              </div>

              <div class="c-card c-card--divide">
                <div class="c-card__header">
                  <div class="c-card__title">파일 업로드 <span style="font-size: 12px; font-weight: 600; color: var(--text-tertiary)">(선택)</span></div>
                </div>
                <div class="c-card__body">
                  <div class="file-upload-row">
                    <label class="c-label" style="width: 90px; flex-shrink: 0">서식 파일</label>
                    <label class="file-label">
                      <input type="file" id="d-file" accept=".pdf,.doc,.docx,.hwp,.xlsx" onchange="showDocFileName(this)" />
                      <span class="material-symbols-rounded" style="font-size: 16px; margin-right: 5px">upload</span>파일 선택
                    </label>
                    <span class="file-fname" id="d-fname">선택된 파일 없음</span>
                  </div>
                  <div style="margin-top: 10px; font-size: 12px; color: var(--text-tertiary)">
                    - PDF는 미리보기가 가능합니다. docx/hwp/xlsx는 다운로드로 확인합니다.<br />
                    - 실제 저장/배포를 위해서는 서버 업로드 API 연동이 필요합니다. (현재 화면은 프론트 데모)
                  </div>
                </div>
              </div>
            </div>
          </form>
        </div>

        <div class="c-modal__footer">
          <button type="button" class="c-btn c-btn--ghost" onclick="closeDocModal()">닫기</button>
          <button type="button" class="c-btn c-btn--primary" onclick="submitDocForm()" id="docSubmitBtn"><span class="material-symbols-rounded">check</span>등록</button>
        </div>
      </div>
    </div>
    <script>
      function goPage(page) {
        var max = parseInt('${pagingVO.totalPage}') || 1;
        if (page < 1 || page > max) return;
        document.getElementById('f-page').value = page;
        document.getElementById('filterForm').submit();
      }

      function resetFilter() {
        var form = document.getElementById('filterForm');
        form.querySelectorAll('input[type=text]').forEach(function(el){ el.value=''; });
        form.querySelectorAll('select').forEach(function(el){ el.value=''; });
        document.getElementById('f-page').value = '1';
        form.submit();
      }

      function openRegisterModal() {
        resetRegisterFormForInsert();
        document.getElementById('c-modal-overlay').classList.remove('is-hidden');
      }

      function closeRegisterModal() {
        document.getElementById('c-modal-overlay').classList.add('is-hidden');
      }

      /* 사이드바 */
      function toggleSidebar() {
        var s = document.getElementById("sidebar");
        if (s) s.classList.toggle("collapsed");
      }
      var logoIcon = document.getElementById("logoIcon");
      if (logoIcon) {
        logoIcon.addEventListener("click", function () {
          var s = document.getElementById("sidebar");
          if (s && s.classList.contains("collapsed")) toggleSidebar();
        });
      }

      function resetRegisterFormForInsert() {
        var form = document.getElementById('registerForm');
        form.action = CTX + '/centralAdmin/contractInsert.do';
        document.getElementById('registerModalTitle').textContent = '계약 등록';
        document.getElementById('registerSubmitBtn').innerHTML =
                '<span class="material-symbols-rounded">check</span>계약 등록';
        var hid = document.getElementById('reg-rent-ctrt-no');
        if (hid) {
          hid.removeAttribute('name');
          hid.value = '';
        }
        document.getElementById('r-user').value = '';
        document.getElementById('r-apt').value = '';
        document.getElementById('r-type').value = '';
        document.getElementById('r-ctrt-amt').value = '';
        document.getElementById('r-dpst-amt').value = '';
        document.getElementById('r-start').value = '';
        document.getElementById('r-end').value = '';
        document.querySelectorAll('#registerForm input[type="file"]').forEach(function(inp) { inp.value = ''; });
        document.getElementById('fname1').textContent = '선택된 파일 없음';
        document.getElementById('fname2').textContent = '선택된 파일 없음';
        document.getElementById('fname3').textContent = '선택된 파일 없음';
        document.getElementById('fname1').style.color = 'var(--text-tertiary)';
        document.getElementById('fname2').style.color = 'var(--text-tertiary)';
        document.getElementById('fname3').style.color = 'var(--text-tertiary)';
        ['err-user', 'err-apt', 'err-type', 'err-date'].forEach(function(id) {
          var e = document.getElementById(id);
          if (e) e.textContent = '';
        });
      }
      // 초기 렌더
      renderDocTable();
    </script>
  </body>
</html>
