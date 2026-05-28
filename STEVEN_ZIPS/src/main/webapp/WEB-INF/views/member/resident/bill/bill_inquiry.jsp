<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

  <title>관리비 조회</title>

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
      max-width: 1120px;
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
      letter-spacing: -.4px;
    }

    .page-desc {
      font-size: 13px;
      line-height: 1.8;
      color: var(--text-light);
      margin-bottom: 24px;
    }

    .panel,
    .stat-card,
    .bill-card {
      background: var(--white);
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, .05);
    }

    .panel {
      padding: 20px;
      margin-bottom: 20px;
    }

    .section-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 14px;
      margin-bottom: 14px;
      padding-bottom: 10px;
      border-bottom: 1px solid var(--border);
    }

    .section-hd h3 {
      margin: 0;
      font-size: 15px;
      font-weight: 800;
      color: var(--text-dark);
    }

    .section-hd span {
      font-size: 12px;
      color: var(--text-light);
    }

    .search-box {
      padding: 16px;
      border: 1px solid var(--border);
      border-radius: 12px;
      background: #f8fafc;
    }

    .search-row {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 10px;
    }

    .search-row label {
      font-size: 13px;
      font-weight: 800;
      color: var(--text-dark);
    }

    .form-control {
      height: 38px;
      min-width: 120px;
      border: 1px solid #d8ddd4;
      background: #fff;
      border-radius: 10px;
      padding: 0 12px;
      font-size: 13px;
      font-family: inherit;
      box-sizing: border-box;
    }

    .house-select {
      min-width: 180px;
    }

    .btn-main,
    .btn-sub {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 100px;
      padding: 11px 16px;
      border-radius: 10px;
      font-size: 13px;
      font-weight: 800;
      text-decoration: none;
      border: none;
      cursor: pointer;
      box-sizing: border-box;
      font-family: inherit;
    }

    .btn-main {
      background: var(--green-dark);
      color: #fff;
    }

    .btn-sub {
      background: #edf5ef;
      color: var(--green-dark);
      border: 1px solid #cfdcd2;
    }

    .message-box {
      display: none;
      padding: 12px 14px;
      border-radius: 10px;
      font-size: 13px;
      font-weight: 800;
      margin-bottom: 16px;
    }

    .message-box.show {
      display: block;
    }

    .message-box.info {
      background: #eff6ff;
      color: #1d4ed8;
      border: 1px solid #bfdbfe;
    }

    .message-box.warn {
      background: #fffbeb;
      color: #92400e;
      border: 1px solid #fde68a;
    }

    .message-box.error {
      background: #fef2f2;
      color: #991b1b;
      border: 1px solid #fecaca;
    }

    .layout-grid {
      display: grid;
      grid-template-columns: 340px 1fr;
      gap: 18px;
      align-items: start;
    }

    .bill-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    .bill-card {
      padding: 18px;
      text-align: left;
      cursor: pointer;
      transition: .15s ease;
      border: 1px solid var(--border);
    }

    .bill-card:hover {
      border-color: var(--green-dark);
      transform: translateY(-1px);
    }

    .bill-card.active {
      border: 2px solid var(--green-dark);
      background: #f7fbf8;
    }

    .bill-card-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      margin-bottom: 12px;
    }

    .bill-month {
      font-size: 15px;
      font-weight: 800;
      color: var(--green-dark);
    }

    .bill-amount {
      font-size: 22px;
      font-weight: 900;
      color: #111827;
      margin-bottom: 10px;
    }

    .bill-meta {
      font-size: 12px;
      color: var(--text-light);
      line-height: 1.7;
    }

    .detail-panel {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, .05);
      overflow: hidden;
    }

    .detail-head {
      padding: 22px;
      border-bottom: 1px solid var(--border);
    }

    .detail-head h3 {
      margin: 0 0 8px;
      color: var(--green-dark);
      font-size: 18px;
      font-weight: 900;
    }

    .detail-head p {
      margin: 0;
      color: var(--text-light);
      font-size: 12px;
    }

    .detail-body {
      padding: 20px;
    }

    .info-table,
    .data-table {
      width: 100%;
      border: 1px solid #d8e7dc;
      border-radius: 12px;
      border-collapse: separate;
      border-spacing: 0;
      font-size: 13px;
      background: #fff;
    }

    .info-table {
      margin-bottom: 16px;
      border: 1px solid var(--border);
      border-radius: 10px;
      overflow: hidden;
    }

    .info-table th {
      width: 110px;
      background: #f3f8f4;
      color: var(--text-mid);
      font-weight: 800;
      text-align: center;
      padding: 12px 14px;
      border-bottom: 1px solid var(--border);
    }

    .info-table td {
      padding: 12px 14px;
      border-bottom: 1px solid var(--border);
      text-align: center;
      color: var(--text-dark);
    }

    /*
     * 관리비 상세 항목 테이블
     * - 항목 / 금액 2개 열만 사용
     * - 상세 합계 박스와 동일한 테두리 톤으로 카드 형태 적용
     * - 열이 2개뿐이므로 가운데 정렬된 컴팩트 너비 사용
     */
    .data-table {
      width: min(100%, 560px);
      margin: 0 auto;
      border: 1px solid #d8e7dc;
      border-radius: 12px;
      border-collapse: separate;
      border-spacing: 0;
      overflow: hidden;
    }

    .data-table thead th {
      background: #f3f8f4;
      color: var(--text-mid);
      padding: 13px 20px;
      font-weight: 800;
      border-bottom: 1px solid var(--border);
    }

    .data-table thead th:first-child {
      width: 62%;
      text-align: center;
    }

    .data-table thead th:last-child {
      width: 38%;
      text-align: center;
      padding-right: 24px;
    }

    .data-table tbody td {
      padding: 14px 20px;
      border-bottom: 1px solid #edf0eb;
      color: var(--text-dark);
      vertical-align: middle;
    }

    .data-table tbody tr:last-child td {
      border-bottom: 0;
    }

    .data-table tbody td:first-child {
      text-align: center;
      font-weight: 400;
    }

    .data-table tbody td:last-child {
      text-align: right;
      padding-right: 24px;
      font-weight: 800;
      color: var(--green-dark);
      white-space: nowrap;
    }

    .text-right {
      text-align: right !important;
    }

    .td-bold {
      font-weight: 800;
      color: var(--green-dark);
    }

    .empty {
      text-align: center;
      color: var(--text-light);
      padding: 32px 12px !important;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
    }

    .badge.ok {
      background: #ecf7ef;
      color: #2f7a4d;
    }

    .badge.wait {
      background: #fff5df;
      color: #9a6b00;
    }

    .badge.danger {
      background: #fbe8e8;
      color: #a23a3a;
    }

    .badge.info {
      background: #edf4fb;
      color: #2d6688;
    }

    .detail-total-box {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 14px;
      width: min(100%, 560px);
      margin: 18px auto 0;
      padding: 18px;
      border: 1px solid #d8e7dc;
      border-radius: 12px;
      background: #f8fcf9;
    }

    .detail-total-box span {
      font-size: 13px;
      font-weight: 800;
      color: var(--text-dark);
    }

    .detail-total-box strong {
      font-size: 24px;
      font-weight: 900;
      color: var(--green-dark);
    }

    @media (max-width: 1100px) {
      .layout-grid {
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
        <a href="javascript:void(0);">아파트관리비</a>
        <span>›</span>
        <span class="cur">관리비조회</span>
      </div>

      <h1 class="page-title">관리비 조회</h1>
      <p class="page-desc">내 세대의 월별 관리비 고지 내역과 상세 항목을 확인합니다.</p>

      <div id="messageBox" class="message-box"></div>

      <section class="panel">
        <div class="section-hd">
          <h3>조회 조건</h3>
          <span>세대 선택 후 관리년월을 조회하세요.</span>
        </div>

        <div class="search-box">
          <div class="search-row">
            <label for="myHouseSelect">내 세대</label>
            <select id="myHouseSelect" class="form-control house-select" onchange="onHouseChange()">
              <option value="">세대 정보 확인 중...</option>
            </select>

            <label for="billYear">연도</label>
            <select id="billYear" class="form-control"></select>

            <label for="billMonth">월</label>
            <select id="billMonth" class="form-control">
              <option value="1">1월</option>
              <option value="2">2월</option>
              <option value="3">3월</option>
              <option value="4">4월</option>
              <option value="5">5월</option>
              <option value="6">6월</option>
              <option value="7">7월</option>
              <option value="8">8월</option>
              <option value="9">9월</option>
              <option value="10">10월</option>
              <option value="11">11월</option>
              <option value="12">12월</option>
            </select>

            <button type="button" class="btn-main" onclick="loadMyBillList()">관리비 조회</button>
            <button type="button" class="btn-sub" onclick="resetBillView()">초기화</button>
          </div>
        </div>
      </section>

      <section class="layout-grid">
        <div class="bill-list" id="billHistoryList">
          <div class="empty panel">관리비 조회 버튼을 눌러 주세요.</div>
        </div>

        <div class="detail-panel">
          <div class="detail-head">
            <h3 id="detailTitle">관리비 상세</h3>
            <p>청구금액과 납부 상태를 확인할 수 있습니다.</p>
          </div>

          <div class="detail-body">
            <table class="info-table">
              <tbody>
              <tr>
                <th>고지서 번호</th>
                <td id="infoBillNo">-</td>
                <th>고지월</th>
                <td id="infoBillYm">-</td>
              </tr>
              <tr>
                <th>고지일</th>
                <td id="infoPblancDt">-</td>
                <th>납부기한</th>
                <td id="infoDueDt">-</td>
              </tr>
              <tr>
                <th>납부상태</th>
                <td id="infoStatus">-</td>
                <th>청구금액</th>
                <td id="infoBillTotAmt">0원</td>
              </tr>
              </tbody>
            </table>

            <table class="data-table">
              <thead>
              <tr>
                <th>항목</th>
                <th>금액</th>
              </tr>
              </thead>
              <tbody id="billDetailTbody">
              <tr>
                <td colspan="2" class="empty">왼쪽에서 고지서를 선택해 주세요.</td>
              </tr>
              </tbody>
            </table>

            <div class="detail-total-box">
              <span>상세 합계</span>
              <strong id="detailTotalAmt">0원</strong>
            </div>
          </div>
        </div>
      </section>

    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
  const contextPath = '${pageContext.request.contextPath}';

  let myHouseList = [];
  let selectedHouse = null;
  let currentBillList = [];

  document.addEventListener('DOMContentLoaded', function () {
    initBillSearchDate();
    loadMyHouseList();
    renderEmptyState();
  });

  function initBillSearchDate() {
    const now = new Date();
    const currentYear = now.getFullYear();
    const yearSelect = document.getElementById('billYear');

    yearSelect.innerHTML = '';

    for (let y = currentYear - 2; y <= currentYear + 1; y++) {
      const option = document.createElement('option');
      option.value = y;
      option.textContent = y + '년';

      if (y === currentYear) {
        option.selected = true;
      }

      yearSelect.appendChild(option);
    }

    document.getElementById('billMonth').value = now.getMonth() + 1;
  }

  function getBillYm() {
    const year = document.getElementById('billYear').value;
    const month = document.getElementById('billMonth').value;

    return String(year) + String(month).padStart(2, '0');
  }

  async function loadMyHouseList() {
    try {
      const response = await fetch(contextPath + '/resident/bill/my-houses');

      if (!response.ok) {
        showMessage('세대 목록 조회 중 오류가 발생했습니다. 상태코드: ' + response.status, 'error');
        renderHouseSelect([]);
        return;
      }

      const result = await response.json();

      if (!result.success) {
        showMessage(result.message || '세대 정보를 찾을 수 없습니다.', 'warn');
        renderHouseSelect([]);
        return;
      }

      myHouseList = result.houseList || [];
      renderHouseSelect(myHouseList);

      clearMessage();

    } catch (e) {
      console.error(e);
      showMessage('세대 목록 조회 중 오류가 발생했습니다.', 'error');
      renderHouseSelect([]);
    }
  }

  function renderHouseSelect(list) {
    const select = document.getElementById('myHouseSelect');
    select.innerHTML = '';

    if (!list || list.length === 0) {
      select.innerHTML = '<option value="">세대 정보 없음</option>';
      selectedHouse = null;
      return;
    }

    select.appendChild(new Option('세대 선택', ''));

    list.forEach(function (house) {
      const option = document.createElement('option');
      option.value = house.hoNo;
      option.textContent = house.displayDongHo || house.hoNo;
      select.appendChild(option);
    });

    if (list.length === 1) {
      select.value = list[0].hoNo;
      selectedHouse = list[0];
    }
  }

  function onHouseChange() {
    const hoNo = document.getElementById('myHouseSelect').value;

    selectedHouse = myHouseList.find(function (house) {
      return house.hoNo === hoNo;
    }) || null;

    currentBillList = [];
    renderEmptyState();
  }

  async function loadMyBillList() {
    clearMessage();

    if (!selectedHouse || !selectedHouse.hoNo) {
      showMessage('조회할 세대를 선택해 주세요.', 'warn');
      return;
    }

    const billYear = document.getElementById('billYear').value;

    if (!billYear) {
      showMessage('조회연도를 선택해 주세요.', 'warn');
      return;
    }

    try {
      const url = contextPath
              + '/resident/bill/year-list?hoNo=' + encodeURIComponent(selectedHouse.hoNo)
              + '&billYear=' + encodeURIComponent(billYear);

      const response = await fetch(url);

      if (!response.ok) {
        showMessage('관리비 조회 중 오류가 발생했습니다. 상태코드: ' + response.status, 'error');
        return;
      }

      const result = await response.json();

      if (!result.success) {
        renderEmptyState();
        showMessage(result.message || '관리비 조회에 실패했습니다.', 'error');
        return;
      }

      currentBillList = result.list || [];

      renderBillHistory(currentBillList);

      if (currentBillList.length > 0) {
        /*
         * XML에서 ORDER BY B.BILL_YM DESC 처리했으므로
         * 첫 번째 데이터가 해당 연도의 가장 최근 고지서이다.
         */
        await loadMyBillDetail(currentBillList[0].billNo);

        showMessage(
                billYear + '년 관리비 내역을 조회했습니다.',
                'info'
        );
      } else {
        renderNoYearBillFound(billYear);

        showMessage(
                billYear + '년에 등록된 관리비 고지서가 없습니다.',
                'warn'
        );
      }

    } catch (e) {
      console.error(e);
      showMessage('관리비 조회 중 오류가 발생했습니다.', 'error');
    }
  }

  async function loadMyBillDetail(billNo) {
    try {
      const response = await fetch(contextPath + '/resident/bill/detail/' + encodeURIComponent(billNo));

      if (!response.ok) {
        showMessage('관리비 상세 조회 중 오류가 발생했습니다. 상태코드: ' + response.status, 'error');
        return;
      }

      const result = await response.json();

      if (!result.success) {
        showMessage(result.message || '관리비 상세 조회에 실패했습니다.', 'error');
        return;
      }

      renderBillSummary(result.bill);
      renderBillDetail(result.bill);
      setActiveBillCard(billNo);

    } catch (e) {
      console.error(e);
      showMessage('관리비 상세 조회 중 오류가 발생했습니다.', 'error');
    }
  }

  function renderBillHistory(list) {
    const wrap = document.getElementById('billHistoryList');
    wrap.innerHTML = '';

    if (!list || list.length === 0) {
      wrap.innerHTML = '<div class="empty panel">조회된 관리비 내역이 없습니다.</div>';
      return;
    }

    list.forEach(function (bill) {
      const div = document.createElement('div');
      div.className = 'bill-card';
      div.dataset.billNo = bill.billNo;

      div.onclick = function () {
        loadMyBillDetail(bill.billNo);
      };

      div.innerHTML =
              '<div class="bill-card-top">' +
              '  <div class="bill-month">' + formatBillYm(bill.billYm) + '</div>' +
              '  ' + renderStatusBadge(bill.pymtSttsCd, bill.pymtSttsNm) +
              '</div>' +
              '<div class="bill-amount">' + formatNumber(bill.billTotAmt) + '원</div>' +
              '<div class="bill-meta">' +
              '  고지일: ' + formatDate(bill.billPblancDt) +
              ' · 납부기한: ' + formatDate(bill.dueDt) +
              '</div>';

      wrap.appendChild(div);
    });
  }

  function setActiveBillCard(billNo) {
    document.querySelectorAll('.bill-card').forEach(function (card) {
      card.classList.toggle('active', card.dataset.billNo === billNo);
    });
  }

  function renderBillSummary(bill) {
    if (!bill) {
      renderEmptyState();
      return;
    }

    document.getElementById('detailTitle').textContent =
            formatBillYm(bill.billYm) + ' 관리비 상세';

    document.getElementById('infoBillNo').textContent = bill.billNo || '-';
    document.getElementById('infoBillYm').textContent = formatBillYm(bill.billYm);
    document.getElementById('infoPblancDt').textContent = formatDate(bill.billPblancDt);
    document.getElementById('infoDueDt').textContent = formatDate(bill.dueDt);
    document.getElementById('infoStatus').textContent = bill.pymtSttsNm || bill.pymtSttsCd || '-';
    document.getElementById('infoBillTotAmt').textContent = formatNumber(bill.billTotAmt) + '원';
  }

  function renderBillDetail(bill) {
    const tbody = document.getElementById('billDetailTbody');
    tbody.innerHTML = '';

    const detailList = bill.detailList || [];
    let detailTotal = 0;

    if (detailList.length === 0) {
      tbody.innerHTML =
              '<tr><td colspan="2" class="empty">조회된 상세 항목이 없습니다.</td></tr>';
      document.getElementById('detailTotalAmt').textContent = '0원';
      return;
    }

    detailList.forEach(function (item) {
      const billItemAmt = Number(item.billItemAmt || 0);
      detailTotal += billItemAmt;

      const tr = document.createElement('tr');

      tr.innerHTML =
              '<td>' + escapeHtml(item.billItemNm || '-') + '</td>' +
              '<td class="text-right td-bold">' + formatNumber(billItemAmt) + '원</td>';

      tbody.appendChild(tr);
    });

    document.getElementById('detailTotalAmt').textContent =
            formatNumber(detailTotal) + '원';
  }

  function renderNoBillFound(billYm) {
    document.getElementById('detailTitle').textContent =
            formatBillYm(billYm) + ' 관리비 상세';

    document.getElementById('infoBillNo').textContent = '-';
    document.getElementById('infoBillYm').textContent = formatBillYm(billYm);
    document.getElementById('infoPblancDt').textContent = '-';
    document.getElementById('infoDueDt').textContent = '-';
    document.getElementById('infoStatus').textContent = '-';
    document.getElementById('infoBillTotAmt').textContent = '0원';

    document.getElementById('billDetailTbody').innerHTML =
            '<tr><td colspan="2" class="empty">해당 월 관리비 고지서가 없습니다.</td></tr>';

    document.getElementById('detailTotalAmt').textContent = '0원';
  }

  function renderEmptyState() {
    document.getElementById('detailTitle').textContent = '관리비 상세';

    document.getElementById('infoBillNo').textContent = '-';
    document.getElementById('infoBillYm').textContent = '-';
    document.getElementById('infoPblancDt').textContent = '-';
    document.getElementById('infoDueDt').textContent = '-';
    document.getElementById('infoStatus').textContent = '-';
    document.getElementById('infoBillTotAmt').textContent = '0원';

    document.getElementById('billHistoryList').innerHTML =
            '<div class="empty panel">관리비 조회 버튼을 눌러 주세요.</div>';

    document.getElementById('billDetailTbody').innerHTML =
            '<tr><td colspan="2" class="empty">왼쪽에서 고지서를 선택해 주세요.</td></tr>';

    document.getElementById('detailTotalAmt').textContent = '0원';
  }

  function resetBillView() {
    initBillSearchDate();
    clearMessage();

    currentBillList = [];

    if (myHouseList.length !== 1) {
      document.getElementById('myHouseSelect').value = '';
      selectedHouse = null;
    }

    renderEmptyState();
  }

  function renderStatusBadge(code, name) {
    const statusName = name || code || '-';
    let cls = 'badge info';

    if (code === 'PAID') {
      cls = 'badge ok';
    } else if (code === 'READY' || code === 'UNPAID') {
      cls = 'badge wait';
    } else if (code === 'OVERDUE') {
      cls = 'badge danger';
    }

    return '<span class="' + cls + '">' + escapeHtml(statusName) + '</span>';
  }

  function showMessage(message, type) {
    const box = document.getElementById('messageBox');
    box.className = 'message-box show ' + (type || 'info');
    box.textContent = message;
  }

  function clearMessage() {
    const box = document.getElementById('messageBox');
    box.className = 'message-box';
    box.textContent = '';
  }

  function formatNumber(value) {
    const num = Number(value);

    if (isNaN(num)) {
      return '0';
    }

    return num.toLocaleString();
  }

  function formatBillYm(value) {
    if (!value || String(value).length !== 6) {
      return '-';
    }

    const str = String(value);
    return str.substring(0, 4) + '년 ' + Number(str.substring(4, 6)) + '월';
  }

  function formatDate(value) {
    if (!value) {
      return '-';
    }

    const date = new Date(value);

    if (isNaN(date.getTime())) {
      return value;
    }

    return date.getFullYear() + '-'
            + String(date.getMonth() + 1).padStart(2, '0') + '-'
            + String(date.getDate()).padStart(2, '0');
  }

  function escapeHtml(value) {
    return String(value)
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
  }

  function renderNoYearBillFound(billYear) {
    document.getElementById('billHistoryList').innerHTML =
            '<div class="empty panel">' + escapeHtml(billYear) + '년에 등록된 관리비 내역이 없습니다.</div>';

    document.getElementById('detailTitle').textContent =
            billYear + '년 관리비 상세';

    document.getElementById('infoBillNo').textContent = '-';
    document.getElementById('infoBillYm').textContent = '-';
    document.getElementById('infoPblancDt').textContent = '-';
    document.getElementById('infoDueDt').textContent = '-';
    document.getElementById('infoStatus').textContent = '-';
    document.getElementById('infoBillTotAmt').textContent = '0원';

    document.getElementById('billDetailTbody').innerHTML =
            '<tr><td colspan="2" class="empty">조회된 관리비 상세 내역이 없습니다.</td></tr>';

    document.getElementById('detailTotalAmt').textContent = '0원';
  }

</script>

</body>
</html>