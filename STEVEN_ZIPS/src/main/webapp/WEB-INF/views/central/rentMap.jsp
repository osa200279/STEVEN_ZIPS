<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>매물 정보 지도</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rentMap.css">
</head>
<body>

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<div class="rent-map-wrap with-sidebar">

  <!-- 상단 타이틀 영역 -->
  <section class="rent-map-top">
    <div class="rent-map-top-left">
      <div class="rent-breadcrumb">
        <span>Home</span>
        <span class="breadcrumb-arrow">›</span>
        <span>매물정보</span>
        <span class="breadcrumb-arrow">›</span>
        <strong>지도에서 보기</strong>
      </div>

      <h1 class="rent-map-page-title">매물 정보 지도</h1>

      <p class="rent-map-page-desc">
        지도에서 공공주택 임대 매물 위치를 확인하고 상세정보를 조회할 수 있습니다.
      </p>
    </div>

    <div class="rent-map-top-right">
      <button type="button"
              class="rent-list-move-btn"
              onclick="location.href='${pageContext.request.contextPath}/rent/list'">
        <span class="rent-list-icon">☰</span>
        매물 목록으로
      </button>
    </div>
  </section>

  <!-- 지도 + 상세정보 영역 -->
  <!-- 처음 진입 시 상세정보는 닫힌 상태 -->
  <div class="rent-map-page detail-collapsed">

    <!-- 상세 패널 -->
    <section class="rent-detail-panel" id="rentDetailPanel">

      <button type="button"
              class="rent-detail-close-floating-btn"
              onclick="closeDetailPanel()">
        ×
      </button>

      <div id="rentDetail" class="rent-detail-empty">
        <h3>매물을 선택해 주세요</h3>
        <p>지도 마커를 클릭하면 상세 정보가 표시됩니다.</p>
      </div>
    </section>

    <!-- 지도 -->
    <section class="rent-map-panel">
      <div id="rentMap"></div>
    </section>

  </div>
</div>

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04"></script>
<script src="${pageContext.request.contextPath}/js/central/rentMap.js"></script>
</body>
</html>