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
        #partnerPage {
            --accent:        #265c30;
            --accent-light:  #dceee0;
            --accent-dim:    rgba(38,92,48,.08);
            --surface:       #ffffff;
            --surface-sub:   #f7f8f6;
            --line:          #e3e6e2;
            --th-bg:         #f0f2ef;
            --text-head:     #1a2e1e;
        }

        #partnerPage .page-title-block h2 { color: var(--text-head); font-size: 19px; letter-spacing: -0.5px; }
        #partnerPage .page-title-block p  { color: #6b7a6e; font-size: 12px; }

        /* ── 요약 카드 ── */
        #partnerPage .summary-row  { gap: 10px; margin-bottom: 18px; }
        #partnerPage .summary-card { padding: 14px 18px; border-radius: 6px; border: 1px solid var(--line); box-shadow: none; gap: 12px; }
        #partnerPage .summary-card .s-icon  { width: 36px; height: 36px; border-radius: 6px; }
        #partnerPage .summary-card .s-val   { font-size: 22px; font-weight: 800; color: var(--text-head); }
        #partnerPage .summary-card .s-label { font-size: 11px; color: #7a8a7d; margin-top: 2px; }

        #partnerPage .summary-card.s-green  { background: var(--accent); border-color: #1a3d1f; }
        #partnerPage .summary-card.s-green .s-icon { background: rgba(255,255,255,.15); }
        #partnerPage .summary-card.s-green .s-icon .material-symbols-rounded { color: #fff; }
        #partnerPage .summary-card.s-green .s-val   { color: #fff; }
        #partnerPage .summary-card.s-green .s-label { color: rgba(255,255,255,.65); }

        /* ── 패널 ── */
        #partnerPage .panel { border-radius: 6px; border: 1px solid var(--line); box-shadow: none; margin: 0; }

        /* ── 인라인 필터 ── */
        #partnerPage .inpanel-filter {
            display: flex; gap: 7px; align-items: center; flex-wrap: wrap;
            padding: 10px 16px;
            border-bottom: 1px solid var(--line);
            background: var(--surface-sub);
            border-radius: 6px 6px 0 0;
        }
        #partnerPage .inpanel-filter .form-input,
        #partnerPage .inpanel-filter .form-select { height: 30px; font-size: 12px; border-color: var(--line); background: var(--surface); border-radius: 4px; }
        #partnerPage .inpanel-filter .form-input:focus,
        #partnerPage .inpanel-filter .form-select:focus { border-color: var(--accent); box-shadow: 0 0 0 2px var(--accent-dim); }
        #partnerPage .inpanel-filter .btn { min-height: 30px; font-size: 12px; padding: 0 12px; border-radius: 4px; }
        #partnerPage .inpanel-filter .search-wrap { position: relative; }
        #partnerPage .inpanel-filter .search-wrap .material-symbols-rounded { position: absolute; left: 8px; top: 50%; transform: translateY(-50%); font-size: 14px; color: #9caa9e; pointer-events: none; }
        #partnerPage .inpanel-filter .search-wrap input { padding-left: 28px; width: 200px; }
        #partnerPage .inpanel-filter .list-count { margin-left: auto; font-size: 11px; font-weight: 700; color: var(--accent); background: var(--accent-light); border-radius: 3px; padding: 2px 8px; }

        /* ── 테이블 ── */
        #partnerPage .table-wrap { padding: 0; overflow-x: auto; }
        #partnerPage .tbl { font-size: 12px; }
        #partnerPage thead th { padding: 9px 14px; background: var(--th-bg); border-bottom: 1px solid var(--line); color: #4a5c4e; font-size: 11px; font-weight: 700; white-space: nowrap; }
        #partnerPage thead th small { display: block; font-weight: 400; color: #9caa9e; font-size: 10px; margin-top: 1px; font-family: 'SF Mono','Consolas',monospace; }
        #partnerPage tbody td { padding: 10px 14px; border-bottom: 1px solid var(--line); color: #374151; vertical-align: middle; }
        #partnerPage tbody tr:last-child td { border-bottom: none; }
        #partnerPage tbody tr:hover td { background: #f4f7f4; }
        #partnerPage .td-bold { font-weight: 600; color: #111827; }
        #partnerPage .td-mono { font-family: 'SF Mono','Consolas',monospace; font-size: 11px; color: #6b7a6e; }

        /* ── 배지 ── */
        #partnerPage .badge { padding: 2px 7px; border-radius: 3px; font-size: 11px; font-weight: 700; }
        #partnerPage .badge-green  { background: #dceee0; color: #1a3d1f; }
        #partnerPage .badge-yellow { background: #fef3c7; color: #713f12; }
        #partnerPage .badge-red    { background: #fee2e2; color: #7f1d1d; }
        #partnerPage .badge-gray   { background: #e9ece9; color: #374151; }
        #partnerPage .badge-blue   { background: #dbeafe; color: #1e3a5f; }
        #partnerPage .badge-orange { background: #ffedd5; color: #7c2d12; }
        #partnerPage .badge-purple { background: #ede9fe; color: #4c1d95; }
        #partnerPage .badge-teal   { background: #ccfbf1; color: #134e4a; }

        /* ── 버튼 ── */
        #partnerPage .btn { border-radius: 4px; }
        #partnerPage .btn-primary  { background: var(--accent); }
        #partnerPage .btn-primary:hover { background: #1a3d1f; }
        #partnerPage .btn-secondary { border-color: var(--line); }
        #partnerPage .col-center { text-align: center !important; }
        #partnerPage .col-right  { text-align: right  !important; }
        #partnerPage .col-manage { text-align: center !important; width: 110px; }
        #partnerPage .grid-actions { display: inline-flex; gap: 5px; }
        #partnerPage .empty-row { text-align: center !important; color: #9caa9e; padding: 40px !important; font-size: 13px; }

        /* ── 모달 ── */
        .modal { border-radius: 6px !important; }
        .modal-header.primary { background: #1a2e1e; }
        .modal-header.primary .modal-title { color: #fff; }
        .modal-header.primary .modal-close { color: rgba(255,255,255,.6); border-color: rgba(255,255,255,.15); background: rgba(255,255,255,.08); }
        .modal-header.primary .modal-close:hover { background: rgba(255,255,255,.15); color: #fff; }
        .form-section-title { letter-spacing: 0; text-transform: none; font-size: 11px; font-weight: 800; color: #4a5c4e; }

        /* ── 삭제 경고 ── */
        #partnerPage .del-warn {
            display: flex; gap: 10px; padding: 11px 13px;
            background: #fff5f5; border-left: 3px solid #ef4444;
            border-top: 1px solid #fecaca; border-bottom: 1px solid #fecaca; border-right: 1px solid #fecaca;
            border-radius: 0 4px 4px 0; margin-bottom: 14px;
            font-size: 12px; color: #7f1d1d; line-height: 1.6;
        }
        #partnerPage .del-warn .material-symbols-rounded { color: #dc2626; font-size: 16px; flex-shrink: 0; margin-top: 2px; }

        /* ── 유틸리티 API 섹션 ── */
        #partnerPage .util-section {
            background: #f0f9ff;
            border: 1px solid #bae6fd;
            border-radius: 4px;
            padding: 12px 14px;
            margin-top: 4px;
        }
        #partnerPage .util-section .util-label {
            font-size: 11px; font-weight: 800; color: #0369a1; margin-bottom: 8px;
            display: flex; align-items: center; gap: 5px;
        }
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
                        <p>일반 협력업체 및 유틸리티 공급기관을 등록·조회·관리합니다</p>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-primary" data-action="openRegister">
                            <span class="material-symbols-rounded">add</span>업체 등록
                        </button>
                    </div>
                </div>

                <!-- ══ 요약 카드 ══ -->
                <div class="summary-row">
                    <div class="summary-card s-green">
                        <div class="s-icon"><span class="material-symbols-rounded">store</span></div>
                        <div>
                            <div class="s-val" id="statTotal">0</div>
                            <div class="s-label">전체 등록 업체 · PARTNER</div>
                        </div>
                    </div>
                    <div class="summary-card s-blue">
                        <div class="s-icon"><span class="material-symbols-rounded">handshake</span></div>
                        <div>
                            <div class="s-val" id="statGeneral">0</div>
                            <div class="s-label">일반 협력업체</div>
                        </div>
                    </div>
                    <div class="summary-card s-teal">
                        <div class="s-icon"><span class="material-symbols-rounded">electric_bolt</span></div>
                        <div>
                            <div class="s-val" id="statUtility">0</div>
                            <div class="s-label">유틸리티 공급기관 · UTILITY_PROVIDER</div>
                        </div>
                    </div>
                    <div class="summary-card s-gray">
                        <div class="s-icon"><span class="material-symbols-rounded">block</span></div>
                        <div>
                            <div class="s-val" id="statInactive">0</div>
                            <div class="s-label">비활성 업체 · USE_YN=N</div>
                        </div>
                    </div>
                </div>

                <!-- ══ 탭 ══ -->
                <div class="tab-bar">
                    <button type="button" class="tab-btn active" data-tab="tab-general">
                        <span class="material-symbols-rounded">store</span>일반 협력업체
                    </button>
                    <button type="button" class="tab-btn" data-tab="tab-utility">
                        <span class="material-symbols-rounded">electric_bolt</span>유틸리티 공급기관
                    </button>
                </div>

                <!-- ══════════════════════════════════════
                     탭 1 : 일반 협력업체
                     ERD  : PARTNER (UTILITY_PROVIDER.METER_WRK_NO IS NULL)
                     - 소방, 청소, 전기, 승강기 등 시설 유지보수 계약 업체
                     - FACILITY_CONTRACT 와 연결됨
                ══════════════════════════════════════ -->
                <div class="tab-panel active" id="tab-general">
                    <div class="panel">
                        <div class="inpanel-filter">
                            <%-- BIZ_TY_NM --%>
                            <select class="form-select" id="filterBizTy" style="width:110px;">
                                <option value="">업종 전체</option>
                                <option>승강기</option>
                                <option>소방</option>
                                <option>전기</option>
                                <option>가스</option>
                                <option>급수</option>
                                <option>보안</option>
                                <option>청소</option>
                                <option>기타</option>
                            </select>
                            <%-- USE_YN --%>
                            <select class="form-select" id="filterUseYn" style="width:90px;">
                                <option value="">전체</option>
                                <option value="Y">활성</option>
                                <option value="N">비활성</option>
                            </select>
                            <%-- PARTNER_NM / PIC_NM / BIZRNO --%>
                            <div class="search-wrap">
                                <span class="material-symbols-rounded">search</span>
                                <input type="text" class="form-input" id="filterKeyword" placeholder="업체명, 담당자, 사업자번호">
                            </div>
                            <button type="button" class="btn btn-primary btn-sm"   data-action="searchGeneral">조회</button>
                            <button type="button" class="btn btn-secondary btn-sm" data-action="resetGeneral">초기화</button>
                            <span class="list-count" id="generalCount">0건</span>
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
                                    <th>이메일<small>PIC_EMAIL</small></th>
                                    <th class="col-center">활성여부<small>USE_YN</small></th>
                                    <th class="col-center">등록일<small>REG_DT</small></th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="generalTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     탭 2 : 유틸리티 공급기관
                     ERD  : PARTNER + UTILITY_PROVIDER (JOIN)
                     - 전기, 가스, 수도 등 검침 API 연동 업체
                     - METER_WRK_NO, API_KEY, CUST_NO 보유
                     - FACILITY_CONTRACT 와 연결 없음
                     - METER_HSTRY 와 연결됨
                ══════════════════════════════════════ -->
                <div class="tab-panel" id="tab-utility">
                    <div class="panel">
                        <div class="inpanel-filter">
                            <select class="form-select" id="filterUtilBizTy" style="width:110px;">
                                <option value="">업종 전체</option>
                                <option>전기</option>
                                <option>가스</option>
                                <option>급수</option>
                                <option>기타</option>
                            </select>
                            <select class="form-select" id="filterUtilUseYn" style="width:90px;">
                                <option value="">전체</option>
                                <option value="Y">활성</option>
                                <option value="N">비활성</option>
                            </select>
                            <div class="search-wrap">
                                <span class="material-symbols-rounded">search</span>
                                <input type="text" class="form-input" id="filterUtilKeyword" placeholder="업체명, 고객번호, 작업번호">
                            </div>
                            <button type="button" class="btn btn-primary btn-sm"   data-action="searchUtility">조회</button>
                            <button type="button" class="btn btn-secondary btn-sm" data-action="resetUtility">초기화</button>
                            <span class="list-count" id="utilityCount">0건</span>
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
                                    <th>검침작업번호<small>METER_WRK_NO</small></th>
                                    <th>고객번호<small>CUST_NO</small></th>
                                    <th class="col-center">API 연동<small>API_KEY</small></th>
                                    <th class="col-center">활성여부<small>USE_YN</small></th>
                                    <th class="col-manage">관리</th>
                                </tr>
                                </thead>
                                <tbody id="utilityTbody"></tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     모달 : 업체 등록 · 수정 · 상세
                     - 일반 협력업체 / 유틸리티 공급기관 구분 토글
                     - 유틸리티 선택 시 API 정보 섹션 추가 노출
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

                                <!-- 업체 구분 토글 -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">category</span>
                                        업체 구분
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <div style="display:flex;gap:8px;">
                                                <label style="display:flex;align-items:center;gap:6px;cursor:pointer;padding:8px 16px;border:1px solid var(--line);border-radius:4px;font-size:12px;" id="typeGenLabel">
                                                    <input type="radio" name="partnerType" value="GEN" id="typeGen" checked>
                                                    <span class="material-symbols-rounded" style="font-size:15px;">store</span>
                                                    일반 협력업체
                                                </label>
                                                <label style="display:flex;align-items:center;gap:6px;cursor:pointer;padding:8px 16px;border:1px solid var(--line);border-radius:4px;font-size:12px;" id="typeUtilLabel">
                                                    <input type="radio" name="partnerType" value="UTIL" id="typeUtil">
                                                    <span class="material-symbols-rounded" style="font-size:15px;">electric_bolt</span>
                                                    유틸리티 공급기관
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- PARTNER 기본 정보 -->
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
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">이메일
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">PIC_EMAIL</small>
                                            </label>
                                            <input type="email" class="form-input" id="picEmail" placeholder="example@company.com">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">활성 여부
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">USE_YN</small>
                                            </label>
                                            <select class="form-select" id="useYn">
                                                <option value="Y">Y · 활성</option>
                                                <option value="N">N · 비활성</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- UTILITY_PROVIDER 정보 (유틸리티 선택 시만 노출) -->
                                <div class="form-section" id="utilitySection" style="display:none;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">electric_bolt</span>
                                        유틸리티 공급기관 정보 · UTILITY_PROVIDER
                                    </div>
                                    <div class="util-section">
                                        <div class="util-label">
                                            <span class="material-symbols-rounded" style="font-size:13px;">info</span>
                                            검침 API 연동 정보 — 계약이 아닌 API 키 기반으로 검침 데이터를 수집합니다
                                        </div>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">검침작업번호
                                                    <small style="font-weight:400;color:#9caa9e;font-family:monospace;">METER_WRK_NO</small>
                                                </label>
                                                <input type="text" class="form-input" id="meterWrkNo" placeholder="자동 생성">
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">고객번호
                                                    <small style="font-weight:400;color:#9caa9e;font-family:monospace;">CUST_NO</small>
                                                </label>
                                                <input type="text" class="form-input" id="custNo" placeholder="공급기관 고객번호">
                                            </div>
                                        </div>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">API KEY
                                                    <small style="font-weight:400;color:#9caa9e;font-family:monospace;">API_KEY</small>
                                                </label>
                                                <input type="text" class="form-input" id="apiKey" placeholder="검침 API 인증 키" style="font-family:monospace;font-size:11px;">
                                            </div>
                                        </div>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">비고
                                                    <small style="font-weight:400;color:#9caa9e;font-family:monospace;">RMRK_CN</small>
                                                </label>
                                                <input type="text" class="form-input" id="rmrkCn" placeholder="검침 관련 메모">
                                            </div>
                                        </div>
                                    </div>
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
                                <div>
                                    선택한 업체를 삭제하시겠습니까?<br>
                                    <span id="deleteWarnDetail"></span>
                                </div>
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

                    /* ── 더미 데이터 ──────────────────────────────────────────
                       백엔드 연결 시 AJAX 대체
                       일반 협력업체: UTILITY_PROVIDER 연결 없음
                       유틸리티:     UTILITY_PROVIDER JOIN → meterWrkNo 보유
                    ────────────────────────────────────────────────────────── */
                    var generalData = [
                        { partnerNo:'PT-001', partnerNm:'승강기관리(주)',   bizTyNm:'승강기', bizrno:'123-45-67890', picNm:'김철수', picTelno:'010-1234-5678', picEmail:'kim@elv.co.kr',   useYn:'Y', regDt:'2025-01-10' },
                        { partnerNo:'PT-002', partnerNm:'한국소방안전',     bizTyNm:'소방',   bizrno:'234-56-78901', picNm:'이영희', picTelno:'010-2345-6789', picEmail:'lee@fire.co.kr',  useYn:'Y', regDt:'2025-02-05' },
                        { partnerNo:'PT-003', partnerNm:'청정환경서비스',   bizTyNm:'청소',   bizrno:'345-67-89012', picNm:'박민준', picTelno:'010-3456-7890', picEmail:'park@clean.co.kr', useYn:'Y', regDt:'2025-03-15' },
                        { partnerNo:'PT-004', partnerNm:'대한전기(주)',     bizTyNm:'전기',   bizrno:'456-78-90123', picNm:'최지원', picTelno:'010-4567-8901', picEmail:'choi@elec.co.kr', useYn:'Y', regDt:'2025-03-20' },
                        { partnerNo:'PT-005', partnerNm:'보안솔루션',       bizTyNm:'보안',   bizrno:'567-89-01234', picNm:'정수진', picTelno:'010-5678-9012', picEmail:'jung@sec.co.kr',  useYn:'Y', regDt:'2025-04-01' },
                        { partnerNo:'PT-008', partnerNm:'e편한안전',        bizTyNm:'소방',   bizrno:'901-23-45678', picNm:'서지훈', picTelno:'010-9012-3456', picEmail:'seo@safe.co.kr',  useYn:'N', regDt:'2024-12-01' },
                        { partnerNo:'PT-009', partnerNm:'KD승강기서비스',  bizTyNm:'승강기', bizrno:'222-33-44444', picNm:'장민서', picTelno:'010-2222-3333', picEmail:'jang@kd.co.kr',   useYn:'Y', regDt:'2025-05-10' },
                    ];

                    /* 유틸리티: PARTNER + UTILITY_PROVIDER JOIN 결과 */
                    var utilityData = [
                        { partnerNo:'PT-006', partnerNm:'가스안전(주)',   bizTyNm:'가스', bizrno:'678-90-12345', picNm:'강동원', picTelno:'010-6789-0123', picEmail:'kang@gas.co.kr',   useYn:'Y', regDt:'2025-01-15',
                            meterWrkNo:'MWK-001', custNo:'GAS-10001', apiKey:'gk_live_abcd1234efgh5678', rmrkCn:'한국가스공사 API 연동' },
                        { partnerNo:'PT-007', partnerNm:'푸른급수관리',   bizTyNm:'급수', bizrno:'789-01-23456', picNm:'윤소희', picTelno:'010-7890-1234', picEmail:'yoon@water.co.kr', useYn:'Y', regDt:'2025-01-20',
                            meterWrkNo:'MWK-002', custNo:'WTR-20002', apiKey:'wk_live_ijkl9012mnop3456', rmrkCn:'수도사업소 검침 API' },
                        { partnerNo:'PT-010', partnerNm:'한전서비스',     bizTyNm:'전기', bizrno:'111-22-33333', picNm:'오민석', picTelno:'010-1111-2222', picEmail:'oh@kepco.co.kr',   useYn:'Y', regDt:'2025-02-01',
                            meterWrkNo:'MWK-003', custNo:'ELC-30003', apiKey:'ek_live_qrst7890uvwx1234', rmrkCn:'한국전력 AMI 연동' },
                    ];

                    var currentTab   = 'general';
                    var currentIdx   = null;
                    var deleteTargetIdx = null;

                    /* ── 헬퍼 ── */
                    function b(cls, t) { return '<span class="badge ' + cls + '">' + t + '</span>'; }
                    function useYnB(v) { return v === 'Y' ? b('badge-green','활성') : b('badge-red','비활성'); }
                    function di(l, v)  { return '<div class="mngr-detail-item"><div class="mngr-detail-label">' + l + '</div><div class="mngr-detail-value">' + v + '</div></div>'; }
                    function maskApi(k){ if (!k) return '—'; return k.substring(0, 8) + '••••••••••••'; }

                    /* ── 요약 통계 ── */
                    function updateStats() {
                        var all = generalData.length + utilityData.length;
                        document.getElementById('statTotal').textContent    = all;
                        document.getElementById('statGeneral').textContent  = generalData.length;
                        document.getElementById('statUtility').textContent  = utilityData.length;
                        var inactive = generalData.filter(function(r){ return r.useYn==='N'; }).length
                            + utilityData.filter(function(r){ return r.useYn==='N'; }).length;
                        document.getElementById('statInactive').textContent = inactive;
                    }

                    /* ── 탭 전환 ── */
                    page.querySelectorAll('.tab-btn').forEach(function(btn){
                        btn.addEventListener('click', function(){
                            page.querySelectorAll('.tab-panel').forEach(function(p){ p.classList.remove('active'); });
                            page.querySelectorAll('.tab-btn').forEach(function(b){ b.classList.remove('active'); });
                            btn.classList.add('active');
                            document.getElementById(btn.dataset.tab).classList.add('active');
                            currentTab = btn.dataset.tab === 'tab-general' ? 'general' : 'utility';
                        });
                    });

                    /* ── 렌더: 일반 협력업체 ── */
                    function renderGeneral(data) {
                        document.getElementById('generalCount').textContent = data.length + '건';
                        var tb = document.getElementById('generalTbody');
                        if (!data.length) { tb.innerHTML = '<tr><td colspan="9" class="empty-row">조건에 맞는 업체가 없습니다.</td></tr>'; return; }
                        tb.innerHTML = data.map(function(p, i) {
                            return '<tr>'
                                + '<td class="td-mono">' + p.partnerNo + '</td>'
                                + '<td class="td-bold">' + p.partnerNm + '</td>'
                                + '<td>' + b('badge-gray', p.bizTyNm) + '</td>'
                                + '<td class="td-mono">' + p.bizrno + '</td>'
                                + '<td>' + p.picNm + '<br><span style="font-size:11px;color:#9caa9e;">' + p.picTelno + '</span></td>'
                                + '<td style="font-size:11px;color:#6b7a6e;">' + (p.picEmail || '—') + '</td>'
                                + '<td class="col-center">' + useYnB(p.useYn) + '</td>'
                                + '<td class="col-center td-mono">' + p.regDt + '</td>'
                                + '<td class="col-manage"><div class="grid-actions">'
                                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-tab="general" data-idx="' + i + '">상세</button>'
                                + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-tab="general" data-idx="' + i + '">수정</button>'
                                + '<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-tab="general" data-idx="' + i + '">삭제</button>'
                                + '</div></td></tr>';
                        }).join('');
                    }

                    /* ── 렌더: 유틸리티 공급기관 ── */
                    function renderUtility(data) {
                        document.getElementById('utilityCount').textContent = data.length + '건';
                        var tb = document.getElementById('utilityTbody');
                        if (!data.length) { tb.innerHTML = '<tr><td colspan="10" class="empty-row">조건에 맞는 공급기관이 없습니다.</td></tr>'; return; }
                        tb.innerHTML = data.map(function(p, i) {
                            return '<tr>'
                                + '<td class="td-mono">' + p.partnerNo + '</td>'
                                + '<td class="td-bold">' + p.partnerNm + '</td>'
                                + '<td>' + b('badge-teal', p.bizTyNm) + '</td>'
                                + '<td class="td-mono">' + p.bizrno + '</td>'
                                + '<td>' + p.picNm + '<br><span style="font-size:11px;color:#9caa9e;">' + p.picTelno + '</span></td>'
                                + '<td class="td-mono">' + (p.meterWrkNo || '—') + '</td>'
                                + '<td class="td-mono">' + (p.custNo || '—') + '</td>'
                                + '<td class="col-center">' + (p.apiKey ? b('badge-blue','연동') : b('badge-gray','미연동')) + '</td>'
                                + '<td class="col-center">' + useYnB(p.useYn) + '</td>'
                                + '<td class="col-manage"><div class="grid-actions">'
                                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-tab="utility" data-idx="' + i + '">상세</button>'
                                + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-tab="utility" data-idx="' + i + '">수정</button>'
                                + '<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-tab="utility" data-idx="' + i + '">삭제</button>'
                                + '</div></td></tr>';
                        }).join('');
                    }

                    /* ── 필터 ── */
                    function filteredGeneral() {
                        var biz = document.getElementById('filterBizTy').value;
                        var use = document.getElementById('filterUseYn').value;
                        var kw  = document.getElementById('filterKeyword').value.trim();
                        return generalData.filter(function(p){
                            return (!biz || p.bizTyNm === biz)
                                && (!use || p.useYn === use)
                                && (!kw  || p.partnerNm.indexOf(kw) > -1 || p.picNm.indexOf(kw) > -1 || p.bizrno.indexOf(kw) > -1);
                        });
                    }
                    function filteredUtility() {
                        var biz = document.getElementById('filterUtilBizTy').value;
                        var use = document.getElementById('filterUtilUseYn').value;
                        var kw  = document.getElementById('filterUtilKeyword').value.trim();
                        return utilityData.filter(function(p){
                            return (!biz || p.bizTyNm === biz)
                                && (!use || p.useYn === use)
                                && (!kw  || p.partnerNm.indexOf(kw) > -1 || (p.custNo && p.custNo.indexOf(kw) > -1) || (p.meterWrkNo && p.meterWrkNo.indexOf(kw) > -1));
                        });
                    }

                    /* ── 모달 ── */
                    var form      = document.getElementById('partnerForm');
                    var saveBtn   = document.getElementById('partnerSaveBtn');
                    var editBtn   = document.getElementById('partnerEditBtn');
                    var delBtn    = document.getElementById('partnerDeleteBtn');
                    var utilSec   = document.getElementById('utilitySection');

                    function openM(id)  { document.getElementById(id).classList.add('open'); }
                    function closeM(id) { document.getElementById(id).classList.remove('open'); }
                    function setDis(v)  { form.querySelectorAll('input,select,textarea').forEach(function(el){ el.disabled = v; }); }

                    /* 업체구분 라디오 → 유틸리티 섹션 토글 */
                    function bindTypeRadio() {
                        form.querySelectorAll('input[name="partnerType"]').forEach(function(r){
                            r.addEventListener('change', function(){
                                utilSec.style.display = (r.value === 'UTIL' && r.checked) ? '' : 'none';
                            });
                        });
                    }
                    bindTypeRadio();

                    function openModal(mode, tab, idx) {
                        form.reset();
                        utilSec.style.display = 'none';
                        currentIdx = idx !== undefined ? idx : null;
                        currentTab = tab || currentTab;

                        saveBtn.style.display = 'inline-flex';
                        editBtn.style.display = 'none';
                        delBtn.style.display  = 'none';
                        setDis(false);

                        if (mode === 'register') {
                            document.getElementById('partnerModalTitle').textContent = '협력업체 등록';
                            /* 현재 탭에 맞게 라디오 기본값 */
                            document.getElementById(currentTab === 'utility' ? 'typeUtil' : 'typeGen').checked = true;
                            if (currentTab === 'utility') utilSec.style.display = '';
                        }

                        if ((mode === 'detail' || mode === 'edit') && currentIdx !== null) {
                            var data = currentTab === 'utility' ? utilityData : generalData;
                            var p    = data[currentIdx];
                            document.getElementById('partnerModalTitle').textContent = mode === 'detail' ? '협력업체 상세' : '협력업체 수정';

                            /* 라디오 */
                            document.getElementById(currentTab === 'utility' ? 'typeUtil' : 'typeGen').checked = true;
                            if (currentTab === 'utility') utilSec.style.display = '';

                            /* 필드 채우기 */
                            var fields = { partnerNo: p.partnerNo, partnerNm: p.partnerNm, bizTyNm: p.bizTyNm,
                                bizrno: p.bizrno, picNm: p.picNm, picTelno: p.picTelno,
                                picEmail: p.picEmail, useYn: p.useYn };
                            if (currentTab === 'utility') {
                                fields.meterWrkNo = p.meterWrkNo;
                                fields.custNo     = p.custNo;
                                fields.apiKey     = p.apiKey;
                                fields.rmrkCn     = p.rmrkCn;
                            }
                            Object.keys(fields).forEach(function(k){ var el = document.getElementById(k); if (el) el.value = fields[k] || ''; });

                            if (mode === 'detail') {
                                setDis(true);
                                saveBtn.style.display = 'none';
                                editBtn.style.display = 'inline-flex';
                                delBtn.style.display  = 'inline-flex';
                                editBtn.dataset.tab = currentTab;
                                editBtn.dataset.idx = currentIdx;
                            } else {
                                delBtn.style.display = 'inline-flex';
                            }
                        }
                        openM('partnerModal');
                    }

                    /* ── 이벤트 위임 ── */
                    page.addEventListener('click', function(e){
                        var btn = e.target.closest('[data-action]');
                        if (!btn) return;
                        var action = btn.dataset.action;
                        var tab    = btn.dataset.tab;
                        var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

                        if (action === 'openRegister')      openModal('register', currentTab);
                        if (action === 'detail')            openModal('detail', tab, idx);
                        if (action === 'edit')              openModal('edit',   tab, idx);
                        if (action === 'changeToEdit')      openModal('edit', editBtn.dataset.tab, Number(editBtn.dataset.idx));
                        if (action === 'closePartnerModal') { closeM('partnerModal'); setDis(false); }

                        if (action === 'delete') {
                            deleteTargetIdx = idx;
                            currentTab = tab;
                            var data = tab === 'utility' ? utilityData : generalData;
                            var p    = data[idx];
                            var warn = tab === 'utility'
                                ? '연결된 검침기록(METER_HSTRY)도 함께 삭제됩니다.'
                                : '연결된 계약(FACILITY_CONTRACT) 및 점검이력(FACILITY_CHECK_HSTRY)도 함께 삭제됩니다.';
                            document.getElementById('deleteWarnDetail').textContent = warn;
                            document.getElementById('deleteTargetInfo').innerHTML =
                                di('PARTNER_NO', p.partnerNo) + di('PARTNER_NM', p.partnerNm) + di('BIZ_TY_NM', p.bizTyNm);
                            openM('partnerDeleteModal');
                        }
                        if (action === 'openDeleteConfirm') {
                            if (currentIdx === null) return;
                            deleteTargetIdx = currentIdx;
                            var data = currentTab === 'utility' ? utilityData : generalData;
                            var p    = data[currentIdx];
                            var warn = currentTab === 'utility'
                                ? '연결된 검침기록(METER_HSTRY)도 함께 삭제됩니다.'
                                : '연결된 계약(FACILITY_CONTRACT) 및 점검이력(FACILITY_CHECK_HSTRY)도 함께 삭제됩니다.';
                            document.getElementById('deleteWarnDetail').textContent = warn;
                            document.getElementById('deleteTargetInfo').innerHTML =
                                di('PARTNER_NO', p.partnerNo) + di('PARTNER_NM', p.partnerNm) + di('BIZ_TY_NM', p.bizTyNm);
                            openM('partnerDeleteModal');
                        }
                        if (action === 'closeDeleteModal') closeM('partnerDeleteModal');

                        if (action === 'searchGeneral')  renderGeneral(filteredGeneral());
                        if (action === 'searchUtility')  renderUtility(filteredUtility());
                        if (action === 'resetGeneral')   { ['filterBizTy','filterUseYn','filterKeyword'].forEach(function(id){ document.getElementById(id).value = ''; }); renderGeneral(generalData); }
                        if (action === 'resetUtility')   { ['filterUtilBizTy','filterUtilUseYn','filterUtilKeyword'].forEach(function(id){ document.getElementById(id).value = ''; }); renderUtility(utilityData); }
                    });

                    /* 삭제 확인 */
                    document.getElementById('deleteConfirmBtn').addEventListener('click', function(){
                        if (deleteTargetIdx === null) return;
                        if (currentTab === 'utility') {
                            utilityData.splice(deleteTargetIdx, 1);
                            renderUtility(utilityData);
                        } else {
                            generalData.splice(deleteTargetIdx, 1);
                            renderGeneral(generalData);
                        }
                        updateStats();
                        closeM('partnerDeleteModal');
                        closeM('partnerModal');
                        deleteTargetIdx = null;
                    });

                    /* 저장 */
                    form.addEventListener('submit', function(e){
                        e.preventDefault();
                        if (!document.getElementById('partnerNm').value.trim()) { alert('업체명을 입력하세요.'); return; }
                        var isUtil = document.getElementById('typeUtil').checked;
                        if (isUtil && !document.getElementById('custNo').value.trim()) { alert('고객번호를 입력하세요.'); return; }
                        /* TODO: AJAX POST /manager/partner/save */
                        alert('저장 — PARTNER ' + (isUtil ? '+ UTILITY_PROVIDER ' : '') + 'insert/update');
                        closeM('partnerModal');
                        setDis(false);
                    });

                    /* 오버레이 클릭 닫기 */
                    document.getElementById('partnerModal').addEventListener('click', function(e){ if (e.target === this) { closeM('partnerModal'); setDis(false); } });
                    document.getElementById('partnerDeleteModal').addEventListener('click', function(e){ if (e.target === this) closeM('partnerDeleteModal'); });

                    /* ── 초기 렌더 ── */
                    updateStats();
                    renderGeneral(generalData);
                    renderUtility(utilityData);

                })();
            </script>

        </main>
    </div>
</div>
</body>
</html>
