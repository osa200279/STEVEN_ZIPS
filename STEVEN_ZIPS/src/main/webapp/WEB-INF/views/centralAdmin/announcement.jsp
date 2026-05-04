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
    <%--<script defer src="<%= request.getContextPath() %>/js/centralAside.js"></script>
    <script defer src="<%= request.getContextPath() %>/js/centralHeader.js"></script>--%>
    <style id="page-style">

      /* ================= 제출 서류 목록 ================= */

      .doc-list {
        display: flex;
        flex-direction: column;
        gap: 8px;
      }

      .doc-item {
        display: flex;
        align-items: center;
        gap: 10px;

        padding: 14px 16px;
        border-radius: 12px;

        background: #f3f4f6;
        border: 1px solid #e5e7eb;

        font-size: 14px;
        font-weight: 700;
        color: var(--text-primary);

        box-shadow: 0 1px 2px rgba(0,0,0,0.03);
      }

      .doc-icon {
        font-size: 18px;
        color: #10b981;
      }

      /* ================= 체크박스 그룹 ================= */

      .cb-group {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
      }

      .cb-group label {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 13px;
        cursor: pointer;
      }

      /* ===================================================== */
      /* 스크롤 없는 꽉 채우기 모달 */
      /* ===================================================== */

      .c-modal--notice-form {
        width: 860px;
        max-width: 95vw;

        height: 90vh;              /* 핵심: 화면 높이 기준 고정 */
        display: flex;
        flex-direction: column;    /* header/body/footer 분리 */

        overflow: hidden;          /* 전체 스크롤 제거 */
      }

      /* header */
      .c-modal__header--compact {
        padding: 16px 20px 10px;
        flex-shrink: 0; /* 줄어들지 않게 */
      }

      /* footer */
      .c-modal__footer--compact {
        padding: 10px 20px 14px;
        flex-shrink: 0;
      }

      /* body */
      .c-modal__body--compact {
        padding: 10px 20px;

        flex: 1;                   /* 남은 공간 전부 차지 */
        overflow: hidden;          /* 스크롤 완전 제거 */

        display: flex;
        flex-direction: column;
        gap: 10px;
      }

      /* ================= 2열 레이아웃 ================= */

      .form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 10px 14px;
      }

      /* ================= 필드 압축 ================= */

      .c-modal--notice-form .c-field {
        margin-bottom: 6px;
      }

      .c-modal--notice-form .c-label {
        margin-bottom: 4px;
        font-size: 13px;
      }

      /* input 높이 줄이기 */
      .c-modal--notice-form .c-input,
      .c-modal--notice-form .c-select {
        height: 34px;
        font-size: 13px;
      }

      /* textarea 최소화 */
      .c-modal--notice-form textarea.c-input {
        min-height: 60px;
        max-height: 80px;
        resize: none; /* 드래그 금지 (높이 고정) */
      }

      /* 날짜 */
      .date-row {
        display: flex;
        gap: 6px;
        align-items: center;
      }

      .date-row input {
        flex: 1;
      }

      /* 체크박스 3열 */
      .cb-group--compact {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 6px 10px;
        font-size: 12px;
      }

      /* 에러 메시지 최소화 */
      .c-modal--notice-form .err-msg {
        min-height: 12px;
        font-size: 11px;
        margin-top: 2px;
      }

      /* ================= 반응형 ================= */

      @media (max-width: 768px) {
        .c-modal--notice-form {
          height: 95vh;
        }

        .form-grid {
          grid-template-columns: 1fr;
        }

        .cb-group--compact {
          grid-template-columns: 1fr 1fr;
        }
      }

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
          <a href="<%= request.getContextPath() %>/centralAdmin/buildSearch" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_search</span><span class="nav-text">매물 통합 검색</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/buildRegister" class="nav-item"><span class="material-symbols-rounded nav-icon">apartment</span><span class="nav-text">건물 등록 및 열람</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/residentList" class="nav-item"><span class="material-symbols-rounded nav-icon">groups</span><span class="nav-text">입주민 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">계약 · 재무</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/contractList.do" class="nav-item"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/statistics" class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">민원 · 소통</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/civilCom" class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/ai" class="nav-item"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/announcement" class="nav-item active"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/notice" class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
        </div>
        <div class="section-divider"></div>
        <div class="nav-group">
          <span class="section-label">시설 · 시스템</span>
          <a href="<%= request.getContextPath() %>/centralAdmin/facility" class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
          <a href="<%= request.getContextPath() %>/centralAdmin/mngrRqstAprv" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">단지관리자 계정</span></a>
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

        <!-- 공고 운영 안내 -->
        <div class="c-card c-card--divide" style="margin-top: 16px; margin-bottom: 16px;">

          <div class="c-card__header">
            <div>
              <div class="c-card__title">공고 운영 안내</div>
              <div class="c-card__sub">입주자 모집 공고 등록 후 진행 절차와 주요 제출 서류를 확인합니다.</div>
            </div>
          </div>

          <div class="c-card__body">
            <!-- 핵심: 높이 맞추기 위한 grid -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; align-items: stretch;">

              <!-- ================= 왼쪽 ================= -->
              <div style="display: flex; flex-direction: column; height: 100%;">
                <div style="font-size: 14px; font-weight: 800; margin-bottom: 12px;">
                  입주자 모집 절차
                </div>

                <!-- 핵심: 전체 높이 채우기 -->
                <div style="display: flex; flex-direction: column; gap: 12px; flex: 1;">

                  <div class="c-step-item">
                    <div class="c-step-num">1</div>
                    <div class="c-step-text">
                      <strong>공고 등록</strong>
                      <span>관리자가 모집 공고를 등록하고 신청 기간을 설정합니다.</span>
                    </div>
                  </div>

                  <div class="c-step-item">
                    <div class="c-step-num">2</div>
                    <div class="c-step-text">
                      <strong>신청 접수</strong>
                      <span>신청 기간 내 입주 희망자가 신청서를 제출합니다.</span>
                    </div>
                  </div>

                  <div class="c-step-item">
                    <div class="c-step-num">3</div>
                    <div class="c-step-text">
                      <strong>서류 심사</strong>
                      <span>제출된 서류를 기준으로 자격 요건을 심사합니다.</span>
                    </div>
                  </div>

                  <!-- 마지막 요소를 아래로 밀기 -->
                  <div class="c-step-item">
                    <div class="c-step-num">4</div>
                    <div class="c-step-text">
                      <strong>결과 발표</strong>
                      <span>심사 결과를 공지하고 당첨자에게 개별 통보합니다.</span>
                    </div>
                  </div>

                </div>
              </div>

              <!-- ================= 오른쪽 ================= -->
              <div style="display: flex; flex-direction: column; height: 100%;">
                <div style="font-size: 14px; font-weight: 800; margin-bottom: 6px;">
                  제출 서류 안내
                </div>

                <!-- 안내문 위치 이동 -->
                <div style="font-size: 12px; color: var(--text-tertiary); margin-bottom: 12px;">
                  ※ 제출 서류는 단지별 공고 조건에 따라 달라질 수 있습니다.
                </div>

                <!-- 전체 높이 채우기 -->
                <div style="display: flex; flex-direction: column; justify-content: space-between; flex: 1;">

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    신분증 사본
                  </div>

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    주민등록등본
                  </div>

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    가족관계증명서
                  </div>

                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    소득증명서
                  </div>

                  <!-- 마지막 요소 아래 정렬 -->
                  <div class="doc-item">
                    <span class="material-symbols-rounded doc-icon">check_circle</span>
                    근로소득원천징수영수증
                  </div>

                </div>
              </div>

            </div>
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

        <!-- 공고 등록/수정 모달 -->
        <div class="c-modal-overlay is-hidden" id="form-modal" onclick="closeFormOutside(event)">
          <div class="c-modal c-modal--notice-form">

            <div class="c-modal__header c-modal__header--compact">
              <div>
                <h4 class="c-modal__title" id="form-title">입주자 모집 공고 등록</h4>
                <div class="c-card__sub">
                  필수 항목(<span style="color: var(--red)">*</span>)을 모두 입력해주세요.
                </div>
              </div>

              <button class="c-modal__close" onclick="closeFormModal()" aria-label="닫기">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <div class="c-modal__body c-modal__body--compact">

              <div class="form-grid">
                <div class="c-field">
                  <label class="c-label">공고 제목 <span style="color: var(--red)">*</span></label>
                  <input type="text" id="f-ftitle" class="c-input" placeholder="예: 2026년 한강 리버뷰 입주자 모집 공고" />
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
              </div>

              <div class="form-grid">
                <div class="c-field">
                  <label class="c-label">공고 게시 기간</label>
                  <div class="date-row">
                    <input type="date" id="f-pblanc-start" class="c-input" />
                    <span>~</span>
                    <input type="date" id="f-pblanc-end" class="c-input" />
                  </div>
                </div>

                <div class="c-field">
                  <label class="c-label">모집 기간 <span style="color: var(--red)">*</span></label>
                  <div class="date-row">
                    <input type="date" id="f-fstart" class="c-input" />
                    <span>~</span>
                    <input type="date" id="f-fend" class="c-input" />
                  </div>
                  <div class="err-msg" id="e-fdate"></div>
                </div>
              </div>

              <div class="form-grid">
                <div class="c-field">
                  <label class="c-label">공급 세대수 <span style="color: var(--red)">*</span></label>
                  <input type="number" id="f-funit" class="c-input" placeholder="예: 120" min="1" />
                  <div class="err-msg" id="e-funit"></div>
                </div>

                <div class="c-field">
                  <label class="c-label">첨부파일</label>
                  <input type="file" id="f-file" class="c-input" />
                </div>
              </div>

              <div class="c-field">
                <label class="c-label">공고 내용 <span style="color: var(--red)">*</span></label>
                <textarea id="f-content" class="c-input" rows="3" placeholder="공고 주요 내용을 입력하세요."></textarea>
                <div class="err-msg" id="e-content"></div>
              </div>

              <div class="c-field">
                <label class="c-label">제출 서류 목록</label>
                <div class="cb-group cb-group--compact">
                  <label><input type="checkbox" name="docs" value="신분증 사본" /> 신분증 사본</label>
                  <label><input type="checkbox" name="docs" value="주민등록등본" /> 주민등록등본</label>
                  <label><input type="checkbox" name="docs" value="가족관계증명서" /> 가족관계증명서</label>
                  <label><input type="checkbox" name="docs" value="소득증명서" /> 소득증명서</label>
                  <label><input type="checkbox" name="docs" value="계약서" /> 계약서</label>
                  <label><input type="checkbox" name="docs" value="금융정보제공동의서" /> 금융정보제공동의서</label>
                </div>
              </div>

              <div class="c-field">
                <label class="c-label">제출 서류 상세 안내</label>
                <textarea id="f-doc-guide" class="c-input" rows="2"
                          placeholder="예: 모든 서류는 공고일 이후 발급분만 인정됩니다."></textarea>
              </div>
            </div>

            <div class="c-modal__footer c-modal__footer--compact">
              <button class="c-btn c-btn--ghost" onclick="closeFormModal()">취소</button>
              <button class="c-btn c-btn--primary" id="form-submit-btn" onclick="submitForm()">
                <span class="material-symbols-rounded">check</span>등록
              </button>
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
  </div> <!-- main-content -->
</div> <!-- main-wrap -->


    <script>
      function toggleSidebar(){var s=document.getElementById("sidebar");if(s)s.classList.toggle("collapsed");}
      var logoIcon=document.getElementById("logoIcon");
      if(logoIcon){logoIcon.onclick=function(){var s=document.getElementById("sidebar");if(s&&s.classList.contains("collapsed"))toggleSidebar();};}
    </script>

    <!-- js연결 -->
    <script src="<%= request.getContextPath() %>/js/central/admin/announcement.js"></script>

  </body>
</html>
