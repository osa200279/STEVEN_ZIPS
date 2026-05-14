<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설(공용) 등록</title>
    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #publicFacilityPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb; --line:#d7dce2; --th-bg:#f3f5f3; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #publicFacilityPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityPage .page-title-block p  { color:var(--text-sec); font-size:12px; }
        #publicFacilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityPage .panel-body .form-input, #publicFacilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #publicFacilityPage .panel-body .form-input:focus, #publicFacilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityPage .panel-body .form-input[readonly] { background:var(--surface-sub); color:var(--text-pri); opacity:1; cursor:default; }
        #publicFacilityPage .panel-body .form-input:disabled, #publicFacilityPage .panel-body .form-select:disabled { background:#f4f5f6; color:#9ca3af; cursor:not-allowed; }
        #publicFacilityPage .panel-body .form-textarea { font-size:12px; border-color:var(--line); border-radius:4px; resize:vertical; }
        #publicFacilityPage .panel-body .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityPage .btn { border-radius:4px; }
        #publicFacilityPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:var(--text-sec); line-height:1.6; }
        #publicFacilityPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #publicFacilityPage .field-help { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.5; }
        .form-section-title { display:flex; align-items:center; gap:4px; font-size:11px; font-weight:800; color:var(--text-sec,#4a5c4e); letter-spacing:0; text-transform:none; margin-bottom:10px; }
        .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent,#2e5c38); }

        /* 2컬럼 레이아웃 */
        .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line,#d7dce2); }
        .facility-modal-col-right { padding-left:20px; }
        .facility-col-label { font-size:11px; font-weight:800; color:#8a9a8e; letter-spacing:.5px; text-transform:uppercase; padding-bottom:8px; border-bottom:1px solid var(--line,#d7dce2); margin-bottom:14px; }

        /* 등록 방식 탭 */
        #publicFacilityPage .mode-tabs { display:grid; grid-template-columns:1fr 1fr; gap:6px; margin-bottom:14px; }
        #publicFacilityPage .mode-tab { display:flex; align-items:center; justify-content:center; gap:5px; height:34px; border:1px solid var(--line); border-radius:4px; background:var(--surface); color:var(--text-sec); font-size:12px; font-weight:800; cursor:pointer; }
        #publicFacilityPage .mode-tab .material-symbols-rounded { font-size:16px; }
        #publicFacilityPage .mode-tab.is-active { border-color:var(--accent); background:var(--accent-light); color:var(--accent); }
        #publicFacilityPage .mode-panel { display:none; }
        #publicFacilityPage .mode-panel.is-active { display:block; }

        /* 선택된 시설자산 요약 */
        #publicFacilityPage .selected-facility-box { border:none; border-radius:0; background:none; padding:0; }
        #publicFacilityPage .selected-facility-box.is-selected { border:1px solid var(--line); border-radius:4px; padding:12px; }
        #publicFacilityPage .selected-empty { display:flex; align-items:center; justify-content:center; flex-direction:column; gap:5px; min-height:92px; color:var(--text-ter); font-size:12px; text-align:center; }
        #publicFacilityPage .selected-empty .material-symbols-rounded { font-size:24px; color:#a7b2aa; }
        #publicFacilityPage .selected-summary { display:none; }
        #publicFacilityPage .selected-summary.is-active { display:block; }
        #publicFacilityPage .selected-head { display:flex; align-items:center; justify-content:space-between; gap:8px; margin-bottom:10px; }
        #publicFacilityPage .selected-name { font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .selected-code { font-size:11px; color:var(--text-ter); }
        #publicFacilityPage .selected-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; }
        #publicFacilityPage .selected-item { min-height:44px; padding:8px 9px; border:1px solid var(--line); border-radius:4px; background:var(--surface-sub); }
        #publicFacilityPage .selected-label { display:block; margin-bottom:3px; font-size:10px; font-weight:800; color:var(--text-ter); }
        #publicFacilityPage .selected-value { font-size:12px; font-weight:700; color:var(--text-pri); }

        /* 시설자산 선택 모달 */
        #publicFacilityPage .facility-select-modal { display:none; position:fixed; inset:0; z-index:9500; background:rgba(16,24,20,.48); align-items:center; justify-content:center; padding:28px; box-sizing:border-box; }
        #publicFacilityPage .facility-select-modal.is-open { display:flex; }
        #publicFacilityPage .facility-select-box { width:min(920px, 94vw); max-height:86vh; display:flex; flex-direction:column; border-radius:3px; background:#fff; border:1px solid rgba(215,220,226,.95); box-shadow:0 22px 52px rgba(0,0,0,.22); overflow:hidden; }
        #publicFacilityPage .facility-select-head { display:flex; align-items:center; justify-content:space-between; gap:12px; padding:15px 18px; border-bottom:1px solid var(--line); background:var(--surface); }
        #publicFacilityPage .facility-select-title { display:flex; align-items:center; gap:7px; margin:0; font-size:14px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .facility-select-title .material-symbols-rounded { color:var(--accent); font-size:18px; }
        #publicFacilityPage .facility-select-close { width:30px; height:30px; border:0; border-radius:4px; background:transparent; color:#4b5563; cursor:pointer; }
        #publicFacilityPage .facility-select-close:hover { background:#edf2ee; color:var(--accent); }
        #publicFacilityPage .facility-select-body { padding:14px 16px 16px; overflow:auto; }
        #publicFacilityPage .candidate-summary-row { display:flex; align-items:center; justify-content:flex-start; gap:6px; margin-bottom:10px; }
        #publicFacilityPage .candidate-count { display:inline-flex; align-items:center; gap:5px; height:28px; padding:0 10px; border:1px solid var(--line); border-radius:4px; background:var(--surface-sub); font-size:12px; color:var(--text-sec); }
        #publicFacilityPage .candidate-count strong { color:var(--accent); font-weight:800; }
        #publicFacilityPage .candidate-filter { display:grid; grid-template-columns:1.4fr .9fr .9fr auto; gap:7px; margin-bottom:10px; padding:10px; border:1px solid var(--line); border-radius:6px; background:var(--surface-sub); }
        #publicFacilityPage .candidate-table-wrap { border:1px solid var(--line); border-radius:6px; overflow:hidden; background:#fff; }
        #publicFacilityPage .candidate-table { width:100%; border-collapse:collapse; table-layout:fixed; }
        #publicFacilityPage .candidate-table th { height:34px; padding:0 10px; border-bottom:1px solid var(--line); background:#f3f5f3; color:var(--text-sec); font-size:11px; font-weight:800; text-align:left; }
        #publicFacilityPage .candidate-table td { height:42px; padding:7px 10px; border-bottom:1px solid var(--line); color:var(--text-pri); font-size:12px; vertical-align:middle; }
        #publicFacilityPage .candidate-table tbody tr:last-child td { border-bottom:0; }
        #publicFacilityPage .candidate-table tbody tr:hover { background:var(--accent-dim); }
        #publicFacilityPage .candidate-table .candidate-hidden { display:none; }
        #publicFacilityPage .candidate-table .cell-center { text-align:center; }
        #publicFacilityPage .candidate-name-main { display:block; font-size:12px; font-weight:800; color:var(--text-pri); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .candidate-name-sub { display:block; margin-top:2px; font-size:11px; color:var(--text-ter); overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        #publicFacilityPage .candidate-empty-row td { height:68px; text-align:center; color:var(--text-ter); }
        #publicFacilityPage .badge-mini { display:inline-flex; align-items:center; height:22px; padding:0 8px; border-radius:4px; font-size:11px; font-weight:800; }
        #publicFacilityPage .badge-use-y { background:#dceee0; color:#1f7a3f; }
        #publicFacilityPage .badge-use-n { background:#fee2e2; color:#b42318; }

        /* 사진 업로드 */
        #publicFacilityPage .file-upload-box { border:1px dashed var(--line); border-radius:4px; padding:12px; background:#fafcfb; }
        #publicFacilityPage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:800; color:var(--text-sec); }
        #publicFacilityPage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #publicFacilityPage .file-upload-desc { font-size:11px; color:var(--text-ter); line-height:1.5; }
        #publicFacilityPage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #publicFacilityPage .file-preview-item { position:relative; min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #publicFacilityPage .file-preview-item img { width:100%; height:92px; object-fit:cover; display:block; cursor:zoom-in; }
        #publicFacilityPage .file-preview-name { padding:6px 7px; font-size:11px; color:var(--text-sec); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; border-top:1px solid var(--line); }
        #publicFacilityPage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:var(--text-ter); }
        #publicFacilityPage .file-manage-list { display:flex; flex-direction:column; gap:7px; margin-top:8px; }
        #publicFacilityPage .file-manage-row { display:flex; align-items:center; gap:10px; padding:8px 10px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #publicFacilityPage .file-thumb { width:48px; height:48px; border-radius:4px; border:1px solid var(--line); object-fit:cover; background:#f4f7f4; flex-shrink:0; cursor:zoom-in; }
        #publicFacilityPage .file-info { min-width:0; flex:1; }
        #publicFacilityPage .file-name { font-size:12px; font-weight:700; color:#111827; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #publicFacilityPage .file-meta { margin-top:2px; font-size:11px; color:var(--text-ter); }
        #publicFacilityPage .file-delete-check { display:inline-flex; align-items:center; gap:4px; font-size:11px; color:#7f1d1d; font-weight:700; }
        #publicFacilityPage .file-delete-check input { width:14px; height:14px; }

        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
            #publicFacilityPage .candidate-filter { grid-template-columns:1fr; }
            #publicFacilityPage .selected-grid { grid-template-columns:1fr; }
        }
    </style>

    <script>
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            preselectFacilityNo: "${param.facilityNo}"
        };
    </script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/publicFacility/list/${mgmtOfcNo}" />
        <c:set var="activeSidebarParent" value="시설·공사 관리" />
        <c:set var="activeSidebarCurrent" value="편의시설(공용) 관리" />
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
        <main class="main-content">
            <div class="office-page" id="publicFacilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설(공용) 등록</h2>
                        <p>기존 시설자산을 운영관리 대상으로 연결하거나, 새 시설자산과 편의시설(공용) 운영정보를 함께 등록합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>편의시설(공용) 정보 입력</h3>
                    </div>

                    <form id="registerForm" method="post" action="${pageContext.request.contextPath}/manager/publicFacility/insert/${mgmtOfcNo}" enctype="multipart/form-data">
                        <sec:csrfInput/>
                        <input type="hidden" id="registerMode" name="registerMode" value="EXISTING">
                        <input type="hidden" id="selectedFacilityNo" name="facilityNo" value="${param.facilityNo}">
                        <input type="hidden" id="deleteFileUuids" name="deleteFileUuids">

                        <div class="panel-body">
                            <div class="form-section" style="margin-bottom:14px;">
                                <div class="notice-box">
                                    <span class="material-symbols-rounded">info</span>
                                    <div>
                                        기존 시설자산 선택은 FACILITY에 등록되어 있지만 아직 운영관리 정보가 없는 시설을 연결합니다.<br>
                                        새 시설자산 등록은 FACILITY를 먼저 생성한 뒤 PUBLIC_FACILITY를 연결합니다. 사진은 연결된 FACILITY.FILE_GROUP_NO 기준으로 저장됩니다.
                                    </div>
                                </div>
                            </div>

                            <div class="facility-modal-cols">
                                <div class="facility-modal-col-left">
                                    <div class="facility-col-label">시설 정보</div>

                                    <div class="mode-tabs" role="tablist" aria-label="편의시설(공용) 등록 방식 선택">
                                        <button type="button" class="mode-tab is-active" data-mode="EXISTING" role="tab" aria-selected="true">
                                            <span class="material-symbols-rounded">link</span>기존 시설자산 선택
                                        </button>
                                        <button type="button" class="mode-tab" data-mode="NEW" role="tab" aria-selected="false">
                                            <span class="material-symbols-rounded">add_business</span>새 시설자산 등록
                                        </button>
                                    </div>

                                    <%-- 기존 시설자산 선택 탭: 선택 요약만 표시하고 목록은 모달에서 검색 --%>
                                    <div class="mode-panel is-active" id="existingFacilityPanel" data-mode-panel="EXISTING">
                                        <div class="form-section" style="margin-bottom:14px;">
                                            <div class="form-section-title">
                                                <span class="material-symbols-rounded">fact_check</span>기존 시설자산 선택
                                            </div>

                                            <div class="selected-facility-box">
                                                <div class="selected-empty" id="selectedEmptyBox">
                                                    <span class="material-symbols-rounded">domain_add</span>
                                                    <div>운영관리 정보를 입력할 시설자산을 선택하세요.</div>
                                                    <button type="button" class="btn btn-secondary" id="openFacilityModalBtn">시설자산 선택</button>
                                                </div>

                                                <div class="selected-summary" id="selectedSummaryBox">
                                                    <div class="selected-head">
                                                        <div>
                                                            <div class="selected-name" id="selectedFacilityNmText">-</div>
                                                            <div class="selected-code" id="selectedFacilityNoText">-</div>
                                                        </div>
                                                        <button type="button" class="btn btn-secondary" id="changeFacilityBtn">다시 선택</button>
                                                    </div>
                                                    <div class="selected-grid">
                                                        <div class="selected-item"><span class="selected-label">시설유형</span><span class="selected-value" id="selectedFacilityTyText">-</span></div>
                                                        <div class="selected-item"><span class="selected-label">위치</span><span class="selected-value" id="selectedLocationText">-</span></div>
                                                        <div class="selected-item"><span class="selected-label">사용여부</span><span class="selected-value" id="selectedUseYnText">-</span></div>
                                                        <div class="selected-item"><span class="selected-label">사진 저장 기준</span><span class="selected-value">시설자산 사진</span></div>
                                                    </div>
                                                    <div class="field-help">선택된 시설자산의 FACILITY.FILE_GROUP_NO에 이번 등록 사진이 함께 저장됩니다.</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- 새 시설자산 등록 탭: 위치 구분 포함 --%>
                                    <div class="mode-panel" id="newFacilityPanel" data-mode-panel="NEW">
                                        <div class="form-section" style="margin-bottom:14px;">
                                            <div class="form-section-title">
                                                <span class="material-symbols-rounded">apartment</span>새 시설자산 정보
                                            </div>

                                            <div class="form-row cols-2">
                                                <div class="form-field">
                                                    <label class="field-label">시설명 <span class="req">*</span></label>
                                                    <input type="text" class="form-input" id="regFacilityNm" name="facilityNm" placeholder="예) 헬스장">
                                                </div>
                                                <div class="form-field">
                                                    <label class="field-label">시설유형</label>
                                                    <select class="form-select" id="regFacilityTyCd" name="facilityTyCd">
                                                        <option value="ETC">기타시설</option>
                                                        <option value="PLAY">놀이터</option>
                                                        <option value="PARK">주차장</option>
                                                        <option value="ELV">승강기</option>
                                                        <option value="FIRE">소방시설</option>
                                                        <option value="ELC">전기시설</option>
                                                        <option value="WTR">급수시설</option>
                                                        <option value="GAS">가스시설</option>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-row cols-2">
                                                <div class="form-field">
                                                    <label class="field-label">위치 구분</label>
                                                    <select class="form-select" id="regLocationType" name="locationType">
                                                        <option value="COMMON">공용 위치</option>
                                                        <option value="DONG">동 기준 위치</option>
                                                    </select>
                                                </div>
                                                <div class="form-field" id="regDongField">
                                                    <label class="field-label">동</label>
                                                    <select class="form-select" id="regDongNo" name="dongNo">
                                                        <option value="">선택 안 함</option>
                                                        <c:forEach var="dong" items="${dongList}">
                                                            <option value="${dong.dongNo}">
                                                                    ${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}
                                                            </option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                            </div>

                                            <div class="form-row cols-2">
                                                <div class="form-field">
                                                    <label class="field-label">상세위치</label>
                                                    <input type="text" class="form-input" id="regLocCn" name="locCn" placeholder="예) 커뮤니티센터 2층">
                                                </div>
                                                <div class="form-field">
                                                    <label class="field-label">활성여부</label>
                                                    <select class="form-select" id="regUseYn" name="useYn">
                                                        <option value="Y">활성</option>
                                                        <option value="N">비활성</option>
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%-- PUBLIC_FACILITY 운영정보 공통 영역 --%>
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">meeting_room</span>편의시설(공용) 운영정보
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">편의시설(공용)명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="regCmnNm" name="cmnFacilityNm" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="regRsvYn" name="cmnFacilityRsvYn">
                                                    <option value="Y">예약 가능</option>
                                                    <option value="N">예약 불가</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="regAmt" name="cmnFacilityAmt" placeholder="0 (무료)" min="0">
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">운영시간</label>
                                                <input type="text" class="form-input" id="regOprHr" name="cmnFacilityOprHr" placeholder="예) 06:00~22:00">
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="regCn" name="cmnFacilityCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 우측: 사진 등록 --%>
                                <div class="facility-modal-col-right">
                                    <div class="facility-col-label">시설 사진</div>

                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">image</span>시설 사진
                                        </div>
                                        <div class="file-manage-list" id="regFileManageList" style="display:none;margin-bottom:8px;"></div>
                                        <div class="file-upload-box">
                                            <div class="file-upload-title"><span class="material-symbols-rounded">upload_file</span>사진 추가</div>
                                            <div class="file-upload-desc" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                            <input type="file" class="form-input" id="regImgInput" name="facilityFiles" accept="image/*" multiple>
                                            <div class="file-preview-list" id="regImgGrid" style="margin-top:8px;">
                                                <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                            <button type="button" class="btn btn-secondary" id="backToListBtn">취소</button>
                            <button type="submit" class="btn btn-primary">저장</button>
                        </div>
                    </form>
                </div>

                <%-- 시설자산 선택 모달 --%>
                <div class="facility-select-modal" id="facilitySelectModal" aria-hidden="true">
                    <div class="facility-select-box" role="dialog" aria-modal="true" aria-label="시설자산 선택">
                        <div class="facility-select-head">
                            <h3 class="facility-select-title"><span class="material-symbols-rounded">domain_search</span>운영관리 미등록 시설자산 선택</h3>
                            <button type="button" class="facility-select-close" id="closeFacilityModalBtn" aria-label="닫기">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="facility-select-body">
                            <div class="candidate-summary-row">
                                <div class="candidate-count" id="candidateTotalCount">전체 <strong><c:choose><c:when test="${not empty facilityCandidateList}">${fn:length(facilityCandidateList)}</c:when><c:otherwise>0</c:otherwise></c:choose></strong>건</div>
                                <div class="candidate-count" id="candidateVisibleCount">검색 결과 <strong>0</strong>건</div>
                            </div>

                            <div class="candidate-filter">
                                <input type="text" class="form-input" id="facilityKeyword" placeholder="시설명, 시설번호, 위치 검색">
                                <select class="form-select" id="facilityTypeFilter">
                                    <option value="">시설유형 전체</option>
                                    <option value="ETC">기타시설</option>
                                    <option value="PLAY">놀이터</option>
                                    <option value="PARK">주차장</option>
                                    <option value="ELV">승강기</option>
                                    <option value="FIRE">소방시설</option>
                                    <option value="ELC">전기시설</option>
                                    <option value="WTR">급수시설</option>
                                    <option value="GAS">가스시설</option>
                                </select>
                                <select class="form-select" id="facilityDongFilter">
                                    <option value="">동 전체</option>
                                    <c:forEach var="dong" items="${dongList}">
                                        <option value="${dong.dongNo}">
                                                ${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}
                                        </option>
                                    </c:forEach>
                                </select>
                                <button type="button" class="btn btn-secondary" id="facilityResetBtn">초기화</button>
                            </div>

                            <div class="candidate-table-wrap">
                                <table class="candidate-table">
                                    <colgroup>
                                        <col style="width:18%;">
                                        <col style="width:24%;">
                                        <col style="width:14%;">
                                        <col style="width:28%;">
                                        <col style="width:8%;">
                                        <col style="width:8%;">
                                    </colgroup>
                                    <thead>
                                    <tr>
                                        <th>시설번호</th>
                                        <th>시설명</th>
                                        <th>시설유형</th>
                                        <th>위치</th>
                                        <th>사용</th>
                                        <th class="cell-center">선택</th>
                                    </tr>
                                    </thead>
                                    <tbody id="facilityCandidateBody">
                                    <c:choose>
                                        <c:when test="${not empty facilityCandidateList}">
                                            <c:forEach var="facility" items="${facilityCandidateList}">
                                                <tr class="candidate-row"
                                                    data-facility-no="${facility.facilityNo}"
                                                    data-facility-nm="${facility.facilityNm}"
                                                    data-facility-ty-cd="${facility.facilityTyCd}"
                                                    data-facility-ty-nm="${empty facility.facilityTyNm ? facility.facilityTyCd : facility.facilityTyNm}"
                                                    data-dong-no="${facility.dongNo}"
                                                    data-loc-cn="${facility.locCn}"
                                                    data-use-yn="${facility.useYn}">
                                                    <td>${facility.facilityNo}</td>
                                                    <td><span class="candidate-name-main">${facility.facilityNm}</span><span class="candidate-name-sub">운영관리 미등록</span></td>
                                                    <td>${empty facility.facilityTyNm ? facility.facilityTyCd : facility.facilityTyNm}</td>
                                                    <td>${empty facility.dongNo ? '공용 위치' : facility.dongNo} · ${facility.locCn}</td>
                                                    <td>${facility.useYn eq 'N' ? '<span class="badge-mini badge-use-n">비활성</span>' : '<span class="badge-mini badge-use-y">활성</span>'}</td>
                                                    <td class="cell-center"><button type="button" class="btn btn-xs btn-detail" data-action="selectCandidate">선택</button></td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- DB 연결 전 화면 확인용 예시 후보. 실제 연동 후 제거 가능 --%>
                                            <tr class="candidate-row" data-sample="Y" data-facility-no="FAC0001" data-facility-nm="실내놀이방" data-facility-ty-cd="ETC" data-facility-ty-nm="기타시설" data-dong-no="" data-loc-cn="커뮤니티센터 1층" data-use-yn="Y">
                                                <td>FAC0001</td><td><span class="candidate-name-main">실내놀이방</span><span class="candidate-name-sub">운영관리 미등록</span></td><td>기타시설</td><td>공용 위치 · 커뮤니티센터 1층</td><td><span class="badge-mini badge-use-y">활성</span></td><td class="cell-center"><button type="button" class="btn btn-xs btn-detail" data-action="selectCandidate">선택</button></td>
                                            </tr>
                                            <tr class="candidate-row" data-sample="Y" data-facility-no="FAC0002" data-facility-nm="독서실" data-facility-ty-cd="ETC" data-facility-ty-nm="기타시설" data-dong-no="DONG_101" data-loc-cn="1층 주민공동시설" data-use-yn="Y">
                                                <td>FAC0002</td><td><span class="candidate-name-main">독서실</span><span class="candidate-name-sub">운영관리 미등록</span></td><td>기타시설</td><td>DONG_101 · 1층 주민공동시설</td><td><span class="badge-mini badge-use-y">활성</span></td><td class="cell-center"><button type="button" class="btn btn-xs btn-detail" data-action="selectCandidate">선택</button></td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                    <tr class="candidate-empty-row" id="candidateEmptyRow" style="display:none;"><td colspan="6">검색 조건에 맞는 운영관리 미등록 시설자산이 없습니다.</td></tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/common-image-viewer.js"></script>


<script>
    (function () {
        var config = window.publicFacilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo  = config.mgmtOfcNo  || "";
        var preselectFacilityNo = config.preselectFacilityNo || "";

        /* 공통 DOM 조회 함수 */
        function getEl(id) { return document.getElementById(id); }

        /* 목록 주소 생성 함수 */
        function listUrl() { return contextPath + "/manager/publicFacility/list/" + encodeURIComponent(mgmtOfcNo); }

        /* 알림 출력 함수 */
        function alertMessage(msg) { if (typeof showAlert === "function") showAlert(msg); else alert(msg); }

        /* CSRF 헤더 생성 함수 */
        function getCsrfHeaders() {
            var tokenMeta  = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
            return headers;
        }

        /* JSON 요청 공통 함수 */
        async function requestJson(url, options) {
            var response = await fetch(url, options || {});
            var contentType = response.headers.get("content-type") || "";
            if (response.redirected || response.url.indexOf("/login.do") !== -1) {
                alertMessage("로그인이 필요합니다. 다시 로그인해주세요.");
                location.href = contextPath + "/login.do";
                throw new Error("login required");
            }
            if (contentType.indexOf("application/json") === -1) {
                throw new Error("JSON 응답이 아닙니다.");
            }
            var data = await response.json();
            if (!response.ok || data.success === false) throw new Error(data.message || "요청 처리 중 오류가 발생했습니다.");
            return data;
        }

        /* FormData POST 함수 */
        function postForm(url, formData) {
            return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData });
        }

        /* 등록 방식 변경 함수 */
        function setRegisterMode(mode) {
            var isNewMode = mode === "NEW";
            getEl("registerMode").value = mode;

            document.querySelectorAll(".mode-tab").forEach(function (tab) {
                var active = tab.dataset.mode === mode;
                tab.classList.toggle("is-active", active);
                tab.setAttribute("aria-selected", active ? "true" : "false");
            });

            document.querySelectorAll(".mode-panel").forEach(function (panel) {
                panel.classList.toggle("is-active", panel.dataset.modePanel === mode);
            });

            /* 새 시설자산 등록 모드에서만 신규 시설 입력값 전송 */
            ["regFacilityNm", "regFacilityTyCd", "regLocationType", "regDongNo", "regLocCn", "regUseYn"].forEach(function (id) {
                var el = getEl(id);
                if (el) el.disabled = !isNewMode;
            });

            /* 기존 시설자산 모드에서만 선택 facilityNo 전송 */
            getEl("selectedFacilityNo").disabled = isNewMode;
            getEl("regFacilityNm").required = isNewMode;

            /* 위치 구분 표시 갱신 */
            updateLocationType();
        }

        /* 새 시설자산 위치 구분 변경 함수 */
        function updateLocationType() {
            var isDongLocation = getEl("regLocationType").value === "DONG";
            var isNewMode = getEl("registerMode").value === "NEW";
            var dongEl = getEl("regDongNo");

            /* 공용 위치 선택 시 동 값 제거 */
            if (!isDongLocation) {
                dongEl.value = "";
            }

            /* 새 시설자산 모드 + 동 기준 위치일 때만 동 선택 가능 */
            dongEl.disabled = !(isNewMode && isDongLocation);
        }

        /* 시설자산 선택 모달 열기 함수 */
        function openFacilityModal() {
            getEl("facilitySelectModal").classList.add("is-open");
            getEl("facilitySelectModal").setAttribute("aria-hidden", "false");
            document.body.style.overflow = "hidden";
            updateCandidateCount();
        }

        /* 시설자산 선택 모달 닫기 함수 */
        function closeFacilityModal() {
            var modal = getEl("facilitySelectModal");
            var activeEl = document.activeElement;

            /*
             * 모달 내부 포커스 제거
             * - 선택/닫기 버튼이 focus 상태인 채 aria-hidden=true가 되면 브라우저 접근성 경고 발생
             * - 모달을 숨기기 전에 현재 포커스를 먼저 해제
             */
            if (activeEl && modal.contains(activeEl)) {
                activeEl.blur();
            }

            /*
             * 모달 닫힘 처리
             * - 화면 표시 클래스 제거
             * - 접근성 숨김 상태 반영
             * - body 스크롤 잠금 해제
             */
            modal.classList.remove("is-open");
            modal.setAttribute("aria-hidden", "true");
            document.body.style.overflow = "";

            /*
             * 포커스 복귀 처리
             * - 선택 요약이 보이면 다시 선택 버튼으로 이동
             * - 선택 전 상태이면 최초 시설자산 선택 버튼으로 이동
             */
            var returnBtn = getEl("changeFacilityBtn") || getEl("openFacilityModalBtn");
            if (returnBtn && returnBtn.offsetParent !== null) {
                returnBtn.focus();
            }
        }

        /* 시설자산 선택값 반영 함수 */
        function selectFacility(row) {
            if (!row) return;

            var facilityNo = row.dataset.facilityNo || "";
            var facilityNm = row.dataset.facilityNm || "";
            var facilityTyNm = row.dataset.facilityTyNm || row.dataset.facilityTyCd || "-";
            var dongNo = row.dataset.dongNo || "";
            var locCn = row.dataset.locCn || "";
            var useYn = row.dataset.useYn || "Y";
            var locationText = (dongNo ? dongNo : "공용 위치") + (locCn ? " · " + locCn : "");

            getEl("selectedFacilityNo").value = facilityNo;
            getEl("selectedFacilityNmText").innerText = facilityNm || "-";
            getEl("selectedFacilityNoText").innerText = facilityNo || "-";
            getEl("selectedFacilityTyText").innerText = facilityTyNm;
            getEl("selectedLocationText").innerText = locationText || "-";
            getEl("selectedUseYnText").innerText = useYn === "N" ? "비활성" : "활성";

            getEl("selectedEmptyBox").style.display = "none";
            getEl("selectedSummaryBox").classList.add("is-active");
            document.querySelector(".selected-facility-box").classList.add("is-selected");

            /* 기존 사진 로드 */
            loadExistingFiles(facilityNo);
            closeFacilityModal();
        }


        /* 사전 선택 시설자산 자동 반영 함수 */
        function applyPreselectedFacility(facilityNo) {
            if (!facilityNo) return;

            /*
             * 후보 목록에서 facilityNo가 같은 row 탐색
             * - 운영등록 버튼으로 넘어온 facilityNo가 후보 목록에 있으면 기존 selectFacility 흐름 그대로 사용
             * - 시설명, 시설유형, 위치, 사용여부까지 data-* 값으로 자동 반영
             */
            var candidateRows = Array.from(document.querySelectorAll("#facilityCandidateBody .candidate-row"));
            var row = candidateRows.find(function (candidateRow) {
                return candidateRow.dataset.facilityNo === facilityNo;
            });

            if (row) {
                selectFacility(row);
                return;
            }

            /*
             * 후보 row를 못 찾은 경우 최소 표시 처리
             * - 후보 목록에 없는 상태에서도 화면이 완전히 비어 보이지 않게 facilityNo만 표시
             * - 상세 API 응답 구조가 확정되면 여기에서 시설유형/위치/사용여부까지 추가 세팅 가능
             */
            getEl("selectedFacilityNo").value = facilityNo;
            getEl("selectedFacilityNoText").innerText = facilityNo;
            getEl("selectedFacilityNmText").innerText = "선택된 시설자산";
            getEl("selectedFacilityTyText").innerText = "-";
            getEl("selectedLocationText").innerText = "-";
            getEl("selectedUseYnText").innerText = "-";
            getEl("selectedEmptyBox").style.display = "none";
            getEl("selectedSummaryBox").classList.add("is-active");
            document.querySelector(".selected-facility-box").classList.add("is-selected");

            /* 기존 사진 로드 */
            loadExistingFiles(facilityNo);
        }

        /* 사전 선택 시설자산 변경 제한 함수 */
        function lockFacilitySelection() {
            var changeBtn = getEl("changeFacilityBtn");

            /*
             * 시설자산 목록에서 운영등록으로 진입한 경우
             * - 이미 선택된 시설자산 기준으로 PUBLIC_FACILITY를 등록하는 흐름
             * - 다른 시설자산으로 다시 선택하지 못하도록 버튼 비활성화
             */
            if (changeBtn) {
                changeBtn.disabled = true;
                changeBtn.innerText = "시설자산 고정";
                changeBtn.title = "시설자산 목록에서 선택되어 들어온 시설은 변경할 수 없습니다.";
            }
        }

        /* 기존 사진 이미지 URL 반환 함수 */
        function getFileImageUrl(file) {
            if (file.viewUrl) return file.viewUrl;
            if (file.fileUrl) return file.fileUrl;
            if (file.googleId) return contextPath + "/file/display/" + encodeURIComponent(file.googleId);
            return "";
        }

        /* 기존 사진 로드 함수 */
        async function loadExistingFiles(facilityNo) {
            var area = getEl("regFileManageList");
            area.style.display = "";
            area.innerHTML = '<div class="file-preview-empty">기존 사진을 불러오는 중입니다.</div>';
            getEl("deleteFileUuids").value = "";

            try {
                var result = await requestJson(contextPath + "/manager/facility/detail/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(facilityNo));
                var fileList = result.fileList || result.attachFileList || (result.facility && result.facility.fileList) || [];
                renderExistingFiles(fileList);
            } catch (err) {
                area.innerHTML = '<div class="file-preview-empty">기존 사진을 불러오지 못했습니다.</div>';
            }
        }

        /* 기존 사진 렌더링 함수 */
        function renderExistingFiles(files) {
            var area = getEl("regFileManageList");
            if (!files || files.length === 0) {
                area.innerHTML = '<div class="file-preview-empty">기존 등록 사진이 없습니다.</div>';
                return;
            }
            area.innerHTML = files.map(function (file) {
                var imgUrl = getFileImageUrl(file);
                var name = file.fileOgName || file.fileSaveUuid || "시설사진";
                var uuid = file.fileSaveUuid || "";
                var thumbHtml = imgUrl
                    ? '<img class="file-thumb js-image-preview" src="' + imgUrl + '" alt="' + name + '">'
                    : '<div class="file-thumb"></div>';
                return '<div class="file-manage-row">'
                    + thumbHtml
                    + '<div class="file-info"><div class="file-name">' + name + '</div><div class="file-meta">' + (file.fileExt || "image") + '</div></div>'
                    + '<label class="file-delete-check"><input type="checkbox" class="js-delete-file-check" value="' + uuid + '">삭제</label>'
                    + '</div>';
            }).join("");
        }

        /* 삭제 UUID 갱신 함수 */
        function updateDeleteFileUuids() {
            var checked = Array.from(document.querySelectorAll(".js-delete-file-check:checked"))
                .map(function (box) { return box.value; })
                .filter(Boolean);
            getEl("deleteFileUuids").value = checked.join(",");
        }

        /* 후보 목록 검색 함수 */
        function filterCandidateList() {
            var keyword = (getEl("facilityKeyword").value || "").toLowerCase().trim();
            var facilityTyCd = getEl("facilityTypeFilter").value || "";
            var dongNo = getEl("facilityDongFilter").value || "";

            document.querySelectorAll("#facilityCandidateBody .candidate-row").forEach(function (row) {
                var text = (row.innerText || "").toLowerCase();
                var matchKeyword = !keyword || text.indexOf(keyword) > -1;
                var matchType = !facilityTyCd || row.dataset.facilityTyCd === facilityTyCd;
                var matchDong = !dongNo || row.dataset.dongNo === dongNo;
                row.classList.toggle("candidate-hidden", !(matchKeyword && matchType && matchDong));
            });

            updateCandidateCount();
        }

        /* 후보 목록 카운트 갱신 함수 */
        function updateCandidateCount() {
            var visibleCount = 0;
            document.querySelectorAll("#facilityCandidateBody .candidate-row").forEach(function (row) {
                if (!row.classList.contains("candidate-hidden")) visibleCount++;
            });
            getEl("candidateVisibleCount").innerHTML = "검색 결과 <strong>" + visibleCount + "</strong>건";
            getEl("candidateEmptyRow").style.display = visibleCount === 0 ? "table-row" : "none";
        }

        /* 후보 검색 초기화 함수 */
        function resetCandidateFilter() {
            getEl("facilityKeyword").value = "";
            getEl("facilityTypeFilter").value = "";
            getEl("facilityDongFilter").value = "";
            filterCandidateList();
        }

        /* 사진 미리보기 렌더링 함수 */
        function previewSelectedFiles() {
            var fileInput = getEl("regImgInput");
            var previewArea = getEl("regImgGrid");
            previewArea.innerHTML = "";

            if (!fileInput.files || fileInput.files.length === 0) {
                previewArea.innerHTML = '<div class="file-preview-empty">선택된 사진이 없습니다.</div>';
                return;
            }

            Array.from(fileInput.files).forEach(function (file) {
                var item = document.createElement("div");
                item.className = "file-preview-item";

                if (file.type && file.type.indexOf("image/") === 0) {
                    var img = document.createElement("img");
                    img.alt = file.name;
                    img.src = URL.createObjectURL(file);
                    if (window.CommonImageViewer) {
                        img.addEventListener("click", function () { CommonImageViewer.openUrl(this.src); });
                    }
                    item.appendChild(img);
                }

                var name = document.createElement("div");
                name.className = "file-preview-name";
                name.textContent = file.name;
                item.appendChild(name);
                previewArea.appendChild(item);
            });
        }

        /* 등록 저장 처리 함수 */
        function saveRegister(event) {
            event.preventDefault();

            var mode = getEl("registerMode").value;
            var selectedFacilityNo = getEl("selectedFacilityNo").value;

            if (mode === "EXISTING" && !selectedFacilityNo) {
                alertMessage("기존 시설자산을 선택하세요.");
                return;
            }
            if (mode === "NEW" && !getEl("regFacilityNm").value.trim()) {
                alertMessage("시설명을 입력하세요.");
                return;
            }
            if (mode === "NEW" && getEl("regLocationType").value === "DONG" && !getEl("regDongNo").value) {
                alertMessage("동 기준 위치를 선택한 경우 동을 선택하세요.");
                return;
            }
            if (!getEl("regCmnNm").value.trim()) {
                alertMessage("편의시설(공용)명을 입력하세요.");
                return;
            }

            updateDeleteFileUuids();
            event.target.submit();
            return;

            try {
                postForm(contextPath + "/manager/publicFacility/insert/" + encodeURIComponent(mgmtOfcNo), new FormData(getEl("registerForm")));
                alertMessage("편의시설(공용)이 등록되었습니다.");
                location.href = listUrl();
            } catch (err) {
                console.error(err);
                alertMessage(err.message || "편의시설(공용) 등록 중 오류가 발생했습니다.");
            }
        }

        /* 초기 이벤트 연결 */
        document.addEventListener("DOMContentLoaded", function () {
            /* 등록 방식 탭 클릭 이벤트 */
            document.querySelectorAll(".mode-tab").forEach(function (tab) {
                tab.addEventListener("click", function () {
                    setRegisterMode(tab.dataset.mode || "EXISTING");
                });
            });

            /* 시설자산 선택 모달 이벤트 */
            getEl("openFacilityModalBtn").addEventListener("click", openFacilityModal);
            getEl("changeFacilityBtn").addEventListener("click", openFacilityModal);
            getEl("closeFacilityModalBtn").addEventListener("click", closeFacilityModal);
            getEl("facilitySelectModal").addEventListener("click", function (event) {
                if (event.target === getEl("facilitySelectModal")) closeFacilityModal();
            });

            /* 후보 선택 이벤트 */
            getEl("facilityCandidateBody").addEventListener("click", function (event) {
                var selectBtn = event.target.closest('[data-action="selectCandidate"]');
                var row = event.target.closest(".candidate-row");
                if (selectBtn && row) selectFacility(row);
            });

            /* 후보 검색 이벤트 */
            getEl("facilityKeyword").addEventListener("keyup", filterCandidateList);
            getEl("facilityTypeFilter").addEventListener("change", filterCandidateList);
            getEl("facilityDongFilter").addEventListener("change", filterCandidateList);
            getEl("facilityResetBtn").addEventListener("click", resetCandidateFilter);

            /* 새 시설자산 위치 구분 이벤트 */
            getEl("regLocationType").addEventListener("change", updateLocationType);

            /* 사진 파일 선택 이벤트 */
            getEl("regImgInput").addEventListener("change", previewSelectedFiles);

            /* 기존 사진 삭제 체크 이벤트 */
            document.addEventListener("change", function (e) {
                if (e.target.classList.contains("js-delete-file-check")) updateDeleteFileUuids();
            });

            /* 저장/취소 이벤트 */
            getEl("registerForm").addEventListener("submit", saveRegister);
            getEl("backToListBtn").addEventListener("click", function () { history.back(); });

            /* ESC 키로 시설자산 선택 모달 닫기 */
            document.addEventListener("keydown", function (event) {
                if (event.key === "Escape") closeFacilityModal();
            });

            /* 기본 등록 방식 및 카운트 세팅 */
            setRegisterMode("EXISTING");
            updateCandidateCount();

            /* 공통 이미지 확대 모듈 연결 */
            if (window.CommonImageViewer) {
                CommonImageViewer.bind("#regFileManageList");
            }

            /* facilityNo 파라미터가 넘어온 경우 후보 목록 기준 자동 선택 */
            if (preselectFacilityNo) {
                applyPreselectedFacility(preselectFacilityNo);

                /*
                 * 시설자산 목록에서 운영등록으로 진입한 경우
                 * - 선택된 시설자산을 변경하지 못하도록 다시 선택 버튼 잠금
                 */
                lockFacilitySelection();
            }
        });
    })();
</script>
</body>
</html>
