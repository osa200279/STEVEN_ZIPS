<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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

    .rent-card-body {
      padding: 26px 22px 22px;
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

    .rent-empty-box {
      grid-column: 1 / -1;
      padding: 70px 20px;
      text-align: center;
      background: #ffffff;
      border: 1px dashed #cbd5e1;
      border-radius: 24px;
      color: #667085;
      font-size: 16px;
      font-weight: 700;
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

    <section class="rent-search-area">
      <div class="rent-search-row">
        <div class="rent-filter-group">
          <button type="button" class="filter-btn active" data-type="ALL">전체</button>
          <button type="button" class="filter-btn" data-type="JS">전세</button>
          <button type="button" class="filter-btn" data-type="PE">월세</button>
        </div>

        <div class="rent-keyword-box">
          <span>⌕</span>
          <input type="text" id="rentKeyword" placeholder="단지명 또는 주소 검색">
        </div>
      </div>
    </section>

    <div class="rent-summary-row">
      <h2 class="rent-summary-title">전체 매물</h2>
      <div class="rent-summary-count">
        총 <strong id="rentCount"><c:out value="${empty rentList ? 0 : rentList.size()}" /></strong>건
      </div>
    </div>

    <section class="rent-card-grid" id="rentCardGrid">

      <c:choose>
        <c:when test="${empty rentList}">
          <div class="rent-empty-box">
            등록된 매물이 없습니다.
          </div>
        </c:when>

        <c:otherwise>
          <c:forEach var="rent" items="${rentList}">
            <article class="rent-card"
                     data-type="${rent.rentTypeCd}"
                     data-keyword="${rent.aptCmplexNm} ${rent.rentTtl} ${rent.dorojuso} ${rent.sidoNm} ${rent.sigunguNm} ${rent.emdNm}">

              <div class="rent-card-body">
                <div class="rent-card-top">
                  <span class="rent-type-badge">
                    <c:out value="${rent.rentTypeNm}" />
                  </span>

                  <span class="rent-end-date">
                    <c:choose>
                      <c:when test="${not empty rent.rcrtEndDt}">
                        <c:out value="${rent.rcrtEndDt}" /> 마감
                      </c:when>
                      <c:otherwise>상시 모집</c:otherwise>
                    </c:choose>
                  </span>
                </div>

                <h3 class="rent-card-title">
                  <c:out value="${rent.rentTtl}" />
                </h3>

                <p class="rent-card-price"
                   data-rent-type="${rent.rentTypeCd}"
                   data-dpst-amt="${rent.dpstAmt}"
                   data-monthly-amt="${rent.mthlyRentAmt}">
                </p>

                <p class="rent-card-info">
                  <c:out value="${rent.floor}" />층 ·
                  <c:out value="${rent.ho}" />호
                  <c:if test="${not empty rent['empty']}">
                    · <c:out value="${rent['empty']}" />
                  </c:if>
                </p>

                <p class="rent-card-address">
                  <c:out value="${rent.dorojuso}" />
                </p>

                <div class="rent-card-footer">
                  <button type="button"
                          class="rent-detail-btn"
                          onclick="location.href='${pageContext.request.contextPath}/rent/detail/${rent.rentLstgNo}'">
                    상세보기
                  </button>

                  <button type="button"
                          class="rent-map-btn"
                          onclick="location.href='${pageContext.request.contextPath}/rent/map?aptCmplexNo=${rent.aptCmplexNo}'">
                    지도보기
                  </button>
                </div>
              </div>
            </article>
          </c:forEach>
        </c:otherwise>
      </c:choose>

    </section>
  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    formatAllPrices();
    bindRentFilters();
  });

  function formatAllPrices() {
    document.querySelectorAll(".rent-card-price").forEach(function (el) {
      const rentTypeCd = el.dataset.rentType;
      const dpstAmt = Number(el.dataset.dpstAmt || 0);
      const monthlyAmt = Number(el.dataset.monthlyAmt || 0);

      if (rentTypeCd === "JS") {
        el.textContent = "전세 " + formatMoney(dpstAmt);
      } else if (rentTypeCd === "PE") {
        el.textContent = "보증금 " + formatMoney(dpstAmt) + " / 월 " + formatMoney(monthlyAmt);
      } else {
        el.textContent = formatMoney(dpstAmt);
      }
    });
  }

  function bindRentFilters() {
    const filterBtns = document.querySelectorAll(".filter-btn");
    const keywordInput = document.getElementById("rentKeyword");

    filterBtns.forEach(function (btn) {
      btn.addEventListener("click", function () {
        filterBtns.forEach(function (item) {
          item.classList.remove("active");
        });

        btn.classList.add("active");
        applyFilter();
      });
    });

    if (keywordInput) {
      keywordInput.addEventListener("input", applyFilter);
    }
  }

  function applyFilter() {
    const activeBtn = document.querySelector(".filter-btn.active");
    const selectedType = activeBtn ? activeBtn.dataset.type : "ALL";
    const keywordEl = document.getElementById("rentKeyword");
    const keyword = keywordEl ? keywordEl.value.trim().toLowerCase() : "";

    let visibleCount = 0;

    document.querySelectorAll(".rent-card").forEach(function (card) {
      const type = card.dataset.type;
      const searchText = (card.dataset.keyword || "").toLowerCase();

      const typeMatched = selectedType === "ALL" || type === selectedType;
      const keywordMatched = keyword === "" || searchText.includes(keyword);

      if (typeMatched && keywordMatched) {
        card.style.display = "";
        visibleCount++;
      } else {
        card.style.display = "none";
      }
    });

    document.getElementById("rentCount").textContent = visibleCount;
  }

  function formatMoney(value) {
    const num = Number(value || 0);

    if (num === 0) {
      return "0원";
    }

    const eok = Math.floor(num / 100000000);
    const man = Math.floor((num % 100000000) / 10000);

    if (eok > 0 && man > 0) {
      return eok + "억 " + man.toLocaleString() + "만";
    }

    if (eok > 0) {
      return eok + "억";
    }

    if (man > 0) {
      return man.toLocaleString() + "만";
    }

    return num.toLocaleString() + "원";
  }
</script>

</body>
</html>