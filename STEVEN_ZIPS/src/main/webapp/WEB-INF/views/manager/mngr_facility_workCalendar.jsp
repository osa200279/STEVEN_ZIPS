<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리사무소</title>

  <!-- Spring Security CSRF 토큰 -->
  <sec:csrfMetaTags/>

  <!-- 공통 한글 폰트 -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

  <!-- 공통 아이콘 폰트 -->
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <!-- 관리사무소 전체 레이아웃 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

  <!-- 관리사무소 공통 화면 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    #schedulePage .schedule-layout{display:grid;grid-template-columns:1fr 270px;gap:16px} #schedulePage .schedule-right{display:flex;flex-direction:column;gap:14px}
    #schedulePage .panel-plain{padding:0;overflow:hidden} #schedulePage .calendar-panel{margin-bottom:16px} #schedulePage .calendar-header,#schedulePage .list-header{display:flex;align-items:center;justify-content:space-between;padding:14px 20px;border-bottom:1px solid var(--border)}
    #schedulePage .calendar-title-wrap{display:flex;align-items:center;gap:12px} #schedulePage .calendar-nav{display:flex;gap:4px} #schedulePage #calTitle{font-size:18px;font-weight:800}
    #schedulePage .calendar-legend{display:flex;gap:14px;align-items:center} #schedulePage .legend-item{display:flex;align-items:center;gap:5px;font-size:11px;color:var(--text-secondary)} #schedulePage .legend-dot{width:10px;height:10px;border-radius:50%;display:inline-block}
    #schedulePage .dot-repair{background:#f59e0b} #schedulePage .dot-check{background:#3b82f6} #schedulePage .dot-safe{background:#10b981} #schedulePage .dot-const{background:#ec4899}
    #schedulePage .week-header,#schedulePage #calBody{display:grid;grid-template-columns:repeat(7,1fr)} #schedulePage .week-header{border-bottom:1px solid var(--border)} #schedulePage .week-cell{text-align:center;padding:8px 0;font-size:11px;font-weight:700;color:var(--text-tertiary)}
    #schedulePage .week-sun{color:#dc2626} #schedulePage .week-sat{color:#2563eb} #schedulePage .cal-cell{min-height:90px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);padding:6px;position:relative} #schedulePage .cal-cell:nth-child(7n){border-right:none}
    #schedulePage .cal-cell.today{background:#f0f7f2} #schedulePage .cal-date{font-size:12px;font-weight:700;width:24px;height:24px;display:flex;align-items:center;justify-content:center;margin-bottom:4px;border-radius:50%}
    #schedulePage .cal-date.today{background:#2e5c38;color:#fff} #schedulePage .cal-date.other{color:var(--text-tertiary)} #schedulePage .cal-date.sun{color:#dc2626} #schedulePage .cal-date.sat{color:#2563eb} #schedulePage .cal-date.normal{color:var(--text-primary)}
    #schedulePage .cal-event{font-size:10px;font-weight:600;padding:2px 5px;border-radius:3px;margin-bottom:2px;cursor:pointer;white-space:nowrap;overflow:hidden;text-overflow:ellipsis} #schedulePage .type-repair{background:#fef3c7;color:#92400e} #schedulePage .type-check{background:#dbeafe;color:#1e40af} #schedulePage .type-safe{background:#dcfce7;color:#166534} #schedulePage .type-const{background:#fce7f3;color:#9d174d}
    #schedulePage .tbl-fixed{width:100%;table-layout:auto;border-collapse:collapse} #schedulePage .tbl-fixed th,#schedulePage .tbl-fixed td{box-sizing:border-box;vertical-align:middle;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center!important}
    #schedulePage .col-center,#schedulePage .col-manage,#schedulePage .td-date,#schedulePage .td-sub,#schedulePage .td-bold{text-align:center!important} #schedulePage .col-manage .grid-actions{display:inline-flex;align-items:center;justify-content:center;gap:8px;white-space:nowrap}
    #schedulePage .empty-row{text-align:center!important;padding:20px;color:var(--text-tertiary)};padding:20px;color:var(--text-tertiary)}
    #schedulePage .side-header{display:flex;align-items:center;justify-content:space-between;padding:12px 16px;border-bottom:1px solid var(--border);background:#f7f8f9} #schedulePage .side-header-simple{padding:12px 16px;border-bottom:1px solid var(--border);background:#f7f8f9} #schedulePage .side-title{font-size:13px;font-weight:700}
    #schedulePage #todayTaskList{padding:12px} #schedulePage .today-empty{text-align:center;padding:12px;font-size:12px;color:var(--text-tertiary)} #schedulePage .today-task{padding:10px 12px;border-radius:8px;border:1px solid var(--border);margin-bottom:8px;cursor:pointer}
    #schedulePage .today-task.repair{border-left:3px solid #f59e0b} #schedulePage .today-task.check{border-left:3px solid #3b82f6} #schedulePage .today-task.safe{border-left:3px solid #10b981} #schedulePage .today-task.const{border-left:3px solid #ec4899} #schedulePage .today-task-title{font-size:12px;font-weight:700;color:var(--text-primary);margin-bottom:3px} #schedulePage .today-task-loc{font-size:11px;color:var(--text-tertiary)}
    #schedulePage .chart-body{padding:16px} #schedulePage .donut-wrap{display:flex;align-items:center;justify-content:center;gap:16px;margin-bottom:14px} #schedulePage .donut-box{position:relative;width:90px;height:90px;flex-shrink:0} #schedulePage .donut-center{position:absolute;top:50%;left:50%;transform:translate(-50%,-50%);text-align:center} #schedulePage #donutPct{font-size:18px;font-weight:800;color:#2e5c38}
    #schedulePage .bar-list{display:flex;flex-direction:column;gap:8px;flex:1} #schedulePage .bar-row{display:flex;align-items:center;gap:6px;font-size:11px} #schedulePage .bar-label{color:var(--text-secondary);width:44px} #schedulePage .bar-track{flex:1;height:4px;background:#f0f1f3;border-radius:99px;overflow:hidden} #schedulePage .bar-fill{height:100%;border-radius:99px;width:0}
    #schedulePage .type-filter-list{padding:10px;display:flex;flex-direction:column;gap:5px} #schedulePage .type-filter-btn{padding:8px 12px;border-radius:8px;border:1px solid transparent;font-size:12px;font-weight:600;cursor:pointer;text-align:left;transition:.15s} #schedulePage .type-filter-btn.active{background:#2e5c38;color:#fff;border-color:transparent}
    #schedulePage .type-filter-btn.all{background:#f3f4f6;color:var(--text-secondary)} #schedulePage .type-filter-btn.repair{background:#fefce8;color:#92400e;border-color:#fde68a} #schedulePage .type-filter-btn.check{background:#eff6ff;color:#1e40af;border-color:#bfdbfe} #schedulePage .type-filter-btn.safe{background:#f0fdf4;color:#166534;border-color:#bbf7d0} #schedulePage .type-filter-btn.const{background:#fdf2f8;color:#9d174d;border-color:#fbcfe8}
  </style>

  <!-- 관리사무소 공통 JS -->
  <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">

  <!-- 관리사무소 좌측 사이드바 include -->
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">

    <!-- 관리사무소 상단 헤더 include -->
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="schedulePage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>공사·점검 일정</h2>
            <p>단지 내 모든 시설의 유지보수 및 점검 일정을 관리합니다.</p>
          </div>
          <div class="page-actions">
            <button type="button" class="btn btn-primary" data-action="openRegister">
              <span class="material-symbols-rounded">add</span>
              일정 등록
            </button>
          </div>
        </div>

        <div class="schedule-layout">
          <div>
            <div class="panel panel-plain calendar-panel">
              <div class="calendar-header">
                <div class="calendar-title-wrap">
                  <div class="calendar-nav">
                    <button type="button" class="icon-btn" id="prevMonth">&#8249;</button>
                    <button type="button" class="icon-btn" id="nextMonth">&#8250;</button>
                  </div>
                  <span id="calTitle"></span>
                </div>

                <div class="calendar-legend">
                                    <span class="legend-item">
                                        <span class="legend-dot dot-repair"></span>유지보수
                                    </span>
                  <span class="legend-item">
                                        <span class="legend-dot dot-check"></span>정기점검
                                    </span>
                  <span class="legend-item">
                                        <span class="legend-dot dot-safe"></span>안전점검
                                    </span>
                  <span class="legend-item">
                                        <span class="legend-dot dot-const"></span>공사
                                    </span>
                </div>
              </div>

              <div class="week-header">
                <div class="week-cell week-sun">SUN</div>
                <div class="week-cell">MON</div>
                <div class="week-cell">TUE</div>
                <div class="week-cell">WED</div>
                <div class="week-cell">THU</div>
                <div class="week-cell">FRI</div>
                <div class="week-cell week-sat">SAT</div>
              </div>

              <div id="calBody"></div>
            </div>

            <div class="panel panel-plain">
              <div class="list-header">
                <h3 class="panel-title">
                  <span class="material-symbols-rounded">list_alt</span>
                  조회된 일정 목록
                </h3>
                <span class="list-sub">COMPLEX_SCHEDULE · <span class="list-count" id="listCount">0건</span></span>
              </div>

              <div class="table-wrap">
                <table class="tbl tbl-fixed">
                  <colgroup>
                    <col style="width: 15%;">
                    <col style="width: 28%;">
                    <col style="width: 22%;">
                    <col style="width: 14%;">
                    <col style="width: 11%;">
                    <col style="width: 10%;">
                  </colgroup>
                  <thead>
                  <tr>
                    <th>날짜</th>
                    <th>일정명</th>
                    <th>장소</th>
                    <th class="col-center">유형</th>
                    <th class="col-center">상태</th>
                    <th class="col-manage">관리</th>
                  </tr>
                  </thead>
                  <tbody id="scheduleListBody"></tbody>
                </table>
              </div>
            </div>
          </div>

          <div class="schedule-right">
            <div class="panel panel-plain">
              <div class="side-header">
                                <span class="side-title">
                                    <span class="material-symbols-rounded">today</span>
                                    오늘의 작업
                                </span>
                <span id="todayLabel"></span>
              </div>
              <div id="todayTaskList"></div>
            </div>

            <div class="panel panel-plain">
              <div class="side-header-simple">
                                <span class="side-title">
                                    <span class="material-symbols-rounded">donut_large</span>
                                    이달의 작업 현황
                                </span>
              </div>

              <div class="chart-body">
                <div class="donut-wrap">
                  <div class="donut-box">
                    <svg width="90" height="90" viewBox="0 0 90 90">
                      <circle cx="45" cy="45" r="36" fill="none" stroke="#f0f1f3" stroke-width="10"/>
                      <circle cx="45" cy="45" r="36" fill="none" stroke="#2e5c38" stroke-width="10"
                              stroke-dasharray="226" stroke-dashoffset="56"
                              stroke-linecap="round" transform="rotate(-90 45 45)" id="donutCircle"/>
                    </svg>
                    <div class="donut-center">
                      <div id="donutPct">0%</div>
                      <div class="donut-label">완료율</div>
                    </div>
                  </div>

                  <div class="bar-list">
                    <div class="bar-row">
                      <span class="bar-label">정기점검</span>
                      <div class="bar-track">
                        <div class="bar-fill" id="barCheck"></div>
                      </div>
                      <span class="bar-count" id="cntCheck">0/0</span>
                    </div>

                    <div class="bar-row">
                      <span class="bar-label">유지보수</span>
                      <div class="bar-track">
                        <div class="bar-fill" id="barRepair"></div>
                      </div>
                      <span class="bar-count" id="cntRepair">0/0</span>
                    </div>

                    <div class="bar-row">
                      <span class="bar-label">공사</span>
                      <div class="bar-track">
                        <div class="bar-fill" id="barConst"></div>
                      </div>
                      <span class="bar-count" id="cntConst">0/0</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <div class="panel panel-plain">
              <div class="side-header-simple">
                                <span class="side-title">
                                    <span class="material-symbols-rounded">filter_list</span>
                                    유형별 보기
                                </span>
              </div>

              <div class="type-filter-list">
                <button type="button" class="type-filter-btn all active" data-type="ALL">전체 일정</button>
                <button type="button" class="type-filter-btn repair" data-type="repair">● 유지보수</button>
                <button type="button" class="type-filter-btn check" data-type="check">● 정기점검</button>
                <button type="button" class="type-filter-btn safe" data-type="safe">● 안전점검</button>
                <button type="button" class="type-filter-btn const" data-type="const">● 공사</button>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-overlay" id="scheduleModal">
          <div class="modal modal-md">
            <div class="modal-header">
              <h3 class="modal-title" id="scheduleModalTitle">일정 등록</h3>
              <button type="button" class="modal-close" data-action="closeModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <form id="scheduleForm">
              <input type="hidden" id="scheduleNo">

              <div class="modal-body">
                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">calendar_month</span>
                    일정 정보 (COMPLEX_SCHEDULE)
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">일정 제목 (SCHDL_TTL) <span class="req">*</span></label>
                      <input type="text" class="form-input" id="mSchdlTtl" placeholder="예: 엘리베이터 정기점검">
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">일정 날짜 <span class="req">*</span></label>
                      <input type="date" class="form-input" id="mSchdlDt">
                    </div>

                    <div class="form-field">
                      <label class="field-label">일정 유형</label>
                      <select class="form-select" id="mSchdlType">
                        <option value="repair">유지보수</option>
                        <option value="check">정기점검</option>
                        <option value="safe">안전점검</option>
                        <option value="const">공사</option>
                      </select>
                    </div>
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">장소 (LOC_CN)</label>
                      <input type="text" class="form-input" id="mLocCn" placeholder="예: 101동 지하 1층">
                    </div>

                    <div class="form-field">
                      <label class="field-label">일정 상태 (SCHDL_STTS_CD)</label>
                      <select class="form-select" id="mSchdlSttsCd">
                        <option value="READY">예정</option>
                        <option value="ING">진행중</option>
                        <option value="DONE">완료</option>
                        <option value="CANCEL">취소</option>
                      </select>
                    </div>
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">일정 내용 (SCHDL_CN)</label>
                      <textarea class="form-textarea" id="mSchdlCn" placeholder="일정 상세 내용을 입력하세요."></textarea>
                    </div>
                  </div>
                </div>
              </div>

              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
                <button type="button" class="btn btn-primary" id="scheduleEditBtn" data-action="changeToEdit">수정하기</button>
                <button type="submit" class="btn btn-primary" id="scheduleSaveBtn">저장</button>
              </div>
            </form>
          </div>
        </div>
      </div>

      <script>
        (function () {
          var page = document.getElementById("schedulePage");
          if (!page || page.dataset.bound === "true") return;
          page.dataset.bound = "true";

          var today = new Date();
          var curYear = today.getFullYear();
          var curMonth = today.getMonth();
          var activeType = "ALL";
          var editTargetIdx = null;

          var modal = document.getElementById("scheduleModal");
          var form = document.getElementById("scheduleForm");
          var modalTitle = document.getElementById("scheduleModalTitle");
          var saveBtn = document.getElementById("scheduleSaveBtn");
          var editBtn = document.getElementById("scheduleEditBtn");

          var schedules = [
            { scheduleNo:"SC-001", schdlTtl:"엘리베이터 노후 부품 교체", locCn:"제1동 승강기 B호", schdlSttsCd:"ING", schdlCn:"노후 부품 전면 교체 작업", type:"repair", dt:"2026-04-13" },
            { scheduleNo:"SC-002", schdlTtl:"지하주차장 배수펌프 점검", locCn:"지하 2층 중앙 기계실", schdlSttsCd:"READY", schdlCn:"정기 배수펌프 상태 점검", type:"check", dt:"2026-04-16" },
            { scheduleNo:"SC-003", schdlTtl:"옥상 방수 누수 보수 작업", locCn:"제3동 옥상", schdlSttsCd:"DONE", schdlCn:"방수 코팅 및 누수 보수", type:"repair", dt:"2026-04-07" },
            { scheduleNo:"SC-004", schdlTtl:"소방 설비 정기 점검", locCn:"전 동 공통", schdlSttsCd:"READY", schdlCn:"법정 소방점검 실시", type:"safe", dt:"2026-04-20" },
            { scheduleNo:"SC-005", schdlTtl:"어린이 놀이터 안전 점검", locCn:"단지 내 놀이터", schdlSttsCd:"READY", schdlCn:"어린이 안전 점검 실시", type:"safe", dt:"2026-04-13" },
            { scheduleNo:"SC-006", schdlTtl:"단지 내 도로 포장 공사", locCn:"단지 내 진입로", schdlSttsCd:"ING", schdlCn:"아스팔트 재포장 공사", type:"const", dt:"2026-04-22" },
            { scheduleNo:"SC-007", schdlTtl:"전기실 배전반 점검", locCn:"지하 1층 전기실", schdlSttsCd:"DONE", schdlCn:"배전반 정기 점검 완료", type:"check", dt:"2026-04-08" }
          ];

          var STTS_TEXT = {
            READY:"예정",
            ING:"진행중",
            DONE:"완료",
            CANCEL:"취소"
          };

          var STTS_BADGE = {
            READY:"badge-gray",
            ING:"badge-yellow",
            DONE:"badge-green",
            CANCEL:"badge-red"
          };

          var TYPE_TEXT = {
            repair:"유지보수",
            check:"정기점검",
            safe:"안전점검",
            const:"공사"
          };

          function renderCalendar() {
            document.getElementById("calTitle").textContent = curYear + "년 " + (curMonth + 1) + "월";

            var firstDay = new Date(curYear, curMonth, 1).getDay();
            var lastDate = new Date(curYear, curMonth + 1, 0).getDate();
            var prevLast = new Date(curYear, curMonth, 0).getDate();
            var totalCells = Math.ceil((firstDay + lastDate) / 7) * 7;
            var body = document.getElementById("calBody");

            body.innerHTML = "";

            var evMap = {};

            schedules.forEach(function (s) {
              if (activeType !== "ALL" && s.type !== activeType) return;

              var d = new Date(s.dt);
              if (d.getFullYear() === curYear && d.getMonth() === curMonth) {
                var day = d.getDate();
                if (!evMap[day]) evMap[day] = [];
                evMap[day].push(s);
              }
            });

            var todayStr = today.getFullYear() + "-"
                    + String(today.getMonth() + 1).padStart(2, "0") + "-"
                    + String(today.getDate()).padStart(2, "0");

            for (var i = 0; i < totalCells; i++) {
              var cell = document.createElement("div");
              cell.className = "cal-cell";

              var dayNum;
              var isOther = false;
              var dateStr;
              var dow = i % 7;

              if (i < firstDay) {
                dayNum = prevLast - firstDay + i + 1;
                isOther = true;
                dateStr = curYear + "-" + String(curMonth).padStart(2, "0") + "-" + String(dayNum).padStart(2, "0");
              } else if (i >= firstDay + lastDate) {
                dayNum = i - firstDay - lastDate + 1;
                isOther = true;
                dateStr = curYear + "-" + String(curMonth + 2).padStart(2, "0") + "-" + String(dayNum).padStart(2, "0");
              } else {
                dayNum = i - firstDay + 1;
                dateStr = curYear + "-" + String(curMonth + 1).padStart(2, "0") + "-" + String(dayNum).padStart(2, "0");
              }

              var isToday = dateStr === todayStr && !isOther;
              if (isToday) cell.classList.add("today");

              var dateDiv = document.createElement("div");
              dateDiv.className = "cal-date";

              if (isToday) {
                dateDiv.classList.add("today");
              } else if (isOther) {
                dateDiv.classList.add("other");
              } else if (dow === 0) {
                dateDiv.classList.add("sun");
              } else if (dow === 6) {
                dateDiv.classList.add("sat");
              } else {
                dateDiv.classList.add("normal");
              }

              dateDiv.textContent = dayNum;
              cell.appendChild(dateDiv);

              if (!isOther && evMap[dayNum]) {
                evMap[dayNum].forEach(function (s) {
                  var ev = document.createElement("div");
                  ev.className = "cal-event type-" + s.type;
                  ev.textContent = s.schdlTtl;
                  ev.title = s.schdlTtl;

                  ev.addEventListener("click", function () {
                    var idx = schedules.indexOf(s);
                    openModal("detail", idx);
                  });

                  cell.appendChild(ev);
                });
              }

              body.appendChild(cell);
            }

            renderList();
            renderSidePanel();
          }

          function renderList() {
            var filtered = schedules.filter(function (s) {
              return activeType === "ALL" || s.type === activeType;
            });

            document.getElementById("listCount").textContent = filtered.length + "건";

            var tbody = document.getElementById("scheduleListBody");

            if (filtered.length === 0) {
              tbody.innerHTML = '<tr><td colspan="6" class="empty-row">일정이 없습니다.</td></tr>';
              return;
            }

            tbody.innerHTML = filtered.map(function (s) {
              var realIdx = schedules.indexOf(s);

              var typeBadge = '<span class="type-badge type-' + s.type + '">' + (TYPE_TEXT[s.type] || "-") + '</span>';
              var sttsBadge = '<span class="badge ' + (STTS_BADGE[s.schdlSttsCd] || "badge-gray") + '">' + (STTS_TEXT[s.schdlSttsCd] || "-") + '</span>';

              return '<tr>'
                      + '<td class="td-date">' + s.dt + '</td>'
                      + '<td class="td-bold">' + s.schdlTtl + '</td>'
                      + '<td class="td-sub">' + (s.locCn || "-") + '</td>'
                      + '<td class="col-center">' + typeBadge + '</td>'
                      + '<td class="col-center">' + sttsBadge + '</td>'
                      + '<td class="col-manage">'
                      + '<div class="grid-actions">'
                      + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + realIdx + '">상세</button>'
                      + '<button type="button" class="btn btn-xs btn-edit" data-action="edit" data-idx="' + realIdx + '">수정</button>'
                      + '</div>'
                      + '</td>'
                      + '</tr>';
            }).join("");
          }

          function renderSidePanel() {
            var todayStr = today.getFullYear() + "-"
                    + String(today.getMonth() + 1).padStart(2, "0") + "-"
                    + String(today.getDate()).padStart(2, "0");

            var todayTasks = schedules.filter(function (s) {
              return s.dt === todayStr;
            });

            document.getElementById("todayLabel").textContent = (today.getMonth() + 1) + "월 " + today.getDate() + "일";

            var taskList = document.getElementById("todayTaskList");

            if (todayTasks.length === 0) {
              taskList.innerHTML = '<div class="today-empty">오늘 예정된 작업이 없습니다.</div>';
            } else {
              taskList.innerHTML = todayTasks.map(function (s) {
                return '<div class="today-task ' + s.type + '">'
                        + '<div class="today-task-title">' + s.schdlTtl + '</div>'
                        + '<div class="today-task-loc">' + (s.locCn || "-") + '</div>'
                        + '</div>';
              }).join("");
            }

            var monthSchedules = schedules.filter(function (s) {
              var d = new Date(s.dt);
              return d.getFullYear() === curYear && d.getMonth() === curMonth;
            });

            var total = monthSchedules.length;
            var done = monthSchedules.filter(function (s) {
              return s.schdlSttsCd === "DONE";
            }).length;

            var pct = total > 0 ? Math.round(done / total * 100) : 0;
            var circumference = 226;
            var offset = circumference - (pct / 100 * circumference);

            document.getElementById("donutPct").textContent = pct + "%";
            document.getElementById("donutCircle").setAttribute("stroke-dashoffset", offset);

            var checkAll = monthSchedules.filter(function (s) {
              return s.type === "check";
            });

            var repairAll = monthSchedules.filter(function (s) {
              return s.type === "repair";
            });

            var constAll = monthSchedules.filter(function (s) {
              return s.type === "const";
            });

            function countDone(arr) {
              return arr.filter(function (s) {
                return s.schdlSttsCd === "DONE";
              }).length;
            }

            document.getElementById("cntCheck").textContent = countDone(checkAll) + "/" + checkAll.length;
            document.getElementById("cntRepair").textContent = countDone(repairAll) + "/" + repairAll.length;
            document.getElementById("cntConst").textContent = countDone(constAll) + "/" + constAll.length;

            document.getElementById("barCheck").style.width =
                    (checkAll.length > 0 ? Math.round(countDone(checkAll) / checkAll.length * 100) : 0) + "%";

            document.getElementById("barRepair").style.width =
                    (repairAll.length > 0 ? Math.round(countDone(repairAll) / repairAll.length * 100) : 0) + "%";

            document.getElementById("barConst").style.width =
                    (constAll.length > 0 ? Math.round(countDone(constAll) / constAll.length * 100) : 0) + "%";
          }

          function openModal(mode, idx) {
            form.reset();
            saveBtn.style.display = "inline-flex";
            editBtn.style.display = "none";
            setFormDisabled(false);
            editTargetIdx = null;

            if (mode === "register") {
              modalTitle.textContent = "일정 등록";
              document.getElementById("scheduleNo").value = "";

              var todayVal = today.getFullYear() + "-"
                      + String(today.getMonth() + 1).padStart(2, "0") + "-"
                      + String(today.getDate()).padStart(2, "0");

              document.getElementById("mSchdlDt").value = todayVal;
            }

            if (mode === "detail" && idx !== undefined) {
              modalTitle.textContent = "일정 상세";
              fillForm(schedules[idx]);
              setFormDisabled(true);
              saveBtn.style.display = "none";
              editBtn.style.display = "inline-flex";
              editBtn.dataset.idx = idx;
            }

            if (mode === "edit" && idx !== undefined) {
              modalTitle.textContent = "일정 수정";
              fillForm(schedules[idx]);
              editTargetIdx = idx;
            }

            modal.classList.add("open");
          }

          function fillForm(s) {
            document.getElementById("scheduleNo").value = s.scheduleNo || "";
            document.getElementById("mSchdlTtl").value = s.schdlTtl || "";
            document.getElementById("mSchdlDt").value = s.dt || "";
            document.getElementById("mSchdlType").value = s.type || "check";
            document.getElementById("mLocCn").value = s.locCn || "";
            document.getElementById("mSchdlSttsCd").value = s.schdlSttsCd || "READY";
            document.getElementById("mSchdlCn").value = s.schdlCn || "";
          }

          function setFormDisabled(disabled) {
            form.querySelectorAll("input, select, textarea").forEach(function (el) {
              el.disabled = disabled;
            });
          }

          function closeModal() {
            modal.classList.remove("open");
          }

          function setTypeFilter(type) {
            activeType = type;

            page.querySelectorAll(".type-filter-btn").forEach(function (btn) {
              btn.classList.remove("active");

              if (btn.dataset.type === type) {
                btn.classList.add("active");
              }
            });

            renderCalendar();
          }

          document.getElementById("prevMonth").addEventListener("click", function () {
            curMonth--;

            if (curMonth < 0) {
              curMonth = 11;
              curYear--;
            }

            renderCalendar();
          });

          document.getElementById("nextMonth").addEventListener("click", function () {
            curMonth++;

            if (curMonth > 11) {
              curMonth = 0;
              curYear++;
            }

            renderCalendar();
          });

          page.addEventListener("click", function (e) {
            var typeBtn = e.target.closest(".type-filter-btn");

            if (typeBtn) {
              setTypeFilter(typeBtn.dataset.type);
              return;
            }

            var btn = e.target.closest("[data-action]");
            if (!btn) return;

            var action = btn.dataset.action;
            var idx = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

            if (action === "openRegister") openModal("register");
            if (action === "detail") openModal("detail", idx);
            if (action === "edit") openModal("edit", idx);
            if (action === "changeToEdit") openModal("edit", Number(editBtn.dataset.idx));
            if (action === "closeModal") closeModal();
          });

          modal.addEventListener("click", function (e) {
            if (e.target === modal) closeModal();
          });

          form.addEventListener("submit", function (e) {
            e.preventDefault();

            if (!document.getElementById("mSchdlTtl").value.trim()) {
              alert("일정 제목을 입력하세요.");
              return;
            }

            if (!document.getElementById("mSchdlDt").value) {
              alert("날짜를 입력하세요.");
              return;
            }

            alert("저장 처리 연결 예정입니다.");
            closeModal();
          });

          renderCalendar();
        })();
      </script>
    </main>
  </div>
</div>
</body>
</html>