<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

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

    .material-symbols-outlined {
      font-family: 'Material Symbols Outlined' !important;
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
      letter-spacing: -.4px;
    }

    .page-desc {
      font-size: 13px;
      line-height: 1.8;
      color: var(--text-light);
      margin-bottom: 24px;
    }

    .panel,
    .card,
    .stat-card,
    .bill-card,
    .detail-panel {
      background: var(--white);
      border: 1px solid var(--border);
      border-radius: 14px;
      box-shadow: 0 10px 24px rgba(30, 60, 40, .05);
    }

    .panel,
    .card {
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

    .unit-grid {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 14px;
    }

    .unit-card {
      position: relative;
      width: 100%;
      min-height: 128px;
      padding: 18px 18px 16px;
      border: 1px solid var(--border);
      border-radius: 14px;
      background: #fff;
      text-align: left;
      cursor: pointer;
      transition: .16s ease;
      font-family: inherit;
    }

    .unit-card:hover {
      border-color: var(--green-dark);
      transform: translateY(-1px);
      box-shadow: 0 10px 22px rgba(30, 60, 40, .08);
    }

    .unit-card.active {
      border: 2px solid var(--green-dark);
      background: #f7fbf8;
    }

    .unit-card.active::after {
      content: "선택됨";
      position: absolute;
      top: 14px;
      right: 14px;
      padding: 5px 9px;
      border-radius: 999px;
      background: var(--green-dark);
      color: #fff;
      font-size: 11px;
      font-weight: 800;
    }

    .unit-apt {
      padding-right: 70px;
      margin-bottom: 10px;
      font-size: 12px;
      color: var(--text-light);
      line-height: 1.5;
    }

    .unit-dongho {
      font-size: 21px;
      font-weight: 800;
      color: var(--green-dark);
      line-height: 1.45;
      letter-spacing: -.5px;
    }

    .unit-meta {
      display: flex;
      flex-wrap: wrap;
      gap: 6px;
      margin-top: 12px;
    }

    .chip {
      display: inline-flex;
      align-items: center;
      padding: 5px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      background: #edf5ef;
      color: var(--green-dark);
    }

    .action-row {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      margin-top: 18px;
    }

    .btn-main,
    .btn-sub,
    .btn-ghost {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 110px;
      padding: 12px 18px;
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

    .btn-main:hover {
      filter: brightness(.94);
    }

    .btn-main:disabled,
    .btn-sub:disabled,
    .btn-ghost:disabled {
      opacity: .55;
      cursor: not-allowed;
    }

    .btn-sub {
      background: #edf5ef;
      color: var(--green-dark);
    }

    .btn-ghost {
      background: #fff;
      color: var(--text-mid);
      border: 1px solid var(--border);
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 14px;
      margin-bottom: 20px;
    }

    .stat-card {
      padding: 18px 18px 16px;
    }

    .stat-label {
      color: var(--text-light);
      font-size: 12px;
      margin-bottom: 8px;
    }

    .stat-value {
      font-size: 22px;
      font-weight: 800;
      color: var(--text-dark);
      letter-spacing: -.6px;
      line-height: 1.45;
      word-break: keep-all;
    }

    .stat-value.green {
      color: var(--green-dark);
    }

    .stat-value.red {
      color: #d71920;
    }

    .bill-toolbar {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .month-input {
      height: 40px;
      min-width: 152px;
      padding: 0 12px;
      border: 1px solid var(--border);
      border-radius: 10px;
      background: #fff;
      color: var(--text-dark);
      font-size: 13px;
      font-family: inherit;
      box-sizing: border-box;
    }

    .bill-layout {
      display: grid;
      grid-template-columns: 380px minmax(0, 1fr);
      gap: 16px;
    }

    .bill-list {
      display: flex;
      flex-direction: column;
      gap: 10px;
      max-height: 560px;
      overflow-y: auto;
      padding-right: 2px;
    }

    .bill-card {
      padding: 16px;
      cursor: pointer;
      transition: .15s ease;
      box-shadow: none;
    }

    .bill-card:hover {
      border-color: var(--green-dark);
      background: #fbfdfb;
    }

    .bill-card.active {
      border: 2px solid var(--green-dark);
      background: #f7fbf8;
    }

    .bill-card-top {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 10px;
      margin-bottom: 10px;
    }

    .bill-month {
      font-size: 16px;
      font-weight: 800;
      color: var(--green-dark);
    }

    .bill-amount {
      margin-bottom: 8px;
      font-size: 22px;
      font-weight: 800;
      color: var(--text-dark);
      letter-spacing: -.5px;
    }

    .bill-meta {
      display: flex;
      flex-wrap: wrap;
      gap: 6px 12px;
      font-size: 12px;
      color: var(--text-light);
      line-height: 1.6;
    }

    .badge {
      display: inline-flex;
      align-items: center;
      padding: 4px 10px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      white-space: nowrap;
    }

    .badge.READY {
      background: #edf4fb;
      color: #2d6688;
    }

    .badge.PAID {
      background: #ecf7ef;
      color: #2f7a4d;
    }

    .badge.UNPAID {
      background: #fff5df;
      color: #9a6b00;
    }

    .badge.OVERDUE {
      background: #fbe8e8;
      color: #a23a3a;
    }

    .detail-panel {
      overflow: hidden;
      min-height: 420px;
      box-shadow: none;
    }

    .detail-head {
      padding: 20px;
      border-bottom: 1px solid var(--border);
      background: #fbfdfb;
    }

    .detail-head h4 {
      margin: 0;
      font-size: 18px;
      font-weight: 800;
      color: var(--green-dark);
      letter-spacing: -.4px;
    }

    .detail-head p {
      margin: 7px 0 0;
      font-size: 12px;
      color: var(--text-light);
      line-height: 1.6;
    }

    .detail-body {
      padding: 20px;
    }

    .label-grid {
      display: grid;
      grid-template-columns: 130px 1fr 130px 1fr;
      border-top: 1px solid var(--border);
      border-left: 1px solid var(--border);
      overflow: hidden;
      border-radius: 12px;
      margin-bottom: 18px;
    }

    .label-grid div {
      padding: 12px 14px;
      border-right: 1px solid var(--border);
      border-bottom: 1px solid var(--border);
      font-size: 13px;
      line-height: 1.6;
      color: var(--text-dark);
      word-break: break-all;
    }

    .label-grid .th {
      background: var(--green-pale);
      color: var(--text-mid);
      font-weight: 700;
    }

    .data-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 13px;
      background: #fff;
      overflow: hidden;
      border-radius: 12px;
    }

    .data-table thead th {
      background: var(--green-pale);
      color: var(--text-mid);
      padding: 12px 14px;
      text-align: left;
      font-weight: 700;
      border-bottom: 1px solid var(--border);
    }

    .data-table tbody td {
      padding: 13px 14px;
      border-bottom: 1px solid #edf0eb;
      color: var(--text-dark);
      vertical-align: top;
    }

    .data-table tbody tr:last-child td {
      border-bottom: none;
    }

    .data-table .amount {
      text-align: right;
      font-weight: 800;
    }

    .total-box {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 14px;
      margin-top: 18px;
      padding: 16px 18px;
      border-radius: 12px;
      background: #f7fbf8;
      border: 1px solid var(--border);
    }

    .total-box .label {
      font-size: 13px;
      color: var(--text-mid);
      font-weight: 800;
    }

    .total-box .amount {
      font-size: 22px;
      font-weight: 800;
      color: var(--green-dark);
      letter-spacing: -.5px;
    }

    .empty-box {
      padding: 38px 20px;
      text-align: center;
      color: var(--text-light);
      border: 1px dashed #cfd7cf;
      border-radius: 14px;
      background: #fafcfb;
      line-height: 1.7;
      font-size: 13px;
    }

    .empty-box strong {
      display: block;
      margin-bottom: 6px;
      color: var(--text-dark);
      font-size: 15px;
      font-weight: 800;
    }

    .loading {
      display: none;
      padding: 16px 18px;
      margin-bottom: 18px;
      border-radius: 12px;
      background: #edf5ef;
      color: var(--green-dark);
      font-size: 13px;
      font-weight: 800;
      text-align: center;
    }

    .loading.show {
      display: block;
    }

    @media (max-width: 1200px) {
      .stats-grid {
        grid-template-columns: repeat(2, 1fr);
      }

      .bill-layout {
        grid-template-columns: 1fr;
      }

      .bill-list {
        max-height: none;
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

      .unit-grid,
      .stats-grid {
        grid-template-columns: 1fr;
      }

      .section-hd {
        align-items: flex-start;
        flex-direction: column;
      }

      .bill-toolbar {
        width: 100%;
      }

      .month-input {
        flex: 1;
      }

      .label-grid {
        grid-template-columns: 120px 1fr;
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

      <h1 class="page-title">관리비조회</h1>
      <p class="page-desc">
        입주민 본인에게 연결된 세대를 선택한 뒤 월별 관리비 고지 내역과 상세 정보를 확인할 수 있습니다.
      </p>

      <section class="panel">
        <div class="section-hd">
          <div>
            <h3>내 세대 선택</h3>
            <span>관리비를 조회할 세대를 선택해 주세요.</span>
          </div>
        </div>

        <div class="unit-grid" id="unitGrid">
          <div class="empty-box">
            <strong>세대 정보를 불러오는 중입니다.</strong>
            잠시만 기다려 주세요.
          </div>
        </div>

        <div class="action-row">
          <button type="button" class="btn-sub" id="btnReset">선택 초기화</button>
          <button type="button" class="btn-main" id="btnSearchBill">관리비 조회</button>
        </div>
      </section>

      <div class="loading" id="loadingBox">
        관리비 정보를 불러오는 중입니다.
      </div>

      <section id="resultSection" style="display:none;">

        <section class="stats-grid">
          <div class="stat-card">
            <div class="stat-label">선택 세대</div>
            <div class="stat-value green" id="summaryUnit">-</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">최근 고지월</div>
            <div class="stat-value" id="summaryRecentMonth">-</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">최근 청구금액</div>
            <div class="stat-value" id="summaryRecentAmount">-</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">미납/연체 건수</div>
            <div class="stat-value red" id="summaryUnpaidCount">0건</div>
          </div>
        </section>

        <section class="panel">
          <div class="section-hd">
            <div>
              <h3>월별 고지 내역</h3>
              <span>고지서를 선택하면 오른쪽에서 상세 정보를 확인할 수 있습니다.</span>
            </div>

            <div class="bill-toolbar">
              <input type="month" class="month-input" id="billYmInput" title="고지월 선택">
              <button type="button" class="btn-sub" id="btnMonthSearch">월별 조회</button>
            </div>
          </div>

          <div class="bill-layout">
            <div class="bill-list" id="billList">
              <div class="empty-box">
                <strong>조회된 고지서가 없습니다.</strong>
                세대를 선택한 후 관리비 조회 버튼을 눌러주세요.
              </div>
            </div>

            <div class="detail-panel">
              <div class="detail-head">
                <h4 id="detailTitle">상세 정보</h4>
                <p id="detailSubText">고지서를 선택하면 상세 정보가 표시됩니다.</p>
              </div>

              <div class="detail-body" id="detailBody">
                <div class="empty-box">
                  <strong>선택된 고지서가 없습니다.</strong>
                  왼쪽의 월별 고지 내역을 선택해 주세요.
                </div>
              </div>
            </div>
          </div>
        </section>

      </section>
    </div>
  </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
  const API_MY_HOUSE = '${pageContext.request.contextPath}/resident/bill/my-house';
  const API_BILL_LIST = '${pageContext.request.contextPath}/resident/bill/list';
  const API_BILL_DETAIL = '${pageContext.request.contextPath}/resident/bill/detail';

  let selectedUnit = null;
  let currentBills = [];

  const unitGrid = document.getElementById('unitGrid');
  const btnSearchBill = document.getElementById('btnSearchBill');
  const btnReset = document.getElementById('btnReset');
  const btnMonthSearch = document.getElementById('btnMonthSearch');
  const billYmInput = document.getElementById('billYmInput');

  const loadingBox = document.getElementById('loadingBox');
  const resultSection = document.getElementById('resultSection');

  const billList = document.getElementById('billList');
  const detailTitle = document.getElementById('detailTitle');
  const detailSubText = document.getElementById('detailSubText');
  const detailBody = document.getElementById('detailBody');

  const summaryUnit = document.getElementById('summaryUnit');
  const summaryRecentMonth = document.getElementById('summaryRecentMonth');
  const summaryRecentAmount = document.getElementById('summaryRecentAmount');
  const summaryUnpaidCount = document.getElementById('summaryUnpaidCount');

  document.addEventListener('DOMContentLoaded', function () {
    loadMyHouseList();
  });

  unitGrid.addEventListener('click', function (e) {
    const card = e.target.closest('.unit-card');
    if (!card) return;

    document.querySelectorAll('.unit-card').forEach(function (item) {
      item.classList.remove('active');
    });

    card.classList.add('active');
    selectedUnit = readUnitDataset(card);
    clearBillResult(true);
  });

  btnReset.addEventListener('click', function () {
    const cards = document.querySelectorAll('.unit-card');

    cards.forEach(function (item) {
      item.classList.remove('active');
    });

    if (cards.length > 0) {
      cards[0].classList.add('active');
      selectedUnit = readUnitDataset(cards[0]);
    } else {
      selectedUnit = null;
    }

    if (billYmInput) {
      billYmInput.value = '';
    }

    clearBillResult(true);
  });

  btnSearchBill.addEventListener('click', function () {
    searchBillList();
  });

  btnMonthSearch.addEventListener('click', function () {
    searchBillList();
  });

  function searchBillList() {
    if (!selectedUnit || !selectedUnit.searchHoNo) {
      alert('관리비를 조회할 세대를 선택해 주세요.');
      return;
    }

    const billYm = normalizeBillYm(billYmInput.value);
    loadBillList(selectedUnit, billYm);
  }

  async function loadMyHouseList() {
    try {
      unitGrid.innerHTML = renderEmpty('세대 정보를 불러오는 중입니다.', '잠시만 기다려 주세요.');

      const response = await fetch(API_MY_HOUSE, {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error('세대 목록 조회에 실패했습니다.');
      }

      const data = await response.json();

      if (!data.success) {
        throw new Error(data.message || '세대 목록 조회에 실패했습니다.');
      }

      renderHouseList(data.houseList || []);

    } catch (error) {
      console.error(error);
      unitGrid.innerHTML = renderEmpty(
              '세대 정보 조회 실패',
              '세대 정보를 불러오지 못했습니다. /resident/bill/my-house API 또는 로그인 정보를 확인해 주세요.'
      );
    }
  }

  function renderHouseList(houseList) {
    if (!houseList || houseList.length === 0) {
      unitGrid.innerHTML = renderEmpty(
              '등록된 세대 정보가 없습니다.',
              '로그인한 계정에 연결된 세대 정보가 없거나 세대 매핑이 필요합니다.'
      );

      selectedUnit = null;
      clearBillResult(true);
      return;
    }

    let html = '';

    houseList.forEach(function (house, index) {
      const aptName = getAptName(house);

      const rawDong = getRawDongNo(house);
      const rawHo = getRawHoNo(house);

      const displayDong = normalizeDongNo(rawDong, rawHo);
      const displayHo = normalizeHoNo(rawHo);

      /*
        API 조회용 hoNo는 컨트롤러/쿼리에서 쓰는 원본 값을 유지해야 함.
        화면 표시용은 2동 1107호처럼 보정.
      */
      const searchHoNo = rawHo || displayHo;

      html += ''
              + '<button type="button"'
              + '        class="unit-card ' + (index === 0 ? 'active' : '') + '"'
              + '        data-search-ho-no="' + escapeHtml(searchHoNo) + '"'
              + '        data-dong="' + escapeHtml(displayDong) + '"'
              + '        data-ho="' + escapeHtml(displayHo) + '"'
              + '        data-apt-name="' + escapeHtml(aptName) + '">'
              + '  <div class="unit-apt">' + escapeHtml(aptName) + '</div>'
              + '  <div class="unit-dongho">' + escapeHtml(displayDong) + '동 ' + escapeHtml(displayHo) + '호</div>'
              + '  <div class="unit-meta">'
              + '    <span class="chip">거주 세대</span>'
              + '  </div>'
              + '</button>';
    });

    unitGrid.innerHTML = html;

    const firstUnit = document.querySelector('.unit-card.active');
    if (firstUnit) {
      selectedUnit = readUnitDataset(firstUnit);
    }

    clearBillResult(true);
  }

  function readUnitDataset(card) {
    return {
      searchHoNo: card.dataset.searchHoNo,
      dong: card.dataset.dong,
      ho: card.dataset.ho,
      aptName: card.dataset.aptName
    };
  }

  async function loadBillList(unit, billYm) {
    showLoading(true);
    clearBillResult(false);

    try {
      let url = API_BILL_LIST + '?hoNo=' + encodeURIComponent(unit.searchHoNo);

      if (billYm) {
        url += '&billYm=' + encodeURIComponent(billYm);
      }

      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error('관리비 목록 조회에 실패했습니다.');
      }

      const data = await response.json();

      if (!data.success) {
        throw new Error(data.message || '관리비 목록 조회에 실패했습니다.');
      }

      currentBills = data.list || [];

      resultSection.style.display = 'block';

      renderSummary(unit, currentBills, data.latestBill, data.latestAmount);
      renderBillList(currentBills);

      if (currentBills.length > 0) {
        const firstBill = currentBills[0];
        await loadBillDetail(getBillNo(firstBill), firstBill);
      } else {
        resetDetail();
      }

    } catch (error) {
      console.error(error);

      resultSection.style.display = 'block';
      billList.innerHTML = renderEmpty(
              '관리비 목록 조회 실패',
              '관리비 정보를 불러오지 못했습니다. /resident/bill/list API 또는 hoNo 값을 확인해 주세요.'
      );

      resetDetail();
    } finally {
      showLoading(false);
    }
  }

  async function loadBillDetail(billNo, selectedBillFromList) {
    if (!billNo) {
      resetDetail();
      return;
    }

    setActiveBillItem(billNo);

    detailTitle.textContent = getBillMonth(selectedBillFromList) + ' 관리비 상세';
    detailSubText.textContent = '청구금액과 납부 상태를 확인할 수 있습니다.';
    detailBody.innerHTML = renderEmpty('상세 정보를 불러오는 중입니다.', '잠시만 기다려 주세요.');

    try {
      const response = await fetch(API_BILL_DETAIL + '/' + encodeURIComponent(billNo), {
        method: 'GET',
        headers: {
          'Accept': 'application/json'
        }
      });

      if (!response.ok) {
        throw new Error('관리비 상세 조회에 실패했습니다.');
      }

      const data = await response.json();

      if (!data.success) {
        throw new Error(data.message || '관리비 상세 조회에 실패했습니다.');
      }

      const bill = data.bill || selectedBillFromList || {};

      const detailList =
              bill.detailList ||
              bill.billDetailList ||
              bill.billDetailVOList ||
              bill.detailVOList ||
              [];

      renderBillDetail(bill, detailList);

    } catch (error) {
      console.error(error);

      detailBody.innerHTML = renderEmpty(
              '상세 조회 실패',
              '상세 정보를 불러오지 못했습니다. /resident/bill/detail/{billNo} API 또는 billNo 값을 확인해 주세요.'
      );
    }
  }

  function renderSummary(unit, bills, latestBill, latestAmount) {
    summaryUnit.textContent = (unit.dong || '-') + '동 ' + (unit.ho || '-') + '호';

    if (!bills || bills.length === 0) {
      summaryRecentMonth.textContent = '-';
      summaryRecentAmount.textContent = '-';
      summaryUnpaidCount.textContent = '0건';
      return;
    }

    const recent = latestBill || bills[0];

    const unpaidCount = bills.filter(function (bill) {
      const status = getPayStatusCode(bill);
      return status === 'UNPAID' || status === 'OVERDUE';
    }).length;

    summaryRecentMonth.textContent = formatBillYm(getBillMonth(recent));
    summaryRecentAmount.textContent = formatMoney(
            latestAmount !== undefined && latestAmount !== null ? latestAmount : getBillAmount(recent)
    );
    summaryUnpaidCount.textContent = unpaidCount + '건';
  }

  function renderBillList(bills) {
    if (!bills || bills.length === 0) {
      billList.innerHTML = renderEmpty(
              '조회된 고지서가 없습니다.',
              '선택한 세대의 관리비 고지 내역이 없습니다.'
      );
      resetDetail();
      return;
    }

    let html = '';

    bills.forEach(function (bill, index) {
      const billNo = getBillNo(bill);
      const month = formatBillYm(getBillMonth(bill));
      const amount = getBillAmount(bill);
      const statusCode = getPayStatusCode(bill);
      const statusName = getPayStatusName(statusCode);
      const dueDate = getDueDate(bill);
      const issueDate = getIssueDate(bill);

      html += ''
              + '<div class="bill-card ' + (index === 0 ? 'active' : '') + '" data-bill-no="' + escapeHtml(billNo) + '">'
              + '  <div class="bill-card-top">'
              + '    <div class="bill-month">' + escapeHtml(month) + '</div>'
              + '    <span class="badge ' + escapeHtml(statusCode) + '">' + escapeHtml(statusName) + '</span>'
              + '  </div>'
              + '  <div class="bill-amount">' + escapeHtml(formatMoney(amount)) + '</div>'
              + '  <div class="bill-meta">'
              + '    <span>고지일: ' + escapeHtml(issueDate) + '</span>'
              + '    <span>납부기한: ' + escapeHtml(dueDate) + '</span>'
              + '  </div>'
              + '</div>';
    });

    billList.innerHTML = html;

    document.querySelectorAll('.bill-card').forEach(function (item) {
      item.addEventListener('click', function () {
        const billNo = this.dataset.billNo;

        const bill = currentBills.find(function (row) {
          return String(getBillNo(row)) === String(billNo);
        });

        loadBillDetail(billNo, bill);
      });
    });
  }

  function renderBillDetail(bill, detailList) {
    const billNo = getBillNo(bill);
    const billYm = formatBillYm(getBillMonth(bill));
    const amount = getBillAmount(bill);
    const statusCode = getPayStatusCode(bill);
    const statusName = getPayStatusName(statusCode);
    const dueDate = getDueDate(bill);
    const issueDate = getIssueDate(bill);

    let html = '';

    html += '<div class="label-grid">';
    html += '  <div class="th">고지서 번호</div>';
    html += '  <div>' + escapeHtml(billNo || '-') + '</div>';
    html += '  <div class="th">고지월</div>';
    html += '  <div>' + escapeHtml(billYm || '-') + '</div>';
    html += '  <div class="th">고지일</div>';
    html += '  <div>' + escapeHtml(issueDate) + '</div>';
    html += '  <div class="th">납부기한</div>';
    html += '  <div>' + escapeHtml(dueDate) + '</div>';
    html += '  <div class="th">납부상태</div>';
    html += '  <div>' + escapeHtml(statusName) + '</div>';
    html += '  <div class="th">청구금액</div>';
    html += '  <div>' + escapeHtml(formatMoney(amount)) + '</div>';
    html += '</div>';

    if (detailList && detailList.length > 0) {
      let detailTotal = 0;

      html += '<table class="data-table">';
      html += '  <thead>';
      html += '    <tr>';
      html += '      <th>항목</th>';
      html += '      <th>구분</th>';
      html += '      <th style="text-align:right;">금액</th>';
      html += '    </tr>';
      html += '  </thead>';
      html += '  <tbody>';

      detailList.forEach(function (item) {
        const itemName = getValue(item, [
          'billItemNm', 'itemNm', 'expnNm', 'commonCodeNm', 'cdNm', 'billItemCd', 'expnCd'
        ], '관리비 항목');

        const itemCode = getValue(item, [
          'billItemCd', 'expnCd', 'itemCd', 'commonCode', 'cd'
        ], '-');

        const itemAmount = Number(getValue(item, [
          'amount', 'amt', 'billAmt', 'chargeAmt', 'itemAmt', 'dtlAmt', 'billDtlAmt'
        ], 0));

        detailTotal += itemAmount;

        html += '    <tr>';
        html += '      <td>' + escapeHtml(itemName) + '</td>';
        html += '      <td>' + escapeHtml(itemCode) + '</td>';
        html += '      <td class="amount">' + escapeHtml(formatMoney(itemAmount)) + '</td>';
        html += '    </tr>';
      });

      html += '  </tbody>';
      html += '</table>';

      html += '<div class="total-box">';
      html += '  <div class="label">상세 합계</div>';
      html += '  <div class="amount">' + escapeHtml(formatMoney(detailTotal)) + '</div>';
      html += '</div>';
    } else {
      html += renderEmpty(
              '상세 항목 리스트가 없습니다.',
              '현재 상세 API는 bill 객체만 반환하고 있습니다. 항목별 상세가 필요하면 BillVO에 detailList를 담아 내려줘야 합니다.'
      );

      html += '<div class="total-box">';
      html += '  <div class="label">총 청구금액</div>';
      html += '  <div class="amount">' + escapeHtml(formatMoney(amount)) + '</div>';
      html += '</div>';
    }

    detailBody.innerHTML = html;
  }

  function clearBillResult(hideResult) {
    currentBills = [];

    if (hideResult) {
      resultSection.style.display = 'none';
    }

    billList.innerHTML = renderEmpty(
            '조회된 고지서가 없습니다.',
            '세대를 선택한 후 관리비 조회 버튼을 눌러주세요.'
    );

    resetDetail();

    summaryUnit.textContent = '-';
    summaryRecentMonth.textContent = '-';
    summaryRecentAmount.textContent = '-';
    summaryUnpaidCount.textContent = '0건';
  }

  function resetDetail() {
    detailTitle.textContent = '상세 정보';
    detailSubText.textContent = '고지서를 선택하면 상세 정보가 표시됩니다.';
    detailBody.innerHTML = renderEmpty(
            '선택된 고지서가 없습니다.',
            '왼쪽의 월별 고지 내역을 선택해 주세요.'
    );
  }

  function setActiveBillItem(billNo) {
    document.querySelectorAll('.bill-card').forEach(function (item) {
      item.classList.toggle('active', String(item.dataset.billNo) === String(billNo));
    });
  }

  function showLoading(flag) {
    loadingBox.classList.toggle('show', flag);
    btnSearchBill.disabled = flag;
    btnMonthSearch.disabled = flag;
  }

  function renderEmpty(title, text) {
    return ''
            + '<div class="empty-box">'
            + '  <strong>' + escapeHtml(title) + '</strong>'
            + '  ' + escapeHtml(text)
            + '</div>';
  }

  function normalizeBillYm(value) {
    if (!value) return '';
    return String(value).replace('-', '');
  }

  function getAptName(obj) {
    const aptName = getValue(obj, ['aptCmplexNm', 'aptComplexNm', 'APT_CMPLEX_NM'], '');
    return aptName || '${aptInfo.aptComplexInfo.aptCmplexNm}' || '아파트 정보';
  }

  function getRawDongNo(obj) {
    return getValue(obj, ['dongNo', 'aptDong', 'dong', 'DONG_NO'], '');
  }

  function getRawHoNo(obj) {
    return getValue(obj, ['hoNo', 'aptHo', 'ho', 'HO_NO'], '');
  }

  function normalizeDongNo(rawDong, rawHo) {
    let value = rawDong || '';

    if (value && String(value).indexOf('_') > -1) {
      const arr = String(value).split('_');
      value = arr[arr.length - 1];
    }

    if ((!value || value === '-') && rawHo && String(rawHo).indexOf('_') > -1) {
      const arr = String(rawHo).split('_');

      if (arr.length >= 2) {
        value = arr[arr.length - 2];
      }
    }

    return value || '-';
  }

  function normalizeHoNo(rawHo) {
    let value = rawHo || '';

    if (value && String(value).indexOf('_') > -1) {
      const arr = String(value).split('_');
      value = arr[arr.length - 1];
    }

    return value || '-';
  }

  function getBillNo(bill) {
    return getValue(bill, ['billNo', 'BILL_NO', 'billSeq', 'mgmtBillNo', 'invoiceNo'], '');
  }

  function getBillMonth(bill) {
    return getValue(bill, ['billYm', 'BILL_YM', 'chrgYm', 'useYm', 'targetYm', 'issueYm', 'month'], '-');
  }

  function getBillAmount(bill) {
    return Number(getValue(bill, [
      'billTotAmt', 'BILL_TOT_AMT', 'totalAmt', 'billAmt', 'chargeAmt', 'totalAmount', 'mgmtFeeAmt', 'amount'
    ], 0));
  }

  function getPayStatusCode(bill) {
    return getValue(bill, [
      'pymtSttsCd', 'PYMT_STTS_CD', 'paySttsCd', 'payStatusCd', 'statusCd'
    ], 'READY');
  }

  function getDueDate(bill) {
    return formatDateText(getValue(bill, [
      'dueDate', 'payDueDate', 'pymntDueYmd', 'paymentDueDate', 'dueYmd'
    ], '-'));
  }

  function getIssueDate(bill) {
    return formatDateText(getValue(bill, [
      'issueDate', 'billIssueDate', 'issueYmd', 'regDate', 'billRegDate'
    ], '-'));
  }

  function getPayStatusName(code) {
    switch (code) {
      case 'READY':
        return '고지됨';
      case 'PAID':
        return '납부완료';
      case 'UNPAID':
        return '미납';
      case 'OVERDUE':
        return '연체';
      default:
        return code || '고지됨';
    }
  }

  function formatBillYm(value) {
    if (!value || value === '-') {
      return '-';
    }

    const str = String(value);

    if (/^\d{6}$/.test(str)) {
      return str.substring(0, 4) + '년 ' + str.substring(4, 6) + '월';
    }

    if (/^\d{4}-\d{2}$/.test(str)) {
      return str.substring(0, 4) + '년 ' + str.substring(5, 7) + '월';
    }

    return str;
  }

  function formatDateText(value) {
    if (!value || value === '-') {
      return '-';
    }

    const str = String(value);

    if (/^\d{8}$/.test(str)) {
      return str.substring(0, 4) + '-' + str.substring(4, 6) + '-' + str.substring(6, 8);
    }

    if (/^\d{6}$/.test(str)) {
      return str.substring(0, 4) + '-' + str.substring(4, 6);
    }

    return str;
  }

  function getValue(obj, keys, defaultValue) {
    if (!obj) return defaultValue;

    for (let i = 0; i < keys.length; i++) {
      const key = keys[i];

      if (obj[key] !== undefined && obj[key] !== null && obj[key] !== '') {
        return obj[key];
      }
    }

    return defaultValue;
  }

  function formatMoney(value) {
    const num = Number(value || 0);
    return num.toLocaleString('ko-KR') + '원';
  }

  function escapeHtml(value) {
    if (value === null || value === undefined) {
      return '';
    }

    return String(value)
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
  }
</script>
</body>
</html>