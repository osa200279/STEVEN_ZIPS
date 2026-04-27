<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리사무소</title>
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

<div class="office-page" id="billChargePage">

  <div class="page-header">
    <div class="page-title-block">
      <h2>고지서 등록</h2>
      <p>단지별 관리비 고지서 및 항목 내역 일괄 생성 — BILL + BILL_DETAIL</p>
    </div>
  </div>

  <div style="display:grid; grid-template-columns:1fr 340px; gap:20px; align-items:start;">

    <!-- 좌: 입력 영역 -->
    <div style="display:flex; flex-direction:column; gap:14px;">

      <!-- ① 단지 선택 -->
      <div class="panel">
        <div class="panel-header">
          <h3 class="panel-title">
            <span class="material-symbols-rounded">apartment</span>
            단지 선택 (APT_CMPLEX_NO)
          </h3>
        </div>
        <div style="padding:0 20px 20px; display:flex; flex-direction:column; gap:12px;">
          <div style="display:grid; grid-template-columns:1fr auto; gap:10px; align-items:flex-end;">
            <div class="form-field">
              <label class="field-label">아파트 단지</label>
              <select class="form-select" id="aptCmplexNo">
                <option value="">단지를 선택하세요</option>
                <option value="APT-001">푸르지오 1단지 (APT-001)</option>
                <option value="APT-002">래미안 2단지 (APT-002)</option>
                <option value="APT-003">힐스테이트 3단지 (APT-003)</option>
              </select>
            </div>
            <button type="button" class="btn btn-primary" id="btnLoadComplex">조회</button>
          </div>

          <div id="complexInfo" style="display:none; background:#f0f7f2; border:1px solid #a8ccb0; border-radius:8px; padding:12px 16px;">
            <div style="display:grid; grid-template-columns:repeat(4,1fr); gap:10px; font-size:12px;">
              <div><div style="color:var(--text-tertiary); margin-bottom:2px;">단지명</div><div style="font-weight:700;" id="ciNm">—</div></div>
              <div><div style="color:var(--text-tertiary); margin-bottom:2px;">총 세대수 (UNIT_CNT)</div><div style="font-weight:700;" id="ciUnit">—</div></div>
              <div><div style="color:var(--text-tertiary); margin-bottom:2px;">동 수 (DONG_CNT)</div><div style="font-weight:700;" id="ciDong">—</div></div>
              <div><div style="color:var(--text-tertiary); margin-bottom:2px;">전월 미납</div><div style="font-weight:700; color:#d97706;" id="ciUnpaid">—</div></div>
            </div>
          </div>
        </div>
      </div>

      <!-- ② 부과 기본 설정 -->
      <div class="panel">
        <div class="panel-header">
          <h3 class="panel-title">
            <span class="material-symbols-rounded">calendar_month</span>
            부과 기본 설정 (BILL)
          </h3>
        </div>
        <div style="padding:0 20px 20px;">
          <div class="form-row cols-3">
            <div class="form-field">
              <label class="field-label">관리비 연월 (BILL_YM) <span class="req">*</span></label>
              <input type="month" class="form-input" id="billYm">
            </div>
            <div class="form-field">
              <label class="field-label">고지일자 (BILL_PBLANC_DT) <span class="req">*</span></label>
              <input type="date" class="form-input" id="billPblancDt">
            </div>
            <div class="form-field">
              <label class="field-label">납부기한 (DUE_DT) <span class="req">*</span></label>
              <input type="date" class="form-input" id="dueDt">
            </div>
          </div>
        </div>
      </div>

      <!-- ③ 항목별 금액 설정 -->
      <div class="panel">
        <div class="panel-header">
          <h3 class="panel-title">
            <span class="material-symbols-rounded">list_alt</span>
            항목별 금액 설정 (BILL_DETAIL)
          </h3>
          <button type="button" class="btn btn-sm btn-primary" id="btnAddItem">
            <span class="material-symbols-rounded" style="font-size:14px;">add</span>
            항목 추가
          </button>
        </div>
        <div style="padding:0 20px 4px;">
          <table style="width:100%; border-collapse:collapse;" id="itemTable">
            <thead>
            <tr style="border-bottom:1px solid var(--border);">
              <th style="padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary); text-align:left;">항목 코드 (BILL_ITEM_CD)</th>
              <th style="padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary); text-align:left; padding-left:10px;">항목명</th>
              <th style="padding:8px 0; font-size:11px; font-weight:700; color:var(--text-tertiary); text-align:right;">금액 (BILL_ITEM_AMT)</th>
              <th style="width:32px;"></th>
            </tr>
            </thead>
            <tbody id="itemTableBody"></tbody>
          </table>

          <!-- 합계 -->
          <div style="display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-top:1px solid var(--border); margin-top:4px;">
            <span style="font-size:12px; font-weight:700; color:var(--text-secondary);">BILL_TOT_AMT (자동 계산)</span>
            <span style="font-size:18px; font-weight:900; color:#2e5c38;" id="totalAmt">₩0</span>
          </div>

          <!-- 산출 근거 파일 -->
          <div class="form-field" style="margin-bottom:16px;">
            <label class="field-label">
              산출 근거 첨부 (BILL_DETAIL.ATCH_FILE_ID)
            </label>
            <div style="border:2px dashed var(--border); border-radius:8px; padding:16px; text-align:center; cursor:pointer; background:#fafafa;"
                 id="billFileTrigger">
              <span class="material-symbols-rounded" style="font-size:24px; color:var(--text-tertiary); display:block; margin-bottom:4px;">upload_file</span>
              <div style="font-size:12px; color:var(--text-secondary);">엑셀 또는 PDF 파일을 업로드하세요</div>
            </div>
            <input type="file" id="billAtchFile" accept=".xlsx,.xls,.pdf" style="display:none;">
            <div id="billAtchFileNm" style="font-size:12px; color:#2e5c38; margin-top:6px; display:none;"></div>
          </div>
        </div>
      </div>

      <!-- ④ 전월 미납 세대 현황 -->
      <div class="panel" id="unpaidPanel" style="display:none;">
        <div class="panel-header">
          <h3 class="panel-title">
            <span class="material-symbols-rounded">warning</span>
            전월 미납 세대 (PYMT_STTS_CD = UNPAID / OVERDUE)
          </h3>
          <span class="list-count" id="unpaidCount">0건</span>
        </div>
        <div class="table-wrap">
          <table class="tbl">
            <thead>
            <tr>
              <th>호번호 (HO_NO)</th>
              <th>부과월 (BILL_YM)</th>
              <th style="text-align:right;">미납 금액</th>
              <th style="text-align:right;">연체료 (LATE_FEE_AMT)</th>
              <th>상태</th>
            </tr>
            </thead>
            <tbody id="unpaidTableBody"></tbody>
          </table>
        </div>
        <div style="padding:10px 20px 16px; font-size:11px; color:var(--text-tertiary);">
          ※ 이번 고지서 생성 시 연체료(LATE_FEE_RT: 3%)가 자동 포함됩니다.
        </div>
      </div>

      <!-- ⑤ 생성 버튼 -->
      <button type="button" class="btn btn-primary" id="btnGenerate"
              style="width:100%; padding:14px; font-size:14px; font-weight:800; border-radius:10px;">
        <span class="material-symbols-rounded">receipt_long</span>
        BILL + BILL_DETAIL 일괄 생성
      </button>
    </div>

    <!-- 우: 고지서 미리보기 -->
    <div style="position:sticky; top:20px;">
      <div style="background:var(--card); border:1px solid var(--border); border-radius:14px; overflow:hidden; box-shadow:var(--shadow-sm);">

        <div style="background:#2e5c38; padding:16px 20px; display:flex; align-items:center; justify-content:space-between;">
          <div style="display:flex; align-items:center; gap:10px;">
            <div style="width:30px; height:30px; background:rgba(255,255,255,0.2); border-radius:8px; display:flex; align-items:center; justify-content:center;">
              <span class="material-symbols-rounded" style="color:#fff; font-size:16px;">home_work</span>
            </div>
            <div>
              <div style="font-size:13px; font-weight:800; color:#fff;">우리집맵핑</div>
              <div style="font-size:10px; color:rgba(255,255,255,0.65);">공식 관리비 고지서 (샘플)</div>
            </div>
          </div>
          <div style="font-size:10px; color:rgba(255,255,255,0.65); text-align:right;">
            <div>부과 연월</div>
            <div id="pvYm">—</div>
          </div>
        </div>

        <div style="padding:18px 20px; display:flex; flex-direction:column; gap:14px;">

          <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px;">
            <div style="background:#f7f8f9; border-radius:8px; padding:10px 12px;">
              <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">고지일</div>
              <div style="font-size:13px; font-weight:700;" id="pvPblancDt">—</div>
            </div>
            <div style="background:#f7f8f9; border-radius:8px; padding:10px 12px;">
              <div style="font-size:10px; color:var(--text-tertiary); margin-bottom:3px;">납부기한</div>
              <div style="font-size:13px; font-weight:700; color:#dc2626;" id="pvDueDt">—</div>
            </div>
          </div>

          <!-- 항목 목록 -->
          <div id="pvItems" style="display:flex; flex-direction:column; gap:6px; min-height:60px;">
            <div style="font-size:12px; color:var(--text-tertiary); text-align:center; padding:16px 0;">항목을 추가하면 여기에 표시됩니다.</div>
          </div>

          <!-- 합계 -->
          <div style="background:#2e5c38; border-radius:10px; padding:14px 16px; display:flex; align-items:center; justify-content:space-between;">
            <div style="font-size:11px; color:rgba(255,255,255,0.7);">총 납부 금액</div>
            <div style="font-size:20px; font-weight:900; color:#fff;" id="pvTotal">₩0</div>
          </div>

          <div style="font-size:10px; color:var(--text-tertiary); text-align:center;">
            ※ 샘플 미리보기입니다. 실제 발송 시 세대별로 생성됩니다.
          </div>
        </div>
      </div>
    </div>
  </div>

</div>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    var page = document.getElementById("billChargePage");
    if (!page) return;

    /* ── 더미 단지 정보 (APT_COMPLEX) ── */
    var complexData = {
      "APT-001": { nm:"푸르지오 1단지", unitCnt:480, dongCnt:6 },
      "APT-002": { nm:"래미안 2단지",   unitCnt:320, dongCnt:4 },
      "APT-003": { nm:"힐스테이트 3단지", unitCnt:560, dongCnt:7 }
    };

    /* ── 더미 전월 미납 (BILL: PYMT_STTS_CD = UNPAID/OVERDUE) ── */
    var unpaidData = {
      "APT-001": [
        { hoNo:"101-803",  billYm:"202603", billTotAmt:210000, lateFeeAmt:6300,  pymtSttsCd:"OVERDUE" },
        { hoNo:"102-501",  billYm:"202603", billTotAmt:185000, lateFeeAmt:0,     pymtSttsCd:"UNPAID"  },
        { hoNo:"103-1102", billYm:"202603", billTotAmt:230000, lateFeeAmt:6900,  pymtSttsCd:"OVERDUE" }
      ],
      "APT-002": [
        { hoNo:"201-402",  billYm:"202603", billTotAmt:195000, lateFeeAmt:0,     pymtSttsCd:"UNPAID"  }
      ],
      "APT-003": []
    };

    /* ── 기본 항목 (BILL_ITEM_CD) ── */
    var defaultItems = [
      { cd:"ELEC",   nm:"전기 요금",       amt:38920 },
      { cd:"WATER",  nm:"수도 요금",       amt:12400 },
      { cd:"GAS",    nm:"가스 요금",       amt:9000  },
      { cd:"COMMON", nm:"공용 관리비",     amt:45000 }
    ];

    var items = JSON.parse(JSON.stringify(defaultItems));

    var STTS_STYLE = {
      UNPAID:  { text:"미납",   bg:"#fff0e0", color:"#92400e" },
      OVERDUE: { text:"장기연체", bg:"#f5e8d0", color:"#6b3d0a" }
    };

    /* ── 단지 조회 ── */
    function loadComplex() {
      var cd = document.getElementById("aptCmplexNo").value;
      if (!cd) { alert("단지를 선택하세요."); return; }

      var info = complexData[cd];
      var unpaid = unpaidData[cd] || [];

      document.getElementById("complexInfo").style.display = "block";
      document.getElementById("ciNm").textContent    = info.nm;
      document.getElementById("ciUnit").textContent  = info.unitCnt.toLocaleString() + "세대";
      document.getElementById("ciDong").textContent  = info.dongCnt + "동";
      document.getElementById("ciUnpaid").textContent = unpaid.length + "건";

      /* 미납 패널 */
      if (unpaid.length > 0) {
        document.getElementById("unpaidPanel").style.display = "block";
        document.getElementById("unpaidCount").textContent = unpaid.length + "건";
        document.getElementById("unpaidTableBody").innerHTML = unpaid.map(function(r) {
          var s = STTS_STYLE[r.pymtSttsCd] || { text:"-", bg:"#f3f4f6", color:"#4b5563" };
          return '<tr>'
                  + '<td class="td-bold">' + r.hoNo + '</td>'
                  + '<td>' + r.billYm.slice(0,4) + "-" + r.billYm.slice(4) + '</td>'
                  + '<td style="text-align:right; font-weight:700; color:#dc2626;">₩' + r.billTotAmt.toLocaleString() + '</td>'
                  + '<td style="text-align:right; color:#d97706; font-weight:700;">'
                  + (r.lateFeeAmt > 0 ? '₩' + r.lateFeeAmt.toLocaleString() : '-') + '</td>'
                  + '<td><span style="display:inline-flex; padding:2px 8px; border-radius:4px; font-size:11px; font-weight:700; background:' + s.bg + '; color:' + s.color + ';">' + s.text + '</span></td>'
                  + '</tr>';
        }).join("");
        document.getElementById("unpaidPanel").style.display = "none";
      }
    }

    /* ── 항목 테이블 렌더 ── */
    function renderItems() {
      var tbody = document.getElementById("itemTableBody");
      tbody.innerHTML = items.map(function(item, idx) {
        return '<tr style="border-bottom:1px solid var(--border);">'
                + '<td style="padding:8px 0;">'
                + '<input type="text" class="form-input" style="height:32px; font-size:12px;" value="' + item.cd + '" '
                + 'data-field="cd" data-idx="' + idx + '" placeholder="예: ELEC"></td>'
                + '<td style="padding:8px 0 8px 10px;">'
                + '<input type="text" class="form-input" style="height:32px; font-size:12px;" value="' + item.nm + '" '
                + 'data-field="nm" data-idx="' + idx + '" placeholder="예: 전기 요금"></td>'
                + '<td style="padding:8px 0;">'
                + '<input type="number" class="form-input" style="height:32px; font-size:12px; text-align:right;" value="' + item.amt + '" '
                + 'data-field="amt" data-idx="' + idx + '" placeholder="0"></td>'
                + '<td style="padding:8px 0; text-align:center;">'
                + '<button type="button" style="border:none; background:none; color:#dc2626; cursor:pointer; font-size:18px; line-height:1;" data-action="removeItem" data-idx="' + idx + '">×</button>'
                + '</td>'
                + '</tr>';
      }).join("");

      calcTotal();
      updatePreview();
    }

    /* ── 합계 계산 ── */
    function calcTotal() {
      var total = items.reduce(function(s, item) { return s + (Number(item.amt) || 0); }, 0);
      document.getElementById("totalAmt").textContent = "₩" + total.toLocaleString();
      return total;
    }

    /* ── 미리보기 업데이트 ── */
    function updatePreview() {
      var ym       = document.getElementById("billYm").value;
      var pblancDt = document.getElementById("billPblancDt").value;
      var dueDt    = document.getElementById("dueDt").value;
      var total    = calcTotal();

      document.getElementById("pvYm").textContent      = ym      ? ym.replace("-","년 ") + "월" : "—";
      document.getElementById("pvPblancDt").textContent = pblancDt ? pblancDt.replace(/-/g,".") : "—";
      document.getElementById("pvDueDt").textContent    = dueDt    ? dueDt.replace(/-/g,".") : "—";
      document.getElementById("pvTotal").textContent    = "₩" + total.toLocaleString();

      var pvItems = document.getElementById("pvItems");
      if (items.length === 0) {
        pvItems.innerHTML = '<div style="font-size:12px; color:var(--text-tertiary); text-align:center; padding:16px 0;">항목을 추가하면 여기에 표시됩니다.</div>';
      } else {
        pvItems.innerHTML = '<div style="border-top:1px solid var(--border); padding-top:10px;">'
                + items.map(function(item) {
                  return '<div style="display:flex; justify-content:space-between; padding:6px 0; border-bottom:1px solid #f0f0f0; font-size:12px;">'
                          + '<span style="color:var(--text-secondary);">' + (item.nm || item.cd || "—") + '</span>'
                          + '<span style="font-weight:700;">₩' + (Number(item.amt)||0).toLocaleString() + '</span>'
                          + '</div>';
                }).join("") + '</div>';
      }
    }

    /* ── 이벤트 ── */
    document.getElementById("btnLoadComplex").addEventListener("click", loadComplex);

    ["billYm", "billPblancDt", "dueDt"].forEach(function(id) {
      document.getElementById(id).addEventListener("input", updatePreview);
    });

    document.getElementById("btnAddItem").addEventListener("click", function() {
      items.push({ cd:"", nm:"", amt:0 });
      renderItems();
    });

    /* 항목 테이블 인풋/삭제 이벤트 위임 */
    document.getElementById("itemTableBody").addEventListener("input", function(e) {
      var el = e.target;
      var field = el.dataset.field;
      var idx   = el.dataset.idx;
      if (field === undefined || idx === undefined) return;
      items[Number(idx)][field] = field === "amt" ? Number(el.value) || 0 : el.value;
      calcTotal();
      updatePreview();
    });

    document.getElementById("itemTableBody").addEventListener("click", function(e) {
      var btn = e.target.closest("[data-action='removeItem']");
      if (!btn) return;
      items.splice(Number(btn.dataset.idx), 1);
      renderItems();
    });

    document.getElementById("billFileTrigger").addEventListener("click", function () {
      document.getElementById("billAtchFile").click();
    });

    /* 파일 업로드 */
    document.getElementById("billAtchFile").addEventListener("change", function() {
      if (this.files.length > 0) {
        var nm = document.getElementById("billAtchFileNm");
        nm.style.display  = "block";
        nm.textContent    = "✓ " + this.files[0].name;
      }
    });

    /* 고지서 생성 */
    document.getElementById("btnGenerate").addEventListener("click", function() {
      var cd = document.getElementById("aptCmplexNo").value;
      if (!cd)   { alert("단지를 선택하세요."); return; }
      var ym = document.getElementById("billYm").value;
      if (!ym)   { alert("관리비 연월을 입력하세요."); return; }
      var pd = document.getElementById("billPblancDt").value;
      if (!pd)   { alert("고지일자를 입력하세요."); return; }
      var dd = document.getElementById("dueDt").value;
      if (!dd)   { alert("납부기한을 입력하세요."); return; }
      if (items.length === 0) { alert("항목을 1개 이상 추가하세요."); return; }
      alert("BILL + BILL_DETAIL 일괄 생성 처리 연결 예정입니다.");
    });

    /* 초기 렌더 */
    renderItems();
    updatePreview();
  });
</script>
        </main>
    </div>
</div>
</body>
</html>
