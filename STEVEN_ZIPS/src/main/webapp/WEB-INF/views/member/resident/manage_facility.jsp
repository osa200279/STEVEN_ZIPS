<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>시설관리이력 – 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

  <style>
    body {font-family: 'Noto Sans KR', sans-serif !important;background: var(--bg);color: var(--text-dark);margin: 0;}
    .material-symbols-outlined { font-family: 'Material Symbols Outlined' !important; }
    .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
    .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
    .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
    .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
    .breadcrumb a {color:var(--text-light);text-decoration:none;} .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
    .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
    .page-desc {font-size:13px;line-height:1.8;color:var(--text-light);margin-bottom:24px;}
    .hero-card,.card,.panel {background:var(--white);border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}    
    .hero-card {padding:24px 28px;margin-bottom:20px;background:linear-gradient(135deg,var(--green-dark),#386a4d);color:#fff;}
    .hero-card h2 {font-size:20px;margin:0 0 8px;letter-spacing:-.3px;} .hero-card p {margin:0;line-height:1.8;color:rgba(255,255,255,.82);font-size:13px;}
    .chip-row {display:flex;gap:8px;flex-wrap:wrap;margin-top:14px;} .chip {display:inline-flex;align-items:center;gap:4px;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;background:rgba(255,255,255,.18);color:#fff;}
    .stats-grid {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin-bottom:24px;} .stat-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:18px 18px 16px;}
    /* 주요 시설 점검 현황 카드 5개 가로 배치 */
    .status-card-wrap {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 14px;
      margin-top: 18px;
    }

    /* JS 페이징으로 숨기는 카드 */
    .status-card-item.is-hidden {
      display: none;
    }

    /* 초록색 영역 안 페이징 버튼 */
    .status-card-pagination {
      display: flex;
      justify-content: center;
      gap: 6px;
      margin-top: 18px;
    }

    .status-card-page-btn {
      min-width: 28px;
      height: 28px;
      border: 1px solid rgba(255,255,255,0.4);
      border-radius: 8px;
      background: rgba(255,255,255,0.15);
      color: #fff;
      font-size: 12px;
      font-weight: 800;
      cursor: pointer;
    }

    .status-card-page-btn.active {
      background: #fff;
      color: var(--green-dark);
    }
    .stat-label {color:var(--text-light);font-size:12px;margin-bottom:8px;} .stat-value {font-size:24px;font-weight:800;color:var(--green-dark);letter-spacing:-.6px;} .stat-sub {margin-top:6px;font-size:12px;color:var(--text-light);}
    .grid-2 {display:grid;grid-template-columns:1.2fr .8fr;gap:18px;margin-bottom:22px;} .grid-2.equal {grid-template-columns:1fr 1fr;} .grid-3 {display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:22px;}
    .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);} .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);} .section-hd span {font-size:12px;color:var(--text-light);} .card,.panel {padding:20px;margin-bottom:20px;}
    .bullet-list {margin:0;padding-left:18px;color:var(--text-mid);line-height:1.8;font-size:13px;} .bullet-list li + li {margin-top:6px;}
    .data-table {width:100%;border-collapse:collapse;font-size:13px;background:#fff;overflow:hidden;border-radius:12px;} .data-table thead th {background:var(--green-pale);color:var(--text-mid);padding:12px 14px;text-align:left;font-weight:700;border-bottom:1px solid var(--border);} .data-table tbody td {padding:13px 14px;border-bottom:1px solid #edf0eb;color:var(--text-dark);vertical-align:top;} .data-table tbody tr:last-child td {border-bottom:none;} .mini-table td,.mini-table th {padding:10px 12px !important;}
    .label-grid {display:grid;grid-template-columns:160px 1fr 160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;margin-bottom:18px;} .label-grid div {padding:13px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);font-size:13px;} .label-grid .th {background:var(--green-pale);color:var(--text-mid);font-weight:700;}
    .form-grid {display:grid;grid-template-columns:160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;} .form-grid .th,.form-grid .td {padding:14px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);} .form-grid .th {background:var(--green-pale);color:var(--text-mid);font-size:13px;font-weight:700;}
    .fake-input,.fake-select,.fake-textarea {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;} .fake-textarea {min-height:110px;resize:vertical;}
    .inline-fields {display:flex;gap:10px;flex-wrap:wrap;} .btn-row {display:flex;justify-content:center;gap:10px;margin-top:22px;flex-wrap:wrap;}
    .btn-main,.btn-sub,.btn-danger,.btn-ghost {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:none;cursor:pointer;box-sizing:border-box;} .btn-main {background:var(--green-dark);color:#fff;} .btn-sub {background:#edf5ef;color:var(--green-dark);} .btn-danger {background:#b64444;color:#fff;} .btn-ghost {background:#fff;color:var(--text-mid);border:1px solid var(--border);}
    .badge {display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:11px;font-weight:800;} .badge.ok {background:#ecf7ef;color:#2f7a4d;} .badge.wait {background:#fff5df;color:#9a6b00;} .badge.danger {background:#fbe8e8;color:#a23a3a;} .badge.info {background:#edf4fb;color:#2d6688;}
    .menu-grid {display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px;margin-bottom:24px;} .menu-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:20px;} .menu-card h4 {margin:0 0 8px;font-size:16px;color:var(--text-dark);} .menu-card p {margin:0 0 12px;font-size:13px;color:var(--text-light);line-height:1.7;} .menu-links {display:flex;flex-direction:column;gap:8px;} .menu-links a {text-decoration:none;color:var(--green-dark);font-size:13px;font-weight:700;}
    .seat-grid {display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-top:10px;} .room-grid {display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:10px;} .seat,.room-box {padding:16px 8px;text-align:center;border-radius:12px;font-weight:700;font-size:13px;border:1px solid var(--border);background:#fff;} .seat.available,.room-box.available {background:#f1f8f2;color:#2a6d44;} .seat.busy,.room-box.busy {background:#f8ecec;color:#9f4747;} .seat.selected,.room-box.selected {background:var(--green-dark);color:#fff;}
    .chart-box {height:240px;border:1px dashed #cfd7cf;border-radius:12px;background:linear-gradient(to top,rgba(43,103,78,.08),rgba(43,103,78,.02)),repeating-linear-gradient(to right,transparent 0 72px,rgba(0,0,0,.03) 72px 73px),repeating-linear-gradient(to bottom,transparent 0 47px,rgba(0,0,0,.04) 47px 48px);position:relative;overflow:hidden;} .chart-line {position:absolute;left:22px;right:22px;bottom:26px;top:28px;} .chart-line svg {width:100%;height:100%;}
    .chat-layout {display:grid;grid-template-columns:320px 1fr;gap:18px;} .chat-list,.chat-box {background:#fff;border:1px solid var(--border);border-radius:14px;} .chat-list {padding:16px;} .chat-box {padding:18px;} .chat-room-item {padding:12px 10px;border-radius:10px;cursor:pointer;border:1px solid transparent;} .chat-room-item.active {background:#f4f8f5;border-color:#d8e6db;} .message-stream {display:flex;flex-direction:column;gap:12px;min-height:320px;} .message {max-width:72%;padding:12px 14px;border-radius:14px;font-size:13px;line-height:1.7;} .message.me {align-self:flex-end;background:var(--green-dark);color:#fff;} .message.other {align-self:flex-start;background:#f2f4f0;color:var(--text-dark);}
    .search-row {display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px;} .search-row .fake-input,.search-row .fake-select {max-width:220px;} .notice-card {padding:18px 20px;border-radius:14px;background:linear-gradient(135deg,#fff8ea,#fff1d5);border:1px solid #f0dfb4;margin-bottom:18px;}
    .process-grid {display:grid;grid-template-columns:repeat(4,1fr);gap:14px;} .process-step {padding:18px 14px;border-radius:14px;border:1px solid var(--border);background:#fff;text-align:center;} .process-step.active {background:#eef8f0;border-color:#b8d9c0;}
    @media (max-width:1200px){.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid{grid-template-columns:repeat(2,1fr)} .grid-2,.grid-2.equal,.chat-layout{grid-template-columns:1fr} .label-grid{grid-template-columns:140px 1fr}}
    @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid,.seat-grid{grid-template-columns:1fr}.form-grid{grid-template-columns:120px 1fr}.label-grid{grid-template-columns:120px 1fr}}

    .facility-pagination {
      margin-top: 24px;
      display: flex;
      justify-content: center;
      gap: 8px;
    }

    .facility-pagination .page-link {
      min-width: 34px;
      height: 34px;
      padding: 0 12px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border: 1px solid var(--border);
      border-radius: 10px;
      color: var(--text-mid);
      text-decoration: none;
      font-size: 13px;
      font-weight: 800;
      background: #fff;
    }

    .facility-pagination .page-link.active {
      background: var(--green-dark);
      color: #fff;
      border-color: var(--green-dark);
    }


    .status-card-page-btn.active {
      background: #fff;
      color: var(--green-dark);
    }

    /* 검색 영역 */
    .facility-search-box {
      display: flex;
      gap: 10px;
      align-items: center;
      flex-wrap: wrap;
      margin-bottom: 16px;
    }

    /* 셀렉트 박스처럼 보이게 하는 영역 */
    .select-wrap {
      position: relative;
      width: 220px;
    }

    /* select란?
       → 여러 선택지 중 하나를 고르는 HTML 입력 요소.
       왜 사용?
       → 시설유형처럼 정해진 코드값 중 하나를 검색조건으로 보낼 때 사용.
    */
    .select-wrap select {
      width: 100%;
      height: 48px;
      appearance: none;
      -webkit-appearance: none;
      border: 1px solid #cfd8cf;
      border-radius: 12px;
      padding: 0 42px 0 14px;
      background: #fff;
      color: var(--text-dark);
      font-size: 13px;
      font-weight: 600;
      cursor: pointer;
    }

    /* 셀렉트박스 오른쪽 화살표 */
    .select-wrap::after {
      content: "⌄";
      position: absolute;
      right: 16px;
      top: 50%;
      transform: translateY(-56%);
      font-size: 18px;
      color: var(--green-dark);
      pointer-events: none;
    }

    .facility-search-input {
      width: 260px;
      height: 48px;
      border: 1px solid #cfd8cf;
      border-radius: 12px;
      padding: 0 14px;
      font-size: 13px;
      box-sizing: border-box;
    }

    /* 정렬 가능한 th */
    .sortable-th {
      cursor: pointer;
      user-select: none;
      white-space: nowrap;
    }

    .sortable-th::after {
      content: " ⇅";
      font-size: 11px;
      color: #8a968c;
    }

    /* 세부 검색 박스 */
    .history-detail-search {
      background: #f8fbf8;
      border: 1px solid var(--border);
      border-radius: 14px;
      padding: 18px;
      margin-bottom: 20px;
    }

    .history-detail-search-title {
      font-size: 14px;
      font-weight: 800;
      margin-bottom: 12px;
      color: var(--text-dark);
    }

    /* 주요 시설 점검 현황 전체 박스 높이 축소 */
    .hero-card {
      padding: 18px 28px 16px;
      margin-bottom: 16px;
    }

    /* 제목 크기 축소 */
    .hero-card h2 {
      font-size: 18px;
      margin-bottom: 6px;
    }

    /* 설명 문구 크기 축소 */
    .hero-card p {
      font-size: 12px;
      line-height: 1.6;
    }



    /* 시설 카드 세로 크기 축소 */
    .status-card-wrap .stat-card {
      min-height: 88px;
      padding: 14px 18px;
    }

    /* 시설명 글씨 */
    .status-card-wrap .stat-label {
      font-size: 12px;
      font-weight: 700;
      color: #253028;
      margin-bottom: 8px;
      letter-spacing: -0.2px;
    }

    /* DONE, FAULT, ING, 점검대기 글씨 */
    .status-card-wrap .stat-value {
      font-size: 18px;
      font-weight: 800;
      letter-spacing: -0.3px;
    }

    /* 최근 점검일 글씨 */
    .status-card-wrap .stat-sub {
      font-size: 11px;
    }

    /* 최근 점검 이력 없음 */
    .status-empty {
      color: #9ca3af !important;
    }

    /* 점검대기 */
    .status-wait {
      color: #c28b1e !important;
    }

    /* 점검중 */
    .status-ing {
      color: #4f6b95 !important;
    }

    /* 점검완료 */
    .status-done {
      color: #2d3130 !important;
    }

    /* 이상발견 */
    .status-fault {
      color: #b45454 !important;
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
          <a href="javascript:void(0);">관리사무소</a>
          <span>›</span>
          <span class="cur">시설관리이력</span>
        </div>
        <h1 class="page-title">시설관리이력</h1>

        <section class="hero-card">
          <h2>주요 시설 점검 현황</h2>
           <p>
             우리 아파트 주요 시설의 점검 현황과
             최근 유지보수 이력을 확인할 수 있습니다.
           </p>
            <div class="status-card-wrap" id="statusCardWrap">
              <c:forEach var="card" items="${statusCardList}">
                <div class="stat-card status-card-item">
                  <div class="stat-label">${card.facilityNm}</div>

                    <%-- 점검 상태별 색상 클래스 적용--%>
                  <c:set var="statusClass" value="status-empty" />

                  <c:choose>
                    <c:when test="${card.chkSttsCd eq 'WAIT'}">
                      <c:set var="statusClass" value="status-wait" />
                    </c:when>

                    <c:when test="${card.chkSttsCd eq 'ING'}">
                      <c:set var="statusClass" value="status-ing" />
                    </c:when>

                    <c:when test="${card.chkSttsCd eq 'DONE'}">
                      <c:set var="statusClass" value="status-done" />
                    </c:when>

                    <c:when test="${card.chkSttsCd eq 'FAULT'}">
                      <c:set var="statusClass" value="status-fault" />
                    </c:when>
                  </c:choose>

                  <div class="stat-value ${statusClass}">
                      <%-- 점검상태 코드 한글 변환
                      --%>
                    <c:choose>
                      <c:when test="${card.chkSttsCd eq 'WAIT'}">점검대기</c:when>
                      <c:when test="${card.chkSttsCd eq 'ING'}">점검중</c:when>
                      <c:when test="${card.chkSttsCd eq 'DONE'}">점검완료</c:when>
                      <c:when test="${card.chkSttsCd eq 'FAULT'}">이상발견</c:when>
                      <c:otherwise>최근이력없음</c:otherwise>
                    </c:choose>
                  </div>

                  <div class="stat-sub">
                    <c:choose>
                      <c:when test="${not empty card.chkDt}">
                        최근 점검 ${card.chkDt}
                      </c:when>
                      <c:otherwise>
                        최근 점검 이력 없음
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </c:forEach>
            </div>
          <div class="status-card-pagination" id="statusCardPagination"></div>
        </section>

        <section class="card">
          <div class="section-hd">

            <%-- 제목 + 단지명 영역 --%>
            <div>
              <h3 style="margin-bottom:4px;">
                우리 단지 시설정보
              </h3>

              <%-- 단지명
                   왜 분리?
                   → 제목 바로 아래에 단지명을 보여주기 위해.
              --%>
              <div style="font-size:13px; color:#6b7280; font-weight:600;">
                ${facilityAptInfo.aptCmplexNm}
              </div>
            </div>

            <%-- 시설정보 총 건수 --%>
            <div style="text-align:right;">
        <span style="font-size:12px; color:#7b837d;">
            총 ${facilityTotalRecord}건
        </span>
            </div>

          </div>
            <form method="get"
                  action="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}"
                  style="display:flex; gap:10px; margin-bottom:16px;">

              <%-- 정렬 조건
                   sortColumn: 어떤 컬럼으로 정렬할지
                   sortOrder : ASC=오름차순, DESC=내림차순  --%>
              <input type="hidden" name="sortColumn" id="sortColumn" value="${sortColumn}">
              <input type="hidden" name="sortOrder" id="sortOrder" value="${sortOrder}">
              <input type="hidden" name="facilityPage" id="facilityPage" value="${facilityPage}">

              <%-- facilityTyCd란?
                   → 시설유형코드.
              --%>
              <select name="facilityTyCd" class="fake-select" style="max-width:220px;">
                <option value="">전체 시설유형</option>
                <option value="ELV" ${facilityTyCd eq 'ELV' ? 'selected' : ''}>엘리베이터</option>
                <option value="GYM" ${facilityTyCd eq 'GYM' ? 'selected' : ''}>피트니스센터</option>
                <option value="SEC" ${facilityTyCd eq 'SEC' ? 'selected' : ''}>보안시설</option>
                <option value="PLAY" ${facilityTyCd eq 'PLAY' ? 'selected' : ''}>어린이 놀이시설</option>
                <option value="STUDY" ${facilityTyCd eq 'STUDY' ? 'selected' : ''}>독서실</option>
                <option value="PARK" ${facilityTyCd eq 'PARK' ? 'selected' : ''}>입주민 주차장</option>
                <option value="PARKING" ${facilityTyCd eq 'PARKING' ? 'selected' : ''}>방문자 주차구역</option>
                <option value="COMM" ${facilityTyCd eq 'COMM' ? 'selected' : ''}>커뮤니티시설</option>
                <option value="MEET" ${facilityTyCd eq 'MEET' ? 'selected' : ''}>주민회의실</option>
                <option value="WTR" ${facilityTyCd eq 'WTR' ? 'selected' : ''}>수도시설</option>
                <option value="ELC" ${facilityTyCd eq 'ELC' ? 'selected' : ''}>전기시설</option>
                <option value="GAS" ${facilityTyCd eq 'GAS' ? 'selected' : ''}>가스시설</option>
                <option value="FIRE" ${facilityTyCd eq 'FIRE' ? 'selected' : ''}>소방시설</option>
                <option value="ETC" ${facilityTyCd eq 'ETC' ? 'selected' : ''}>기타시설</option>
              </select>

              <button type="submit" class="btn-main" style="min-width:80px;">조회</button>

                <input type="text"
                       name="facilityNm"
                       class="fake-input"
                       value="${facilityNm}"
                       placeholder="시설명 검색"
                       style="max-width:220px;">

                <input type="text"
                       name="locCn"
                       class="fake-input"
                       value="${locCn}"
                       placeholder="상세위치 검색"
                       style="max-width:220px;">

            </form>
          <table class="data-table">
            <thead>
            <tr>
              <th class="sortable-th" data-column="facility_ty_cd">시설유형</th>
              <th class="sortable-th" data-column="facility_nm">시설명</th>
              <th class="sortable-th" data-column="dong_no">위치</th>
              <th class="sortable-th" data-column="loc_cn">상세위치</th>
            </tr>
            </thead>

            <tbody>
            <c:choose>
              <c:when test="${not empty facilityInfoList}">
                <c:forEach var="item" items="${facilityInfoList}">
                  <tr>
                    <td>
                        <%-- 시설유형 코드 한글 변환
                             왜 사용?
                             → DB에는 COMM, ELV 같은 코드값이 저장되어 있기 때문.
                             화면에서는 사용자가 이해하기 쉽게 한글로 변환해서 보여준다.
                        --%>
                      <c:choose>
                        <c:when test="${item.facilityTyCd eq 'COMM'}">
                          커뮤니티시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'ELV'}">
                          엘리베이터
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'GYM'}">
                          피트니스센터
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'SEC'}">
                          보안시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'PLAY'}">
                          어린이 놀이시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'STUDY'}">
                          독서실
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'PARK'}">
                          입주민 주차장
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'PARKING'}">
                          방문자 주차구역
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'MEET'}">
                          주민회의실
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'WTR'}">
                          수도시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'ELC'}">
                          전기시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'GAS'}">
                          가스시설
                        </c:when>
                        <c:when test="${item.facilityTyCd eq 'FIRE'}">
                          소방시설
                        </c:when>
                        <c:otherwise>
                          기타시설
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${item.facilityNm}</td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty item.dongNo}">
                          ${fn:substringAfter(item.dongNo, '_')}동
                        </c:when>
                        <c:otherwise>단지 공용</c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${not empty item.locCn}">
                          ${item.locCn}
                        </c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </c:when>

              <c:otherwise>
                <tr>
                  <td colspan="4" style="text-align:center; padding:40px;">
                    등록된 시설정보가 없습니다.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>

          <%-- 시설정보 페이징
     왜 필요?
     → 시설정보가 많아질 때 한 화면에 전부 보여주지 않고
       페이지 단위로 나누어 보여주기 위해 사용.
--%>
          <c:if test="${facilityTotalPage > 1}">
            <div class="facility-pagination">
              <c:forEach begin="1" end="${facilityTotalPage}" var="page">
                <a class="page-link ${facilityPage eq page ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?facilityPage=${page}&facilityTyCd=${facilityTyCd}&facilityNm=${facilityNm}&locCn=${locCn}&sortColumn=${sortColumn}&sortOrder=${sortOrder}">
                    ${page}
                </a>
              </c:forEach>
            </div>
          </c:if>

        </section>

        <section class="card">
          <div class="section-hd">
            <h3>시설 점검 상세 이력</h3>
            <span>총 ${totalRecord}건</span>
          </div>

          <table class="data-table">
            <thead>
            <tr>
              <th>점검일</th>
              <th>시설명</th>
              <th>점검내용</th>
              <th>상태</th>
              <th>담당자</th>
            </tr>
            </thead>

            <tbody>
            <c:choose>
              <c:when test="${not empty historyList}">
                <c:forEach var="history" items="${historyList}">
                  <tr>
                    <td>${history.chkDt}</td>
                    <td>${history.facilityNm}</td>
                    <td>${history.chkCn}</td>
                    <td>
                        <%-- 점검상태 코드별 배지 표시
                        --%>
                      <c:choose>
                        <c:when test="${history.chkSttsCd eq 'WAIT'}">
                          <span class="badge wait">점검대기</span>
                        </c:when>
                        <c:when test="${history.chkSttsCd eq 'ING'}">
                          <span class="badge info">점검중</span>
                        </c:when>
                        <c:when test="${history.chkSttsCd eq 'DONE'}">
                          <span class="badge ok">점검완료</span>
                        </c:when>
                        <c:when test="${history.chkSttsCd eq 'FAULT'}">
                          <span class="badge danger">이상발견</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge wait">점검대기</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${history.picNm}</td>
                  </tr>
                </c:forEach>
              </c:when>

              <c:otherwise>
                <tr>
                  <td colspan="5" style="text-align:center; padding:40px;">
                    등록된 시설 점검 이력이 없습니다.
                  </td>
                </tr>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
        </section>

        <%-- 페이징 처리 --%>
        <c:if test="${totalPage > 1}">
          <div class="facility-pagination">
            <c:forEach begin="1" end="${totalPage}" var="page">
              <a class="page-link ${currentPage eq page ? 'active' : ''}"
                 href="${pageContext.request.contextPath}/resident/manage/facility/${aptCmplexNo}?currentPage=${page}&facilityTyCd=${facilityTyCd}">
                  ${page}
              </a>
            </c:forEach>
          </div>
        </c:if>

      </div>
    </main>
  </div>
  <%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const cardList = Array.from(document.querySelectorAll(".status-card-item"));
        const pagination = document.getElementById("statusCardPagination");

        const pageSize = 5;
        const totalPage = Math.ceil(cardList.length / pageSize);

        function showPage(page) {
          cardList.forEach(function (card, index) {
            const startIndex = (page - 1) * pageSize;
            const endIndex = page * pageSize;

            if (index >= startIndex && index < endIndex) {
              card.classList.remove("is-hidden");
            } else {
              card.classList.add("is-hidden");
            }
          });

          document.querySelectorAll(".status-card-page-btn").forEach(function (btn) {
            btn.classList.remove("active");

            if (Number(btn.dataset.page) === page) {
              btn.classList.add("active");
            }
          });
        }

        if (cardList.length === 0) {
          return;
        }

        if (totalPage <= 1) {
          showPage(1);
          return;
        }

        for (let i = 1; i <= totalPage; i++) {
          const button = document.createElement("button");
          button.type = "button";
          button.className = "status-card-page-btn";
          button.dataset.page = i;
          button.innerText = i;

          button.addEventListener("click", function () {
            showPage(Number(this.dataset.page));
          });

          pagination.appendChild(button);
        }

        showPage(1);

        /*
 * 시설정보 테이블 정렬
 * 왜 사용?
 * → 사용자가 시설유형, 시설명, 위치, 상세위치 제목을 누르면
 *   해당 기준으로 오름차순/내림차순 조회하기 위해 사용.
 */
        document.querySelectorAll(".sortable-th").forEach(function (th) {
          th.addEventListener("click", function () {
            const clickedColumn = this.dataset.column;
            const sortColumnInput = document.getElementById("sortColumn");
            const sortOrderInput = document.getElementById("sortOrder");
            const facilityPageInput = document.getElementById("facilityPage");

            if (sortColumnInput.value === clickedColumn) {
              sortOrderInput.value = sortOrderInput.value === "ASC" ? "DESC" : "ASC";
            } else {
              sortColumnInput.value = clickedColumn;
              sortOrderInput.value = "ASC";
            }

            facilityPageInput.value = "1";
            this.closest("section").querySelector("form").submit();
          });
        });
      });
    </script>
</body>
</html>
