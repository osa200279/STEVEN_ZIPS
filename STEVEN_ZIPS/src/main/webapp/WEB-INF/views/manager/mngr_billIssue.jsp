<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리비 부과·연체</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">

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
                <div style="display:flex; align-items:center; gap:6px; margin-bottom:20px; padding:14px 20px; background:var(--card); border:1px solid var(--border); border-radius:var(--r-lg); flex-wrap:wrap;">
                    <div style="display:flex; align-items:center; gap:6px;">
                        <div style="width:26px; height:26px; border-radius:50%; background:#e8eaed; color:var(--text-secondary); font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">1</div>
                        <span style="font-size:12px; font-weight:600; color:var(--text-secondary);">고지서 등록</span>
                    </div>
                    <span style="color:var(--text-tertiary);">→</span>
                    <div style="display:flex; align-items:center; gap:6px;">
                        <div style="width:26px; height:26px; border-radius:50%; background:#2e5c38; color:#fff; font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">2</div>
                        <span style="font-size:12px; font-weight:700; color:#2e5c38;">부과 내역 조회</span>
                    </div>
                    <span style="color:var(--text-tertiary);">→</span>
                    <div style="display:flex; align-items:center; gap:6px;">
                        <div style="width:26px; height:26px; border-radius:50%; background:#e8eaed; color:var(--text-secondary); font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">3</div>
                        <span style="font-size:12px; font-weight:600; color:var(--text-secondary);">연체 처리</span>
                    </div>
                    <span style="color:var(--text-tertiary);">→</span>
                    <div style="display:flex; align-items:center; gap:6px;">
                        <div style="width:26px; height:26px; border-radius:50%; background:#e8eaed; color:var(--text-secondary); font-size:11px; font-weight:800; display:flex; align-items:center; justify-content:center;">4</div>
                        <span style="font-size:12px; font-weight:600; color:var(--text-secondary);">납부 확인 (PAYMENT)</span>
                    </div>
                </div>

                <!-- 메인 레이아웃: 목록 + 우측 패널 -->
                <div style="display:grid; grid-template-columns:1fr 260px; gap:16px;">

                    <!-- 좌: 필터 + 목록 -->
                    <div style="display:flex; flex-direction:column; gap:12px;">

                        <!-- 필터 -->
                        <div class="panel" style="padding:16px 20px;">
                            <div style="display:flex; gap:12px; flex-wrap:wrap; align-items:flex-end;">
                                <div class="form-field" style="gap:4px;">
                                    <label class="field-label">부과월 (BILL_YM)</label>
                                    <select class="form-select" id="filterYm" style="width:150px;">
                                        <option value="202604">2026년 4월분</option>
                                        <option value="202603">2026년 3월분</option>
                                        <option value="202602">2026년 2월분</option>
                                    </select>
                                </div>
                                <div class="form-field" style="gap:4px;">
                                    <label class="field-label">납부 상태 (PYMT_STTS_CD)</label>
                                    <select class="form-select" id="filterStts" style="width:140px;">
                                        <option value="">전체</option>
                                        <option value="PAID">완납</option>
                                        <option value="UNPAID">미납</option>
                                        <option value="OVERDUE">장기연체</option>
                                    </select>
                                </div>
                                <div class="form-field" style="gap:4px;">
                                    <label class="field-label">동/호수 (HO_NO)</label>
                                    <input type="text" class="form-input" id="filterKeyword" style="width:180px;" placeholder="예: 101동 / 1204호">
                                </div>
                                <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
                            </div>
                        </div>

                        <!-- 목록 -->
                        <div class="panel" style="padding:0; overflow:hidden;">
                            <div style="display:flex; align-items:center; justify-content:space-between; padding:12px 20px; border-bottom:1px solid var(--border); background:#f7f8f9;">
                                <div>
                                    <span style="font-size:13px; font-weight:700;">세대별 부과 현황</span>
                                    <span style="font-size:11px; color:var(--text-tertiary); margin-left:8px;">상세, 연체 처리, 고지서 생성을 선택하세요.</span>
                                </div>
                                <div style="display:flex; align-items:center; gap:10px;">
                                    <button type="button" class="btn btn-secondary btn-sm" id="btnExcelDown">엑셀 다운로드</button>
                                    <span class="list-count" id="billListCount">0건</span>
                                </div>
                            </div>

                            <div class="table-wrap">
                                <table class="tbl tbl-fixed">
                                    <colgroup>
                                        <col style="width:18%;">
                                        <col style="width:10%;">
                                        <col style="width:9%;">
                                        <col style="width:14%;">
                                        <col style="width:14%;">
                                        <col style="width:10%;">
                                        <col style="width:9%;">
                                        <col style="width:5.33%;">
                                        <col style="width:5.33%;">
                                        <col style="width:5.34%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>동/호수 (HO_NO)</th>
                                        <th>세대주</th>
                                        <th>부과월</th>
                                        <th style="text-align:right;">부과 금액</th>
                                        <th style="text-align:right;">미납 금액</th>
                                        <th style="text-align:right;">연체료</th>
                                        <th>상태</th>
                                        <th style="width:52px; text-align:center;">상세</th><th style="width:52px; text-align:center;">납부</th><th style="width:52px; text-align:center;">연체</th>
                                    </tr>
                                    </thead>
                                    <tbody id="billTableBody"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- 우: 현황 패널 -->
                    <div style="display:flex; flex-direction:column; gap:12px;">

                        <!-- 이달 현황 -->
                        <div class="panel" style="padding:0; overflow:hidden;">
                            <div style="padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
                                <span style="font-size:13px; font-weight:700;">이달 현황</span>
                            </div>
                            <div style="padding:16px; display:flex; flex-direction:column; gap:14px;">
                                <div>
                                    <div style="font-size:11px; color:var(--text-tertiary); margin-bottom:4px;">총 부과 세대</div>
                                    <div style="font-size:24px; font-weight:900;" id="rTotal">0세대</div>
                                </div>
                                <div style="height:1px; background:var(--border);"></div>
                                <div>
                                    <div style="font-size:11px; color:#d97706; margin-bottom:4px;">미납 세대</div>
                                    <div style="font-size:24px; font-weight:900; color:#d97706;" id="rUnpaid">0세대</div>
                                </div>
                                <div style="height:1px; background:var(--border);"></div>
                                <div>
                                    <div style="font-size:11px; color:#92400e; margin-bottom:4px;">장기연체 세대</div>
                                    <div style="font-size:24px; font-weight:900; color:#92400e;" id="rOverdue">0세대</div>
                                </div>
                            </div>
                        </div>

                        <!-- 바로 처리 -->
                        <div class="panel" style="padding:0; overflow:hidden;">
                            <div style="padding:12px 16px; border-bottom:1px solid var(--border); background:#f7f8f9;">
                                <span style="font-size:13px; font-weight:700;">바로 처리</span>
                            </div>
                            <div style="padding:12px; display:flex; flex-direction:column; gap:8px;">
                                <button type="button" class="btn btn-primary" style="width:100%; background:#2e5c38; justify-content:center;" id="btnShowOverdue">
                                    연체 세대만 보기
                                </button>
                                <button type="button" class="btn btn-secondary" style="width:100%; justify-content:center;" id="btnShowUnpaid">
                                    미납 세대만 보기
                                </button>
                                <button type="button" class="btn btn-secondary" style="width:100%; justify-content:center;" id="btnShowAll">
                                    전체 보기
                                </button>
                            </div>
                        </div>

                    </div>
                </div>

                <!-- ── 상세 모달 ── -->
                <div class="modal-overlay" id="billDetailModal">
                    <div class="modal" style="max-width:540px;">
                        <div class="modal-header primary">
                            <div>
                                <h3 class="modal-title" id="modalHoNo">—</h3>
                                <div style="font-size:11px; color:var(--text-secondary); margin-top:2px;" id="modalBillNo">BILL_NO: —</div>
                            </div>
                            <button type="button" class="modal-close" id="btnCloseModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <div class="modal-body" style="padding:20px; display:flex; flex-direction:column; gap:14px;">

                            <!-- 기본 정보 (BILL) -->
                            <div style="background:#f7f8f9; border-radius:10px; padding:14px;">
                                <div style="font-size:11px; font-weight:700; color:var(--text-tertiary); margin-bottom:12px; text-transform:uppercase; letter-spacing:0.05em;">기본 정보 (BILL)</div>
                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                                    <div>
                                        <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">부과월 (BILL_YM)</div>
                                        <div style="font-size:13px; font-weight:700;" id="modalYm">—</div>
                                    </div>
                                    <div>
                                        <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">납부 상태 (PYMT_STTS_CD)</div>
                                        <div id="modalStts">—</div>
                                    </div>
                                    <div>
                                        <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">부과 총액 (BILL_TOT_AMT)</div>
                                        <div style="font-size:13px; font-weight:700;" id="modalAmt">—</div>
                                    </div>
                                    <div>
                                        <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">납부기한 (DUE_DT)</div>
                                        <div style="font-size:13px; font-weight:700;" id="modalDueDt">—</div>
                                    </div>
                                    <div>
                                        <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">실납부액 (PYMT_AMT)</div>
                                        <div style="font-size:13px; font-weight:700;" id="modalPymtAmt">—</div>
                                    </div>
                                    <div>
                                        <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">납부일 (PYMT_DT)</div>
                                        <div style="font-size:13px; font-weight:700;" id="modalPymtDt">—</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 연체 정보 (BILL) -->
                            <div style="background:#fef9f0; border:1px solid #fde68a; border-radius:10px; padding:14px;" id="modalOverdueBox">
                                <div style="font-size:11px; font-weight:700; color:#92400e; margin-bottom:12px; text-transform:uppercase; letter-spacing:0.05em;">연체 정보 (BILL)</div>
                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
                                    <div>
                                        <div style="font-size:10px; color:#92400e; margin-bottom:3px;">연체요율 (LATE_FEE_RT)</div>
                                        <div style="font-size:13px; font-weight:700;" id="modalFeeRt">3%</div>
                                    </div>
                                    <div>
                                        <div style="font-size:10px; color:#92400e; margin-bottom:3px;">연체료 (LATE_FEE_AMT)</div>
                                        <div style="font-size:15px; font-weight:900; color:#dc2626;" id="modalLateFee">—</div>
                                    </div>
                                </div>
                            </div>

                            <!-- 항목별 내역 (BILL_DETAIL) -->
                            <div>
                                <div style="font-size:11px; font-weight:700; color:var(--text-tertiary); margin-bottom:8px; text-transform:uppercase; letter-spacing:0.05em;">항목별 내역 (BILL_DETAIL)</div>
                                <div id="modalItems" style="display:flex; flex-direction:column; gap:4px;"></div>
                            </div>

                            <!-- 납부 이력 (PAYMENT) -->
                            <div>
                                <div style="font-size:11px; font-weight:700; color:var(--text-tertiary); margin-bottom:8px; text-transform:uppercase; letter-spacing:0.05em;">납부 이력 (PAYMENT)</div>
                                <div id="modalPayments" style="display:flex; flex-direction:column; gap:6px;"></div>
                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" id="btnCloseModal2">닫기</button>
                            <button type="button" class="btn btn-primary" style="background:#2e5c38;" id="btnOverdueProcess">
                                연체 처리
                            </button>
                            <button type="button" class="btn btn-primary" id="btnPaidProcess">
                                납부 완료 처리
                            </button>
                        </div>
                    </div>
                </div>

            </div>

            <script>
                document.addEventListener("DOMContentLoaded", function () {

                    var currentDetailIdx = null;

                    /* ── 더미 데이터 (BILL 기반)
                       세대주명: HO_NO → HSHLD_HEAD 조인 (백엔드 처리)
                       최근이력: ERD에 없음 → 제거
                    ── */
                    var rowData = [
                        { billNo:"B001", hoNo:"101동 402호",  ownerNm:"김철수", billYm:"202604", billTotAmt:285000, dueDt:"2026-04-25",
                            pymtSttsCd:"PAID",    pymtAmt:285000, pymtDt:"2026-04-20", lateFeeRt:0.03, lateFeeAmt:0,
                            details:[  {cd:"ELEC",  nm:"전기요금",   amt:95000},
                                {cd:"WATER", nm:"수도요금",   amt:45000},
                                {cd:"COMMON",nm:"공용관리비", amt:145000} ],
                            payments:[ {payNo:"P001", payAmt:285000, paySttsCd:"PAID", payCmplDt:"2026-04-20", payMthdCd:"CARD"} ] },

                        { billNo:"B002", hoNo:"104동 1205호", ownerNm:"이영희", billYm:"202604", billTotAmt:312000, dueDt:"2026-04-25",
                            pymtSttsCd:"UNPAID",  pymtAmt:0, pymtDt:"", lateFeeRt:0.03, lateFeeAmt:0,
                            details:[  {cd:"ELEC",  nm:"전기요금",   amt:112000},
                                {cd:"WATER", nm:"수도요금",   amt:55000},
                                {cd:"COMMON",nm:"공용관리비", amt:145000} ],
                            payments:[] },

                        { billNo:"B003", hoNo:"102동 701호",  ownerNm:"박지민", billYm:"202604", billTotAmt:245500, dueDt:"2026-04-25",
                            pymtSttsCd:"OVERDUE", pymtAmt:0, pymtDt:"", lateFeeRt:0.03, lateFeeAmt:7365,
                            details:[  {cd:"ELEC",  nm:"전기요금",   amt:85500},
                                {cd:"WATER", nm:"수도요금",   amt:35000},
                                {cd:"COMMON",nm:"공용관리비", amt:125000} ],
                            payments:[] },

                        { billNo:"B004", hoNo:"103동 1103호", ownerNm:"정미선", billYm:"202604", billTotAmt:298000, dueDt:"2026-04-25",
                            pymtSttsCd:"PAID",    pymtAmt:298000, pymtDt:"2026-04-18", lateFeeRt:0.03, lateFeeAmt:0,
                            details:[  {cd:"ELEC",  nm:"전기요금",   amt:98000},
                                {cd:"WATER", nm:"수도요금",   amt:55000},
                                {cd:"COMMON",nm:"공용관리비", amt:145000} ],
                            payments:[ {payNo:"P002", payAmt:298000, paySttsCd:"PAID", payCmplDt:"2026-04-18", payMthdCd:"TRANSFER"} ] },
                    ];

                    var STTS_STYLE = {
                        PAID:    { text:"완납",    bg:"#dcfce7", color:"#166534" },
                        UNPAID:  { text:"미납",    bg:"#fff0e0", color:"#92400e" },
                        OVERDUE: { text:"장기연체", bg:"#f5e8d0", color:"#6b3d0a" }
                    };

                    var PAY_MTHD = { CARD:"카드", TRANSFER:"계좌이체", CASH:"현금" };

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
                            tbody.innerHTML = '<tr><td colspan="8" style="text-align:center; padding:24px; color:var(--text-tertiary);">부과 내역이 없습니다.</td></tr>';
                            return;
                        }

                        tbody.innerHTML = data.map(function(row) {
                            var realIdx = rowData.indexOf(row);
                            var s = STTS_STYLE[row.pymtSttsCd] || { text:"-", bg:"#f3f4f6", color:"#4b5563" };
                            var badge = '<span style="display:inline-flex; padding:3px 10px; border-radius:4px; font-size:11px; font-weight:700; background:' + s.bg + '; color:' + s.color + ';">' + s.text + '</span>';

                            /* 버튼: 상세/납부/연체 각각 고정 열 */
                            var bsDetail  = 'font-size:11px; padding:4px 6px; border-radius:5px; font-weight:600; cursor:pointer; width:44px;';
                            var tdDetail  = '<td style="text-align:center; padding:8px 4px;">'
                                + '<button type="button" style="' + bsDetail + 'border:1px solid #2e5c38; background:var(--card); color:#2e5c38;" data-action="openDetail" data-idx="' + realIdx + '">상세</button>'
                                + '</td>';
                            var tdPaid = '<td style="text-align:center; padding:8px 4px;">'
                                + (row.pymtSttsCd !== "PAID"
                                    ? '<button type="button" style="' + bsDetail + 'border:1px solid var(--border); background:var(--card); color:var(--text-secondary);" data-action="quickPaid" data-idx="' + realIdx + '">납부</button>'
                                    : '')
                                + '</td>';
                            var tdOverdue = '<td style="text-align:center; padding:8px 4px;">'
                                + (row.pymtSttsCd === "UNPAID"
                                    ? '<button type="button" style="' + bsDetail + 'border:1px solid #2e5c38; background:#2e5c38; color:#fff;" data-action="quickOverdue" data-idx="' + realIdx + '">연체</button>'
                                    : '')
                                + '</td>';

                            return '<tr>'
                                + '<td class="td-bold">' + row.hoNo + '</td>'
                                + '<td style="color:var(--text-secondary);">' + row.ownerNm + '</td>'
                                + '<td>' + row.billYm.slice(0,4) + '.' + row.billYm.slice(4) + '</td>'
                                + '<td style="text-align:right; font-weight:700;">₩' + row.billTotAmt.toLocaleString() + '</td>'
                                + '<td style="text-align:right; font-weight:700; color:' + (row.pymtSttsCd !== "PAID" ? "#dc2626" : "var(--text-tertiary)") + ';">'
                                + (row.pymtSttsCd !== "PAID" ? "₩" + row.billTotAmt.toLocaleString() : "-") + '</td>'
                                + '<td style="text-align:right; font-weight:700; color:#d97706;">'
                                + (row.lateFeeAmt > 0 ? "₩" + row.lateFeeAmt.toLocaleString() : "-") + '</td>'
                                + '<td>' + badge + '</td>'
                                + tdDetail + tdPaid + tdOverdue
                                + '</tr>';
                        }).join("");
                    }

                    /* ── 필터 ── */
                    function getFiltered(sttsFix) {
                        var stts    = sttsFix !== undefined ? sttsFix : document.getElementById("filterStts").value;
                        var keyword = document.getElementById("filterKeyword").value.trim();
                        return rowData.filter(function(r) {
                            return (!stts    || r.pymtSttsCd === stts)
                                && (!keyword || r.hoNo.indexOf(keyword) > -1 || r.ownerNm.indexOf(keyword) > -1);
                        });
                    }

                    /* ── 모달 열기 ── */
                    function openDetail(idx) {
                        currentDetailIdx = idx;
                        var row = rowData[idx];
                        var s   = STTS_STYLE[row.pymtSttsCd] || { text:"-", bg:"#f3f4f6", color:"#4b5563" };

                        document.getElementById("modalHoNo").textContent    = row.hoNo + (row.ownerNm ? " · " + row.ownerNm : "");
                        document.getElementById("modalBillNo").textContent  = "BILL_NO: " + row.billNo;
                        document.getElementById("modalYm").textContent      = row.billYm.slice(0,4) + "년 " + row.billYm.slice(4) + "월";
                        document.getElementById("modalAmt").textContent     = "₩" + row.billTotAmt.toLocaleString();
                        document.getElementById("modalDueDt").textContent   = row.dueDt || "-";
                        document.getElementById("modalPymtAmt").textContent = row.pymtAmt > 0 ? "₩" + row.pymtAmt.toLocaleString() : "-";
                        document.getElementById("modalPymtDt").textContent  = row.pymtDt  || "-";
                        document.getElementById("modalFeeRt").textContent   = (row.lateFeeRt * 100).toFixed(0) + "%";
                        document.getElementById("modalLateFee").textContent = row.lateFeeAmt > 0 ? "₩" + row.lateFeeAmt.toLocaleString() : "-";
                        document.getElementById("modalStts").innerHTML =
                            '<span style="display:inline-flex; padding:3px 10px; border-radius:4px; font-size:11px; font-weight:700; background:' + s.bg + '; color:' + s.color + ';">' + s.text + '</span>';

                        /* 연체정보 박스: 미납·연체만 표시 */
                        document.getElementById("modalOverdueBox").style.display = row.pymtSttsCd !== "PAID" ? "block" : "none";

                        /* 항목별 내역 (BILL_DETAIL) */
                        document.getElementById("modalItems").innerHTML = (row.details || []).map(function(d) {
                            return '<div style="display:flex; justify-content:space-between; align-items:center; padding:8px 12px; background:#f7f8f9; border-radius:6px; font-size:13px;">'
                                + '<span style="color:var(--text-secondary);">' + d.nm
                                + ' <span style="font-size:10px; color:var(--text-tertiary);">(' + d.cd + ')</span></span>'
                                + '<span style="font-weight:700;">₩' + d.amt.toLocaleString() + '</span>'
                                + '</div>';
                        }).join("") || '<div style="font-size:12px; color:var(--text-tertiary); padding:8px 0;">항목 내역 없음</div>';

                        /* 납부 이력 (PAYMENT) */
                        document.getElementById("modalPayments").innerHTML = (row.payments || []).map(function(p) {
                            return '<div style="display:flex; justify-content:space-between; align-items:center; padding:10px 12px; background:#f0f7f2; border-radius:8px; font-size:13px;">'
                                + '<div>'
                                + '<div style="font-weight:700; color:#2e5c38;">₩' + p.payAmt.toLocaleString() + '</div>'
                                + '<div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">' + p.payCmplDt + ' · ' + (PAY_MTHD[p.payMthdCd] || p.payMthdCd) + '</div>'
                                + '</div>'
                                + '<span class="badge badge-green">완료</span>'
                                + '</div>';
                        }).join("") || '<div style="font-size:12px; color:var(--text-tertiary); padding:8px 0;">납부 이력 없음</div>';

                        /* 액션 버튼 표시 제어 */
                        document.getElementById("btnOverdueProcess").style.display = row.pymtSttsCd === "UNPAID"  ? "inline-flex" : "none";
                        document.getElementById("btnPaidProcess").style.display    = row.pymtSttsCd !== "PAID"    ? "inline-flex" : "none";

                        document.getElementById("billDetailModal").classList.add("open");
                    }

                    function closeModal() {
                        document.getElementById("billDetailModal").classList.remove("open");
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

                    document.getElementById("btnCloseModal").addEventListener("click", closeModal);
                    document.getElementById("btnCloseModal2").addEventListener("click", closeModal);

                    document.getElementById("billDetailModal").addEventListener("click", function(e) {
                        if (e.target === this) closeModal();
                    });

                    document.getElementById("btnOverdueProcess").addEventListener("click", function() {
                        if (currentDetailIdx === null) return;
                        var row = rowData[currentDetailIdx];
                        row.pymtSttsCd = "OVERDUE";
                        row.lateFeeAmt = Math.round(row.billTotAmt * row.lateFeeRt);
                        alert("연체 처리 완료\nPYMT_STTS_CD = OVERDUE\nLATE_FEE_AMT = ₩" + row.lateFeeAmt.toLocaleString());
                        closeModal();
                        renderTable(getFiltered());
                    });

                    document.getElementById("btnPaidProcess").addEventListener("click", function() {
                        if (currentDetailIdx === null) return;
                        var row = rowData[currentDetailIdx];
                        row.pymtSttsCd = "PAID";
                        row.pymtAmt    = row.billTotAmt + row.lateFeeAmt;
                        row.pymtDt     = new Date().toISOString().slice(0,10);
                        alert("납부 완료 처리 연결 예정입니다.");
                        closeModal();
                        renderTable(getFiltered());
                    });

                    /* 테이블 버튼 위임 */
                    document.getElementById("billTableBody").addEventListener("click", function(e) {
                        var btn = e.target.closest("[data-action]");
                        if (!btn) return;
                        var idx = Number(btn.dataset.idx);

                        if (btn.dataset.action === "openDetail") {
                            openDetail(idx);
                        }
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
                });
            </script>

        </main>
    </div>
</div>
</body>
</html>
