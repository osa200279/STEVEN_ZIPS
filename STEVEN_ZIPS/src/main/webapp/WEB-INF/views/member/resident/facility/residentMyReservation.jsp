<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>내 예약내역</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif !important;
      background: var(--bg);
      color: var(--text-dark);
      margin: 0;
    }

    .main-shell {
      display: flex;
      align-items: stretch;
      width: 100%;
      min-height: calc(100vh - 114px);
      margin-top: 114px;
      background: var(--bg);
    }

    .content-area {
      flex: 1;
      min-width: 0;
      padding: 32px 40px 64px;
    }

    .page-content-wrap {
      max-width: 1080px;
      width: 100%;
      margin: 0 auto;
    }

    .breadcrumb {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 12px;
      color: var(--text-light);
      margin-bottom: 18px;
    }

    .breadcrumb a {
      color: var(--text-light);
      text-decoration: none;
    }

    .breadcrumb .cur {
      color: var(--green-dark);
      font-weight: 700;
    }

    .page-title {
      font-size: 22px;
      font-weight: 800;
      color: var(--text-dark);
      padding-bottom: 14px;
      border-bottom: 2px solid var(--green-dark);
      margin-bottom: 16px;
    }

    .page-desc {
      font-size: 14px;
      color: var(--text-light);
      margin-bottom: 24px;
    }

    .pf-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
      margin-bottom: 18px;
    }

    .pf-card-hd {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 14px 18px;
      border-bottom: 1px solid var(--border);
      font-weight: 800;
      color: var(--text-dark);
    }

    .pf-card-bd {
      padding: 16px 18px;
    }

    .pf-search-grid {
      display: grid;
      grid-template-columns: repeat(6, 1fr) auto auto;
      gap: 10px;
      align-items: end;
    }

    .pf-field label {
      display: block;
      font-size: 12px;
      font-weight: 800;
      color: #374151;
      margin-bottom: 6px;
    }

    .pf-field input,
    .pf-field select {
      width: 100%;
      height: 38px;
      border: none;
      border-radius: 999px;
      padding: 0 14px;
      background: #eef2ef;
      font-size: 13px;
      box-sizing: border-box;
      outline: none;
    }

    .pf-btn {
      height: 38px;
      border: none;
      border-radius: 999px;
      padding: 0 18px;
      font-weight: 800;
      cursor: pointer;
      white-space: nowrap;
    }

    .pf-btn-primary {
      background: #006b4f;
      color: #fff;
    }

    .pf-btn-light {
      background: #66758d;
      color: #fff;
    }

    .pf-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
      background: #fff;
      border-radius: 12px;
      overflow: hidden;
    }

    .pf-table th {
      background: #f3f3f3;
      border-top: 2px solid #333;
      border-bottom: 1px solid var(--border);
      padding: 12px;
      text-align: center;
      color: #111827;
      font-weight: 800;
    }

    .pf-table td {
      border-bottom: 1px solid #edf0ed;
      padding: 12px;
      text-align: center;
      color: var(--text-dark);
    }

    .pf-badge {
      display: inline-block;
      min-width: 66px;
      padding: 4px 8px;
      border-radius: 999px;
      font-size: 12px;
      font-weight: 800;
      background: #edf4fb;
      color: #2d6688;
    }

    .pf-paging {
      display: flex;
      justify-content: center;
      margin-top: 18px;
    }

    .pagination {
      display: flex;
      gap: 4px;
      list-style: none;
      padding: 0;
    }

    .page-link {
      display: block;
      padding: 6px 10px;
      border: 1px solid var(--border);
      border-radius: 8px;
      color: var(--text-mid);
      text-decoration: none;
      background: #fff;
      font-weight: 800;
    }

    .page-item.active .page-link {
      background: var(--green-dark);
      color: #fff;
      border-color: var(--green-dark);
    }

    .pf-actions {
      display: flex;
      gap: 6px;
      justify-content: center;
    }

    .pf-modal {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,.35);
      z-index: 9999;
    }

    .pf-modal.is-open {
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .pf-modal-box {
      width: 620px;
      background: #fff;
      border-radius: 14px;
      padding: 20px;
    }

    .pf-modal-title {
      font-size: 18px;
      font-weight: 800;
      margin-bottom: 12px;
    }

    @media (max-width: 1200px) {
      .pf-search-grid {
        grid-template-columns: repeat(2, 1fr);
      }
    }

    @media (max-width: 900px) {
      .main-shell {
        flex-direction: column;
      }

      .content-area {
        padding: 24px 18px 48px;
      }

      .page-content-wrap {
        max-width: 100%;
      }

      .pf-search-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>

<body>

<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>

<div class="main-shell">

  <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>

  <main class="content-area">
    <div class="page-content-wrap">

      <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/">HOME</a>
        <span>›</span>
        <a href="javascript:void(0);">생활지원서비스</a>
        <span>›</span>
        <span class="cur">내 예약내역</span>
      </div>

      <h1 class="page-title">내 예약내역</h1>
      <p class="page-desc">단지 내 공용시설 예약 정보를 조회합니다.</p>

      <form id="searchForm" method="get" action="${pageContext.request.contextPath}/resident/publicFacility/myReservation">
        <div class="pf-card">
          <div class="pf-card-hd">검색 조건</div>

          <div class="pf-card-bd pf-search-grid">
            <div class="pf-field">
              <label>시설명</label>
              <input name="searchWord" value="${searchVO.searchWord}" placeholder="시설명/좌석명"/>
            </div>

            <div class="pf-field">
              <label>동</label>
              <input name="searchDongNo" value="${searchVO.searchDongNo}" placeholder="동"/>
            </div>

            <div class="pf-field">
              <label>상태</label>
              <select name="searchRsvtSttsCd">
                <option value="">전체</option>
                <option value="PENDING" ${searchVO.searchRsvtSttsCd eq 'PENDING' ? 'selected' : ''}>승인대기</option>
                <option value="APPROVED" ${searchVO.searchRsvtSttsCd eq 'APPROVED' ? 'selected' : ''}>승인완료</option>
                <option value="REJECTED" ${searchVO.searchRsvtSttsCd eq 'REJECTED' ? 'selected' : ''}>거절</option>
                <option value="CANCELLED" ${searchVO.searchRsvtSttsCd eq 'CANCELLED' ? 'selected' : ''}>취소</option>
              </select>
            </div>

            <div class="pf-field">
              <label>시작일</label>
              <input type="date" name="searchStartDt" value="${searchVO.searchStartDt}"/>
            </div>

            <div class="pf-field">
              <label>종료일</label>
              <input type="date" name="searchEndDt" value="${searchVO.searchEndDt}"/>
            </div>

            <div class="pf-field">
              <label>입주민명</label>
              <input name="searchUserNm" value="${searchVO.searchUserNm}" placeholder="이름"/>
            </div>

            <button type="button"
                    class="pf-btn pf-btn-light"
                    onclick="location.href='${pageContext.request.contextPath}/resident/publicFacility/myReservation'">
              초기화
            </button>

            <button class="pf-btn pf-btn-primary">
              검색
            </button>
          </div>
        </div>
      </form>

      <div class="pf-card">
        <div class="pf-card-hd">
          <span>내 예약내역 <b>${pagingVO.totalRecord}</b>건</span>
        </div>

        <div class="pf-card-bd">
          <table class="pf-table">
            <thead>
            <tr>
              <th>번호</th>
              <th>시설명</th>
              <th>세부시설</th>
              <th>예약시간</th>
              <th>상태</th>
              <th>관리</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach items="${pagingVO.dataList}" var="row" varStatus="st">
              <tr>
                <td>${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - st.index}</td>
                <td>${row.cmnFacilityNm}</td>
                <td>${row.itemNm}</td>
                <td>${row.rsvtBgngDttm} ~ ${row.rsvtEndDttm}</td>
                <td><span class="pf-badge">${row.rsvtSttsNm}</span></td>
                <td class="pf-actions">
                  <button class="pf-btn pf-btn-light" onclick="detailRsvt('${row.rsvtNo}')">상세</button>
                  <button class="pf-btn pf-btn-light" onclick="cancelRsvt('${row.rsvtNo}')">취소</button>
                </td>
              </tr>
            </c:forEach>

            <c:if test="${empty pagingVO.dataList}">
              <tr>
                <td colspan="6">조회된 데이터가 없습니다.</td>
              </tr>
            </c:if>
            </tbody>
          </table>

          <div class="pf-paging">${pagingVO.pagingHTML}</div>
        </div>
      </div>

      <div id="detailModal" class="pf-modal">
        <div class="pf-modal-box">
          <div class="pf-modal-title">예약 상세</div>
          <div id="detailBody"></div>

          <div class="pf-actions" style="margin-top:16px;">
            <button class="pf-btn pf-btn-light"
                    onclick="document.getElementById('detailModal').classList.remove('is-open')">
              닫기
            </button>
          </div>
        </div>
      </div>

    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
  document.addEventListener('click', function(e){
    const a = e.target.closest('.page-link');

    if(!a || !a.dataset.page) {
      return;
    }

    e.preventDefault();

    const form = document.getElementById('searchForm');
    const page = document.createElement('input');

    page.type = 'hidden';
    page.name = 'currentPage';
    page.value = a.dataset.page;

    form.appendChild(page);
    form.submit();
  });

  function detailRsvt(rsvtNo){
    fetch('${pageContext.request.contextPath}/resident/publicFacility/myReservation/' + rsvtNo)
            .then(function(response) {
              return response.json();
            })
            .then(function(d) {
              document.getElementById('detailBody').innerHTML =
                      '<p>시설명: ' + d.cmnFacilityNm + '</p>' +
                      '<p>세부시설: ' + d.itemNm + '</p>' +
                      '<p>예약시간: ' + d.rsvtBgngDttm + ' ~ ' + d.rsvtEndDttm + '</p>' +
                      '<p>상태: ' + d.rsvtSttsNm + '</p>';

              document.getElementById('detailModal').classList.add('is-open');
            });
  }

  function cancelRsvt(rsvtNo){
    if(!confirm('예약을 취소하시겠습니까?')) {
      return;
    }

    fetch('${pageContext.request.contextPath}/resident/publicFacility/myReservation/' + rsvtNo + '/cancel', {
      method: 'POST'
    }).then(function() {
      location.reload();
    });
  }
</script>

</body>
</html>