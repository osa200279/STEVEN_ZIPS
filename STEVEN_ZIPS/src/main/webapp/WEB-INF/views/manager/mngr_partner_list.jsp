<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
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

    <style>
        /* ─────────────────────────────────────────────────────
           협력업체 관리  ·  전문적 톤 보정
           - 본문 배경을 사이드바 다크그린과 연결되는 깊이로
           - 라운딩·그림자 최소화, 테이블 타이트, 컬러 절제
        ───────────────────────────────────────────────────── */

        /* ── 배경 : 사이드바 #1a2e1e 와 이어지는 구조감 ── */
        #partnerPage {
            --accent:        #265c30;
            --accent-light:  #dceee0;
            --accent-dim:    rgba(38,92,48,.08);
            --surface:       #ffffff;
            --surface-sub:   #f7f8f6;   /* 아주 살짝 그린-그레이 */
            --line:          #e3e6e2;
            --th-bg:         #f0f2ef;
            --text-head:     #1a2e1e;   /* 사이드바 배경색 → 헤딩 강조 */
        }

        /* 페이지 타이틀을 사이드바와 같은 다크그린으로 */
        #partnerPage .page-title-block h2 {
            color: var(--text-head);
            font-size: 19px;
            letter-spacing: -0.5px;
        }
        #partnerPage .page-title-block p {
            color: #6b7a6e;
            font-size: 12px;
        }

        /* ── 요약 카드 : 더 조밀하게, 그림자 제거 ── */
        #partnerPage .summary-row {
            gap: 10px;
            margin-bottom: 18px;
        }
        #partnerPage .summary-card {
            padding: 14px 18px;
            border-radius: 6px;
            border: 1px solid var(--line);
            box-shadow: none;
            gap: 12px;
        }
        #partnerPage .summary-card .s-icon {
            width: 36px; height: 36px;
            border-radius: 6px;
        }
        #partnerPage .summary-card .s-val {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-head);
        }
        #partnerPage .summary-card .s-label {
            font-size: 11px;
            color: #7a8a7d;
            margin-top: 2px;
        }
        /* 첫 번째 카드(총 업체)만 다크그린 accent */
        #partnerPage .summary-card.s-green {
            background: var(--accent);
            border-color: #1a3d1f;
        }
        #partnerPage .summary-card.s-green .s-icon {
            background: rgba(255,255,255,.15);
        }
        #partnerPage .summary-card.s-green .s-icon .material-symbols-rounded { color: #fff; }
        #partnerPage .summary-card.s-green .s-val   { color: #fff; }
        #partnerPage .summary-card.s-green .s-label { color: rgba(255,255,255,.65); }

        /* ── 만료 배너 ── */
        #partnerPage .expire-banner {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 10px 14px;
            background: #fffbeb;
            border-left: 3px solid #f59e0b;
            border-top: 1px solid #fde68a;
            border-bottom: 1px solid #fde68a;
            border-right: 1px solid #fde68a;
            border-radius: 0 4px 4px 0;
            margin-bottom: 16px;
            font-size: 12px;
        }
        #partnerPage .expire-banner > .material-symbols-rounded { color: #b45309; font-size: 16px; flex-shrink:0; margin-top:2px; }
        #partnerPage .expire-banner strong { color: #78350f; }
        #partnerPage .expire-chips { display: flex; gap: 5px; flex-wrap: wrap; margin-top: 5px; }
        #partnerPage .expire-chip {
            background: #fef9c3; border: 1px solid #fde047;
            border-radius: 3px; padding: 1px 7px;
            font-size: 11px; font-weight: 700; color: #713f12;
            cursor: pointer; transition: background .12s;
        }
        #partnerPage .expire-chip:hover { background: #fef08a; }

        /* ── 패널 : 라운딩·그림자 절제 ── */
        #partnerPage .panel {
            border-radius: 6px;
            border: 1px solid var(--line);
            box-shadow: none;
            margin-top: 0;
            margin-bottom: 0;
        }

        /* ── 인라인 필터 (패널 상단) ── */
        #partnerPage .inpanel-filter {
            display: flex; gap: 7px; align-items: center; flex-wrap: wrap;
            padding: 10px 16px;
            border-bottom: 1px solid var(--line);
            background: var(--surface-sub);
            border-radius: 6px 6px 0 0;
        }
        #partnerPage .inpanel-filter .form-input,
        #partnerPage .inpanel-filter .form-select {
            height: 30px; font-size: 12px;
            border-color: var(--line);
            background: var(--surface);
            border-radius: 4px;
        }
        #partnerPage .inpanel-filter .form-input:focus,
        #partnerPage .inpanel-filter .form-select:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 2px var(--accent-dim);
        }
        #partnerPage .inpanel-filter .btn {
            min-height: 30px; font-size: 12px; padding: 0 12px; border-radius: 4px;
        }
        #partnerPage .inpanel-filter .search-wrap { position: relative; }
        #partnerPage .inpanel-filter .search-wrap .material-symbols-rounded {
            position: absolute; left: 8px; top: 50%; transform: translateY(-50%);
            font-size: 14px; color: #9caa9e; pointer-events: none;
        }
        #partnerPage .inpanel-filter .search-wrap input { padding-left: 28px; width: 230px; }
        #partnerPage .inpanel-filter .list-count {
            margin-left: auto;
            font-size: 11px; font-weight: 700;
            color: var(--accent);
            background: var(--accent-light);
            border-radius: 3px; padding: 2px 8px;
        }

        /* ── 테이블 : 더 타이트하게 ── */
        #partnerPage .table-wrap { padding: 0; overflow-x: auto; }
        #partnerPage .tbl { font-size: 12px; }
        #partnerPage thead th {
            padding: 9px 14px;
            background: var(--th-bg);
            border-bottom: 1px solid var(--line);
            color: #4a5c4e;
            font-size: 11px;
            font-weight: 700;
            text-transform: none;
            letter-spacing: 0;
            white-space: nowrap;
        }
        #partnerPage thead th small {
            display: block;
            font-weight: 400;
            color: #9caa9e;
            font-size: 10px;
            margin-top: 1px;
            font-family: 'SF Mono', 'Consolas', monospace;
        }
        #partnerPage tbody td {
            padding: 10px 14px;
            border-bottom: 1px solid var(--line);
            color: #374151;
            vertical-align: middle;
        }
        #partnerPage tbody tr:last-child td { border-bottom: none; }
        #partnerPage tbody tr:hover td { background: #f4f7f4; }
        #partnerPage .td-bold { font-weight: 600; color: #111827; }
        #partnerPage .td-mono { font-family: 'SF Mono','Consolas',monospace; font-size: 11px; color: #6b7a6e; }

        /* ── 배지 ── */
        #partnerPage .badge {
            padding: 2px 7px; border-radius: 3px;
            font-size: 11px; font-weight: 700;
        }
        #partnerPage .badge-green  { background: #dceee0; color: #1a3d1f; }
        #partnerPage .badge-yellow { background: #fef3c7; color: #713f12; }
        #partnerPage .badge-red    { background: #fee2e2; color: #7f1d1d; }
        #partnerPage .badge-gray   { background: #e9ece9; color: #374151; }
        #partnerPage .badge-blue   { background: #dbeafe; color: #1e3a5f; }
        #partnerPage .badge-orange { background: #ffedd5; color: #7c2d12; }
        #partnerPage .badge-purple { background: #ede9fe; color: #4c1d95; }

        /* ── D-Day ── */
        #partnerPage .dday { display:inline-block; padding:1px 5px; border-radius:2px; font-size:10px; font-weight:800; font-family:monospace; }
        #partnerPage .dday-danger { background:#fee2e2; color:#991b1b; }
        #partnerPage .dday-warn   { background:#fef3c7; color:#7c4a0a; }

        /* ── 버튼 ── */
        #partnerPage .btn { border-radius: 4px; }
        #partnerPage .btn-primary   { background: var(--accent); }
        #partnerPage .btn-primary:hover { background: #1a3d1f; }
        #partnerPage .btn-secondary { border-color: var(--line); }
        #partnerPage .col-center { text-align: center !important; }
        #partnerPage .col-right  { text-align: right  !important; }
        #partnerPage .col-manage { text-align: center !important; width: 110px; }
        #partnerPage .grid-actions { display: inline-flex; gap: 5px; }
        #partnerPage .empty-row { text-align:center !important; color:#9caa9e; padding:40px !important; font-size:13px; }

        /* ── 모달 ── */
        #partnerPage ~ .modal-overlay .modal { border-radius: 6px; }
        .modal { border-radius: 6px !important; }
        .modal-header { border-bottom: 2px solid var(--line, #e3e6e2); }
        .modal-header.primary { background: #1a2e1e; }
        .modal-header.primary .modal-title { color: #fff; }
        .modal-header.primary .modal-close { color: rgba(255,255,255,.6); border-color: rgba(255,255,255,.15); background: rgba(255,255,255,.08); }
        .modal-header.primary .modal-close:hover { background: rgba(255,255,255,.15); color: #fff; }

        .form-section-title { letter-spacing: 0; text-transform: none; font-size: 11px; font-weight: 800; color: #4a5c4e; }

        /* 삭제 경고 */
        #partnerPage .del-warn {
            display: flex; gap: 10px; padding: 11px 13px;
            background: #fff5f5; border-left: 3px solid #ef4444;
            border-top: 1px solid #fecaca; border-bottom: 1px solid #fecaca; border-right: 1px solid #fecaca;
            border-radius: 0 4px 4px 0; margin-bottom: 14px;
            font-size: 12px; color: #7f1d1d; line-height: 1.6;
        }
        #partnerPage .del-warn .material-symbols-rounded { color: #dc2626; font-size:16px; flex-shrink:0; margin-top:2px; }

        /* 첨부 드롭존 */
        #partnerPage .file-drop {
            border: 1px dashed #c8d5ca; border-radius: 4px;
            padding: 16px; text-align: center; cursor: pointer;
            color: #9caa9e; font-size: 12px; transition: .14s;
        }
        #partnerPage .file-drop:hover { border-color: var(--accent); background:#f4f9f5; color:var(--accent); }
        #partnerPage .file-drop .material-symbols-rounded { font-size:20px; display:block; margin-bottom:3px; }
        #partnerPage .file-list { margin-top:7px; display:flex; flex-direction:column; gap:3px; }
        #partnerPage .file-item {
            display:flex; align-items:center; gap:6px;
            padding:4px 9px; background:var(--surface-sub);
            border:1px solid var(--line); border-radius:3px; font-size:11px; color:#4a5c4e;
        }
        #partnerPage .file-item .material-symbols-rounded { font-size:13px; color:var(--accent); }
        #partnerPage .file-item .f-name { flex:1; }
        #partnerPage .file-remove { background:none; border:none; cursor:pointer; color:#9caa9e; display:flex; padding:0; }
        #partnerPage .file-remove:hover { color:#dc2626; }
    </style>

    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="partnerPage">

                <!-- 페이지 헤더 -->
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>협력업체 관리</h2>
                        <p>등록 업체·계약 현황·점검 참여이력을 조회하고 관리합니다</p>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-primary" data-action="openRegister">
                            <span class="material-symbols-rounded">add</span>업체 등록
                        </button>
                    </div>
                </div>

                <!-- ══ 요약 카드 ══ -->
                <div class="summary-row">
                    <%-- PARTNER 전체 --%>
                    <div class="summary-card s-green">
                        <div class="s-icon"><span class="material-symbols-rounded">store</span></div>
                        <div>
                            <div class="s-val" id="statTotal">0</div>
                            <div class="s-label">등록 업체 · PARTNER</div>
                        </div>
                    </div>
                    <%-- CONT_STTS_CD = ACTIVE --%>
                    <div class="summary-card s-blue">
                        <div class="s-icon"><span class="material-symbols-rounded">handshake</span></div>
                        <div>
                            <div class="s-val" id="statActive">0</div>
                            <div class="s-label">유효 계약 · CONT_STTS=ACTIVE</div>
                        </div>
                    </div>
                    <%-- CONT_END_DT ≤ 30일 --%>
                    <div class="summary-card s-yellow">
                        <div class="s-icon"><span class="material-symbols-rounded">event_upcoming</span></div>
                        <div>
                            <div class="s-val" id="statExpire">0</div>
                            <div class="s-label">30일 내 만료 · CONT_END_DT</div>
                        </div>
                    </div>
                    <%-- CONT_STTS_CD = END --%>
                    <div class="summary-card s-gray">
                        <div class="s-icon"><span class="material-symbols-rounded">contract_delete</span></div>
                        <div>
                            <div class="s-val" id="statEnd">0</div>
                            <div class="s-label">계약 종료 · CONT_STTS=END</div>
                        </div>
                    </div>
                </div>

                <!-- 만료 배너 -->
                <div class="expire-banner" id="expireBanner" style="display:none;">
                    <span class="material-symbols-rounded">notification_important</span>
                    <div>
                        <strong id="expireBannerText"></strong>
                        <div class="expire-chips" id="expireChips"></div>
                    </div>
                </div>

                <!-- ══ 탭 ══ -->
                <div class="tab-bar">
                    <button type="button" class="tab-btn active" data-tab="tab-partner">
                        <span class="material-symbols-rounded">store</span>업체 조회
                    </button>
                    <button type="button" class="tab-btn" data-tab="tab-contract">
                        <span class="material-symbols-rounded">description</span>계약 현황
                    </button>
                    <button type="button" class="tab-btn" data-tab="tab-history">
                        <span class="material-symbols-rounded">history</span>점검 참여이력
                    </button>
                </div>

                <!-- ══════════════════════════════════════
                     탭 1 : 업체 조회
                     ERD  : PARTNER
                     PK   PARTNER_NO       VARCHAR2(15)
                     FK   APT_CMPLEX_NO    VARCHAR2(15)
                          PARTNER_NM       VARCHAR2(100) NOT NULL
                          BIZ_TY_NM        VARCHAR2(100) NOT NULL
                          BIZRNO           VARCHAR2(20)  NOT NULL
                          PIC_NM           VARCHAR2(20)
                          PIC_TELNO        VARCHAR2(20)
                          PIC_EMAIL        VARCHAR2(50)
                          REG_DT           DATE  DEFAULT SYSDATE
                          MDF_DT           DATE
                ══════════════════════════════════════ -->
                <div class="tab-panel active" id="tab-partner">
                    <div class="panel">
                        <div class="inpanel-filter">
                            <%-- BIZ_TY_NM --%>
                            <select class="form-select" id="filterBizTy" style="width:110px;">
                                <option value="">업종 전체</option>
                                <option>승강기</option><option>소방</option><option>전기</option>
                                <option>가스</option><option>급수</option><option>보안</option>
                                <option>청소</option><option>기타</option>
                            </select>
                            <%-- CONT_STTS_CD (공통코드 CONTRACT_STTS) --%>
                            <select class="form-select" id="filterContStts" style="width:110px;">
                                <option value="">계약상태 전체</option>
                                <option value="ACTIVE">유효</option>
                                <option value="EXPIRE">만료예정</option>
                                <option value="END">종료</option>
                                <option value="TERM">해지</option>
                                <option value="DRAFT">작성중</option>
                            </select>
                            <%-- PARTNER_NM / PIC_NM / BIZRNO --%>
                            <div class="search-wrap">
                                <span class="material-symbols-rounded">search</span>
                                <input type="text" class="form-input" id="filterKeyword" placeholder="업체명, 담당자, 사업자번호">
                            </div>
                            <button type="button" class="btn btn-primary btn-sm"   data-action="searchPartner">조회</button>
                            <button type="button" class="btn btn-secondary btn-sm" data-action="resetPartner">초기화</button>
                            <span class="list-count" id="partnerCount">0건</span>
                        </div>
                        <div class="table-wrap">
                            <table class="tbl">
                                <thead>
                                <tr>
                                    <th>업체번호<small>PARTNER_NO</small></th>
                                    <th>업체명<small>PARTNER_NM</small></th>
                                    <th>업종<small>BIZ_TY_NM</small></th>
                                    <th>사업자번호<small>BIZRNO</small></th>
                                    <th>담당자<small>PIC_NM · PIC_TELNO</small></th>
                                    <th>계약명<small>CONT_NM</small></th>
                                    <th class="col-right">계약금액<small>CONT_AMT</small></th>
                                    <th class="col-center">계약기간<small>BGNG~END_DT</small></th>
                                    <th class="col-center">상태<small>CONT_STTS_CD</small></th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="partnerTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     탭 2 : 계약 현황
                     ERD  : FACILITY_CONTRACT
                     PK   CONT_NO          VARCHAR2(15)
                     FK   FACILITY_NO      VARCHAR2(15) → FACILITY
                     FK   PARTNER_NO       VARCHAR2(15) → PARTNER
                          CONT_NM          VARCHAR2(200) NOT NULL
                          BID_TY_CD        VARCHAR2(20)  NOT NULL
                            공통코드 BID_TY
                            GEN 일반경쟁입찰 / LIM 제한경쟁입찰
                            SEL 지명경쟁입찰 / PRT 수의계약
                          CONT_DT          DATE
                          CONT_STTS_CD     VARCHAR2(50)
                            공통코드 CONTRACT_STTS
                            DRAFT / ACTIVE / END / TERM
                          CONT_AMT         NUMBER(15) NOT NULL
                          PYMT_DT          DATE
                          CONT_BGNG_DT     DATE NOT NULL
                          CONT_END_DT      DATE
                ══════════════════════════════════════ -->
                <div class="tab-panel" id="tab-contract">
                    <div class="panel">
                        <div class="inpanel-filter">
                            <select class="form-select" id="filterContStts2" style="width:110px;">
                                <option value="">계약상태 전체</option>
                                <option value="ACTIVE">유효</option>
                                <option value="EXPIRE">만료예정</option>
                                <option value="END">종료</option>
                                <option value="TERM">해지</option>
                                <option value="DRAFT">작성중</option>
                            </select>
                            <select class="form-select" id="filterBidTy" style="width:120px;">
                                <option value="">입찰유형 전체</option>
                                <option value="GEN">일반경쟁입찰</option>
                                <option value="LIM">제한경쟁입찰</option>
                                <option value="SEL">지명경쟁입찰</option>
                                <option value="PRT">수의계약</option>
                            </select>
                            <input type="date" class="form-input" id="filterContStart" style="width:132px;">
                            <span style="font-size:11px;color:#9caa9e;">~</span>
                            <input type="date" class="form-input" id="filterContEnd"   style="width:132px;">
                            <div class="search-wrap">
                                <span class="material-symbols-rounded">search</span>
                                <input type="text" class="form-input" id="filterContKeyword" placeholder="계약명, 업체명">
                            </div>
                            <button type="button" class="btn btn-primary btn-sm"   data-action="searchContract">조회</button>
                            <button type="button" class="btn btn-secondary btn-sm" data-action="resetContract">초기화</button>
                            <span class="list-count" id="contractCount">0건</span>
                            <button type="button" class="btn btn-primary btn-sm" data-action="openRegister" style="margin-left:4px;">
                                <span class="material-symbols-rounded">add</span>계약 등록
                            </button>
                        </div>
                        <div class="table-wrap">
                            <table class="tbl">
                                <thead>
                                <tr>
                                    <th>계약번호<small>CONT_NO</small></th>
                                    <th>계약명<small>CONT_NM</small></th>
                                    <th>업체명<small>PARTNER_NO→NM</small></th>
                                    <th class="col-center">시설<small>FACILITY_NO</small></th>
                                    <th class="col-center">입찰유형<small>BID_TY_CD</small></th>
                                    <th class="col-right">계약금액<small>CONT_AMT</small></th>
                                    <th class="col-center">계약기간<small>BGNG~END_DT</small></th>
                                    <th class="col-center">상태<small>CONT_STTS_CD</small></th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="contractTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     탭 3 : 점검 참여이력
                     ERD  : FACILITY_CHECK_HSTRY
                     PK   FAC_CHK_HSTRY_NO  VARCHAR2(15)
                     FK   FACILITY_NO        VARCHAR2(15) → FACILITY
                     FK   PARTNER_NO         VARCHAR2(15) → PARTNER
                          CHK_DT             DATE
                          CHK_TY_CD          VARCHAR2(20)
                            공통코드 CHECK_TY
                            REG / SPC / SAFE / REPAIR
                          CHK_STTS_CD        VARCHAR2(20)
                            공통코드 CHECK_STTS
                            WAIT / ING / DONE / FAULT
                          CHK_CN             VARCHAR2(1000)
                          RMK                VARCHAR2(500)
                          REG_DT             DATE  DEFAULT SYSDATE
                          MDF_DT             DATE
                ══════════════════════════════════════ -->
                <div class="tab-panel" id="tab-history">
                    <div class="panel">
                        <div class="inpanel-filter">
                            <select class="form-select" id="filterChkTy" style="width:110px;">
                                <option value="">점검유형 전체</option>
                                <option value="REG">정기점검</option>
                                <option value="SPC">특별점검</option>
                                <option value="SAFE">안전점검</option>
                                <option value="REPAIR">보수점검</option>
                            </select>
                            <select class="form-select" id="filterChkStts" style="width:110px;">
                                <option value="">점검상태 전체</option>
                                <option value="WAIT">점검대기</option>
                                <option value="ING">점검중</option>
                                <option value="DONE">점검완료</option>
                                <option value="FAULT">이상발견</option>
                            </select>
                            <input type="date" class="form-input" id="filterChkStart" style="width:132px;">
                            <span style="font-size:11px;color:#9caa9e;">~</span>
                            <input type="date" class="form-input" id="filterChkEnd"   style="width:132px;">
                            <div class="search-wrap">
                                <span class="material-symbols-rounded">search</span>
                                <input type="text" class="form-input" id="filterChkKeyword" placeholder="업체명, 시설번호">
                            </div>
                            <button type="button" class="btn btn-primary btn-sm"   data-action="searchHistory">조회</button>
                            <button type="button" class="btn btn-secondary btn-sm" data-action="resetHistory">초기화</button>
                            <span class="list-count" id="historyCount">0건</span>
                        </div>
                        <div class="table-wrap">
                            <table class="tbl">
                                <thead>
                                <tr>
                                    <th>이력번호<small>FAC_CHK_HSTRY_NO</small></th>
                                    <th>업체명<small>PARTNER_NO→NM</small></th>
                                    <th>시설번호<small>FACILITY_NO</small></th>
                                    <th class="col-center">점검유형<small>CHK_TY_CD</small></th>
                                    <th class="col-center">점검일자<small>CHK_DT</small></th>
                                    <th class="col-center">점검상태<small>CHK_STTS_CD</small></th>
                                    <th>점검내용<small>CHK_CN</small></th>
                                    <th>비고<small>RMK</small></th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="historyTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- ══ 모달 : 업체 등록·상세·수정 ══ -->
                <div class="modal-overlay" id="partnerModal">
                    <div class="modal modal-lg">
                        <div class="modal-header primary">
                            <h3 class="modal-title" id="partnerModalTitle">협력업체 등록</h3>
                            <button type="button" class="modal-close" data-action="closePartnerModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="partnerForm">
                            <div class="modal-body">

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">store</span>
                                        업체 기본 정보 · PARTNER
                                    </div>
                                    <input type="hidden" id="partnerNo">
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">업체명 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">PARTNER_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="partnerNm" placeholder="예) (주)대한엘리베이터" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">업종 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">BIZ_TY_NM</small>
                                            </label>
                                            <select class="form-select" id="bizTyNm" required>
                                                <option value="">선택</option>
                                                <option>승강기</option><option>소방</option><option>전기</option>
                                                <option>가스</option><option>급수</option><option>보안</option>
                                                <option>청소</option><option>기타</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-3">
                                        <div class="form-field">
                                            <label class="field-label">사업자등록번호 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">BIZRNO</small>
                                            </label>
                                            <input type="text" class="form-input" id="bizrno" placeholder="000-00-00000" maxlength="12" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">담당자명
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">PIC_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="picNm" placeholder="홍길동">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">연락처
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">PIC_TELNO</small>
                                            </label>
                                            <input type="text" class="form-input" id="picTelno" placeholder="010-0000-0000">
                                        </div>
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">이메일
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">PIC_EMAIL</small>
                                            </label>
                                            <input type="email" class="form-input" id="picEmail" placeholder="example@company.com">
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">description</span>
                                        계약 정보 · FACILITY_CONTRACT
                                    </div>
                                    <input type="hidden" id="contNo">
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">계약명 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">CONT_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="contNm" placeholder="예) 2026년 승강기 유지보수 계약" required>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">대상 시설 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">FACILITY_NO</small>
                                            </label>
                                            <select class="form-select" id="facilityNo" required>
                                                <option value="">선택</option>
                                                <option value="FAC-001">FAC-001 · 1호기 승강기</option>
                                                <option value="FAC-002">FAC-002 · 2호기 승강기</option>
                                                <option value="FAC-003">FAC-003 · 지하 전기실</option>
                                                <option value="FAC-004">FAC-004 · 스프링클러 설비</option>
                                                <option value="FAC-005">FAC-005 · 옥상 물탱크</option>
                                                <option value="FAC-006">FAC-006 · CCTV 101동</option>
                                            </select>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">입찰 유형 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">BID_TY_CD</small>
                                            </label>
                                            <select class="form-select" id="bidTyCd" required>
                                                <option value="">선택</option>
                                                <option value="GEN">GEN · 일반경쟁입찰</option>
                                                <option value="LIM">LIM · 제한경쟁입찰</option>
                                                <option value="SEL">SEL · 지명경쟁입찰</option>
                                                <option value="PRT">PRT · 수의계약</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-3">
                                        <div class="form-field">
                                            <label class="field-label">계약금액 (원) <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">CONT_AMT</small>
                                            </label>
                                            <input type="number" class="form-input" id="contAmt" placeholder="0" min="0" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">계약 시작일 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">CONT_BGNG_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="contBgngDt" required>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">계약 종료일
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">CONT_END_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="contEndDt">
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">계약 체결일
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">CONT_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="contDt">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">계약 상태
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">CONT_STTS_CD</small>
                                            </label>
                                            <select class="form-select" id="contSttsCd">
                                                <option value="DRAFT">DRAFT · 작성중</option>
                                                <option value="ACTIVE">ACTIVE · 유효</option>
                                                <option value="END">END · 종료</option>
                                                <option value="TERM">TERM · 해지</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">attach_file</span>
                                        첨부 파일
                                        <small style="font-weight:400;color:#9caa9e;font-size:11px;text-transform:none;letter-spacing:0;">계약서·견적서 등 최대 5개 / 개당 10MB</small>
                                    </div>
                                    <div class="file-drop" onclick="document.getElementById('fileInput').click()">
                                        <span class="material-symbols-rounded">upload_file</span>
                                        클릭하거나 파일을 끌어다 놓으세요 · PDF, DOC, XLS, JPG
                                        <input type="file" id="fileInput" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.png" style="display:none;">
                                    </div>
                                    <div class="file-list" id="fileList"></div>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-danger" id="partnerDeleteBtn" data-action="openDeleteConfirm" style="display:none;margin-right:auto;">
                                    <span class="material-symbols-rounded">delete</span>삭제
                                </button>
                                <button type="button" class="btn btn-secondary" data-action="closePartnerModal">취소</button>
                                <button type="button" class="btn btn-secondary" id="partnerEditBtn" data-action="changeToEdit" style="display:none;">수정하기</button>
                                <button type="submit"  class="btn btn-primary"  id="partnerSaveBtn">저장</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- 모달 : 삭제 확인 -->
                <div class="modal-overlay" id="partnerDeleteModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">업체 삭제</h3>
                            <button type="button" class="modal-close" data-action="closeDeleteModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="del-warn">
                                <span class="material-symbols-rounded">warning</span>
                                <div>선택한 업체를 삭제하시겠습니까?<br>연결된 계약(FACILITY_CONTRACT) 및 점검이력(FACILITY_CHECK_HSTRY)도 함께 삭제됩니다.</div>
                            </div>
                            <div class="mngr-detail-grid" id="deleteTargetInfo"></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
                            <button type="button" class="btn btn-danger"    id="deleteConfirmBtn">삭제</button>
                        </div>
                    </div>
                </div>

            </div><!-- /office-page -->

            <script>
                (function () {
                    var page = document.getElementById('partnerPage');
                    if (!page || page.dataset.bound === 'true') return;
                    page.dataset.bound = 'true';

                    /* ── 공통코드 ── */
                    var BID_TEXT  = { GEN:'일반경쟁입찰', LIM:'제한경쟁입찰', SEL:'지명경쟁입찰', PRT:'수의계약' };
                    var BID_BADGE = { GEN:'badge-blue', LIM:'badge-purple', SEL:'badge-orange', PRT:'badge-gray' };
                    var STTS_TEXT  = { ACTIVE:'유효', EXPIRE:'만료예정', END:'종료', TERM:'해지', DRAFT:'작성중' };
                    var STTS_BADGE = { ACTIVE:'badge-green', EXPIRE:'badge-yellow', END:'badge-gray', TERM:'badge-red', DRAFT:'badge-blue' };
                    var FAC_TEXT   = { ELV:'승강기', WTR:'급수시설', ELC:'전기시설', GAS:'가스시설', FIRE:'소방시설', SEC:'보안시설', ETC:'기타시설' };
                    var FAC_BADGE  = { ELV:'badge-blue', WTR:'badge-green', ELC:'badge-yellow', GAS:'badge-orange', FIRE:'badge-red', SEC:'badge-purple', ETC:'badge-gray' };
                    var CHK_TY_TEXT  = { REG:'정기점검', SPC:'특별점검', SAFE:'안전점검', REPAIR:'보수점검' };
                    var CHK_ST_TEXT  = { WAIT:'점검대기', ING:'점검중', DONE:'점검완료', FAULT:'이상발견' };
                    var CHK_ST_BADGE = { WAIT:'badge-yellow', ING:'badge-blue', DONE:'badge-green', FAULT:'badge-red' };

                    /* ── 더미 데이터 (백엔드 연결 시 AJAX 대체) ── */
                    var partnerData = [
                        { partnerNo:'PT-001', partnerNm:'승강기관리(주)', bizTyNm:'승강기', bizrno:'123-45-67890', picNm:'김철수', picTelno:'010-1234-5678', picEmail:'kim@elv.co.kr',
                            contNo:'CT-001', contNm:'2025 승강기 유지보수 계약', contSttsCd:'EXPIRE', bidTyCd:'GEN', contAmt:48000000, contBgngDt:'2025-01-01', contEndDt:'2026-05-07', facilityNo:'FAC-001', facilityTyCd:'ELV' },
                        { partnerNo:'PT-002', partnerNm:'한국소방안전', bizTyNm:'소방', bizrno:'234-56-78901', picNm:'이영희', picTelno:'010-2345-6789', picEmail:'lee@fire.co.kr',
                            contNo:'CT-002', contNm:'소방시설 정기점검 계약', contSttsCd:'EXPIRE', bidTyCd:'LIM', contAmt:15000000, contBgngDt:'2025-04-01', contEndDt:'2026-05-12', facilityNo:'FAC-004', facilityTyCd:'FIRE' },
                        { partnerNo:'PT-003', partnerNm:'청정환경서비스', bizTyNm:'청소', bizrno:'345-67-89012', picNm:'박민준', picTelno:'010-3456-7890', picEmail:'park@clean.co.kr',
                            contNo:'CT-003', contNm:'단지 청소 용역 계약', contSttsCd:'ACTIVE', bidTyCd:'PRT', contAmt:36000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-006', facilityTyCd:'ETC' },
                        { partnerNo:'PT-004', partnerNm:'대한전기(주)', bizTyNm:'전기', bizrno:'456-78-90123', picNm:'최지원', picTelno:'010-4567-8901', picEmail:'choi@elec.co.kr',
                            contNo:'CT-004', contNm:'전기설비 유지관리 계약', contSttsCd:'ACTIVE', bidTyCd:'GEN', contAmt:24000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-003', facilityTyCd:'ELC' },
                        { partnerNo:'PT-005', partnerNm:'보안솔루션', bizTyNm:'보안', bizrno:'567-89-01234', picNm:'정수진', picTelno:'010-5678-9012', picEmail:'jung@sec.co.kr',
                            contNo:'CT-005', contNm:'CCTV 운영 및 보안 계약', contSttsCd:'ACTIVE', bidTyCd:'SEL', contAmt:18000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-006', facilityTyCd:'SEC' },
                        { partnerNo:'PT-006', partnerNm:'가스안전(주)', bizTyNm:'가스', bizrno:'678-90-12345', picNm:'강동원', picTelno:'010-6789-0123', picEmail:'kang@gas.co.kr',
                            contNo:'CT-006', contNm:'가스시설 안전관리 계약', contSttsCd:'ACTIVE', bidTyCd:'LIM', contAmt:12000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-005', facilityTyCd:'GAS' },
                        { partnerNo:'PT-007', partnerNm:'푸른급수관리', bizTyNm:'급수', bizrno:'789-01-23456', picNm:'윤소희', picTelno:'010-7890-1234', picEmail:'yoon@water.co.kr',
                            contNo:'CT-007', contNm:'급수시설 유지보수 계약', contSttsCd:'ACTIVE', bidTyCd:'PRT', contAmt:9600000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-005', facilityTyCd:'WTR' },
                        { partnerNo:'PT-008', partnerNm:'e편한안전', bizTyNm:'소방', bizrno:'901-23-45678', picNm:'서지훈', picTelno:'010-9012-3456', picEmail:'seo@safe.co.kr',
                            contNo:'CT-008', contNm:'소화기 관리 용역', contSttsCd:'END', bidTyCd:'PRT', contAmt:8400000, contBgngDt:'2025-01-01', contEndDt:'2025-12-31', facilityNo:'FAC-004', facilityTyCd:'FIRE' },
                        { partnerNo:'PT-009', partnerNm:'KD승강기서비스', bizTyNm:'승강기', bizrno:'222-33-44444', picNm:'장민서', picTelno:'010-2222-3333', picEmail:'jang@kd.co.kr',
                            contNo:'CT-009', contNm:'2호기 승강기 유지보수', contSttsCd:'ACTIVE', bidTyCd:'GEN', contAmt:24000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-002', facilityTyCd:'ELV' },
                    ];
                    var historyData = [
                        { facChkHstryNo:'FCH-001', facilityNo:'FAC-001', partnerNo:'PT-001', partnerNm:'승강기관리(주)', chkDt:'2026-04-10', chkSttsCd:'DONE',  chkTyCd:'REG',    chkCn:'엘리베이터 안전장치 및 운행 상태 월간 점검 완료', rmk:'' },
                        { facChkHstryNo:'FCH-002', facilityNo:'FAC-004', partnerNo:'PT-002', partnerNm:'한국소방안전',   chkDt:'2026-04-12', chkSttsCd:'DONE',  chkTyCd:'REG',    chkCn:'소화기 및 스프링클러 작동 상태 확인 완료', rmk:'' },
                        { facChkHstryNo:'FCH-003', facilityNo:'FAC-003', partnerNo:'PT-004', partnerNm:'대한전기(주)',   chkDt:'2026-04-14', chkSttsCd:'FAULT', chkTyCd:'SPC',    chkCn:'전기 분전반 3번 이상 발견', rmk:'분전반 교체 필요 — 즉시 조치 요망' },
                        { facChkHstryNo:'FCH-004', facilityNo:'FAC-006', partnerNo:'PT-005', partnerNm:'보안솔루션',     chkDt:'2026-04-16', chkSttsCd:'DONE',  chkTyCd:'REG',    chkCn:'CCTV 화질 조정 및 녹화 테스트 완료', rmk:'' },
                        { facChkHstryNo:'FCH-005', facilityNo:'FAC-005', partnerNo:'PT-006', partnerNm:'가스안전(주)',   chkDt:'2026-04-18', chkSttsCd:'DONE',  chkTyCd:'SAFE',   chkCn:'가스 배관 누수 점검 이상 없음', rmk:'' },
                        { facChkHstryNo:'FCH-006', facilityNo:'FAC-005', partnerNo:'PT-007', partnerNm:'푸른급수관리',   chkDt:'2026-04-20', chkSttsCd:'ING',   chkTyCd:'REPAIR', chkCn:'급수펌프 소음 원인 파악 및 부품 교체 진행 중', rmk:'교체 완료 후 재점검 필요' },
                        { facChkHstryNo:'FCH-007', facilityNo:'FAC-002', partnerNo:'PT-009', partnerNm:'KD승강기서비스', chkDt:'2026-04-22', chkSttsCd:'DONE',  chkTyCd:'REG',    chkCn:'2호기 와이어 장력 조정 및 도어 센서 점검', rmk:'' },
                        { facChkHstryNo:'FCH-008', facilityNo:'FAC-001', partnerNo:'PT-001', partnerNm:'승강기관리(주)', chkDt:'2026-04-25', chkSttsCd:'WAIT',  chkTyCd:'SPC',    chkCn:'법정 정기검사 예정', rmk:'' },
                    ];

                    var currentIdx = null, deleteTargetIdx = null, uploadedFiles = [];

                    /* ── 헬퍼 ── */
                    function b(cls, t)  { return '<span class="badge ' + cls + '">' + t + '</span>'; }
                    function sttsB(cd)  { return b(STTS_BADGE[cd]   || 'badge-gray', STTS_TEXT[cd]   || cd); }
                    function bidB(cd)   { return b(BID_BADGE[cd]    || 'badge-gray', BID_TEXT[cd]    || cd); }
                    function facB(cd)   { return b(FAC_BADGE[cd]    || 'badge-gray', FAC_TEXT[cd]    || cd); }
                    function chkStB(cd) { return b(CHK_ST_BADGE[cd] || 'badge-gray', CHK_ST_TEXT[cd] || cd); }
                    function fmtAmt(n)  { return Number(n).toLocaleString() + '원'; }
                    function di(l, v)   { return '<div class="mngr-detail-item"><div class="mngr-detail-label">' + l + '</div><div class="mngr-detail-value">' + v + '</div></div>'; }
                    function calcDday(dt) { if (!dt) return null; return Math.ceil((new Date(dt) - new Date()) / 86400000); }
                    function ddayHtml(p) {
                        if (p.contSttsCd==='END'||p.contSttsCd==='TERM') return '';
                        var d = calcDday(p.contEndDt); if (d===null) return '';
                        if (d<=30) return ' <span class="dday dday-danger">D-'+d+'</span>';
                        if (d<=90) return ' <span class="dday dday-warn">D-'+d+'</span>';
                        return '';
                    }

                    /* ── 요약 + 배너 ── */
                    function updateStats(data) {
                        document.getElementById('statTotal').textContent  = data.length;
                        document.getElementById('statActive').textContent = data.filter(function(r){ return r.contSttsCd==='ACTIVE'; }).length;
                        document.getElementById('statEnd').textContent    = data.filter(function(r){ return r.contSttsCd==='END'; }).length;
                        var exp = data.filter(function(r){ var d=calcDday(r.contEndDt); return d!==null&&d>=0&&d<=30&&r.contSttsCd!=='END'&&r.contSttsCd!=='TERM'; });
                        document.getElementById('statExpire').textContent = exp.length;
                        var banner = document.getElementById('expireBanner');
                        if (exp.length > 0) {
                            banner.style.display = 'flex';
                            document.getElementById('expireBannerText').innerHTML = '<strong>만료 예정 ' + exp.length + '건</strong> — 계약 갱신 또는 재입찰 검토가 필요합니다';
                            var chips = document.getElementById('expireChips');
                            chips.innerHTML = '';
                            exp.forEach(function(r) {
                                var chip = document.createElement('span'); chip.className='expire-chip';
                                chip.textContent = r.partnerNm + '  D-' + calcDday(r.contEndDt);
                                chip.addEventListener('click', function(){
                                    document.getElementById('filterKeyword').value = r.partnerNm;
                                    renderPartner(partnerData.filter(function(p){ return p.partnerNm===r.partnerNm; }));
                                    switchTab('tab-partner');
                                });
                                chips.appendChild(chip);
                            });
                        } else { banner.style.display='none'; }
                    }

                    /* ── 탭 ── */
                    function switchTab(id) {
                        page.querySelectorAll('.tab-panel').forEach(function(el){ el.classList.remove('active'); });
                        page.querySelectorAll('.tab-btn').forEach(function(btn){ btn.classList.toggle('active', btn.dataset.tab===id); });
                        var p=document.getElementById(id); if(p) p.classList.add('active');
                    }
                    page.querySelectorAll('.tab-btn').forEach(function(btn){
                        btn.addEventListener('click', function(){ switchTab(btn.dataset.tab); });
                    });

                    /* ── 렌더 : PARTNER ── */
                    function renderPartner(data) {
                        document.getElementById('partnerCount').textContent = data.length + '건';
                        var tb = document.getElementById('partnerTbody');
                        if (!data.length) { tb.innerHTML='<tr><td colspan="10" class="empty-row">조건에 맞는 업체가 없습니다.</td></tr>'; return; }
                        tb.innerHTML = data.map(function(p,i){
                            return '<tr>'
                                +'<td class="td-mono">'+p.partnerNo+'</td>'
                                +'<td class="td-bold">'+p.partnerNm+'</td>'
                                +'<td><span class="badge badge-gray">'+p.bizTyNm+'</span></td>'
                                +'<td class="td-mono">'+p.bizrno+'</td>'
                                +'<td>'+p.picNm+'<br><span style="font-size:11px;color:#9caa9e;">'+p.picTelno+'</span></td>'
                                +'<td style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'+p.contNm+'</td>'
                                +'<td class="col-right td-bold">'+fmtAmt(p.contAmt)+'</td>'
                                +'<td class="col-center td-mono" style="font-size:11px;white-space:nowrap;">'+p.contBgngDt+'<br>~ '+p.contEndDt+ddayHtml(p)+'</td>'
                                +'<td class="col-center">'+sttsB(p.contSttsCd)+'</td>'
                                +'<td class="col-manage"><div class="grid-actions">'
                                +'<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="'+i+'">상세</button>'
                                +'<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="'+i+'">수정</button>'
                                +'<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="'+i+'">삭제</button>'
                                +'</div></td></tr>';
                        }).join('');
                    }

                    /* ── 렌더 : FACILITY_CONTRACT ── */
                    function renderContract(data) {
                        document.getElementById('contractCount').textContent = data.length + '건';
                        var tb = document.getElementById('contractTbody');
                        if (!data.length) { tb.innerHTML='<tr><td colspan="9" class="empty-row">조건에 맞는 계약이 없습니다.</td></tr>'; return; }
                        tb.innerHTML = data.map(function(p,i){
                            return '<tr>'
                                +'<td class="td-mono">'+p.contNo+'</td>'
                                +'<td class="td-bold" style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">'+p.contNm+'</td>'
                                +'<td>'+p.partnerNm+'</td>'
                                +'<td class="col-center">'+facB(p.facilityTyCd)+'</td>'
                                +'<td class="col-center">'+bidB(p.bidTyCd)+'</td>'
                                +'<td class="col-right td-bold">'+fmtAmt(p.contAmt)+'</td>'
                                +'<td class="col-center td-mono" style="font-size:11px;white-space:nowrap;">'+p.contBgngDt+'<br>~ '+p.contEndDt+ddayHtml(p)+'</td>'
                                +'<td class="col-center">'+sttsB(p.contSttsCd)+'</td>'
                                +'<td class="col-manage"><div class="grid-actions">'
                                +'<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="'+i+'">상세</button>'
                                +'<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="'+i+'">수정</button>'
                                +'</div></td></tr>';
                        }).join('');
                    }

                    /* ── 렌더 : FACILITY_CHECK_HSTRY ── */
                    function renderHistory(data) {
                        document.getElementById('historyCount').textContent = data.length + '건';
                        var tb = document.getElementById('historyTbody');
                        if (!data.length) { tb.innerHTML='<tr><td colspan="9" class="empty-row">조건에 맞는 이력이 없습니다.</td></tr>'; return; }
                        tb.innerHTML = data.map(function(h){
                            return '<tr>'
                                +'<td class="td-mono">'+h.facChkHstryNo+'</td>'
                                +'<td class="td-bold">'+h.partnerNm+'</td>'
                                +'<td class="td-mono">'+h.facilityNo+'</td>'
                                +'<td class="col-center"><span class="badge badge-gray">'+( CHK_TY_TEXT[h.chkTyCd]||h.chkTyCd)+'</span></td>'
                                +'<td class="col-center td-mono">'+h.chkDt+'</td>'
                                +'<td class="col-center">'+chkStB(h.chkSttsCd)+'</td>'
                                +'<td style="max-width:200px;font-size:12px;">'+h.chkCn+'</td>'
                                +'<td style="font-size:12px;color:'+(h.rmk?'#dc2626':'#9caa9e')+';">'+(h.rmk||'—')+'</td>'
                                +'<td class="col-manage"><div class="grid-actions">'
                                +'<button type="button" class="btn btn-xs btn-detail" data-action="detailHistory" data-id="'+h.facChkHstryNo+'">상세</button>'
                                +'</div></td></tr>';
                        }).join('');
                    }

                    /* ── 필터 ── */
                    function filteredPartner() {
                        var biz=document.getElementById('filterBizTy').value, st=document.getElementById('filterContStts').value, kw=document.getElementById('filterKeyword').value.trim();
                        return partnerData.filter(function(p){
                            var d=calcDday(p.contEndDt), isExp=d!==null&&d>=0&&d<=30&&p.contSttsCd!=='END'&&p.contSttsCd!=='TERM';
                            return (!biz||p.bizTyNm===biz)&&(!st||p.contSttsCd===st||(st==='EXPIRE'&&isExp))&&(!kw||p.partnerNm.indexOf(kw)>-1||p.picNm.indexOf(kw)>-1||p.bizrno.indexOf(kw)>-1);
                        });
                    }
                    function filteredContract() {
                        var st=document.getElementById('filterContStts2').value, bt=document.getElementById('filterBidTy').value,
                            s=document.getElementById('filterContStart').value, e=document.getElementById('filterContEnd').value, kw=document.getElementById('filterContKeyword').value.trim();
                        return partnerData.filter(function(p){
                            var d=calcDday(p.contEndDt), isExp=d!==null&&d>=0&&d<=30&&p.contSttsCd!=='END'&&p.contSttsCd!=='TERM';
                            return (!st||p.contSttsCd===st||(st==='EXPIRE'&&isExp))&&(!bt||p.bidTyCd===bt)&&(!s||p.contBgngDt>=s)&&(!e||p.contEndDt<=e)&&(!kw||p.contNm.indexOf(kw)>-1||p.partnerNm.indexOf(kw)>-1);
                        });
                    }
                    function filteredHistory() {
                        var ty=document.getElementById('filterChkTy').value, st=document.getElementById('filterChkStts').value,
                            s=document.getElementById('filterChkStart').value, e=document.getElementById('filterChkEnd').value, kw=document.getElementById('filterChkKeyword').value.trim();
                        return historyData.filter(function(h){
                            return (!ty||h.chkTyCd===ty)&&(!st||h.chkSttsCd===st)&&(!s||h.chkDt>=s)&&(!e||h.chkDt<=e)&&(!kw||h.partnerNm.indexOf(kw)>-1||h.facilityNo.indexOf(kw)>-1);
                        });
                    }

                    /* ── 모달 ── */
                    var pModal=document.getElementById('partnerModal'), dModal=document.getElementById('partnerDeleteModal');
                    var form=document.getElementById('partnerForm');
                    var saveBtn=document.getElementById('partnerSaveBtn'), editBtn=document.getElementById('partnerEditBtn'), delBtn=document.getElementById('partnerDeleteBtn');

                    function openM(id)  { document.getElementById(id).classList.add('open'); }
                    function closeM(id) { document.getElementById(id).classList.remove('open'); }

                    function openModal(mode, idx) {
                        form.reset(); document.getElementById('fileList').innerHTML=''; uploadedFiles=[];
                        currentIdx=idx!==undefined?idx:null;
                        saveBtn.style.display='inline-flex'; editBtn.style.display='none'; delBtn.style.display='none';
                        setDis(false);
                        if (mode==='register') { document.getElementById('partnerModalTitle').textContent='협력업체 등록'; }
                        if (mode==='detail'&&currentIdx!==null) {
                            document.getElementById('partnerModalTitle').textContent='협력업체 상세';
                            fill(partnerData[currentIdx]); setDis(true);
                            saveBtn.style.display='none'; editBtn.style.display='inline-flex'; delBtn.style.display='inline-flex';
                            editBtn.dataset.idx=currentIdx;
                        }
                        if (mode==='edit'&&currentIdx!==null) {
                            document.getElementById('partnerModalTitle').textContent='협력업체 수정';
                            fill(partnerData[currentIdx]); delBtn.style.display='inline-flex';
                        }
                        openM('partnerModal');
                    }
                    function fill(p) {
                        var m={'partnerNo':p.partnerNo,'partnerNm':p.partnerNm,'bizTyNm':p.bizTyNm,'bizrno':p.bizrno,'picNm':p.picNm,'picTelno':p.picTelno,'picEmail':p.picEmail,
                            'contNo':p.contNo,'contNm':p.contNm,'facilityNo':p.facilityNo,'bidTyCd':p.bidTyCd,'contAmt':p.contAmt,'contBgngDt':p.contBgngDt,'contEndDt':p.contEndDt,'contSttsCd':p.contSttsCd};
                        Object.keys(m).forEach(function(k){ var el=document.getElementById(k); if(el) el.value=m[k]||''; });
                    }
                    function setDis(v) { form.querySelectorAll('input,select,textarea').forEach(function(el){ el.disabled=v; }); }

                    document.getElementById('fileInput').addEventListener('change', function(){
                        var list=document.getElementById('fileList');
                        Array.prototype.slice.call(this.files).forEach(function(f){
                            if(uploadedFiles.length>=5) return; uploadedFiles.push(f.name);
                            var item=document.createElement('div'); item.className='file-item';
                            item.innerHTML='<span class="material-symbols-rounded">description</span><span class="f-name">'+f.name+'</span><span style="color:#9caa9e;font-size:10px;font-family:monospace;">'+(f.size/1024).toFixed(1)+' KB</span><button type="button" class="file-remove" data-fname="'+f.name+'"><span class="material-symbols-rounded" style="font-size:14px;">close</span></button>';
                            list.appendChild(item);
                        }); this.value='';
                    });
                    document.getElementById('fileList').addEventListener('click', function(e){
                        var btn=e.target.closest('.file-remove'); if(!btn) return;
                        uploadedFiles=uploadedFiles.filter(function(n){ return n!==btn.dataset.fname; });
                        btn.closest('.file-item').remove();
                    });

                    /* 이벤트 위임 */
                    page.addEventListener('click', function(e){
                        var btn=e.target.closest('[data-action]'); if(!btn) return;
                        var action=btn.dataset.action, idx=btn.dataset.idx!==undefined?Number(btn.dataset.idx):undefined;

                        if(action==='openRegister')       openModal('register');
                        if(action==='detail')             openModal('detail',idx);
                        if(action==='edit')               openModal('edit',idx);
                        if(action==='changeToEdit')       openModal('edit',Number(editBtn.dataset.idx));
                        if(action==='closePartnerModal')  { closeM('partnerModal'); setDis(false); currentIdx=null; }

                        if(action==='delete') {
                            deleteTargetIdx=idx;
                            var p=partnerData[idx];
                            document.getElementById('deleteTargetInfo').innerHTML=di('PARTNER_NO',p.partnerNo)+di('PARTNER_NM',p.partnerNm)+di('BIZ_TY_NM',p.bizTyNm)+di('CONT_NO',p.contNo);
                            openM('partnerDeleteModal');
                        }
                        if(action==='openDeleteConfirm') {
                            if(currentIdx===null) return;
                            deleteTargetIdx=currentIdx;
                            var p=partnerData[currentIdx];
                            document.getElementById('deleteTargetInfo').innerHTML=di('PARTNER_NO',p.partnerNo)+di('PARTNER_NM',p.partnerNm)+di('BIZ_TY_NM',p.bizTyNm)+di('CONT_NO',p.contNo);
                            openM('partnerDeleteModal');
                        }
                        if(action==='closeDeleteModal') closeM('partnerDeleteModal');

                        if(action==='searchPartner')  renderPartner(filteredPartner());
                        if(action==='searchContract') renderContract(filteredContract());
                        if(action==='searchHistory')  renderHistory(filteredHistory());

                        if(action==='resetPartner')  { ['filterBizTy','filterContStts','filterKeyword'].forEach(function(id){ document.getElementById(id).value=''; }); renderPartner(partnerData); }
                        if(action==='resetContract') { ['filterContStts2','filterBidTy','filterContStart','filterContEnd','filterContKeyword'].forEach(function(id){ document.getElementById(id).value=''; }); renderContract(partnerData); }
                        if(action==='resetHistory')  { ['filterChkTy','filterChkStts','filterChkStart','filterChkEnd','filterChkKeyword'].forEach(function(id){ document.getElementById(id).value=''; }); renderHistory(historyData); }
                        if(action==='detailHistory') alert('FAC_CHK_HSTRY_NO='+btn.dataset.id+' 기준 조회 — 백엔드 연결 예정');
                    });

                    document.getElementById('deleteConfirmBtn').addEventListener('click', function(){
                        if(deleteTargetIdx===null) return;
                        partnerData.splice(deleteTargetIdx,1);
                        renderPartner(partnerData); renderContract(partnerData); updateStats(partnerData);
                        closeM('partnerDeleteModal'); closeM('partnerModal');
                    });
                    form.addEventListener('submit', function(e){
                        e.preventDefault();
                        if(!document.getElementById('partnerNm').value.trim()){ alert('업체명을 입력하세요.'); return; }
                        alert('저장 — PARTNER insert/update + FACILITY_CONTRACT insert/update');
                        closeM('partnerModal'); setDis(false);
                    });
                    pModal.addEventListener('click', function(e){ if(e.target===pModal){ closeM('partnerModal'); setDis(false); currentIdx=null; } });
                    dModal.addEventListener('click', function(e){ if(e.target===dModal) closeM('partnerDeleteModal'); });

                    /* 초기 렌더 */
                    updateStats(partnerData);
                    renderPartner(partnerData);
                    renderContract(partnerData);
                    renderHistory(historyData);
                })();
            </script>

        </main>
    </div>
</div>
</body>
</html>
