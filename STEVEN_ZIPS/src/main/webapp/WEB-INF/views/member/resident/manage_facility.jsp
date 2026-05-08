<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>시설관리이력 – 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">


<%-- 260509 시설 쪽 컬럼 정해지면 더미데이터 넣고 지울거임 -보라 --%>
<%--  /* =========================================================--%>
<%--  PARTNER 더미데이터--%>
<%--  시설 점검 / 공사 / 유지보수 업체--%>
<%--  ========================================================= */--%>

<%--  INSERT INTO partner (--%>
<%--  partner_no          /* 업체번호 */--%>
<%--  , apt_cmplex_no       /* 아파트단지번호 */--%>
<%--  , partner_nm          /* 업체명 */--%>
<%--  , biz_ty_nm           /* 업종명 */--%>
<%--  , bizrno              /* 사업자번호 */--%>
<%--  , pic_nm              /* 담당자명 */--%>
<%--  , pic_telno           /* 담당자연락처 */--%>
<%--  , pic_email           /* 담당자이메일 */--%>
<%--  , reg_dt              /* 등록일 */--%>
<%--  ) VALUES (--%>
<%--  'PTN00000000001'--%>
<%--  , 'A10022030'--%>
<%--  , '현대승강기관리'--%>
<%--  , '승강기 유지보수'--%>
<%--  , '101-81-52341'--%>
<%--  , '김민수'--%>
<%--  , '010-1234-1001'--%>
<%--  , 'lift@partner.com'--%>
<%--  , SYSDATE--%>
<%--  );--%>

<%--  INSERT INTO partner (--%>
<%--  partner_no--%>
<%--  , apt_cmplex_no--%>
<%--  , partner_nm--%>
<%--  , biz_ty_nm--%>
<%--  , bizrno--%>
<%--  , pic_nm--%>
<%--  , pic_telno--%>
<%--  , pic_email--%>
<%--  , reg_dt--%>
<%--  ) VALUES (--%>
<%--  'PTN00000000002'--%>
<%--  , 'A10022030'--%>
<%--  , '대한소방안전'--%>
<%--  , '소방 설비 점검'--%>
<%--  , '214-88-11235'--%>
<%--  , '이서연'--%>
<%--  , '010-2222-1002'--%>
<%--  , 'fire@partner.com'--%>
<%--  , SYSDATE--%>
<%--  );--%>

<%--  INSERT INTO partner (--%>
<%--  partner_no--%>
<%--  , apt_cmplex_no--%>
<%--  , partner_nm--%>
<%--  , biz_ty_nm--%>
<%--  , bizrno--%>
<%--  , pic_nm--%>
<%--  , pic_telno--%>
<%--  , pic_email--%>
<%--  , reg_dt--%>
<%--  ) VALUES (--%>
<%--  'PTN00000000003'--%>
<%--  , 'A10022030'--%>
<%--  , '그린급수설비'--%>
<%--  , '급수시설 유지관리'--%>
<%--  , '301-55-77231'--%>
<%--  , '박정훈'--%>
<%--  , '010-3333-1003'--%>
<%--  , 'water@partner.com'--%>
<%--  , SYSDATE--%>
<%--  );--%>

<%--  INSERT INTO partner (--%>
<%--  partner_no--%>
<%--  , apt_cmplex_no--%>
<%--  , partner_nm--%>
<%--  , biz_ty_nm--%>
<%--  , bizrno--%>
<%--  , pic_nm--%>
<%--  , pic_telno--%>
<%--  , pic_email--%>
<%--  , reg_dt--%>
<%--  ) VALUES (--%>
<%--  'PTN00000000004'--%>
<%--  , 'A10022033'--%>
<%--  , '스마트전기안전'--%>
<%--  , '전기설비 점검'--%>
<%--  , '120-44-66321'--%>
<%--  , '최현우'--%>
<%--  , '010-4444-1004'--%>
<%--  , 'electric@partner.com'--%>
<%--  , SYSDATE--%>
<%--  );--%>

<%--  INSERT INTO partner (--%>
<%--  partner_no--%>
<%--  , apt_cmplex_no--%>
<%--  , partner_nm--%>
<%--  , biz_ty_nm--%>
<%--  , bizrno--%>
<%--  , pic_nm--%>
<%--  , pic_telno--%>
<%--  , pic_email--%>
<%--  , reg_dt--%>
<%--  ) VALUES (--%>
<%--  'PTN00000000005'--%>
<%--  , 'A10022033'--%>
<%--  , '세이프보안시스템'--%>
<%--  , '보안시설 유지보수'--%>
<%--  , '555-77-99881'--%>
<%--  , '정다은'--%>
<%--  , '010-5555-1005'--%>
<%--  , 'security@partner.com'--%>
<%--  , SYSDATE--%>
<%--  );--%>

<%--  /* =========================================================--%>
<%--  FACILITY 더미데이터--%>
<%--  단지 시설 정보--%>
<%--  ========================================================= */--%>

<%--  INSERT INTO facility (--%>
<%--  facility_no         /* 시설번호 */--%>
<%--  , apt_cmplex_no       /* 아파트단지번호 */--%>
<%--  , facility_ty_cd      /* 시설유형코드 */--%>
<%--  , instl_dt            /* 설치일 */--%>
<%--  , facility_nm         /* 시설명 */--%>
<%--  , dong_no             /* 동번호 */--%>
<%--  , loc_cn              /* 위치내용 */--%>
<%--  , use_yn              /* 사용여부 */--%>
<%--  ) VALUES (--%>
<%--  'FAC00000000001'--%>
<%--  , 'A10022030'--%>
<%--  , 'ELV'--%>
<%--  , TO_DATE('2020-03-01', 'YYYY-MM-DD')--%>
<%--  , '101동 메인 승강기'--%>
<%--  , '101'--%>
<%--  , '101동 1라인'--%>
<%--  , 'Y'--%>
<%--  );--%>

<%--  INSERT INTO facility (--%>
<%--  facility_no--%>
<%--  , apt_cmplex_no--%>
<%--  , facility_ty_cd--%>
<%--  , instl_dt--%>
<%--  , facility_nm--%>
<%--  , dong_no--%>
<%--  , loc_cn--%>
<%--  , use_yn--%>
<%--  ) VALUES (--%>
<%--  'FAC00000000002'--%>
<%--  , 'A10022030'--%>
<%--  , 'FIRE'--%>
<%--  , TO_DATE('2021-05-10', 'YYYY-MM-DD')--%>
<%--  , '지하주차장 소방설비'--%>
<%--  , 'B1'--%>
<%--  , '지하주차장 전체'--%>
<%--  , 'Y'--%>
<%--  );--%>

<%--  INSERT INTO facility (--%>
<%--  facility_no--%>
<%--  , apt_cmplex_no--%>
<%--  , facility_ty_cd--%>
<%--  , instl_dt--%>
<%--  , facility_nm--%>
<%--  , dong_no--%>
<%--  , loc_cn--%>
<%--  , use_yn--%>
<%--  ) VALUES (--%>
<%--  'FAC00000000003'--%>
<%--  , 'A10022030'--%>
<%--  , 'WTR'--%>
<%--  , TO_DATE('2019-08-15', 'YYYY-MM-DD')--%>
<%--  , '저수조 급수시설'--%>
<%--  , '공용'--%>
<%--  , '관리동 뒤편'--%>
<%--  , 'Y'--%>
<%--  );--%>

<%--  INSERT INTO facility (--%>
<%--  facility_no--%>
<%--  , apt_cmplex_no--%>
<%--  , facility_ty_cd--%>
<%--  , instl_dt--%>
<%--  , facility_nm--%>
<%--  , dong_no--%>
<%--  , loc_cn--%>
<%--  , use_yn--%>
<%--  ) VALUES (--%>
<%--  'FAC00000000004'--%>
<%--  , 'A10022033'--%>
<%--  , 'ELC'--%>
<%--  , TO_DATE('2022-01-12', 'YYYY-MM-DD')--%>
<%--  , '전기 배전반'--%>
<%--  , '102'--%>
<%--  , '102동 전기실'--%>
<%--  , 'Y'--%>
<%--  );--%>

<%--  INSERT INTO facility (--%>
<%--  facility_no--%>
<%--  , apt_cmplex_no--%>
<%--  , facility_ty_cd--%>
<%--  , instl_dt--%>
<%--  , facility_nm--%>
<%--  , dong_no--%>
<%--  , loc_cn--%>
<%--  , use_yn--%>
<%--  ) VALUES (--%>
<%--  'FAC00000000005'--%>
<%--  , 'A10022033'--%>
<%--  , 'SEC'--%>
<%--  , TO_DATE('2023-02-01', 'YYYY-MM-DD')--%>
<%--  , 'CCTV 보안시스템'--%>
<%--  , '공용'--%>
<%--  , '정문 및 주차장'--%>
<%--  , 'Y'--%>
<%--  );--%>

<%--  INSERT INTO facility (--%>
<%--  facility_no--%>
<%--  , apt_cmplex_no--%>
<%--  , facility_ty_cd--%>
<%--  , instl_dt--%>
<%--  , facility_nm--%>
<%--  , dong_no--%>
<%--  , loc_cn--%>
<%--  , use_yn--%>
<%--  ) VALUES (--%>
<%--  'FAC00000000006'--%>
<%--  , 'A10022033'--%>
<%--  , 'GAS'--%>
<%--  , TO_DATE('2021-11-03', 'YYYY-MM-DD')--%>
<%--  , '가스 배관 시설'--%>
<%--  , '103'--%>
<%--  , '103동 외벽 라인'--%>
<%--  , 'Y'--%>
<%--  );--%>

<%--  INSERT INTO facility (--%>
<%--  facility_no--%>
<%--  , apt_cmplex_no--%>
<%--  , facility_ty_cd--%>
<%--  , instl_dt--%>
<%--  , facility_nm--%>
<%--  , dong_no--%>
<%--  , loc_cn--%>
<%--  , use_yn--%>
<%--  ) VALUES (--%>
<%--  'FAC00000000007'--%>
<%--  , 'A10022030'--%>
<%--  , 'ETC'--%>
<%--  , TO_DATE('2024-01-10', 'YYYY-MM-DD')--%>
<%--  , '주차장 LED 조명'--%>
<%--  , '지하1층'--%>
<%--  , '지하주차장'--%>
<%--  , 'Y'--%>
<%--  );--%>


  <style>
    body {font-family: 'Noto Sans KR', sans-serif !important;background: var(--bg);color: var(--text-dark);margin: 0;}
    .material-symbols-outlined { font-family: 'Material Symbols Outlined' !important; }
    .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
    .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
    .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
    .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
    .breadcrumb a {color:var(--text-light);text-decoration:none;} .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
    .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
    .page-desc {font-size:13px;line-height:1.8;color:var(--text-light);margin-bottom:24px;}
    .hero-card,.card,.panel {background:var(--white);border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}    
    .hero-card {padding:24px 28px;margin-bottom:20px;background:linear-gradient(135deg,var(--green-dark),#386a4d);color:#fff;}
    .hero-card h2 {font-size:20px;margin:0 0 8px;letter-spacing:-.3px;} .hero-card p {margin:0;line-height:1.8;color:rgba(255,255,255,.82);font-size:13px;}
    .chip-row {display:flex;gap:8px;flex-wrap:wrap;margin-top:14px;} .chip {display:inline-flex;align-items:center;gap:4px;padding:6px 12px;border-radius:999px;font-size:12px;font-weight:700;background:rgba(255,255,255,.18);color:#fff;}
    .stats-grid {display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:14px;margin-bottom:24px;} .stat-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:18px 18px 16px;}
    .stat-label {color:var(--text-light);font-size:12px;margin-bottom:8px;} .stat-value {font-size:24px;font-weight:800;color:var(--green-dark);letter-spacing:-.6px;} .stat-sub {margin-top:6px;font-size:12px;color:var(--text-light);}
    .grid-2 {display:grid;grid-template-columns:1.2fr .8fr;gap:18px;margin-bottom:22px;} .grid-2.equal {grid-template-columns:1fr 1fr;} .grid-3 {display:grid;grid-template-columns:repeat(3,1fr);gap:16px;margin-bottom:22px;}
    .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);} .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);} .section-hd span {font-size:12px;color:var(--text-light);} .card,.panel {padding:20px;margin-bottom:20px;}
    .bullet-list {margin:0;padding-left:18px;color:var(--text-mid);line-height:1.8;font-size:13px;} .bullet-list li + li {margin-top:6px;}
    .data-table {width:100%;border-collapse:collapse;font-size:13px;background:#fff;overflow:hidden;border-radius:12px;} .data-table thead th {background:var(--green-pale);color:var(--text-mid);padding:12px 14px;text-align:left;font-weight:700;border-bottom:1px solid var(--border);} .data-table tbody td {padding:13px 14px;border-bottom:1px solid #edf0eb;color:var(--text-dark);vertical-align:top;} .data-table tbody tr:last-child td {border-bottom:none;} .mini-table td,.mini-table th {padding:10px 12px !important;}
    .label-grid {display:grid;grid-template-columns:160px 1fr 160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;margin-bottom:18px;} .label-grid div {padding:13px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);font-size:13px;} .label-grid .th {background:var(--green-pale);color:var(--text-mid);font-weight:700;}
    .form-grid {display:grid;grid-template-columns:160px 1fr;border-top:1px solid var(--border);border-left:1px solid var(--border);overflow:hidden;border-radius:12px;} .form-grid .th,.form-grid .td {padding:14px 16px;border-right:1px solid var(--border);border-bottom:1px solid var(--border);} .form-grid .th {background:var(--green-pale);color:var(--text-mid);font-size:13px;font-weight:700;}
    .fake-input,.fake-select,.fake-textarea {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;} .fake-textarea {min-height:110px;resize:vertical;}
    .inline-fields {display:flex;gap:10px;flex-wrap:wrap;} .btn-row {display:flex;justify-content:center;gap:10px;margin-top:22px;flex-wrap:wrap;}
    .btn-main,.btn-sub,.btn-danger,.btn-ghost {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:none;cursor:pointer;box-sizing:border-box;} .btn-main {background:var(--green-dark);color:#fff;} .btn-sub {background:#edf5ef;color:var(--green-dark);} .btn-danger {background:#b64444;color:#fff;} .btn-ghost {background:#fff;color:var(--text-mid);border:1px solid var(--border);}
    .badge {display:inline-flex;align-items:center;padding:4px 10px;border-radius:999px;font-size:11px;font-weight:800;} .badge.ok {background:#ecf7ef;color:#2f7a4d;} .badge.wait {background:#fff5df;color:#9a6b00;} .badge.danger {background:#fbe8e8;color:#a23a3a;} .badge.info {background:#edf4fb;color:#2d6688;}
    .menu-grid {display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:16px;margin-bottom:24px;} .menu-card {background:#fff;border:1px solid var(--border);border-radius:14px;padding:20px;} .menu-card h4 {margin:0 0 8px;font-size:16px;color:var(--text-dark);} .menu-card p {margin:0 0 12px;font-size:13px;color:var(--text-light);line-height:1.7;} .menu-links {display:flex;flex-direction:column;gap:8px;} .menu-links a {text-decoration:none;color:var(--green-dark);font-size:13px;font-weight:700;}
    .seat-grid {display:grid;grid-template-columns:repeat(6,1fr);gap:10px;margin-top:10px;} .room-grid {display:grid;grid-template-columns:repeat(3,1fr);gap:10px;margin-top:10px;} .seat,.room-box {padding:16px 8px;text-align:center;border-radius:12px;font-weight:700;font-size:13px;border:1px solid var(--border);background:#fff;} .seat.available,.room-box.available {background:#f1f8f2;color:#2a6d44;} .seat.busy,.room-box.busy {background:#f8ecec;color:#9f4747;} .seat.selected,.room-box.selected {background:var(--green-dark);color:#fff;}
    .chart-box {height:240px;border:1px dashed #cfd7cf;border-radius:12px;background:linear-gradient(to top,rgba(43,103,78,.08),rgba(43,103,78,.02)),repeating-linear-gradient(to right,transparent 0 72px,rgba(0,0,0,.03) 72px 73px),repeating-linear-gradient(to bottom,transparent 0 47px,rgba(0,0,0,.04) 47px 48px);position:relative;overflow:hidden;} .chart-line {position:absolute;left:22px;right:22px;bottom:26px;top:28px;} .chart-line svg {width:100%;height:100%;}
    .chat-layout {display:grid;grid-template-columns:320px 1fr;gap:18px;} .chat-list,.chat-box {background:#fff;border:1px solid var(--border);border-radius:14px;} .chat-list {padding:16px;} .chat-box {padding:18px;} .chat-room-item {padding:12px 10px;border-radius:10px;cursor:pointer;border:1px solid transparent;} .chat-room-item.active {background:#f4f8f5;border-color:#d8e6db;} .message-stream {display:flex;flex-direction:column;gap:12px;min-height:320px;} .message {max-width:72%;padding:12px 14px;border-radius:14px;font-size:13px;line-height:1.7;} .message.me {align-self:flex-end;background:var(--green-dark);color:#fff;} .message.other {align-self:flex-start;background:#f2f4f0;color:var(--text-dark);}
    .search-row {display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px;} .search-row .fake-input,.search-row .fake-select {max-width:220px;} .notice-card {padding:18px 20px;border-radius:14px;background:linear-gradient(135deg,#fff8ea,#fff1d5);border:1px solid #f0dfb4;margin-bottom:18px;}
    .process-grid {display:grid;grid-template-columns:repeat(4,1fr);gap:14px;} .process-step {padding:18px 14px;border-radius:14px;border:1px solid var(--border);background:#fff;text-align:center;} .process-step.active {background:#eef8f0;border-color:#b8d9c0;}
    @media (max-width:1200px){.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid{grid-template-columns:repeat(2,1fr)} .grid-2,.grid-2.equal,.chat-layout{grid-template-columns:1fr} .label-grid{grid-template-columns:140px 1fr}}
    @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}.stats-grid,.menu-grid,.grid-3,.room-grid,.process-grid,.seat-grid{grid-template-columns:1fr}.form-grid{grid-template-columns:120px 1fr}.label-grid{grid-template-columns:120px 1fr}}
  </style>

</head>
<body>
  <%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
  <div class="main-shell">
    <%@ include file="/WEB-INF/views/include/sidebarLayout.jsp" %>
    <main class="content-area">
      <div class="page-content-wrap">
        <div class="breadcrumb">
          <a href="${pageContext.request.contextPath}/">HOME</a>
          <span>›</span>
          <a href="javascript:void(0);">관리사무소</a>
          <span>›</span>
          <span class="cur">시설관리이력</span>
        </div>
        <h1 class="page-title">시설관리이력</h1>

        <section class="hero-card">
          <h2>주요 시설 점검 현황</h2>
          <p>승강기, 소방설비, 급수시설, 전기설비의 최근 점검 상태를 카드형 UI로 제공하고, 하단에서 상세 점검 내역을 확인할 수 있습니다.</p>
          <div class="chip-row">
            <span class="chip">정기점검</span>
            <span class="chip">상태 모니터링</span>
            <span class="chip">관리비 납부 연결</span>
          </div>
        </section>
        <section class="stats-grid">
          <div class="stat-card">
            <div class="stat-label">승강기</div>
            <div class="stat-value">정상</div>
            <div class="stat-sub">최근 점검 2026-04-12</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">소방설비</div>
            <div class="stat-value">점검완료</div>
            <div class="stat-sub">정밀 점검 이상 없음</div>
          </div>
          <div class="stat-card">
          <div class="stat-label">급수시설</div>
            <div class="stat-value">양호</div>
            <div class="stat-sub">수질 검사 통과</div>
          </div><div class="stat-card">
          <div class="stat-label">전기설비</div>
          <div class="stat-value">정상</div>
          <div class="stat-sub">부하 점검 완료</div>
        </div>
        </section>
        <section class="panel">
          <div class="section-hd">
            <h3>상세 점검 내역</h3>
            <span>최근 5건</span>
          </div>
          <table class="data-table">
            <thead>
            <tr>
              <th>점검일</th>
              <th>구분</th>
              <th>세부 내용</th>
              <th>상태</th>
              <th>담당자</th>
            </tr>
            </thead>
            <tbody>
            <tr>
              <td>2026-04-12</td>
              <td>승강기</td>
              <td>운행 상태 및 비상통화 장치 점검</td>
              <td>
                <span class="badge ok">정상</span>
              </td>
              <td>시설팀 김민수</td>
            </tr>
            <tr>
              <td>2026-04-11</td>
              <td>소방설비</td>
              <td>소화전 압력 및 경보 설비 테스트</td>
              <td>
                <span class="badge ok">완료</span>
              </td>
              <td>안전팀 이서연</td>
            </tr>
            <tr>
              <td>2026-04-09</td>
              <td>급수시설</td>
              <td>저수조 청소 및 배관 점검</td>
              <td>
                <span class="badge ok">양호</span>
              </td>
              <td>외부업체</td>
            </tr>
            <tr>
              <td>2026-04-07</td>
              <td>전기설비</td>
              <td>비상 발전기 시운전 및 패널 확인</td>
              <td><span class="badge ok">정상</span></td>
              <td>전기실 박정훈</td>
            </tr>
            <tr>
              <td>2026-04-04</td>
              <td>공용부</td>
              <td>주차장 조명 교체 이력 등록</td>
              <td><span class="badge info">처리완료</span></td>
              <td>관리사무소</td>
            </tr>
            </tbody>
          </table>
        </section>

      </div>
    </main>
  </div>
  <%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
</html>
