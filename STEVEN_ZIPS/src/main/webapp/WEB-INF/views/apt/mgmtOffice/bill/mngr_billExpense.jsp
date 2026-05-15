<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">

  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">

  <title>지출 등록</title>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    .expense-page .expense-form-row {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      align-items: center;
    }

    .expense-page .expense-form-row label {
      font-weight: 700;
      margin-right: 4px;
    }

    .expense-page input,
    .expense-page select {
      height: 36px;
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      padding: 0 10px;
      font-family: inherit;
      font-size: 13px;
    }

    .expense-page input[type="number"] {
      width: 130px;
    }

    .expense-page input[type="text"] {
      width: 300px;
    }

    .expense-summary {
      font-size: 16px;
      font-weight: 800;
      margin-bottom: 14px;
    }

    .text-right {
      text-align: right;
    }

    .empty {
      color: var(--text-tertiary);
      padding: 30px;
      text-align: center;
    }
  </style>
</head>

<body>
<div class="app-wrapper">

  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">

    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page expense-page">

        <div class="page-header">
          <div class="page-title-block">
            <h2>지출 내역 관리</h2>
            <p>관리비 부과에 사용할 월별 지출 내역을 등록하고 관리합니다.</p>
          </div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">search</span>
              조회 조건
            </h3>
          </div>

          <div class="panel-body">
            <div class="expense-form-row">
              <label for="searchYear">연도</label>
              <input type="number" id="searchYear">

              <label for="searchMonth">월</label>
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

              <label for="searchExpenseCd">지출항목</label>
              <select id="searchExpenseCd">
                <option value="">전체</option>
                <option value="SAL">급여/수당</option>
                <option value="OFF">사무비</option>
                <option value="REP">수선유지비</option>
                <option value="UTL">공공요금</option>
                <option value="SRV">위탁수수료</option>
                <option value="INS">보험료</option>
                <option value="ETC">잡지출</option>
              </select>

              <button type="button" class="btn btn-primary" onclick="loadExpenseList()">조회</button>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">edit_note</span>
              지출 입력
            </h3>
          </div>

          <div class="panel-body">
            <input type="hidden" id="expenseNo">

            <div class="expense-form-row">
              <label for="expenseYr">연도</label>
              <input type="number" id="expenseYr">

              <label for="expenseMm">월</label>
              <select id="expenseMm">
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

              <label for="expenseCd">지출항목</label>
              <select id="expenseCd">
                <option value="">선택</option>
                <option value="SAL">급여/수당</option>
                <option value="OFF">사무비</option>
                <option value="REP">수선유지비</option>
                <option value="UTL">공공요금</option>
                <option value="SRV">위탁수수료</option>
                <option value="INS">보험료</option>
                <option value="ETC">잡지출</option>
              </select>

              <label for="expenseAmt">금액</label>
              <input type="number" id="expenseAmt" placeholder="금액">

              <label for="expenseCn">내용</label>
              <input type="text" id="expenseCn" placeholder="예: 5월 공용 전기요금">

              <button type="button" class="btn btn-primary" onclick="saveExpense()">저장</button>
              <button type="button" class="btn btn-secondary" onclick="resetForm()">초기화</button>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">receipt_long</span>
              지출 목록
            </h3>
          </div>

          <div class="panel-body">
            <div class="expense-summary">
              월 지출 합계:
              <span id="totalAmount">0</span>원
            </div>
          </div>

          <div class="table-wrap">
            <table class="tbl">
              <thead>
              <tr>
                <th>연도</th>
                <th>월</th>
                <th>항목</th>
                <th>내용</th>
                <th>금액</th>
                <th>등록일</th>
                <th>관리</th>
              </tr>
              </thead>
              <tbody id="expenseTbody">
              <tr>
                <td colspan="7" class="empty">조회된 지출 내역이 없습니다.</td>
              </tr>
              </tbody>
            </table>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>
  // 기존 script 그대로 유지
</script>

</body>
</html>

<script>
  const contextPath = '${pageContext.request.contextPath}';
  const mgmtOfcNo = '${mgmtOfcNo}';

  const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
  const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');

  let currentExpenseList = [];

  document.addEventListener('DOMContentLoaded', function () {
    initDate();
    loadExpenseList();
  });

  function initDate() {
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;

    document.getElementById('searchYear').value = year;
    document.getElementById('searchMonth').value = month;

    document.getElementById('expenseYr').value = year;
    document.getElementById('expenseMm').value = month;
  }

  function getHeaders() {
    const headers = {
      'Content-Type': 'application/json'
    };

    if (csrfToken && csrfHeader) {
      headers[csrfHeader] = csrfToken;
    }

    return headers;
  }

  async function loadExpenseList() {
    const expenseYr = document.getElementById('searchYear').value;
    const expenseMm = document.getElementById('searchMonth').value;
    const expenseCd = document.getElementById('searchExpenseCd').value;

    let url = contextPath + '/manager/expense/' + mgmtOfcNo
            + '?expenseYr=' + encodeURIComponent(expenseYr)
            + '&expenseMm=' + encodeURIComponent(expenseMm);

    if (expenseCd) {
      url += '&expenseCd=' + encodeURIComponent(expenseCd);
    }

    const response = await fetch(url);
    const result = await response.json();

    if (!result.success) {
      alert(result.message || '조회 중 오류가 발생했습니다.');
      return;
    }

    currentExpenseList = result.list || [];

    renderExpenseList(currentExpenseList);
    document.getElementById('totalAmount').textContent = formatNumber(result.totalAmount || 0);
  }

  function renderExpenseList(list) {
    const tbody = document.getElementById('expenseTbody');
    tbody.innerHTML = '';

    if (!list || list.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" class="empty">조회된 지출 내역이 없습니다.</td></tr>';
      return;
    }

    list.forEach(function (item, index) {
      const tr = document.createElement('tr');

      tr.innerHTML =
              '<td>' + nvl(item.expenseYr) + '</td>' +
              '<td>' + nvl(item.expenseMm) + '월</td>' +
              '<td>' + nvl(item.expenseCdNm || item.expenseCd) + '</td>' +
              '<td>' + nvl(item.expenseCn) + '</td>' +
              '<td class="text-right">' + formatNumber(item.expenseAmt) + '원</td>' +
              '<td>' + formatDate(item.regDt) + '</td>' +
              '<td>' +
              '<button type="button" class="btn btn-secondary" onclick="editExpense(' + index + ')">수정</button> ' +
              '<button type="button" class="btn btn-danger" onclick="deleteExpense(\'' + item.expenseNo + '\')">삭제</button>' +
              '</td>';

      tbody.appendChild(tr);
    });
  }

  async function saveExpense() {
    //console.log("저장 버튼 클릭됨");
    const expenseNo = document.getElementById('expenseNo').value;

    const payload = {
      expenseYr: Number(document.getElementById('expenseYr').value),
      expenseMm: Number(document.getElementById('expenseMm').value),
      expenseCd: document.getElementById('expenseCd').value,
      expenseAmt: Number(document.getElementById('expenseAmt').value),
      expenseCn: document.getElementById('expenseCn').value
    };

    if (!payload.expenseYr) {
      alert('연도를 입력해 주세요.');
      return;
    }

    if (!payload.expenseMm) {
      alert('월을 선택해 주세요.');
      return;
    }

    if (!payload.expenseCd) {
      alert('지출항목을 선택해 주세요.');
      return;
    }

    if (!payload.expenseAmt || payload.expenseAmt < 0) {
      alert('지출금액을 입력해 주세요.');
      return;
    }

    const isUpdate = expenseNo !== '';

    const url = isUpdate
            ? contextPath + '/manager/expense/' + mgmtOfcNo + '/' + expenseNo
            : contextPath + '/manager/expense/' + mgmtOfcNo;

    const method = isUpdate ? 'PUT' : 'POST';

    const response = await fetch(url, {
      method: method,
      headers: getHeaders(),
      body: JSON.stringify(payload)
    });

    const result = await response.json();

    alert(result.message || '처리되었습니다.');

    if (result.success) {
      resetForm();
      loadExpenseList();
    }
  }

  function editExpense(index) {
    const item = currentExpenseList[index];

    document.getElementById('expenseNo').value = item.expenseNo;
    document.getElementById('expenseYr').value = item.expenseYr;
    document.getElementById('expenseMm').value = item.expenseMm;
    document.getElementById('expenseCd').value = item.expenseCd;
    document.getElementById('expenseAmt').value = item.expenseAmt;
    document.getElementById('expenseCn').value = item.expenseCn || '';
  }

  async function deleteExpense(expenseNo) {
    if (!confirm('해당 지출 내역을 삭제하시겠습니까?')) {
      return;
    }

    const response = await fetch(contextPath + '/manager/expense/' + mgmtOfcNo + '/' + expenseNo, {
      method: 'DELETE',
      headers: getHeaders()
    });

    const result = await response.json();

    alert(result.message || '처리되었습니다.');

    if (result.success) {
      loadExpenseList();
    }
  }

  function resetForm() {
    document.getElementById('expenseNo').value = '';
    document.getElementById('expenseCd').value = '';
    document.getElementById('expenseAmt').value = '';
    document.getElementById('expenseCn').value = '';

    document.getElementById('expenseYr').value = document.getElementById('searchYear').value;
    document.getElementById('expenseMm').value = document.getElementById('searchMonth').value;
  }

  function formatNumber(value) {
    return Number(value || 0).toLocaleString();
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

  function nvl(value) {
    return value === null || value === undefined || value === '' ? '-' : value;
  }
</script>

</body>
</html>
