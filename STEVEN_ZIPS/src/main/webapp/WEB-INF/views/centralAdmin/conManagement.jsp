<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralAside.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralHeader.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralCommon.css" />
  <script defer src="${pageContext.request.contextPath}/js/centralAside.js"></script>
  <script defer src="${pageContext.request.contextPath}/js/centralHeader.js"></script>
  <style>
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
      <a href="${pageContext.request.contextPath}/centralAdmin/contractList.do" class="nav-item active"><span class="material-symbols-rounded nav-icon">contract</span><span class="nav-text">계약 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/statistics" class="nav-item"><span class="material-symbols-rounded nav-icon">bar_chart_4_bars</span><span class="nav-text">통계</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">민원 · 소통</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/civilCom" class="nav-item"><span class="material-symbols-rounded nav-icon">support_agent</span><span class="nav-text">민원 관리</span><span class="nav-badge">3</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/ai" class="nav-item"><span class="material-symbols-rounded nav-icon">forum</span><span class="nav-text">문의 관리</span><span class="nav-badge yellow">4</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/announcement" class="nav-item"><span class="material-symbols-rounded nav-icon">campaign</span><span class="nav-text">공고 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/notice" class="nav-item"><span class="material-symbols-rounded nav-icon">article</span><span class="nav-text">통합 게시판 관리</span></a>
    </div>
    <div class="section-divider"></div>
    <div class="nav-group">
      <span class="section-label">시설 · 시스템</span>
      <a href="${pageContext.request.contextPath}/centralAdmin/facility" class="nav-item"><span class="material-symbols-rounded nav-icon">handyman</span><span class="nav-text">시설 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/proHistory" class="nav-item"><span class="material-symbols-rounded nav-icon">warning</span><span class="nav-text">비정상 세대 관리</span></a>
      <a href="${pageContext.request.contextPath}/centralAdmin/subAdmin" class="nav-item"><span class="material-symbols-rounded nav-icon">manage_accounts</span><span class="nav-text">단지관리자 계정</span></a>
    </div>
  </nav>
  <div class="admin-card">
    <div class="admin-avatar"><span class="material-symbols-rounded" style="color:#fff;font-size:18px">person</span></div>
    <div class="admin-info"><p>중앙관리자</p><span>클로드 최고</span></div>
    <button class="icon-btn" data-tooltip="로그아웃" style="flex-shrink:0;margin-left:auto">
      <span class="material-symbols-rounded">logout</span>
    </button>
  </div>
</aside>

<%-- ================================================================ MAIN ================================================================ --%>
<div class="main-wrap">
  <div class="topbar">
    <div class="breadcrumb">
      <span class="material-symbols-rounded" style="font-size:14px">home</span>
      <span style="margin:0 4px">/</span>
      <span>계약·재무</span>
      <span style="margin:0 4px">/</span>
      <span class="bc-current">계약 관리</span>
    </div>
    <div class="topbar-actions">
      <button class="topbar-icon-btn" data-tooltip="알림"><span class="material-symbols-rounded">notifications</span><div class="dot"></div></button>
      <button class="topbar-icon-btn" data-tooltip="설정"><span class="material-symbols-rounded">settings</span></button>
    </div>
  </div>

  <div class="main-content">
    <div class="page-header">
      <div>
        <div class="page-title">계약 관리</div>
        <div class="page-subtitle">전·월세 계약 신청을 검토하고 오프라인 계약을 직접 등록합니다.</div>
      </div>
      <div class="page-header__right">
        <button class="c-btn" onclick="excelDownload()" data-tooltip="목록을 엑셀로 내려받기">
          <span class="material-symbols-rounded">table_view</span>엑셀 출력하기
        </button>
        <button class="c-btn c-btn--primary" onclick="openRegisterModal()">
          <span class="material-symbols-rounded">add</span>계약 등록
        </button>
      </div>
    </div>

    <%-- ================================================================ 필터 폼 ================================================================ --%>
    <form id="filterForm" method="get" action="${pageContext.request.contextPath}/centralAdmin/contractList.do">
      <input type="hidden" name="page" id="f-page" value="1" />
      <div class="c-card c-card--divide" style="margin-bottom:16px">
        <div class="c-card__header">
          <div>
            <div class="c-card__title">검색 조건</div>
            <div class="c-card__sub">조건을 입력하면 계약 목록이 필터링됩니다.</div>
          </div>
          <div class="c-card__actions">
            <button type="button" class="c-btn c-btn--ghost" onclick="resetFilter()">
              <span class="material-symbols-rounded">refresh</span>초기화
            </button>
            <button type="submit" class="c-btn c-btn--primary">
              <span class="material-symbols-rounded">search</span>검색
            </button>
          </div>
        </div>
        <div class="c-card__body c-filter-row">
          <div class="c-field" style="min-width:160px">
            <label class="c-label">계약번호</label>
            <input type="text" class="c-input" name="ctrtNo" placeholder="예: CTR-001" value="${param.ctrtNo}" />
          </div>
          <div class="c-field" style="min-width:140px">
            <label class="c-label">계약 유형</label>
            <%-- TODO: rentTypeCd 실제 코드값으로 option value 수정 --%>
            <select class="c-select" name="type">
              <option value="">전체 계약</option>
              <option value="전세" <c:if test="${param.type eq '전세'}">selected</c:if>>전세계약</option>
              <option value="월세" <c:if test="${param.type eq '월세'}">selected</c:if>>월세계약</option>
            </select>
          </div>
          <div class="c-field" style="min-width:200px">
            <label class="c-label">회원 ID</label>
            <input type="text" class="c-input" name="user" placeholder="회원 ID 검색" value="${param.user}" />
          </div>
          <div class="c-field" style="min-width:140px">
            <label class="c-label">상태</label>
            <%-- TODO: ctrtSttsCd 실제 코드값으로 option value 수정 --%>
            <select class="c-select" name="status">
              <option value="">전체 상태</option>
              <option value="승인대기" <c:if test="${param.status eq '승인대기'}">selected</c:if>>승인대기</option>
              <option value="승인"    <c:if test="${param.status eq '승인'}">selected</c:if>>승인</option>
              <option value="반려"    <c:if test="${param.status eq '반려'}">selected</c:if>>반려</option>
            </select>
          </div>
          <div class="c-field" style="min-width:170px">
            <label class="c-label">만료 임박</label>
            <select class="c-select" name="expiry">
              <option value="">전체</option>
              <option value="30"      <c:if test="${param.expiry eq '30'}">selected</c:if>>30일 이내 만료</option>
              <option value="90"      <c:if test="${param.expiry eq '90'}">selected</c:if>>90일 이내 만료</option>
              <option value="expired" <c:if test="${param.expiry eq 'expired'}">selected</c:if>>만료됨</option>
            </select>
          </div>
        </div>
      </div>
    </form>

    <%-- ================================================================ 테이블 ================================================================ --%>
    <div class="c-card c-card--divide">
      <div class="c-card__header">
        <div>
          <div class="c-card__title">계약 목록</div>
          <div class="c-card__sub">
            총 <span style="color:var(--accent);font-weight:800">${pagingVO.totalRecord}</span>건 · 페이지당 10건
          </div>
        </div>
      </div>
      <div class="c-table-wrap">
        <table class="c-table">
          <thead>
          <tr>
            <th>계약번호</th>
            <th>유형</th>
            <th>회원 ID</th>
            <th>아파트</th>
            <th>계약기간</th>
            <th>계약일</th>
            <th>담당자명</th>
            <th>상태</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty pagingVO.dataList}">
              <tr>
                <td colspan="8">
                  <div class="c-empty">
                    <div class="c-empty__title">조회된 계약이 없습니다</div>
                    <div class="c-empty__sub">조건을 변경하여 다시 검색해주세요.</div>
                  </div>
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="ct" items="${pagingVO.dataList}">
                <tr style="cursor:pointer" onclick="openPanel('${ct.rentCtrtNo}')">
                  <td style="font-weight:700">${ct.rentCtrtNo}</td>
                    <%-- TODO: rentTypeNm 조인 안 됐으면 rentTypeCd 표시 --%>
                  <td>${not empty ct.rentTypeNm ? ct.rentTypeNm : ct.rentTypeCd}</td>
                  <td>${ct.userId}</td>
                  <td>${ct.aptCmplexNm}</td>
                  <td>
                    <c:choose>
                      <c:when test="${not empty ct.mvinDt and not empty ct.mvoutDt}">
                        <fmt:formatDate value="${ct.mvinDt}" pattern="yyyy-MM-dd"/> ~
                        <fmt:formatDate value="${ct.mvoutDt}" pattern="yyyy-MM-dd"/>
                      </c:when>
                      <c:otherwise>-</c:otherwise>
                    </c:choose>
                  </td>
                  <td style="color:var(--text-secondary)">
                    <fmt:formatDate value="${ct.regDt}" pattern="yyyy-MM-dd"/>
                  </td>
                  <td>${not empty ct.mgrNm ? ct.mgrNm : '-'}</td>
                  <td>
                      <%-- TODO: ctrtSttsCd 실제 코드값으로 조건 수정 --%>
                    <c:choose>
                      <c:when test="${ct.ctrtSttsCd eq '승인대기'}"><span class="c-badge c-badge--pending">승인대기</span></c:when>
                      <c:when test="${ct.ctrtSttsCd eq '승인'}"><span class="c-badge c-badge--active">승인</span></c:when>
                      <c:when test="${ct.ctrtSttsCd eq '반려'}"><span class="c-badge c-badge--danger">반려</span></c:when>
                      <c:otherwise><span class="c-badge">${ct.ctrtSttsCd}</span></c:otherwise>
                    </c:choose>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>

      <%-- 페이지네이션 --%>
      <div class="c-card__footer" style="justify-content:center">
        <div class="c-pagination">
          <c:if test="${pagingVO.totalPage > 1}">
            <button type="button"
                    class="c-pagination__btn ${pagingVO.currentPage eq 1 ? 'is-disabled' : ''}"
                    onclick="goPage(${pagingVO.currentPage - 1})">
              <span class="material-symbols-rounded">chevron_left</span>
            </button>
            <c:forEach begin="${pagingVO.startPage}" end="${pagingVO.endPage}" var="i">
              <c:if test="${i <= pagingVO.totalPage}">
                <button type="button"
                        class="c-pagination__btn ${pagingVO.currentPage eq i ? 'is-active' : ''}"
                        onclick="goPage(${i})">${i}</button>
              </c:if>
            </c:forEach>
            <button type="button"
                    class="c-pagination__btn ${pagingVO.currentPage eq pagingVO.totalPage ? 'is-disabled' : ''}"
                    onclick="goPage(${pagingVO.currentPage + 1})">
              <span class="material-symbols-rounded">chevron_right</span>
            </button>
          </c:if>
        </div>
      </div>
    </div>
  </div>
</div>

<%-- ================================================================
     계약 등록 모달
     핵심: form은 c-modal__body 안에, footer는 modal 직계 자식으로
     ================================================================ --%>
<div class="c-modal-overlay is-hidden" id="registerOverlay"
     onclick="if(event.target===this) closeRegisterModal()">
  <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">

    <div class="c-modal__header">
      <h3 class="c-modal__title">계약 등록</h3>
      <button class="c-modal__close" onclick="closeRegisterModal()" aria-label="닫기">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>

    <%-- body 안에 form --%>
    <div class="c-modal__body">
      <form id="registerForm" method="post"
            action="${pageContext.request.contextPath}/centralAdmin/contractInsert.do"
            enctype="multipart/form-data">

        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

        <div style="display:flex;flex-direction:column;gap:16px">

          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">계약 기본 정보</div></div>
            <div class="c-card__body">
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px">

                <div class="c-field">
                  <label class="c-label">회원 ID <span class="req">*</span></label>
                  <input type="text" id="r-user" name="userNo" class="c-input" placeholder="회원 ID 입력" />
                  <span class="form-err" id="err-user"></span>
                </div>

                <div class="c-field">
                  <label class="c-label">매물번호 <span class="req">*</span></label>
                  <%-- TODO: aptList 연동 후 select로 교체 --%>
                  <input type="text" id="r-apt" name="rentLstgNo" class="c-input" placeholder="매물번호 입력 (예: 1)" />
                  <span class="form-err" id="err-apt"></span>
                </div>

                <div class="c-field">
                  <label class="c-label">계약 유형 <span class="req">*</span></label>
                  <%-- TODO: rentTypeCd 실제 코드값으로 수정 --%>
                  <select id="r-type" name="ctrtId" class="c-select">
                    <option value="">선택</option>
                    <option value="전세">전세계약</option>
                    <option value="월세">월세계약</option>
                  </select>
                  <span class="form-err" id="err-type"></span>
                </div>

                <div class="c-field">
                  <label class="c-label">계약 상태</label>
                  <input type="text" class="c-input" value="승인대기" disabled
                         style="background:var(--gray-soft);color:var(--text-tertiary);cursor:not-allowed" />
                </div>

              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">계약 정보</div></div>
            <div class="c-card__body">
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px">

                <div class="c-field">
                  <label class="c-label">계약 금액</label>
                  <input type="number" name="ctrtAmt" class="c-input" placeholder="원 단위 입력" min="0" />
                </div>

                <div class="c-field">
                  <label class="c-label">보증금</label>
                  <input type="number" name="dpstAmt" class="c-input" placeholder="원 단위 입력" min="0" />
                </div>

                <div class="c-field">
                  <label class="c-label">계약 시작일</label>
                  <input type="date" id="r-start" name="mvinDt" class="c-input" />
                </div>

                <div class="c-field">
                  <label class="c-label">계약 종료일</label>
                  <input type="date" id="r-end" name="mvoutDt" class="c-input" />
                  <span class="form-err" id="err-date"></span>
                </div>

              </div>
            </div>
          </div>

          <div class="c-card c-card--divide">
            <div class="c-card__header"><div class="c-card__title">계약 서류 업로드</div></div>
            <div class="c-card__body">
              <div style="display:flex;flex-direction:column;gap:10px">

                <div class="file-upload-row">
                  <label class="c-label" style="width:90px;flex-shrink:0">계약서</label>
                  <label class="file-label">
                    <input type="file" name="contractFile" accept=".pdf,.doc,.docx"
                           onchange="showFileName(this,'fname1')" />
                    <span class="material-symbols-rounded" style="font-size:16px;margin-right:5px">upload</span>파일 선택
                  </label>
                  <span class="file-fname" id="fname1">선택된 파일 없음</span>
                </div>

                <div class="file-upload-row">
                  <label class="c-label" style="width:90px;flex-shrink:0">신분증</label>
                  <label class="file-label">
                    <input type="file" name="idFile" accept=".pdf,.jpg,.png"
                           onchange="showFileName(this,'fname2')" />
                    <span class="material-symbols-rounded" style="font-size:16px;margin-right:5px">upload</span>파일 선택
                  </label>
                  <span class="file-fname" id="fname2">선택된 파일 없음</span>
                </div>

                <div class="file-upload-row">
                  <label class="c-label" style="width:90px;flex-shrink:0">추가 서류</label>
                  <label class="file-label">
                    <input type="file" name="etcFile" accept=".pdf,.doc,.docx"
                           onchange="showFileName(this,'fname3')" />
                    <span class="material-symbols-rounded" style="font-size:16px;margin-right:5px">upload</span>파일 선택
                  </label>
                  <span class="file-fname" id="fname3">선택된 파일 없음</span>
                </div>

              </div>
            </div>
          </div>

        </div>
      </form><%-- form 끝 --%>
    </div><%-- c-modal__body 끝 --%>

    <%-- footer는 modal 직계 자식 — form 밖 --%>
    <div class="c-modal__footer">
      <button type="button" class="c-btn c-btn--ghost" onclick="closeRegisterModal()">닫기</button>
      <button type="button" class="c-btn c-btn--primary" onclick="submitRegister()">
        <span class="material-symbols-rounded">check</span>계약 등록
      </button>
    </div>

  </div>
</div>

<%-- ================================================================
     계약 상세 모달
     ================================================================ --%>
<div class="c-modal-overlay is-hidden" id="overlay"
     onclick="if(event.target===this) closePanel()">
  <div class="c-modal c-modal--lg" role="dialog" aria-modal="true">

    <div class="c-modal__header">
      <h3 class="c-modal__title">계약 상세</h3>
      <button class="c-modal__close" onclick="closePanel()" aria-label="닫기">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>

    <div class="c-modal__body">
      <div>
        <div class="c-so__section-title">계약 정보</div>
        <div class="c-info-grid" id="so-info"></div>
      </div>
      <div style="margin-top:14px">
        <div class="c-so__section-title">첨부 서류</div>
        <div id="so-files"></div>
      </div>
      <div id="so-reject-section" style="margin-top:14px;display:none">
        <div class="c-so__section-title">반려 사유 <span class="req">*</span></div>
        <textarea class="so-textarea" id="so-reason" rows="3"
                  placeholder="반려 시 사유를 입력하세요 (필수)"></textarea>
        <span class="form-err" id="err-reason"></span>
      </div>
    </div>

    <div class="c-modal__footer" id="so-footer"></div>

  </div>
</div>

<%-- ================================================================ SCRIPT ================================================================ --%>
<script>
  var CTX = '${pageContext.request.contextPath}';
  var currentCtrtNo = null;

  /* 페이지네이션 */
  function goPage(page) {
    var max = parseInt('${pagingVO.totalPage}') || 1;
    if (page < 1 || page > max) return;
    document.getElementById('f-page').value = page;
    document.getElementById('filterForm').submit();
  }

  /* 필터 초기화 */
  function resetFilter() {
    var form = document.getElementById('filterForm');
    form.querySelectorAll('input[type=text]').forEach(function(el){ el.value=''; });
    form.querySelectorAll('select').forEach(function(el){ el.value=''; });
    document.getElementById('f-page').value = '1';
    form.submit();
  }

  /* 엑셀 출력 — TODO: URL 수정 */
  function excelDownload() {
    var form = document.getElementById('filterForm');
    var origin = form.action;
    form.action = CTX + '/centralAdmin/contractExcel.do';
    form.target = '_blank';
    form.submit();
    form.action = origin;
    form.target = '';
  }

  /* 등록 모달 */
  function openRegisterModal()  { document.getElementById('registerOverlay').classList.remove('is-hidden'); }
  function closeRegisterModal() { document.getElementById('registerOverlay').classList.add('is-hidden'); }

  /* 등록 유효성 검사 후 form submit */
  function submitRegister() {
    var valid = true;

    function setErr(inputId, errId, msg) {
      var el  = document.getElementById(inputId);
      var err = document.getElementById(errId);
      var empty = !el.value.trim();
      el.style.borderColor = empty ? 'var(--red)' : '';
      err.textContent      = empty ? msg : '';
      if (empty) valid = false;
    }

    setErr('r-user', 'err-user', '회원 ID를 입력해주세요');
    setErr('r-apt',  'err-apt',  '매물번호를 입력해주세요');
    setErr('r-type', 'err-type', '계약 유형을 선택해주세요');

    var start   = document.getElementById('r-start').value;
    var end     = document.getElementById('r-end').value;
    var endEl   = document.getElementById('r-end');
    var errDate = document.getElementById('err-date');
    if (start && end && end < start) {
      endEl.style.borderColor = 'var(--red)';
      errDate.textContent     = '종료일은 시작일 이후여야 합니다';
      valid = false;
    } else {
      endEl.style.borderColor = '';
      errDate.textContent     = '';
    }

    if (!valid) return;
    document.getElementById('registerForm').submit();
  }

  function showFileName(input, targetId) {
    var el = document.getElementById(targetId);
    el.textContent = input.files[0] ? input.files[0].name : '선택된 파일 없음';
    el.style.color = input.files[0] ? 'var(--text-primary)' : 'var(--text-tertiary)';
  }

  /* 상세 모달
     TODO: fetch URL → 실제 단건 조회 컨트롤러로 수정
     응답 JSON: { rentCtrtNo, rentTypeNm, userId, aptCmplexNm,
                  ctrtAmt, dpstAmt, mvinDt, mvoutDt,
                  ctrtSttsCd, ctrtSttsNm,
                  files:[{fileNm, atchFileId}] } */
  function openPanel(rentCtrtNo) {
    currentCtrtNo = rentCtrtNo;
    document.getElementById('so-info').innerHTML   = '<div style="color:var(--text-tertiary);font-size:13px;padding:12px 0">불러오는 중...</div>';
    document.getElementById('so-files').innerHTML  = '';
    document.getElementById('so-footer').innerHTML = '';
    document.getElementById('so-reject-section').style.display = 'none';
    document.getElementById('so-reason').value     = '';
    document.getElementById('err-reason').textContent = '';
    document.getElementById('overlay').classList.remove('is-hidden');

    fetch(CTX + '/centralAdmin/contractDetail.do?rentCtrtNo=' + encodeURIComponent(rentCtrtNo))
            .then(function(res){ if(!res.ok) throw new Error(res.status); return res.json(); })
            .then(function(data){ renderDetail(data); })
            .catch(function(err){
              document.getElementById('so-info').innerHTML =
                      '<div style="color:var(--red);font-size:13px">데이터를 불러오지 못했습니다.</div>';
              console.error(err);
            });
  }

  function renderDetail(data) {
    var BADGE = {'승인대기':'c-badge--pending','승인':'c-badge--active','반려':'c-badge--danger'};
    var rows = [
      ['계약번호',  data.rentCtrtNo  || '-'],
      ['계약 유형', data.rentTypeNm  || '-'],
      ['회원 ID',   data.userId      || '-'],
      ['아파트',    data.aptCmplexNm || '-'],
      ['계약 금액', data.ctrtAmt     || '-'],
      ['보증금',    data.dpstAmt     || '-'],
      ['계약 기간', (data.mvinDt && data.mvoutDt) ? data.mvinDt + ' ~ ' + data.mvoutDt : '-'],
      ['현재 상태', '<span class="c-badge ' + (BADGE[data.ctrtSttsCd]||'') + '">' + (data.ctrtSttsNm||data.ctrtSttsCd||'-') + '</span>']
    ];
    document.getElementById('so-info').innerHTML = rows.map(function(r){
      return '<div class="c-info-block"><div class="c-info-field__label">' + r[0] + '</div><div class="c-info-field__val">' + r[1] + '</div></div>';
    }).join('');

    var files = data.files || [];
    document.getElementById('so-files').innerHTML = files.length === 0
            ? '<div style="color:var(--text-tertiary);font-size:13px">첨부된 서류가 없습니다.</div>'
            : files.map(function(f){
              return '<div class="file-row"><span class="file-name">'
                      + '<span class="material-symbols-rounded" style="font-size:18px;color:var(--text-tertiary)">description</span>'
                      + f.fileNm + '</span>'
                      + '<button class="c-btn c-btn--ghost c-btn--sm" onclick="viewFile(\'' + f.atchFileId + '\')">보기</button></div>';
            }).join('');

    document.getElementById('so-reject-section').style.display =
            data.ctrtSttsCd === '승인' ? 'none' : '';

    document.getElementById('so-footer').innerHTML = data.ctrtSttsCd === '승인대기'
            ? '<button class="c-btn c-btn--danger" onclick="doReject()"><span class="material-symbols-rounded">close</span>반려</button>'
            + '<button class="c-btn c-btn--primary" onclick="doApprove()"><span class="material-symbols-rounded">check</span>승인</button>'
            : '<button class="c-btn c-btn--ghost" onclick="closePanel()" style="flex:1">닫기</button>';
  }

  function closePanel() {
    document.getElementById('overlay').classList.add('is-hidden');
    currentCtrtNo = null;
  }

  /* 승인 — TODO: URL 수정 */
  function doApprove() {
    if (!confirm('승인하시겠습니까?')) return;
    fetch(CTX + '/centralAdmin/contractApprove.do', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: 'rentCtrtNo=' + encodeURIComponent(currentCtrtNo)
    })
            .then(function(res){ return res.json(); })
            .then(function(result){
              if (result.success) {
                alert('승인되었습니다.');
                closePanel();
                document.getElementById('filterForm').submit();
              } else {
                alert('오류: ' + (result.message || '처리 실패'));
              }
            })
            .catch(function(){ alert('서버 통신 오류가 발생했습니다.'); });
  }

  /* 반려 — TODO: URL 수정 */
  function doReject() {
    var reason = document.getElementById('so-reason').value.trim();
    var errEl  = document.getElementById('err-reason');
    if (!reason) {
      document.getElementById('so-reason').classList.add('is-error');
      errEl.textContent = '반려 사유를 입력해주세요.';
      document.getElementById('so-reason').focus();
      return;
    }
    errEl.textContent = '';
    document.getElementById('so-reason').classList.remove('is-error');
    if (!confirm('반려 처리하시겠습니까?')) return;

    fetch(CTX + '/centralAdmin/contractReject.do', {
      method: 'POST',
      headers: {'Content-Type':'application/x-www-form-urlencoded'},
      body: 'rentCtrtNo=' + encodeURIComponent(currentCtrtNo)
              + '&rejectReason=' + encodeURIComponent(reason)
    })
            .then(function(res){ return res.json(); })
            .then(function(result){
              if (result.success) {
                alert('반려 처리되었습니다.');
                closePanel();
                document.getElementById('filterForm').submit();
              } else {
                alert('오류: ' + (result.message || '처리 실패'));
              }
            })
            .catch(function(){ alert('서버 통신 오류가 발생했습니다.'); });
  }

  /* 파일 보기 — TODO: URL 수정 */
  function viewFile(atchFileId) {
    window.open(CTX + '/centralAdmin/fileDownload.do?atchFileId=' + encodeURIComponent(atchFileId), '_blank');
  }

  /* 사이드바 */
  function toggleSidebar() {
    var s = document.getElementById('sidebar');
    if (s) s.classList.toggle('collapsed');
  }
  var logoIcon = document.getElementById('logoIcon');
  if (logoIcon) {
    logoIcon.addEventListener('click', function(){
      var s = document.getElementById('sidebar');
      if (s && s.classList.contains('collapsed')) toggleSidebar();
    });
  }
</script>
</body>
</html>
