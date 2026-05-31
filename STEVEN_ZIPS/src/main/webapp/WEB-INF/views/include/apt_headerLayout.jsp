<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<meta name="_csrf_header" content="${_csrf.headerName}"/>
<%-- 서버가 정해준 이름(편지봉투) --%>
<meta name="_csrf" content="${_csrf.token}"/>
<%-- 실제 1회용 암호 값(편지) --%>

<header class="site-header">
    <!-- 헤더 부터 푸터까지 사용할 수 있도록 스코프 지정 -->
    <c:set var="apt" value="${aptInfo.aptComplexInfo}" scope="request"/>
    <c:set var="mgmtOffice" value="${aptInfo.mgmtOfficeInfo}" scope="request"/>
    <c:set var="board" value="${aptInfo.annBoardPostInfoList}" scope="request"/>

    <div class="header-top">
        <a href="${pageContext.request.contextPath}/apt/main/${apt.aptCmplexNo}" class="logo">
            <%-- 로고 아이콘 --%>
            <svg class="logo-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                 stroke-linecap="round" stroke-linejoin="round">
                <path d="M3 9.5L12 3l9 6.5V20a1 1 0 01-1 1H4a1 1 0 01-1-1V9.5z"/>
                <path d="M9 21V12h6v9"/>
            </svg>
            <div class="logo-text">
                <span class="ko">${apt.aptCmplexNm}</span>
                <span class="en">MY HOME MAPPING</span>
            </div>
        </a>

        <div class="header-actions">

            <%-- 카카오 알림 --%>
            <button type="button"
                    id="kakaoAlimBtn"
                    class="kakao-alim-btn">

                <svg class="kakao-bell"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">
                    <path d="M18 8a6 6 0 10-12 0c0 7-3 8-3 8h18s-3-1-3-8"/>
                    <path d="M13.73 21a2 2 0 01-3.46 0"/>
                </svg>

                <span class="kakao-label">알림</span>

                <span class="kakao-badge">
                <c:out value="${empty unreadCount ? 0 : unreadCount}"/>
            </span>
            </button>
            <!-- 카카오톡 모달 -->
            <div id="kakaoModal" class="kakao-modal">
                <div class="kakao-phone">
                    <div class="kakao-header">
                        <span>STEVEN_ZIPS</span>
                        <button type="button" id="kakaoCloseBtn">×</button>
                    </div>

                    <div id="kakaoAlimList" class="kakao-chat-body">
                        <!-- JS로 알림 출력 -->
                    </div>
                </div>
            </div>

            <sec:authorize access="isAuthenticated()">
            <span style="font-size:1.2em; color:blue; font-weight:bold;">
            <sec:authentication property="principal.member.userNm"/>
            </span>님
                <a href="/member/myPageAuth.do" class="btn-filled">마이페이지</a>
                <button type="button" id="logoutBtn" class="btn-outline">로그아웃</button>
                <%-- 로그아웃을 위한 히든 폼 --%>
                <form id="logoutForm" action="/logout" method="post" style="display: none;">
                    <sec:csrfInput/>
                </form>
            </sec:authorize>

            <sec:authorize access="isAnonymous()">
                <a href="/login.do" class="btn-outline">로그인</a>
                <button type="button" class="btn-filled" id="joinFormBtn">회원가입</button>
            </sec:authorize>
        </div>
    </div>

    <nav class="header-nav">
        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/manage') ? 'active' : ''}">
            <span>관리사무소
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
            <path d="M6 9l6 6 6-6"/>
            </svg>
            </span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/apt/main/aptInfo/${apt.aptCmplexNo}">우리아파트</a>
                <a href="${pageContext.request.contextPath}/resident/calendar/${apt.aptCmplexNo}">우리단지일정</a>
                <a href="${pageContext.request.contextPath}/apt/main/mgmtInfo/${apt.aptCmplexNo}">관리사무소 소개</a>
                <%--<a href="${pageContext.request.contextPath}/resident/manage/operation">운영정보공개</a>--%>
                <a href="${pageContext.request.contextPath}/resident/manage/facility/${apt.aptCmplexNo}">시설관리이력</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/bill') ? 'active' : ''}">
            <span>아파트관리비<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/bill/inquiry/${apt.aptCmplexNo}">관리비조회</a>
                <a href="${pageContext.request.contextPath}/resident/bill/guide/${aptCmplexNo}">납부안내</a>
                <%--<a href="${pageContext.request.contextPath}/resident/bill/auto">자동이체신청</a>--%>
                <a href="${pageContext.request.contextPath}/resident/bill/receipt/${aptCmplexNo}">납부영수증</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/service') ? 'active' : ''}">
            <span>생활지원서비스<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/service/moving/${aptCmplexNo}">전입/전출신고</a>
                <a href="/resident/service/car/${aptCmplexNo}">차량등록</a>
                <a href="${pageContext.request.contextPath}/resident/service/visitor/${aptCmplexNo}">방문차량등록</a>
<%--                <a href="${pageContext.request.contextPath}/resident/service/facility">편의시설예약</a>--%>
                <a href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${apt.aptCmplexNo}">편의시설예약</a>
                <a href="${pageContext.request.contextPath}/resident/publicFacility/myReservation/${apt.aptCmplexNo}">예약내역</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/complaint') ? 'active' : ''}">
            <span>민원접수<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="/apt/complaint/apply.do/${apt.aptCmplexNo}">내 민원 및 신청</a>
                <a href="/apt/complaint/list/${apt.aptCmplexNo}">단지 민원 내역</a>
                <a href="${pageContext.request.contextPath}/resident/complaint/live">실시간문의</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/vote') ? 'active' : ''}">
            <span>전자투표및설문<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/survey/list/${aptCmplexNo}">투표 및 설문조사</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/board') ? 'active' : ''}">
            <span>입주민게시판<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <a href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}">공지사항</a>
                <a href="${pageContext.request.contextPath}/resident/board/free/list/${aptCmplexNo}">자유게시판</a>
                <a href="${pageContext.request.contextPath}/resident/board/chat/${aptCmplexNo}">그룹채팅방</a>
            </div>
        </div>

        <div class="nav-item ${fn:contains(pageContext.request.requestURI, '/resident/stats') ? 'active' : ''}">
            <span>우리아파트통계<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path
                    d="M6 9l6 6 6-6"/></svg></span>
            <div class="slim-drop">
                <%-- 단지번호 포함 URL (URL 유실 시 404 방지) --%>
                <a href="${pageContext.request.contextPath}/resident/stats/custom/${aptCmplexNo}">우리집맞춤통계</a>
                <a href="${pageContext.request.contextPath}/resident/stats/apartment/${aptCmplexNo}">아파트통계</a>
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
            <div class="all-menu-title">${apt.aptCmplexNm} 전체메뉴</div>
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
                    <li><a href="${pageContext.request.contextPath}/apt/main/aptInfo/${apt.aptCmplexNo}">우리아파트</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/calendar/${apt.aptCmplexNo}">우리단지일정</a></li>
                    <li><a href="${pageContext.request.contextPath}/apt/main/mgmtInfo/${apt.aptCmplexNo}">관리사무소 소개</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/manage/operation">운영정보공개</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/manage/facility/${apt.aptCmplexNo}">시설관리이력</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/manage/favorite">즐겨찾기</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">아파트관리비</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/inquiry/${apt.aptCmplexNo}">관리비조회</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/guide">납부안내</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/auto">자동이체신청</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/bill/receipt">납부영수증</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">생활지원서비스</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/service/moving">전입/전출신고</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/service/car/${aptCmplexNo}">차량등록</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/service/visitor/${aptCmplexNo}">방문차량등록</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/publicFacility/reservation/${apt.aptCmplexNo}">편의시설예약</a>
                    </li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">민원접수</div>
                <ul>
                    <li><a href="/apt/complaint/apply.do/${apt.aptCmplexNo}">민원신청</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/complaint/live">실시간문의</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/complaint/chatbot">챗봇민원접수</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/complaint/status">민원접수현황</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">전자투표및설문</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/vote">입주민 투표</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/survey">설문조사</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">입주민게시판</div>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/resident/board/notice/${aptCmplexNo}">공지사항</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/board/free/list/${aptCmplexNo}">자유게시판</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/board/chat">그룹채팅방</a></li>
                </ul>
            </div>

            <div class="all-menu-section">
                <div class="all-menu-section-title">우리아파트통계</div>
                <ul>
                    <%-- 단지번호 포함 URL (URL 유실 시 404 방지) --%>
                    <li><a href="${pageContext.request.contextPath}/resident/stats/custom/${aptCmplexNo}">우리집맞춤통계</a></li>
                    <li><a href="${pageContext.request.contextPath}/resident/stats/apartment/${aptCmplexNo}">아파트통계</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

    <style>
        /* 스타일시트를 못찾아서.. 알려주면 옮기겠습니다. -보라 */
        .kakao-alim-btn{
            display:flex;
            align-items:center;
            gap:4px;

            background:#FEE500;

            border:none;
            border-radius:999px;

            padding:4px 8px;

            font-size:11px;
            font-weight:700;

            color:#191919;

            margin-right:10px;
            cursor:pointer;
        }

        .kakao-bell{
            width:11px;
            height:11px;
            fill:#191919;
        }

        .kakao-badge{
            min-width:14px;
            height:14px;

            display:flex;
            align-items:center;
            justify-content:center;

            border-radius:50%;

            background:#3C1E1E;
            color:#FEE500;

            font-size:9px;
            font-weight:700;
        }
        /* 카카오 모달은 버튼 클릭 전까지 숨김 */
        .kakao-modal{
            display:none;
        }
    </style>

<script type="module">

    const allBtn = document.getElementById('allMenuBtn');
    const overlay = document.getElementById('allMenuOverlay');
    const closeBtn = document.getElementById('allMenuClose');

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
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) closeMenu();
        });
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') closeMenu();
    });

</script>
<jsp:include page="/WEB-INF/views/include/websocket.jsp"/>
