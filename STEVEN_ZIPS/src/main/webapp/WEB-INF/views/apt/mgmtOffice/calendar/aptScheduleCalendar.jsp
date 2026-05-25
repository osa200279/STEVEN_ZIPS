<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>단지 일정 캘린더</title>

  <sec:csrfMetaTags/>

  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    #aptScheduleCalendarPage .calendar-topbar { display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:14px; }
    #aptScheduleCalendarPage .calendar-nav { display:flex; align-items:center; justify-content:center; gap:10px; }
    #aptScheduleCalendarPage .calendar-title { min-width:110px; text-align:center; font-size:18px; font-weight:800; color:#172033; }
    #aptScheduleCalendarPage .filter-row { display:flex; align-items:center; gap:8px; flex-wrap:wrap; padding:14px; border:1px solid var(--border); border-radius:12px; background:#fff; margin-bottom:14px; }
    #aptScheduleCalendarPage .filter-row select { width:160px; }
    #aptScheduleCalendarPage .filter-row input { width:280px; }

    #aptScheduleCalendarPage .legend-row { display:flex; align-items:center; gap:10px; flex-wrap:wrap; margin:10px 0 14px; font-size:12px; color:#64748b; }
    #aptScheduleCalendarPage .legend-dot { width:9px; height:9px; border-radius:50%; display:inline-block; margin-right:4px; }
    #aptScheduleCalendarPage .legend-dot.NOTICE { background:#2563eb; }
    #aptScheduleCalendarPage .legend-dot.EVENT { background:#16a34a; }
    #aptScheduleCalendarPage .legend-dot.VACATION { background:#7c3aed; }
    #aptScheduleCalendarPage .legend-dot.CONSTRUCTION { background:#ea580c; }
    #aptScheduleCalendarPage .legend-dot.METER { background:#0891b2; }
    #aptScheduleCalendarPage .legend-dot.CHECK { background:#64748b; }

    #aptScheduleCalendarPage .apt-calendar { table-layout:fixed; width:100%; border-collapse:collapse; background:#fff; border-top:2px solid #2563eb; }
    #aptScheduleCalendarPage .apt-calendar th { height:36px; text-align:center; font-size:12px; font-weight:800; border:1px solid #e5e7eb; background:#f8fafc; }
    #aptScheduleCalendarPage .apt-calendar td { height:128px; vertical-align:top; padding:8px 7px; border:1px solid #e5e7eb; background:#fff; }
    #aptScheduleCalendarPage .apt-calendar td.other-month { background:#fafafa; }
    #aptScheduleCalendarPage .apt-calendar td.today { background:#f0f7ff; }
    #aptScheduleCalendarPage .day-num { font-size:12px; font-weight:800; margin-bottom:5px; color:#334155; }
    #aptScheduleCalendarPage .sun .day-num { color:#dc2626; }
    #aptScheduleCalendarPage .sat .day-num { color:#2563eb; }
    #aptScheduleCalendarPage .schedule-chip { display:block; width:100%; max-width:100%; border:1px solid currentColor; background:#fff; border-radius:999px; padding:2px 7px; margin-bottom:3px; font-size:10px; line-height:16px; font-weight:700; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; cursor:pointer; }
    #aptScheduleCalendarPage .schedule-chip.NOTICE { color:#2563eb; }
    #aptScheduleCalendarPage .schedule-chip.EVENT { color:#16a34a; }
    #aptScheduleCalendarPage .schedule-chip.VACATION { color:#7c3aed; }
    #aptScheduleCalendarPage .schedule-chip.CONSTRUCTION { color:#ea580c; }
    #aptScheduleCalendarPage .schedule-chip.METER { color:#0891b2; }
    #aptScheduleCalendarPage .schedule-chip.CHECK { color:#64748b; }
    #aptScheduleCalendarPage .more-count { margin-top:3px; font-size:10px; color:#475569; text-align:center; }

    #aptScheduleCalendarPage .schedule-list-table { table-layout:fixed; width:100%; }
    #aptScheduleCalendarPage .schedule-list-table th, #aptScheduleCalendarPage .schedule-list-table td { text-align:center; vertical-align:middle; white-space:nowrap; }
    #aptScheduleCalendarPage .schedule-list-table .td-title { text-align:left; overflow:hidden; text-overflow:ellipsis; }

    #aptScheduleCalendarPage .modal-backdrop { position:fixed; inset:0; background:rgba(15,23,42,.45); display:none; align-items:center; justify-content:center; z-index:1000; }
    #aptScheduleCalendarPage .modal-backdrop.active { display:flex; }
    #aptScheduleCalendarPage .modal-card { width:460px; max-width:calc(100vw - 32px); background:#fff; border-radius:16px; box-shadow:0 20px 60px rgba(15,23,42,.25); overflow:hidden; }
    #aptScheduleCalendarPage .modal-head { display:flex; justify-content:space-between; align-items:center; padding:16px 18px; border-bottom:1px solid #e5e7eb; }
    #aptScheduleCalendarPage .modal-title { font-size:16px; font-weight:800; }
    #aptScheduleCalendarPage .modal-body { padding:18px; }
    #aptScheduleCalendarPage .form-row { margin-bottom:12px; }
    #aptScheduleCalendarPage .form-row label { display:block; font-size:12px; font-weight:800; margin-bottom:5px; color:#334155; }
    #aptScheduleCalendarPage .form-row input, #aptScheduleCalendarPage .form-row select, #aptScheduleCalendarPage .form-row textarea { width:100%; }
    #aptScheduleCalendarPage .modal-foot { display:flex; justify-content:flex-end; gap:8px; padding:14px 18px; border-top:1px solid #e5e7eb; }
  </style>

  <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>
<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="aptScheduleCalendarPage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>단지 일정 캘린더</h2>
            <p>공지, 행사, 직원 휴가, 공사, 검침, 점검 일정을 월별로 확인합니다.</p>
          </div>
          <div class="page-actions">
            <button type="button" class="btn btn-primary" id="openVacationBtn">
              <span class="material-symbols-rounded">add</span>
              휴가 등록
            </button>
          </div>
        </div>

        <div class="stat-row">
          <div class="stat-card"><div class="stat-icon green"><span class="material-symbols-rounded">event_available</span></div><div><div class="stat-value" id="totalCnt">0</div><div class="stat-label">전체 일정</div></div></div>
          <div class="stat-card"><div class="stat-icon blue"><span class="material-symbols-rounded">today</span></div><div><div class="stat-value" id="todayCnt">0</div><div class="stat-label">오늘 일정</div></div></div>
          <div class="stat-card"><div class="stat-icon yellow"><span class="material-symbols-rounded">calendar_month</span></div><div><div class="stat-value" id="monthCnt">0</div><div class="stat-label">이번 달 일정</div></div></div>
          <div class="stat-card"><div class="stat-icon purple"><span class="material-symbols-rounded">badge</span></div><div><div class="stat-value" id="vacationCnt">0</div><div class="stat-label">직원 휴가</div></div></div>
        </div>

        <div class="tab-bar">
          <button type="button" class="tab-btn active" data-tab="calendar"><span class="material-symbols-rounded">calendar_month</span>달력</button>
          <button type="button" class="tab-btn" data-tab="list"><span class="material-symbols-rounded">list_alt</span>전체 목록</button>
        </div>

        <div class="filter-row">
          <select id="scheduleTy" class="form-control">
            <option value="ALL">전체 유형</option>
            <option value="NOTICE">공지</option>
            <option value="EVENT">행사</option>
            <option value="VACATION">직원휴가</option>
            <option value="CONSTRUCTION">공사</option>
            <option value="METER">검침</option>
            <option value="CHECK">점검</option>
          </select>
          <input type="text" id="keyword" class="form-control" placeholder="일정명, 내용, 위치, 직원명 검색">
          <button type="button" class="btn btn-primary" id="searchBtn"><span class="material-symbols-rounded">search</span>검색</button>
        </div>

        <div class="tab-panel active" id="calendarPanel">
          <div class="panel">
            <div class="panel-header calendar-topbar">
              <div class="panel-title"><span class="material-symbols-rounded">calendar_month</span>월간 일정</div>
              <div class="calendar-nav">
                <button type="button" class="btn btn-sm btn-secondary" id="prevMonthBtn"><span class="material-symbols-rounded">chevron_left</span></button>
                <strong class="calendar-title" id="calendarTitle"></strong>
                <button type="button" class="btn btn-sm btn-secondary" id="nextMonthBtn"><span class="material-symbols-rounded">chevron_right</span></button>
                <button type="button" class="btn btn-sm btn-secondary" id="todayBtn">오늘</button>
              </div>
            </div>

            <div class="legend-row">
              <span><i class="legend-dot NOTICE"></i>공지</span>
              <span><i class="legend-dot EVENT"></i>행사</span>
              <span><i class="legend-dot VACATION"></i>직원휴가</span>
              <span><i class="legend-dot CONSTRUCTION"></i>공사</span>
              <span><i class="legend-dot METER"></i>검침</span>
              <span><i class="legend-dot CHECK"></i>점검</span>
            </div>

            <table class="apt-calendar">
              <thead><tr><th style="color:#dc2626;">일</th><th>월</th><th>화</th><th>수</th><th>목</th><th>금</th><th style="color:#2563eb;">토</th></tr></thead>
              <tbody id="calendarBody"></tbody>
            </table>
          </div>
        </div>

        <div class="tab-panel" id="listPanel" style="display:none;">
          <div class="panel">
            <div class="panel-header"><div class="panel-title"><span class="material-symbols-rounded">list_alt</span>전체 일정 목록</div></div>
            <table class="tbl schedule-list-table">
              <thead><tr><th style="width:70px;">유형</th><th>일정명</th><th style="width:180px;">기간</th><th style="width:140px;">위치</th><th style="width:100px;">등록자/직원</th></tr></thead>
              <tbody id="scheduleListBody"><tr><td colspan="5">조회된 일정이 없습니다.</td></tr></tbody>
            </table>
          </div>
        </div>

        <div class="modal-backdrop" id="vacationModal">
          <div class="modal-card">
            <div class="modal-head">
              <div class="modal-title">직원 휴가 등록</div>
              <button type="button" class="btn btn-sm btn-secondary" id="closeVacationBtn">닫기</button>
            </div>
            <div class="modal-body">
              <div class="form-row">
                <label>직원</label>
                <select id="vacUserNo" class="form-control">
                  <option value="">직원 선택</option>
                  <c:forEach var="emp" items="${managerEmployeeList}">
                    <option value="${emp.userNo}">${emp.userNm}</option>
                  </c:forEach>
                </select>
              </div>
              <div class="form-row">
                <label>휴가 제목</label>
                <input type="text" id="vacTitle" class="form-control" placeholder="예: 연차, 오전 반차, 병가">
              </div>
              <div class="form-row">
                <label>시작일</label>
                <input type="date" id="vacStartDt" class="form-control">
              </div>
              <div class="form-row">
                <label>종료일</label>
                <input type="date" id="vacEndDt" class="form-control">
              </div>
            </div>
            <div class="modal-foot">
              <button type="button" class="btn btn-secondary" id="cancelVacationBtn">취소</button>
              <button type="button" class="btn btn-primary" id="saveVacationBtn">등록</button>
            </div>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>
(function () {
  const contextPath = '${pageContext.request.contextPath}';
  const mgmtOfcNo = '${mgmtOfcNo}';
  const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.content;
  const csrfToken = document.querySelector('meta[name="_csrf"]')?.content;

  let currentDate = new Date();
  let scheduleList = [];

  const calendarTitle = document.getElementById('calendarTitle');
  const calendarBody = document.getElementById('calendarBody');
  const scheduleListBody = document.getElementById('scheduleListBody');

  function pad(num) { return String(num).padStart(2, '0'); }
  function formatDate(date) { return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate()); }
  function escapeHtml(value) {
    if (value === null || value === undefined) return '';
    return String(value).replace(/[&<>"]/g, function (s) {
      return ({'&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;'}[s]);
    });
  }

  function getMonthRange() {
    const first = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const last = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    return { start: formatDate(first), end: formatDate(last) };
  }

  function loadSchedule() {
    const range = getMonthRange();
    const params = new URLSearchParams();
    params.append('monthStartDt', range.start);
    params.append('monthEndDt', range.end);
    params.append('scheduleTy', document.getElementById('scheduleTy').value);
    params.append('keyword', document.getElementById('keyword').value.trim());

    fetch(contextPath + '/manager/aptScheduleCalendar/' + mgmtOfcNo + '/list?' + params.toString())
      .then(function (res) { return res.json(); })
      .then(function (data) {
        scheduleList = data.list || [];
        renderStat(data.stat || {});
        renderCalendar();
        renderList();
      })
      .catch(function () { alert('일정 조회 중 오류가 발생했습니다.'); });
  }

  function renderStat(stat) {
    document.getElementById('totalCnt').textContent = stat.totalCnt || 0;
    document.getElementById('todayCnt').textContent = stat.todayCnt || 0;
    document.getElementById('monthCnt').textContent = stat.monthCnt || 0;
    document.getElementById('vacationCnt').textContent = stat.vacationCnt || 0;
  }

  function renderCalendar() {
    const year = currentDate.getFullYear();
    const month = currentDate.getMonth();
    calendarTitle.textContent = year + '년 ' + (month + 1) + '월';

    const firstDay = new Date(year, month, 1);
    const startDate = new Date(year, month, 1 - firstDay.getDay());
    const todayStr = formatDate(new Date());

    let html = '';
    for (let week = 0; week < 6; week++) {
      html += '<tr>';
      for (let day = 0; day < 7; day++) {
        const cellDate = new Date(startDate);
        cellDate.setDate(startDate.getDate() + (week * 7) + day);
        const dateStr = formatDate(cellDate);
        const isOther = cellDate.getMonth() !== month;
        const dayClass = day === 0 ? 'sun' : (day === 6 ? 'sat' : '');
        const todayClass = dateStr === todayStr ? 'today' : '';
        const items = getSchedulesByDate(dateStr);

        html += '<td class="' + dayClass + ' ' + todayClass + (isOther ? ' other-month' : '') + '">';
        html += '<div class="day-num">' + cellDate.getDate() + '</div>';

        items.slice(0, 5).forEach(function (item) {
          html += '<button type="button" class="schedule-chip ' + item.scheduleTy + '" title="' + escapeHtml(item.scheduleTtl) + '">';
          html += escapeHtml(item.scheduleTtl);
          html += '</button>';
        });

        if (items.length > 5) html += '<div class="more-count">전체 +' + (items.length - 5) + '</div>';
        html += '</td>';
      }
      html += '</tr>';
    }
    calendarBody.innerHTML = html;
  }

  function getSchedulesByDate(dateStr) {
    return scheduleList.filter(function (item) {
      return item.startDt <= dateStr && item.endDt >= dateStr;
    });
  }

  function renderList() {
    if (!scheduleList.length) {
      scheduleListBody.innerHTML = '<tr><td colspan="5">조회된 일정이 없습니다.</td></tr>';
      return;
    }

    scheduleListBody.innerHTML = scheduleList.map(function (item) {
      const period = item.startDt === item.endDt ? item.startDt : item.startDt + ' ~ ' + item.endDt;
      const person = item.userNm || item.rgtrId || '-';
      return '<tr>'
        + '<td>' + escapeHtml(item.scheduleTyNm) + '</td>'
        + '<td class="td-title">' + escapeHtml(item.scheduleTtl) + '</td>'
        + '<td>' + escapeHtml(period) + '</td>'
        + '<td>' + escapeHtml(item.locCn || '-') + '</td>'
        + '<td>' + escapeHtml(person) + '</td>'
        + '</tr>';
    }).join('');
  }

  function saveVacation() {
    const userNo = document.getElementById('vacUserNo').value;
    const title = document.getElementById('vacTitle').value.trim();
    const startDt = document.getElementById('vacStartDt').value;
    const endDt = document.getElementById('vacEndDt').value;

    if (!userNo) { alert('직원을 선택해 주세요.'); return; }
    if (!title) { alert('휴가 제목을 입력해 주세요.'); return; }
    if (!startDt || !endDt) { alert('휴가 기간을 선택해 주세요.'); return; }
    if (startDt > endDt) { alert('종료일은 시작일보다 빠를 수 없습니다.'); return; }

    fetch(contextPath + '/manager/aptScheduleCalendar/' + mgmtOfcNo + '/vacation', {
      method: 'POST',
      headers: Object.assign({'Content-Type': 'application/json'}, csrfHeader && csrfToken ? {[csrfHeader]: csrfToken} : {}),
      body: JSON.stringify({ userNo: userNo, scheduleTtl: title, startDt: startDt, endDt: endDt, colorCd: 'PURPLE' })
    })
      .then(function (res) { return res.json(); })
      .then(function (data) {
        alert(data.message || '처리되었습니다.');
        if (data.success) {
          closeVacationModal();
          loadSchedule();
        }
      })
      .catch(function () { alert('휴가 등록 중 오류가 발생했습니다.'); });
  }

  function openVacationModal() { document.getElementById('vacationModal').classList.add('active'); }
  function closeVacationModal() {
    document.getElementById('vacationModal').classList.remove('active');
    document.getElementById('vacUserNo').value = '';
    document.getElementById('vacTitle').value = '';
    document.getElementById('vacStartDt').value = '';
    document.getElementById('vacEndDt').value = '';
  }

  document.getElementById('prevMonthBtn').addEventListener('click', function () { currentDate.setMonth(currentDate.getMonth() - 1); loadSchedule(); });
  document.getElementById('nextMonthBtn').addEventListener('click', function () { currentDate.setMonth(currentDate.getMonth() + 1); loadSchedule(); });
  document.getElementById('todayBtn').addEventListener('click', function () { currentDate = new Date(); loadSchedule(); });
  document.getElementById('searchBtn').addEventListener('click', loadSchedule);
  document.getElementById('keyword').addEventListener('keydown', function (e) { if (e.key === 'Enter') loadSchedule(); });

  document.querySelectorAll('.tab-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      document.querySelectorAll('.tab-btn').forEach(function (b) { b.classList.remove('active'); });
      btn.classList.add('active');
      const tab = btn.dataset.tab;
      document.getElementById('calendarPanel').style.display = tab === 'calendar' ? 'block' : 'none';
      document.getElementById('calendarPanel').classList.toggle('active', tab === 'calendar');
      document.getElementById('listPanel').style.display = tab === 'list' ? 'block' : 'none';
      document.getElementById('listPanel').classList.toggle('active', tab === 'list');
    });
  });

  document.getElementById('openVacationBtn').addEventListener('click', openVacationModal);
  document.getElementById('closeVacationBtn').addEventListener('click', closeVacationModal);
  document.getElementById('cancelVacationBtn').addEventListener('click', closeVacationModal);
  document.getElementById('saveVacationBtn').addEventListener('click', saveVacation);

  loadSchedule();
})();
</script>
</body>
</html>
