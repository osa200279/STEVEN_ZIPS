<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<header class="site-header">
  <div class="header-top">
    <a href="${pageContext.request.contextPath}/" class="logo">
      <svg class="logo-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
        <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
        <path d="M9 21V12h6v9"/>
      </svg>
      <div class="logo-text">
        <span class="ko">대덕아파트</span>
        <span class="en">DAEDEOK APARTMENT</span>
      </div>
    </a>

    <div class="header-actions">
      <sec:authorize access="isAuthenticated()">
        <span style="font-size:1.2em; color:blue; font-weight:bold;">
          <sec:authentication property="principal.member.userNm"/>님
        </span>
        <a href="/member/mypage.do" class="btn-filled">마이페이지</a>
        <button type="button" id="logoutBtn" class="btn-outline">로그아웃</button>
           <%-- 로그아웃을 위한 히든 폼 --%>
        <form id="logoutForm" action="/logout" method="post" style="display: none;">
	      <sec:csrfInput/>
	    </form>
      </sec:authorize>

      <sec:authorize access="isAnonymous()">
        <a href="/login.do" class="btn-outline">로그인</a>
        <a href="/member/register.do" class="btn-filled">회원가입</a>
      </sec:authorize>
    </div>
  </div>

  <nav class="header-nav">
    <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/manage') ? 'active' : ''}">
      <span>관리사무소<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg></span>
      <div class="slim-drop">
        <a href="${pageContext.request.contextPath}/manage/intro">관리사무소 소개</a>
        <a href="${pageContext.request.contextPath}/manage/operation">운영정보공개</a>
        <a href="${pageContext.request.contextPath}/manage/facility">시설관리이력</a>
        <a href="${pageContext.request.contextPath}/manage/favorite">즐겨찾기</a>
      </div>
    </div>

    <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/fee') ? 'active' : ''}">
      <span>아파트관리비<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg></span>
      <div class="slim-drop">
        <a href="${pageContext.request.contextPath}/fee/inquiry">관리비조회</a>
        <a href="${pageContext.request.contextPath}/fee/guide">납부안내</a>
        <a href="${pageContext.request.contextPath}/fee/auto">자동이체신청</a>
        <a href="${pageContext.request.contextPath}/fee/receipt">납부영수증</a>
      </div>
    </div>

    <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/service') ? 'active' : ''}">
      <span>생활지원서비스<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg></span>
      <div class="slim-drop">
        <a href="${pageContext.request.contextPath}/service/moving">전입/전출신고</a>
        <a href="${pageContext.request.contextPath}/service/car">차량등록</a>
        <a href="${pageContext.request.contextPath}/service/visitor">방문차량등록</a>
        <a href="${pageContext.request.contextPath}/service/facility">공용시설예약</a>
      </div>
    </div>

    <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/complaint') ? 'active' : ''}">
      <span>민원접수<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg></span>
      <div class="slim-drop">
        <a href="${pageContext.request.contextPath}/complaint/apply">민원신청</a>
        <a href="${pageContext.request.contextPath}/complaint/live">실시간문의</a>
        <a href="${pageContext.request.contextPath}/complaint/chatbot">챗봇민원접수</a>
        <a href="${pageContext.request.contextPath}/complaint/status">민원접수현황</a>
      </div>
    </div>

    <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/vote') ? 'active' : ''}">
      <span>전자투표및설문<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg></span>
      <div class="slim-drop">
        <a href="${pageContext.request.contextPath}/vote/resident">입주민 투표</a>
        <a href="${pageContext.request.contextPath}/vote/survey">설문조사</a>
      </div>
    </div>

    <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/board') ? 'active' : ''}">
      <span>입주민게시판<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg></span>
      <div class="slim-drop">
        <a href="${pageContext.request.contextPath}/board/notice">공지사항</a>
        <a href="${pageContext.request.contextPath}/board/free">자유게시판</a>
        <a href="${pageContext.request.contextPath}/board/chat">그룹채팅방</a>
      </div>
    </div>

    <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/stats') ? 'active' : ''}">
      <span>우리아파트통계<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M6 9l6 6 6-6"/></svg></span>
      <div class="slim-drop">
        <a href="${pageContext.request.contextPath}/stats/custom">우리집맞춤통계</a>
      </div>
    </div>

    <button class="nav-all-btn" id="allMenuBtn" type="button" aria-label="전체메뉴">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round">
        <line x1="3" y1="6" x2="21" y2="6"/>
        <line x1="3" y1="12" x2="21" y2="12"/>
        <line x1="3" y1="18" x2="21" y2="18"/>
      </svg>
    </button>
  </nav>
  <script src="${pageContext.request.contextPath}/js/common/conn.js"></script>
</header>

<div class="all-menu-overlay" id="allMenuOverlay" role="dialog" aria-modal="true">
  <div class="all-menu-panel">
    <div class="all-menu-header">
      <div class="all-menu-title">대덕아파트 전체메뉴</div>
      <button class="all-menu-close" id="allMenuClose" type="button">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round">
          <line x1="18" y1="6" x2="6" y2="18"/>
          <line x1="6" y1="6" x2="18" y2="18"/>
        </svg>
      </button>
    </div>

    <div class="all-menu-grid">
      <div class="all-menu-section">
        <div class="all-menu-section-title">관리사무소</div>
        <ul>
          <li><a href="${pageContext.request.contextPath}/manage/intro">관리사무소 소개</a></li>
          <li><a href="${pageContext.request.contextPath}/manage/operation">운영정보공개</a></li>
          <li><a href="${pageContext.request.contextPath}/manage/facility">시설관리이력</a></li>
          <li><a href="${pageContext.request.contextPath}/manage/favorite">즐겨찾기</a></li>
        </ul>
      </div>

      <div class="all-menu-section">
        <div class="all-menu-section-title">아파트관리비</div>
        <ul>
          <li><a href="${pageContext.request.contextPath}/fee/inquiry">관리비조회</a></li>
          <li><a href="${pageContext.request.contextPath}/fee/guide">납부안내</a></li>
          <li><a href="${pageContext.request.contextPath}/fee/auto">자동이체신청</a></li>
          <li><a href="${pageContext.request.contextPath}/fee/receipt">납부영수증</a></li>
        </ul>
      </div>

      <div class="all-menu-section">
        <div class="all-menu-section-title">생활지원서비스</div>
        <ul>
          <li><a href="${pageContext.request.contextPath}/service/moving">전입/전출신고</a></li>
          <li><a href="${pageContext.request.contextPath}/service/car">차량등록</a></li>
          <li><a href="${pageContext.request.contextPath}/service/visitor">방문차량등록</a></li>
          <li><a href="${pageContext.request.contextPath}/service/facility">공용시설예약</a></li>
        </ul>
      </div>

      <div class="all-menu-section">
        <div class="all-menu-section-title">민원접수</div>
        <ul>
          <li><a href="${pageContext.request.contextPath}/complaint/apply">민원신청</a></li>
          <li><a href="${pageContext.request.contextPath}/complaint/live">실시간문의</a></li>
          <li><a href="${pageContext.request.contextPath}/complaint/chatbot">챗봇민원접수</a></li>
          <li><a href="${pageContext.request.contextPath}/complaint/status">민원접수현황</a></li>
        </ul>
      </div>

      <div class="all-menu-section">
        <div class="all-menu-section-title">전자투표및설문</div>
        <ul>
          <li><a href="${pageContext.request.contextPath}/vote/resident">입주민 투표</a></li>
          <li><a href="${pageContext.request.contextPath}/vote/survey">설문조사</a></li>
        </ul>
      </div>

      <div class="all-menu-section">
        <div class="all-menu-section-title">입주민게시판</div>
        <ul>
          <li><a href="${pageContext.request.contextPath}/board/notice">공지사항</a></li>
          <li><a href="${pageContext.request.contextPath}/board/free">자유게시판</a></li>
          <li><a href="${pageContext.request.contextPath}/board/chat">그룹채팅방</a></li>
        </ul>
      </div>

      <div class="all-menu-section">
        <div class="all-menu-section-title">우리아파트통계</div>
        <ul>
          <li><a href="${pageContext.request.contextPath}/stats/custom">우리집맞춤통계</a></li>
        </ul>
      </div>
    </div>
  </div>
</div>

<script>
(function () {
  var allBtn   = document.getElementById('allMenuBtn');
  var overlay  = document.getElementById('allMenuOverlay');
  var closeBtn = document.getElementById('allMenuClose');

  function openMenu() {
    overlay.classList.add('open');
    document.body.style.overflow = 'hidden';
  }

  function closeMenu() {
    overlay.classList.remove('open');
    document.body.style.overflow = '';
  }

  if (allBtn) allBtn.addEventListener('click', openMenu);
  if (closeBtn) closeBtn.addEventListener('click', closeMenu);

  if (overlay) {
    overlay.addEventListener('click', function(e) {
      if (e.target === overlay) closeMenu();
    });
  }

  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closeMenu();
  });
})();
</script>