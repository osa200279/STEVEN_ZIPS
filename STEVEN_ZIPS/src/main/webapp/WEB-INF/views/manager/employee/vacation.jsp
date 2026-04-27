<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<div class="office-page" id="mngrVacationPage">

  <div class="page-header">
    <div class="page-title-block">
      <h2>휴가 일정</h2>
      <p>관리사무소 직원의 휴가 일정을 등록하고 월별로 확인합니다.</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-primary" data-action="openRegister">
        <span class="material-symbols-rounded">add</span>
        휴가 등록
      </button>
    </div>
  </div>

  <div class="stat-row">
    <div class="stat-card">
      <div class="stat-icon green"><span class="material-symbols-rounded">event_available</span></div>
      <div>
        <div class="stat-value">${vacationStat.totalCnt}</div>
        <div class="stat-label">전체 일정</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon blue"><span class="material-symbols-rounded">today</span></div>
      <div>
        <div class="stat-value">${vacationStat.todayCnt}</div>
        <div class="stat-label">오늘 휴가</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon yellow"><span class="material-symbols-rounded">calendar_month</span></div>
      <div>
        <div class="stat-value">${vacationStat.monthCnt}</div>
        <div class="stat-label">이번 달 일정</div>
      </div>
    </div>
    <div class="stat-card">
      <div class="stat-icon purple"><span class="material-symbols-rounded">group</span></div>
      <div>
        <div class="stat-value">${vacationStat.vacationUserCnt}</div>
        <div class="stat-label">휴가 직원</div>
      </div>
    </div>
  </div>

  <!-- 탭바 -->
  <div class="tab-bar">
    <button type="button" class="tab-btn active" data-action="changeTab" data-tab="calendar">
      <span class="material-symbols-rounded">calendar_month</span>
      달력
    </button>
    <button type="button" class="tab-btn" data-action="changeTab" data-tab="list">
      <span class="material-symbols-rounded">list_alt</span>
      전체 목록
    </button>
  </div>

  <!-- 탭: 달력 -->
  <div class="tab-panel active" id="calendarTabPanel">
    <div class="panel">
      <div class="panel-header">
        <div class="panel-title">
          <span class="material-symbols-rounded">calendar_month</span>
          월간 일정
        </div>
        <div style="display:flex; align-items:center; gap:10px;">
          <button type="button" class="btn btn-sm btn-secondary" data-action="prevMonth">
            <span class="material-symbols-rounded">chevron_left</span>
          </button>
          <strong id="calendarTitle" style="font-size:14px; min-width:70px; text-align:center;"></strong>
          <button type="button" class="btn btn-sm btn-secondary" data-action="nextMonth">
            <span class="material-symbols-rounded">chevron_right</span>
          </button>
        </div>
      </div>

      <div style="display:grid; grid-template-columns:1fr 300px; border-top:1px solid var(--border);">

        <!-- 달력 -->
        <div style="overflow-x:auto; border-right:1px solid var(--border);">
          <table class="tbl vac-calendar">
            <thead>
            <tr>
              <th style="color:#c0392b;">일</th>
              <th>월</th><th>화</th><th>수</th><th>목</th><th>금</th>
              <th style="color:#2980b9;">토</th>
            </tr>
            </thead>
            <tbody id="calendarBody"></tbody>
          </table>
        </div>

        <!-- 날짜 현황 패널 -->
        <div style="display:flex; flex-direction:column;">
          <div style="padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
            <div style="font-size:11px; font-weight:700; color:var(--text-tertiary); text-transform:uppercase; letter-spacing:0.04em;">날짜별 현황</div>
            <div id="dayPanelDate" style="font-size:18px; font-weight:800; color:var(--text-primary); margin-top:4px;">날짜를 선택하세요</div>
          </div>
          <div id="dayPanelBody" style="flex:1; overflow-y:auto; padding:12px 16px;">
            <div style="color:var(--text-tertiary); font-size:12px; text-align:center; padding:24px 0;">
              달력에서 날짜를 클릭하면<br>해당 날의 일정이 표시됩니다.
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>

  <!-- 탭: 전체 목록 -->
  <div class="tab-panel" id="listTabPanel">
    <div class="panel">
      <div class="panel-header">
        <div class="panel-title">
          <span class="material-symbols-rounded">list_alt</span>
          전체 휴가 목록
        </div>
        <span class="list-count" id="listCount">${vacationStat.totalCnt}건</span>
      </div>

      <div class="filter-bar">
        <select class="form-select" id="colorFilter" style="width:150px;">
          <option value="">전체 구분</option>
          <option value="V_ANN">연차/휴가</option>
          <option value="V_HALF">반차</option>
          <option value="V_SICK">병가</option>
          <option value="V_OFF">공가/경조사</option>
          <option value="V_ETC">기타 일정</option>
        </select>

        <div class="search-wrap" style="width:280px;">
          <span class="material-symbols-rounded">search</span>
          <input type="text" class="form-input" id="keyword" placeholder="직원명 또는 일정 제목 검색">
        </div>

        <button type="button" class="btn btn-primary" data-action="search">검색</button>
        <button type="button" class="btn btn-secondary" data-action="reset">초기화</button>
      </div>

      <div class="table-wrap">
        <table class="tbl">
          <thead>
          <tr>
            <th>직원</th><th>일정 제목</th><th>구분</th><th>기간</th><th>관리</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty vacationList}">
              <tr><td colspan="5" style="text-align:center; color:var(--text-tertiary);">등록된 휴가 일정이 없습니다.</td></tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="vacation" items="${vacationList}">
                <tr class="vacation-row"
                    data-vacation-schdl-no="${vacation.vacationSchdlNo}"
                    data-user-no="${vacation.userNo}"
                    data-user-nm="${vacation.userNm}"
                    data-schdl-ttl="${vacation.schdlTtl}"
                    data-color-cd="${vacation.colorCd}"
                    data-bgng-dt="<fmt:formatDate value='${vacation.schdlBgngDt}' pattern='yyyy-MM-dd'/>"
                    data-end-dt="<fmt:formatDate value='${vacation.schdlEndDt}' pattern='yyyy-MM-dd'/>">
                  <td class="td-bold">${vacation.userNm}</td>
                  <td>${vacation.schdlTtl}</td>
                  <td><span data-color-label="${vacation.colorCd}">${vacation.colorCd}</span></td>
                  <td>
                    <fmt:formatDate value="${vacation.schdlBgngDt}" pattern="yyyy.MM.dd"/>
                    ~
                    <fmt:formatDate value="${vacation.schdlEndDt}" pattern="yyyy.MM.dd"/>
                  </td>
                  <td>
                    <div class="grid-actions">
                      <button type="button" class="btn btn-xs btn-detail" data-action="detail" data-vacation-schdl-no="${vacation.vacationSchdlNo}">상세</button>
                      <button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-vacation-schdl-no="${vacation.vacationSchdlNo}">수정</button>
                      <button type="button" class="btn btn-xs btn-delete" data-action="delete" data-vacation-schdl-no="${vacation.vacationSchdlNo}">삭제</button>
                    </div>
                  </td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- 등록/수정 모달 -->
  <div class="modal-overlay" id="vacationModal">
    <div class="modal modal-md">
      <div class="modal-header">
        <h3 id="modalTitle">휴가 등록</h3>
        <button type="button" class="modal-close" data-modal-close>
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>

      <form id="vacationForm">
        <input type="hidden" id="vacationSchdlNo" name="vacationSchdlNo">

        <div class="modal-body">
          <div class="form-section">
            <div class="form-section-title">
              <span class="material-symbols-rounded">person</span>직원 선택
            </div>
            <div class="form-row cols-1">
              <div class="form-group">
                <label class="form-label">직원 <span class="req">*</span></label>
                <select class="form-select" id="userNo" name="userNo" required>
                  <option value="">선택</option>
                  <c:forEach var="manager" items="${managerList}">
                    <option value="${manager.userNo}">${manager.userNm}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
          </div>

          <div class="form-section">
            <div class="form-section-title">
              <span class="material-symbols-rounded">event</span>일정 정보
            </div>
            <div class="form-row cols-1">
              <div class="form-group">
                <label class="form-label">일정 제목 <span class="req">*</span></label>
                <input type="text" class="form-input" id="schdlTtl" name="schdlTtl" placeholder="예: 홍길동 연차" required>
              </div>
            </div>
            <div class="form-row cols-2">
              <div class="form-group">
                <label class="form-label">시작일 <span class="req">*</span></label>
                <input type="date" class="form-input" id="schdlBgngDt" name="schdlBgngDt" required>
              </div>
              <div class="form-group">
                <label class="form-label">종료일 <span class="req">*</span></label>
                <input type="date" class="form-input" id="schdlEndDt" name="schdlEndDt" required>
              </div>
            </div>
            <div class="form-row cols-1">
              <div class="form-group">
                <label class="form-label">일정 구분</label>
                <select class="form-select" id="colorCd" name="colorCd">
                  <option value="V_ANN">연차/휴가</option>
                  <option value="V_HALF">반차</option>
                  <option value="V_SICK">병가</option>
                  <option value="V_OFF">공가/경조사</option>
                  <option value="V_ETC">기타 일정</option>
                </select>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-modal-close>취소</button>
          <button type="submit" class="btn btn-primary">저장</button>
        </div>
      </form>
    </div>
  </div>

  <!-- 상세 모달 -->
  <div class="modal-overlay" id="detailModal">
    <div class="modal modal-sm">
      <div class="modal-header">
        <h3>휴가 일정 상세</h3>
        <button type="button" class="modal-close" data-modal-close>
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>
      <div class="modal-body">
        <div class="mngr-detail-grid">
          <div class="mngr-detail-item">
            <div class="mngr-detail-label">직원</div>
            <div class="mngr-detail-value" id="detailUserNm"></div>
          </div>
          <div class="mngr-detail-item">
            <div class="mngr-detail-label">구분</div>
            <div class="mngr-detail-value" id="detailColorNm"></div>
          </div>
          <div class="mngr-detail-item mngr-detail-wide">
            <div class="mngr-detail-label">일정 제목</div>
            <div class="mngr-detail-value" id="detailSchdlTtl"></div>
          </div>
          <div class="mngr-detail-item mngr-detail-wide">
            <div class="mngr-detail-label">기간</div>
            <div class="mngr-detail-value" id="detailPeriod"></div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-modal-close>닫기</button>
      </div>
    </div>
  </div>

</div>

<style>
  /* 달력 셀 */
  .vac-calendar { table-layout: fixed; }
  .vac-calendar th { text-align: center; padding: 8px 4px; font-size: 11px; }
  .vac-calendar td {
    vertical-align: top;
    padding: 6px 8px;
    height: 90px;
    cursor: pointer;
    transition: background 0.12s;
    border-right: 1px solid var(--border);
    border-bottom: 1px solid var(--border);
  }
  .vac-calendar td:last-child { border-right: none; }
  .vac-calendar tr:last-child td { border-bottom: none; }
  .vac-calendar td:hover { background: #f7f8f9; }
  .vac-calendar td.selected { background: #f0f4ff; }
  .vac-calendar td.today .day-num { color: var(--btn-primary); font-weight: 800; }
  .vac-calendar td.sun .day-num { color: #c0392b; }
  .vac-calendar td.sat .day-num { color: #2980b9; }
  .vac-calendar .day-num { font-size: 12px; font-weight: 600; margin-bottom: 4px; }
  .vac-calendar .day-empty { cursor: default; background: #fafafa; }
  .vac-calendar .day-empty:hover { background: #fafafa; }

  /* 일정 칩 */
  .vac-chip {
    font-size: 10px;
    font-weight: 600;
    padding: 2px 6px;
    border-radius: 3px;
    margin-bottom: 2px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    display: block;
  }
  .vac-chip.V_ANN  { background: #eef4ff; color: #2c4a8a; }
  .vac-chip.V_HALF { background: #f5f0fa; color: #5a3a7a; }
  .vac-chip.V_SICK { background: #fff0f0; color: #8a2020; }
  .vac-chip.V_OFF  { background: #fffbf0; color: #8a6400; }
  .vac-chip.V_ETC  { background: #f4f4f5; color: #4a5260; }

  /* 날짜 현황 패널 아이템 */
  .day-panel-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 0;
    border-bottom: 1px solid var(--border);
  }
  .day-panel-item:last-child { border-bottom: none; }
  .day-panel-nm { font-size: 13px; font-weight: 600; color: var(--text-primary); }
  .day-panel-sub { font-size: 11px; color: var(--text-tertiary); margin-top: 1px; }
</style>

<script>
  (function () {
    var page = document.getElementById("mngrVacationPage");
    if (!page || page.dataset.inited === "true") return;
    page.dataset.inited = "true";

    var contextPath = "${pageContext.request.contextPath}";
    var vacationModal = document.getElementById("vacationModal");
    var detailModal   = document.getElementById("detailModal");
    var vacationForm  = document.getElementById("vacationForm");
    var calendarBody  = document.getElementById("calendarBody");
    var dayPanelDate  = document.getElementById("dayPanelDate");
    var dayPanelBody  = document.getElementById("dayPanelBody");

    var mode = "insert";
    var currentDate = new Date();
    var selectedDate = null;

    /* ───────── 코드 → 텍스트/클래스 ───────── */
    var COLOR_TEXT = { V_ANN: "연차/휴가", V_HALF: "반차", V_SICK: "병가", V_OFF: "공가/경조사", V_ETC: "기타 일정" };
    var BADGE_CLASS = { V_ANN: "badge badge-blue", V_HALF: "badge badge-purple", V_SICK: "badge badge-red", V_OFF: "badge badge-yellow", V_ETC: "badge badge-gray" };

    function colorName(code)  { return COLOR_TEXT[code]  || "-"; }
    function badgeClass(code) { return BADGE_CLASS[code] || "badge badge-gray"; }

    /* ───────── 데이터 수집 ───────── */
    function getRows() {
      return Array.from(page.querySelectorAll(".vacation-row")).map(function (row) {
        return {
          vacationSchdlNo: row.dataset.vacationSchdlNo,
          userNo:    row.dataset.userNo,
          userNm:    row.dataset.userNm,
          schdlTtl:  row.dataset.schdlTtl,
          colorCd:   row.dataset.colorCd,
          schdlBgngDt: row.dataset.bgngDt,
          schdlEndDt:  row.dataset.endDt
        };
      });
    }

    function findVacation(no) {
      return getRows().find(function (r) { return String(r.vacationSchdlNo) === String(no); });
    }

    /* ───────── 달력 렌더 ───────── */
    function renderCalendar() {
      var rows  = getRows();
      var year  = currentDate.getFullYear();
      var month = currentDate.getMonth();

      document.getElementById("calendarTitle").textContent =
              year + "." + String(month + 1).padStart(2, "0");

      var first    = new Date(year, month, 1);
      var lastDate = new Date(year, month + 1, 0).getDate();
      var startDay = first.getDay();
      var todayStr = toDateStr(new Date());

      var html = "";
      var day  = 1;

      for (var week = 0; week < 6; week++) {
        html += "<tr>";
        for (var col = 0; col < 7; col++) {
          if ((week === 0 && col < startDay) || day > lastDate) {
            html += '<td class="day-empty"></td>';
            continue;
          }

          var dateStr  = toDateStr(new Date(year, month, day));
          var dayRows  = rows.filter(function (r) { return r.schdlBgngDt <= dateStr && r.schdlEndDt >= dateStr; });
          var isToday  = dateStr === todayStr;
          var isSelected = dateStr === selectedDate;
          var cls = [];
          if (col === 0) cls.push("sun");
          if (col === 6) cls.push("sat");
          if (isToday)   cls.push("today");
          if (isSelected) cls.push("selected");

          html += '<td class="' + cls.join(" ") + '" data-date="' + dateStr + '">';
          html += '<div class="day-num">' + day + '</div>';

          dayRows.slice(0, 3).forEach(function (r) {
            html += '<span class="vac-chip ' + r.colorCd + '">' + r.userNm + '</span>';
          });
          if (dayRows.length > 3) {
            html += '<span style="font-size:10px;color:var(--text-tertiary);">+' + (dayRows.length - 3) + '건</span>';
          }

          html += "</td>";
          day++;
        }
        html += "</tr>";
        if (day > lastDate) break;
      }

      calendarBody.innerHTML = html;
    }

    /* ───────── 날짜 현황 패널 ───────── */
    function renderDayPanel(dateStr) {
      selectedDate = dateStr;
      renderCalendar(); // 선택 표시 갱신

      var parts = dateStr.split("-");
      dayPanelDate.textContent = parts[0] + "." + parts[1] + "." + parts[2];

      var rows = getRows().filter(function (r) {
        return r.schdlBgngDt <= dateStr && r.schdlEndDt >= dateStr;
      });

      if (rows.length === 0) {
        dayPanelBody.innerHTML = '<div style="color:var(--text-tertiary);font-size:12px;text-align:center;padding:24px 0;">이 날의 휴가 일정이 없습니다.</div>';
        return;
      }

      var html = "";
      rows.forEach(function (r) {
        html += '<div class="day-panel-item">'
                + '<div class="avatar avatar-sm">' + (r.userNm ? r.userNm.charAt(0) : "-") + '</div>'
                + '<div>'
                + '<div class="day-panel-nm">' + r.userNm + '</div>'
                + '<div class="day-panel-sub">' + colorName(r.colorCd) + ' · ' + r.schdlTtl + '</div>'
                + '</div>'
                + '</div>';
      });
      dayPanelBody.innerHTML = html;
    }

    /* ───────── 배지 텍스트 초기화 ───────── */
    function renderColorLabels() {
      page.querySelectorAll("[data-color-label]").forEach(function (el) {
        var code = el.dataset.colorLabel;
        el.textContent  = colorName(code);
        el.className    = badgeClass(code);
      });
    }

    /* ───────── 유틸 ───────── */
    function toDateStr(date) {
      return date.getFullYear() + "-"
              + String(date.getMonth() + 1).padStart(2, "0") + "-"
              + String(date.getDate()).padStart(2, "0");
    }

    function openModal(id)  { document.getElementById(id).classList.add("open"); }
    function closeModals()  {
      vacationModal.classList.remove("open");
      detailModal.classList.remove("open");
    }

    function reload() {
      if (typeof reloadFragment === "function") { reloadFragment(); return; }
      if (typeof loadContent    === "function") { loadContent(contextPath + "/manager/employee/vacation", "휴가 일정"); }
    }

    /* ───────── 모달 ───────── */
    function openVacationModal(openMode, data) {
      mode = openMode;
      vacationForm.reset();
      document.getElementById("vacationSchdlNo").value = "";
      document.getElementById("modalTitle").textContent = openMode === "insert" ? "휴가 등록" : "휴가 수정";

      if (openMode === "insert") {
        document.getElementById("colorCd").value = "V_ANN";
      }

      if (openMode === "update" && data) {
        document.getElementById("vacationSchdlNo").value = data.vacationSchdlNo;
        document.getElementById("userNo").value      = data.userNo;
        document.getElementById("schdlTtl").value    = data.schdlTtl;
        document.getElementById("schdlBgngDt").value = data.schdlBgngDt;
        document.getElementById("schdlEndDt").value  = data.schdlEndDt;
        document.getElementById("colorCd").value     = data.colorCd || "V_ANN";
      }

      openModal("vacationModal");
    }

    function openDetailModal(data) {
      if (!data) return;
      document.getElementById("detailUserNm").textContent  = data.userNm || "-";
      document.getElementById("detailColorNm").textContent = colorName(data.colorCd);
      document.getElementById("detailSchdlTtl").textContent = data.schdlTtl || "-";
      document.getElementById("detailPeriod").textContent  = data.schdlBgngDt + " ~ " + data.schdlEndDt;
      openModal("detailModal");
    }

    /* ───────── 이벤트 ───────── */
    page.addEventListener("click", function (e) {
      if (e.target.closest("[data-modal-close]")) { closeModals(); return; }

      // 달력 날짜 클릭
      var td = e.target.closest("td[data-date]");
      if (td) { renderDayPanel(td.dataset.date); return; }

      var btn = e.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;

      if (action === "changeTab") {
        var tab = btn.dataset.tab;
        page.querySelectorAll(".tab-btn").forEach(function (b) { b.classList.toggle("active", b.dataset.tab === tab); });
        document.getElementById("calendarTabPanel").classList.toggle("active", tab === "calendar");
        document.getElementById("listTabPanel").classList.toggle("active", tab === "list");
        return;
      }

      if (action === "openRegister")  { openVacationModal("insert"); return; }
      if (action === "prevMonth")     { currentDate.setMonth(currentDate.getMonth() - 1); renderCalendar(); return; }
      if (action === "nextMonth")     { currentDate.setMonth(currentDate.getMonth() + 1); renderCalendar(); return; }
      if (action === "detail")        { openDetailModal(findVacation(btn.dataset.vacationSchdlNo)); return; }
      if (action === "edit")          { openVacationModal("update", findVacation(btn.dataset.vacationSchdlNo)); return; }

      if (action === "delete") {
        if (!confirm("선택한 휴가 일정을 삭제하시겠습니까?")) return;
        fetch(contextPath + "/manager/employee/vacation/delete", {
          method: "POST",
          headers: { "Content-Type": "application/json", "X-Requested-With": "XMLHttpRequest" },
          body: JSON.stringify({ vacationSchdlNo: btn.dataset.vacationSchdlNo })
        }).then(reload);
        return;
      }

      if (action === "search") {
        var colorFilter = document.getElementById("colorFilter").value;
        var keyword     = document.getElementById("keyword").value.trim();
        var rows        = page.querySelectorAll(".vacation-row");
        var visible     = 0;

        rows.forEach(function (row) {
          var matchColor   = !colorFilter || row.dataset.colorCd === colorFilter;
          var matchKeyword = !keyword
                  || row.dataset.userNm.includes(keyword)
                  || row.dataset.schdlTtl.includes(keyword);

          var show = matchColor && matchKeyword;
          row.style.display = show ? "" : "none";
          if (show) visible++;
        });

        document.getElementById("listCount").textContent = visible + "건";
        return;
      }

      if (action === "reset") {
        document.getElementById("colorFilter").value = "";
        document.getElementById("keyword").value     = "";
        page.querySelectorAll(".vacation-row").forEach(function (r) { r.style.display = ""; });
        document.getElementById("listCount").textContent = "${vacationStat.totalCnt}건";
      }
    });

    vacationForm.addEventListener("submit", function (e) {
      e.preventDefault();

      var bgngDt = document.getElementById("schdlBgngDt").value;
      var endDt  = document.getElementById("schdlEndDt").value;

      if (bgngDt > endDt) { alert("종료일은 시작일보다 빠를 수 없습니다."); return; }

      var url = mode === "insert"
              ? contextPath + "/manager/employee/vacation/insert"
              : contextPath + "/manager/employee/vacation/update";

      fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json", "X-Requested-With": "XMLHttpRequest" },
        body: JSON.stringify({
          vacationSchdlNo: document.getElementById("vacationSchdlNo").value,
          userNo:     document.getElementById("userNo").value,
          schdlTtl:   document.getElementById("schdlTtl").value,
          schdlBgngDt: bgngDt,
          schdlEndDt:  endDt,
          colorCd:    document.getElementById("colorCd").value
        })
      }).then(function () { closeModals(); reload(); });
    });

    /* ───────── 초기화 ───────── */
    renderColorLabels();
    renderCalendar();
  })();
</script>
