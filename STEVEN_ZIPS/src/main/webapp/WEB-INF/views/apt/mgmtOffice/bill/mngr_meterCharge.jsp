<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>세대 검침 관리</title>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet">

  <style>
    .meter-page .form-row {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 10px;
    }

    .meter-page label {
      font-weight: 800;
      color: var(--text-primary);
    }

    .meter-page input,
    .meter-page select {
      height: 36px;
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      padding: 0 10px;
      font-family: inherit;
      font-size: 13px;
      background: #fff;
    }

    .meter-page input[type="number"] {
      width: 120px;
    }

    /* 세대별 현재 검침값 입력 */
    .meter-page .meter-current-input {
      width: 112px !important;
      height: 34px;
      text-align: right;
      font-weight: 800;
      color: var(--text-primary);
      border: 1px solid #cbd5e1;
      background: #fff;
    }

    .meter-page .meter-current-input:focus {
      outline: none;
      border-color: #356859;
      box-shadow: 0 0 0 3px rgba(53, 104, 89, 0.13);
    }

    .meter-page .meter-current-input.input-error {
      border-color: #dc2626;
      background: #fef2f2;
    }

    .meter-page .input-guide {
      display: flex;
      align-items: center;
      gap: 6px;
      margin-top: 14px;
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 700;
    }

    .meter-page .input-guide .material-symbols-rounded {
      font-size: 17px;
      color: #356859;
    }

    .meter-page .summary-grid {
      display: grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap: 14px;
      margin-bottom: 20px;
    }

    .meter-page .summary-card {
      background: #fff;
      border: 1px solid var(--border);
      border-radius: var(--r-md);
      padding: 16px 18px;
    }

    .meter-page .summary-label {
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 700;
      margin-bottom: 8px;
    }

    .meter-page .summary-value {
      font-size: 24px;
      font-weight: 800;
      color: var(--text-primary);
      line-height: 1.2;
    }

    .meter-page .summary-sub {
      margin-top: 6px;
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 600;
    }

    .meter-page .text-right {
      text-align: right;
    }

    .meter-page .td-bold {
      font-weight: 800;
      color: var(--text-primary);
    }

    .meter-page .empty {
      color: var(--text-tertiary);
      text-align: center;
      padding: 30px;
    }

    .meter-page .badge-meter {
      display: inline-flex;
      align-items: center;
      padding: 3px 9px;
      border-radius: 999px;
      font-size: 11px;
      font-weight: 800;
      border: 1px solid var(--border);
      white-space: nowrap;
    }

    .meter-page .badge-elc {
      background: #eff6ff;
      color: #1d4ed8;
      border-color: #bfdbfe;
    }

    .meter-page .badge-wtr {
      background: #ecfeff;
      color: #0e7490;
      border-color: #a5f3fc;
    }

    .meter-page .badge-gas {
      background: #fff7ed;
      color: #c2410c;
      border-color: #fed7aa;
    }

    .meter-page .message-box {
      display: none;
      padding: 12px 14px;
      border-radius: var(--r-sm);
      font-size: 13px;
      font-weight: 700;
      margin-bottom: 16px;
    }

    .meter-page .message-box.show {
      display: block;
    }

    .meter-page .message-box.info {
      background: #eff6ff;
      border: 1px solid #bfdbfe;
      color: #1d4ed8;
    }

    .meter-page .message-box.warn {
      background: #fffbeb;
      border: 1px solid #fde68a;
      color: #92400e;
    }

    .meter-page .message-box.error {
      background: #fef2f2;
      border: 1px solid #fecaca;
      color: #991b1b;
    }

    .meter-page .filter-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      margin-bottom: 12px;
    }

    .meter-page .filter-group {
      display: flex;
      flex-wrap: wrap;
      align-items: center;
      gap: 8px;
    }

    .meter-page .filter-group select,
    .meter-page .filter-group input {
      height: 34px;
      font-size: 13px;
    }

    .meter-page .filter-group input[type="text"] {
      width: 160px;
    }

    .meter-page .table-info {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-secondary);
    }

    .meter-page .table-wrap {
      overflow-x: auto;
    }

    /* 검침값 저장 버튼 영역 */
    .meter-page .save-area {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      gap: 10px;
      padding: 0 20px 18px;
    }

    .meter-page .save-hint {
      margin-right: auto;
      font-size: 12px;
      color: var(--text-tertiary);
      font-weight: 700;
    }

    .meter-page .btn-save-meter {
      min-width: 140px;
    }

    .meter-page .btn-save-meter:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }

    .meter-page .tbl th,
    .meter-page .tbl td {
      white-space: nowrap;
    }

    @media (max-width: 1200px) {
      .meter-page .summary-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 768px) {
      .meter-page .summary-grid {
        grid-template-columns: 1fr;
      }

      .meter-page .filter-row {
        align-items: flex-start;
        flex-direction: column;
      }
    }
  </style>
</head>

<body>
<div class="app-wrapper">

  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">

    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page meter-page">

        <div class="page-header">
          <div class="page-title-block">
            <h2>세대별 검침 입력 및 요금 계산</h2>
            <p>세대별 전기, 수도, 가스의 현재 검침 숫자를 입력하여 사용량과 개별요금을 확인합니다.</p>
          </div>
        </div>

        <div id="messageBox" class="message-box"></div>

        <!-- 조회 조건 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">search</span>
              조회 조건
            </h3>
          </div>

          <div class="panel-body">
            <div class="form-row">
              <label for="searchYear">검침연도</label>
              <input type="number" id="searchYear">

              <label for="searchMonth">검침월</label>
              <select id="searchMonth">
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

              <button type="button" class="btn btn-primary" onclick="loadMeterChargeList()">
                <span class="material-symbols-rounded">calculate</span>
                계산 조회
              </button>

              <button type="button" class="btn btn-secondary" onclick="resetPage()">
                초기화
              </button>
            </div>

            <div class="input-guide">
              <span class="material-symbols-rounded">edit_square</span>
              조회 후 목록의 현재 검침값 칸에 숫자를 입력하면 사용량과 요금 합계가 즉시 다시 계산됩니다.
            </div>
          </div>
        </div>

        <!-- 요약 -->
        <div class="summary-grid">
          <div class="summary-card">
            <div class="summary-label">전기요금 합계</div>
            <div class="summary-value" id="electricTotal">0원</div>
            <div class="summary-sub" id="electricUsage">사용량 0 / 단가 0원</div>
          </div>

          <div class="summary-card">
            <div class="summary-label">수도요금 합계</div>
            <div class="summary-value" id="waterTotal">0원</div>
            <div class="summary-sub" id="waterUsage">사용량 0 / 단가 0원</div>
          </div>

          <div class="summary-card">
            <div class="summary-label">가스요금 합계</div>
            <div class="summary-value" id="gasTotal">0원</div>
            <div class="summary-sub" id="gasUsage">사용량 0 / 단가 0원</div>
          </div>

          <div class="summary-card">
            <div class="summary-label">검침요금 총합</div>
            <div class="summary-value" id="grandTotal">0원</div>
            <div class="summary-sub" id="meterCount">0건</div>
          </div>
        </div>

        <!-- 목록 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">speed</span>
              세대별 검침요금 목록
            </h3>
          </div>

          <div class="panel-body">
            <div class="filter-row">
              <div class="filter-group">
                <label for="itemFilter">항목</label>
                <select id="itemFilter" onchange="renderMeterChargeList()">
                  <option value="">전체</option>
                  <option value="ELC">전기</option>
                  <option value="WTR">수도</option>
                  <option value="GAS">가스</option>
                </select>

                <label for="keywordFilter">동/호수</label>
                <input type="text" id="keywordFilter" placeholder="예: 101 또는 101호" onkeyup="renderMeterChargeList()">
              </div>

              <div class="table-info" id="tableInfo">
                조회 전
              </div>
            </div>
          </div>

          <div class="table-wrap">
            <table class="tbl">
              <thead>
              <tr>
                <th>동/호수</th>
                <th>항목</th>
                <th class="text-right">이전 검침값</th>
                <th class="text-right">현재 검침값 입력</th>
                <th class="text-right">사용량</th>
                <th class="text-right">단가</th>
                <th class="text-right">계산금액</th>
                <th>검침일</th>
                <th>검침결과</th>
              </tr>
              </thead>
              <tbody id="meterChargeTbody">
              <tr>
                <td colspan="9" class="empty">검침요금 계산 조회를 실행해 주세요.</td>
              </tr>
              </tbody>
            </table>
          </div>

          <div class="save-area">
            <span class="save-hint">현재 검침값을 입력한 행만 저장됩니다.</span>
            <button type="button"
                    id="btnSaveMeter"
                    class="btn btn-primary btn-save-meter"
                    onclick="saveMeterReadings()"
                    disabled>
              <span class="material-symbols-rounded">save</span>
              검침값 저장
            </button>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>
  const contextPath = '${pageContext.request.contextPath}';
  const mgmtOfcNo = '${mgmtOfcNo}';

  let meterChargeList = [];

  document.addEventListener('DOMContentLoaded', function () {
    initDate();
    renderEmptyState();

    console.log('meterCharge mgmtOfcNo =', mgmtOfcNo);
  });

  function initDate() {
    const now = new Date();

    document.getElementById('searchYear').value = now.getFullYear();
    document.getElementById('searchMonth').value = now.getMonth() + 1;
  }

  function getBillYm() {
    const year = document.getElementById('searchYear').value;
    const month = document.getElementById('searchMonth').value;

    if (!year || !month) {
      return '';
    }

    return String(year) + String(month).padStart(2, '0');
  }

  async function loadMeterChargeList() {
    clearMessage();

    const billYm = getBillYm();

    if (!billYm) {
      showMessage('검침년월을 선택해 주세요.', 'warn');
      return;
    }

    if (!mgmtOfcNo || mgmtOfcNo === 'null') {
      showMessage('관리사무소 번호가 확인되지 않았습니다.', 'error');
      return;
    }

    const url = contextPath
            + '/manager/bill/meter-charge/list/' + mgmtOfcNo
            + '?billYm=' + encodeURIComponent(billYm);

    try {
      const response = await fetch(url);

      if (!response.ok) {
        showMessage('검침요금 계산 조회 중 오류가 발생했습니다. 상태코드: ' + response.status, 'error');
        return;
      }

      const result = await response.json();

      if (!result.success) {
        showMessage(result.message || '검침요금 계산 조회에 실패했습니다.', 'error');
        return;
      }

      meterChargeList = (result.list || []).map(function (item) {
        // 서버에서 전달된 현재 검침값이 있으면 입력칸의 초기값으로 사용합니다.
        item.currVal = item.currVal === null || item.currVal === undefined ? '' : item.currVal;

        // 저장 후 변경 여부를 판단하기 위한 원본값입니다.
        item.originalCurrVal = item.currVal;

        return item;
      });

      renderSummaryFromList();
      renderMeterChargeList();
      updateSaveButton();

      showMessage(formatBillYm(billYm) + ' 검침요금 계산 결과를 조회했습니다.', 'info');

    } catch (e) {
      console.error(e);
      showMessage('검침요금 계산 조회 중 오류가 발생했습니다.', 'error');
    }
  }

  /**
   * 현재 화면에 입력되어 있는 검침값을 기준으로 요약 카드를 다시 계산합니다.
   * 최종 저장 시에는 서버에서도 동일한 유효성 검사와 금액 계산을 수행해야 합니다.
   */
  function renderSummaryFromList() {
    const totals = {
      ELC: {amount: 0, usage: 0, unitPrice: 0},
      WTR: {amount: 0, usage: 0, unitPrice: 0},
      GAS: {amount: 0, usage: 0, unitPrice: 0}
    };

    let enteredCount = 0;

    meterChargeList.forEach(function (item) {
      const code = item.billItemCd;

      if (!totals[code]) {
        return;
      }

      totals[code].amount += Number(item.chargeAmt || 0);
      totals[code].usage += Number(item.usageVal || 0);
      totals[code].unitPrice = Number(item.unitPrice || totals[code].unitPrice || 0);

      if (item.currVal !== '' && item.currVal !== null && item.currVal !== undefined) {
        enteredCount++;
      }
    });

    const grandTotal = totals.ELC.amount + totals.WTR.amount + totals.GAS.amount;

    document.getElementById('electricTotal').textContent = formatNumber(totals.ELC.amount) + '원';
    document.getElementById('waterTotal').textContent = formatNumber(totals.WTR.amount) + '원';
    document.getElementById('gasTotal').textContent = formatNumber(totals.GAS.amount) + '원';
    document.getElementById('grandTotal').textContent = formatNumber(grandTotal) + '원';

    document.getElementById('electricUsage').textContent =
            '사용량 ' + formatNumber(totals.ELC.usage) + ' / 단가 ' + formatNumber(totals.ELC.unitPrice) + '원';

    document.getElementById('waterUsage').textContent =
            '사용량 ' + formatNumber(totals.WTR.usage) + ' / 단가 ' + formatNumber(totals.WTR.unitPrice) + '원';

    document.getElementById('gasUsage').textContent =
            '사용량 ' + formatNumber(totals.GAS.usage) + ' / 단가 ' + formatNumber(totals.GAS.unitPrice) + '원';

    document.getElementById('meterCount').textContent =
            '입력 ' + formatNumber(enteredCount) + '건 / 전체 ' + formatNumber(meterChargeList.length) + '건';
  }

  /**
   * 현재 검침값 입력 후, 해당 행의 사용량과 계산금액을 화면에서 즉시 갱신합니다.
   */
  function applyMeterInput(listIndex, inputElement) {
    const item = meterChargeList[listIndex];
    const enteredValue = inputElement.value.trim();
    const previousValue = Number(item.preVal || 0);

    inputElement.classList.remove('input-error');

    if (enteredValue === '') {
      item.currVal = '';
      item.usageVal = 0;
      item.chargeAmt = 0;

      renderMeterChargeList();
      renderSummaryFromList();
      updateSaveButton();
      showMessage('현재 검침값이 비어 있는 행은 요금 계산에서 제외됩니다.', 'warn');
      return;
    }

    const currentValue = Number(enteredValue);

    if (!Number.isFinite(currentValue) || currentValue < 0) {
      inputElement.classList.add('input-error');
      showMessage('현재 검침값은 0 이상의 숫자로 입력해 주세요.', 'warn');
      return;
    }

    if (currentValue < previousValue) {
      inputElement.classList.add('input-error');
      showMessage('현재 검침값은 이전 검침값보다 작을 수 없습니다. (' +
              formatNumber(previousValue) + ' 이상 입력)', 'warn');
      return;
    }

    item.currVal = currentValue;
    item.usageVal = currentValue - previousValue;
    item.chargeAmt = Math.round(item.usageVal * Number(item.unitPrice || 0));

    renderMeterChargeList();
    renderSummaryFromList();
    updateSaveButton();
    showMessage('입력값을 기준으로 사용량과 계산금액을 반영했습니다.', 'info');
  }

  function renderMeterChargeList() {
    const tbody = document.getElementById('meterChargeTbody');
    const itemFilter = document.getElementById('itemFilter').value;
    const keyword = document.getElementById('keywordFilter').value.trim();

    tbody.innerHTML = '';

    let filteredList = meterChargeList.slice();

    if (itemFilter) {
      filteredList = filteredList.filter(function (item) {
        return item.billItemCd === itemFilter;
      });
    }

    if (keyword) {
      filteredList = filteredList.filter(function (item) {
        const displayDongHo = item.displayDongHo || '';
        const dongNm = item.dongNm || '';
        const ho = item.ho || '';

        return displayDongHo.indexOf(keyword) > -1
                || dongNm.indexOf(keyword) > -1
                || ho.indexOf(keyword) > -1;
      });
    }

    document.getElementById('tableInfo').textContent =
            '총 ' + formatNumber(filteredList.length) + '건';

    if (filteredList.length === 0) {
      tbody.innerHTML =
              '<tr><td colspan="9" class="empty">조회된 검침 데이터가 없습니다.</td></tr>';
      return;
    }

    filteredList.forEach(function (item) {
      const listIndex = meterChargeList.indexOf(item);
      const tr = document.createElement('tr');
      const currentValue = item.currVal === null || item.currVal === undefined ? '' : item.currVal;

      tr.innerHTML =
              '<td class="td-bold">' + escapeHtml(item.displayDongHo || '-') + '</td>' +
              '<td>' + renderMeterBadge(item.billItemCd, item.billItemNm) + '</td>' +
              '<td class="text-right">' + formatNumber(item.preVal) + '</td>' +
              '<td class="text-right">' +
              '<input type="number" class="meter-current-input" min="' + Number(item.preVal || 0) + '"' +
              ' step="1" value="' + escapeHtml(currentValue) + '"' +
              ' aria-label="' + escapeHtml((item.displayDongHo || '') + ' ' + (item.billItemNm || '') + ' 현재 검침값') + '"' +
              ' onchange="applyMeterInput(' + listIndex + ', this)">' +
              '</td>' +
              '<td class="text-right td-bold">' + formatNumber(item.usageVal) + '</td>' +
              '<td class="text-right">' + formatNumber(item.unitPrice) + '원</td>' +
              '<td class="text-right td-bold">' + formatNumber(item.chargeAmt) + '원</td>' +
              '<td>' + formatDate(item.meterDt) + '</td>' +
              '<td>' + escapeHtml(item.meterRsltCd || '입력대기') + '</td>';

      tbody.appendChild(tr);
    });
  }

  /**
   * 입력값이 있는 행 중 실제 변경된 검침값만 서버 전송용 목록으로 만듭니다.
   * Controller에서는 meterList 배열을 받아 METER_HSTRY에 등록/수정합니다.
   */
  function makeSavePayload() {
    const billYm = getBillYm();

    const meterList = meterChargeList
            .filter(function (item) {
              return item.currVal !== ''
                      && item.currVal !== null
                      && item.currVal !== undefined
                      && String(item.currVal) !== String(item.originalCurrVal);
            })
            .map(function (item) {
              return {
                hoNo: item.hoNo,
                billItemCd: item.billItemCd,
                utilityProviderNo: item.utilityProviderNo,
                facilityNo: item.facilityNo,
                preVal: Number(item.preVal || 0),
                currVal: Number(item.currVal),
                usageVal: Number(item.usageVal || 0),
                unitPrice: Number(item.unitPrice || 0),
                chargeAmt: Number(item.chargeAmt || 0)
              };
            });

    return {
      mgmtOfcNo: mgmtOfcNo,
      billYm: billYm,
      meterList: meterList
    };
  }

  /**
   * 저장 전 화면 입력값을 검증합니다.
   * 금액 계산은 화면 편의 기능이므로, Controller/Service에서도 다시 검증해야 합니다.
   */
  function validateBeforeSave(payload) {
    if (!payload.billYm) {
      showMessage('검침년월을 선택해 주세요.', 'warn');
      return false;
    }

    if (!payload.meterList.length) {
      showMessage('저장할 검침값이 없습니다. 값을 입력하거나 변경해 주세요.', 'warn');
      return false;
    }

    for (const item of payload.meterList) {
      if (!item.hoNo) {
        showMessage('호수 식별값(HO_NO)이 없는 행이 있습니다. 조회 쿼리에서 hoNo를 내려주도록 확인해 주세요.', 'error');
        return false;
      }

      if (item.currVal < item.preVal) {
        showMessage('현재 검침값은 이전 검침값보다 작을 수 없습니다.', 'warn');
        return false;
      }
    }

    return true;
  }

  /**
   * 세대별 현재 검침값 저장
   * 다음 단계에서 생성할 Controller URL:
   * POST /manager/bill/meter-charge/save/{mgmtOfcNo}
   */
  async function saveMeterReadings() {
    clearMessage();

    const payload = makeSavePayload();

    if (!validateBeforeSave(payload)) {
      return;
    }

    const saveButton = document.getElementById('btnSaveMeter');
    const originalButtonText = saveButton.innerHTML;

    saveButton.disabled = true;
    saveButton.innerHTML =
            '<span class="material-symbols-rounded">hourglass_top</span> 저장 중';

    const url = contextPath
            + '/manager/bill/meter-charge/save/' + encodeURIComponent(mgmtOfcNo);

    try {
      const headers = {
        'Content-Type': 'application/json'
      };

      // Spring Security CSRF meta 태그를 사용하는 화면이라면 자동으로 헤더를 추가합니다.
      const csrfToken = document.querySelector('meta[name="_csrf"]');
      const csrfHeader = document.querySelector('meta[name="_csrf_header"]');

      if (csrfToken && csrfHeader) {
        headers[csrfHeader.getAttribute('content')] = csrfToken.getAttribute('content');
      }

      const response = await fetch(url, {
        method: 'POST',
        headers: headers,
        body: JSON.stringify(payload)
      });

      if (!response.ok) {
        showMessage('검침값 저장 중 오류가 발생했습니다. 상태코드: ' + response.status, 'error');
        return;
      }

      const result = await response.json();

      if (!result.success) {
        showMessage(result.message || '검침값 저장에 실패했습니다.', 'error');
        return;
      }

      // 저장이 완료된 값은 다시 변경 목록으로 잡히지 않도록 원본값을 갱신합니다.
      meterChargeList.forEach(function (item) {
        if (item.currVal !== '' && item.currVal !== null && item.currVal !== undefined) {
          item.originalCurrVal = item.currVal;
          item.meterRsltCd = item.meterRsltCd || '정상';
        }
      });

      renderMeterChargeList();
      updateSaveButton();

      showMessage(result.message || ('검침값 ' + payload.meterList.length + '건을 저장했습니다.'), 'info');

    } catch (e) {
      console.error(e);
      showMessage('검침값 저장 중 오류가 발생했습니다.', 'error');

    } finally {
      saveButton.innerHTML = originalButtonText;
      updateSaveButton();
    }
  }

  /**
   * 변경된 현재 검침값이 존재할 때만 저장 버튼을 활성화합니다.
   */
  function updateSaveButton() {
    const button = document.getElementById('btnSaveMeter');

    if (!button) {
      return;
    }

    const hasModifiedInput = meterChargeList.some(function (item) {
      return item.currVal !== ''
              && item.currVal !== null
              && item.currVal !== undefined
              && String(item.currVal) !== String(item.originalCurrVal);
    });

    button.disabled = !hasModifiedInput;
  }

  function renderMeterBadge(code, name) {
    let cls = 'badge-meter';

    if (code === 'ELC') {
      cls += ' badge-elc';
    } else if (code === 'WTR') {
      cls += ' badge-wtr';
    } else if (code === 'GAS') {
      cls += ' badge-gas';
    }

    return '<span class="' + cls + '">' + escapeHtml(name || code || '-') + '</span>';
  }

  function resetPage() {
    initDate();
    clearMessage();

    meterChargeList = [];

    document.getElementById('itemFilter').value = '';
    document.getElementById('keywordFilter').value = '';

    renderEmptyState();
    updateSaveButton();
  }

  function renderEmptyState() {
    document.getElementById('electricTotal').textContent = '0원';
    document.getElementById('waterTotal').textContent = '0원';
    document.getElementById('gasTotal').textContent = '0원';
    document.getElementById('grandTotal').textContent = '0원';

    document.getElementById('electricUsage').textContent = '사용량 0 / 단가 0원';
    document.getElementById('waterUsage').textContent = '사용량 0 / 단가 0원';
    document.getElementById('gasUsage').textContent = '사용량 0 / 단가 0원';
    document.getElementById('meterCount').textContent = '0건';

    document.getElementById('tableInfo').textContent = '조회 전';

    document.getElementById('meterChargeTbody').innerHTML =
            '<tr><td colspan="9" class="empty">검침요금 계산 조회를 실행해 주세요.</td></tr>';
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
    return Number(value || 0).toLocaleString();
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
</script>

</body>
</html>