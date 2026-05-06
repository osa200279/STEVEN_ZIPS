<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%--
  Created by IntelliJ IDEA.
  User: PC-24
  Date: 2026-04-22
  Time: 오후 3:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/loginStyle.css">
    <meta charset="utf-8"/>
    <script src="/js/common/conn.js"></script>
    <title>Login Form</title>
</head>
<body>
    <div class="login-page">

        <header class="topbar">
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

            <div class="top-links">
                <a href="${pageContext.request.contextPath}/" class="top-btn outline">홈으로</a>
                <a href="${pageContext.request.contextPath}/join" class="top-btn fill">회원가입</a>
            </div>
        </header>

        <div class="login-wrap">
            <div class="login-shell">

                <section class="login-left">
                    <div class="left-copy">
                        <span class="left-badge">Premium Housing Service</span>
                        <h1>품격 있는 주거관리,<br><em>더 편리한 생활의 시작</em></h1>
                        <p>
                            관리비 조회, 공지사항 확인, 공용시설 예약, 민원접수까지<br>
                            대덕아파트의 다양한 서비스를 한 번에 이용해 보세요.
                        </p>

                        <div class="info-cards">
                            <div class="info-card">입주민 전용 생활지원 서비스</div>
                            <div class="info-card">공동주택 통합 관리 시스템</div>
                            <div class="info-card">민원 · 설문 · 시설예약 통합</div>
                        </div>
                    </div>
                </section>

                <section class="login-right">
                    <div class="login-panel">
                        <div class="panel-head">
                            <div class="panel-sub">Member Login</div>
                            <h1 class="panel-title">로그인</h1>
                            <p class="panel-desc">
                                로그인 권한을 선택한 뒤 아이디와 비밀번호를 입력해 주세요.
                            </p>
                        </div>

                        <form action="/login" method="post" id="loginForm">
                            <input type="hidden" name="loginRole" id="loginRole" value="관리사무소">

                            <div class="form-group">
                                <label class="form-label" for="username">아이디</label>
                                <input type="text" id="username" name="username" class="form-control" placeholder="아이디를 입력하세요">
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="password">비밀번호</label>
                                <input type="password" id="password" name="password" class="form-control" placeholder="비밀번호를 입력하세요">
                            </div>

                            <div class="row-between">
                                <label class="check-wrap">
                                    <input type="checkbox" name="rememberId">
                                    <span>아이디 저장</span>
                                </label>

                                <div class="mini-links">
                                    <a href="${pageContext.request.contextPath}">아이디 찾기</a>
                                    <a href="${pageContext.request.contextPath}">비밀번호 찾기</a>
                                </div>
                            </div>

                            <button type="submit" class="loginBtn" id="loginBtn">로그인</button>
                            <sec:csrfInput/>
                        </form>

                        <div class="divider">또는</div>

                        <div class="join-box">
                            <p>
                                아직 회원이 아니신가요?<br>
                                회원가입 후 더 다양한 서비스를 이용할 수 있습니다.
                            </p>
                            <a href="${pageContext.request.contextPath}/join" class="join-link">회원가입</a>
                        </div>
                    </div>
                </section>

            </div>
        </div>
    </div>
</body>
</html>
