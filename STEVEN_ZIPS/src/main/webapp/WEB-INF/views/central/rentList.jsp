<%--
  Created by IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-11
  Time: 오후 8:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>매물 목록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

  <style>
    * {
      box-sizing: border-box;
    }

    body {
      margin: 0;
      font-family: "Pretendard", "Noto Sans KR", sans-serif;
      color: #17201b;
      background: #f8faf6;
    }

    .rent-list-wrap {
      margin-left: 280px;
      padding: 88px 100px 48px;
      min-height: 100vh;
    }

    .rent-list-container {
      max-width: 1580px;
      margin: 0 auto;
    }

    /* 상단 */
    .rent-list-top {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 24px;
      margin-bottom: 28px;
    }

    .rent-breadcrumb {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 12px;
      color: #98a2b3;
      font-size: 14px;
      font-weight: 500;
    }

    .rent-breadcrumb strong {
      color: #005f46;
      font-weight: 800;
    }

    .breadcrumb-arrow {
      color: #98a2b3;
      font-size: 20px;
      line-height: 1;
    }

    .rent-list-page-title {
      margin: 0 0 10px;
      font-size: 36px;
      line-height: 1.15;
      font-weight: 900;
      color: #0b1f17;
    }

    .rent-list-page-desc {
      margin: 0;
      font-size: 16px;
      color: #667085;
      line-height: 1.6;
    }

    .rent-map-move-btn {
      height: 48px;
      padding: 0 22px;
      border: 1px solid #e4e7ec;
      border-radius: 999px;
      background: #ffffff;
      color: #344054;
      font-size: 15px;
      font-weight: 800;
      cursor: pointer;
      box-shadow: 0 3px 10px rgba(16, 24, 40, 0.05);
      display: inline-flex;
      align-items: center;
      gap: 10px;
    }

    .rent-map-move-btn:hover {
      background: #f9fafb;
      border-color: #d0d5dd;
    }

    /* 검색/필터 */
    .rent-search-area {
      background: #ffffff;
      border-radius: 24px;
      padding: 24px;
      box-shadow: 0 8px 24px rgba(16, 24, 40, 0.06);
      margin-bottom: 24px;
    }

    .rent-search-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 18px;
      flex-wrap: wrap;
    }

    .rent-filter-group {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .filter-btn {
      border: 1px solid #d0d5dd;
      background: #ffffff;
      color: #344054;
      border-radius: 999px;
      padding: 10px 16px;
      font-size: 14px;
      font-weight: 700;
      cursor: pointer;
    }

    .filter-btn.active {
      background: #005f46;
      border-color: #005f46;
      color: #ffffff;
    }

    .rent-keyword-box {
      display: flex;
      align-items: center;
      gap: 10px;
      min-width: 340px;
      height: 46px;
      padding: 0 16px;
      border: 1px solid #d0d5dd;
      border-radius: 14px;
      background: #ffffff;
    }

    .rent-keyword-box input {
      width: 100%;
      border: none;
      outline: none;
      font-size: 14px;
      background: transparent;
    }

    .rent-summary-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin: 28px 0 18px;
    }

    .rent-summary-title {
      margin: 0;
      font-size: 24px;
      font-weight: 900;
    }

    .rent-summary-count {
      color: #667085;
      font-size: 15px;
    }

    .rent-summary-count strong {
      color: #005f46;
    }

    /* 카드 목록 */
    .rent-card-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 20px;
    }

    .rent-card {
      background: #ffffff;
      border: 1px solid #e5e7eb;
      border-radius: 24px;
      overflow: hidden;
      box-shadow: 0 8px 24px rgba(16, 24, 40, 0.05);
      transition: 0.2s ease;
    }

    .rent-card:hover {
      transform: translateY(-4px);
      border-color: #005f46;
      box-shadow: 0 14px 32px rgba(0, 95, 70, 0.14);
    }

    .rent-card-image {
      height: 190px;
      background-size: cover;
      background-position: center;
    }

    .rent-card-body {
      padding: 22px;
    }

    .rent-card-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      margin-bottom: 14px;
    }

    .rent-type-badge {
      display: inline-flex;
      align-items: center;
      padding: 6px 10px;
      border-radius: 999px;
      background: #e8f3ef;
      color: #005f46;
      font-size: 12px;
      font-weight: 800;
    }

    .rent-end-date {
      color: #667085;
      font-size: 13px;
    }

    .rent-card-title {
      margin: 0 0 10px;
      font-size: 21px;
      font-weight: 900;
      color: #0b1f17;
    }

    .rent-card-price {
      margin: 0 0 14px;
      color: #005f46;
      font-size: 24px;
      font-weight: 900;
    }

    .rent-card-info {
      margin: 0 0 8px;
      color: #344054;
      font-size: 14px;
      line-height: 1.6;
    }

    .rent-card-address {
      margin: 0;
      color: #667085;
      font-size: 14px;
      line-height: 1.6;
    }

    .rent-card-footer {
      display: flex;
      gap: 10px;
      margin-top: 20px;
    }

    .rent-detail-btn,
    .rent-map-btn {
      flex: 1;
      height: 44px;
      border-radius: 12px;
      font-size: 14px;
      font-weight: 800;
      cursor: pointer;
    }

    .rent-detail-btn {
      border: none;
      background: #005f46;
      color: #ffffff;
    }

    .rent-map-btn {
      border: 1px solid #d0d5dd;
      background: #ffffff;
      color: #344054;
    }

    .rent-detail-btn:hover {
      background: #004d39;
    }

    .rent-map-btn:hover {
      background: #f9fafb;
    }

    @media (max-width: 1400px) {
      .rent-list-wrap {
        margin-left: 280px;
        padding-left: 32px;
        padding-right: 32px;
      }

      .rent-card-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 900px) {
      .rent-list-top {
        flex-direction: column;
      }

      .rent-search-row {
        align-items: stretch;
      }

      .rent-keyword-box {
        min-width: 100%;
      }

      .rent-card-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<div class="rent-list-wrap">
  <div class="rent-list-container">

    <!-- 상단 -->
    <section class="rent-list-top">
      <div>
        <div class="rent-breadcrumb">
          <span>Home</span>
          <span class="breadcrumb-arrow">›</span>
          <span>매물정보</span>
          <span class="breadcrumb-arrow">›</span>
          <strong>매물 목록</strong>
        </div>

        <h1 class="rent-list-page-title">매물 목록</h1>
        <p class="rent-list-page-desc">
          공공주택 임대 매물을 한눈에 확인하고 원하는 매물의 상세정보를 조회할 수 있습니다.
        </p>
      </div>

      <button type="button"
              class="rent-map-move-btn"
              onclick="location.href='${pageContext.request.contextPath}/rent/map'">
        지도에서 보기
      </button>
    </section>

    <!-- 검색/필터 -->
    <section class="rent-search-area">
      <div class="rent-search-row">
        <div class="rent-filter-group">
          <button type="button" class="filter-btn active">전체</button>
          <button type="button" class="filter-btn">전세</button>
          <button type="button" class="filter-btn">월세</button>
        </div>

        <div class="rent-keyword-box">
          <span>⌕</span>
          <input type="text" placeholder="단지명 또는 주소 검색">
        </div>
      </div>
    </section>

    <!-- 목록 헤더 -->
    <div class="rent-summary-row">
      <h2 class="rent-summary-title">전체 매물</h2>
      <div class="rent-summary-count">
        총 <strong>3</strong>건
      </div>
    </div>

    <!-- 하드코딩 매물 목록 -->
    <section class="rent-card-grid">

      <!-- RENT001 -->
      <article class="rent-card">
        <div class="rent-card-image"
             style="background-image:url('https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1200');">
        </div>

        <div class="rent-card-body">
          <div class="rent-card-top">
            <span class="rent-type-badge">전세</span>
            <span class="rent-end-date">2026-05-31 마감</span>
          </div>

          <h3 class="rent-card-title">송파삼성래미안 101동</h3>
          <p class="rent-card-price">전세 10억 5,000</p>

          <p class="rent-card-info">84㎡ · 10층 · 1004호</p>
          <p class="rent-card-address">서울특별시 송파구 오금로32길 14</p>

          <div class="rent-card-footer">
            <button type="button"
                    class="rent-detail-btn"
                    onclick="location.href='${pageContext.request.contextPath}/rent/detail/RENT001'">
              상세보기
            </button>

            <button type="button"
                    class="rent-map-btn"
                    onclick="location.href='${pageContext.request.contextPath}/rent/map'">
              지도보기
            </button>
          </div>
        </div>
      </article>

      <!-- RENT002 -->
      <article class="rent-card">
        <div class="rent-card-image"
             style="background-image:url('https://images.unsplash.com/photo-1560518883-ce09059eeffa?q=80&w=1200');">
        </div>

        <div class="rent-card-body">
          <div class="rent-card-top">
            <span class="rent-type-badge">월세</span>
            <span class="rent-end-date">2026-05-20 마감</span>
          </div>

          <h3 class="rent-card-title">잠실5단지아파트 503동</h3>
          <p class="rent-card-price">보증금 5,000 / 월 120</p>

          <p class="rent-card-info">76㎡ · 8층 · 804호</p>
          <p class="rent-card-address">서울특별시 송파구 송파대로 567</p>

          <div class="rent-card-footer">
            <button type="button"
                    class="rent-detail-btn"
                    onclick="location.href='${pageContext.request.contextPath}/rent/detail/RENT002'">
              상세보기
            </button>

            <button type="button"
                    class="rent-map-btn"
                    onclick="location.href='${pageContext.request.contextPath}/rent/map'">
              지도보기
            </button>
          </div>
        </div>
      </article>

      <!-- RENT003 -->
      <article class="rent-card">
        <div class="rent-card-image"
             style="background-image:url('https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=1200');">
        </div>

        <div class="rent-card-body">
          <div class="rent-card-top">
            <span class="rent-type-badge">월세</span>
            <span class="rent-end-date">2026-05-28 마감</span>
          </div>

          <h3 class="rent-card-title">가락현대아파트 202동</h3>
          <p class="rent-card-price">보증금 3,000 / 월 95</p>

          <p class="rent-card-info">59㎡ · 6층 · 604호</p>
          <p class="rent-card-address">서울특별시 송파구 가락동</p>

          <div class="rent-card-footer">
            <button type="button"
                    class="rent-detail-btn"
                    onclick="location.href='${pageContext.request.contextPath}/rent/detail/RENT003'">
              상세보기
            </button>

            <button type="button"
                    class="rent-map-btn"
                    onclick="location.href='${pageContext.request.contextPath}/rent/map'">
              지도보기
            </button>
          </div>
        </div>
      </article>

    </section>
  </div>
</div>

</body>
</html>
