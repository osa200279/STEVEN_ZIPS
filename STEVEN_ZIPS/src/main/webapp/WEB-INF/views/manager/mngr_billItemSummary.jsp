<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="billItemSummaryPage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>관리비 항목·집계</h2>
            <p>항목별 관리비 집계 현황 조회 — BILL + BILL_DETAIL 기반</p>
        </div>
        <div class="page-actions">
            <button type="button" class="btn btn-secondary" id="btnPdf">
                <span class="material-symbols-rounded">picture_as_pdf</span>
                PDF 내보내기
            </button>
        </div>
    </div>

    <!-- 상단: 당월 총액 + 요약 -->
    <div style="display:grid; grid-template-columns:1fr 2fr; gap:14px; margin-bottom:20px;">

        <div style="background:#2e5c38; border-radius:var(--r-lg); padding:28px 24px; display:flex; flex-direction:column; justify-content:space-between; min-height:140px;">
            <div style="font-size:12px; color:rgba(255,255,255,0.65); margin-bottom:8px;">당월 총 부과 금액 (BILL_TOT_AMT 합계)</div>
            <div>
                <div style="font-size:30px; font-weight:900; color:#fff; margin-bottom:8px;" id="grandTotal">₩0</div>
                <div style="display:inline-flex; align-items:center; gap:4px; background:rgba(255,255,255,0.15); padding:3px 10px; border-radius:99px; font-size:11px; color:rgba(255,255,255,0.85);" id="grandTotalDiff">
                    — 전월 대비
                </div>
            </div>
        </div>

        <div style="display:grid; grid-template-columns:repeat(3,1fr); gap:14px;">
            <div class="stat-card">
                <div>
                    <div style="font-size:11px; color:var(--text-tertiary); margin-bottom:6px;">이번 달 고지서 (BILL)</div>
                    <div style="font-size:26px; font-weight:800;" id="statBillCnt">0건</div>
                    <div style="font-size:11px; color:var(--text-tertiary); margin-top:4px;">생성 완료</div>
                </div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:11px; color:var(--text-tertiary); margin-bottom:6px;">납부 완료 (PAID)</div>
                    <div style="font-size:26px; font-weight:800; color:#2e5c38;" id="statPaidCnt">0건</div>
                    <div style="font-size:11px; color:var(--text-tertiary); margin-top:4px;">PYMT_STTS_CD</div>
                </div>
            </div>
            <div class="stat-card">
                <div>
                    <div style="font-size:11px; color:#d97706; margin-bottom:6px;">미납·연체</div>
                    <div style="font-size:26px; font-weight:800; color:#d97706;" id="statUnpaidCnt">0건</div>
                    <div style="font-size:11px; color:var(--text-tertiary); margin-top:4px;">UNPAID + OVERDUE</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 집계 현황 -->
    <div class="panel">
        <div class="panel-header">
            <div>
                <h3 class="panel-title">
                    <span class="material-symbols-rounded">bar_chart</span>
                    관리비 집계 현황
                </h3>
                <div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">BILL_DETAIL.BILL_ITEM_CD 기준 집계</div>
            </div>
            <div style="display:flex; gap:6px;">
                <button type="button" class="chart-view-btn active" data-view="chart"
                        style="padding:5px 14px; border-radius:6px; border:1px solid #2e5c38; background:#2e5c38; color:#fff; font-size:12px; font-weight:600; cursor:pointer;">차트</button>
                <button type="button" class="chart-view-btn" data-view="list"
                        style="padding:5px 14px; border-radius:6px; border:1px solid var(--border); background:var(--card); color:var(--text-secondary); font-size:12px; font-weight:600; cursor:pointer;">리스트</button>
            </div>
        </div>

        <div class="filter-bar">
            <div class="form-field" style="flex-direction:row; align-items:center; gap:6px;">
                <label class="field-label" style="white-space:nowrap;">조회 기준</label>
                <select class="form-select" id="filterBase" style="width:120px;">
                    <option value="item">항목별</option>
                    <option value="month">납부월별</option>
                </select>
            </div>
            <div class="form-field" style="flex-direction:row; align-items:center; gap:6px;">
                <label class="field-label" style="white-space:nowrap;">집계 항목 (BILL_ITEM_CD)</label>
                <select class="form-select" id="filterItem" style="width:150px;">
                    <option value="ALL">전체 항목</option>
                    <option value="ELEC">ELEC (전기)</option>
                    <option value="WATER">WATER (수도)</option>
                    <option value="GAS">GAS (가스)</option>
                    <option value="COMMON">COMMON (공용관리비)</option>
                </select>
            </div>
            <div class="form-field" style="flex-direction:row; align-items:center; gap:6px;">
                <label class="field-label" style="white-space:nowrap;">조회 기간</label>
                <select class="form-select" id="filterPeriod" style="width:130px;">
                    <option value="6">최근 6개월</option>
                    <option value="12">최근 12개월</option>
                    <option value="3">최근 3개월</option>
                </select>
            </div>
            <button type="button" class="btn btn-primary" id="btnSearchChart">조회</button>
        </div>

        <div style="padding:4px 20px 8px; font-size:11px; color:var(--text-tertiary);" id="chartLabel">
            항목별 · 전체 항목 · 최근 6개월
        </div>

        <!-- 차트 뷰 -->
        <div id="chartView" style="padding:10px 20px 28px;">
            <div style="display:flex; align-items:flex-end; gap:8px; height:180px;" id="barChart"></div>
            <div style="display:flex; gap:8px; margin-top:8px; padding-top:8px; border-top:1px solid var(--border);" id="barLabels"></div>
            <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:10px; margin-top:16px; padding-top:16px; border-top:1px solid var(--border);" id="itemSummary"></div>
        </div>

        <!-- 리스트 뷰 -->
        <div id="listView" style="display:none;">
            <div class="table-wrap">
                <table class="tbl">
                    <thead>
                    <tr>
                        <th>월 (BILL_YM)</th>
                        <th style="text-align:right;">ELEC</th>
                        <th style="text-align:right;">WATER</th>
                        <th style="text-align:right;">GAS</th>
                        <th style="text-align:right;">COMMON</th>
                        <th style="text-align:right;">합계</th>
                    </tr>
                    </thead>
                    <tbody id="listViewBody"></tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<script>
    (function() {
        var page = document.getElementById("billItemSummaryPage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        var currentView = "chart";

        /* ── 더미 집계 데이터 (BILL + BILL_DETAIL 기반) ── */
        var months  = ["1월","2월","3월","4월","5월","6월"];
        var amounts = [
            { elec:38000, water:12000, gas:9000, common:45000 },
            { elec:40000, water:12400, gas:9200, common:45000 },
            { elec:42000, water:13000, gas:9500, common:45000 },
            { elec:39000, water:12200, gas:9100, common:45000 },
            { elec:41000, water:12800, gas:9300, common:45000 },
            { elec:38920, water:12400, gas:9000, common:45000 }
        ];

        /* 더미 BILL 요약 */
        var billSummary = { total:486, paid:449, unpaid:37 };

        var ITEM_LABEL = { elec:"전기 (ELEC)", water:"수도 (WATER)", gas:"가스 (GAS)", common:"공용관리비 (COMMON)" };
        var ITEM_COLOR = { elec:"#f59e0b", water:"#3b82f6", gas:"#f97316", common:"#2e5c38" };

        /* ── 상단 통계 ── */
        function initStats() {
            var grand = amounts[amounts.length-1];
            var total = grand.elec + grand.water + grand.gas + grand.common;
            var prevGrand = amounts[amounts.length-2];
            var prevTotal = prevGrand.elec + prevGrand.water + prevGrand.gas + prevGrand.common;
            var diff = total - prevTotal;
            var pct  = Math.abs(Math.round(diff / prevTotal * 100 * 10) / 10);

            document.getElementById("grandTotal").textContent = "₩" + (total * 486).toLocaleString();
            document.getElementById("grandTotalDiff").textContent =
                (diff >= 0 ? "▲" : "▼") + " 전월 대비 " + pct + "% " + (diff >= 0 ? "증가" : "감소");

            document.getElementById("statBillCnt").textContent   = billSummary.total + "건";
            document.getElementById("statPaidCnt").textContent   = billSummary.paid + "건";
            document.getElementById("statUnpaidCnt").textContent = billSummary.unpaid + "건";
        }

        /* ── 차트 렌더 ── */
        function renderChart() {
            var totals = amounts.map(function(a){ return a.elec + a.water + a.gas + a.common; });
            var maxAmt = Math.max.apply(null, totals);

            document.getElementById("barChart").innerHTML = months.map(function(m, i) {
                var total = totals[i];
                var h     = Math.round((total / maxAmt) * 160);
                var pct   = Math.round(total / maxAmt * 100);
                var color = pct >= 90 ? "#2e5c38" : pct >= 70 ? "#4d7a58" : "#8aab94";
                return '<div style="display:flex; flex-direction:column; align-items:center; gap:4px; flex:1;">'
                    + '<div style="font-size:10px; color:var(--text-secondary); font-weight:700;">₩' + Math.round(total/1000) + 'K</div>'
                    + '<div style="width:100%; background:' + color + '; border-radius:6px 6px 0 0; height:' + h + 'px; transition:0.3s;"></div>'
                    + '</div>';
            }).join("");

            document.getElementById("barLabels").innerHTML = months.map(function(m) {
                return '<div style="flex:1; text-align:center; font-size:11px; color:var(--text-tertiary);">' + m + '</div>';
            }).join("");

            var keys = ["elec","water","gas","common"];
            document.getElementById("itemSummary").innerHTML = keys.map(function(k) {
                var total = amounts.reduce(function(s,a){ return s + a[k]; }, 0);
                return '<div style="background:#f7f8f9; border-radius:8px; padding:10px 12px;">'
                    + '<div style="display:flex; align-items:center; gap:6px; margin-bottom:4px;">'
                    + '<div style="width:8px; height:8px; border-radius:50%; background:' + ITEM_COLOR[k] + ';"></div>'
                    + '<span style="font-size:11px; color:var(--text-secondary);">' + ITEM_LABEL[k] + '</span>'
                    + '</div>'
                    + '<div style="font-size:15px; font-weight:800;">₩' + total.toLocaleString() + '</div>'
                    + '<div style="font-size:10px; color:var(--text-tertiary); margin-top:2px;">6개월 합산</div>'
                    + '</div>';
            }).join("");
        }

        /* ── 리스트 렌더 ── */
        function renderList() {
            document.getElementById("listViewBody").innerHTML = months.map(function(m, i) {
                var a = amounts[i];
                var total = a.elec + a.water + a.gas + a.common;
                return '<tr>'
                    + '<td class="td-bold">2026년 ' + m + '</td>'
                    + '<td style="text-align:right;">₩' + a.elec.toLocaleString() + '</td>'
                    + '<td style="text-align:right;">₩' + a.water.toLocaleString() + '</td>'
                    + '<td style="text-align:right;">₩' + a.gas.toLocaleString() + '</td>'
                    + '<td style="text-align:right;">₩' + a.common.toLocaleString() + '</td>'
                    + '<td style="text-align:right; font-weight:800;">₩' + total.toLocaleString() + '</td>'
                    + '</tr>';
            }).join("");
        }

        /* ── 뷰 전환 ── */
        function setView(view) {
            currentView = view;
            page.querySelectorAll(".chart-view-btn").forEach(function(btn) {
                var active = btn.dataset.view === view;
                btn.style.background  = active ? "#2e5c38" : "var(--card)";
                btn.style.color       = active ? "#fff"    : "var(--text-secondary)";
                btn.style.borderColor = active ? "#2e5c38" : "var(--border)";
            });
            document.getElementById("chartView").style.display = view === "chart" ? "block" : "none";
            document.getElementById("listView").style.display  = view === "list"  ? "block" : "none";
            if (view === "list") renderList();
        }

        /* ── 이벤트 ── */
        page.addEventListener("click", function(e) {
            var viewBtn = e.target.closest(".chart-view-btn");
            if (viewBtn) { setView(viewBtn.dataset.view); return; }
        });

        document.getElementById("btnSearchChart").addEventListener("click", function() {
            var base   = document.getElementById("filterBase").value;
            var item   = document.getElementById("filterItem").value;
            var period = document.getElementById("filterPeriod").value;
            document.getElementById("chartLabel").textContent =
                (base === "item" ? "항목별" : "납부월별") + " · " +
                (item === "ALL" ? "전체 항목" : item) +
                " · 최근 " + period + "개월";
            if (currentView === "chart") renderChart();
            else renderList();
        });

        initStats();
        renderChart();
    })();
</script>
