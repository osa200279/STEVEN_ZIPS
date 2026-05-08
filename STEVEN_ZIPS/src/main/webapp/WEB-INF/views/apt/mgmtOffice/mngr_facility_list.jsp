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
        #facilityPage { --accent:#2e5c38; --accent-light:#e8f0ea; --accent-dim:rgba(38,92,48,.08); --surface:#fff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f0f2ef; --text-head:#1a2e1e; }
        #facilityPage .page-title-block h2 { color:var(--text-head); font-size:19px; letter-spacing:-.5px; }
        #facilityPage .page-title-block p { color:#6b7a6e; font-size:12px; }
        #facilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #facilityPage .panel + .panel { margin-top:14px; }

        /* 시설자산 마스터 화면의 현황카드는 FACILITY 기본 분류 기준만 표시한다. */
        #facilityPage .asset-summary-row { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:10px; margin-bottom:14px; }
        #facilityPage .asset-summary-card { display:flex; align-items:center; gap:12px; min-height:74px; padding:14px 16px; border:1px solid var(--line); border-radius:6px; background:var(--surface); box-shadow:none; }
        #facilityPage .asset-summary-card .summary-icon { display:inline-flex; align-items:center; justify-content:center; width:36px; height:36px; border-radius:6px; background:var(--accent-light); color:var(--accent); flex-shrink:0; }
        #facilityPage .asset-summary-card .summary-icon .material-symbols-rounded { font-size:20px; }
        #facilityPage .asset-summary-card .summary-label { font-size:11px; font-weight:700; color:#6b7a6e; margin-bottom:2px; }
        #facilityPage .asset-summary-card .summary-value { font-size:22px; font-weight:800; color:var(--text-head); line-height:1; }
        #facilityPage .asset-summary-card.primary { background:var(--accent); border-color:#1f4027; }
        #facilityPage .asset-summary-card.primary .summary-icon { background:rgba(255,255,255,.14); color:#fff; }
        #facilityPage .asset-summary-card.primary .summary-label { color:rgba(255,255,255,.72); }
        #facilityPage .asset-summary-card.primary .summary-value { color:#fff; }

        #facilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #facilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-head); }
        #facilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #facilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #facilityPage .panel-body .form-row { margin-bottom:10px; }
        #facilityPage .panel-body .form-row:last-child { margin-bottom:0; }
        #facilityPage .panel-body .form-input, #facilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #facilityPage .panel-body .form-input:focus, #facilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #facilityPage .panel-body .btn { min-height:32px; font-size:12px; padding:0 13px; border-radius:4px; }
        #facilityPage .panel-body .page-actions { justify-content:flex-end; }
        #facilityPage .panel-body .search-wrap { position:relative; }
        #facilityPage .panel-body .search-wrap .material-symbols-rounded { position:absolute; left:9px; top:50%; transform:translateY(-50%); font-size:15px; color:#9caa9e; pointer-events:none; }
        #facilityPage .panel-body .search-wrap input { padding-left:30px; width:100%; }
        #facilityPage .list-count { font-size:12px; font-weight:800; color:var(--accent); background:var(--accent-light); border-radius:4px; padding:3px 9px; white-space:nowrap; }
        #facilityPage .result-desc { font-size:11px; color:#7a8a7d; margin-left:8px; font-weight:500; }

        #facilityPage .table-wrap { padding:0; overflow-x:auto; }
        #facilityPage .tbl { font-size:12px; }
        #facilityPage thead th { padding:9px 14px; background:var(--th-bg); border-bottom:1px solid var(--line); color:#4a5c4e; font-size:11px; font-weight:700; white-space:nowrap; }
        #facilityPage thead th small { display:block; font-weight:400; color:#9caa9e; font-size:10px; margin-top:1px; font-family:'SF Mono','Consolas',monospace; }
        #facilityPage tbody td { padding:10px 14px; border-bottom:1px solid var(--line); color:#374151; vertical-align:middle; }
        #facilityPage tbody tr:last-child td { border-bottom:none; }
        #facilityPage tbody tr:hover td { background:#f4f7f4; }
        #facilityPage .td-bold { font-weight:600; color:#111827; }
        #facilityPage .td-mono { font-family:'SF Mono','Consolas',monospace; font-size:11px; color:#6b7a6e; }
        #facilityPage .col-center { text-align:center !important; }
        #facilityPage .col-manage { text-align:center !important; width:100px; }
        #facilityPage .grid-actions { display:inline-flex; gap:5px; }
        #facilityPage .empty-row { text-align:center !important; color:#9caa9e; padding:40px !important; font-size:13px; }

        #facilityPage .badge { padding:2px 7px; border-radius:3px; font-size:11px; font-weight:700; }
        #facilityPage .badge-green { background:#dceee0; color:#1a3d1f; }
        #facilityPage .badge-yellow { background:#fef3c7; color:#713f12; }
        #facilityPage .badge-red { background:#fee2e2; color:#7f1d1d; }
        #facilityPage .badge-gray { background:#e9ece9; color:#374151; }
        #facilityPage .badge-blue { background:#dbeafe; color:#1e3a5f; }
        #facilityPage .badge-orange { background:#ffedd5; color:#7c2d12; }
        #facilityPage .badge-purple { background:#ede9fe; color:#4c1d95; }
        #facilityPage .badge-teal { background:#ccfbf1; color:#134e4a; }
        #facilityPage .btn { border-radius:4px; }
        #facilityPage .btn-primary { background:var(--accent); }
        #facilityPage .btn-primary:hover { background:#1a3d1f; }

        .modal { border-radius:6px !important; }
        .modal-header.primary { background:#1a2e1e; }
        .modal-header.primary .modal-title { color:#fff; }
        .modal-header.primary .modal-close { color:rgba(255,255,255,.6); border-color:rgba(255,255,255,.15); background:rgba(255,255,255,.08); }
        .modal-header.primary .modal-close:hover { background:rgba(255,255,255,.15); color:#fff; }
        .form-section-title { letter-spacing:0; text-transform:none; font-size:11px; font-weight:800; color:#4a5c4e; }

        #facilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:#4a5c4e; line-height:1.6; }
        #facilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #facilityPage .notice-box strong { color:#1a2e1e; }
        #facilityPage .notice-box ul { margin:4px 0 0; padding-left:16px; }
        #facilityPage .field-help { margin-top:5px; font-size:11px; color:#9caa9e; line-height:1.5; }
        #facilityPage .field-help.warn { color:#7c2d12; }
        #facilityPage .field-help.lock { display:none; color:#7c2d12; }
        #facilityPage .is-edit-mode .field-help.lock { display:block; }
        #facilityPage .is-edit-mode .register-guide { display:none; }
        #facilityPage .edit-guide { display:none; }
        #facilityPage .is-edit-mode .edit-guide { display:flex; }

        #facilityPage .detail-summary { border:1px solid var(--line); border-radius:4px; overflow:hidden; margin-top:4px; }
        #facilityPage .detail-summary .ds-header { display:flex; align-items:center; justify-content:space-between; padding:8px 12px; background:var(--th-bg); border-bottom:1px solid var(--line); font-size:11px; font-weight:800; color:#4a5c4e; }
        #facilityPage .detail-summary .ds-header a { font-size:11px; font-weight:600; color:var(--accent); text-decoration:none; }
        #facilityPage .detail-summary .ds-header a:hover { text-decoration:underline; }
        #facilityPage .detail-summary .ds-row { display:flex; align-items:center; gap:10px; padding:8px 12px; border-bottom:1px solid var(--line); font-size:12px; }
        #facilityPage .detail-summary .ds-row:last-child { border-bottom:none; }
        #facilityPage .detail-summary .ds-row:hover { background:#f4f7f4; }
        #facilityPage .detail-summary .ds-no { font-family:monospace; font-size:11px; color:#9caa9e; min-width:70px; }
        #facilityPage .detail-summary .ds-nm { flex:1; font-weight:600; color:#111827; }
        #facilityPage .detail-summary .ds-dt { font-size:11px; color:#9caa9e; font-family:monospace; }
        #facilityPage .detail-summary .ds-empty { padding:14px 12px; font-size:12px; color:#9caa9e; }
    </style>

    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="facilityPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>시설자산 관리</h2>
                        <p>단지 내 시설자산 마스터 정보를 등록·조회·관리합니다</p>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-primary" data-action="openRegister">
                            <span class="material-symbols-rounded">add</span>시설 등록
                        </button>
                    </div>
                </div>

                <!-- ══ 자산 현황 카드 ══
                     시설자산 등록/관리 화면이므로 FACILITY 마스터 기준으로만 표시한다.
                     점검 이상, 이용중단, 검침 이상 같은 운영 판단은 전용 화면에서 처리한다.
                ══════════════════════════════════════ -->
                <div class="asset-summary-row">
                    <div class="asset-summary-card primary">
                        <div class="summary-icon"><span class="material-symbols-rounded">apartment</span></div>
                        <div>
                            <div class="summary-label">전체 시설</div>
                            <div class="summary-value" id="statTotal">0</div>
                        </div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">domain</span></div>
                        <div>
                            <div class="summary-label">동 지정 시설</div>
                            <div class="summary-value" id="statDong">0</div>
                        </div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">location_city</span></div>
                        <div>
                            <div class="summary-label">공용 위치 시설</div>
                            <div class="summary-value" id="statCommonLoc">0</div>
                        </div>
                    </div>
                    <div class="asset-summary-card">
                        <div class="summary-icon"><span class="material-symbols-rounded">electric_meter</span></div>
                        <div>
                            <div class="summary-label">검침 연결 시설</div>
                            <div class="summary-value" id="statMeterLinked">0</div>
                        </div>
                    </div>
                </div>

                <!-- ══ 검색 조건 패널 ══ -->
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">manage_search</span>검색 조건</h3>
                    </div>
                    <div class="panel-body">
                        <div class="form-row cols-3">
                            <%-- FACILITY_TY_CD (공통코드 FACILITY_TY) --%>
                            <div class="form-field">
                                <label class="field-label">시설유형</label>
                                <select class="form-select" id="filterFacTy">
                                    <option value="">전체</option>
                                    <option value="ELV">승강기</option>
                                    <option value="WTR">급수시설</option>
                                    <option value="ELC">전기시설</option>
                                    <option value="GAS">가스시설</option>
                                    <option value="FIRE">소방시설</option>
                                    <option value="SEC">보안시설</option>
                                    <option value="ETC">기타시설</option>
                                </select>
                            </div>

                            <%-- DONG_NO (APT_UNIT.DONG_NO 기준) --%>
                            <div class="form-field">
                                <label class="field-label">동</label>
                                <select class="form-select" id="filterDong">
                                    <option value="">전체</option>
                                    <option value="101">101동</option>
                                    <option value="102">102동</option>
                                    <option value="103">103동</option>
                                    <option value="공용">공용</option>
                                </select>
                            </div>

                            <%-- 검침시설은 고정 분류값이 아니라 METER_WORK 연결 여부로 판단한다. --%>
                            <div class="form-field">
                                <label class="field-label">검침 연결</label>
                                <select class="form-select" id="filterMeterLink">
                                    <option value="">전체</option>
                                    <option value="Y">연결 있음</option>
                                    <option value="N">연결 없음</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row cols-3">
                            <div class="form-field">
                                <label class="field-label">시설명/위치</label>
                                <div class="search-wrap">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="filterKeyword" placeholder="시설명 또는 상세위치 검색">
                                </div>
                            </div>
                            <div class="form-field"></div>
                            <div class="form-field">
                                <label class="field-label">&nbsp;</label>
                                <div class="page-actions">
                                    <button type="button" class="btn btn-secondary btn-sm" data-action="resetFacility">
                                        <span class="material-symbols-rounded">refresh</span>초기화
                                    </button>
                                    <button type="button" class="btn btn-primary btn-sm" data-action="searchFacility">
                                        <span class="material-symbols-rounded">search</span>검색
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ══ 시설자산 목록 패널 ══ -->
                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title">
                            <span class="material-symbols-rounded">apartment</span>
                            시설자산 목록
                            <span class="result-desc" id="resultDesc">전체 조건</span>
                        </h3>
                        <span class="list-count" id="facilityCount">0건</span>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl">
                            <thead>
                            <tr>
                                <th>시설번호<small>FACILITY_NO</small></th>
                                <th>시설명<small>FACILITY_NM</small></th>
                                <th class="col-center">시설유형<small>FACILITY_TY_CD</small></th>
                                <th class="col-center">검침 연결<small>METER_WORK</small></th>
                                <th class="col-center">동<small>DONG_NO</small></th>
                                <th>상세위치<small>LOC_CN</small></th>
                                <th class="col-center">설치일자<small>INSTL_DT</small></th>
                                <th class="col-center">예정 점검<small>일정 건수</small></th>
                                <th class="col-manage">관리</th>
                            </tr>
                            </thead>
                            <tbody id="facilityTbody"></tbody>
                        </table>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     모달 : 시설 등록 · 수정
                     ERD  : FACILITY
                     - FACILITY_TY_CD : 시설 자체의 종류
                     - 검침 대상 여부  : METER_WORK 연결 여부로 판단
                     - APT_CMPLEX_NO  : mgmtOfcNo로 MGMT_OFFICE 조회 후 서버에서 세팅
                     - 비활성/이용상태 : 현재 FACILITY 컬럼에 없으므로 이 화면에서 처리하지 않음
                ══════════════════════════════════════ -->
                <div class="modal-overlay" id="facilityModal">
                    <div class="modal modal-lg">
                        <div class="modal-header primary">
                            <h3 class="modal-title" id="facilityModalTitle">시설 등록</h3>
                            <button type="button" class="modal-close" data-action="closeFacilityModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <form id="facilityForm">
                            <div class="modal-body">

                                <!-- 등록 모드 안내 : 안내문은 상단 하나로 모아 산만하지 않게 유지한다. -->
                                <div class="form-section register-guide">
                                    <div class="notice-box">
                                        <span class="material-symbols-rounded">info</span>
                                        <div>
                                            <strong>시설 등록 전 확인사항</strong>
                                            <ul>
                                                <li>시설유형은 시설 자체의 종류이며 계약·점검·검침 연결 시 기준 정보로 사용됩니다.</li>
                                                <li>검침 대상 여부는 시설유형이 아니라 METER_WORK 연결 여부로 판단합니다.</li>
                                                <li>등록 후 일반 수정에서는 시설유형을 변경하지 않습니다. 오등록 건은 연결 데이터가 없을 때만 정정합니다.</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>

                                <!-- 수정 모드 안내 : 마스터 보정과 분류값 정정을 분리한다. -->
                                <div class="form-section edit-guide">
                                    <div class="notice-box">
                                        <span class="material-symbols-rounded">lock</span>
                                        <div>
                                            <strong>수정 가능 범위</strong><br>
                                            일반 수정은 시설명, 동, 상세위치, 설치일자만 수정합니다.<br>
                                            시설유형 오등록은 계약·점검·검침 연결 데이터가 없을 때만 별도 정정할 수 있습니다.
                                        </div>
                                    </div>
                                </div>

                                <!-- 시설 기본정보 -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">apartment</span>
                                        시설 기본정보 · FACILITY
                                    </div>
                                    <input type="hidden" id="facilityNo">

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">시설명 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">FACILITY_NM</small>
                                            </label>
                                            <input type="text" class="form-input" id="facilityNm" placeholder="예) 1호기 승강기" required>
                                        </div>

                                        <div class="form-field">
                                            <%--
                                                FACILITY_TY_CD
                                                - 시설 자체의 종류만 의미한다.
                                                - 검침 대상 여부는 METER_WORK 연결 여부로 판단한다.
                                                - 수정 모드에서는 기본 잠금 처리하고, 오등록 예외 정정은 별도 검증 후 처리한다.
                                            --%>
                                            <label class="field-label">시설유형 <span class="req">*</span>
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">FACILITY_TY_CD</small>
                                            </label>
                                            <select class="form-select" id="facilityTyCd" required>
                                                <option value="">선택</option>
                                                <option value="ELV">ELV · 승강기</option>
                                                <option value="WTR">WTR · 급수시설</option>
                                                <option value="ELC">ELC · 전기시설</option>
                                                <option value="GAS">GAS · 가스시설</option>
                                                <option value="FIRE">FIRE · 소방시설</option>
                                                <option value="SEC">SEC · 보안시설</option>
                                                <option value="ETC">ETC · 기타시설</option>
                                            </select>
                                            <div class="field-help">시설유형은 시설 분류 및 후속 관리 기준입니다.</div>
                                            <div class="field-help lock">시설유형은 일반 수정에서 변경하지 않습니다. 오등록 건은 분류값 정정으로 처리합니다.</div>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">설치일자
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">INSTL_DT</small>
                                            </label>
                                            <input type="date" class="form-input" id="instlDt" style="width:180px;">
                                        </div>
                                    </div>
                                </div>

                                <!-- 시설 위치정보 -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">location_on</span>
                                        시설 위치정보
                                    </div>

                                    <div class="form-row cols-2">
                                        <%--
                                            DONG_NO
                                            - APT_UNIT.DONG_NO 기준 목록 사용
                                            - nullable 허용
                                            - 서버에서 APT_CMPLEX_NO + DONG_NO 조합 검증
                                        --%>
                                        <div class="form-field">
                                            <label class="field-label">동
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">DONG_NO</small>
                                                <small style="font-weight:400;color:#9caa9e;font-size:10px;"> (없으면 공용 위치)</small>
                                            </label>
                                            <select class="form-select" id="dongNo">
                                                <option value="">선택 (없음)</option>
                                                <option value="101">101동</option>
                                                <option value="102">102동</option>
                                                <option value="103">103동</option>
                                                <option value="공용">공용</option>
                                            </select>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">상세위치
                                                <small style="font-weight:400;color:#9caa9e;font-family:monospace;">LOC_CN</small>
                                            </label>
                                            <input type="text" class="form-input" id="locCn" placeholder="예) 지하주차장 B2 A구역">
                                        </div>
                                    </div>
                                </div>

                                <!-- 검침 연결 안내 -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">electric_meter</span>
                                        검침 연결 안내
                                    </div>
                                    <div class="notice-box">
                                        <span class="material-symbols-rounded">link</span>
                                        <div>
                                            검침 대상 여부는 시설 등록값이 아니라 <strong>METER_WORK 연결 여부</strong>로 판단합니다.<br>
                                            검침 연결 등록·해제는 검침 관리 화면 또는 시설 상세의 연결 기능에서 처리합니다.
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-action="closeFacilityModal">취소</button>
                                <button type="button" class="btn btn-secondary" id="facilityCorrectionBtn" data-action="openCorrection" style="display:none;margin-right:auto;">
                                    <span class="material-symbols-rounded">edit_note</span>분류값 정정
                                </button>
                                <button type="submit" class="btn btn-primary" id="facilitySaveBtn">저장</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- ══════════════════════════════════════
                     모달 : 시설 상세
                     - 기본정보 조회
                     - 최근 계약 요약
                     - 최근 점검이력 요약
                     - 검침 연결 정보
                     - 예정 점검 건수
                ══════════════════════════════════════ -->
                <div class="modal-overlay" id="facilityDetailModal">
                    <div class="modal modal-lg">
                        <div class="modal-header primary">
                            <h3 class="modal-title" id="detailModalTitle">시설 상세</h3>
                            <button type="button" class="modal-close" data-action="closeDetailModal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="form-section">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">apartment</span>
                                    시설 기본정보 · FACILITY
                                </div>
                                <div class="mngr-detail-grid" id="detailBasicGrid"></div>
                            </div>

                            <div class="form-section" id="detailContSection">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">description</span>
                                    최근 계약 · FACILITY_CONTRACT
                                </div>
                                <div class="detail-summary">
                                    <div class="ds-header">
                                        <span>최신 계약 1건</span>
                                        <a href="${pageContext.request.contextPath}/manager/facility/contractList" id="contMoreLink">전체보기 →</a>
                                    </div>
                                    <div class="ds-body" id="detailContBody"></div>
                                </div>
                            </div>

                            <div class="form-section" id="detailChkSection">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">fact_check</span>
                                    최근 점검이력 · FACILITY_CHECK_HISTORY
                                </div>
                                <div class="detail-summary">
                                    <div class="ds-header">
                                        <span>최근 3건</span>
                                        <a href="${pageContext.request.contextPath}/manager/checkHistory" id="chkMoreLink">전체보기 →</a>
                                    </div>
                                    <div class="ds-body" id="detailChkBody"></div>
                                </div>
                            </div>

                            <div class="form-section" id="detailMeterSection">
                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">electric_meter</span>
                                    검침 연결 · METER_WORK
                                </div>
                                <div class="detail-summary">
                                    <div class="ds-header">
                                        <span>검침 연결 정보</span>
                                        <a href="${pageContext.request.contextPath}/manager/checkHistory">검침기록 보기 →</a>
                                    </div>
                                    <div class="ds-body" id="detailMeterBody"></div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-action="closeDetailModal">닫기</button>
                            <button type="button" class="btn btn-primary" data-action="editFromDetail" id="detailEditBtn">수정하기</button>
                        </div>
                    </div>
                </div>

            </div><!-- /office-page -->

            <script>
                (function () {
                    var page = document.getElementById('facilityPage');
                    if (!page || page.dataset.bound === 'true') return;
                    page.dataset.bound = 'true';

                    /* ── 공통코드 맵 ──────────────────────────────────────────
                       FACILITY_TY : ELV/WTR/ELC/GAS/FIRE/SEC/ETC
                       CHECK_STTS  : WAIT/ING/DONE/FAULT
                       CHECK_TY    : REG/SPC/SAFE/REPAIR
                       CONTRACT_STTS: DRAFT/ACTIVE/END/TERM
                    ────────────────────────────────────────────────────────── */
                    var FAC_TY_TEXT  = { ELV:'승강기', WTR:'급수시설', ELC:'전기시설', GAS:'가스시설', FIRE:'소방시설', SEC:'보안시설', ETC:'기타시설' };
                    var FAC_TY_BADGE = { ELV:'badge-blue', WTR:'badge-teal', ELC:'badge-yellow', GAS:'badge-orange', FIRE:'badge-red', SEC:'badge-purple', ETC:'badge-gray' };
                    var CHK_ST_TEXT  = { WAIT:'점검대기', ING:'점검중', DONE:'점검완료', FAULT:'이상발견' };
                    var CHK_ST_BADGE = { WAIT:'badge-yellow', ING:'badge-blue', DONE:'badge-green', FAULT:'badge-red' };
                    var CHK_TY_TEXT  = { REG:'정기점검', SPC:'특별점검', SAFE:'안전점검', REPAIR:'보수점검' };
                    var CONT_ST_TEXT = { DRAFT:'작성중', ACTIVE:'유효', END:'종료', TERM:'해지' };
                    var CONT_ST_BADGE = { DRAFT:'badge-blue', ACTIVE:'badge-green', END:'badge-gray', TERM:'badge-red' };

                    /* ── 더미 데이터 ──────────────────────────────────────────
                       백엔드 연결 시 AJAX 조회 결과로 대체한다.
                       검침 연결 시설 여부는 meterWork 존재 여부로 판단한다.
                    ────────────────────────────────────────────────────────── */
                    var facilityData = [
                        { facilityNo:'FAC-001', facilityNm:'1호기 승강기', facilityTyCd:'ELV', dongNo:'101', locCn:'1층 승강기 홀', instlDt:'2018-03-15', upcomingCheckCnt:1,
                            contracts:[{ contNo:'CT-001', contNm:'2026 승강기 유지보수 계약', contSttsCd:'ACTIVE', partnerNm:'승강기관리(주)', contEndDt:'2026-12-31' }],
                            checks:[{ facChkHstryNo:'FCH-008', chkDt:'2026-05-02', chkTyCd:'SPC', chkSttsCd:'WAIT', chkCn:'법정 정기검사 예정' }, { facChkHstryNo:'FCH-001', chkDt:'2026-04-10', chkTyCd:'REG', chkSttsCd:'DONE', chkCn:'월간 점검 완료' }] },
                        { facilityNo:'FAC-002', facilityNm:'2호기 승강기', facilityTyCd:'ELV', dongNo:'102', locCn:'1층 승강기 홀', instlDt:'2018-03-15', upcomingCheckCnt:0,
                            contracts:[{ contNo:'CT-006', contNm:'2호기 승강기 유지보수', contSttsCd:'ACTIVE', partnerNm:'KD승강기서비스', contEndDt:'2026-12-31' }],
                            checks:[{ facChkHstryNo:'FCH-007', chkDt:'2026-04-22', chkTyCd:'REG', chkSttsCd:'DONE', chkCn:'와이어 장력 조정 완료' }] },
                        { facilityNo:'FAC-003', facilityNm:'지하 전기실', facilityTyCd:'ELC', dongNo:'공용', locCn:'지하 1층 전기실', instlDt:'2015-07-01', upcomingCheckCnt:2,
                            meterWork:{ meterWrkNo:'MWK-003', partnerNm:'한전서비스', meterTyCd:'ELEC', meterMethod:'API' },
                            checks:[{ facChkHstryNo:'FCH-008', chkDt:'2026-05-02', chkTyCd:'REPAIR', chkSttsCd:'ING', chkCn:'분전반 교체 작업 진행 중' }, { facChkHstryNo:'FCH-003', chkDt:'2026-04-14', chkTyCd:'SPC', chkSttsCd:'FAULT', chkCn:'분전반 3번 이상 발견' }] },
                        { facilityNo:'FAC-004', facilityNm:'스프링클러 설비', facilityTyCd:'FIRE', dongNo:'공용', locCn:'각 동 천장', instlDt:'2016-05-20', upcomingCheckCnt:0,
                            contracts:[{ contNo:'CT-002', contNm:'소방시설 정기점검 계약', contSttsCd:'ACTIVE', partnerNm:'한국소방안전', contEndDt:'2026-05-30' }],
                            checks:[{ facChkHstryNo:'FCH-002', chkDt:'2026-04-12', chkTyCd:'REG', chkSttsCd:'DONE', chkCn:'스프링클러 작동 상태 확인 완료' }] },
                        { facilityNo:'FAC-005', facilityNm:'옥상 물탱크', facilityTyCd:'WTR', dongNo:'', locCn:'옥상 기계실', instlDt:'2015-07-01', upcomingCheckCnt:1,
                            meterWork:{ meterWrkNo:'MWK-002', partnerNm:'푸른급수관리', meterTyCd:'WATER', meterMethod:'API' },
                            checks:[{ facChkHstryNo:'FCH-005', chkDt:'2026-04-18', chkTyCd:'SAFE', chkSttsCd:'DONE', chkCn:'물탱크 위생 점검 이상 없음' }] },
                        { facilityNo:'FAC-006', facilityNm:'CCTV 101동', facilityTyCd:'SEC', dongNo:'101', locCn:'각 층 복도', instlDt:'2020-11-10', upcomingCheckCnt:0,
                            contracts:[{ contNo:'CT-005', contNm:'CCTV 운영 및 보안 계약', contSttsCd:'DRAFT', partnerNm:'보안솔루션', contEndDt:'2026-12-31' }],
                            checks:[{ facChkHstryNo:'FCH-004', chkDt:'2026-04-16', chkTyCd:'REG', chkSttsCd:'DONE', chkCn:'CCTV 화질 조정 및 녹화 테스트 완료' }] }
                    ];

                    var currentIdx = null;
                    var form = document.getElementById('facilityForm');
                    var correctionBtn = document.getElementById('facilityCorrectionBtn');

                    function b(cls, t) { return '<span class="badge ' + cls + '">' + t + '</span>'; }
                    function facTyB(cd) { return b(FAC_TY_BADGE[cd] || 'badge-gray', FAC_TY_TEXT[cd] || cd); }
                    function chkStB(cd) { return b(CHK_ST_BADGE[cd] || 'badge-gray', CHK_ST_TEXT[cd] || cd); }
                    function contStB(cd) { return b(CONT_ST_BADGE[cd] || 'badge-gray', CONT_ST_TEXT[cd] || cd); }
                    function meterLinkB(r) { return r.meterWork ? b('badge-teal', '연결') : b('badge-gray', '미연결'); }
                    function di(l, v) { return '<div class="mngr-detail-item"><div class="mngr-detail-label">' + l + '</div><div class="mngr-detail-value">' + v + '</div></div>'; }
                    function openM(id) { document.getElementById(id).classList.add('open'); }
                    function closeM(id) { document.getElementById(id).classList.remove('open'); }

                    function hasLinkedData(r) {
                        return (r.contracts && r.contracts.length > 0) || (r.checks && r.checks.length > 0) || !!r.meterWork;
                    }

                    /* ── 현황 카드 ──
                       FACILITY 마스터 기준: 전체, 동 지정, 공용 위치, 검침 연결
                    */
                    function updateStats(data) {
                        document.getElementById('statTotal').textContent = data.length;
                        document.getElementById('statDong').textContent = data.filter(function(r){ return r.dongNo && r.dongNo !== '공용'; }).length;
                        document.getElementById('statCommonLoc').textContent = data.filter(function(r){ return !r.dongNo || r.dongNo === '공용'; }).length;
                        document.getElementById('statMeterLinked').textContent = data.filter(function(r){ return !!r.meterWork; }).length;
                    }

                    function getFilterSummaryText() {
                        var labels = [];
                        var ty = document.getElementById('filterFacTy').value;
                        var dng = document.getElementById('filterDong').value;
                        var meter = document.getElementById('filterMeterLink').value;
                        var kw = document.getElementById('filterKeyword').value.trim();

                        if (ty) labels.push(FAC_TY_TEXT[ty] || ty);
                        if (dng) labels.push(dng);
                        if (meter) labels.push(meter === 'Y' ? '검침 연결 있음' : '검침 연결 없음');
                        if (kw) labels.push('검색어: ' + kw);
                        return labels.length ? labels.join(' · ') : '전체 조건';
                    }

                    function filtered() {
                        var ty = document.getElementById('filterFacTy').value;
                        var dng = document.getElementById('filterDong').value;
                        var meter = document.getElementById('filterMeterLink').value;
                        var kw = document.getElementById('filterKeyword').value.trim();

                        return facilityData.filter(function(r){
                            var meterYn = r.meterWork ? 'Y' : 'N';
                            return (!ty || r.facilityTyCd === ty)
                                && (!dng || r.dongNo === dng)
                                && (!meter || meterYn === meter)
                                && (!kw || r.facilityNm.indexOf(kw) > -1 || (r.locCn || '').indexOf(kw) > -1);
                        });
                    }

                    function renderFacility(data) {
                        document.getElementById('facilityCount').textContent = data.length + '건';
                        document.getElementById('resultDesc').textContent = getFilterSummaryText();

                        var tb = document.getElementById('facilityTbody');
                        if (!data.length) {
                            tb.innerHTML = '<tr><td colspan="9" class="empty-row">조건에 맞는 시설이 없습니다.</td></tr>';
                            return;
                        }

                        tb.innerHTML = data.map(function(r){
                            var realIdx = facilityData.indexOf(r);
                            return '<tr>'
                                + '<td class="td-mono">' + r.facilityNo + '</td>'
                                + '<td class="td-bold">' + r.facilityNm + '</td>'
                                + '<td class="col-center">' + facTyB(r.facilityTyCd) + '</td>'
                                + '<td class="col-center">' + meterLinkB(r) + '</td>'
                                + '<td class="col-center td-mono">' + (r.dongNo || '—') + '</td>'
                                + '<td style="font-size:11px;color:#6b7a6e;">' + (r.locCn || '—') + '</td>'
                                + '<td class="col-center td-mono">' + (r.instlDt || '—') + '</td>'
                                + '<td class="col-center">' + ((r.upcomingCheckCnt || 0) > 0 ? b('badge-yellow', '예정 ' + r.upcomingCheckCnt + '건') : b('badge-gray', '없음')) + '</td>'
                                + '<td class="col-manage"><div class="grid-actions">'
                                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + realIdx + '">상세</button>'
                                + '<button type="button" class="btn btn-xs btn-edit" data-action="edit" data-idx="' + realIdx + '">수정</button>'
                                + '</div></td></tr>';
                        }).join('');
                    }

                    function bindFilterAutoSearch() {
                        ['filterFacTy','filterDong','filterMeterLink'].forEach(function(id){
                            document.getElementById(id).addEventListener('change', function(){ renderFacility(filtered()); });
                        });
                        document.getElementById('filterKeyword').addEventListener('keyup', function(e){
                            if (e.key === 'Enter') renderFacility(filtered());
                        });
                    }

                    function setEditMode(isEdit) {
                        page.classList.toggle('is-edit-mode', isEdit);
                        document.getElementById('facilityTyCd').disabled = isEdit;
                        correctionBtn.style.display = isEdit ? 'inline-flex' : 'none';
                    }

                    function openModal(mode, idx) {
                        form.reset();
                        currentIdx = idx !== undefined ? idx : null;

                        if (mode === 'register') {
                            document.getElementById('facilityModalTitle').textContent = '시설 등록';
                            setEditMode(false);
                        }

                        if (mode === 'edit' && currentIdx !== null) {
                            var r = facilityData[currentIdx];
                            document.getElementById('facilityModalTitle').textContent = '시설 수정';
                            document.getElementById('facilityNo').value = r.facilityNo || '';
                            document.getElementById('facilityNm').value = r.facilityNm || '';
                            document.getElementById('facilityTyCd').value = r.facilityTyCd || '';
                            document.getElementById('instlDt').value = r.instlDt || '';
                            document.getElementById('dongNo').value = r.dongNo || '';
                            document.getElementById('locCn').value = r.locCn || '';
                            setEditMode(true);
                        }

                        openM('facilityModal');
                    }

                    function openDetail(idx) {
                        var r = facilityData[idx];
                        currentIdx = idx;
                        document.getElementById('detailModalTitle').textContent = r.facilityNm + ' · 상세';
                        document.getElementById('detailEditBtn').dataset.idx = idx;

                        document.getElementById('detailBasicGrid').innerHTML =
                            di('FACILITY_NO', r.facilityNo)
                            + di('시설명 (FACILITY_NM)', r.facilityNm)
                            + di('시설유형 (FACILITY_TY_CD)', facTyB(r.facilityTyCd))
                            + di('검침 연결 여부', meterLinkB(r))
                            + di('동 (DONG_NO)', r.dongNo || '—')
                            + di('상세위치 (LOC_CN)', r.locCn || '—')
                            + di('설치일자 (INSTL_DT)', r.instlDt || '—')
                            + di('예정 점검 일정', (r.upcomingCheckCnt || 0) + '건');

                        var contBody = document.getElementById('detailContBody');
                        if (r.contracts && r.contracts.length) {
                            var c = r.contracts[0];
                            contBody.innerHTML = '<div class="ds-row">'
                                + '<span class="ds-no">' + c.contNo + '</span>'
                                + '<span class="ds-nm">' + c.contNm + '</span>'
                                + '<span>' + contStB(c.contSttsCd) + '</span>'
                                + '<span class="ds-dt">' + c.partnerNm + '</span>'
                                + '<span class="ds-dt">' + (c.contEndDt || '—') + '</span>'
                                + '</div>';
                        } else {
                            contBody.innerHTML = '<div class="ds-empty">등록된 계약이 없습니다.</div>';
                        }

                        var chkBody = document.getElementById('detailChkBody');
                        if (r.checks && r.checks.length) {
                            chkBody.innerHTML = r.checks.slice(0,3).map(function(c){
                                return '<div class="ds-row">'
                                    + '<span class="ds-no">' + c.facChkHstryNo + '</span>'
                                    + '<span class="ds-dt">' + c.chkDt + '</span>'
                                    + '<span>' + b('badge-gray', CHK_TY_TEXT[c.chkTyCd] || c.chkTyCd) + '</span>'
                                    + '<span>' + chkStB(c.chkSttsCd) + '</span>'
                                    + '<span class="ds-nm" style="font-weight:400;color:#6b7a6e;">' + c.chkCn + '</span>'
                                    + '</div>';
                            }).join('');
                        } else {
                            chkBody.innerHTML = '<div class="ds-empty">점검이력이 없습니다.</div>';
                        }

                        var meterBody = document.getElementById('detailMeterBody');
                        if (r.meterWork) {
                            var m = r.meterWork;
                            meterBody.innerHTML = '<div class="ds-row">'
                                + '<span class="ds-no">' + m.meterWrkNo + '</span>'
                                + '<span class="ds-nm">' + m.partnerNm + '</span>'
                                + '<span>' + b('badge-teal', m.meterTyCd) + '</span>'
                                + '<span>' + b('badge-blue', m.meterMethod === 'API' ? 'API 연동' : '수동') + '</span>'
                                + '</div>';
                        } else {
                            meterBody.innerHTML = '<div class="ds-empty">검침작업과 연결되지 않은 시설입니다.</div>';
                        }

                        openM('facilityDetailModal');
                    }

                    page.addEventListener('click', function(e){
                        var btn = e.target.closest('[data-action]');
                        if (!btn) return;

                        var action = btn.dataset.action;
                        var idx = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

                        if (action === 'openRegister') openModal('register');
                        if (action === 'edit') openModal('edit', idx);
                        if (action === 'detail') openDetail(idx);
                        if (action === 'editFromDetail') { closeM('facilityDetailModal'); openModal('edit', Number(btn.dataset.idx)); }
                        if (action === 'closeFacilityModal') { closeM('facilityModal'); setEditMode(false); }
                        if (action === 'closeDetailModal') closeM('facilityDetailModal');

                        if (action === 'searchFacility') renderFacility(filtered());
                        if (action === 'resetFacility') {
                            ['filterFacTy','filterDong','filterMeterLink','filterKeyword'].forEach(function(id){ document.getElementById(id).value = ''; });
                            renderFacility(facilityData);
                        }

                        if (action === 'openCorrection') {
                            if (currentIdx === null) return;
                            var target = facilityData[currentIdx];
                            /*
                             * 분류값 정정은 오등록 예외 처리용이다.
                             * 서버에서는 FACILITY_CONTRACT, FACILITY_CHECK_HISTORY, METER_WORK 연결 건수를 다시 확인해야 한다.
                             */
                            if (hasLinkedData(target)) {
                                alert('연결된 계약·점검·검침 데이터가 있어 시설유형을 정정할 수 없습니다. 담당자 또는 DB 관리자 확인이 필요합니다.');
                                return;
                            }
                            alert('연결 데이터가 없는 오등록 건입니다. 서버 검증 후 시설유형 정정 화면을 열 수 있습니다.');
                        }
                    });

                    form.addEventListener('submit', function(e){
                        e.preventDefault();
                        if (!document.getElementById('facilityNm').value.trim()) { alert('시설명을 입력하세요.'); return; }
                        if (!document.getElementById('facilityTyCd').value) { alert('시설유형을 선택하세요.'); return; }

                        if (currentIdx === null) {
                            /*
                             * TODO: AJAX POST /manager/facility/api/insert/{mgmtOfcNo}
                             * - FACILITY INSERT
                             * - APT_CMPLEX_NO는 mgmtOfcNo로 MGMT_OFFICE 조회 후 서버에서 세팅
                             * - 검침 연결은 여기서 처리하지 않고 METER_WORK 연결 기능에서 처리
                             */
                            alert('등록 요청 — FACILITY insert');
                        } else {
                            /*
                             * TODO: AJAX POST /manager/facility/api/update/{mgmtOfcNo}/{facilityNo}
                             * - 시설명, 동, 상세위치, 설치일자만 수정
                             * - FACILITY_TY_CD는 일반 수정 update 대상에서 제외
                             */
                            alert('수정 요청 — FACILITY 기본정보 update');
                        }

                        closeM('facilityModal');
                        setEditMode(false);
                    });

                    document.getElementById('facilityModal').addEventListener('click', function(e){
                        if (e.target === this) { closeM('facilityModal'); setEditMode(false); }
                    });
                    document.getElementById('facilityDetailModal').addEventListener('click', function(e){
                        if (e.target === this) closeM('facilityDetailModal');
                    });

                    bindFilterAutoSearch();
                    updateStats(facilityData);
                    renderFacility(facilityData);
                })();
            </script>
        </main>
    </div>
</div>
</body>
</html>
