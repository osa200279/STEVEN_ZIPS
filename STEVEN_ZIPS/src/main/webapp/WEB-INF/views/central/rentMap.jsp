<%--
  Created by IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-11
  Time: 오후 2:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>임대 매물 지도</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/rentMap.css">
</head>
<body>

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<div class="rent-map-page detail-collapsed">

  <!-- 좌측 매물 리스트 패널 -->
  <aside class="rent-list-panel">
    <div class="rent-search-box">
      <h2>임대 매물</h2>
      <p>지도에서 공공주택 임대 매물을 확인하세요.</p>

      <div class="rent-filter-row">
        <button type="button" class="filter-btn active" data-type="ALL">전체</button>
        <button type="button" class="filter-btn" data-type="JEONSE">전세</button>
        <button type="button" class="filter-btn" data-type="MONTHLY">월세</button>
      </div>

      <input type="text"
             id="rentKeyword"
             class="rent-keyword"
             placeholder="단지명 또는 주소 검색">
    </div>

    <div id="rentList" class="rent-list">
      <!-- JS로 매물 카드 렌더링 -->
    </div>
  </aside>

  <!-- 중앙 상세 패널 -->
  <section class="rent-detail-panel" id="rentDetailPanel">

    <!-- 상세 패널 위에 항상 떠 있는 닫기 버튼 -->
    <button type="button"
            class="rent-detail-close-floating-btn"
            onclick="closeDetailPanel()">
      ×
    </button>

    <div id="rentDetail" class="rent-detail-empty">
      <h3>매물을 선택해 주세요</h3>
      <p>좌측 리스트 또는 지도 마커를 클릭하면 상세 정보가 표시됩니다.</p>
    </div>
  </section>

  <!-- 우측 지도 -->
  <section class="rent-map-panel">
    <div id="rentMap"></div>
  </section>

</div>

<%-- 카카오 지도 SDK 예시. 실제 앱키로 교체 필요 --%>
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04"></script>
<script src="${pageContext.request.contextPath}/js/central/rentMap.js"></script>
</body>
</html>
