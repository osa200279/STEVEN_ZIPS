<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="billIssuePage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>관리비 부과·연체</h2>
            <p>세대별 관리비 부과 내역 조회 및 연체 처리 — BILL 기반</p>
        </div>
        <div class="page-actions">
            <button type="button" class="btn btn-secondary" id="btnExcel">
                <span class="material-symbols-rounded">download</span>
                엑셀 다운로드
            </button>
        </div>
    </div>

    <!-- 업무 순서 스텝바 -->
    <div style="display:flex; align-items:center; gap:8px; margin-bottom:20px; padding:14px 20px; background:var(--card); border:1px solid var(--border); border-radius:var(--r-lg);">
        <div style="display:flex; align-items:center; gap:6px;">
            <div style="width:24px; height:24px; border-radius:50%; background:#e8eaed; color:var(--text-secondary); font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">1</div>
            <span style="font-size:12px; font-weight:600; color:var(--text-secondary);">고지서 등록</span>
        </div>
        <span style="color:var(--text-tertiary);">→</span>
        <div style="display:flex; align-items:center; gap:6px;">
            <div style="width:24px; height:24px; border-radius:50%; background:#2e5c38; color:#fff; font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">2</div>
            <span style="font-size:12px; font-weight:700; color:#2e5c38;">부과 내역 조회</span>
        </div>
        <span style="color:var(--text-tertiary);">→</span>
        <div style="display:flex; align-items:center; gap:6px;">
            <div style="width:24px; height:24px; border-radius:50%; background:#e8eaed; color:var(--text-secondary); font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">3</div>
            <span style="font-size:12px; font-weight:600; color:var(--text-secondary);">연체 처리 (LATE_FEE_AMT)</span>
        </div>
        <span style="color:var(--text-tertiary);">→</span>
        <div style="display:flex; align-items:center; gap:6px;">
            <div style="width:24px; height:24px; border-radius:50%; background:#e8eaed; color:var(--text-secondary); font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">4</div>
            <span style="font-size:12px; font-weight:600; color:var(--text-secondary);">납부 확인 (PAYMENT)</span>
        </div>
    </div>

    <!-- 메인 레이아웃: 목록 + 우측 패널 -->
    <div style="display:grid; grid-template-columns:1fr 260px; gap:16px;">

        <!-- 좌: 필터 + 목록 -->
        <div style="display:flex; flex-direction:column; gap:12px;">

            <!-- 필터 -->
            <div class="panel" style="padding:14px 16px;">
                <div style="display:flex; gap:10px; flex-wrap:wrap; align-items:flex-end;">
                    <div class="form-field" style="gap:4px;">
                        <label class="field-label">부과월 (BILL_YM)</label>
                        <select class="form-select" id="filterYm" style="width:140px;">
                            <option value="202604">2026년 4월분</option>
                            <option value="202603">2026년 3월분</option>
                            <option value="202602">2026년 2월분</option>
                        </select>
                    </div>
                    <div class="form-field" style="gap:4px;">
                        <label class="field-label">납부 상태 (PYMT_STTS_CD)</label>
                        <select class="form-select" id="filterStts" style="width:130px;">
                            <option value="">전체</option>
                            <option value="PAID">완납</option>
                            <option value="UNPAID">미납</option>
                            <option value="OVERDUE">장기연체</option>
                        </select>
                    </div>
                    <div class="form-field" style="gap:4px;">
                        <label class="field-label">동/호수 (HO_NO)</label>
                        <input type="text" class="form-input" id="filterKeyword" style="width:160px;" placeholder="예: 101동 / 1204호">
                    </div>
                    <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
                </div>
            </div>

            <!-- 목록 -->
            <div class="panel" style="padding:0; overflow:hidden;">
                <div style="display:flex; align-items:center; justify-content:space-between; padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
                    <span style="font-size:13px; font-weight:700;">세대별 부과 현황</span>
                    <span class="list-count" id="billListCount">0건</span>
                </div>

                <div class="table-wrap">
                    <table class="tbl">
                        <thead>
                        <tr>
                            <th>호번호 (HO_NO)</th>
                            <th>부과월</th>
                            <th style="text-align:right;">부과 총액</th>
                            <th style="text-align:right;">미납 금액</th>
                            <th style="text-align:right;">연체료 (3%)</th>
                            <th>납부상태</th>
                            <th style="width:140px;">처리</th>
                        </tr>
                        </thead>
                        <tbody id="billTableBody"></tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 우: 현황 패널 -->
        <div style="display:flex; flex-direction:column; gap:12px;">

            <div class="panel" style="padding:0; overflow:hidden;">
                <div style="padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
                    <span style="font-size:13px; font-weight:700;">이달 현황</span>
                </div>
                <div style="padding:14px 16px; display:flex; flex-direction:column; gap:12px;">
                    <div>
                        <div style="font-size:11px; color:var(--text-tertiary); margin-bottom:3px;">총 부과 세대</div>
                        <div style="font-size:22px; font-weight:800;" id="rTotal">0세대</div>
                    </div>
                    <div style="height:1px; background:var(--border);"></div>
                    <div>
                        <div style="font-size:11px; color:#d97706; margin-bottom:3px;">미납 세대</div>
                        <div style="font-size:22px; font-weight:800; color:#d97706;" id="rUnpaid">0세대</div>
                    </div>
                    <div style="height:1px; background:var(--border);"></div>
                    <div>
                        <div style="font-size:11px; color:#92400e; margin-bottom:3px;">장기연체 세대</div>
                        <div style="font-size:22px; font-weight:800; color:#92400e;" id="rOverdue">0세대</div>
                    </div>
                </div>
            </div>

            <div class="panel" style="padding:0; overflow:hidden;">
                <div style="padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
                    <span style="font-size:13px; font-weight:700;">필터 바로가기</span>
                </div>
                <div style="padding:10px 12px; display:flex; flex-direction:column; gap:6px;">
                    <button type="button" class="btn btn-secondary" style="width:100%; justify-content:flex-start; font-size:12px;" id="btnShowOverdue">
                        <span style="width:8px; height:8px; border-radius:50%; background:#92400e; display:inline-block; margin-right:6px;"></span>
                        장기연체 세대만 보기
                    </button>
                    <button type="button" class="btn btn-secondary" style="width:100%; justify-content:flex-start; font-size:12px;" id="btnShowUnpaid">
                        <span style="width:8px; height:8px; border-radius:50%; background:#d97706; display:inline-block; margin-right:6px;"></span>
                        미납 세대만 보기
                    </button>
                    <button type="button" class="btn btn-secondary" style="width:100%; justify-content:flex-start; font-size:12px;" id="btnShowAll">
                        전체 보기
                    </button>
                </div>
            </div>

        </div>
    </div>

    <!-- 상세 슬라이드오버 -->
    <div id="detailPanel" style="display:none; position:fixed; top:0; right:0; width:380px; height:100vh; background:var(--card); box-shadow:-4px 0 24px rgba(0,0,0,0.13); z-index:500; overflow-y:auto;">
        <div style="padding:20px;">
            <div style="display:flex; align-items:flex-start; justify-content:space-between; margin-bottom:16px;">
                <div>
                    <div style="font-size:18px; font-weight:900;" id="detailHoNo">—</div>
                    <div style="font-size:12px; color:var(--text-tertiary); margin-top:2px;" id="detailBillNo">BILL_NO: —</div>
                </div>
                <button type="button" id="btnCloseDetail" style="border:none; background:#e8eaed; border-radius:6px; width:28px; height:28px; cursor:pointer; font-size:18px; color:var(--text-secondary); display:flex; align-items:center; justify-content:center;">×</button>
            </div>

            <!-- 기본 정보 -->
            <div style="background:#f7f8f9; border-radius:10px; padding:14px; margin-bottom:12px;">
                <div style="font-size:11px; font-weight:700; color:var(--text-tertiary); margin-bottom:10px;">기본 정보 (BILL)</div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                    <div><div style="font-size:10px; color:var(--text-tertiary);">부과월</div><div style="font-size:13px; font-weight:700;" id="detailYm">—</div></div>
                    <div><div style="font-size:10px; color:var(--text-tertiary);">상태</div><div id="detailStts">—</div></div>
                    <div><div style="font-size:10px; color:var(--text-tertiary);">부과 총액 (BILL_TOT_AMT)</div><div style="font-size:13px; font-weight:700;" id="detailAmt">—</div></div>
                    <div><div style="font-size:10px; color:var(--text-tertiary);">납부기한 (DUE_DT)</div><div style="font-size:13px; font-weight:700;" id="detailDueDt">—</div></div>
                    <div><div style="font-size:10px; color:var(--text-tertiary);">실납부액 (PYMT_AMT)</div><div style="font-size:13px; font-weight:700;" id="detailPymtAmt">—</div></div>
                    <div><div style="font-size:10px; color:var(--text-tertiary);">납부일 (PYMT_DT)</div><div style="font-size:13px; font-weight:700;" id="detailPymtDt">—</div></div>
                </div>
            </div>

            <!-- 연체 정보 -->
            <div style="background:#fef9f0; border:1px solid #fde68a; border-radius:10px; padding:14px; margin-bottom:12px;" id="detailOverdueBox">
                <div style="font-size:11px; font-weight:700; color:#92400e; margin-bottom:10px;">연체 정보 (BILL)</div>
                <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
                    <div><div style="font-size:10px; color:#92400e;">연체요율 (LATE_FEE_RT)</div><div style="font-size:13px; font-weight:700;" id="detailFeeRt">3%</div></div>
                    <div><div style="font-size:10px; color:#92400e;">연체료 (LATE_FEE_AMT)</div><div style="font-size:13px; font-weight:700; color:#dc2626;" id="detailLateFee">—</div></div>
                </div>
            </div>

            <!-- 항목별 내역 -->
            <div style="margin-bottom:12px;">
                <div style="font-size:11px; font-weight:700; color:var(--text-tertiary); margin-bottom:8px;">항목별 내역 (BILL_DETAIL)</div>
                <div id="detailItems" style="display:flex; flex-direction:column; gap:4px;"></div>
            </div>

            <!-- 납부 이력 -->
            <div style="margin-bottom:16px;">
                <div style="font-size:11px; font-weight:700; color:var(--text-tertiary); margin-bottom:8px;">납부 이력 (PAYMENT)</div>
                <div id="detailPayments" style="display:flex; flex-direction:column; gap:4px;"></div>
            </div>

            <!-- 액션 버튼 -->
            <div style="display:flex; flex-direction:column; gap:8px;">
                <button type="button" class="btn btn-primary" style="width:100%; background:#2e5c38;" id="btnOverdueProcess">
                    연체 처리 (PYMT_STTS_CD → OVERDUE)
                </button>
                <button type="button" class="btn btn-secondary" style="width:100%;" id="btnPaidProcess">
                    납부 완료 처리 (PYMT_STTS_CD → PAID)
                </button>
            </div>
        </div>
    </div>
    <div id="detailOverlay" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.3); z-index:499;"></div>

</div>

<script>
    (function() {
        var page = document.getElementById("billIssuePage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        var currentDetailIdx = null;

        /* ── 더미 데이터 (BILL 기반)
           세대주명은 HO_NO → HSHLD_HEAD 조인으로 가져옴 (백엔드 처리)
        ── */
        var rowData = [
            { billNo:"B001", hoNo:"101동 402호", billYm:"202604", billTotAmt:285000, dueDt:"2026-04-25",
                pymtSttsCd:"PAID",    pymtAmt:285000, pymtDt:"2026-04-20", lateFeeRt:0.03, lateFeeAmt:0,
                details:[ {cd:"ELEC",nm:"전기요금",amt:95000}, {cd:"WATER",nm:"수도요금",amt:45000}, {cd:"COMMON",nm:"공용관리비",amt:145000} ],
                payments:[ {payNo:"P001", payAmt:285000, paySttsCd:"PAID", payCmplDt:"2026-04-20", payMthdCd:"CARD"} ] },
            { billNo:"B002", hoNo:"104동 1205호", billYm:"202604", billTotAmt:312000, dueDt:"2026-04-25",
                pymtSttsCd:"UNPAID",  pymtAmt:0,      pymtDt:"",           lateFeeRt:0.03, lateFeeAmt:0,
                details:[ {cd:"ELEC",nm:"전기요금",amt:112000}, {cd:"WATER",nm:"수도요금",amt:55000}, {cd:"COMMON",nm:"공용관리비",amt:145000} ],
                payments:[] },
            { billNo:"B003", hoNo:"102동 701호",  billYm:"202604", billTotAmt:245500, dueDt:"2026-04-25",
                pymtSttsCd:"OVERDUE", pymtAmt:0,      pymtDt:"",           lateFeeRt:0.03, lateFeeAmt:7365,
                details:[ {cd:"ELEC",nm:"전기요금",amt:85500}, {cd:"WATER",nm:"수도요금",amt:35000}, {cd:"COMMON",nm:"공용관리비",amt:125000} ],
                payments:[] },
            { billNo:"B004", hoNo:"103동 1103호", billYm:"202604", billTotAmt:298000, dueDt:"2026-04-25",
                pymtSttsCd:"PAID",    pymtAmt:298000, pymtDt:"2026-04-18", lateFeeRt:0.03, lateFeeAmt:0,
                details:[ {cd:"ELEC",nm:"전기요금",amt:98000}, {cd:"WATER",nm:"수도요금",amt:55000}, {cd:"COMMON",nm:"공용관리비",amt:145000} ],
                payments:[ {payNo:"P002", payAmt:298000, paySttsCd:"PAID", payCmplDt:"2026-04-18", payMthdCd:"TRANSFER"} ] },
        ];

        var STTS_STYLE = {
            PAID:    { text:"완납",   bg:"#dcfce7", color:"#166534" },
            UNPAID:  { text:"미납",   bg:"#fff0e0", color:"#92400e" },
            OVERDUE: { text:"장기연체", bg:"#f5e8d0", color:"#6b3d0a" }
        };

        /* ── 통계 ── */
        function updateStats(data) {
            document.getElementById("rTotal").textContent   = data.length + "세대";
            document.getElementById("rUnpaid").textContent  = data.filter(function(r){ return r.pymtSttsCd === "UNPAID"; }).length + "세대";
            document.getElementById("rOverdue").textContent = data.filter(function(r){ return r.pymtSttsCd === "OVERDUE"; }).length + "세대";
        }

        /* ── 목록 렌더 ── */
        function renderTable(data) {
            document.getElementById("billListCount").textContent = data.length + "건";
            updateStats(data);

            var tbody = document.getElementById("billTableBody");
            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; padding:20px; color:var(--text-tertiary);">부과 내역이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = data.map(function(row) {
                var realIdx = rowData.indexOf(row);
                var s = STTS_STYLE[row.pymtSttsCd] || { text:"-", bg:"#f3f4f6", color:"#4b5563" };
                var badge = '<span style="display:inline-flex; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; background:' + s.bg + '; color:' + s.color + ';">' + s.text + '</span>';

                var actionBtns = '<button type="button" class="btn btn-xs btn-detail" data-action="openDetail" data-idx="' + realIdx + '">상세</button>';
                if (row.pymtSttsCd === "UNPAID") {
                    actionBtns += ' <button type="button" class="btn btn-xs" style="background:#2e5c38; color:#fff; border-color:#2e5c38;" data-action="quickOverdue" data-idx="' + realIdx + '">연체처리</button>';
                }
                if (row.pymtSttsCd !== "PAID") {
                    actionBtns += ' <button type="button" class="btn btn-xs" data-action="quickPaid" data-idx="' + realIdx + '">납부처리</button>';
                }

                return '<tr>'
                    + '<td class="td-bold">' + row.hoNo + '</td>'
                    + '<td>' + row.billYm.slice(0,4) + "." + row.billYm.slice(4) + '</td>'
                    + '<td style="text-align:right; font-weight:700;">₩' + row.billTotAmt.toLocaleString() + '</td>'
                    + '<td style="text-align:right; color:' + (row.pymtSttsCd !== "PAID" ? "#dc2626" : "var(--text-tertiary)") + '; font-weight:700;">'
                    + (row.pymtSttsCd !== "PAID" ? "₩" + row.billTotAmt.toLocaleString() : "-") + '</td>'
                    + '<td style="text-align:right; color:#d97706; font-weight:700;">'
                    + (row.lateFeeAmt > 0 ? "₩" + row.lateFeeAmt.toLocaleString() : "-") + '</td>'
                    + '<td>' + badge + '</td>'
                    + '<td><div class="grid-actions">' + actionBtns + '</div></td>'
                    + '</tr>';
            }).join("");
        }

        /* ── 필터 ── */
        function getFiltered(sttsFix) {
            var stts    = sttsFix !== undefined ? sttsFix : document.getElementById("filterStts").value;
            var keyword = document.getElementById("filterKeyword").value.trim();
            return rowData.filter(function(r) {
                return (!stts    || r.pymtSttsCd === stts)
                    && (!keyword || r.hoNo.indexOf(keyword) > -1);
            });
        }

        /* ── 상세 패널 ── */
        function openDetail(idx) {
            currentDetailIdx = idx;
            var row = rowData[idx];
            var s   = STTS_STYLE[row.pymtSttsCd] || { text:"-", bg:"#f3f4f6", color:"#4b5563" };

            document.getElementById("detailHoNo").textContent   = row.hoNo;
            document.getElementById("detailBillNo").textContent = "BILL_NO: " + row.billNo;
            document.getElementById("detailYm").textContent     = row.billYm.slice(0,4) + "년 " + row.billYm.slice(4) + "월";
            document.getElementById("detailAmt").textContent    = "₩" + row.billTotAmt.toLocaleString();
            document.getElementById("detailDueDt").textContent  = row.dueDt || "-";
            document.getElementById("detailPymtAmt").textContent = row.pymtAmt > 0 ? "₩" + row.pymtAmt.toLocaleString() : "-";
            document.getElementById("detailPymtDt").textContent  = row.pymtDt || "-";
            document.getElementById("detailFeeRt").textContent   = (row.lateFeeRt * 100).toFixed(0) + "%";
            document.getElementById("detailLateFee").textContent = row.lateFeeAmt > 0 ? "₩" + row.lateFeeAmt.toLocaleString() : "-";
            document.getElementById("detailStts").innerHTML = '<span style="display:inline-flex; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; background:' + s.bg + '; color:' + s.color + ';">' + s.text + '</span>';

            document.getElementById("detailOverdueBox").style.display = row.pymtSttsCd !== "PAID" ? "block" : "none";

            /* 항목별 내역 */
            document.getElementById("detailItems").innerHTML = (row.details || []).map(function(d) {
                return '<div style="display:flex; justify-content:space-between; padding:6px 10px; background:#f7f8f9; border-radius:6px; font-size:12px;">'
                    + '<span style="color:var(--text-secondary);">' + d.nm + ' <span style="color:var(--text-tertiary); font-size:10px;">(' + d.cd + ')</span></span>'
                    + '<span style="font-weight:700;">₩' + d.amt.toLocaleString() + '</span>'
                    + '</div>';
            }).join("") || '<div style="font-size:12px; color:var(--text-tertiary); padding:8px 0;">항목 내역 없음</div>';

            /* 납부 이력 */
            document.getElementById("detailPayments").innerHTML = (row.payments || []).map(function(p) {
                return '<div style="padding:8px 10px; background:#f0f7f2; border-radius:6px; font-size:12px;">'
                    + '<div style="font-weight:700; color:#2e5c38;">₩' + p.payAmt.toLocaleString() + ' · ' + p.payMthdCd + '</div>'
                    + '<div style="color:var(--text-tertiary); font-size:11px; margin-top:2px;">' + p.payCmplDt + '</div>'
                    + '</div>';
            }).join("") || '<div style="font-size:12px; color:var(--text-tertiary); padding:8px 0;">납부 이력 없음</div>';

            /* 버튼 표시 제어 */
            document.getElementById("btnOverdueProcess").style.display = row.pymtSttsCd === "UNPAID"  ? "flex" : "none";
            document.getElementById("btnPaidProcess").style.display    = row.pymtSttsCd !== "PAID"    ? "flex" : "none";

            document.getElementById("detailPanel").style.display   = "block";
            document.getElementById("detailOverlay").style.display = "block";
        }

        function closeDetail() {
            document.getElementById("detailPanel").style.display   = "none";
            document.getElementById("detailOverlay").style.display = "none";
            currentDetailIdx = null;
        }

        /* ── 이벤트 ── */
        document.getElementById("btnSearch").addEventListener("click", function() {
            renderTable(getFiltered());
        });

        document.getElementById("btnShowOverdue").addEventListener("click", function() {
            document.getElementById("filterStts").value = "OVERDUE";
            renderTable(getFiltered("OVERDUE"));
        });

        document.getElementById("btnShowUnpaid").addEventListener("click", function() {
            document.getElementById("filterStts").value = "UNPAID";
            renderTable(getFiltered("UNPAID"));
        });

        document.getElementById("btnShowAll").addEventListener("click", function() {
            document.getElementById("filterStts").value = "";
            renderTable(rowData);
        });

        document.getElementById("btnCloseDetail").addEventListener("click", closeDetail);
        document.getElementById("detailOverlay").addEventListener("click", closeDetail);

        document.getElementById("btnOverdueProcess").addEventListener("click", function() {
            if (currentDetailIdx === null) return;
            var row = rowData[currentDetailIdx];
            row.pymtSttsCd = "OVERDUE";
            row.lateFeeAmt = Math.round(row.billTotAmt * row.lateFeeRt);
            alert("연체 처리 완료: PYMT_STTS_CD = OVERDUE, LATE_FEE_AMT = ₩" + row.lateFeeAmt.toLocaleString());
            closeDetail();
            renderTable(getFiltered());
        });

        document.getElementById("btnPaidProcess").addEventListener("click", function() {
            if (currentDetailIdx === null) return;
            var row = rowData[currentDetailIdx];
            row.pymtSttsCd = "PAID";
            row.pymtAmt    = row.billTotAmt + row.lateFeeAmt;
            row.pymtDt     = new Date().toISOString().slice(0,10);
            alert("납부 완료 처리 연결 예정입니다.");
            closeDetail();
            renderTable(getFiltered());
        });

        /* 테이블 버튼 위임 */
        document.getElementById("billTableBody").addEventListener("click", function(e) {
            var btn = e.target.closest("[data-action]");
            if (!btn) return;
            var idx = Number(btn.dataset.idx);
            if (btn.dataset.action === "openDetail")   openDetail(idx);
            if (btn.dataset.action === "quickOverdue") {
                rowData[idx].pymtSttsCd = "OVERDUE";
                rowData[idx].lateFeeAmt = Math.round(rowData[idx].billTotAmt * rowData[idx].lateFeeRt);
                renderTable(getFiltered());
            }
            if (btn.dataset.action === "quickPaid") {
                rowData[idx].pymtSttsCd = "PAID";
                rowData[idx].pymtAmt    = rowData[idx].billTotAmt + rowData[idx].lateFeeAmt;
                rowData[idx].pymtDt     = new Date().toISOString().slice(0,10);
                renderTable(getFiltered());
            }
        });

        renderTable(rowData);
    })();
</script>
