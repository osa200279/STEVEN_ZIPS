<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
  .vac-body-title {
    margin-bottom: 18px;
  }

  .vac-body-title h2 {
    margin: 0;
    font-size: 22px;
    font-weight: 800;
    color: #111827;
  }

  .vac-body-title p {
    margin: 6px 0 0;
    font-size: 13px;
    color: #6b7280;
  }

  .vac-top-row {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 16px;
    margin-bottom: 16px;
  }

  .vac-top-actions {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
  }

  .vac-summary-row {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 14px;
    margin-bottom: 18px;
  }

  .vac-summary-card {
    min-height: 118px;
    padding: 18px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    box-sizing: border-box;
  }

  .vac-summary-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
  }

  .vac-summary-label {
    font-size: 13px;
    font-weight: 700;
    color: #4b5563;
  }

  .vac-summary-value {
    font-size: 21px;
    font-weight: 800;
    color: #111827;
    margin-bottom: 8px;
    line-height: 1;
  }

  .vac-summary-desc {
    font-size: 12px;
    color: #6b7280;
    line-height: 1.5;
  }

  .vac-main-grid {
    display: grid;
    grid-template-columns: minmax(0, 1.9fr) 380px;
    gap: 24px;
    align-items: stretch;
    margin-bottom: 18px;
  }

  .vac-calendar-panel {
    height: 720px;
    display: flex;
    flex-direction: column;
    min-width: 0;
    overflow: hidden;
  }

  .vac-calendar-panel-inner {
    flex: 1;
    min-height: 0;
    padding: 16px;
    box-sizing: border-box;
  }

  .vac-side-stack {
    height: 720px;
    display: grid;
    grid-template-rows: 1fr 0.9fr;
    gap: 18px;
    min-height: 0;
  }

  .vac-side-card {
    min-height: 0;
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .vac-side-panel-body {
    padding: 16px;
    display: flex;
    flex-direction: column;
    min-height: 0;
    height: 100%;
    box-sizing: border-box;
  }

  .vac-side-panel-title {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 10px;
    margin-bottom: 14px;
    flex: 0 0 auto;
  }

  .vac-side-panel-title h4 {
    margin: 0;
    font-size: 15px;
    font-weight: 800;
    color: #111827;
  }

  .vac-side-panel-title p {
    margin: 4px 0 0;
    font-size: 12px;
    color: #6b7280;
    line-height: 1.45;
  }

  .vac-status-list,
  .vac-legend-list {
    min-height: 0;
    overflow-y: auto;
    padding-right: 4px;
    box-sizing: border-box;
  }

  .vac-status-list {
    flex: 1;
    max-height: 292px;
  }

  .vac-legend-list {
    flex: 1;
  }

  .vac-status-item,
  .vac-legend-item {
    border: 1px solid var(--border);
    border-radius: 12px;
    background: #fff;
    padding: 12px 14px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    box-sizing: border-box;
  }

  .vac-status-list .vac-status-item + .vac-status-item,
  .vac-legend-list .vac-legend-item + .vac-legend-item {
    margin-top: 10px;
  }

  .vac-status-left,
  .vac-legend-left {
    min-width: 0;
    display: flex;
    align-items: center;
    gap: 10px;
    flex: 1;
  }

  .vac-person-dot {
    width: 10px;
    height: 10px;
    border-radius: 50%;
    flex: 0 0 10px;
  }

  .vac-status-name,
  .vac-legend-name {
    font-size: 13px;
    font-weight: 800;
    color: #111827;
    line-height: 1.2;
  }

  .vac-status-meta,
  .vac-legend-meta {
    margin-top: 4px;
    font-size: 12px;
    color: #6b7280;
    line-height: 1.4;
  }

  .vac-role-tag {
    min-height: 24px;
    padding: 4px 10px;
    border-radius: 999px;
    display: inline-flex;
    align-items: center;
    font-size: 11px;
    font-weight: 800;
    border: 1px solid transparent;
    white-space: nowrap;
    box-sizing: border-box;
  }

  .vac-bottom-panel .filter-bar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
  }

  .vac-filter-actions {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
  }

  .vac-table-scroll {
    max-height: 260px;
    overflow: auto;
  }

  .vac-empty {
    padding: 28px 12px;
    text-align: center;
    color: #6b7280;
    font-size: 13px;
  }

  .vac-role-head {
    background: #eff6e7;
    color: #66851f;
    border-color: #d5e7bb;
  }

  .vac-role-admin {
    background: #eef5fb;
    color: #3f77a6;
    border-color: #cfe1f1;
  }

  .vac-role-fac {
    background: #edf5f1;
    color: #46856b;
    border-color: #cce0d7;
  }

  .vac-role-acc {
    background: #fbf5e9;
    color: #b07c1e;
    border-color: #ecd8b0;
  }

  .vac-dot-head { background: #7ba122; }
  .vac-dot-admin { background: #4f86b6; }
  .vac-dot-fac { background: #5a9b7d; }
  .vac-dot-acc { background: #cc9120; }

  #vacationCalendar {
    width: 100%;
    height: 100%;
  }

  .fc {
    font-family: inherit;
    height: 100%;
  }

  .fc .fc-toolbar {
    margin-bottom: 14px !important;
  }

  .fc .fc-toolbar-title {
    font-size: 19px;
    font-weight: 800;
    color: #111827;
  }

  .fc .fc-button {
    background: #6b8e23;
    border-color: #6b8e23;
    box-shadow: none;
    border-radius: 10px;
    padding: 6px 12px;
    font-size: 12px;
    font-weight: 700;
  }

  .fc .fc-button:hover,
  .fc .fc-button:focus,
  .fc .fc-button:active,
  .fc .fc-button.fc-button-active {
    background: #5d7c1f !important;
    border-color: #5d7c1f !important;
    box-shadow: none !important;
  }

  .fc .fc-scrollgrid {
    border-radius: 14px;
    overflow: hidden;
    border: 1px solid var(--border);
  }

  .fc .fc-col-header-cell {
    background: #f7f7f5;
  }

  .fc .fc-col-header-cell-cushion {
    font-size: 12px;
    font-weight: 700;
    color: #4b5563;
    padding: 10px 0;
    text-decoration: none;
  }

  .fc .fc-daygrid-day-frame {
    min-height: 102px;
  }

  .fc .fc-daygrid-day-number {
    font-size: 12px;
    font-weight: 800;
    color: #111827;
    padding: 8px 8px 0 8px;
    text-decoration: none;
  }

  .fc .fc-day-today {
    background: rgba(107, 142, 35, 0.06) !important;
  }

  .fc .fc-daygrid-event-harness {
    margin: 0 6px 4px;
  }

  .fc .fc-daygrid-event {
    border-radius: 999px;
    padding: 3px 8px;
    font-size: 11px;
    font-weight: 700;
    line-height: 1.3;
  }

  .fc .fc-daygrid-event-dot {
    display: none;
  }

  .fc .fc-more-link {
    font-size: 11px;
    font-weight: 700;
    color: #6b7280;
    text-decoration: none;
    padding-left: 8px;
  }

  .fc-event.role-head {
    background: #eff6e7 !important;
    border: 1px solid #d5e7bb !important;
    color: #66851f !important;
  }

  .fc-event.role-admin {
    background: #eef5fb !important;
    border: 1px solid #cfe1f1 !important;
    color: #3f77a6 !important;
  }

  .fc-event.role-fac {
    background: #edf5f1 !important;
    border: 1px solid #cce0d7 !important;
    color: #46856b !important;
  }

  .fc-event.role-acc {
    background: #fbf5e9 !important;
    border: 1px solid #ecd8b0 !important;
    color: #b07c1e !important;
  }

  .vac-status-list::-webkit-scrollbar,
  .vac-legend-list::-webkit-scrollbar,
  .vac-table-scroll::-webkit-scrollbar {
    width: 8px;
    height: 8px;
  }

  .vac-status-list::-webkit-scrollbar-thumb,
  .vac-legend-list::-webkit-scrollbar-thumb,
  .vac-table-scroll::-webkit-scrollbar-thumb {
    background: #cfd4dc;
    border-radius: 999px;
  }

  .vac-status-list::-webkit-scrollbar-track,
  .vac-legend-list::-webkit-scrollbar-track,
  .vac-table-scroll::-webkit-scrollbar-track {
    background: transparent;
  }

  @media (max-width: 1360px) {
    .vac-summary-row {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .vac-main-grid {
      grid-template-columns: 1fr;
      gap: 18px;
    }

    .vac-calendar-panel,
    .vac-side-stack {
      height: auto;
    }

    .vac-side-stack {
      grid-template-rows: auto auto;
    }

    .vac-status-list,
    .vac-legend-list {
      max-height: 280px;
    }
  }

  @media (max-width: 900px) {
    .vac-top-row {
      flex-direction: column;
      align-items: stretch;
    }

    .vac-summary-row {
      grid-template-columns: 1fr;
    }
  }
</style>

<div class="vac-top-row">
  <div class="vac-body-title">
    <h2>휴가 일정 관리</h2>
    <p>직원별 휴가 일정을 월간 일정과 예정 내역으로 함께 확인합니다. 직무별 색상으로 빠르게 구분할 수 있습니다.</p>
  </div>

  <div class="vac-top-actions">
    <button class="btn btn-secondary">
      <span class="material-symbols-rounded">download</span>일정 내보내기
    </button>
    <button class="btn btn-primary" onclick="openVacationModal('modalVacationCreate')">
      <span class="material-symbols-rounded">event_available</span>휴가 일정 등록
    </button>
  </div>
</div>

<div class="vac-summary-row">
  <div class="panel vac-summary-card">
    <div>
      <div class="vac-summary-head">
        <div class="vac-summary-label">이번 달 휴가 일정</div>
        <span class="material-symbols-rounded" style="color:#6b8e23;">calendar_month</span>
      </div>
      <div class="vac-summary-value" id="vacMonthCount">0</div>
    </div>
    <div class="vac-summary-desc">월간 휴가 등록 건수와 운영 공백 가능 구간을 함께 확인합니다.</div>
  </div>

  <div class="panel vac-summary-card">
    <div>
      <div class="vac-summary-head">
        <div class="vac-summary-label">오늘 휴가</div>
        <span class="material-symbols-rounded" style="color:#4f86b6;">today</span>
      </div>
      <div class="vac-summary-value" id="vacTodayCount">0</div>
    </div>
    <div class="vac-summary-desc">오늘 부재 인원을 기준으로 현장 인력 배치를 조정할 수 있습니다.</div>
  </div>

  <div class="panel vac-summary-card">
    <div>
      <div class="vac-summary-head">
        <div class="vac-summary-label">이번 주 예정</div>
        <span class="material-symbols-rounded" style="color:#cc9120;">date_range</span>
      </div>
      <div class="vac-summary-value" id="vacWeekCount">0</div>
    </div>
    <div class="vac-summary-desc">다가오는 일정 중심으로 확인해 인수인계와 대체 근무를 준비합니다.</div>
  </div>

  <div class="panel vac-summary-card">
    <div>
      <div class="vac-summary-head">
        <div class="vac-summary-label">장기 일정</div>
        <span class="material-symbols-rounded" style="color:#5a9b7d;">event_busy</span>
      </div>
      <div class="vac-summary-value" id="vacLongCount">0</div>
    </div>
    <div class="vac-summary-desc">2일 이상 일정은 별도 체크해 업무 공백 여부를 먼저 확인합니다.</div>
  </div>
</div>

<div class="vac-main-grid">
  <div class="panel vac-calendar-panel">
    <div class="vac-calendar-panel-inner">
      <div id="vacationCalendar"></div>
    </div>
  </div>

  <div class="vac-side-stack">
    <div class="panel vac-side-card">
      <div class="vac-side-panel-body">
        <div class="vac-side-panel-title">
          <div>
            <h4>오늘 운영 현황</h4>
            <p>휴가자와 현장 인력 상태를 함께 확인합니다</p>
          </div>
          <span class="badge badge-blue">오늘</span>
        </div>

        <div class="vac-status-list">
          <div class="vac-status-item">
            <div class="vac-status-left">
              <span class="vac-person-dot vac-dot-head"></span>
              <div>
                <div class="vac-status-name">정하린</div>
                <div class="vac-status-meta">관리소장 · 운영 총괄</div>
              </div>
            </div>
            <span class="badge badge-green">근무중</span>
          </div>

          <div class="vac-status-item">
            <div class="vac-status-left">
              <span class="vac-person-dot vac-dot-admin"></span>
              <div>
                <div class="vac-status-name">이영희</div>
                <div class="vac-status-meta">행정 · 민원/입주</div>
              </div>
            </div>
            <span class="badge badge-green">근무중</span>
          </div>

          <div class="vac-status-item">
            <div class="vac-status-left">
              <span class="vac-person-dot vac-dot-acc"></span>
              <div>
                <div class="vac-status-name">박지현</div>
                <div class="vac-status-meta">회계 · 관리비 정산</div>
              </div>
            </div>
            <span class="badge badge-red">휴가중</span>
          </div>

          <div class="vac-status-item">
            <div class="vac-status-left">
              <span class="vac-person-dot vac-dot-fac"></span>
              <div>
                <div class="vac-status-name">윤서연</div>
                <div class="vac-status-meta">시설 · 전기 검침</div>
              </div>
            </div>
            <span class="badge badge-red">휴가중</span>
          </div>

          <div class="vac-status-item">
            <div class="vac-status-left">
              <span class="vac-person-dot vac-dot-fac"></span>
              <div>
                <div class="vac-status-name">김민수</div>
                <div class="vac-status-meta">시설 · 보수 대응</div>
              </div>
            </div>
            <span class="badge badge-green">근무중</span>
          </div>
        </div>
      </div>
    </div>

    <div class="panel vac-side-card">
      <div class="vac-side-panel-body">
        <div class="vac-side-panel-title">
          <div>
            <h4>직무별 범례</h4>
            <p>달력과 목록에 동일하게 적용됩니다</p>
          </div>
        </div>

        <div class="vac-legend-list">
          <div class="vac-legend-item">
            <div class="vac-legend-left">
              <span class="vac-person-dot vac-dot-head"></span>
              <div>
                <div class="vac-legend-name">관리소장</div>
                <div class="vac-legend-meta">총괄 승인 및 운영 확인</div>
              </div>
            </div>
            <span class="vac-role-tag vac-role-head">총괄</span>
          </div>

          <div class="vac-legend-item">
            <div class="vac-legend-left">
              <span class="vac-person-dot vac-dot-admin"></span>
              <div>
                <div class="vac-legend-name">행정</div>
                <div class="vac-legend-meta">민원, 공지, 입주 관련 행정</div>
              </div>
            </div>
            <span class="vac-role-tag vac-role-admin">행정</span>
          </div>

          <div class="vac-legend-item">
            <div class="vac-legend-left">
              <span class="vac-person-dot vac-dot-fac"></span>
              <div>
                <div class="vac-legend-name">시설</div>
                <div class="vac-legend-meta">점검, 보수, 현장 대응</div>
              </div>
            </div>
            <span class="vac-role-tag vac-role-fac">시설</span>
          </div>

          <div class="vac-legend-item">
            <div class="vac-legend-left">
              <span class="vac-person-dot vac-dot-acc"></span>
              <div>
                <div class="vac-legend-name">회계</div>
                <div class="vac-legend-meta">관리비, 지출, 정산</div>
              </div>
            </div>
            <span class="vac-role-tag vac-role-acc">회계</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="panel vac-bottom-panel">
  <div class="filter-bar">
    <div class="tbl-main">휴가 일정 목록</div>

    <div class="vac-filter-actions">
      <select class="form-select" id="vacStatusFilter" style="width:120px" onchange="renderVacationList()">
        <option value="">상태 전체</option>
        <option>예정</option>
        <option>진행중</option>
        <option>완료</option>
      </select>

      <select class="form-select" id="vacRoleFilter" style="width:120px" onchange="renderVacationList()">
        <option value="">직무 전체</option>
        <option>관리소장</option>
        <option>행정</option>
        <option>시설</option>
        <option>회계</option>
      </select>

      <div class="search-wrap">
        <span class="material-symbols-rounded">search</span>
        <input class="form-input" type="text" id="vacKeyword" placeholder="직원명 검색" style="width:180px" oninput="renderVacationList()" />
      </div>

      <button class="btn btn-secondary btn-sm" onclick="resetVacationFilters()">
        <span class="material-symbols-rounded">refresh</span>초기화
      </button>
    </div>
  </div>

  <div class="table-wrap vac-table-scroll">
    <table>
      <thead>
      <tr>
        <th>직원명</th>
        <th>직무</th>
        <th>시작일</th>
        <th>종료일</th>
        <th>상태</th>
        <th>비고</th>
        <th style="width:120px">관리</th>
      </tr>
      </thead>
      <tbody id="vacationTbody"></tbody>
    </table>
  </div>
</div>

<div class="modal-overlay" id="modalVacationCreate">
  <div class="modal" style="width:620px">
    <div class="modal-header">
      <div class="modal-title">휴가 일정 등록</div>
      <button class="modal-close" onclick="closeVacationModal('modalVacationCreate')">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>
    <div class="modal-body">
      <div class="form-section">
        <div class="form-section-title">
          <span class="material-symbols-rounded">person</span>직원 정보
        </div>
        <div class="form-row cols-1">
          <div class="form-group">
            <label class="form-label">직원명 <span class="req">*</span></label>
            <select class="form-select">
              <option value="">직원 선택</option>
              <option>정하린</option>
              <option>김민수</option>
              <option>이영희</option>
              <option>박지현</option>
              <option>최수진</option>
              <option>윤서연</option>
            </select>
          </div>
        </div>
      </div>

      <div class="form-section">
        <div class="form-section-title">
          <span class="material-symbols-rounded">date_range</span>일정 정보
        </div>
        <div class="form-row cols-2">
          <div class="form-group">
            <label class="form-label">시작일 <span class="req">*</span></label>
            <input class="form-input" type="date" />
          </div>
          <div class="form-group">
            <label class="form-label">종료일 <span class="req">*</span></label>
            <input class="form-input" type="date" />
          </div>
        </div>
        <div class="form-row cols-1">
          <div class="form-group">
            <label class="form-label">비고</label>
            <textarea class="form-textarea" placeholder="휴가 관련 전달 사항을 입력하세요"></textarea>
          </div>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-secondary" onclick="closeVacationModal('modalVacationCreate')">취소</button>
      <button class="btn btn-primary" onclick="closeVacationModal('modalVacationCreate')">
        <span class="material-symbols-rounded">save</span>등록
      </button>
    </div>
  </div>
</div>

<div class="modal-overlay" id="modalVacationDetail">
  <div class="modal" style="width:520px">
    <div class="modal-header">
      <div class="modal-title">휴가 일정 상세</div>
      <button class="modal-close" onclick="closeVacationModal('modalVacationDetail')">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>
    <div class="modal-body">
      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px" id="vacationDetailGrid"></div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-danger btn-sm" style="margin-right:auto"
              onclick="if(confirm('정말 삭제하시겠습니까?')) closeVacationModal('modalVacationDetail')">
        <span class="material-symbols-rounded">delete</span>삭제
      </button>
      <button class="btn btn-secondary" onclick="closeVacationModal('modalVacationDetail')">닫기</button>
      <button class="btn btn-primary" id="vacationDetailEditBtn">
        <span class="material-symbols-rounded">edit</span>수정
      </button>
    </div>
  </div>
</div>

<div class="modal-overlay" id="modalVacationEdit">
  <div class="modal" style="width:620px">
    <div class="modal-header">
      <div class="modal-title">휴가 일정 수정</div>
      <button class="modal-close" onclick="closeVacationModal('modalVacationEdit')">
        <span class="material-symbols-rounded">close</span>
      </button>
    </div>
    <div class="modal-body">
      <div class="form-section">
        <div class="form-section-title">
          <span class="material-symbols-rounded">person</span>직원 정보
        </div>
        <div class="form-row cols-1">
          <div class="form-group">
            <label class="form-label">직원명</label>
            <input class="form-input" type="text" id="editVacEmpNm" />
          </div>
        </div>
      </div>

      <div class="form-section">
        <div class="form-section-title">
          <span class="material-symbols-rounded">date_range</span>일정 정보
        </div>
        <div class="form-row cols-2">
          <div class="form-group">
            <label class="form-label">시작일</label>
            <input class="form-input" type="date" id="editVacStart" />
          </div>
          <div class="form-group">
            <label class="form-label">종료일</label>
            <input class="form-input" type="date" id="editVacEnd" />
          </div>
        </div>
        <div class="form-row cols-2">
          <div class="form-group">
            <label class="form-label">상태</label>
            <select class="form-select" id="editVacStatus">
              <option>예정</option>
              <option>진행중</option>
              <option>완료</option>
            </select>
          </div>
          <div class="form-group">
            <label class="form-label">비고</label>
            <input class="form-input" type="text" id="editVacNote" />
          </div>
        </div>
      </div>
    </div>
    <div class="modal-footer">
      <button class="btn btn-secondary" onclick="closeVacationModal('modalVacationEdit')">취소</button>
      <button class="btn btn-primary" onclick="closeVacationModal('modalVacationEdit')">
        <span class="material-symbols-rounded">save</span>저장
      </button>
    </div>
  </div>
</div>

<script>
  window.initVacationPage = function () {
    var calendarEl = document.getElementById("vacationCalendar");
    if (!calendarEl || !window.FullCalendar) return;

    if (calendarEl.dataset.rendered === "Y") return;
    calendarEl.dataset.rendered = "Y";

    var vacationList = [
      { no: "VAC001", name: "정하린", role: "관리소장", start: "2026-04-07", end: "2026-04-07", status: "완료",   note: "외부 회의 일정" },
      { no: "VAC002", name: "김민수", role: "시설",     start: "2026-04-09", end: "2026-04-09", status: "완료",   note: "오전 휴가" },
      { no: "VAC003", name: "이영희", role: "행정",     start: "2026-04-15", end: "2026-04-15", status: "완료",   note: "진료 일정" },
      { no: "VAC004", name: "박지현", role: "회계",     start: "2026-04-16", end: "2026-04-17", status: "진행중", note: "개인 사유" },
      { no: "VAC005", name: "최수진", role: "행정",     start: "2026-04-22", end: "2026-04-22", status: "예정",   note: "외부 일정" },
      { no: "VAC006", name: "김민수", role: "시설",     start: "2026-04-25", end: "2026-04-25", status: "예정",   note: "가족 행사" },
      { no: "VAC007", name: "정하린", role: "관리소장", start: "2026-04-28", end: "2026-04-28", status: "예정",   note: "휴가 사용" },
      { no: "VAC008", name: "윤서연", role: "시설",     start: "2026-04-16", end: "2026-04-16", status: "진행중", note: "반차" }
    ];

    function getStatusBadge(status) {
      if (status === "예정") return "badge-blue";
      if (status === "진행중") return "badge-yellow";
      return "badge-green";
    }

    function getRoleClass(role) {
      if (role === "관리소장") return "role-head";
      if (role === "행정") return "role-admin";
      if (role === "시설") return "role-fac";
      return "role-acc";
    }

    function getRoleTagClass(role) {
      if (role === "관리소장") return "vac-role-head";
      if (role === "행정") return "vac-role-admin";
      if (role === "시설") return "vac-role-fac";
      return "vac-role-acc";
    }

    function getRoleDotClass(role) {
      if (role === "관리소장") return "vac-dot-head";
      if (role === "행정") return "vac-dot-admin";
      if (role === "시설") return "vac-dot-fac";
      return "vac-dot-acc";
    }

    function addOneDay(dateStr) {
      var date = new Date(dateStr + "T00:00:00");
      date.setDate(date.getDate() + 1);
      var y = date.getFullYear();
      var m = String(date.getMonth() + 1).padStart(2, "0");
      var d = String(date.getDate()).padStart(2, "0");
      return y + "-" + m + "-" + d;
    }

    function renderSummary() {
      document.getElementById("vacMonthCount").textContent = vacationList.length;

      var today = "2026-04-16";
      var todayCount = vacationList.filter(function (v) {
        return v.start <= today && v.end >= today;
      }).length;
      document.getElementById("vacTodayCount").textContent = todayCount;

      var weekCount = vacationList.filter(function (v) {
        return v.start >= "2026-04-16" && v.start <= "2026-04-22";
      }).length;
      document.getElementById("vacWeekCount").textContent = weekCount;

      var longCount = vacationList.filter(function (v) {
        return v.start !== v.end;
      }).length;
      document.getElementById("vacLongCount").textContent = longCount;
    }

    window.renderVacationList = function () {
      var keywordVal = document.getElementById("vacKeyword").value.trim().toLowerCase();
      var statusVal = document.getElementById("vacStatusFilter").value;
      var roleVal = document.getElementById("vacRoleFilter").value;

      var filtered = vacationList.filter(function (v) {
        var matchedKeyword = !keywordVal || v.name.toLowerCase().indexOf(keywordVal) > -1;
        var matchedStatus = !statusVal || v.status === statusVal;
        var matchedRole = !roleVal || v.role === roleVal;
        return matchedKeyword && matchedStatus && matchedRole;
      });

      var tbody = document.getElementById("vacationTbody");
      if (!filtered.length) {
        tbody.innerHTML = '<tr><td colspan="7"><div class="vac-empty">조건에 맞는 일정이 없습니다.</div></td></tr>';
        return;
      }

      tbody.innerHTML = filtered.map(function (v) {
        return '' +
                '<tr>' +
                '<td class="tbl-main">' +
                '<div style="display:flex; align-items:center; gap:8px;">' +
                '<span class="vac-person-dot ' + getRoleDotClass(v.role) + '"></span>' +
                '<span>' + v.name + '</span>' +
                '</div>' +
                '</td>' +
                '<td><span class="vac-role-tag ' + getRoleTagClass(v.role) + '">' + v.role + '</span></td>' +
                '<td class="tbl-sub">' + v.start + '</td>' +
                '<td class="tbl-sub">' + v.end + '</td>' +
                '<td><span class="badge ' + getStatusBadge(v.status) + '">' + v.status + '</span></td>' +
                '<td class="tbl-muted">' + (v.note || '—') + '</td>' +
                '<td>' +
                '<div style="display:flex; gap:4px;">' +
                '<button class="btn btn-secondary btn-xs" onclick="openVacationDetail(\'' + v.no + '\')">상세</button>' +
                '<button class="btn btn-secondary btn-xs" onclick="openVacationEdit(\'' + v.no + '\')">수정</button>' +
                '</div>' +
                '</td>' +
                '</tr>';
      }).join("");
    };

    window.resetVacationFilters = function () {
      document.getElementById("vacKeyword").value = "";
      document.getElementById("vacStatusFilter").value = "";
      document.getElementById("vacRoleFilter").value = "";
      renderVacationList();
    };

    window.openVacationDetail = function (no) {
      var v = vacationList.find(function (x) { return x.no === no; });
      if (!v) return;

      var items = [
        ["일정번호", v.no],
        ["직원명", v.name],
        ["직무", v.role],
        ["시작일", v.start],
        ["종료일", v.end],
        ["상태", v.status],
        ["비고", v.note || "—"]
      ];

      var grid = document.getElementById("vacationDetailGrid");
      grid.innerHTML = items.map(function (i) {
        return '' +
                '<div style="padding:12px; background:var(--gray-100); border-radius:10px;">' +
                '<div style="font-size:11px; color:var(--text-tertiary); margin-bottom:4px;">' + i[0] + '</div>' +
                '<div style="font-size:13px; font-weight:700; color:#111827;">' + i[1] + '</div>' +
                '</div>';
      }).join("");

      document.getElementById("vacationDetailEditBtn").onclick = function () {
        closeVacationModal("modalVacationDetail");
        openVacationEdit(no);
      };

      openVacationModal("modalVacationDetail");
    };

    window.openVacationEdit = function (no) {
      var v = vacationList.find(function (x) { return x.no === no; });
      if (!v) return;

      document.getElementById("editVacEmpNm").value = v.name;
      document.getElementById("editVacStart").value = v.start;
      document.getElementById("editVacEnd").value = v.end;
      document.getElementById("editVacStatus").value = v.status;
      document.getElementById("editVacNote").value = v.note || "";

      openVacationModal("modalVacationEdit");
    };

    window.openVacationModal = function (id) {
      var el = document.getElementById(id);
      if (el) el.classList.add("open");
    };

    window.closeVacationModal = function (id) {
      var el = document.getElementById(id);
      if (el) el.classList.remove("open");
    };

    document.querySelectorAll(".modal-overlay").forEach(function (o) {
      o.addEventListener("click", function (e) {
        if (e.target === o) o.classList.remove("open");
      });
    });

    var events = vacationList.map(function (v) {
      return {
        id: v.no,
        title: v.name,
        start: v.start,
        end: addOneDay(v.end),
        classNames: [getRoleClass(v.role)],
        extendedProps: {
          role: v.role,
          status: v.status,
          note: v.note
        }
      };
    });

    var calendar = new FullCalendar.Calendar(calendarEl, {
      locale: "ko",
      initialView: "dayGridMonth",
      height: "100%",
      fixedWeekCount: false,
      expandRows: true,
      dayMaxEvents: 3,
      headerToolbar: {
        left: "prev,next today",
        center: "title",
        right: ""
      },
      buttonText: {
        today: "오늘"
      },
      events: events,
      eventClick: function (info) {
        openVacationDetail(info.event.id);
      },
      dateClick: function () {
        openVacationModal("modalVacationCreate");
      }
    });

    calendar.render();
    renderSummary();
    renderVacationList();
  };
</script>