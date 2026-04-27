<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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

  <!-- 메인 레이아웃: 달력 + 우측 패널 -->
  <div style="display:grid; grid-template-columns:1fr 270px; gap:16px;">

    <!-- 좌: 달력 -->
    <div>
      <div class="panel" style="margin-bottom:16px; padding:0; overflow:hidden;">

        <!-- 달력 헤더 -->
        <div style="display:flex; align-items:center; justify-content:space-between; padding:14px 20px; border-bottom:1px solid var(--border);">
          <div style="display:flex; align-items:center; gap:12px;">
            <div style="display:flex; gap:4px;">
              <button type="button" class="icon-btn" id="prevMonth">&#8249;</button>
              <button type="button" class="icon-btn" id="nextMonth">&#8250;</button>
            </div>
            <span style="font-size:18px; font-weight:800;" id="calTitle"></span>
          </div>
          <div style="display:flex; gap:14px; align-items:center;">
            <span style="display:flex; align-items:center; gap:5px; font-size:11px; color:var(--text-secondary);">
              <span style="width:10px; height:10px; border-radius:50%; background:#f59e0b; display:inline-block;"></span>유지보수
            </span>
            <span style="display:flex; align-items:center; gap:5px; font-size:11px; color:var(--text-secondary);">
              <span style="width:10px; height:10px; border-radius:50%; background:#3b82f6; display:inline-block;"></span>정기점검
            </span>
            <span style="display:flex; align-items:center; gap:5px; font-size:11px; color:var(--text-secondary);">
              <span style="width:10px; height:10px; border-radius:50%; background:#10b981; display:inline-block;"></span>안전점검
            </span>
            <span style="display:flex; align-items:center; gap:5px; font-size:11px; color:var(--text-secondary);">
              <span style="width:10px; height:10px; border-radius:50%; background:#ec4899; display:inline-block;"></span>공사
            </span>
          </div>
        </div>

        <!-- 요일 헤더 -->
        <div style="display:grid; grid-template-columns:repeat(7,1fr); border-bottom:1px solid var(--border);">
          <div style="text-align:center; padding:8px 0; font-size:11px; font-weight:700; color:#dc2626;">SUN</div>
          <div style="text-align:center; padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary);">MON</div>
          <div style="text-align:center; padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary);">TUE</div>
          <div style="text-align:center; padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary);">WED</div>
          <div style="text-align:center; padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary);">THU</div>
          <div style="text-align:center; padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary);">FRI</div>
          <div style="text-align:center; padding:8px 0; font-size:11px; font-weight:700; color:#2563eb;">SAT</div>
        </div>

        <!-- 달력 셀 -->
        <div style="display:grid; grid-template-columns:repeat(7,1fr);" id="calBody"></div>
      </div>

      <!-- 일정 목록 -->
      <div class="panel" style="padding:0; overflow:hidden;">
        <div style="display:flex; align-items:center; justify-content:space-between; padding:14px 20px; border-bottom:1px solid var(--border);">
          <h3 class="panel-title">
            <span class="material-symbols-rounded">list_alt</span>
            조회된 일정 목록
          </h3>
          <span style="font-size:11px; color:var(--text-tertiary);">COMPLEX_SCHEDULE · <span class="list-count" id="listCount">0건</span></span>
        </div>
        <div class="table-wrap">
          <table class="tbl">
            <thead>
            <tr>
              <th>날짜</th>
              <th>일정명</th>
              <th>장소</th>
              <th>유형</th>
              <th>상태</th>
              <th style="width:100px;">관리</th>
            </tr>
            </thead>
            <tbody id="scheduleListBody"></tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- 우: 사이드 패널 -->
    <div style="display:flex; flex-direction:column; gap:14px;">

      <!-- 오늘 작업 -->
      <div class="panel" style="padding:0; overflow:hidden;">
        <div style="display:flex; align-items:center; justify-content:space-between; padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
          <span style="font-size:13px; font-weight:700;">
            <span class="material-symbols-rounded" style="font-size:14px; vertical-align:middle; margin-right:3px;">today</span>
            오늘의 작업
          </span>
          <span style="font-size:11px; color:var(--text-tertiary);" id="todayLabel"></span>
        </div>
        <div style="padding:12px;" id="todayTaskList"></div>
      </div>

      <!-- 이달 작업 현황 -->
      <div class="panel" style="padding:0; overflow:hidden;">
        <div style="padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
          <span style="font-size:13px; font-weight:700;">
            <span class="material-symbols-rounded" style="font-size:14px; vertical-align:middle; margin-right:3px;">donut_large</span>
            이달의 작업 현황
          </span>
        </div>
        <div style="padding:16px;">
          <!-- 도넛 차트 -->
          <div style="display:flex; align-items:center; justify-content:center; gap:16px; margin-bottom:14px;">
            <div style="position:relative; width:90px; height:90px; flex-shrink:0;">
              <svg width="90" height="90" viewBox="0 0 90 90">
                <circle cx="45" cy="45" r="36" fill="none" stroke="#f0f1f3" stroke-width="10"/>
                <circle cx="45" cy="45" r="36" fill="none" stroke="#2e5c38" stroke-width="10"
                        stroke-dasharray="226" stroke-dashoffset="56"
                        stroke-linecap="round" transform="rotate(-90 45 45)" id="donutCircle"/>
              </svg>
              <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); text-align:center;">
                <div style="font-size:18px; font-weight:800; color:#2e5c38;" id="donutPct">0%</div>
                <div style="font-size:10px; color:var(--text-tertiary);">완료율</div>
              </div>
            </div>
            <div style="display:flex; flex-direction:column; gap:8px; flex:1;">
              <div style="display:flex; align-items:center; gap:6px; font-size:11px;">
                <span style="color:var(--text-secondary); width:44px;">정기점검</span>
                <div style="flex:1; height:4px; background:#f0f1f3; border-radius:99px; overflow:hidden;">
                  <div style="height:100%; background:#2e5c38; border-radius:99px;" id="barCheck"></div>
                </div>
                <span style="font-weight:700; min-width:28px; text-align:right;" id="cntCheck">0/0</span>
              </div>
              <div style="display:flex; align-items:center; gap:6px; font-size:11px;">
                <span style="color:var(--text-secondary); width:44px;">유지보수</span>
                <div style="flex:1; height:4px; background:#f0f1f3; border-radius:99px; overflow:hidden;">
                  <div style="height:100%; background:#f59e0b; border-radius:99px;" id="barRepair"></div>
                </div>
                <span style="font-weight:700; min-width:28px; text-align:right;" id="cntRepair">0/0</span>
              </div>
              <div style="display:flex; align-items:center; gap:6px; font-size:11px;">
                <span style="color:var(--text-secondary); width:44px;">공사</span>
                <div style="flex:1; height:4px; background:#f0f1f3; border-radius:99px; overflow:hidden;">
                  <div style="height:100%; background:#ec4899; border-radius:99px;" id="barConst"></div>
                </div>
                <span style="font-weight:700; min-width:28px; text-align:right;" id="cntConst">0/0</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 유형별 필터 -->
      <div class="panel" style="padding:0; overflow:hidden;">
        <div style="padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
          <span style="font-size:13px; font-weight:700;">
            <span class="material-symbols-rounded" style="font-size:14px; vertical-align:middle; margin-right:3px;">filter_list</span>
            유형별 보기
          </span>
        </div>
        <div style="padding:10px; display:flex; flex-direction:column; gap:5px;">
          <button type="button" class="type-filter-btn active" data-type="ALL"
                  style="padding:8px 12px; border-radius:8px; border:1px solid transparent; background:#2e5c38; color:#fff; font-size:12px; font-weight:600; cursor:pointer; text-align:left; transition:0.15s;">
            전체 일정
          </button>
          <button type="button" class="type-filter-btn" data-type="repair"
                  style="padding:8px 12px; border-radius:8px; border:1px solid #fde68a; background:#fefce8; color:#92400e; font-size:12px; font-weight:600; cursor:pointer; text-align:left; transition:0.15s;">
            ● 유지보수
          </button>
          <button type="button" class="type-filter-btn" data-type="check"
                  style="padding:8px 12px; border-radius:8px; border:1px solid #bfdbfe; background:#eff6ff; color:#1e40af; font-size:12px; font-weight:600; cursor:pointer; text-align:left; transition:0.15s;">
            ● 정기점검
          </button>
          <button type="button" class="type-filter-btn" data-type="safe"
                  style="padding:8px 12px; border-radius:8px; border:1px solid #bbf7d0; background:#f0fdf4; color:#166534; font-size:12px; font-weight:600; cursor:pointer; text-align:left; transition:0.15s;">
            ● 안전점검
          </button>
          <button type="button" class="type-filter-btn" data-type="const"
                  style="padding:8px 12px; border-radius:8px; border:1px solid #fbcfe8; background:#fdf2f8; color:#9d174d; font-size:12px; font-weight:600; cursor:pointer; text-align:left; transition:0.15s;">
            ● 공사
          </button>
        </div>
      </div>

    </div>
  </div>

  <!-- 등록/수정 모달 -->
  <div class="modal-overlay" id="scheduleModal">
    <div class="modal modal-md">
      <div class="modal-header primary">
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
          <button type="button" class="btn btn-primary" id="scheduleEditBtn"
                  data-action="changeToEdit" style="display:none;">수정하기</button>
          <button type="submit" class="btn btn-primary" id="scheduleSaveBtn">저장</button>
        </div>
      </form>
    </div>
  </div>

</div>

<script>
  (function() {
    var page = document.getElementById("schedulePage");
    if (!page || page.dataset.bound === "true") return;
    page.dataset.bound = "true";

    var today      = new Date();
    var curYear    = today.getFullYear();
    var curMonth   = today.getMonth();
    var activeType = "ALL";
    var editTargetIdx = null;

    var modal      = document.getElementById("scheduleModal");
    var form       = document.getElementById("scheduleForm");
    var modalTitle = document.getElementById("scheduleModalTitle");
    var saveBtn    = document.getElementById("scheduleSaveBtn");
    var editBtn    = document.getElementById("scheduleEditBtn");

    /* ── 더미 데이터 (COMPLEX_SCHEDULE 기준)
       ERD 컬럼: SCHEDULE_NO, APT_CMPLEX_NO, SCHDL_TTL, LOC_CN,
                 SCHDL_STTS_CD, SCHDL_CN, RGTR_ID, METER_WRK_NO
       ※ dt(날짜)/type(유형)은 실제 구현 시 METER_WRK_NO 조인으로 처리
    ── */
    var schedules = [
      { scheduleNo:"SC-001", schdlTtl:"엘리베이터 노후 부품 교체", locCn:"제1동 승강기 B호",   schdlSttsCd:"ING",    schdlCn:"노후 부품 전면 교체 작업", type:"repair", dt:"2026-04-13" },
      { scheduleNo:"SC-002", schdlTtl:"지하주차장 배수펌프 점검",   locCn:"지하 2층 중앙 기계실", schdlSttsCd:"READY",  schdlCn:"정기 배수펌프 상태 점검", type:"check",  dt:"2026-04-16" },
      { scheduleNo:"SC-003", schdlTtl:"옥상 방수 누수 보수 작업",   locCn:"제3동 옥상",        schdlSttsCd:"DONE",   schdlCn:"방수 코팅 및 누수 보수",  type:"repair", dt:"2026-04-07" },
      { scheduleNo:"SC-004", schdlTtl:"소방 설비 정기 점검",        locCn:"전 동 공통",        schdlSttsCd:"READY",  schdlCn:"법정 소방점검 실시",      type:"safe",   dt:"2026-04-20" },
      { scheduleNo:"SC-005", schdlTtl:"어린이 놀이터 안전 점검",    locCn:"단지 내 놀이터",    schdlSttsCd:"READY",  schdlCn:"어린이 안전 점검 실시",   type:"safe",   dt:"2026-04-13" },
      { scheduleNo:"SC-006", schdlTtl:"단지 내 도로 포장 공사",     locCn:"단지 내 진입로",    schdlSttsCd:"ING",    schdlCn:"아스팔트 재포장 공사",    type:"const",  dt:"2026-04-22" },
      { scheduleNo:"SC-007", schdlTtl:"전기실 배전반 점검",         locCn:"지하 1층 전기실",   schdlSttsCd:"DONE",   schdlCn:"배전반 정기 점검 완료",   type:"check",  dt:"2026-04-08" },
    ];

    var STTS_TEXT  = { READY:"예정", ING:"진행중", DONE:"완료", CANCEL:"취소" };
    var STTS_BADGE = { READY:"badge-gray", ING:"badge-yellow", DONE:"badge-green", CANCEL:"badge-red" };
    var TYPE_TEXT  = { repair:"유지보수", check:"정기점검", safe:"안전점검", const:"공사" };
    var TYPE_COLOR = { repair:"#f59e0b", check:"#3b82f6", safe:"#10b981", const:"#ec4899" };
    var TYPE_BG    = { repair:"#fef3c7", check:"#dbeafe", safe:"#dcfce7", const:"#fce7f3" };
    var TYPE_FG    = { repair:"#92400e", check:"#1e40af", safe:"#166534", const:"#9d174d" };

    /* ── 달력 렌더 ── */
    function renderCalendar() {
      document.getElementById("calTitle").textContent = curYear + "년 " + (curMonth + 1) + "월";

      var firstDay    = new Date(curYear, curMonth, 1).getDay();
      var lastDate    = new Date(curYear, curMonth + 1, 0).getDate();
      var prevLast    = new Date(curYear, curMonth, 0).getDate();
      var totalCells  = Math.ceil((firstDay + lastDate) / 7) * 7;
      var body        = document.getElementById("calBody");
      body.innerHTML  = "";

      var evMap = {};
      schedules.forEach(function(s) {
        if (activeType !== "ALL" && s.type !== activeType) return;
        var d = new Date(s.dt);
        if (d.getFullYear() === curYear && d.getMonth() === curMonth) {
          var day = d.getDate();
          if (!evMap[day]) evMap[day] = [];
          evMap[day].push(s);
        }
      });

      var todayStr = today.getFullYear() + "-" + String(today.getMonth()+1).padStart(2,"0") + "-" + String(today.getDate()).padStart(2,"0");

      for (var i = 0; i < totalCells; i++) {
        var cell = document.createElement("div");
        cell.style.cssText = "min-height:90px; border-right:1px solid var(--border); border-bottom:1px solid var(--border); padding:6px; position:relative;";
        if ((i + 1) % 7 === 0) cell.style.borderRight = "none";

        var dayNum, isOther = false, dateStr;
        var dow = i % 7;

        if (i < firstDay) {
          dayNum = prevLast - firstDay + i + 1;
          isOther = true;
          dateStr = (curYear) + "-" + String(curMonth).padStart(2,"0") + "-" + String(dayNum).padStart(2,"0");
        } else if (i >= firstDay + lastDate) {
          dayNum = i - firstDay - lastDate + 1;
          isOther = true;
          dateStr = curYear + "-" + String(curMonth+2).padStart(2,"0") + "-" + String(dayNum).padStart(2,"0");
        } else {
          dayNum = i - firstDay + 1;
          dateStr = curYear + "-" + String(curMonth+1).padStart(2,"0") + "-" + String(dayNum).padStart(2,"0");
        }

        var isToday = (dateStr === todayStr && !isOther);
        if (isToday) cell.style.background = "#f0f7f2";

        var dateDiv = document.createElement("div");
        dateDiv.style.cssText = "font-size:12px; font-weight:700; width:24px; height:24px; display:flex; align-items:center; justify-content:center; margin-bottom:4px; border-radius:50%;";

        if (isToday) {
          dateDiv.style.background = "#2e5c38";
          dateDiv.style.color = "#fff";
        } else if (isOther) {
          dateDiv.style.color = "var(--text-tertiary)";
        } else if (dow === 0) {
          dateDiv.style.color = "#dc2626";
        } else if (dow === 6) {
          dateDiv.style.color = "#2563eb";
        } else {
          dateDiv.style.color = "var(--text-primary)";
        }

        dateDiv.textContent = dayNum;
        cell.appendChild(dateDiv);

        if (!isOther && evMap[dayNum]) {
          evMap[dayNum].forEach(function(s) {
            var ev = document.createElement("div");
            ev.style.cssText = "font-size:10px; font-weight:600; padding:2px 5px; border-radius:3px; margin-bottom:2px; cursor:pointer; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; background:" + TYPE_BG[s.type] + "; color:" + TYPE_FG[s.type] + ";";
            ev.textContent = s.schdlTtl;
            ev.title = s.schdlTtl;
            ev.addEventListener("click", function() {
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

    /* ── 목록 렌더 ── */
    function renderList() {
      var filtered = schedules.filter(function(s) {
        return activeType === "ALL" || s.type === activeType;
      });

      document.getElementById("listCount").textContent = filtered.length + "건";

      var tbody = document.getElementById("scheduleListBody");
      if (filtered.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; padding:20px; color:var(--text-tertiary);">일정이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = filtered.map(function(s, idx) {
        var realIdx = schedules.indexOf(s);
        var typeBadge = '<span style="display:inline-flex; align-items:center; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; background:' + TYPE_BG[s.type] + '; color:' + TYPE_FG[s.type] + ';">' + (TYPE_TEXT[s.type] || "-") + '</span>';
        var sttsBadge = '<span class="badge ' + (STTS_BADGE[s.schdlSttsCd] || "badge-gray") + '">' + (STTS_TEXT[s.schdlSttsCd] || "-") + '</span>';
        return '<tr>'
                + '<td style="font-family:monospace; font-size:12px; color:var(--text-secondary);">' + s.dt + '</td>'
                + '<td class="td-bold">' + s.schdlTtl + '</td>'
                + '<td style="font-size:12px; color:var(--text-secondary);">' + (s.locCn || "-") + '</td>'
                + '<td>' + typeBadge + '</td>'
                + '<td>' + sttsBadge + '</td>'
                + '<td><div class="grid-actions">'
                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + realIdx + '">상세</button>'
                + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + realIdx + '">수정</button>'
                + '</div></td>'
                + '</tr>';
      }).join("");
    }

    /* ── 사이드 패널 렌더 ── */
    function renderSidePanel() {
      // 오늘 작업
      var todayStr = today.getFullYear() + "-" + String(today.getMonth()+1).padStart(2,"0") + "-" + String(today.getDate()).padStart(2,"0");
      var todayTasks = schedules.filter(function(s){ return s.dt === todayStr; });
      document.getElementById("todayLabel").textContent = (today.getMonth()+1) + "월 " + today.getDate() + "일";

      var taskList = document.getElementById("todayTaskList");
      if (todayTasks.length === 0) {
        taskList.innerHTML = '<div style="text-align:center; padding:12px; font-size:12px; color:var(--text-tertiary);">오늘 예정된 작업이 없습니다.</div>';
      } else {
        taskList.innerHTML = todayTasks.map(function(s) {
          return '<div style="padding:10px 12px; border-radius:8px; border:1px solid var(--border); margin-bottom:8px; cursor:pointer; border-left:3px solid ' + TYPE_COLOR[s.type] + ';">'
                  + '<div style="font-size:12px; font-weight:700; color:var(--text-primary); margin-bottom:3px;">' + s.schdlTtl + '</div>'
                  + '<div style="font-size:11px; color:var(--text-tertiary);">' + (s.locCn || "-") + '</div>'
                  + '</div>';
        }).join("");
      }

      // 이달 현황
      var monthSchedules = schedules.filter(function(s) {
        var d = new Date(s.dt);
        return d.getFullYear() === curYear && d.getMonth() === curMonth;
      });
      var total = monthSchedules.length;
      var done  = monthSchedules.filter(function(s){ return s.schdlSttsCd === "DONE"; }).length;
      var pct   = total > 0 ? Math.round(done / total * 100) : 0;
      var circumference = 226;
      var offset = circumference - (pct / 100 * circumference);

      document.getElementById("donutPct").textContent = pct + "%";
      document.getElementById("donutCircle").setAttribute("stroke-dashoffset", offset);

      var checkAll  = monthSchedules.filter(function(s){ return s.type === "check"; });
      var repairAll = monthSchedules.filter(function(s){ return s.type === "repair"; });
      var constAll  = monthSchedules.filter(function(s){ return s.type === "const"; });

      function countDone(arr) { return arr.filter(function(s){ return s.schdlSttsCd === "DONE"; }).length; }

      document.getElementById("cntCheck").textContent  = countDone(checkAll)  + "/" + checkAll.length;
      document.getElementById("cntRepair").textContent = countDone(repairAll) + "/" + repairAll.length;
      document.getElementById("cntConst").textContent  = countDone(constAll)  + "/" + constAll.length;

      document.getElementById("barCheck").style.width  = (checkAll.length  > 0 ? Math.round(countDone(checkAll)  / checkAll.length  * 100) : 0) + "%";
      document.getElementById("barRepair").style.width = (repairAll.length > 0 ? Math.round(countDone(repairAll) / repairAll.length * 100) : 0) + "%";
      document.getElementById("barConst").style.width  = (constAll.length  > 0 ? Math.round(countDone(constAll)  / constAll.length  * 100) : 0) + "%";
    }

    /* ── 모달 ── */
    function openModal(mode, idx) {
      form.reset();
      saveBtn.style.display = "inline-flex";
      editBtn.style.display = "none";
      setFormDisabled(false);
      editTargetIdx = null;

      if (mode === "register") {
        modalTitle.textContent = "일정 등록";
        document.getElementById("scheduleNo").value = "";
        var todayVal = today.getFullYear() + "-" + String(today.getMonth()+1).padStart(2,"0") + "-" + String(today.getDate()).padStart(2,"0");
        document.getElementById("mSchdlDt").value = todayVal;
      }
      if (mode === "detail" && idx !== undefined) {
        modalTitle.textContent = "일정 상세";
        fillForm(schedules[idx]);
        setFormDisabled(true);
        saveBtn.style.display = "none";
        editBtn.style.display = "inline-flex";
        editBtn.dataset.idx   = idx;
      }
      if (mode === "edit" && idx !== undefined) {
        modalTitle.textContent = "일정 수정";
        fillForm(schedules[idx]);
        editTargetIdx = idx;
      }
      modal.classList.add("open");
    }

    function fillForm(s) {
      document.getElementById("scheduleNo").value   = s.scheduleNo   || "";
      document.getElementById("mSchdlTtl").value    = s.schdlTtl    || "";
      document.getElementById("mSchdlDt").value     = s.dt          || "";
      document.getElementById("mSchdlType").value   = s.type        || "check";
      document.getElementById("mLocCn").value       = s.locCn       || "";
      document.getElementById("mSchdlSttsCd").value = s.schdlSttsCd || "READY";
      document.getElementById("mSchdlCn").value     = s.schdlCn     || "";
    }

    function setFormDisabled(disabled) {
      form.querySelectorAll("input, select, textarea").forEach(function(el){ el.disabled = disabled; });
    }

    function closeModal() { modal.classList.remove("open"); }

    /* ── 유형 필터 버튼 ── */
    function setTypeFilter(type) {
      activeType = type;
      page.querySelectorAll(".type-filter-btn").forEach(function(btn) {
        var t = btn.dataset.type;
        if (t === type) {
          btn.style.background = "#2e5c38";
          btn.style.color      = "#fff";
          btn.style.borderColor = "transparent";
        } else {
          if (t === "repair") { btn.style.background="#fefce8"; btn.style.color="#92400e"; btn.style.borderColor="#fde68a"; }
          if (t === "check")  { btn.style.background="#eff6ff"; btn.style.color="#1e40af"; btn.style.borderColor="#bfdbfe"; }
          if (t === "safe")   { btn.style.background="#f0fdf4"; btn.style.color="#166534"; btn.style.borderColor="#bbf7d0"; }
          if (t === "const")  { btn.style.background="#fdf2f8"; btn.style.color="#9d174d"; btn.style.borderColor="#fbcfe8"; }
          if (t === "ALL")    { btn.style.background="#f3f4f6"; btn.style.color="var(--text-secondary)"; btn.style.borderColor="transparent"; }
        }
      });
      renderCalendar();
    }

    /* ── 이벤트 ── */
    document.getElementById("prevMonth").addEventListener("click", function() {
      curMonth--; if (curMonth < 0) { curMonth = 11; curYear--; }
      renderCalendar();
    });
    document.getElementById("nextMonth").addEventListener("click", function() {
      curMonth++; if (curMonth > 11) { curMonth = 0; curYear++; }
      renderCalendar();
    });

    page.addEventListener("click", function(e) {
      var typeBtn = e.target.closest(".type-filter-btn");
      if (typeBtn) { setTypeFilter(typeBtn.dataset.type); return; }

      var btn = e.target.closest("[data-action]");
      if (!btn) return;
      var action = btn.dataset.action;
      var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

      if (action === "openRegister") openModal("register");
      if (action === "detail")       openModal("detail", idx);
      if (action === "edit")         openModal("edit", idx);
      if (action === "changeToEdit") openModal("edit", Number(editBtn.dataset.idx));
      if (action === "closeModal")   closeModal();
    });

    modal.addEventListener("click", function(e){ if (e.target === modal) closeModal(); });

    form.addEventListener("submit", function(e){
      e.preventDefault();
      if (!document.getElementById("mSchdlTtl").value.trim()) { alert("일정 제목을 입력하세요."); return; }
      if (!document.getElementById("mSchdlDt").value)         { alert("날짜를 입력하세요."); return; }
      alert("저장 처리 연결 예정입니다.");
      closeModal();
    });

    renderCalendar();
  })();
</script>
