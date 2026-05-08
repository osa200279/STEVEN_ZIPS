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

    <style>
        .bill-stepbar {
            display: flex;
            align-items: center;
            gap: 6px;
            flex-wrap: wrap;
            margin-bottom: 20px;
            padding: 14px 20px;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--r-lg);
        }

        .bill-step {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .bill-step-num {
            width: 26px;
            height: 26px;
            border-radius: 50%;
            background: #e8eaed;
            color: var(--text-secondary);
            font-size: 11px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .bill-step.active .bill-step-num {
            background: #2e5c38;
            color: #fff;
        }

        .bill-step-text {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .bill-step.active .bill-step-text {
            font-weight: 700;
            color: #2e5c38;
        }

        .bill-step-arrow {
            color: var(--text-tertiary);
        }

        .bill-layout {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 280px;
            gap: 16px;
        }

        .bill-main {
            display: flex;
            flex-direction: column;
            gap: 12px;
            min-width: 0;
        }

        .bill-side {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .bill-filter-panel {
            padding: 16px 20px;
        }

        .bill-filter-row {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .bill-field-sm {
            gap: 4px;
        }

        .bill-filter-ym {
            width: 150px;
        }

        .bill-filter-status {
            width: 140px;
        }

        .bill-filter-keyword {
            width: 180px;
        }

        .bill-list-panel {
            padding: 0;
            overflow: hidden;
        }

        .bill-list-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 20px;
            border-bottom: 1px solid var(--border);
            background: #f7f8f9;
        }

        .bill-list-title {
            font-size: 13px;
            font-weight: 700;
        }

        .bill-list-sub {
            font-size: 11px;
            color: var(--text-tertiary);
            margin-left: 8px;
        }

        .bill-list-actions {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .text-right {
            text-align: right;
        }

        .text-center {
            text-align: center;
        }

        .bill-action-th {
            width: 52px;
            text-align: center;
        }

        .bill-row-btn {
            width: 44px;
            padding: 4px 6px;
            border-radius: 5px;
            font-size: 11px;
            font-weight: 600;
            cursor: pointer;
            font-family: inherit;
        }

        .bill-row-btn.detail {
            border: 1px solid #2e5c38;
            background: var(--card);
            color: #2e5c38;
        }

        .bill-row-btn.paid {
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--text-secondary);
        }

        .bill-row-btn.overdue {
            border: 1px solid #2e5c38;
            background: #2e5c38;
            color: #fff;
        }

        .bill-status-badge {
            display: inline-flex;
            padding: 3px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
        }

        .bill-side-panel {
            padding: 0;
            overflow: hidden;
        }

        .bill-side-header {
            padding: 12px 16px;
            border-bottom: 1px solid var(--border);
            background: #f7f8f9;
            font-size: 13px;
            font-weight: 700;
        }

        .bill-side-body {
            padding: 16px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .bill-side-label {
            font-size: 11px;
            color: var(--text-tertiary);
            margin-bottom: 4px;
        }

        .bill-side-label.unpaid {
            color: #d97706;
        }

        .bill-side-label.overdue {
            color: #92400e;
        }

        .bill-side-value {
            font-size: 24px;
            font-weight: 900;
            color: var(--text-primary);
        }

        .bill-side-value.unpaid {
            color: #d97706;
        }

        .bill-side-value.overdue {
            color: #92400e;
        }

        .bill-side-divider {
            height: 1px;
            background: var(--border);
        }

        .bill-quick-body {
            padding: 12px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .bill-full-btn {
            width: 100%;
            justify-content: center;
        }

        .bill-green-btn {
            background: #2e5c38;
        }

        .bill-modal {
            max-width: 540px;
        }

        .bill-modal-sub {
            font-size: 11px;
            color: var(--text-secondary);
            margin-top: 2px;
        }

        .bill-modal-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .bill-modal-info {
            background: #f7f8f9;
            border-radius: 10px;
            padding: 14px;
        }

        .bill-modal-section-title {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-tertiary);
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .bill-modal-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .bill-modal-label {
            font-size: 10px;
            color: var(--text-tertiary);
            margin-bottom: 3px;
        }

        .bill-modal-value {
            font-size: 13px;
            font-weight: 700;
        }

        .bill-modal-overdue {
            background: #fef9f0;
            border: 1px solid #fde68a;
            border-radius: 10px;
            padding: 14px;
        }

        .bill-modal-overdue .bill-modal-section-title,
        .bill-modal-overdue .bill-modal-label {
            color: #92400e;
        }

        .bill-modal-late-fee {
            font-size: 15px;
            font-weight: 900;
            color: #dc2626;
        }

        .bill-modal-list-title {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-tertiary);
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .bill-modal-list {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .bill-detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 12px;
            background: #f7f8f9;
            border-radius: 6px;
            font-size: 13px;
        }

        .bill-detail-item-name {
            color: var(--text-secondary);
        }

        .bill-detail-code {
            font-size: 10px;
            color: var(--text-tertiary);
        }

        .bill-detail-amt {
            font-weight: 700;
        }

        .bill-payment-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 12px;
            background: #f0f7f2;
            border-radius: 8px;
            font-size: 13px;
        }

        .bill-payment-amt {
            font-weight: 700;
            color: #2e5c38;
        }

        .bill-payment-sub {
            font-size: 11px;
            color: var(--text-tertiary);
            margin-top: 2px;
        }

        .bill-empty-text {
            font-size: 12px;
            color: var(--text-tertiary);
            padding: 8px 0;
        }

        @media (max-width: 1200px) {
            .bill-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
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
                        <p>세대별 관리비 부과 내역 조회 및 연체 처리를 관리합니다.</p>
                    </div>

                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary" id="btnExcel">
                            <span class="material-symbols-rounded">download</span>
                            엑셀 다운로드
                        </button>
                    </div>
                </div>

                <div class="bill-stepbar">
                    <div class="bill-step">
                        <div class="bill-step-num">1</div>
                        <span class="bill-step-text">고지서 등록</span>
                    </div>

                    <span class="bill-step-arrow">→</span>

                    <div class="bill-step active">
                        <div class="bill-step-num">2</div>
                        <span class="bill-step-text">부과 내역 조회</span>
                    </div>

                    <span class="bill-step-arrow">→</span>

                    <div class="bill-step">
                        <div class="bill-step-num">3</div>
                        <span class="bill-step-text">연체 처리</span>
                    </div>

                    <span class="bill-step-arrow">→</span>

                    <div class="bill-step">
                        <div class="bill-step-num">4</div>
                        <span class="bill-step-text">납부 확인</span>
                    </div>
                </div>

                <div class="bill-layout">

                    <div class="bill-main">

                        <div class="panel bill-filter-panel">
                            <div class="bill-filter-row">
                                <div class="form-field bill-field-sm">
                                    <label class="field-label">부과월</label>
                                    <select class="form-select bill-filter-ym" id="filterYm">
                                        <option value="202604">2026년 4월분</option>
                                        <option value="202603">2026년 3월분</option>
                                        <option value="202602">2026년 2월분</option>
                                    </select>
                                </div>

                                <div class="form-field bill-field-sm">
                                    <label class="field-label">납부 상태</label>
                                    <select class="form-select bill-filter-status" id="filterStts">
                                        <option value="">전체</option>
                                        <option value="PAID">완납</option>
                                        <option value="UNPAID">미납</option>
                                        <option value="OVERDUE">장기연체</option>
                                    </select>
                                </div>

                                <div class="form-field bill-field-sm">
                                    <label class="field-label">동/호수</label>
                                    <input type="text" class="form-input bill-filter-keyword" id="filterKeyword" placeholder="예: 101동 / 1204호">
                                </div>

                                <button type="button" class="btn btn-primary" id="btnSearch">조회</button>
                            </div>
                        </div>

                        <div class="panel bill-list-panel">
                            <div class="bill-list-header">
                                <div>
                                    <span class="bill-list-title">세대별 부과 현황</span>
                                    <span class="bill-list-sub">상세, 납부 처리, 연체 처리를 선택하세요.</span>
                                </div>

                                <div class="bill-list-actions">
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
                                        <th>동/호수</th>
                                        <th>세대주</th>
                                        <th>부과월</th>
                                        <th class="text-right">부과 금액</th>
                                        <th class="text-right">미납 금액</th>
                                        <th class="text-right">연체료</th>
                                        <th>상태</th>
                                        <th class="bill-action-th">상세</th>
                                        <th class="bill-action-th">납부</th>
                                        <th class="bill-action-th">연체</th>
                                    </tr>
                                    </thead>

                                    <tbody id="billTableBody"></tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <div class="bill-side">

                        <div class="panel bill-side-panel">
                            <div class="bill-side-header">이달 현황</div>

                            <div class="bill-side-body">
                                <div>
                                    <div class="bill-side-label">총 부과 세대</div>
                                    <div class="bill-side-value" id="rTotal">0세대</div>
                                </div>

                                <div class="bill-side-divider"></div>

                                <div>
                                    <div class="bill-side-label unpaid">미납 세대</div>
                                    <div class="bill-side-value unpaid" id="rUnpaid">0세대</div>
                                </div>

                                <div class="bill-side-divider"></div>

                                <div>
                                    <div class="bill-side-label overdue">장기연체 세대</div>
                                    <div class="bill-side-value overdue" id="rOverdue">0세대</div>
                                </div>
                            </div>
                        </div>

                        <div class="panel bill-side-panel">
                            <div class="bill-side-header">바로 처리</div>

                            <div class="bill-quick-body">
                                <button type="button" class="btn btn-primary bill-full-btn bill-green-btn" id="btnShowOverdue">
                                    연체 세대만 보기
                                </button>

                                <button type="button" class="btn btn-secondary bill-full-btn" id="btnShowUnpaid">
                                    미납 세대만 보기
                                </button>

                                <button type="button" class="btn btn-secondary bill-full-btn" id="btnShowAll">
                                    전체 보기
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-overlay" id="billDetailModal">
                    <div class="modal bill-modal">
                        <div class="modal-header primary">
                            <div>
                                <h3 class="modal-title" id="modalHoNo">—</h3>
                                <div class="bill-modal-sub" id="modalBillNo">BILL_NO: —</div>
                            </div>

                            <button type="button" class="modal-close" id="btnCloseModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <div class="modal-body bill-modal-body">

                            <div class="bill-modal-info">
                                <div class="bill-modal-section-title">기본 정보</div>

                                <div class="bill-modal-grid">
                                    <div>
                                        <div class="bill-modal-label">부과월</div>
                                        <div class="bill-modal-value" id="modalYm">—</div>
                                    </div>

                                    <div>
                                        <div class="bill-modal-label">납부 상태</div>
                                        <div id="modalStts">—</div>
                                    </div>

                                    <div>
                                        <div class="bill-modal-label">부과 총액</div>
                                        <div class="bill-modal-value" id="modalAmt">—</div>
                                    </div>

                                    <div>
                                        <div class="bill-modal-label">납부기한</div>
                                        <div class="bill-modal-value" id="modalDueDt">—</div>
                                    </div>

                                    <div>
                                        <div class="bill-modal-label">실납부액</div>
                                        <div class="bill-modal-value" id="modalPymtAmt">—</div>
                                    </div>

                                    <div>
                                        <div class="bill-modal-label">납부일</div>
                                        <div class="bill-modal-value" id="modalPymtDt">—</div>
                                    </div>
                                </div>
                            </div>

                            <div class="bill-modal-overdue" id="modalOverdueBox">
                                <div class="bill-modal-section-title">연체 정보</div>

                                <div class="bill-modal-grid">
                                    <div>
                                        <div class="bill-modal-label">연체요율</div>
                                        <div class="bill-modal-value" id="modalFeeRt">3%</div>
                                    </div>

                                    <div>
                                        <div class="bill-modal-label">연체료</div>
                                        <div class="bill-modal-late-fee" id="modalLateFee">—</div>
                                    </div>
                                </div>
                            </div>

                            <div>
                                <div class="bill-modal-list-title">항목별 내역</div>
                                <div id="modalItems" class="bill-modal-list"></div>
                            </div>

                            <div>
                                <div class="bill-modal-list-title">납부 이력</div>
                                <div id="modalPayments" class="bill-modal-list"></div>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" id="btnCloseModal2">닫기</button>

                            <button type="button" class="btn btn-primary bill-green-btn" id="btnOverdueProcess">
                                연체 처리
                            </button>

                            <button type="button" class="btn btn-primary" id="btnPaidProcess">
                                납부 완료 처리
                            </button>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        initBillIssuePage();
    });

    function initBillIssuePage() {
        var currentDetailIdx = null;

        var rowData = [
            {
                billNo: "B001",
                hoNo: "101동 402호",
                ownerNm: "김철수",
                billYm: "202604",
                billTotAmt: 285000,
                dueDt: "2026-04-25",
                pymtSttsCd: "PAID",
                pymtAmt: 285000,
                pymtDt: "2026-04-20",
                lateFeeRt: 0.03,
                lateFeeAmt: 0,
                details: [
                    { cd: "ELEC", nm: "전기요금", amt: 95000 },
                    { cd: "WATER", nm: "수도요금", amt: 45000 },
                    { cd: "COMMON", nm: "공용관리비", amt: 145000 }
                ],
                payments: [
                    { payNo: "P001", payAmt: 285000, paySttsCd: "PAID", payCmplDt: "2026-04-20", payMthdCd: "CARD" }
                ]
            },
            {
                billNo: "B002",
                hoNo: "104동 1205호",
                ownerNm: "이영희",
                billYm: "202604",
                billTotAmt: 312000,
                dueDt: "2026-04-25",
                pymtSttsCd: "UNPAID",
                pymtAmt: 0,
                pymtDt: "",
                lateFeeRt: 0.03,
                lateFeeAmt: 0,
                details: [
                    { cd: "ELEC", nm: "전기요금", amt: 112000 },
                    { cd: "WATER", nm: "수도요금", amt: 55000 },
                    { cd: "COMMON", nm: "공용관리비", amt: 145000 }
                ],
                payments: []
            },
            {
                billNo: "B003",
                hoNo: "102동 701호",
                ownerNm: "박지민",
                billYm: "202604",
                billTotAmt: 245500,
                dueDt: "2026-04-25",
                pymtSttsCd: "OVERDUE",
                pymtAmt: 0,
                pymtDt: "",
                lateFeeRt: 0.03,
                lateFeeAmt: 7365,
                details: [
                    { cd: "ELEC", nm: "전기요금", amt: 85500 },
                    { cd: "WATER", nm: "수도요금", amt: 35000 },
                    { cd: "COMMON", nm: "공용관리비", amt: 125000 }
                ],
                payments: []
            },
            {
                billNo: "B004",
                hoNo: "103동 1103호",
                ownerNm: "정미선",
                billYm: "202604",
                billTotAmt: 298000,
                dueDt: "2026-04-25",
                pymtSttsCd: "PAID",
                pymtAmt: 298000,
                pymtDt: "2026-04-18",
                lateFeeRt: 0.03,
                lateFeeAmt: 0,
                details: [
                    { cd: "ELEC", nm: "전기요금", amt: 98000 },
                    { cd: "WATER", nm: "수도요금", amt: 55000 },
                    { cd: "COMMON", nm: "공용관리비", amt: 145000 }
                ],
                payments: [
                    { payNo: "P002", payAmt: 298000, paySttsCd: "PAID", payCmplDt: "2026-04-18", payMthdCd: "TRANSFER" }
                ]
            }
        ];

        var STTS_STYLE = {
            PAID: { text: "완납", bg: "#dcfce7", color: "#166534" },
            UNPAID: { text: "미납", bg: "#fff0e0", color: "#92400e" },
            OVERDUE: { text: "장기연체", bg: "#f5e8d0", color: "#6b3d0a" }
        };

        var PAY_MTHD = {
            CARD: "카드",
            TRANSFER: "계좌이체",
            CASH: "현금"
        };

        function statusBadge(code) {
            var status = STTS_STYLE[code] || { text: "-", bg: "#f3f4f6", color: "#4b5563" };

            return '<span class="bill-status-badge" style="background:' + status.bg + '; color:' + status.color + ';">'
                + status.text
                + '</span>';
        }

        function updateStats(data) {
            document.getElementById("rTotal").textContent = data.length + "세대";

            document.getElementById("rUnpaid").textContent = data.filter(function (row) {
                return row.pymtSttsCd === "UNPAID";
            }).length + "세대";

            document.getElementById("rOverdue").textContent = data.filter(function (row) {
                return row.pymtSttsCd === "OVERDUE";
            }).length + "세대";
        }

        function renderTable(data) {
            document.getElementById("billListCount").textContent = data.length + "건";
            updateStats(data);

            var tbody = document.getElementById("billTableBody");

            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="10" class="text-center" style="padding:24px; color:var(--text-tertiary);">부과 내역이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = data.map(function (row) {
                var realIdx = rowData.indexOf(row);

                var detailBtn = '<button type="button" class="bill-row-btn detail" data-action="openDetail" data-idx="' + realIdx + '">상세</button>';

                var paidBtn = row.pymtSttsCd !== "PAID"
                    ? '<button type="button" class="bill-row-btn paid" data-action="quickPaid" data-idx="' + realIdx + '">납부</button>'
                    : '';

                var overdueBtn = row.pymtSttsCd === "UNPAID"
                    ? '<button type="button" class="bill-row-btn overdue" data-action="quickOverdue" data-idx="' + realIdx + '">연체</button>'
                    : '';

                return '<tr>'
                    + '<td class="td-bold">' + row.hoNo + '</td>'
                    + '<td>' + row.ownerNm + '</td>'
                    + '<td>' + row.billYm.slice(0, 4) + '.' + row.billYm.slice(4) + '</td>'
                    + '<td class="text-right" style="font-weight:700;">₩' + row.billTotAmt.toLocaleString() + '</td>'
                    + '<td class="text-right" style="font-weight:700; color:' + (row.pymtSttsCd !== "PAID" ? "#dc2626" : "var(--text-tertiary)") + ';">'
                    + (row.pymtSttsCd !== "PAID" ? "₩" + row.billTotAmt.toLocaleString() : "-")
                    + '</td>'
                    + '<td class="text-right" style="font-weight:700; color:#d97706;">'
                    + (row.lateFeeAmt > 0 ? "₩" + row.lateFeeAmt.toLocaleString() : "-")
                    + '</td>'
                    + '<td>' + statusBadge(row.pymtSttsCd) + '</td>'
                    + '<td class="text-center">' + detailBtn + '</td>'
                    + '<td class="text-center">' + paidBtn + '</td>'
                    + '<td class="text-center">' + overdueBtn + '</td>'
                    + '</tr>';
            }).join("");
        }

        function getFiltered(sttsFix) {
            var stts = sttsFix !== undefined ? sttsFix : document.getElementById("filterStts").value;
            var keyword = document.getElementById("filterKeyword").value.trim();

            return rowData.filter(function (row) {
                return (!stts || row.pymtSttsCd === stts)
                    && (!keyword || row.hoNo.indexOf(keyword) > -1 || row.ownerNm.indexOf(keyword) > -1);
            });
        }

        function openDetail(idx) {
            currentDetailIdx = idx;

            var row = rowData[idx];

            document.getElementById("modalHoNo").textContent = row.hoNo + (row.ownerNm ? " · " + row.ownerNm : "");
            document.getElementById("modalBillNo").textContent = "BILL_NO: " + row.billNo;
            document.getElementById("modalYm").textContent = row.billYm.slice(0, 4) + "년 " + row.billYm.slice(4) + "월";
            document.getElementById("modalAmt").textContent = "₩" + row.billTotAmt.toLocaleString();
            document.getElementById("modalDueDt").textContent = row.dueDt || "-";
            document.getElementById("modalPymtAmt").textContent = row.pymtAmt > 0 ? "₩" + row.pymtAmt.toLocaleString() : "-";
            document.getElementById("modalPymtDt").textContent = row.pymtDt || "-";
            document.getElementById("modalFeeRt").textContent = (row.lateFeeRt * 100).toFixed(0) + "%";
            document.getElementById("modalLateFee").textContent = row.lateFeeAmt > 0 ? "₩" + row.lateFeeAmt.toLocaleString() : "-";
            document.getElementById("modalStts").innerHTML = statusBadge(row.pymtSttsCd);

            document.getElementById("modalOverdueBox").style.display = row.pymtSttsCd !== "PAID" ? "block" : "none";

            document.getElementById("modalItems").innerHTML = (row.details || []).map(function (detail) {
                return '<div class="bill-detail-item">'
                    + '<span class="bill-detail-item-name">' + detail.nm + ' <span class="bill-detail-code">(' + detail.cd + ')</span></span>'
                    + '<span class="bill-detail-amt">₩' + detail.amt.toLocaleString() + '</span>'
                    + '</div>';
            }).join("") || '<div class="bill-empty-text">항목 내역 없음</div>';

            document.getElementById("modalPayments").innerHTML = (row.payments || []).map(function (payment) {
                return '<div class="bill-payment-item">'
                    + '<div>'
                    + '<div class="bill-payment-amt">₩' + payment.payAmt.toLocaleString() + '</div>'
                    + '<div class="bill-payment-sub">' + payment.payCmplDt + ' · ' + (PAY_MTHD[payment.payMthdCd] || payment.payMthdCd) + '</div>'
                    + '</div>'
                    + '<span class="badge badge-green">완료</span>'
                    + '</div>';
            }).join("") || '<div class="bill-empty-text">납부 이력 없음</div>';

            document.getElementById("btnOverdueProcess").style.display = row.pymtSttsCd === "UNPAID" ? "inline-flex" : "none";
            document.getElementById("btnPaidProcess").style.display = row.pymtSttsCd !== "PAID" ? "inline-flex" : "none";

            document.getElementById("billDetailModal").classList.add("open");
        }

        function closeModal() {
            document.getElementById("billDetailModal").classList.remove("open");
            currentDetailIdx = null;
        }

        document.getElementById("btnSearch").addEventListener("click", function () {
            renderTable(getFiltered());
        });

        document.getElementById("btnShowOverdue").addEventListener("click", function () {
            document.getElementById("filterStts").value = "OVERDUE";
            renderTable(getFiltered("OVERDUE"));
        });

        document.getElementById("btnShowUnpaid").addEventListener("click", function () {
            document.getElementById("filterStts").value = "UNPAID";
            renderTable(getFiltered("UNPAID"));
        });

        document.getElementById("btnShowAll").addEventListener("click", function () {
            document.getElementById("filterStts").value = "";
            renderTable(rowData);
        });

        document.getElementById("btnCloseModal").addEventListener("click", closeModal);
        document.getElementById("btnCloseModal2").addEventListener("click", closeModal);

        document.getElementById("billDetailModal").addEventListener("click", function (event) {
            if (event.target === this) {
                closeModal();
            }
        });

        document.getElementById("btnOverdueProcess").addEventListener("click", function () {
            if (currentDetailIdx === null) return;

            var row = rowData[currentDetailIdx];
            row.pymtSttsCd = "OVERDUE";
            row.lateFeeAmt = Math.round(row.billTotAmt * row.lateFeeRt);

            alert("연체 처리 완료\n연체료: ₩" + row.lateFeeAmt.toLocaleString());

            closeModal();
            renderTable(getFiltered());
        });

        document.getElementById("btnPaidProcess").addEventListener("click", function () {
            if (currentDetailIdx === null) return;

            var row = rowData[currentDetailIdx];
            row.pymtSttsCd = "PAID";
            row.pymtAmt = row.billTotAmt + row.lateFeeAmt;
            row.pymtDt = new Date().toISOString().slice(0, 10);

            alert("납부 완료 처리 연결 예정입니다.");

            closeModal();
            renderTable(getFiltered());
        });

        document.getElementById("billTableBody").addEventListener("click", function (event) {
            var btn = event.target.closest("[data-action]");
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
                rowData[idx].pymtAmt = rowData[idx].billTotAmt + rowData[idx].lateFeeAmt;
                rowData[idx].pymtDt = new Date().toISOString().slice(0, 10);
                renderTable(getFiltered());
            }
        });

        renderTable(rowData);
    }
</script>
</body>
</html>