<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>공공주택관리 시스템 소개</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Pretendard", "Noto Sans KR", "Malgun Gothic", sans-serif;
    }

    body {
      background: #ffffff;
      color: #1f1f1f;
    }

    a { text-decoration: none; color: inherit; }
    ul { list-style: none; }

    /* ── 사이드바(18rem) + 헤더(80px) 오프셋, 남은 공간 전부 사용 ── */
    .intro-wrap {
      margin-left: 18rem;
      padding-top: 80px;
      min-height: 100vh;
      background: #ffffff;
      width: calc(100% - 18rem);
    }

    /* 좌우 여백만 주는 inner (max-width 없음) */
    .inner {
      width: 100%;
      padding: 0 56px;
    }

    /* ── hero ── */
    .hero {
      position: relative;
      overflow: hidden;
      padding: 60px 0 80px;
      background: #f7f5f1;
    }

    .hero-inner {
      width: 100%;
      padding: 0 56px;
      min-height: 420px;
      display: flex;
      align-items: center;
      position: relative;
    }

    .hero-bg {
      position: absolute;
      top: 0;
      right: 0;
      width: 55%;
      height: 100%;
      background:
              linear-gradient(to right,
              rgba(247,245,241,1)   0%,
              rgba(247,245,241,.90) 20%,
              rgba(247,245,241,.35) 55%,
              rgba(247,245,241,.02) 100%),
              url("https://images.unsplash.com/photo-1511818966892-d7d671e672a2?auto=format&fit=crop&w=1600&q=80")
              no-repeat center center / cover;
    }

    .hero-content {
      position: relative;
      z-index: 2;
      width: 50%;
    }

    .hero-badge {
      display: inline-block;
      padding: 7px 16px;
      border-radius: 999px;
      background: #dcdcc6;
      color: #5d6f1f;
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 0.5px;
      margin-bottom: 24px;
    }

    .hero-title {
      font-size: 54px;
      line-height: 1.15;
      font-weight: 800;
      letter-spacing: -1.6px;
      margin-bottom: 22px;
    }

    .hero-title .point { color: #6b7c24; }

    .hero-desc {
      font-size: 17px;
      line-height: 1.85;
      color: #5f6266;
      word-break: keep-all;
    }

    /* ── summary box ── */
    .summary-box {
      position: relative;
      z-index: 3;
      margin: -28px 56px 0;
      background: #fff;
      border-radius: 20px;
      box-shadow: 0 12px 36px rgba(0,0,0,0.09);
      padding: 28px 36px;
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 0;
    }

    .summary-item {
      padding: 10px 28px;
      border-right: 1px solid #eee7dc;
    }

    .summary-item:first-child { padding-left: 10px; }
    .summary-item:last-child { border-right: none; }

    .summary-item .label {
      font-size: 12px;
      color: #8a8d91;
      margin-bottom: 8px;
      font-weight: 600;
    }

    .summary-item .value {
      font-size: 20px;
      font-weight: 800;
      color: #283018;
      line-height: 1.5;
    }

    /* ── section common ── */
    .section { padding: 80px 0; }

    .section-head {
      text-align: center;
      margin-bottom: 48px;
    }

    .section-head .mini {
      color: #6b7c24;
      font-size: 12px;
      font-weight: 700;
      letter-spacing: 1.5px;
      margin-bottom: 14px;
    }

    .section-head h2 {
      font-size: 38px;
      font-weight: 800;
      letter-spacing: -1px;
      margin-bottom: 16px;
    }

    .section-head p {
      font-size: 17px;
      color: #5f6266;
      line-height: 1.85;
      word-break: keep-all;
    }

    /* ── cards ── */
    .card-list {
      display: flex;
      gap: 24px;
    }

    .card {
      flex: 1;
      background: #f3f1ec;
      border-radius: 20px;
      padding: 36px 30px;
      min-height: 280px;
    }

    .card.highlight { background: #e8eee3; }

    .card-icon {
      width: 60px;
      height: 60px;
      border-radius: 16px;
      background: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 26px;
      margin-bottom: 22px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.06);
    }

    .card h3 {
      font-size: 24px;
      font-weight: 800;
      margin-bottom: 14px;
      letter-spacing: -0.5px;
    }

    .card p {
      font-size: 15px;
      color: #5f6266;
      line-height: 1.85;
      word-break: keep-all;
    }

    /* ── process ── */
    .process-wrap {
      display: flex;
      gap: 24px;
    }

    .process-step {
      flex: 1;
      background: #fff;
      border: 1px solid #ece5d9;
      border-radius: 20px;
      padding: 32px 28px;
    }

    .step-no {
      width: 42px;
      height: 42px;
      border-radius: 50%;
      background: #6b7c24;
      color: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 15px;
      font-weight: 800;
      margin-bottom: 20px;
    }

    .process-step h3 {
      font-size: 22px;
      font-weight: 800;
      margin-bottom: 12px;
    }

    .process-step p {
      font-size: 15px;
      color: #666;
      line-height: 1.85;
      word-break: keep-all;
    }

    /* ── feature banner ── */
    .feature-banner {
      background: linear-gradient(135deg, #6b7c24 0%, #889a3d 100%);
      color: #fff;
      border-radius: 24px;
      padding: 52px 58px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 40px;
    }

    .feature-banner h3 {
      font-size: 32px;
      font-weight: 800;
      line-height: 1.4;
      margin-bottom: 16px;
      letter-spacing: -0.6px;
    }

    .feature-banner p {
      font-size: 16px;
      line-height: 1.9;
      opacity: 0.95;
      word-break: keep-all;
    }

    .feature-tag {
      min-width: 200px;
      flex-shrink: 0;
      background: rgba(255,255,255,0.14);
      border: 1px solid rgba(255,255,255,0.22);
      border-radius: 18px;
      padding: 26px 28px;
    }

    .feature-tag strong {
      display: block;
      font-size: 16px;
      margin-bottom: 14px;
    }

    .feature-tag span {
      display: block;
      font-size: 15px;
      line-height: 2.1;
    }

    /* ── footer ── */
    .footer {
      border-top: 1px solid #e6e0d6;
      padding: 48px 0 28px;
      background: #ffffff;
      margin-top: 80px;
    }

    .footer-top {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      padding-bottom: 32px;
    }

    .footer-brand h3 {
      font-size: 26px;
      font-weight: 800;
      color: #5d6f1f;
      margin-bottom: 14px;
    }

    .footer-brand p {
      font-size: 14px;
      line-height: 1.9;
      color: #7a7d82;
    }

    .footer-menu-wrap {
      display: flex;
      gap: 72px;
    }

    .footer-menu h4 {
      font-size: 13px;
      margin-bottom: 14px;
      color: #1f1f1f;
      letter-spacing: 1px;
      font-weight: 700;
    }

    .footer-menu a {
      display: block;
      font-size: 14px;
      color: #8b8e94;
      margin-bottom: 10px;
    }

    .footer-bottom {
      border-top: 1px solid #e6e0d6;
      padding-top: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      color: #a0a3a9;
      font-size: 13px;
    }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebarStyle.jsp" %>

<div class="intro-wrap">

  <!-- hero -->
  <section class="hero">
    <div class="hero-inner">
      <div class="hero-bg"></div>
      <div class="hero-content">
        <span class="hero-badge">PUBLIC HOUSING TOTAL PLATFORM</span>
        <h2 class="hero-title">
          계약부터 관리까지,<br />
          <span class="point">공공주택의 모든 과정을 하나로</span>
        </h2>
        <p class="hero-desc">
          공공주택관리 시스템은 LH와 같은 공공임대주택 운영 방식을 기반으로,
          전·월세 계약 관리와 입주 이후 아파트 운영 서비스를 통합 제공하는
          주거 관리 플랫폼입니다.
        </p>
      </div>
    </div>
  </section>

  <!-- summary -->
  <div class="summary-box">
    <div class="summary-item">
      <div class="label">계약 관리</div>
      <div class="value">입주 신청<br />전자계약</div>
    </div>
    <div class="summary-item">
      <div class="label">입주민 서비스</div>
      <div class="value">민원 처리<br />공지 및 커뮤니티</div>
    </div>
    <div class="summary-item">
      <div class="label">단지 운영</div>
      <div class="value">시설 예약<br />점검 이력 관리</div>
    </div>
    <div class="summary-item">
      <div class="label">퇴거 정산</div>
      <div class="value">관리비 정산<br />보증금 반환 지원</div>
    </div>
  </div>

  <!-- service overview -->
  <section class="section">
    <div class="inner">
      <div class="section-head">
        <div class="mini">SERVICE OVERVIEW</div>
        <h2>공공주택의 전 과정을 연결하는 통합 서비스</h2>
        <p>
          입주 전 계약 업무부터 입주 후 생활 관리, 퇴거 시 정산까지 하나의 시스템에서 처리하여<br />
          관리 주체와 입주민 모두에게 편리하고 효율적인 주거 환경을 제공합니다.
        </p>
      </div>
      <div class="card-list">
        <div class="card">
          <div class="card-icon">📄</div>
          <h3>전·월세 계약 관리</h3>
          <p>입주 신청, 자격 검증, 계약 체결, 보증금 및 임대료 관리 등 공공임대주택의 계약 업무를 체계적으로 지원합니다.</p>
        </div>
        <div class="card highlight">
          <div class="card-icon">🏢</div>
          <h3>아파트 운영 관리</h3>
          <p>관리비 조회, 공지사항, 민원 접수, 차량 등록, 공용시설 예약 등 입주 후 필요한 생활 서비스를 통합 제공합니다.</p>
        </div>
        <div class="card">
          <div class="card-icon">💳</div>
          <h3>퇴거 및 정산 지원</h3>
          <p>미납 관리비, 시설 이용 내역, 보증금 반환 금액 등을 반영하여 퇴거 시 필요한 정산 업무까지 한 번에 처리할 수 있습니다.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- service flow -->
  <section class="section" style="padding-top: 10px; background: #f9f9f7;">
    <div class="inner">
      <div class="section-head">
        <div class="mini">SERVICE FLOW</div>
        <h2>입주 전부터 퇴거까지 이어지는 관리 흐름</h2>
        <p>
          공공주택관리 시스템은 단순 조회형 서비스가 아니라<br />
          주거 라이프사이클 전체를 연결하는 업무 중심 플랫폼입니다.
        </p>
      </div>
      <div class="process-wrap">
        <div class="process-step">
          <div class="step-no">01</div>
          <h3>입주 전</h3>
          <p>계약 공고 확인, 입주 신청, 자격 심사, 전자계약 체결 등 공공임대주택 입주를 위한 행정 절차를 처리합니다.</p>
        </div>
        <div class="process-step">
          <div class="step-no">02</div>
          <h3>입주 중</h3>
          <p>관리비 납부, 시설 예약, 민원 접수, 공지 확인, 커뮤니티 이용 등 실제 거주에 필요한 다양한 생활 서비스를 제공합니다.</p>
        </div>
        <div class="process-step">
          <div class="step-no">03</div>
          <h3>퇴거 시</h3>
          <p>사용 내역 확인, 정산 처리, 보증금 반환, 이력 보관 등을 통해 퇴거 절차를 명확하고 효율적으로 지원합니다.</p>
        </div>
      </div>
    </div>
  </section>

  <!-- feature banner -->
  <section class="section" style="padding-top: 80px;">
    <div class="inner">
      <div class="feature-banner">
        <div>
          <h3>공공임대 행정과 아파트 관리 서비스를<br />하나로 통합한 차별화된 플랫폼</h3>
          <p>
            일반적인 아파트 관리 시스템이 입주 이후 생활 편의 기능에 집중한다면,
            본 시스템은 전·월세 계약과 자격 관리, 행정 처리까지 포함하여
            공공주택 운영에 필요한 전체 업무를 폭넓게 지원합니다.
          </p>
        </div>
        <div class="feature-tag">
          <strong>핵심 차별점</strong>
          <span>계약 + 운영 + 정산</span>
          <span>공공주택 특화 서비스</span>
          <span>입주민 중심 통합 관리</span>
        </div>
      </div>
    </div>
  </section>

  <!-- footer -->
  <footer class="footer">
    <div class="inner">
      <div class="footer-top">
        <div class="footer-brand">
          <h3>우리집ON</h3>
          <p>
            공공주택 계약부터 입주민 생활 관리까지 하나로 연결하는 통합 플랫폼<br />
            프로젝트명 : 공공주택관리 시스템 | 기술 스택 : Spring Boot, React
          </p>
        </div>
        <div class="footer-menu-wrap">
          <div class="footer-menu">
            <h4>MENU</h4>
            <a href="#">서비스 소개</a>
            <a href="#">주요 기능</a>
            <a href="#">이용 안내</a>
          </div>
          <div class="footer-menu">
            <h4>PROJECT</h4>
            <a href="#">팀 소개</a>
            <a href="#">화면 설계</a>
            <a href="#">문의하기</a>
          </div>
        </div>
      </div>
      <div class="footer-bottom">
        <div>© 2026 공공주택관리 시스템. All rights reserved.</div>
        <div>Integrated Public Housing Management Platform</div>
      </div>
    </div>
  </footer>

</div><!-- /intro-wrap -->

</body>
</html>
