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
        /* ────────────────────────────────────────────
           협력업체 관리 페이지 전용 스타일
        ──────────────────────────────────────────── */
        #partnerPage .filter-select  { width: 150px; }
        #partnerPage .filter-keyword { width: 280px; }

        /* 만료 예정 알림 배너 */
        #partnerPage .expire-banner {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 12px 16px;
            background: #fffbeb; border: 1px solid #fcd34d;
            border-radius: var(--r-md); margin-bottom: 16px; font-size: 13px;
        }
        #partnerPage .expire-banner > .material-symbols-rounded {
            color: #d97706; font-size: 19px; flex-shrink: 0; margin-top: 2px;
        }
        #partnerPage .expire-banner strong { color: #92400e; }
        #partnerPage .expire-chips { display: flex; gap: 6px; flex-wrap: wrap; margin-top: 7px; }
        #partnerPage .expire-chip {
            background: #fef3c7; border: 1px solid #fcd34d; border-radius: 99px;
            padding: 2px 10px; font-size: 11px; font-weight: 700; color: #92400e;
            cursor: pointer; transition: background 0.14s;
        }
        #partnerPage .expire-chip:hover { background: #fde68a; }

        /* 카드 그리드 */
        #partnerPage .partner-grid {
            display: grid; grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px; padding: 20px 22px;
        }
        #partnerPage .partner-card {
            border: 1px solid var(--border); border-radius: var(--r-md);
            padding: 18px; background: var(--card); cursor: pointer;
            transition: border-color 0.15s, box-shadow 0.15s;
        }
        #partnerPage .partner-card:hover { border-color: #2e5c38; box-shadow: 0 4px 14px rgba(38,92,48,0.1); }
        #partnerPage .card-top { display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 10px; }
        #partnerPage .card-avatar {
            width: 40px; height: 40px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 15px; font-weight: 800; color: #fff; flex-shrink: 0;
        }
        #partnerPage .card-name { font-size: 14px; font-weight: 700; margin-bottom: 2px; }
        #partnerPage .card-biz  { font-size: 12px; color: var(--text-tertiary); margin-bottom: 10px; }
        #partnerPage .card-meta { display: flex; flex-direction: column; gap: 4px; }
        #partnerPage .card-meta-row { display: flex; align-items: center; gap: 5px; font-size: 12px; color: var(--text-secondary); }
        #partnerPage .card-meta-row .material-symbols-rounded { font-size: 13px; color: var(--text-tertiary); }
        #partnerPage .card-divider { height: 1px; background: var(--border); margin: 10px 0; }
        #partnerPage .card-cont { display: flex; justify-content: space-between; align-items: flex-end; font-size: 12px; }
        #partnerPage .card-cont .c-label { color: var(--text-tertiary); margin-bottom: 2px; }
        #partnerPage .card-cont .c-val   { font-weight: 600; color: var(--text-primary); }
        #partnerPage .card-cont .c-date  { font-size: 11px; color: var(--text-tertiary); }
        #partnerPage .card-actions { display: flex; gap: 6px; margin-top: 10px; }
        #partnerPage .card-actions .btn { flex: 1; justify-content: center; font-size: 12px; }

        /* D-Day 뱃지 */
        #partnerPage .dday { display: inline-block; padding: 2px 7px; border-radius: 4px; font-size: 11px; font-weight: 800; }
        #partnerPage .dday-danger { background: #fee2e2; color: #991b1b; }
        #partnerPage .dday-warn   { background: #fef3c7; color: #7c4a0a; }
        #partnerPage .dday-ok     { background: #d1fae5; color: #14532d; }

        /* 테이블 공통 */
        #partnerPage .col-center { text-align: center !important; }
        #partnerPage .col-right  { text-align: right  !important; }
        #partnerPage .col-manage { text-align: center !important; width: 110px; }
        #partnerPage .grid-actions { display: inline-flex; align-items: center; gap: 6px; }
        #partnerPage .empty-row { text-align: center !important; color: var(--text-tertiary); }

        /* 삭제 경고 */
        #partnerPage .delete-warning {
            display: flex; gap: 10px; padding: 14px 16px;
            background: #fff0f0; border: 1px solid #e0a8a8; border-radius: 8px; margin-bottom: 16px;
        }
        #partnerPage .delete-warning-icon { color: #991b1b; font-size: 20px; flex-shrink: 0; margin-top: 1px; }
        #partnerPage .delete-warning-text { font-size: 13px; color: #7f1d1d; line-height: 1.6; }

        /* 첨부파일 드롭존 */
        #partnerPage .file-drop {
            border: 2px dashed var(--border); border-radius: var(--r-sm);
            padding: 20px; text-align: center; cursor: pointer; color: var(--text-tertiary); transition: 0.14s;
        }
        #partnerPage .file-drop:hover { border-color: #2e5c38; background: #f0fdf4; color: #2e5c38; }
        #partnerPage .file-drop .material-symbols-rounded { font-size: 26px; display: block; margin-bottom: 4px; }
        #partnerPage .file-drop p     { font-size: 13px; font-weight: 500; }
        #partnerPage .file-drop small { font-size: 11px; }
        #partnerPage .file-list { margin-top: 8px; display: flex; flex-direction: column; gap: 5px; }
        #partnerPage .file-item {
            display: flex; align-items: center; gap: 7px;
            padding: 6px 10px; background: var(--gray-soft); border-radius: var(--r-sm); font-size: 12px;
        }
        #partnerPage .file-item .material-symbols-rounded { font-size: 15px; color: #2e5c38; }
        #partnerPage .file-item .f-name { flex: 1; }
        #partnerPage .file-remove { background: none; border: none; cursor: pointer; color: var(--text-tertiary); display: flex; padding: 0; }
        #partnerPage .file-remove:hover { color: var(--red); }

        @media (max-width: 1200px) { #partnerPage .partner-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 860px)  { #partnerPage .partner-grid { grid-template-columns: 1fr; } }
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

                <!-- ══════════════════════════════════════
                     페이지 헤더
                ══════════════════════════════════════ -->
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>협력업체 관리</h2>
                        <p>등록 업체·계약 현황·점검 참여이력을 조회하고 관리합니다</p>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary" data-action="resetFilter">
                            <span class="material-symbols-rounded">refresh</span>초기화
                        </button>
                        <button type="button" class="btn btn-primary" data-action="openRegister">
                            <span class="material-symbols-rounded">add</span>업체 등록
                        </button>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     요약 카드
                     PARTNER + FACILITY_CONTRACT 집계
                ══════════════════════════════════════ -->
                <div class="summary-row">
                    <%-- COUNT(*) FROM PARTNER --%>
                    <div class="summary-card s-green">
                        <div class="s-icon"><span class="material-symbols-rounded">store</span></div>
                        <div>
                            <div class="s-val" id="statTotal">0</div>
                            <div class="s-label">등록 업체 · PARTNER</div>
                        </div>
                    </div>
                    <%-- COUNT(*) FROM FACILITY_CONTRACT WHERE CONT_STTS_CD='ACTIVE' --%>
                    <div class="summary-card s-blue">
                        <div class="s-icon"><span class="material-symbols-rounded">handshake</span></div>
                        <div>
                            <div class="s-val" id="statActive">0</div>
                            <div class="s-label">유효 계약 · CONTRACT_STTS=ACTIVE</div>
                        </div>
                    </div>
                    <%-- COUNT(*) WHERE CONT_END_DT - SYSDATE ≤ 30 --%>
                    <div class="summary-card s-yellow">
                        <div class="s-icon"><span class="material-symbols-rounded">event_upcoming</span></div>
                        <div>
                            <div class="s-val" id="statExpire">0</div>
                            <div class="s-label">30일 내 만료 · CONT_END_DT</div>
                        </div>
                    </div>
                    <%-- COUNT(*) FROM FACILITY_CONTRACT WHERE CONT_STTS_CD='END' --%>
                    <div class="summary-card s-gray">
                        <div class="s-icon"><span class="material-symbols-rounded">contract_delete</span></div>
                        <div>
                            <div class="s-val" id="statEnd">0</div>
                            <div class="s-label">계약 종료 · CONTRACT_STTS=END</div>
                        </div>
                    </div>
                </div>

                <!-- 만료 예정 알림 배너 -->
                <div class="expire-banner" id="expireBanner" style="display:none;">
                    <span class="material-symbols-rounded">notification_important</span>
                    <div>
                        <strong id="expireBannerText"></strong>
                        <div class="expire-chips" id="expireChips"></div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     탭 바
                ══════════════════════════════════════ -->
                <div class="tab-bar">
                    <button type="button" class="tab-btn active" data-tab="tab-partner">
                        <span class="material-symbols-rounded">grid_view</span>업체 조회
                    </button>
                    <button type="button" class="tab-btn" data-tab="tab-contract">
                        <span class="material-symbols-rounded">description</span>계약 현황
                    </button>
                    <button type="button" class="tab-btn" data-tab="tab-history">
                        <span class="material-symbols-rounded">history</span>점검 참여이력
                    </button>
                </div>

                <!-- ══════════════════════════════════════
                     탭 1 : 업체 조회 (카드형 UI)
                     ─── ERD : PARTNER ───────────────────
                     PK  PARTNER_NO       VARCHAR2(15)
                     FK  APT_CMPLEX_NO    VARCHAR2(15)
                         PARTNER_NM       VARCHAR2(100) NOT NULL
                         BIZ_TY_NM        VARCHAR2(100) NOT NULL
                         BIZRNO           VARCHAR2(20)  NOT NULL
                         PIC_NM           VARCHAR2(20)
                         PIC_TELNO        VARCHAR2(20)
                         PIC_EMAIL        VARCHAR2(50)
                         REG_DT           DATE          DEFAULT SYSDATE
                         MDF_DT           DATE
                ══════════════════════════════════════ -->
                <div class="tab-panel active" id="tab-partner">

                    <div class="filter-card">
                        <%-- BIZ_TY_NM 필터 --%>
                        <select class="form-select filter-select" id="filterBizTy">
                            <option value="">업종 전체</option>
                            <option value="승강기">승강기</option>
                            <option value="소방">소방</option>
                            <option value="전기">전기</option>
                            <option value="가스">가스</option>
                            <option value="급수">급수</option>
                            <option value="보안">보안</option>
                            <option value="청소">청소</option>
                            <option value="기타">기타</option>
                        </select>
                        <%-- FACILITY_CONTRACT.CONT_STTS_CD 공통코드 CONTRACT_STTS --%>
                        <select class="form-select filter-select" id="filterContStts">
                            <option value="">계약상태 전체</option>
                            <option value="ACTIVE">유효</option>
                            <option value="EXPIRE">만료예정</option>
                            <option value="END">종료</option>
                            <option value="TERM">해지</option>
                            <option value="DRAFT">작성중</option>
                        </select>
                        <%-- PARTNER_NM / PIC_NM / BIZRNO --%>
                        <div class="search-wrap filter-keyword">
                            <span class="material-symbols-rounded">search</span>
                            <input type="text" class="form-input" id="filterKeyword" placeholder="업체명, 담당자, 사업자번호 검색">
                        </div>
                        <button type="button" class="btn btn-primary"   data-action="searchPartner">조회</button>
                        <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
                    </div>

                    <div class="panel">
                        <div class="panel-header">
                            <div class="list-header-left">
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">store</span>업체 목록
                                </h3>
                                <span class="list-count" id="partnerListCount">0건</span>
                            </div>
                        </div>
                        <div class="partner-grid" id="partnerGrid"></div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     탭 2 : 계약 현황
                     ─── ERD : FACILITY_CONTRACT ─────────
                     PK  CONT_NO          VARCHAR2(15)
                     FK  FACILITY_NO      VARCHAR2(15)  → FACILITY
                     FK  PARTNER_NO       VARCHAR2(15)  → PARTNER
                         CONT_NM          VARCHAR2(200) NOT NULL
                         BID_TY_CD        VARCHAR2(20)  NOT NULL
                           공통코드 BID_TY
                           GEN 일반경쟁입찰 / LIM 제한경쟁입찰
                           SEL 지명경쟁입찰 / PRT 수의계약
                         CONT_DT          DATE
                         CONT_STTS_CD     VARCHAR2(50)
                           공통코드 CONTRACT_STTS
                           DRAFT 작성중 / ACTIVE 유효
                           END 종료    / TERM 해지
                         CONT_AMT         NUMBER(15)    NOT NULL
                         PYMT_DT          DATE
                         CONT_BGNG_DT     DATE          NOT NULL
                         CONT_END_DT      DATE
                ══════════════════════════════════════ -->
                <div class="tab-panel" id="tab-contract">

                    <div class="filter-card">
                        <%-- CONT_STTS_CD --%>
                        <select class="form-select filter-select" id="filterContStts2">
                            <option value="">계약상태 전체</option>
                            <option value="ACTIVE">유효</option>
                            <option value="EXPIRE">만료예정</option>
                            <option value="END">종료</option>
                            <option value="TERM">해지</option>
                            <option value="DRAFT">작성중</option>
                        </select>
                        <%-- BID_TY_CD --%>
                        <select class="form-select filter-select" id="filterBidTy">
                            <option value="">입찰유형 전체</option>
                            <option value="GEN">일반경쟁입찰</option>
                            <option value="LIM">제한경쟁입찰</option>
                            <option value="SEL">지명경쟁입찰</option>
                            <option value="PRT">수의계약</option>
                        </select>
                        <%-- CONT_BGNG_DT 범위 --%>
                        <input type="date" class="form-input filter-select" id="filterContStart">
                        <input type="date" class="form-input filter-select" id="filterContEnd">
                        <%-- CONT_NM / PARTNER_NM --%>
                        <div class="search-wrap filter-keyword">
                            <span class="material-symbols-rounded">search</span>
                            <input type="text" class="form-input" id="filterContKeyword" placeholder="계약명, 업체명 검색">
                        </div>
                        <button type="button" class="btn btn-primary"   data-action="searchContract">조회</button>
                        <button type="button" class="btn btn-secondary" data-action="resetContFilter">초기화</button>
                    </div>

                    <div class="panel">
                        <div class="panel-header">
                            <div class="list-header-left">
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">description</span>계약 목록
                                </h3>
                                <span class="list-count" id="contractListCount">0건</span>
                            </div>
                            <button type="button" class="btn btn-primary btn-sm" data-action="openRegister">
                                <span class="material-symbols-rounded">add</span>계약 등록
                            </button>
                        </div>
                        <div class="table-wrap">
                            <table class="tbl">
                                <thead>
                                <tr>
                                    <th>계약번호<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CONT_NO</small></th>
                                    <th>계약명<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CONT_NM</small></th>
                                    <th>업체명<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">PARTNER_NM</small></th>
                                    <th class="col-center">시설유형<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">FACILITY_TY_CD</small></th>
                                    <th class="col-center">입찰유형<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">BID_TY_CD</small></th>
                                    <th class="col-right">계약금액<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CONT_AMT</small></th>
                                    <th>계약기간<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CONT_BGNG_DT ~ CONT_END_DT</small></th>
                                    <th class="col-center">상태<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CONT_STTS_CD</small></th>
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
                     ─── ERD : FACILITY_CHECK_HSTRY ──────
                     PK  FAC_CHK_HSTRY_NO  VARCHAR2(15)
                     FK  FACILITY_NO        VARCHAR2(15)  → FACILITY
                     FK  PARTNER_NO         VARCHAR2(15)  → PARTNER
                         CHK_DT             DATE
                         CHK_STTS_CD        VARCHAR2(20)
                           공통코드 CHECK_STTS
                           WAIT 점검대기 / ING 점검중
                           DONE 점검완료 / FAULT 이상발견
                         CHK_CN             VARCHAR2(1000)
                         RMK                VARCHAR2(500)
                         REG_DT             DATE  DEFAULT SYSDATE
                         MDF_DT             DATE
                         CHK_TY_CD          VARCHAR2(20)
                           공통코드 CHECK_TY
                           REG 정기점검 / SPC 특별점검
                           SAFE 안전점검 / REPAIR 보수점검
                ══════════════════════════════════════ -->
                <div class="tab-panel" id="tab-history">

                    <div class="filter-card">
                        <%-- CHK_TY_CD --%>
                        <select class="form-select filter-select" id="filterChkTy">
                            <option value="">점검유형 전체</option>
                            <option value="REG">정기점검</option>
                            <option value="SPC">특별점검</option>
                            <option value="SAFE">안전점검</option>
                            <option value="REPAIR">보수점검</option>
                        </select>
                        <%-- CHK_STTS_CD --%>
                        <select class="form-select filter-select" id="filterChkStts">
                            <option value="">점검상태 전체</option>
                            <option value="WAIT">점검대기</option>
                            <option value="ING">점검중</option>
                            <option value="DONE">점검완료</option>
                            <option value="FAULT">이상발견</option>
                        </select>
                        <%-- CHK_DT 범위 --%>
                        <input type="date" class="form-input filter-select" id="filterChkStart">
                        <input type="date" class="form-input filter-select" id="filterChkEnd">
                        <%-- FAC_CHK_HSTRY_NO / FACILITY_NO / PARTNER_NM --%>
                        <div class="search-wrap filter-keyword">
                            <span class="material-symbols-rounded">search</span>
                            <input type="text" class="form-input" id="filterHstryKeyword" placeholder="이력번호, 시설번호, 업체명 검색">
                        </div>
                        <button type="button" class="btn btn-primary"   data-action="searchHistory">조회</button>
                        <button type="button" class="btn btn-secondary" data-action="resetHstryFilter">초기화</button>
                    </div>

                    <div class="panel">
                        <div class="panel-header">
                            <div class="list-header-left">
                                <h3 class="panel-title">
                                    <span class="material-symbols-rounded">fact_check</span>점검 참여이력
                                </h3>
                                <span class="list-count" id="historyListCount">0건</span>
                            </div>
                        </div>
                        <div class="table-wrap">
                            <table class="tbl">
                                <thead>
                                <tr>
                                    <th>이력번호<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">FAC_CHK_HSTRY_NO</small></th>
                                    <th>업체명<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">PARTNER_NO → NM</small></th>
                                    <th>시설번호<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">FACILITY_NO</small></th>
                                    <th class="col-center">점검유형<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CHK_TY_CD</small></th>
                                    <th class="col-center">점검일자<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CHK_DT</small></th>
                                    <th class="col-center">점검상태<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CHK_STTS_CD</small></th>
                                    <th>점검내용<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">CHK_CN</small></th>
                                    <th>비고<br><small style="font-weight:400;letter-spacing:0;text-transform:none;">RMK</small></th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="historyTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     모달 : 업체 등록·상세·수정
                     PARTNER + FACILITY_CONTRACT 동시 처리
                ══════════════════════════════════════ -->
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

                                <!-- ─── PARTNER 기본 정보 ─── -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">store</span>
                                        업체 기본 정보 · PARTNER
                                    </div>

                                    <%-- PK PARTNER_NO (자동생성) --%>
                                    <input type="hidden" id="partnerNo">

                                    <div class="form-row cols-2">
                                        <%-- PARTNER_NM VARCHAR2(100) NOT NULL --%>
                                        <div class="form-field">
                                            <label class="field-label">업체명 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">PARTNER_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="partnerNm" placeholder="예) (주)대한엘리베이터" required>
                                        </div>
                                        <%-- BIZ_TY_NM VARCHAR2(100) NOT NULL --%>
                                        <div class="form-field">
                                            <label class="field-label">업종 구분 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">BIZ_TY_NM</small>
                                            </label>
                                            <select class="form-select" id="bizTyNm" required>
                                                <option value="">선택하세요</option>
                                                <option value="승강기">승강기</option>
                                                <option value="소방">소방</option>
                                                <option value="전기">전기</option>
                                                <option value="가스">가스</option>
                                                <option value="급수">급수</option>
                                                <option value="보안">보안</option>
                                                <option value="청소">청소</option>
                                                <option value="기타">기타</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row cols-3">
                                        <%-- BIZRNO VARCHAR2(20) NOT NULL --%>
                                        <div class="form-field">
                                            <label class="field-label">사업자등록번호 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">BIZRNO</small>
                                            </label>
                                            <input type="text" class="form-input" id="bizrno" placeholder="000-00-00000" maxlength="12" required>
                                        </div>
                                        <%-- PIC_NM VARCHAR2(20) --%>
                                        <div class="form-field">
                                            <label class="field-label">담당자명
                                                <small style="font-weight:400;color:var(--text-tertiary);">PIC_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="picNm" placeholder="홍길동">
                                        </div>
                                        <%-- PIC_TELNO VARCHAR2(20) --%>
                                        <div class="form-field">
                                            <label class="field-label">담당자 연락처
                                                <small style="font-weight:400;color:var(--text-tertiary);">PIC_TELNO</small>
                                            </label>
                                            <input type="text" class="form-input" id="picTelno" placeholder="010-0000-0000">
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <%-- PIC_EMAIL VARCHAR2(50) --%>
                                        <div class="form-field">
                                            <label class="field-label">담당자 이메일
                                                <small style="font-weight:400;color:var(--text-tertiary);">PIC_EMAIL</small>
                                            </label>
                                            <input type="email" class="form-input" id="picEmail" placeholder="example@company.com">
                                        </div>
                                    </div>
                                </div>

                                <!-- ─── FACILITY_CONTRACT 계약 정보 ─── -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">description</span>
                                        계약 정보 · FACILITY_CONTRACT
                                    </div>

                                    <%-- PK CONT_NO (자동생성) --%>
                                    <input type="hidden" id="contNo">

                                    <div class="form-row cols-1">
                                        <%-- CONT_NM VARCHAR2(200) NOT NULL --%>
                                        <div class="form-field">
                                            <label class="field-label">계약명 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">CONT_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="contNm" placeholder="예) 2026년 승강기 유지보수 계약" required>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <%-- FK FACILITY_NO → FACILITY --%>
                                        <div class="form-field">
                                            <label class="field-label">대상 시설 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">FACILITY_NO</small>
                                            </label>
                                            <select class="form-select" id="facilityNo" required>
                                                <option value="">시설 선택</option>
                                                <option value="FAC-001">FAC-001 · 1호기 승강기</option>
                                                <option value="FAC-002">FAC-002 · 2호기 승강기</option>
                                                <option value="FAC-003">FAC-003 · 지하 전기실</option>
                                                <option value="FAC-004">FAC-004 · 스프링클러 설비</option>
                                                <option value="FAC-005">FAC-005 · 옥상 물탱크</option>
                                                <option value="FAC-006">FAC-006 · CCTV 101동</option>
                                            </select>
                                        </div>
                                        <%-- BID_TY_CD VARCHAR2(20) 공통코드 BID_TY --%>
                                        <div class="form-field">
                                            <label class="field-label">입찰 유형 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">BID_TY_CD</small>
                                            </label>
                                            <select class="form-select" id="bidTyCd" required>
                                                <option value="">선택하세요</option>
                                                <option value="GEN">GEN · 일반경쟁입찰</option>
                                                <option value="LIM">LIM · 제한경쟁입찰</option>
                                                <option value="SEL">SEL · 지명경쟁입찰</option>
                                                <option value="PRT">PRT · 수의계약</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <%-- CONT_AMT NUMBER(15) NOT NULL --%>
                                        <div class="form-field">
                                            <label class="field-label">계약금액 (원) <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">CONT_AMT</small>
                                            </label>
                                            <input type="number" class="form-input" id="contAmt" placeholder="0" min="0" required>
                                        </div>
                                        <%-- PYMT_DT DATE --%>
                                        <div class="form-field">
                                            <label class="field-label">지급일
                                                <small style="font-weight:400;color:var(--text-tertiary);">PYMT_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="pymtDt">
                                        </div>
                                    </div>

                                    <div class="form-row cols-3">
                                        <%-- CONT_DT DATE --%>
                                        <div class="form-field">
                                            <label class="field-label">계약 체결일
                                                <small style="font-weight:400;color:var(--text-tertiary);">CONT_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="contDt">
                                        </div>
                                        <%-- CONT_BGNG_DT DATE NOT NULL --%>
                                        <div class="form-field">
                                            <label class="field-label">계약 시작일 <span class="req">*</span>
                                                <small style="font-weight:400;color:var(--text-tertiary);">CONT_BGNG_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="contBgngDt" required>
                                        </div>
                                        <%-- CONT_END_DT DATE --%>
                                        <div class="form-field">
                                            <label class="field-label">계약 종료일
                                                <small style="font-weight:400;color:var(--text-tertiary);">CONT_END_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="contEndDt">
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <%-- CONT_STTS_CD VARCHAR2(50) 공통코드 CONTRACT_STTS --%>
                                        <div class="form-field">
                                            <label class="field-label">계약 상태
                                                <small style="font-weight:400;color:var(--text-tertiary);">CONT_STTS_CD</small>
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

                                <!-- ─── 첨부 파일 ─── -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">attach_file</span>
                                        첨부 파일
                                        <small style="font-weight:400;color:var(--text-tertiary);text-transform:none;letter-spacing:0;">계약서·견적서 등 최대 5개 / 개당 10MB</small>
                                    </div>
                                    <div class="file-drop" id="fileDrop" onclick="document.getElementById('fileInput').click()">
                                        <span class="material-symbols-rounded">upload_file</span>
                                        <p>클릭하거나 파일을 끌어다 놓으세요</p>
                                        <small>PDF · DOC · XLS · JPG · PNG</small>
                                        <input type="file" id="fileInput" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.png" style="display:none">
                                    </div>
                                    <div class="file-list" id="fileList"></div>
                                </div>

                            </div><!-- /modal-body -->

                            <div class="modal-footer">
                                <button type="button" class="btn btn-danger"    id="partnerDeleteBtn"   data-action="openDeleteConfirm" style="display:none; margin-right:auto;">
                                    <span class="material-symbols-rounded">delete</span>삭제
                                </button>
                                <button type="button" class="btn btn-secondary" data-action="closePartnerModal">취소</button>
                                <button type="button" class="btn btn-primary"   id="partnerEditBtn"     data-action="changeToEdit"      style="display:none;">수정하기</button>
                                <button type="submit"  class="btn btn-primary"  id="partnerSaveBtn">저장</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     모달 : 삭제 확인
                     PARTNER + FACILITY_CONTRACT 연쇄 삭제
                ══════════════════════════════════════ -->
                <div class="modal-overlay" id="partnerDeleteModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title">업체 삭제</h3>
                            <button type="button" class="modal-close" data-action="closeDeleteModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="delete-warning">
                                <span class="material-symbols-rounded delete-warning-icon">warning</span>
                                <div class="delete-warning-text">
                                    선택한 업체를 삭제하시겠습니까?<br>
                                    연결된 계약(FACILITY_CONTRACT) 및<br>
                                    점검이력(FACILITY_CHECK_HSTRY)도 함께 삭제됩니다.
                                </div>
                            </div>
                            <div class="mngr-detail-grid" id="partnerDeleteInfo"></div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
                            <button type="button" class="btn btn-danger"    id="partnerDeleteConfirmBtn">삭제</button>
                        </div>
                    </div>
                </div>

            </div><!-- /office-page #partnerPage -->

            <script>
                (function () {
                    var page = document.getElementById('partnerPage');
                    if (!page || page.dataset.bound === 'true') return;
                    page.dataset.bound = 'true';

                    /* ── 공통코드 매핑 ── */
                    // BID_TY
                    var BID_TEXT  = { GEN:'일반경쟁입찰', LIM:'제한경쟁입찰', SEL:'지명경쟁입찰', PRT:'수의계약' };
                    var BID_BADGE = { GEN:'badge-blue',   LIM:'badge-purple',  SEL:'badge-orange', PRT:'badge-gray' };
                    // CONTRACT_STTS
                    var STTS_TEXT  = { ACTIVE:'유효',      EXPIRE:'만료예정', END:'종료',   TERM:'해지',  DRAFT:'작성중' };
                    var STTS_BADGE = { ACTIVE:'badge-green',EXPIRE:'badge-yellow',END:'badge-gray',TERM:'badge-red',DRAFT:'badge-blue' };
                    // FACILITY_TY
                    var FAC_TEXT  = { ELV:'승강기', WTR:'급수시설', ELC:'전기시설', GAS:'가스시설', FIRE:'소방시설', SEC:'보안시설', ETC:'기타시설' };
                    var FAC_BADGE = { ELV:'badge-blue', WTR:'badge-green', ELC:'badge-yellow', GAS:'badge-orange', FIRE:'badge-red', SEC:'badge-purple', ETC:'badge-gray' };
                    // CHECK_TY
                    var CHK_TY_TEXT = { REG:'정기점검', SPC:'특별점검', SAFE:'안전점검', REPAIR:'보수점검' };
                    // CHECK_STTS
                    var CHK_ST_TEXT  = { WAIT:'점검대기', ING:'점검중', DONE:'점검완료', FAULT:'이상발견' };
                    var CHK_ST_BADGE = { WAIT:'badge-yellow', ING:'badge-blue', DONE:'badge-green', FAULT:'badge-red' };

                    var AVATAR_COLORS = ['#2e5c38','#1d4ed8','#7c3aed','#c2410c','#0e7490','#b45309','#be123c','#4d7c0f'];

                    /* ── 더미 데이터 (백엔드 연결 시 AJAX 대체) ── */

                    // PARTNER JOIN FACILITY_CONTRACT (최신 계약 1건)
                    var partnerData = [
                        { partnerNo:'PT-001', partnerNm:'승강기관리(주)', bizTyNm:'승강기', bizrno:'123-45-67890', picNm:'김철수', picTelno:'010-1234-5678', picEmail:'kim@elv.co.kr',
                            contNo:'CT-001', contNm:'2025 승강기 유지보수 계약',  contSttsCd:'EXPIRE', bidTyCd:'GEN', contAmt:48000000, contBgngDt:'2025-01-01', contEndDt:'2026-05-07', facilityNo:'FAC-001', facilityTyCd:'ELV' },
                        { partnerNo:'PT-002', partnerNm:'한국소방안전',   bizTyNm:'소방',   bizrno:'234-56-78901', picNm:'이영희', picTelno:'010-2345-6789', picEmail:'lee@fire.co.kr',
                            contNo:'CT-002', contNm:'소방시설 정기점검 계약',    contSttsCd:'EXPIRE', bidTyCd:'LIM', contAmt:15000000, contBgngDt:'2025-04-01', contEndDt:'2026-05-12', facilityNo:'FAC-004', facilityTyCd:'FIRE' },
                        { partnerNo:'PT-003', partnerNm:'청정환경서비스', bizTyNm:'청소',   bizrno:'345-67-89012', picNm:'박민준', picTelno:'010-3456-7890', picEmail:'park@clean.co.kr',
                            contNo:'CT-003', contNm:'단지 청소 용역 계약',       contSttsCd:'ACTIVE', bidTyCd:'PRT', contAmt:36000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-006', facilityTyCd:'ETC' },
                        { partnerNo:'PT-004', partnerNm:'대한전기(주)',   bizTyNm:'전기',   bizrno:'456-78-90123', picNm:'최지원', picTelno:'010-4567-8901', picEmail:'choi@elec.co.kr',
                            contNo:'CT-004', contNm:'전기설비 유지관리 계약',    contSttsCd:'ACTIVE', bidTyCd:'GEN', contAmt:24000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-003', facilityTyCd:'ELC' },
                        { partnerNo:'PT-005', partnerNm:'보안솔루션',     bizTyNm:'보안',   bizrno:'567-89-01234', picNm:'정수진', picTelno:'010-5678-9012', picEmail:'jung@sec.co.kr',
                            contNo:'CT-005', contNm:'CCTV 운영 및 보안 계약',   contSttsCd:'ACTIVE', bidTyCd:'SEL', contAmt:18000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-006', facilityTyCd:'SEC' },
                        { partnerNo:'PT-006', partnerNm:'가스안전(주)',   bizTyNm:'가스',   bizrno:'678-90-12345', picNm:'강동원', picTelno:'010-6789-0123', picEmail:'kang@gas.co.kr',
                            contNo:'CT-006', contNm:'가스시설 안전관리 계약',    contSttsCd:'ACTIVE', bidTyCd:'LIM', contAmt:12000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-005', facilityTyCd:'GAS' },
                        { partnerNo:'PT-007', partnerNm:'푸른급수관리',   bizTyNm:'급수',   bizrno:'789-01-23456', picNm:'윤소희', picTelno:'010-7890-1234', picEmail:'yoon@water.co.kr',
                            contNo:'CT-007', contNm:'급수시설 유지보수 계약',    contSttsCd:'ACTIVE', bidTyCd:'PRT', contAmt:9600000,  contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-005', facilityTyCd:'WTR' },
                        { partnerNo:'PT-008', partnerNm:'e편한안전',      bizTyNm:'소방',   bizrno:'901-23-45678', picNm:'서지훈', picTelno:'010-9012-3456', picEmail:'seo@safe.co.kr',
                            contNo:'CT-008', contNm:'소화기 관리 용역',          contSttsCd:'END',    bidTyCd:'PRT', contAmt:8400000,  contBgngDt:'2025-01-01', contEndDt:'2025-12-31', facilityNo:'FAC-004', facilityTyCd:'FIRE' },
                        { partnerNo:'PT-009', partnerNm:'KD승강기서비스', bizTyNm:'승강기', bizrno:'222-33-44444', picNm:'장민서', picTelno:'010-2222-3333', picEmail:'jang@kd.co.kr',
                            contNo:'CT-009', contNm:'2호기 승강기 유지보수',     contSttsCd:'ACTIVE', bidTyCd:'GEN', contAmt:24000000, contBgngDt:'2026-01-01', contEndDt:'2026-12-31', facilityNo:'FAC-002', facilityTyCd:'ELV' },
                    ];

                    // FACILITY_CHECK_HSTRY rows
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

                    var deleteTargetIdx = null;
                    var currentIdx      = null;
                    var uploadedFiles   = [];

                    /* ── 헬퍼 ── */
                    function b(cls, text) { return '<span class="badge ' + cls + '">' + text + '</span>'; }
                    function sttsB(cd)  { return b(STTS_BADGE[cd]  || 'badge-gray', STTS_TEXT[cd]  || cd); }
                    function facB(cd)   { return b(FAC_BADGE[cd]   || 'badge-gray', FAC_TEXT[cd]   || cd); }
                    function bidB(cd)   { return b(BID_BADGE[cd]   || 'badge-gray', BID_TEXT[cd]   || cd); }
                    function chkStB(cd) { return b(CHK_ST_BADGE[cd]|| 'badge-gray', CHK_ST_TEXT[cd]|| cd); }

                    function calcDday(endDt) {
                        if (!endDt) return null;
                        return Math.ceil((new Date(endDt) - new Date()) / 86400000);
                    }

                    function ddayHtml(p) {
                        if (p.contSttsCd === 'END' || p.contSttsCd === 'TERM') return '';
                        var d = calcDday(p.contEndDt);
                        if (d === null) return '';
                        if (d <= 30)  return '<span class="dday dday-danger">D-' + d + '</span>';
                        if (d <= 90)  return '<span class="dday dday-warn">D-' + d + '</span>';
                        return '<span class="dday dday-ok">D-' + d + '</span>';
                    }

                    function fmtAmt(n) { return Number(n).toLocaleString() + '원'; }

                    /* ── 요약 카드 + 배너 ── */
                    function updateStats(data) {
                        document.getElementById('statTotal').textContent  = data.length;
                        document.getElementById('statActive').textContent = data.filter(function (r) { return r.contSttsCd === 'ACTIVE'; }).length;
                        document.getElementById('statEnd').textContent    = data.filter(function (r) { return r.contSttsCd === 'END'; }).length;

                        var expList = data.filter(function (r) {
                            var d = calcDday(r.contEndDt);
                            return d !== null && d >= 0 && d <= 30 && r.contSttsCd !== 'END' && r.contSttsCd !== 'TERM';
                        });
                        document.getElementById('statExpire').textContent = expList.length;

                        var banner = document.getElementById('expireBanner');
                        if (expList.length > 0) {
                            banner.style.display = 'flex';
                            document.getElementById('expireBannerText').textContent =
                                '30일 이내 계약 만료 예정 업체가 ' + expList.length + '개 있습니다. 계약 갱신 또는 재입찰을 검토해 주세요.';
                            var chips = document.getElementById('expireChips');
                            chips.innerHTML = '';
                            expList.forEach(function (r) {
                                var d = calcDday(r.contEndDt);
                                var chip = document.createElement('span');
                                chip.className   = 'expire-chip';
                                chip.textContent = r.partnerNm + '  D-' + d;
                                chip.addEventListener('click', function () {
                                    document.getElementById('filterKeyword').value = r.partnerNm;
                                    renderPartnerGrid(partnerData.filter(function (p) { return p.partnerNm === r.partnerNm; }));
                                    switchTab('tab-partner');
                                });
                                chips.appendChild(chip);
                            });
                        } else {
                            banner.style.display = 'none';
                        }
                    }

                    /* ── 탭 전환 ── */
                    function switchTab(tabId) {
                        page.querySelectorAll('.tab-panel').forEach(function (el) { el.classList.remove('active'); });
                        page.querySelectorAll('.tab-btn').forEach(function (btn) {
                            btn.classList.toggle('active', btn.dataset.tab === tabId);
                        });
                        var panel = document.getElementById(tabId);
                        if (panel) panel.classList.add('active');
                    }
                    page.querySelectorAll('.tab-btn').forEach(function (btn) {
                        btn.addEventListener('click', function () { switchTab(btn.dataset.tab); });
                    });

                    /* ── 탭1 : 업체 카드 렌더 (PARTNER) ── */
                    function renderPartnerGrid(data) {
                        var grid = document.getElementById('partnerGrid');
                        document.getElementById('partnerListCount').textContent = data.length + '건';
                        if (data.length === 0) {
                            grid.innerHTML = '<p style="padding:40px;text-align:center;color:var(--text-tertiary);font-size:13px;">조건에 맞는 업체가 없습니다.</p>';
                            return;
                        }
                        grid.innerHTML = data.map(function (p, i) {
                            var color = AVATAR_COLORS[i % AVATAR_COLORS.length];
                            return '<div class="partner-card">'
                                + '<div class="card-top">'
                                + '  <div class="card-avatar" style="background:' + color + '">' + p.partnerNm.substring(0,2) + '</div>'
                                + '  ' + sttsB(p.contSttsCd)
                                + '</div>'
                                /* PARTNER_NM */
                                + '<div class="card-name">' + p.partnerNm + '</div>'
                                /* BIZ_TY_NM · BIZRNO */
                                + '<div class="card-biz">' + p.bizTyNm + '  ·  ' + p.bizrno + '</div>'
                                + '<div class="card-meta">'
                                /* PIC_NM · PIC_TELNO */
                                + '  <div class="card-meta-row"><span class="material-symbols-rounded">person</span>' + p.picNm + '  (' + p.picTelno + ')</div>'
                                /* PIC_EMAIL */
                                + '  <div class="card-meta-row"><span class="material-symbols-rounded">email</span>' + p.picEmail + '</div>'
                                + '</div>'
                                + '<div class="card-divider"></div>'
                                + '<div class="card-cont">'
                                + '  <div>'
                                /* CONT_NM */
                                + '    <div class="c-label">CONT_NM</div>'
                                + '    <div class="c-val" style="max-width:160px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">' + p.contNm + '</div>'
                                /* CONT_BGNG_DT ~ CONT_END_DT */
                                + '    <div class="c-date">' + p.contBgngDt + ' ~ ' + p.contEndDt + '</div>'
                                + '  </div>'
                                + '  <div style="text-align:right;">'
                                /* CONT_AMT */
                                + '    <div class="c-label">CONT_AMT</div>'
                                + '    <div class="c-val">' + fmtAmt(p.contAmt) + '</div>'
                                + '    ' + ddayHtml(p)
                                + '  </div>'
                                + '</div>'
                                + '<div class="card-actions">'
                                + '  <button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + i + '">상세</button>'
                                + '  <button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + i + '">수정</button>'
                                + '  <button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="' + i + '">삭제</button>'
                                + '</div>'
                                + '</div>';
                        }).join('');
                    }

                    /* ── 탭2 : 계약 테이블 렌더 (FACILITY_CONTRACT) ── */
                    function renderContractTable(data) {
                        var tbody = document.getElementById('contractTbody');
                        document.getElementById('contractListCount').textContent = data.length + '건';
                        if (data.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="9" class="empty-row">조건에 맞는 계약이 없습니다.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = data.map(function (p, i) {
                            return '<tr>'
                                + '<td class="td-mono">' + p.contNo + '</td>'                                                                        /* CONT_NO */
                                + '<td class="td-bold" style="max-width:180px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">' + p.contNm + '</td>' /* CONT_NM */
                                + '<td>' + p.partnerNm + '</td>'                                                                                    /* PARTNER_NM */
                                + '<td class="col-center">' + facB(p.facilityTyCd) + '</td>'                                                        /* FACILITY_TY_CD */
                                + '<td class="col-center">' + bidB(p.bidTyCd) + '</td>'                                                             /* BID_TY_CD */
                                + '<td class="col-right td-bold">' + fmtAmt(p.contAmt) + '</td>'                                                    /* CONT_AMT */
                                + '<td style="font-size:12px;white-space:nowrap;">' + p.contBgngDt + '<br><span style="color:var(--text-tertiary)">~ ' + p.contEndDt + '</span></td>' /* CONT_BGNG_DT ~ CONT_END_DT */
                                + '<td class="col-center">' + sttsB(p.contSttsCd) + (ddayHtml(p) ? '<br>' + ddayHtml(p) : '') + '</td>'            /* CONT_STTS_CD */
                                + '<td class="col-manage"><div class="grid-actions">'
                                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + i + '">상세</button>'
                                + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + i + '">수정</button>'
                                + '</div></td>'
                                + '</tr>';
                        }).join('');
                    }

                    /* ── 탭3 : 점검이력 테이블 렌더 (FACILITY_CHECK_HSTRY) ── */
                    function renderHistoryTable(data) {
                        var tbody = document.getElementById('historyTbody');
                        document.getElementById('historyListCount').textContent = data.length + '건';
                        if (data.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="9" class="empty-row">조건에 맞는 이력이 없습니다.</td></tr>';
                            return;
                        }
                        tbody.innerHTML = data.map(function (h) {
                            return '<tr>'
                                + '<td class="td-mono">' + h.facChkHstryNo + '</td>'                                                                /* FAC_CHK_HSTRY_NO */
                                + '<td class="td-bold">' + h.partnerNm + '</td>'                                                                    /* PARTNER_NO → NM join */
                                + '<td>' + h.facilityNo + '</td>'                                                                                   /* FACILITY_NO */
                                + '<td class="col-center"><span class="badge badge-gray">' + (CHK_TY_TEXT[h.chkTyCd] || h.chkTyCd) + '</span></td>'/* CHK_TY_CD */
                                + '<td class="col-center">' + h.chkDt + '</td>'                                                                     /* CHK_DT */
                                + '<td class="col-center">' + chkStB(h.chkSttsCd) + '</td>'                                                        /* CHK_STTS_CD */
                                + '<td style="max-width:220px;font-size:12px;">' + h.chkCn + '</td>'                                                /* CHK_CN */
                                + '<td style="font-size:12px;color:' + (h.rmk ? 'var(--red)' : 'var(--text-tertiary)') + ';">' + (h.rmk || '—') + '</td>' /* RMK */
                                + '<td class="col-manage"><div class="grid-actions">'
                                + '<button type="button" class="btn btn-xs btn-detail" data-action="detailHistory" data-id="' + h.facChkHstryNo + '">상세</button>'
                                + '</div></td>'
                                + '</tr>';
                        }).join('');
                    }

                    /* ── 필터 ── */
                    function getFilteredPartners() {
                        var bizTy = document.getElementById('filterBizTy').value;
                        var stts  = document.getElementById('filterContStts').value;
                        var kw    = document.getElementById('filterKeyword').value.trim();
                        return partnerData.filter(function (p) {
                            var d = calcDday(p.contEndDt);
                            var isExpire = d !== null && d >= 0 && d <= 30 && p.contSttsCd !== 'END' && p.contSttsCd !== 'TERM';
                            return (!bizTy || p.bizTyNm === bizTy)
                                && (!stts  || p.contSttsCd === stts || (stts === 'EXPIRE' && isExpire))
                                && (!kw    || p.partnerNm.indexOf(kw) > -1 || p.picNm.indexOf(kw) > -1 || p.bizrno.indexOf(kw) > -1);
                        });
                    }
                    function getFilteredContracts() {
                        var stts  = document.getElementById('filterContStts2').value;
                        var bidTy = document.getElementById('filterBidTy').value;
                        var start = document.getElementById('filterContStart').value;
                        var end   = document.getElementById('filterContEnd').value;
                        var kw    = document.getElementById('filterContKeyword').value.trim();
                        return partnerData.filter(function (p) {
                            var d = calcDday(p.contEndDt);
                            var isExpire = d !== null && d >= 0 && d <= 30 && p.contSttsCd !== 'END' && p.contSttsCd !== 'TERM';
                            return (!stts  || p.contSttsCd === stts || (stts === 'EXPIRE' && isExpire))
                                && (!bidTy || p.bidTyCd === bidTy)
                                && (!start || p.contBgngDt >= start)
                                && (!end   || p.contEndDt  <= end)
                                && (!kw    || p.contNm.indexOf(kw) > -1 || p.partnerNm.indexOf(kw) > -1);
                        });
                    }
                    function getFilteredHistory() {
                        var ty    = document.getElementById('filterChkTy').value;
                        var stts  = document.getElementById('filterChkStts').value;
                        var start = document.getElementById('filterChkStart').value;
                        var end   = document.getElementById('filterChkEnd').value;
                        var kw    = document.getElementById('filterHstryKeyword').value.trim();
                        return historyData.filter(function (h) {
                            return (!ty   || h.chkTyCd   === ty)
                                && (!stts || h.chkSttsCd === stts)
                                && (!start|| h.chkDt     >= start)
                                && (!end  || h.chkDt     <= end)
                                && (!kw   || h.facChkHstryNo.indexOf(kw) > -1 || h.facilityNo.indexOf(kw) > -1 || h.partnerNm.indexOf(kw) > -1);
                        });
                    }

                    /* ── 모달 제어 ── */
                    var partnerModal       = document.getElementById('partnerModal');
                    var partnerDeleteModal = document.getElementById('partnerDeleteModal');
                    var form               = document.getElementById('partnerForm');
                    var modalTitle         = document.getElementById('partnerModalTitle');
                    var saveBtn            = document.getElementById('partnerSaveBtn');
                    var editBtn            = document.getElementById('partnerEditBtn');
                    var deleteBtn          = document.getElementById('partnerDeleteBtn');

                    function openModal(mode, idx) {
                        form.reset();
                        document.getElementById('fileList').innerHTML = '';
                        uploadedFiles = [];
                        currentIdx = (idx !== undefined) ? idx : null;
                        saveBtn.style.display   = 'inline-flex';
                        editBtn.style.display   = 'none';
                        deleteBtn.style.display = 'none';
                        setFormDisabled(false);

                        if (mode === 'register') { modalTitle.textContent = '협력업체 등록'; }

                        if (mode === 'detail' && currentIdx !== null) {
                            modalTitle.textContent = '협력업체 상세';
                            fillForm(partnerData[currentIdx]);
                            setFormDisabled(true);
                            saveBtn.style.display   = 'none';
                            editBtn.style.display   = 'inline-flex';
                            deleteBtn.style.display = 'inline-flex';
                            editBtn.dataset.idx = currentIdx;
                        }

                        if (mode === 'edit' && currentIdx !== null) {
                            modalTitle.textContent  = '협력업체 수정';
                            fillForm(partnerData[currentIdx]);
                            deleteBtn.style.display = 'inline-flex';
                        }

                        partnerModal.classList.add('open');
                    }

                    function fillForm(p) {
                        document.getElementById('partnerNo').value   = p.partnerNo  || '';
                        document.getElementById('partnerNm').value   = p.partnerNm  || '';
                        document.getElementById('bizTyNm').value     = p.bizTyNm    || '';
                        document.getElementById('bizrno').value      = p.bizrno     || '';
                        document.getElementById('picNm').value       = p.picNm      || '';
                        document.getElementById('picTelno').value    = p.picTelno   || '';
                        document.getElementById('picEmail').value    = p.picEmail   || '';
                        document.getElementById('contNo').value      = p.contNo     || '';
                        document.getElementById('contNm').value      = p.contNm     || '';
                        document.getElementById('facilityNo').value  = p.facilityNo || '';
                        document.getElementById('bidTyCd').value     = p.bidTyCd    || '';
                        document.getElementById('contAmt').value     = p.contAmt    || '';
                        document.getElementById('contBgngDt').value  = p.contBgngDt || '';
                        document.getElementById('contEndDt').value   = p.contEndDt  || '';
                        document.getElementById('contSttsCd').value  = p.contSttsCd || 'DRAFT';
                    }

                    function setFormDisabled(disabled) {
                        form.querySelectorAll('input, select, textarea').forEach(function (el) { el.disabled = disabled; });
                    }

                    function closePartnerModal() {
                        partnerModal.classList.remove('open');
                        setFormDisabled(false);
                        currentIdx = null;
                    }

                    function openDeleteConfirm(idx) {
                        deleteTargetIdx = idx;
                        var p = partnerData[idx];
                        document.getElementById('partnerDeleteInfo').innerHTML =
                            '<div class="mngr-detail-item"><div class="mngr-detail-label">업체번호 · PARTNER_NO</div><div class="mngr-detail-value">' + p.partnerNo + '</div></div>'
                            + '<div class="mngr-detail-item"><div class="mngr-detail-label">업체명 · PARTNER_NM</div><div class="mngr-detail-value">' + p.partnerNm + '</div></div>'
                            + '<div class="mngr-detail-item"><div class="mngr-detail-label">업종 · BIZ_TY_NM</div><div class="mngr-detail-value">' + p.bizTyNm + '</div></div>'
                            + '<div class="mngr-detail-item"><div class="mngr-detail-label">계약번호 · CONT_NO</div><div class="mngr-detail-value">' + p.contNo + '</div></div>';
                        partnerDeleteModal.classList.add('open');
                    }

                    function closeDeleteModal() { partnerDeleteModal.classList.remove('open'); deleteTargetIdx = null; }

                    /* ── 파일 업로드 UI ── */
                    document.getElementById('fileInput').addEventListener('change', function () {
                        var list = document.getElementById('fileList');
                        Array.prototype.slice.call(this.files).forEach(function (f) {
                            if (uploadedFiles.length >= 5) return;
                            uploadedFiles.push(f.name);
                            var item = document.createElement('div');
                            item.className = 'file-item';
                            item.innerHTML = '<span class="material-symbols-rounded">description</span>'
                                + '<span class="f-name">' + f.name + '</span>'
                                + '<span style="color:var(--text-tertiary);font-size:11px;">' + (f.size/1024).toFixed(1) + ' KB</span>'
                                + '<button type="button" class="file-remove" data-fname="' + f.name + '">'
                                + '<span class="material-symbols-rounded" style="font-size:16px;">close</span></button>';
                            list.appendChild(item);
                        });
                        this.value = '';
                    });

                    document.getElementById('fileList').addEventListener('click', function (e) {
                        var btn = e.target.closest('.file-remove');
                        if (!btn) return;
                        uploadedFiles = uploadedFiles.filter(function (n) { return n !== btn.dataset.fname; });
                        btn.closest('.file-item').remove();
                    });

                    /* ── 이벤트 위임 ── */
                    page.addEventListener('click', function (e) {
                        var btn = e.target.closest('[data-action]');
                        if (!btn) return;
                        var action = btn.dataset.action;
                        var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

                        if (action === 'openRegister')       openModal('register');
                        if (action === 'detail')             openModal('detail', idx);
                        if (action === 'edit')               openModal('edit',   idx);
                        if (action === 'changeToEdit')       openModal('edit',   Number(editBtn.dataset.idx));
                        if (action === 'closePartnerModal')  closePartnerModal();
                        if (action === 'delete')             openDeleteConfirm(idx);
                        if (action === 'openDeleteConfirm')  openDeleteConfirm(currentIdx);
                        if (action === 'closeDeleteModal')   closeDeleteModal();
                        if (action === 'detailHistory')      alert('백엔드 연결 시 FAC_CHK_HSTRY_NO=' + btn.dataset.id + ' 기준 조회');

                        if (action === 'searchPartner')  renderPartnerGrid(getFilteredPartners());
                        if (action === 'searchContract') renderContractTable(getFilteredContracts());
                        if (action === 'searchHistory')  renderHistoryTable(getFilteredHistory());

                        if (action === 'resetFilter') {
                            ['filterBizTy','filterContStts','filterKeyword'].forEach(function (id) { document.getElementById(id).value = ''; });
                            renderPartnerGrid(partnerData);
                        }
                        if (action === 'resetContFilter') {
                            ['filterContStts2','filterBidTy','filterContStart','filterContEnd','filterContKeyword'].forEach(function (id) { document.getElementById(id).value = ''; });
                            renderContractTable(partnerData);
                        }
                        if (action === 'resetHstryFilter') {
                            ['filterChkTy','filterChkStts','filterChkStart','filterChkEnd','filterHstryKeyword'].forEach(function (id) { document.getElementById(id).value = ''; });
                            renderHistoryTable(historyData);
                        }
                    });

                    /* 삭제 확인 */
                    document.getElementById('partnerDeleteConfirmBtn').addEventListener('click', function () {
                        if (deleteTargetIdx === null) return;
                        partnerData.splice(deleteTargetIdx, 1);
                        renderPartnerGrid(partnerData);
                        renderContractTable(partnerData);
                        updateStats(partnerData);
                        closeDeleteModal();
                        closePartnerModal();
                        alert('삭제되었습니다. (PARTNER + FACILITY_CONTRACT 연쇄 삭제)');
                    });

                    /* 폼 저장 */
                    form.addEventListener('submit', function (e) {
                        e.preventDefault();
                        if (!document.getElementById('partnerNm').value.trim()) { alert('업체명을 입력하세요.'); return; }
                        alert('저장 — 백엔드 연결 시 PARTNER insert/update + FACILITY_CONTRACT insert/update로 처리하면 됩니다.');
                        closePartnerModal();
                    });

                    /* 배경 클릭 닫기 */
                    partnerModal.addEventListener('click', function (e) { if (e.target === partnerModal) closePartnerModal(); });
                    partnerDeleteModal.addEventListener('click', function (e) { if (e.target === partnerDeleteModal) closeDeleteModal(); });

                    /* ── 초기 렌더 ── */
                    updateStats(partnerData);
                    renderPartnerGrid(partnerData);
                    renderContractTable(partnerData);
                    renderHistoryTable(historyData);
                })();
            </script>

        </main>
    </div>
</div>
</body>
</html>
