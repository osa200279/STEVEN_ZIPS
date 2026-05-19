<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>임대 매물 지도</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/central/rentMap.css">
</head>
<body>

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

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

  <!-- 지도 + 단지 매물목록 + 상세정보 영역 -->
  <div class="rent-map-page panels-collapsed">

    <!-- 좌측: 선택한 단지의 매물 목록 -->
    <aside class="rent-complex-list-panel" id="rentComplexListPanel">

      <div class="rent-complex-list-header">
        <div>
          <p class="rent-complex-list-label">선택 단지 매물</p>
          <h2 id="selectedComplexName">단지를 선택해 주세요</h2>
        </div>

        <button type="button"
                class="rent-panel-close-btn"
                onclick="closeRentPanels()">
          ×
        </button>
      </div>

      <div id="complexRentList" class="complex-rent-list">
        <div class="rent-empty-message">
          지도 마커를 클릭하면 해당 단지의 매물 목록이 표시됩니다.
        </div>
      </div>
    </aside>

    <!-- 가운데: 선택한 매물 상세정보 -->
    <section class="rent-detail-panel" id="rentDetailPanel">

      <div id="rentDetailHero" class="rent-detail-hero-area"></div>

      <div class="rent-detail-scroll">
        <div id="rentDetail" class="rent-detail-empty">
          <h3>매물을 선택해 주세요</h3>
          <p>왼쪽 매물 목록에서 항목을 클릭하면 상세정보가 표시됩니다.</p>
        </div>
      </div>

    </section>

    <!-- 우측: 지도 -->
    <section class="rent-map-panel">
      <div id="rentMap"></div>
    </section>

  </div>
</div>

<script>
  const CONTEXT_PATH = '${pageContext.request.contextPath}';
</script>

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04&libraries=services"></script>
<script src="${pageContext.request.contextPath}/js/central/rentMap.js?v=20260519_1"></script>
</body>
</html>