<%--
  Created by IntelliJ IDEA.
  User: PC-27
  Date: 2026-05-14
  Time: 오후 7:37
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">

  <meta name="_csrf" content="${_csrf.token}">
  <meta name="_csrf_header" content="${_csrf.headerName}">

  <title>지출 등록</title>

  <style>
    body {
      margin: 0;
      background: #f5f6f8;
      font-family: Arial, sans-serif;
      color: #222;
    }

    .page-wrap {
      max-width: 1200px;
      margin: 40px auto;
      padding: 0 20px;
    }

    .page-title {
      font-size: 28px;
      font-weight: 800;
      margin-bottom: 24px;
    }

    .box {
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 14px;
      padding: 22px;
      margin-bottom: 20px;
    }

    .box-title {
      font-size: 18px;
      font-weight: 800;
      margin-bottom: 16px;
    }

    .form-row {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      align-items: center;
    }

    label {
      font-weight: 700;
      margin-right: 4px;
    }

    input,
    select {
      height: 38px;
      border: 1px solid #ccc;
      border-radius: 8px;
      padding: 0 10px;
      box-sizing: border-box;
    }

    input[type="number"] {
      width: 130px;
    }

    input[type="text"] {
      width: 300px;
    }

    .btn {
      height: 38px;
      border: 0;
      border-radius: 8px;
      padding: 0 16px;
      font-weight: 700;
      cursor: pointer;
    }

    .btn-primary {
      background: #166534;
      color: #fff;
    }

    .btn-secondary {
      background: #e5e7eb;
      color: #111827;
    }

    .btn-danger {
      background: #dc2626;
      color: #fff;
    }

    .summary {
      font-size: 18px;
      font-weight: 800;
      margin-bottom: 14px;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: #fff;
    }

    th {
      background: #f0f2f5;
      border-bottom: 1px solid #ccc;
      padding: 12px;
      font-size: 14px;
    }

    td {
      border-bottom: 1px solid #eee;
      padding: 12px;
      text-align: center;
      font-size: 14px;
    }

    .text-right {
      text-align: right;
    }

    .empty {
      color: #777;
      padding: 30px;
    }

    .desc {
      color: #666;
      font-size: 13px;
    }
  </style>
</head>

<body>

<div class="page-wrap">

  <h1 class="page-title">지출 등록</h1>

  <div class="box">
    <div class="box-title">조회 조건</div>

    <div class="form-row">
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

  <div class="box">
    <div class="box-title">지출 입력</div>

    <input type="hidden" id="expenseNo">

    <div class="form-row">
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

    <p class="desc">
      저장 시 EXPENSE 테이블에 등록되고, 목록은 COMMON_CODE와 조인해서 항목명을 표시합니다.
    </p>
  </div>

  <div class="box">
    <div class="summary">
      월 지출 합계:
      <span id="totalAmount">0</span>원
    </div>

    <table>
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
