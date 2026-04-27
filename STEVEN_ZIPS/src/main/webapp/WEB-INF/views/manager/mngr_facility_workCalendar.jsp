<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<div class="office-page" id="facilityWorkCalendarPage">

  <style>
    .work-layout {
      display: grid;
      grid-template-columns: minmax(0, 1fr) 330px;
      gap: 18px;
      align-items: start;
    }

    .calendar-card {
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: var(--r-lg);
      box-shadow: var(--shadow-sm);
      overflow: hidden;
    }

    .calendar-toolbar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 16px 22px;
      border-bottom: 1px solid var(--border);
    }

    .calendar-title {
      font-size: 17px;
      font-weight: 800;
      color: var(--text-primary);
    }

    .calendar-nav {
      display: flex;
      align-items: center;
      gap: 6px;
    }

    .calendar-filter-row {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 14px 22px;
      border-bottom: 1px solid var(--border);
      background: #fafafa;
      flex-wrap: wrap;
    }

    .calendar-grid {
      padding: 16px 22px 22px;
    }

    .calendar-week,
    .calendar-days {
      display: grid;
      grid-template-columns: repeat(7, minmax(0, 1fr));
    }

    .calendar-week div {
      padding: 8px 6px;
      font-size: 11px;
      font-weight: 700;
      color: var(--text-tertiary);
      text-align: center;
    }

    .calendar-day {
      min-height: 112px;
      border: 1px solid var(--border);
      margin: -1px 0 0 -1px;
      padding: 8px;
      background: #fff;
    }

    .calendar-day.is-muted {
      background: #fafafa;
    }

    .calendar-day.is-today {
      background: #f8fbff;
      box-shadow: inset 0 0 0 1px var(--btn-primary);
    }

    .day-num {
      font-size: 12px;
      font-weight: 700;
      color: var(--text-secondary);
      margin-bottom: 6px;
    }

    .event-chip {
      width: 100%;
      border-radius: 5px;
      padding: 4px 6px;
      margin-bottom: 4px;
      font-size: 11px;
      font-weight: 600;
      text-align: left;
      cursor: pointer;
      line-height: 1.35;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .event-contract {
      background: #f5f0e8;
      color: #7a4e18;
      border: 1px solid #ddc89a;
    }

    .event-check {
      background: #ecf4ee;
      color: #1e6040;
      border: 1px solid #b8dcc4;
    }

    .side-panel {
      display: flex;
      flex-direction: column;
      gap: 14px;
    }

    .mini-list {
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .mini-item {
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      padding: 10px 12px;
      background: #fff;
      cursor: pointer;
    }

    .mini-item:hover {
      background: #f9fafb;
    }

    .mini-item-title {
      font-size: 13px;
      font-weight: 700;
      color: var(--text-primary);
    }

    .mini-item-meta {
      font-size: 11px;
      color: var(--text-tertiary);
      margin-top: 3px;
    }

    .status-row {
      display: grid;
      grid-template-columns: repeat(2, minmax(0, 1fr));
      gap: 8px;
    }

    .status-box {
      border: 1px solid var(--border);
      border-radius: var(--r-sm);
      padding: 12px;
      background: #fff;
    }

    .status-box strong {
      display: block;
      font-size: 20px;
      line-height: 1;
      color: var(--text-primary);
    }

    .status-box span {
      display: block;
      font-size: 11px;
      color: var(--text-tertiary);
      margin-top: 5px;
    }

    .work-status-actions {
      display: flex;
      gap: 4px;
      align-items: center;
    }

    @media (max-width: 1100px) {
      .work-layout {
        grid-template-columns: 1fr;
      }
    }
  </style>

  <div class="page-header">
    <div class="page-title-block">
      <h2>공사·점검 일정</h2>
      <p>공사 계약 기간과 시설 점검일을 기준으로 일정을 확인하고, 진행 중인 점검 작업을 관리합니다.</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-secondary" data-action="today">
        <span class="material-symbols-rounded">today</span>
        오늘
      </button>
      <button type="button" class="btn btn-primary" data-action="open-create">
        <span class="material-symbols-rounded">add</span>
        점검 등록
      </button>
    </div>
  </div>

  <div class="tab-bar">
    <button type="button" class="tab-btn active" data-tab="calendar">
      <span class="material-symbols-rounded">calendar_month</span>
      일정 캘린더
    </button>
    <button type="button" class="tab-btn" data-tab="work">
      <span class="material-symbols-rounded">task_alt</span>
      진행 작업 관리
    </button>
  </div>

  <div class="tab-panel active" id="calendarTab">
    <div class="work-layout">
      <div class="calendar-card">
        <div class="calendar-toolbar">
          <div class="calendar-title" id="calendarTitle">2026년 4월</div>
          <div class="calendar-nav">
            <button type="button" class="btn btn-secondary btn-sm" data-action="prev-month">
              <span class="material-symbols-rounded">chevron_left</span>
            </button>
            <button type="button" class="btn btn-secondary btn-sm" data-action="next-month">
              <span class="material-symbols-rounded">chevron_right</span>
            </button>
          </div>
        </div>

        <div class="calendar-filter-row">
          <select class="form-select" id="filterWorkType" style="width: 150px;">
            <option value="">전체 일정</option>
            <option value="CONTRACT">공사/계약</option>
            <option value="CHECK">점검</option>
          </select>

          <select class="form-select" id="filterStatus" style="width: 150px;">
            <option value="">상태 전체</option>
            <option value="WAIT">예정</option>
            <option value="PROC">진행중</option>
            <option value="DONE">완료</option>
          </select>

          <input type="date" class="form-input" id="filterStartDate" style="width: 150px;">
          <input type="date" class="form-input" id="filterEndDate" style="width: 150px;">

          <button type="button" class="btn btn-primary" data-action="search">조회</button>
          <button type="button" class="btn btn-secondary" data-action="reset">초기화</button>
        </div>

        <div class="calendar-grid">
          <div class="calendar-week">
            <div>일</div>
            <div>월</div>
            <div>화</div>
            <div>수</div>
            <div>목</div>
            <div>금</div>
            <div>토</div>
          </div>
          <div class="calendar-days" id="calendarDays"></div>
        </div>
      </div>

      <div class="side-panel">
        <div class="panel">
          <div class="panel-header">
            <div class="panel-title">
              <span class="material-symbols-rounded">event_available</span>
              오늘의 작업
            </div>
          </div>
          <div class="panel-body">
            <div class="mini-list" id="todayList"></div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <div class="panel-title">
              <span class="material-symbols-rounded">query_stats</span>
              이달의 작업 현황
            </div>
          </div>
          <div class="panel-body">
            <div class="status-row">
              <div class="status-box">
                <strong id="monthTotal">0</strong>
                <span>전체 일정</span>
              </div>
              <div class="status-box">
                <strong id="monthContract">0</strong>
                <span>공사/계약</span>
              </div>
              <div class="status-box">
                <strong id="monthCheck">0</strong>
                <span>점검</span>
              </div>
              <div class="status-box">
                <strong id="monthDone">0</strong>
                <span>완료</span>
              </div>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-header">
            <div class="panel-title">
              <span class="material-symbols-rounded">list_alt</span>
              선택 월 일정
            </div>
          </div>
          <div class="panel-body">
            <div class="mini-list" id="monthList"></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="tab-panel" id="workTab">
    <div class="filter-card">
      <select class="form-select" id="workFilterStatus" style="width: 150px;">
        <option value="">상태 전체</option>
        <option value="WAIT">예정</option>
        <option value="PROC">진행중</option>
        <option value="DONE">완료</option>
      </select>

      <select class="form-select" id="workFilterType" style="width: 150px;">
        <option value="">점검유형 전체</option>
        <option value="REG">정기</option>
        <option value="SAFE">안전</option>
        <option value="EMER">긴급</option>
      </select>

      <div class="search-wrap" style="width: 280px;">
        <span class="material-symbols-rounded">search</span>
        <input type="text" class="form-input" id="workKeyword" placeholder="시설번호, 업체번호, 내용 검색">
      </div>

      <button type="button" class="btn btn-primary" data-action="work-search">조회</button>
      <button type="button" class="btn btn-secondary" data-action="work-reset">초기화</button>
    </div>

    <div class="panel">
      <div class="panel-header">
        <div class="panel-title">
          <span class="material-symbols-rounded">engineering</span>
          진행 작업 목록
        </div>
        <span class="list-count">FACILITY_CHECK_HSTRY 기준</span>
      </div>

      <div class="table-wrap">
        <table class="tbl">
          <thead>
          <tr>
            <th>점검이력번호</th>
            <th>시설번호</th>
            <th>업체번호</th>
            <th>점검유형</th>
            <th>점검일자</th>
            <th>상태</th>
            <th>점검내용</th>
            <th style="width: 220px;">관리</th>
          </tr>
          </thead>
          <tbody id="workTbody"></tbody>
        </table>
      </div>
    </div>
  </div>

  <div class="modal-overlay" id="workModal">
    <div class="modal modal-lg">
      <div class="modal-header">
        <h3 class="modal-title" id="workModalTitle">점검 등록</h3>
        <button type="button" class="modal-close" data-action="close-modal">
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>

      <form id="workForm">
        <div class="modal-body">
          <input type="hidden" id="formMode" value="create">
          <input type="hidden" id="workType" value="CHECK">

          <div class="form-section">
            <div class="form-section-title">
              <span class="material-symbols-rounded">fact_check</span>
              점검 기본 정보
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">시설점검이력번호</label>
                <input type="text" class="form-input" id="facChkHstryNo" placeholder="신규 등록 시 자동 생성">
              </div>
              <div class="form-field">
                <label class="field-label">점검일자 <span class="req">*</span></label>
                <input type="date" class="form-input" id="chkDt" required>
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">시설번호 <span class="req">*</span></label>
                <input type="text" class="form-input" id="facilityNo" required>
              </div>
              <div class="form-field">
                <label class="field-label">업체번호</label>
                <input type="text" class="form-input" id="partnerNo">
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">점검유형코드</label>
                <select class="form-select" id="chkTyCd">
                  <option value="REG">정기</option>
                  <option value="SAFE">안전</option>
                  <option value="EMER">긴급</option>
                </select>
              </div>
              <div class="form-field">
                <label class="field-label">점검상태코드</label>
                <select class="form-select" id="chkSttsCd">
                  <option value="WAIT">예정</option>
                  <option value="PROC">진행중</option>
                  <option value="DONE">완료</option>
                </select>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="form-section-title">
              <span class="material-symbols-rounded">notes</span>
              점검 내용
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">점검내용</label>
                <textarea class="form-textarea" id="chkCn"></textarea>
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">비고</label>
                <textarea class="form-textarea" id="rmk"></textarea>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-action="close-modal">닫기</button>
          <button type="button" class="btn btn-primary" id="detailEditBtn" data-action="change-edit" style="display:none;">수정하기</button>
          <button type="button" class="btn btn-danger" id="deleteBtn" data-action="delete" style="display:none;">삭제</button>
          <button type="submit" class="btn btn-primary" id="saveBtn">저장</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  (function () {
    const page = document.getElementById('facilityWorkCalendarPage');
    if (!page || page.dataset.bound === 'true') return;
    page.dataset.bound = 'true';

    let currentDate = new Date(2026, 3, 1);
    let currentDetailId = null;

    const workList = [
      {
        id: 'FC-001',
        workType: 'CONTRACT',
        title: '승강기 정기보수 계약',
        facilityNo: 'FAC-001',
        partnerNo: 'PT-001',
        startDate: '2026-04-03',
        endDate: '2026-04-07',
        status: 'DONE',
        statusNm: '완료',
        chkTyCd: '',
        content: '계약 기간 기준 일정입니다.',
        rmk: '공사/계약 일정은 조회 중심으로 표시합니다.'
      },
      {
        id: 'FCH-001',
        workType: 'CHECK',
        title: '소방설비 정기점검',
        facilityNo: 'FAC-004',
        partnerNo: 'PT-003',
        startDate: '2026-04-15',
        endDate: '2026-04-15',
        status: 'DONE',
        statusNm: '완료',
        chkTyCd: 'REG',
        content: '소방설비 정기 점검 완료',
        rmk: '특이사항 없음'
      },
      {
        id: 'FCH-002',
        workType: 'CHECK',
        title: '급수펌프 긴급점검',
        facilityNo: 'FAC-014',
        partnerNo: 'PT-002',
        startDate: '2026-04-27',
        endDate: '2026-04-27',
        status: 'PROC',
        statusNm: '진행중',
        chkTyCd: 'EMER',
        content: '지하 급수펌프 소음 확인 및 부품 점검',
        rmk: '완료 후 재점검 필요'
      },
      {
        id: 'FCH-003',
        workType: 'CHECK',
        title: '전기실 안전점검',
        facilityNo: 'FAC-008',
        partnerNo: 'PT-004',
        startDate: '2026-04-30',
        endDate: '2026-04-30',
        status: 'WAIT',
        statusNm: '예정',
        chkTyCd: 'SAFE',
        content: '전기실 분전반 및 차단기 안전점검 예정',
        rmk: ''
      }
    ];

    function pad(num) {
      return String(num).padStart(2, '0');
    }

    function toDateText(date) {
      return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate());
    }

    function getTypeNm(type) {
      if (type === 'CONTRACT') return '공사/계약';
      if (type === 'CHECK') return '점검';
      return type;
    }

    function getChkTyNm(code) {
      if (code === 'REG') return '정기';
      if (code === 'SAFE') return '안전';
      if (code === 'EMER') return '긴급';
      return '-';
    }

    function getStatusNm(code) {
      if (code === 'WAIT') return '예정';
      if (code === 'PROC') return '진행중';
      if (code === 'DONE') return '완료';
      return code;
    }

    function statusBadge(code) {
      if (code === 'WAIT') return '<span class="badge badge-orange">예정</span>';
      if (code === 'PROC') return '<span class="badge badge-blue">진행중</span>';
      if (code === 'DONE') return '<span class="badge badge-green">완료</span>';
      return '<span class="badge badge-gray">' + code + '</span>';
    }

    function findWork(id) {
      return workList.find(function (item) {
        return item.id === id;
      });
    }

    function isEventOnDate(item, dateText) {
      return item.startDate <= dateText && item.endDate >= dateText;
    }

    function getFilteredCalendarList() {
      const type = document.getElementById('filterWorkType').value;
      const status = document.getElementById('filterStatus').value;
      const start = document.getElementById('filterStartDate').value;
      const end = document.getElementById('filterEndDate').value;

      return workList.filter(function (item) {
        const matchType = !type || item.workType === type;
        const matchStatus = !status || item.status === status;
        const matchStart = !start || item.endDate >= start;
        const matchEnd = !end || item.startDate <= end;
        return matchType && matchStatus && matchStart && matchEnd;
      });
    }

    function getMonthEvents(list) {
      const year = currentDate.getFullYear();
      const month = currentDate.getMonth();
      const monthStart = year + '-' + pad(month + 1) + '-01';
      const monthEnd = year + '-' + pad(month + 1) + '-' + pad(new Date(year, month + 1, 0).getDate());

      return list.filter(function (item) {
        return item.endDate >= monthStart && item.startDate <= monthEnd;
      });
    }

    function renderCalendar() {
      const list = getFilteredCalendarList();
      const year = currentDate.getFullYear();
      const month = currentDate.getMonth();

      document.getElementById('calendarTitle').textContent = year + '년 ' + (month + 1) + '월';

      const firstDay = new Date(year, month, 1);
      const startDay = firstDay.getDay();
      const lastDate = new Date(year, month + 1, 0).getDate();
      const prevLastDate = new Date(year, month, 0).getDate();

      const todayText = '2026-04-27';
      const daysWrap = document.getElementById('calendarDays');
      daysWrap.innerHTML = '';

      for (let i = 0; i < 42; i++) {
        let dayNum;
        let cellDate;
        let muted = false;

        if (i < startDay) {
          dayNum = prevLastDate - startDay + i + 1;
          cellDate = new Date(year, month - 1, dayNum);
          muted = true;
        } else if (i >= startDay + lastDate) {
          dayNum = i - startDay - lastDate + 1;
          cellDate = new Date(year, month + 1, dayNum);
          muted = true;
        } else {
          dayNum = i - startDay + 1;
          cellDate = new Date(year, month, dayNum);
        }

        const dateText = toDateText(cellDate);
        const dayEvents = list.filter(function (item) {
          return isEventOnDate(item, dateText);
        });

        const dayEl = document.createElement('div');
        dayEl.className = 'calendar-day' + (muted ? ' is-muted' : '') + (dateText === todayText ? ' is-today' : '');
        dayEl.innerHTML = '<div class="day-num">' + dayNum + '</div>';

        dayEvents.forEach(function (item) {
          const btn = document.createElement('button');
          btn.type = 'button';
          btn.className = 'event-chip ' + (item.workType === 'CONTRACT' ? 'event-contract' : 'event-check');
          btn.dataset.action = 'detail';
          btn.dataset.id = item.id;
          btn.textContent = item.title;
          dayEl.appendChild(btn);
        });

        daysWrap.appendChild(dayEl);
      }

      renderSide(list);
    }

    function renderSide(list) {
      const monthEvents = getMonthEvents(list);
      const todayEvents = list.filter(function (item) {
        return isEventOnDate(item, '2026-04-27');
      });

      document.getElementById('monthTotal').textContent = monthEvents.length;
      document.getElementById('monthContract').textContent = monthEvents.filter(item => item.workType === 'CONTRACT').length;
      document.getElementById('monthCheck').textContent = monthEvents.filter(item => item.workType === 'CHECK').length;
      document.getElementById('monthDone').textContent = monthEvents.filter(item => item.status === 'DONE').length;

      renderMiniList('todayList', todayEvents);
      renderMiniList('monthList', monthEvents);
    }

    function renderMiniList(targetId, list) {
      const wrap = document.getElementById(targetId);
      wrap.innerHTML = '';

      if (list.length === 0) {
        wrap.innerHTML = '<div class="mini-item"><div class="mini-item-meta">조회된 일정이 없습니다.</div></div>';
        return;
      }

      list.forEach(function (item) {
        const div = document.createElement('div');
        div.className = 'mini-item';
        div.dataset.action = 'detail';
        div.dataset.id = item.id;
        div.innerHTML =
                '<div class="mini-item-title">' + item.title + '</div>' +
                '<div class="mini-item-meta">' + item.startDate + ' ~ ' + item.endDate + ' · ' + item.facilityNo + '</div>';
        wrap.appendChild(div);
      });
    }

    function renderWorkTable() {
      const status = document.getElementById('workFilterStatus').value;
      const type = document.getElementById('workFilterType').value;
      const keyword = document.getElementById('workKeyword').value.trim();

      const list = workList.filter(function (item) {
        if (item.workType !== 'CHECK') return false;

        const matchStatus = !status || item.status === status;
        const matchType = !type || item.chkTyCd === type;
        const matchKeyword = !keyword ||
                item.facilityNo.includes(keyword) ||
                item.partnerNo.includes(keyword) ||
                item.content.includes(keyword);

        return matchStatus && matchType && matchKeyword;
      });

      const tbody = document.getElementById('workTbody');
      tbody.innerHTML = '';

      list.forEach(function (item) {
        const tr = document.createElement('tr');
        tr.innerHTML =
                '<td class="td-mono">' + item.id + '</td>' +
                '<td>' + item.facilityNo + '</td>' +
                '<td>' + item.partnerNo + '</td>' +
                '<td>' + getChkTyNm(item.chkTyCd) + '</td>' +
                '<td>' + item.startDate + '</td>' +
                '<td>' + statusBadge(item.status) + '</td>' +
                '<td>' + item.content + '</td>' +
                '<td>' +
                '<div class="work-status-actions">' +
                '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-id="' + item.id + '">상세</button>' +
                '<button type="button" class="btn btn-xs btn-edit" data-action="edit" data-id="' + item.id + '">수정</button>' +
                '<button type="button" class="btn btn-xs btn-primary" data-action="complete" data-id="' + item.id + '">완료</button>' +
                '</div>' +
                '</td>';

        tbody.appendChild(tr);
      });
    }

    function openModal(mode, data) {
      currentDetailId = data ? data.id : null;

      document.getElementById('formMode').value = mode;
      document.getElementById('workType').value = data ? data.workType : 'CHECK';

      document.getElementById('workModalTitle').textContent =
              mode === 'create' ? '점검 등록' :
                      mode === 'detail' ? '일정 상세' :
                              '점검 수정';

      document.getElementById('facChkHstryNo').value = data ? data.id : '';
      document.getElementById('facilityNo').value = data ? data.facilityNo : '';
      document.getElementById('partnerNo').value = data ? data.partnerNo : '';
      document.getElementById('chkDt').value = data ? data.startDate : '';
      document.getElementById('chkTyCd').value = data && data.chkTyCd ? data.chkTyCd : 'REG';
      document.getElementById('chkSttsCd').value = data ? data.status : 'WAIT';
      document.getElementById('chkCn').value = data ? data.content : '';
      document.getElementById('rmk').value = data ? data.rmk : '';

      const isContract = data && data.workType === 'CONTRACT';
      const readonly = mode === 'detail' || isContract;

      page.querySelectorAll('#workForm input, #workForm select, #workForm textarea').forEach(function (el) {
        if (el.id !== 'formMode' && el.id !== 'workType') {
          el.disabled = readonly;
        }
      });

      document.getElementById('detailEditBtn').style.display =
              mode === 'detail' && !isContract ? 'inline-flex' : 'none';

      document.getElementById('saveBtn').style.display =
              mode === 'detail' || isContract ? 'none' : 'inline-flex';

      document.getElementById('deleteBtn').style.display =
              mode === 'edit' ? 'inline-flex' : 'none';

      document.getElementById('workModal').style.display = 'flex';
    }

    function changeToEditMode() {
      const data = findWork(currentDetailId);
      if (!data || data.workType === 'CONTRACT') return;
      openModal('edit', data);
    }

    function closeModal() {
      document.getElementById('workModal').style.display = 'none';
      page.querySelectorAll('#workForm input, #workForm select, #workForm textarea').forEach(function (el) {
        el.disabled = false;
      });
    }

    function setComplete(id) {
      const item = findWork(id);
      if (!item || item.workType !== 'CHECK') return;

      item.status = 'DONE';
      item.statusNm = '완료';

      renderCalendar();
      renderWorkTable();
    }

    page.addEventListener('click', function (event) {
      const tabBtn = event.target.closest('[data-tab]');
      if (tabBtn) {
        page.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
        tabBtn.classList.add('active');

        page.querySelectorAll('.tab-panel').forEach(panel => panel.classList.remove('active'));

        if (tabBtn.dataset.tab === 'calendar') {
          document.getElementById('calendarTab').classList.add('active');
        }

        if (tabBtn.dataset.tab === 'work') {
          document.getElementById('workTab').classList.add('active');
          renderWorkTable();
        }

        return;
      }

      const btn = event.target.closest('[data-action]');
      if (!btn) return;

      const action = btn.dataset.action;
      const id = btn.dataset.id;
      const data = id ? findWork(id) : null;

      if (action === 'prev-month') {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
      }

      if (action === 'next-month') {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
      }

      if (action === 'today') {
        currentDate = new Date(2026, 3, 1);
        renderCalendar();
      }

      if (action === 'search') renderCalendar();

      if (action === 'reset') {
        document.getElementById('filterWorkType').value = '';
        document.getElementById('filterStatus').value = '';
        document.getElementById('filterStartDate').value = '';
        document.getElementById('filterEndDate').value = '';
        renderCalendar();
      }

      if (action === 'work-search') renderWorkTable();

      if (action === 'work-reset') {
        document.getElementById('workFilterStatus').value = '';
        document.getElementById('workFilterType').value = '';
        document.getElementById('workKeyword').value = '';
        renderWorkTable();
      }

      if (action === 'open-create') openModal('create');
      if (action === 'detail' && data) openModal('detail', data);
      if (action === 'edit' && data) openModal('edit', data);
      if (action === 'change-edit') changeToEditMode();
      if (action === 'complete') setComplete(id);
      if (action === 'close-modal') closeModal();

      if (action === 'delete') {
        alert('삭제는 FAC_CHK_HSTRY_NO 기준으로 처리하면 됩니다.');
        closeModal();
      }
    });

    document.getElementById('workForm').addEventListener('submit', function (event) {
      event.preventDefault();
      alert('저장 시 FACILITY_CHECK_HSTRY 기준으로 insert/update 처리하면 됩니다.');
      closeModal();
    });

    renderCalendar();
    renderWorkTable();
  })();
</script>