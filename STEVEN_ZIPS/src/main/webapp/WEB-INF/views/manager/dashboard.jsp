<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>
    /* dashboard.jsp 전용 CSS - 기존 인라인 스타일 값을 최대한 유지하면서 위로 모음 */
    #dashboardPage .dash-card-red{cursor:pointer;border-left:4px solid #dc2626} #dashboardPage .dash-card-orange{cursor:pointer;border-left:4px solid #d97706} #dashboardPage .dash-card-purple{cursor:pointer;border-left:4px solid #7c3aed} #dashboardPage .dash-card-green{cursor:pointer;border-left:4px solid #2e5c38}
    #dashboardPage .dash-card-red:hover,#dashboardPage .dash-card-orange:hover,#dashboardPage .dash-card-purple:hover,#dashboardPage .dash-card-green:hover{transform:translateY(-1px)}
    #dashboardPage .dash-card-body{display:flex;align-items:center;justify-content:space-between;width:100%} #dashboardPage .dash-card-label{font-size:11px;color:var(--text-tertiary);margin-bottom:6px} #dashboardPage .dash-card-value{font-size:28px;font-weight:900} #dashboardPage .dash-card-sub{font-size:11px;color:var(--text-tertiary);margin-top:4px}
    #dashboardPage .dash-red{color:#dc2626} #dashboardPage .dash-orange{color:#d97706} #dashboardPage .dash-purple{color:#7c3aed} #dashboardPage .dash-green{color:#2e5c38}
    #dashboardPage .dash-icon-box{width:44px;height:44px;border-radius:10px;display:flex;align-items:center;justify-content:center} #dashboardPage .dash-icon-red{background:#fee2e2} #dashboardPage .dash-icon-orange{background:#fef3c7} #dashboardPage .dash-icon-purple{background:#ede9fe} #dashboardPage .dash-icon-green{background:#f0f7f2} #dashboardPage .dash-icon{font-size:22px}
    #dashboardPage .dash-link-btn{display:inline-flex;align-items:center;justify-content:center;text-decoration:none} #dashboardPage .dash-grid-2{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:16px} #dashboardPage .dash-grid-3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;margin-bottom:16px}
    #dashboardPage .dash-panel{padding:0;overflow:hidden} #dashboardPage .dash-panel-head{display:flex;align-items:center;justify-content:space-between;padding:14px 18px;border-bottom:1px solid var(--border);background:#f7f8f9} #dashboardPage .dash-panel-title{font-size:13px;font-weight:700} #dashboardPage .dash-panel-title .material-symbols-rounded{font-size:15px;vertical-align:middle;margin-right:4px}
    #dashboardPage .dash-panel-body-sm{padding:12px} #dashboardPage .dash-panel-body{padding:16px 18px} #dashboardPage .dash-bill-total{margin-bottom:16px;text-align:center} #dashboardPage .dash-bill-label{font-size:11px;color:var(--text-tertiary);margin-bottom:4px} #dashboardPage .dash-bill-amount{font-size:22px;font-weight:900;color:#2e5c38}
    #dashboardPage .dash-progress-wrap{margin-bottom:12px} #dashboardPage .dash-progress-head{display:flex;justify-content:space-between;font-size:11px;margin-bottom:5px} #dashboardPage .dash-progress-label{color:var(--text-secondary)} #dashboardPage .dash-progress-pct{font-weight:700;color:#2e5c38} #dashboardPage .dash-progress-track{height:8px;background:#f0f1f3;border-radius:99px;overflow:hidden} #dashboardPage .dash-progress-bar{height:100%;background:#2e5c38;border-radius:99px;transition:.5s;width:0}
    #dashboardPage .dash-bill-cards{display:grid;grid-template-columns:repeat(3,1fr);gap:8px} #dashboardPage .dash-mini-card{border-radius:8px;padding:10px 12px;text-align:center} #dashboardPage .dash-mini-value{font-size:18px;font-weight:900} #dashboardPage .dash-mini-label{font-size:10px;margin-top:2px;opacity:.8}
    #dashboardPage .dash-list-box{padding:8px 0} #dashboardPage .dash-list-item{display:flex;align-items:center;justify-content:space-between;padding:9px 18px;border-bottom:1px solid var(--border);text-align:center} #dashboardPage .dash-list-left{flex:1;min-width:0;text-align:center} #dashboardPage .dash-list-title{font-size:12px;font-weight:700;text-align:center} #dashboardPage .dash-list-title-ellipsis{font-size:12px;font-weight:700;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;text-align:center} #dashboardPage .dash-list-sub{font-size:11px;color:var(--text-tertiary);margin-top:1px;text-align:center}
    #dashboardPage .dash-priority-dot{width:6px;height:6px;border-radius:50%;flex-shrink:0} #dashboardPage .dash-schedule-item{display:flex;align-items:center;gap:10px;padding:9px 10px;border-radius:8px;border:1px solid var(--border);margin-bottom:7px;text-align:center} #dashboardPage .dash-schedule-bar{width:4px;height:36px;border-radius:99px;flex-shrink:0} #dashboardPage .dash-schedule-body{flex:1;min-width:0;text-align:center} #dashboardPage .dash-schedule-title{font-size:12px;font-weight:700;color:var(--text-primary);overflow:hidden;text-overflow:ellipsis;white-space:nowrap;text-align:center} #dashboardPage .dash-schedule-loc{font-size:11px;color:var(--text-tertiary);margin-top:1px;text-align:center}
    #dashboardPage .dash-meter-badge{font-size:11px;font-weight:700;padding:2px 8px;border-radius:4px} #dashboardPage .dashboard-table th,#dashboardPage .dashboard-table td{text-align:center;vertical-align:middle}
</style>

<div class="office-page" id="dashboardPage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>대시보드</h2>
            <p id="dashDate"></p>
        </div>
    </div>

    <!-- ① KPI 카드 4개: 카드 전체 클릭 시 해당 화면으로 동기 이동 -->
    <div class="stat-row">

        <div class="stat-card dash-card-red" onclick="location.href='${pageContext.request.contextPath}/manager/cvpl/list'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">미처리 민원</div>
                    <div class="dash-card-value dash-red" id="kpiCvpl">0</div>
                    <div class="dash-card-sub">즉시 처리 필요</div>
                </div>
                <div class="dash-icon-box dash-icon-red">
                    <span class="material-symbols-rounded dash-icon dash-red">campaign</span>
                </div>
            </div>
        </div>

        <div class="stat-card dash-card-orange" onclick="location.href='${pageContext.request.contextPath}/manager/resident/auth'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">미처리 권한 신청</div>
                    <div class="dash-card-value dash-orange" id="kpiRqst">0</div>
                    <div class="dash-card-sub">승인 대기 중</div>
                </div>
                <div class="dash-icon-box dash-icon-orange">
                    <span class="material-symbols-rounded dash-icon dash-orange">how_to_reg</span>
                </div>
            </div>
        </div>

        <div class="stat-card dash-card-purple" onclick="location.href='${pageContext.request.contextPath}/manager/checkHistory'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">이상 발견 시설</div>
                    <div class="dash-card-value dash-purple" id="kpiFault">0</div>
                    <div class="dash-card-sub">점검 결과 확인 필요</div>
                </div>
                <div class="dash-icon-box dash-icon-purple">
                    <span class="material-symbols-rounded dash-icon dash-purple">build</span>
                </div>
            </div>
        </div>

        <div class="stat-card dash-card-green" onclick="location.href='${pageContext.request.contextPath}/manager/bill/issue'">
            <div class="dash-card-body">
                <div>
                    <div class="dash-card-label">관리비 미납·연체</div>
                    <div class="dash-card-value dash-green" id="kpiBill">0</div>
                    <div class="dash-card-sub">미납 및 연체 세대</div>
                </div>
                <div class="dash-icon-box dash-icon-green">
                    <span class="material-symbols-rounded dash-icon dash-green">receipt_long</span>
                </div>
            </div>
        </div>

    </div>

    <!-- ② 오늘 일정 / 이달 관리비 현황 -->
    <div class="dash-grid-2">

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">today</span>
                    오늘의 공사·점검 일정
                </span>
                <a href="${pageContext.request.contextPath}/manager/facility/workCalendar" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>
            <div class="dash-panel-body-sm" id="todayScheduleList"></div>
        </div>

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">receipt_long</span>
                    이달 관리비 현황
                </span>
                <a href="${pageContext.request.contextPath}/manager/bill/issue" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>

            <div class="dash-panel-body">
                <div class="dash-bill-total">
                    <div class="dash-bill-label">당월 총 부과액</div>
                    <div class="dash-bill-amount">₩142,580,000</div>
                </div>

                <div class="dash-progress-wrap">
                    <div class="dash-progress-head">
                        <span class="dash-progress-label">납부 현황</span>
                        <span class="dash-progress-pct" id="billPaidPct">0%</span>
                    </div>
                    <div class="dash-progress-track">
                        <div id="billPaidBar" class="dash-progress-bar"></div>
                    </div>
                </div>

                <div class="dash-bill-cards" id="billStatusCards"></div>
            </div>
        </div>

    </div>

    <!-- ③ 최근 검침 이상 / 최근 민원 / 이번 주 점검 -->
    <div class="dash-grid-3">

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">speed</span>
                    최근 검침 이상
                </span>
                <a href="${pageContext.request.contextPath}/manager/meterReading" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>
            <div id="meterAlertList" class="dash-list-box"></div>
        </div>

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">forum</span>
                    최근 민원
                </span>
                <a href="${pageContext.request.contextPath}/manager/cvpl/list" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>
            <div id="cvplList" class="dash-list-box"></div>
        </div>

        <div class="panel dash-panel">
            <div class="dash-panel-head">
                <span class="dash-panel-title">
                    <span class="material-symbols-rounded">build</span>
                    이번 주 점검 현황
                </span>
                <a href="${pageContext.request.contextPath}/manager/checkHistory" class="btn btn-xs btn-detail dash-link-btn">이동</a>
            </div>
            <div id="checkList" class="dash-list-box"></div>
        </div>

    </div>

    <!-- ④ 최근 권한 신청 현황: 처리 열 삭제, 신청번호 추가 -->
    <div class="panel dash-panel">
        <div class="dash-panel-head">
            <span class="dash-panel-title">
                <span class="material-symbols-rounded">how_to_reg</span>
                최근 권한 신청 현황
            </span>
            <a href="${pageContext.request.contextPath}/manager/resident/auth" class="btn btn-xs btn-detail dash-link-btn">이동</a>
        </div>

        <div class="table-wrap">
            <table class="tbl dashboard-table">
                <thead>
                <tr>
                    <th>신청번호</th>
                    <th>신청자</th>
                    <th>동/호수</th>
                    <th>신청 유형</th>
                    <th>신청일</th>
                    <th>상태</th>
                </tr>
                </thead>
                <tbody id="rqstTableBody"></tbody>
            </table>
        </div>
    </div>

</div>
<%@ include file="/WEB-INF/views/manager/admin_mgmt_ofc_select_modal.jsp" %>
<script>
    (function() {
        var page = document.getElementById("dashboardPage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        /* 오늘 날짜 표시 */
        var now = new Date();
        var days = ["일","월","화","수","목","금","토"];
        document.getElementById("dashDate").textContent = now.getFullYear() + "년 " + (now.getMonth() + 1) + "월 " + now.getDate() + "일 (" + days[now.getDay()] + ")";

        /* 화면 확인용 더미 데이터 */
        var cvplData = [
            { cvplNo:"C001", ttl:"누수 발생 신고", hoNo:"101동 803호", regDt:"2026-04-27", cvplSttsCd:"RCPT", prrtCd:"HIGH" },
            { cvplNo:"C002", ttl:"주차 공간 문의", hoNo:"102동 501호", regDt:"2026-04-26", cvplSttsCd:"APLY", prrtCd:"LOW" },
            { cvplNo:"C003", ttl:"엘리베이터 소음", hoNo:"103동 1102호", regDt:"2026-04-26", cvplSttsCd:"RCPT", prrtCd:"MEDIUM" },
            { cvplNo:"C004", ttl:"쓰레기 무단 투기 신고", hoNo:"101동 402호", regDt:"2026-04-25", cvplSttsCd:"POCS", prrtCd:"MEDIUM" }
        ];

        var rqstData = [
            { rqstNo:"R001", userNm:"김민준", hoNo:"101동 1203호", rqstTy:"MVIN", regDt:"2026-04-27", rqstSttsCd:"WAIT" },
            { rqstNo:"R002", userNm:"이서연", hoNo:"102동 803호", rqstTy:"MVOT", regDt:"2026-04-26", rqstSttsCd:"WAIT" },
            { rqstNo:"R003", userNm:"박지민", hoNo:"103동 501호", rqstTy:"CHG", regDt:"2026-04-25", rqstSttsCd:"APPR" },
            { rqstNo:"R004", userNm:"정미선", hoNo:"104동 302호", rqstTy:"MVIN", regDt:"2026-04-24", rqstSttsCd:"WAIT" }
        ];

        var checkData = [
            { facilityNm:"1호기 승강기", chkTyCd:"REG", chkDt:"2026-04-27", chkSttsCd:"ING" },
            { facilityNm:"스프링클러 설비", chkTyCd:"SAFE", chkDt:"2026-04-26", chkSttsCd:"FAULT" },
            { facilityNm:"CCTV 101동", chkTyCd:"REG", chkDt:"2026-04-25", chkSttsCd:"DONE" },
            { facilityNm:"지하 전기실", chkTyCd:"REPAIR", chkDt:"2026-04-24", chkSttsCd:"FAULT" }
        ];

        var meterAlerts = [
            { facilityNm:"101동 102호", meterTyCd:"ELEC", meterDt:"2026-04-27", meterRsltCd:"ERROR" },
            { facilityNm:"103동 지하", meterTyCd:"WATER", meterDt:"2026-04-26", meterRsltCd:"MISS" },
            { facilityNm:"102동 501호", meterTyCd:"GAS", meterDt:"2026-04-25", meterRsltCd:"ERROR" }
        ];

        var todaySchedules = [
            { schdlTtl:"엘리베이터 정기 점검", locCn:"101동", type:"check", schdlSttsCd:"ING" },
            { schdlTtl:"어린이 놀이터 안전 점검", locCn:"단지 내 놀이터", type:"safe", schdlSttsCd:"READY" }
        ];

        var billStat = { total:486, paid:449, unpaid:26, overdue:11 };

        /* 코드값 화면 표시용 변환 */
        var CVPL_STTS = { APLY:"접수대기", RCPT:"접수완료", POCS:"처리중", COMP:"완료" };
        var CVPL_BADGE = { APLY:"badge-gray", RCPT:"badge-yellow", POCS:"badge-blue", COMP:"badge-green" };
        var PRRT_COLOR = { HIGH:"#dc2626", MEDIUM:"#d97706", LOW:"#6b7280" };

        var RQST_TY = { MVIN:"입주", MVOT:"퇴거", CHG:"변경" };
        var RQST_STTS = { WAIT:"대기중", APPR:"승인", REJT:"반려" };
        var RQST_BADGE = { WAIT:"badge-yellow", APPR:"badge-green", REJT:"badge-red" };

        var CHK_TY = { REG:"정기점검", SPC:"특별점검", SAFE:"안전점검", REPAIR:"수리보수" };
        var CHK_STTS = { WAIT:"대기", ING:"진행중", DONE:"완료", FAULT:"이상발견" };
        var CHK_BADGE = { WAIT:"badge-gray", ING:"badge-yellow", DONE:"badge-green", FAULT:"badge-red" };

        var METER_TY = { ELEC:"전기", WATER:"수도", GAS:"가스", HEAT:"난방" };
        var METER_RSLT = { ERROR:"오류", MISS:"누락", CHECK:"확인필요" };
        var METER_RSLT_COLOR = { ERROR:"#dc2626", MISS:"#d97706", CHECK:"#7c3aed" };

        var SCHED_TYPE_COLOR = { repair:"#f59e0b", check:"#3b82f6", safe:"#10b981", const:"#ec4899" };
        var SCHED_STTS = { READY:"예정", ING:"진행중", DONE:"완료" };

        /* KPI 숫자 반영 */
        document.getElementById("kpiCvpl").textContent = cvplData.filter(function(r) { return r.cvplSttsCd !== "COMP"; }).length;
        document.getElementById("kpiRqst").textContent = rqstData.filter(function(r) { return r.rqstSttsCd === "WAIT"; }).length;
        document.getElementById("kpiFault").textContent = checkData.filter(function(r) { return r.chkSttsCd === "FAULT"; }).length;
        document.getElementById("kpiBill").textContent = billStat.unpaid + billStat.overdue;

        /* 관리비 납부 현황 */
        var paidPct = Math.round(billStat.paid / billStat.total * 100);
        document.getElementById("billPaidPct").textContent = paidPct + "%";
        setTimeout(function() { document.getElementById("billPaidBar").style.width = paidPct + "%"; }, 200);

        document.getElementById("billStatusCards").innerHTML = [
            { label:"납부완료", val:billStat.paid, bg:"#dcfce7", color:"#166534" },
            { label:"미납", val:billStat.unpaid, bg:"#fff0e0", color:"#92400e" },
            { label:"장기연체", val:billStat.overdue, bg:"#f5e8d0", color:"#6b3d0a" }
        ].map(function(s) {
            return '<div class="dash-mini-card" style="background:' + s.bg + ';">'
                + '<div class="dash-mini-value" style="color:' + s.color + ';">' + s.val + '건</div>'
                + '<div class="dash-mini-label" style="color:' + s.color + ';">' + s.label + '</div>'
                + '</div>';
        }).join("");

        /* 오늘 일정 */
        var todayEl = document.getElementById("todayScheduleList");
        if (todaySchedules.length === 0) {
            todayEl.innerHTML = '<div class="dash-list-sub" style="padding:20px;">오늘 예정된 일정이 없습니다.</div>';
        } else {
            todayEl.innerHTML = todaySchedules.map(function(s) {
                var sttsText = SCHED_STTS[s.schdlSttsCd] || "-";
                var sttsColor = s.schdlSttsCd === "ING" ? "#2e5c38" : s.schdlSttsCd === "DONE" ? "#6b7280" : "#d97706";

                return '<div class="dash-schedule-item">'
                    + '<div class="dash-schedule-bar" style="background:' + (SCHED_TYPE_COLOR[s.type] || "#888") + ';"></div>'
                    + '<div class="dash-schedule-body">'
                    + '<div class="dash-schedule-title">' + s.schdlTtl + '</div>'
                    + '<div class="dash-schedule-loc">' + s.locCn + '</div>'
                    + '</div>'
                    + '<span style="font-size:11px;font-weight:700;color:' + sttsColor + ';flex-shrink:0;">' + sttsText + '</span>'
                    + '</div>';
            }).join("");
        }

        /* 검침 이상 */
        document.getElementById("meterAlertList").innerHTML = meterAlerts.map(function(m) {
            return '<div class="dash-list-item">'
                + '<div class="dash-list-left">'
                + '<div class="dash-list-title">' + m.facilityNm + '</div>'
                + '<div class="dash-list-sub">' + METER_TY[m.meterTyCd] + ' · ' + m.meterDt + '</div>'
                + '</div>'
                + '<span class="dash-meter-badge" style="background:' + (METER_RSLT_COLOR[m.meterRsltCd] + "18") + ';color:' + METER_RSLT_COLOR[m.meterRsltCd] + ';">' + (METER_RSLT[m.meterRsltCd] || "-") + '</span>'
                + '</div>';
        }).join("");

        /* 최근 민원 */
        document.getElementById("cvplList").innerHTML = cvplData.map(function(c) {
            return '<div class="dash-list-item">'
                + '<div class="dash-priority-dot" style="background:' + (PRRT_COLOR[c.prrtCd] || "#888") + ';"></div>'
                + '<div class="dash-list-left">'
                + '<div class="dash-list-title-ellipsis">' + c.ttl + '</div>'
                + '<div class="dash-list-sub">' + c.hoNo + ' · ' + c.regDt + '</div>'
                + '</div>'
                + '<span class="badge ' + (CVPL_BADGE[c.cvplSttsCd] || "badge-gray") + '">' + (CVPL_STTS[c.cvplSttsCd] || "-") + '</span>'
                + '</div>';
        }).join("");

        /* 이번 주 점검 */
        document.getElementById("checkList").innerHTML = checkData.map(function(c) {
            return '<div class="dash-list-item">'
                + '<div class="dash-list-left">'
                + '<div class="dash-list-title">' + c.facilityNm + '</div>'
                + '<div class="dash-list-sub">' + (CHK_TY[c.chkTyCd] || "-") + ' · ' + c.chkDt + '</div>'
                + '</div>'
                + '<span class="badge ' + (CHK_BADGE[c.chkSttsCd] || "badge-gray") + '">' + (CHK_STTS[c.chkSttsCd] || "-") + '</span>'
                + '</div>';
        }).join("");

        /* 권한 신청 테이블 */
        document.getElementById("rqstTableBody").innerHTML = rqstData.map(function(r) {
            return '<tr>'
                + '<td>' + r.rqstNo + '</td>'
                + '<td class="td-bold">' + r.userNm + '</td>'
                + '<td>' + r.hoNo + '</td>'
                + '<td><span class="badge badge-blue">' + (RQST_TY[r.rqstTy] || r.rqstTy) + '</span></td>'
                + '<td>' + r.regDt + '</td>'
                + '<td><span class="badge ' + (RQST_BADGE[r.rqstSttsCd] || "badge-gray") + '">' + (RQST_STTS[r.rqstSttsCd] || "-") + '</span></td>'
                + '</tr>';
        }).join("");

    })();
</script>