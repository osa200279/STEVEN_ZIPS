<%--
  Created by IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-13
  Time: 오전 10:31
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/central/rentDetail.css">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<div class="rent-detail-layout">

  <main class="rent-detail-content">
    <div class="rent-detail-page">

      <div class="rent-detail-head">
        <nav class="rent-detail-breadcrumb" aria-label="breadcrumb">
          <a href="${pageContext.request.contextPath}/">Home</a>
          <span>›</span>
          <a href="${pageContext.request.contextPath}/rent/list">매물목록</a>
          <span>›</span>
          <strong>매물 상세</strong>
        </nav>

        <h1>매물 상세</h1>

        <p>
          공공주택 임대 매물의 단지정보, 면적정보, 가격정보를 한눈에 확인할 수 있습니다.
        </p>
      </div>

      <!-- 상단 매물 요약 -->
      <section class="detail-hero">

        <div class="detail-image-box">
          <img src="${pageContext.request.contextPath}/images/sample_apt.jpg"
               alt="매물 이미지"
               class="detail-main-image">
        </div>

        <div class="detail-summary">
          <span class="trade-badge">매매</span>

          <h2 class="detail-title">공덕동 현대아파트 31B평</h2>

          <div class="detail-price">
            21억 8,744만
          </div>

          <p class="detail-address">
            서울시 마포구 공덕동 370-9
          </p>

          <div class="summary-grid">
            <div>
              <span>공급/전용</span>
              <strong>31.1평 / 25.61평</strong>
            </div>
            <div>
              <span>층수</span>
              <strong>7층 / 15층</strong>
            </div>
            <div>
              <span>방/욕실</span>
              <strong>3개 / 1개</strong>
            </div>
            <div>
              <span>관리비</span>
              <strong>23만 999원</strong>
            </div>
          </div>
        </div>
      </section>


      <!-- 매물 기본 정보 -->
      <section class="detail-card">
        <div class="section-title-row">
          <h3>매물 정보</h3>
        </div>

        <div class="info-table">
          <div class="info-row">
            <div class="info-label">거래유형</div>
            <div class="info-value">매매</div>
            <div class="info-label">매매가</div>
            <div class="info-value price-text">21억 8,744만</div>
          </div>

          <div class="info-row">
            <div class="info-label">아파트명</div>
            <div class="info-value">공덕 현대아파트</div>
            <div class="info-label">평형</div>
            <div class="info-value">31B평</div>
          </div>

          <div class="info-row">
            <div class="info-label">공급/전용</div>
            <div class="info-value">31.1평 / 25.61평</div>
            <div class="info-label">전용률</div>
            <div class="info-value">82%</div>
          </div>

          <div class="info-row">
            <div class="info-label">방/욕실수</div>
            <div class="info-value">3개 / 1개</div>
            <div class="info-label">층수</div>
            <div class="info-value">7층 / 15층</div>
          </div>

          <div class="info-row">
            <div class="info-label">현관구조</div>
            <div class="info-value">계단식</div>
            <div class="info-label">입주가능일</div>
            <div class="info-value">협의 가능</div>
          </div>
        </div>
      </section>


      <!-- 단지 정보 -->
      <section class="detail-card">
        <div class="section-title-row">
          <h3>단지 정보</h3>
        </div>

        <div class="info-table">
          <div class="info-row">
            <div class="info-label">세대수</div>
            <div class="info-value">183세대(총 2개동)</div>
            <div class="info-label">저/최고층</div>
            <div class="info-value">7층 / 15층</div>
          </div>

          <div class="info-row">
            <div class="info-label">사용승인일</div>
            <div class="info-value">1989년 08월 07일</div>
            <div class="info-label">총주차대수</div>
            <div class="info-value">128대(세대당 0.69대)</div>
          </div>

          <div class="info-row">
            <div class="info-label">용적률</div>
            <div class="info-value">201%</div>
            <div class="info-label">건폐율</div>
            <div class="info-value">18%</div>
          </div>

          <div class="info-row full">
            <div class="info-label">건설사</div>
            <div class="info-value">현대건설</div>
          </div>

          <div class="info-row full">
            <div class="info-label">난방</div>
            <div class="info-value">개별난방, 도시가스</div>
          </div>

          <div class="info-row full">
            <div class="info-label">관리사무소</div>
            <div class="info-value">02-717-8181</div>
          </div>

          <div class="info-row full">
            <div class="info-label">주소</div>
            <div class="info-value">
              서울시 마포구 공덕동 370-9<br>
              <span class="road-badge">도로명</span>
              서울시 마포구 마포대로11길 73
            </div>
          </div>

          <div class="info-row full">
            <div class="info-label">면적</div>
            <div class="info-value">
              68㎡, 87A㎡, 87B㎡, 98㎡, 102A㎡, 102C㎡, 102B㎡
            </div>
          </div>
        </div>
      </section>


      <!-- 단지 내 면적별 정보 -->
      <section class="detail-card">
        <div class="section-title-row">
          <h3>단지 내 면적별 정보</h3>
        </div>

        <div class="area-tabs">
          <button type="button">20평</button>
          <button type="button">26A평</button>
          <button type="button">26B평</button>
          <button type="button">29평</button>
          <button type="button">30A평</button>
          <button type="button">30C평</button>
          <button type="button" class="active">31B평</button>
        </div>

        <div class="floor-plan-box">
          <img src="${pageContext.request.contextPath}/images/sample_floor_plan.png"
               alt="평면도"
               class="floor-plan-image">
        </div>

        <div class="info-table">
          <div class="info-row full">
            <div class="info-label">공급/전용</div>
            <div class="info-value">
              31.1평 / 25.61평 <span class="muted">(전용률 82%)</span>
            </div>
          </div>

          <div class="info-row full">
            <div class="info-label">방수/욕실수</div>
            <div class="info-value">3개 / 1개</div>
          </div>

          <div class="info-row full">
            <div class="info-label">해당면적 세대수</div>
            <div class="info-value">14세대</div>
          </div>

          <div class="info-row full">
            <div class="info-label">현관구조</div>
            <div class="info-value">계단식</div>
          </div>

          <div class="info-row full">
            <div class="info-label">해당면적 매물</div>
            <div class="info-value">등록된 매물이 없습니다.</div>
          </div>

          <div class="info-row full">
            <div class="info-label">관리비</div>
            <div class="info-value">
              <strong>21만 8,744원</strong>
              <span class="month-select">2026년 02월</span>

              <ul class="fee-list">
                <li>월평균 관리비 23만 999원</li>
                <li>하절기평균(6~8월) 관리비 25만 2,771원</li>
                <li>동절기평균(12~2월) 관리비 21만 6,559원</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

    </div>
  </main>
</div>
