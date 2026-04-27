<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="meterHistoryPage">

  <div class="page-header">
    <div class="page-title-block">
      <h2>검침 기록 관리</h2>
      <p>전기 및 수도 사용량 검침 기록 등록·수정·조회 — METER_HISTORY 기반</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-primary" data-action="openRegister">
        <span class="material-symbols-rounded">add</span>
        신규 검침 등록
      </button>
    </div>
  </div>

  <!-- 통계: 전월대비 증감 강조 -->
  <div class="stat-row" style="grid-template-columns:repeat(3,minmax(0,1fr));">
    <div class="stat-card" style="background:#2e5c38; border-color:#264e30;">
      <div style="width:100%;">
        <div style="font-size:12px; color:rgba(255,255,255,0.7); margin-bottom:4px;">이번 달 총 전기 사용량</div>
        <div style="font-size:26px; font-weight:800; color:#fff;" id="statElec">842.5 <span style="font-size:14px;">kWh</span></div>
        <div style="font-size:11px; color:rgba(255,255,255,0.6); margin-top:4px;">
          <span style="background:rgba(255,255,255,0.15); padding:2px 8px; border-radius:99px;">▼ 전월 대비 4.2% 감소</span>
        </div>
      </div>
    </div>
    <div class="stat-card">
      <div style="width:100%;">
        <div style="font-size:12px; color:var(--text-tertiary); margin-bottom:4px;">이번 달 총 수도 사용량</div>
        <div style="font-size:26px; font-weight:800; color:var(--text-primary);" id="statWater">32.8 <span style="font-size:14px; font-weight:400;">m³</span></div>
        <div style="font-size:11px; margin-top:4px;">
          <span style="background:#fde68a; color:#6b3d0a; padding:2px 8px; border-radius:99px;">▲ 전월 대비 12% 증가</span>
        </div>
      </div>
    </div>
    <div class="stat-card">
      <div style="width:100%;">
        <div style="font-size:12px; color:var(--text-tertiary); margin-bottom:4px;">최근 입력 건수</div>
        <div style="font-size:26px; font-weight:800; color:var(--text-primary);" id="statCount">0</div>
        <div style="font-size:11px; color:var(--text-tertiary); margin-top:4px;" id="statCountSub">전기 0건 · 수도 0건</div>
      </div>
    </div>
  </div>

  <!-- pill형 탭 필터 + 검색 -->
  <div class="panel">
    <div class="filter-bar" style="gap:12px;">

      <!-- 검침 항목 pill 탭 -->
      <div style="display:flex; gap:4px; background:#f0f1f3; border-radius:99px; padding:3px;">
        <button type="button" class="meter-tab-btn active" data-meter-tab="ALL"
                style="padding:5px 16px; border:none; border-radius:99px; font-size:12px; font-weight:600; cursor:pointer; transition:0.15s; background:#2e5c38; color:#fff;">전체</button>
        <button type="button" class="meter-tab-btn" data-meter-tab="ELEC"
                style="padding:5px 16px; border:none; border-radius:99px; font-size:12px; font-weight:600; cursor:pointer; transition:0.15s; background:transparent; color:var(--text-secondary);">전기</button>
        <button type="button" class="meter-tab-btn" data-meter-tab="WATER"
                style="padding:5px 16px; border:none; border-radius:99px; font-size:12px; font-weight:600; cursor:pointer; transition:0.15s; background:transparent; color:var(--text-secondary);">수도</button>
      </div>

      <!-- 기간 -->
      <select class="form-select" id="filterPeriod" style="width:130px;">
        <option value="7">최근 7일</option>
        <option value="30">최근 30일</option>
        <option value="90">최근 3개월</option>
        <option value="0">전체</option>
      </select>

      <!-- 검색 -->
      <div class="search-wrap" style="width:240px;">
        <span class="material-symbols-rounded">search</span>
        <input type="text" class="form-input" id="filterKeyword" placeholder="동/호수, 시설명 검색">
      </div>

      <button type="button" class="btn btn-primary"   data-action="search">검색</button>
      <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
    </div>

    <!-- 목록 -->
    <div class="panel-header">
      <h3 class="panel-title">
        <span class="material-symbols-rounded">speed</span>
        검침 기록 리스트
      </h3>
      <span style="font-size:11px; color:var(--text-tertiary);">총 <span id="meterListCount">0</span>건 · METER_HISTORY</span>
    </div>

    <div class="table-wrap">
      <table class="tbl">
        <thead>
        <tr>
          <th>시설명</th>
          <th>호번호</th>
          <th>항목</th>
          <th style="text-align:right;">이전 지침</th>
          <th style="text-align:right;">현재 지침</th>
          <th style="text-align:right;">사용량</th>
          <th>결과</th>
          <th>검침일</th>
          <th style="width:80px;">관리</th>
        </tr>
        </thead>
        <tbody id="meterTableBody"></tbody>
      </table>
    </div>
  </div>

  <!-- 등록/수정 모달 -->
  <div class="modal-overlay" id="meterModal">
    <div class="modal modal-md">
      <div class="modal-header primary">
        <h3 class="modal-title" id="meterModalTitle">신규 검침 등록</h3>
        <button type="button" class="modal-close" data-action="closeModal">
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>

      <form id="meterForm">
        <input type="hidden" id="meterHstryNo">

        <div class="modal-body">
          <div class="form-section">
            <div class="form-section-title">
              <span class="material-symbols-rounded">speed</span>
              검침 정보
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">시설명 (FACILITY_NO) <span class="req">*</span></label>
                <input type="text" class="form-input" id="mFacilityNm" placeholder="예: 커뮤니티센터">
              </div>
              <div class="form-field">
                <label class="field-label">호 번호 (HO_NO)</label>
                <input type="text" class="form-input" id="mHoNo" placeholder="예: 102호">
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">검침일 (METER_DT) <span class="req">*</span></label>
                <input type="date" class="form-input" id="mMeterDt">
              </div>
              <div class="form-field">
                <label class="field-label">검침 항목</label>
                <select class="form-select" id="mMeterTyCd">
                  <option value="ELEC">전기</option>
                  <option value="WATER">수도</option>
                  <option value="GAS">가스</option>
                  <option value="HEAT">난방</option>
                </select>
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">이전 지침 (PRE_VAL)</label>
                <input type="number" class="form-input" id="mPreVal" placeholder="0.00" step="0.01"
                       oninput="calcUsage()">
              </div>
              <div class="form-field">
                <label class="field-label">현재 지침 (CURR_VAL) <span class="req">*</span></label>
                <input type="number" class="form-input" id="mCurrVal" placeholder="0.00" step="0.01"
                       oninput="calcUsage()">
              </div>
            </div>

            <!-- 사용량 자동계산 표시 -->
            <div style="display:flex; align-items:center; gap:10px; padding:12px 16px; background:#f0f7f2; border:1px solid #a8ccb0; border-radius:8px; margin-bottom:14px;">
              <span class="material-symbols-rounded" style="color:#2e5c38; font-size:18px;">calculate</span>
              <div>
                <div style="font-size:11px; color:#2e5c38; font-weight:700;">사용량 (자동 계산)</div>
                <div style="font-size:18px; font-weight:800; color:#1a5c30;" id="calcUsageDisplay">— </div>
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">검침 결과 (METER_RSLT_CD)</label>
                <select class="form-select" id="mMeterRsltCd">
                  <option value="NORMAL">정상</option>
                  <option value="ERROR">오류</option>
                  <option value="MISS">누락</option>
                  <option value="CHECK">확인필요</option>
                </select>
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">검침 메모 (METER_CN)</label>
                <textarea class="form-textarea" id="mMeterCn" placeholder="특이사항을 입력하세요." style="min-height:70px;"></textarea>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
          <button type="button" class="btn btn-primary" id="meterEditBtn"
                  data-action="changeToEdit" style="display:none;">수정하기</button>
          <button type="submit" class="btn btn-primary" id="meterSaveBtn">저장</button>
        </div>
      </form>
    </div>
  </div>

</div>

<script>
  (function () {
    var page = document.getElementById("meterHistoryPage");
    if (!page || page.dataset.bound === "true") return;
    page.dataset.bound = "true";

    var modal      = document.getElementById("meterModal");
    var form       = document.getElementById("meterForm");
    var modalTitle = document.getElementById("meterModalTitle");
    var saveBtn    = document.getElementById("meterSaveBtn");
    var editBtn    = document.getElementById("meterEditBtn");
    var tbody      = document.getElementById("meterTableBody");

    var currentTab = "ALL";

    /* ── 더미 데이터 (METER_HISTORY 컬럼 기준) ── */
    var rowData = [
      { meterHstryNo:"MH001", facilityNm:"커뮤니티센터", hoNo:"-",    meterTyCd:"WATER", preVal:2105,   currVal:2118,   meterDt:"2026-04-14", meterRsltCd:"NORMAL", meterCn:"" },
      { meterHstryNo:"MH002", facilityNm:"102동 지하주차장", hoNo:"-", meterTyCd:"ELEC",  preVal:158420, currVal:158950, meterDt:"2026-04-14", meterRsltCd:"NORMAL", meterCn:"" },
      { meterHstryNo:"MH003", facilityNm:"101동",         hoNo:"102호", meterTyCd:"ELEC",  preVal:42150,  currVal:42284,  meterDt:"2026-04-13", meterRsltCd:"ERROR",  meterCn:"계량기 이상 의심" },
      { meterHstryNo:"MH004", facilityNm:"101동",         hoNo:"201호", meterTyCd:"WATER", preVal:830,    currVal:844,    meterDt:"2026-04-13", meterRsltCd:"NORMAL", meterCn:"" },
      { meterHstryNo:"MH005", facilityNm:"103동",         hoNo:"501호", meterTyCd:"ELEC",  preVal:91200,  currVal:91200,  meterDt:"2026-04-12", meterRsltCd:"MISS",   meterCn:"검침 누락" }
    ];

    /* ── 코드 변환 ── */
    var METER_TY = { ELEC:"전기", WATER:"수도", GAS:"가스", HEAT:"난방" };
    var METER_TY_BADGE = { ELEC:"badge-yellow", WATER:"badge-blue", GAS:"badge-orange", HEAT:"badge-red" };
    var RSLT_TEXT  = { NORMAL:"정상", ERROR:"오류", MISS:"누락", CHECK:"확인필요" };
    var RSLT_BADGE = { NORMAL:"badge-green", ERROR:"badge-red", MISS:"badge-orange", CHECK:"badge-yellow" };
    var UNIT = { ELEC:"kWh", WATER:"m³", GAS:"m³", HEAT:"Mcal" };

    function meterBadge(code) {
      return '<span class="badge ' + (METER_TY_BADGE[code] || "badge-gray") + '">' + (METER_TY[code] || code) + '</span>';
    }
    function rsltBadge(code) {
      return '<span class="badge ' + (RSLT_BADGE[code] || "badge-gray") + '">' + (RSLT_TEXT[code] || code) + '</span>';
    }

    /* ── 통계 ── */
    function updateStats(data) {
      var elecCnt  = data.filter(function(r){ return r.meterTyCd === "ELEC"; }).length;
      var waterCnt = data.filter(function(r){ return r.meterTyCd === "WATER"; }).length;
      document.getElementById("statCount").textContent    = data.length;
      document.getElementById("statCountSub").textContent = "전기 " + elecCnt + "건 · 수도 " + waterCnt + "건";
    }

    /* ── 목록 렌더 ── */
    function renderTable(data) {
      document.getElementById("meterListCount").textContent = data.length;
      updateStats(data);

      if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center; color:var(--text-tertiary);">검침 기록이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(function(row, idx) {
        var usage   = row.currVal - row.preVal;
        var unit    = UNIT[row.meterTyCd] || "";
        var usageTxt = usage > 0
                ? '<strong style="color:var(--text-primary);">' + usage.toLocaleString() + '</strong> <span style="font-size:11px; color:var(--text-tertiary);">' + unit + '</span>'
                : '<span style="color:var(--text-tertiary);">0</span>';

        return '<tr>'
                + '<td class="td-bold">' + row.facilityNm + '</td>'
                + '<td>' + (row.hoNo || "-") + '</td>'
                + '<td>' + meterBadge(row.meterTyCd) + '</td>'
                + '<td style="text-align:right; font-family:monospace; color:var(--text-tertiary);">' + row.preVal.toLocaleString() + '</td>'
                + '<td style="text-align:right; font-family:monospace; font-weight:700; color:var(--text-primary);">' + row.currVal.toLocaleString() + '</td>'
                + '<td style="text-align:right;">' + usageTxt + '</td>'
                + '<td>' + rsltBadge(row.meterRsltCd) + '</td>'
                + '<td>' + row.meterDt + '</td>'
                + '<td><div class="grid-actions">'
                + '<button type="button" class="btn btn-xs btn-edit" data-action="edit" data-idx="' + idx + '">수정</button>'
                + '</div></td>'
                + '</tr>';
      }).join("");
    }

    /* ── 필터 ── */
    function getFiltered() {
      var keyword = document.getElementById("filterKeyword").value.trim();
      return rowData.filter(function(row) {
        var tabMatch = currentTab === "ALL" || row.meterTyCd === currentTab;
        var kwMatch  = !keyword
                || row.facilityNm.indexOf(keyword) > -1
                || row.hoNo.indexOf(keyword) > -1;
        return tabMatch && kwMatch;
      });
    }

    function resetFilter() {
      document.getElementById("filterKeyword").value = "";
      document.getElementById("filterPeriod").value  = "7";
      setTab("ALL");
      renderTable(rowData);
    }

    function setTab(tab) {
      currentTab = tab;
      page.querySelectorAll(".meter-tab-btn").forEach(function(btn) {
        var active = btn.dataset.meterTab === tab;
        btn.style.background = active ? "#2e5c38" : "transparent";
        btn.style.color      = active ? "#fff"    : "var(--text-secondary)";
      });
    }

    /* ── 사용량 자동계산 ── */
    window.calcUsage = function() {
      var pre  = parseFloat(document.getElementById("mPreVal").value)  || 0;
      var curr = parseFloat(document.getElementById("mCurrVal").value) || 0;
      var ty   = document.getElementById("mMeterTyCd").value;
      var usage = curr - pre;
      var unit  = UNIT[ty] || "";
      var display = document.getElementById("calcUsageDisplay");

      if (curr === 0) {
        display.textContent = "—";
      } else if (usage < 0) {
        display.innerHTML = '<span style="color:#991b1b;">음수값 확인 필요</span>';
      } else {
        display.textContent = usage.toFixed(2) + " " + unit;
      }
    };

    /* ── 모달 ── */
    function openModal(mode, idx) {
      form.reset();
      document.getElementById("calcUsageDisplay").textContent = "—";
      saveBtn.style.display = "inline-flex";
      editBtn.style.display = "none";
      setFormDisabled(false);

      if (mode === "register") {
        modalTitle.textContent = "신규 검침 등록";
        var today = new Date().toISOString().slice(0,10);
        document.getElementById("mMeterDt").value = today;
      }
      if (mode === "edit" && idx !== undefined) {
        modalTitle.textContent = "검침 수정";
        fillForm(rowData[idx]);
      }
      modal.classList.add("open");
    }

    function fillForm(row) {
      document.getElementById("meterHstryNo").value = row.meterHstryNo || "";
      document.getElementById("mFacilityNm").value  = row.facilityNm   || "";
      document.getElementById("mHoNo").value        = row.hoNo         || "";
      document.getElementById("mMeterDt").value     = row.meterDt      || "";
      document.getElementById("mMeterTyCd").value   = row.meterTyCd    || "ELEC";
      document.getElementById("mPreVal").value      = row.preVal       || "";
      document.getElementById("mCurrVal").value     = row.currVal      || "";
      document.getElementById("mMeterRsltCd").value = row.meterRsltCd  || "NORMAL";
      document.getElementById("mMeterCn").value     = row.meterCn      || "";
      calcUsage();
    }

    function setFormDisabled(disabled) {
      form.querySelectorAll("input, select, textarea").forEach(function(el){ el.disabled = disabled; });
    }

    function closeModal() { modal.classList.remove("open"); }

    /* ── 이벤트 ── */
    page.addEventListener("click", function(e) {
      var btn = e.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;
      var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

      if (action === "openRegister") openModal("register");
      if (action === "edit")         openModal("edit", idx);
      if (action === "closeModal")   closeModal();
      if (action === "search")       renderTable(getFiltered());
      if (action === "resetFilter")  resetFilter();
    });

    /* pill 탭 클릭 */
    page.addEventListener("click", function(e) {
      var tabBtn = e.target.closest(".meter-tab-btn");
      if (!tabBtn) return;
      setTab(tabBtn.dataset.meterTab);
      renderTable(getFiltered());
    });

    modal.addEventListener("click", function(e){ if (e.target === modal) closeModal(); });

    form.addEventListener("submit", function(e){
      e.preventDefault();
      if (!document.getElementById("mFacilityNm").value.trim()) { alert("시설명을 입력하세요."); return; }
      if (!document.getElementById("mCurrVal").value)           { alert("현재 지침을 입력하세요."); return; }
      alert("저장 처리 연결 예정입니다.");
      closeModal();
    });

    renderTable(rowData);
  })();
</script>
