<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설 수정</title>
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
        #publicFacilityPage .photo-guide { align-items:flex-start; padding:12px; }
        #publicFacilityPage .photo-guide-title { margin-bottom:9px; font-size:12px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .photo-guide-row { display:flex; align-items:center; justify-content:space-between; gap:10px; padding:8px 0; border-top:1px solid rgba(46,92,56,.13); }
        #publicFacilityPage .photo-guide-row span { flex:0 0 auto; font-size:11px; color:var(--text-sec); font-weight:700; }
        #publicFacilityPage .photo-guide-row strong { min-width:0; text-align:right; font-size:11px; color:var(--text-pri); font-weight:800; line-height:1.35; }
        /* 운영시간 입력 */
        #publicFacilityPage .opr-time-box { display:flex; flex-direction:column; gap:8px; padding:10px; border:1px solid var(--line); border-radius:4px; background:#fafcfb; }
        #publicFacilityPage .opr-time-row { display:grid; grid-template-columns:64px minmax(120px,1fr) 64px minmax(112px,1fr) 16px minmax(112px,1fr); gap:7px; align-items:center; }
        #publicFacilityPage .opr-custom-day-row { display:none; grid-template-columns:64px minmax(112px,1fr) 16px minmax(112px,1fr); gap:7px; align-items:center; }
        #publicFacilityPage .opr-custom-day-row.is-active { display:grid; }
        #publicFacilityPage .opr-time-label { font-size:11px; font-weight:800; color:var(--text-sec); white-space:nowrap; }
        #publicFacilityPage .opr-time-separator { text-align:center; font-size:12px; font-weight:800; color:var(--text-ter); }
        #publicFacilityPage .opr-preview-row { display:grid; grid-template-columns:64px 1fr; gap:7px; align-items:center; }
        #publicFacilityPage .opr-preview { min-height:30px; padding:6px 9px; display:flex; align-items:center; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; font-weight:700; color:var(--text-pri); }
        #publicFacilityPage .opr-preview.is-empty { color:var(--text-ter); font-weight:500; }
        #publicFacilityPage .opr-time-notice { min-height:17px; padding-left:71px; font-size:11px; line-height:1.5; color:#b45309; }
        #publicFacilityPage .opr-time-notice:empty { display:none; }


        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
            #publicFacilityPage .selected-grid { grid-template-columns:1fr; }
        }
    </style>

    <script>
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
        };
    </script>
</head>
<body>
<c:set var="activeSidebarHref" value="${pageContext.request.contextPath}/manager/publicFacility/page/${mgmtOfcNo}" />
<c:set var="activeSidebarParent" value="시설·공사 관리" />
<c:set var="activeSidebarCurrent" value="편의시설 관리" />
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <%@ include file="/WEB-INF/views/include/office_active_sidebar.jspf" %>
        <main class="main-content">
            <div class="office-page" id="publicFacilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설 수정</h2>
                        <p>편의시설 운영정보를 수정합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>편의시설(공용) 정보 입력</h3>
                    </div>

                    <form id="registerForm" method="post" action="${pageContext.request.contextPath}/manager/publicFacility/update/${mgmtOfcNo}" enctype="multipart/form-data">
                        <sec:csrfInput/>
                        <input type="hidden" id="registerMode" name="registerMode" value="EXISTING">
                        <input type="hidden" id="cmnFacilityNo" name="cmnFacilityNo" value="${detail.cmnFacilityNo}">
                        <input type="hidden" id="selectedFacilityNo" name="facilityNo" value="${detail.facilityNo}">
                        <input type="hidden" id="deleteFileUuids" name="deleteFileUuids">

                        <div class="panel-body">
                            <div class="facility-modal-cols">
                                <div class="facility-modal-col-left">
                                    <div class="facility-col-label">시설 정보</div>


                                    <%-- 기존 시설자산 선택 탭: 선택 요약만 표시하고 목록은 모달에서 검색 --%>
                                    <div class="mode-panel is-active" id="existingFacilityPanel" data-mode-panel="EXISTING">
                                        <div class="form-section" style="margin-bottom:14px;">

                                            <div class="selected-facility-box">
                                                <div class="selected-empty" id="selectedEmptyBox" style="display:none;">
                                                    <span class="material-symbols-rounded">domain_add</span>
                                                    <div>운영관리 정보를 입력할 시설자산을 선택하세요.</div>
                                                    <button type="button" class="btn btn-secondary" id="openFacilityModalBtn">시설자산 선택</button>
                                                </div>

                                                <div class="selected-summary is-active" id="selectedSummaryBox">
                                                    <div class="selected-head">
                                                        <div>
                                                            <div class="selected-name" id="selectedFacilityNmText">${empty detail.facilityNm ? '-' : detail.facilityNm}</div>
                                                            <div class="selected-code" id="selectedFacilityNoText">${empty detail.facilityNo ? '-' : detail.facilityNo}</div>
                                                        </div>
                                                        <button type="button" class="btn btn-secondary" id="changeFacilityBtn" disabled>시설자산 고정</button>
                                                    </div>
                                                    <div class="selected-grid">
                                                        <div class="selected-item"><span class="selected-label">시설유형</span><span class="selected-value" id="selectedFacilityTyText">${empty detail.facilityTyNm ? detail.facilityTyCd : detail.facilityTyNm}</span></div>
                                                        <div class="selected-item"><span class="selected-label">위치</span><span class="selected-value" id="selectedLocationText">${empty detail.locCn ? '-' : detail.locCn}</span></div>
                                                        <div class="selected-item"><span class="selected-label">사용여부</span><span class="selected-value" id="selectedUseYnText">${detail.useYn eq 'N' ? '비활성' : '활성'}</span></div>
                                                        <div class="selected-item"><span class="selected-label">사진 저장 기준</span><span class="selected-value">시설자산 사진</span></div>
                                                    </div>
                                                    <div class="field-help">운영관리 등록 후 시설자산 연결은 변경하지 않습니다.</div>
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
                                                <input type="text" class="form-input" id="regCmnNm" name="cmnFacilityNm" value="${detail.cmnFacilityNm}" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="regRsvYn" name="cmnFacilityRsvYn">
                                                    <option value="Y" ${detail.cmnFacilityRsvYn eq 'Y' ? 'selected' : ''}>예약 가능</option>
                                                    <option value="N" ${detail.cmnFacilityRsvYn eq 'N' ? 'selected' : ''}>예약 불가</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="regAmt" name="cmnFacilityAmt" value="${detail.cmnFacilityAmt}" placeholder="0 (무료)" min="0">
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">운영요일/운영시간</label>
                                                <div class="opr-time-box">
                                                    <%-- 운영조건 선택 행 --%>
                                                    <div class="opr-time-row">
                                                        <span class="opr-time-label">운영요일</span>
                                                        <select class="form-select" id="oprDayType">
                                                            <option value="DAILY" selected>매일</option>
                                                            <option value="WEEKDAY">평일</option>
                                                            <option value="WEEKEND">주말</option>
                                                            <option value="CUSTOM">직접 지정</option>
                                                        </select>
                                                        <span class="opr-time-label">운영시간</span>
                                                        <input type="time" class="form-input" id="oprStartTime" step="60">
                                                        <span class="opr-time-separator">~</span>
                                                        <input type="time" class="form-input" id="oprEndTime" step="60">
                                                    </div>

                                                    <%-- 직접 지정 요일 행: 운영요일이 직접 지정일 때만 표시 --%>
                                                    <div class="opr-custom-day-row" id="oprCustomDayRow">
                                                        <span class="opr-time-label">요일범위</span>
                                                        <select class="form-select" id="oprStartDay">
                                                            <option value="월" selected>월요일</option>
                                                            <option value="화">화요일</option>
                                                            <option value="수">수요일</option>
                                                            <option value="목">목요일</option>
                                                            <option value="금">금요일</option>
                                                            <option value="토">토요일</option>
                                                            <option value="일">일요일</option>
                                                        </select>
                                                        <span class="opr-time-separator">~</span>
                                                        <select class="form-select" id="oprEndDay">
                                                            <option value="월">월요일</option>
                                                            <option value="화">화요일</option>
                                                            <option value="수">수요일</option>
                                                            <option value="목">목요일</option>
                                                            <option value="금" selected>금요일</option>
                                                            <option value="토">토요일</option>
                                                            <option value="일">일요일</option>
                                                        </select>
                                                    </div>

                                                    <%-- 자동 저장값 표시 행 --%>
                                                    <div class="opr-preview-row">
                                                        <span class="opr-time-label">저장값</span>
                                                        <div class="opr-preview is-empty" id="oprHrPreview">운영시간을 입력하면 자동으로 저장값이 생성됩니다.</div>
                                                    </div>
                                                    <div class="opr-time-notice" id="oprTimeNotice"></div>

                                                    <%-- DB 전송용 운영시간 값 --%>
                                                    <input type="hidden" id="regOprHr" name="cmnFacilityOprHr" value="${detail.cmnFacilityOprHr}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="regCn" name="cmnFacilityCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요.">${detail.cmnFacilityCn}</textarea>
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

                                    <%-- 자원 아이템 목록 --%>
                                    <c:if test="${not empty detail.cmnFacilityNo}">
                                        <div class="form-section" style="margin-top:14px;">
                                            <div class="form-section-title" style="justify-content:space-between;">
                                            <span style="display:flex;align-items:center;gap:4px;">
                                                <span class="material-symbols-rounded">inventory_2</span>편의시설 자원
                                            </span>
                                                <button type="button" class="btn btn-secondary btn-sm" id="itemInsertBtn" style="height:26px;padding:0 10px;font-size:11px;">
                                                    <span class="material-symbols-rounded" style="font-size:13px;vertical-align:middle;">add</span> 자원 등록
                                                </button>
                                            </div>
                                            <div style="border:1px solid var(--line);border-radius:4px;overflow:hidden;">
                                                <table style="width:100%;border-collapse:collapse;table-layout:fixed;font-size:12px;">
                                                    <colgroup>
                                                        <col style="width:30%;">
                                                        <col style="width:38%;">
                                                        <col style="width:18%;">
                                                        <col style="width:14%;">
                                                    </colgroup>
                                                    <thead>
                                                    <tr>
                                                        <th style="height:32px;padding:0 10px;background:var(--th-bg);color:var(--text-sec);font-size:11px;font-weight:800;text-align:left;border-bottom:1px solid var(--line);">자원번호</th>
                                                        <th style="height:32px;padding:0 10px;background:var(--th-bg);color:var(--text-sec);font-size:11px;font-weight:800;text-align:left;border-bottom:1px solid var(--line);">자원명</th>
                                                        <th style="height:32px;padding:0 10px;background:var(--th-bg);color:var(--text-sec);font-size:11px;font-weight:800;text-align:center;border-bottom:1px solid var(--line);">상태</th>
                                                        <th style="height:32px;padding:0 10px;background:var(--th-bg);color:var(--text-sec);font-size:11px;font-weight:800;text-align:center;border-bottom:1px solid var(--line);">수정</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="itemListBody">
                                                    <tr><td colspan="4" style="padding:18px;text-align:center;font-size:12px;color:var(--text-ter);">자원 목록을 불러오는 중...</td></tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                            <button type="button" class="btn btn-secondary" id="backToListBtn">취소</button>
                            <button type="submit" class="btn btn-primary">저장</button>
                        </div>
                    </form>
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

        /* 공통 DOM 조회 함수 */
        function getEl(id) { return document.getElementById(id); }

        /* 목록 주소 생성 함수 */
        function listUrl() { return contextPath + "/manager/publicFacility/page/" + encodeURIComponent(mgmtOfcNo); }

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

        function getJson(url) {
            return requestJson(url, { method:"GET", headers:getCsrfHeaders() });
        }


        /* 새 시설자산 위치 구분 변경 함수 */

        /* 운영요일 표시문구 생성 함수 */
        function buildOperationDayText() {
            var dayType = getEl("oprDayType").value; // 운영요일 구분값
            var startDay = getEl("oprStartDay").value; // 직접지정 시작요일
            var endDay = getEl("oprEndDay").value; // 직접지정 종료요일

            if (dayType === "DAILY") return "매일"; // 매일 운영
            if (dayType === "WEEKDAY") return "평일"; // 평일 운영
            if (dayType === "WEEKEND") return "주말"; // 주말 운영

            if (!startDay || !endDay) return ""; // 직접지정 값 없음
            if (startDay === startDay && startDay === endDay) return startDay; // 단일 요일 운영
            return startDay + "~" + endDay; // 요일 범위 운영
        }

        /* 운영요일 직접지정 표시 함수 */
        function updateOperationDayTypeView() {
            var customDayRow = getEl("oprCustomDayRow"); // 직접지정 요일 행
            if (!customDayRow) return; // 요소 없음 방어
            customDayRow.classList.toggle("is-active", getEl("oprDayType").value === "CUSTOM"); // 직접지정 표시 여부
        }

        /* 운영시간 저장값 자동 생성 함수 */
        function updateOperationHourText() {
            updateOperationDayTypeView(); // 직접지정 행 표시 갱신
            var startTime = getEl("oprStartTime").value;
            var endTime = getEl("oprEndTime").value;
            var hiddenInput = getEl("regOprHr");
            var preview = getEl("oprHrPreview");
            var notice = getEl("oprTimeNotice");

            /* 시간 미입력 상태 */
            if (!startTime && !endTime) {
                hiddenInput.value = "";
                preview.innerText = "운영시간을 입력하면 자동으로 저장값이 생성됩니다.";
                preview.classList.add("is-empty");
                notice.innerText = "";
                return;
            }

            /* 부분 입력 상태 */
            if (!startTime || !endTime) {
                hiddenInput.value = "";
                preview.innerText = "시작시간과 종료시간을 모두 입력해야 저장됩니다.";
                preview.classList.add("is-empty");
                notice.innerText = "";
                return;
            }

            var dayText = buildOperationDayText(); // 운영요일 표시문구
            var operationText = dayText + " " + startTime + "~" + endTime; // DB 저장용 운영시간 문구

            hiddenInput.value = operationText;
            preview.innerText = operationText;
            preview.classList.remove("is-empty");

            /* 야간 운영 안내 */
            if (startTime > endTime) {
                notice.innerText = "종료시간이 시작시간보다 빠르므로 다음날 종료되는 야간 운영으로 저장됩니다.";
                return;
            }

            /* 24시간 또는 별도 기준 안내 */
            if (startTime === endTime) {
                notice.innerText = "시작시간과 종료시간이 같아 24시간 운영 또는 별도 운영 기준으로 저장됩니다.";
                return;
            }

            notice.innerText = "";
        }

        /* 운영시간 입력 검증 함수 */
        function validateOperationHourInput() {
            var startTime = getEl("oprStartTime").value;
            var endTime = getEl("oprEndTime").value;

            /* 둘 다 비어 있으면 운영시간 미입력으로 허용 */
            if (!startTime && !endTime) return true;

            /* 하나만 입력된 경우 저장 방지 */
            if (!startTime || !endTime) {
                alertMessage("운영시간은 시작시간과 종료시간을 모두 입력하세요.");
                return false;
            }

            return true;
        }

        function setSelectValueByValueOrText(select, value) {
            if (!select || !value) return;
            select.value = value;
            if (select.value === value) return;
            Array.from(select.options).some(function (option) {
                if (option.value === value || option.textContent.indexOf(value) > -1) {
                    option.selected = true;
                    return true;
                }
                return false;
            });
        }

        function applyExistingOperationHour() {
            var raw = (getEl("regOprHr").value || "").trim();
            var preview = getEl("oprHrPreview");
            if (!raw) {
                updateOperationHourText();
                return;
            }

            //** stored operation text form restoration
            var match = raw.match(/^(.*?)\s+(\d{2}:\d{2})\s*~\s*(\d{2}:\d{2})$/);
            if (!match) {
                preview.innerText = raw;
                preview.classList.remove("is-empty");
                return;
            }

            var dayText = match[1].trim();
            getEl("oprStartTime").value = match[2];
            getEl("oprEndTime").value = match[3];

            if (dayText === "매일") {
                getEl("oprDayType").value = "DAILY";
            } else if (dayText === "평일") {
                getEl("oprDayType").value = "WEEKDAY";
            } else if (dayText === "주말") {
                getEl("oprDayType").value = "WEEKEND";
            } else {
                getEl("oprDayType").value = "CUSTOM";
                var dayParts = dayText.split("~");
                setSelectValueByValueOrText(getEl("oprStartDay"), dayParts[0]);
                setSelectValueByValueOrText(getEl("oprEndDay"), dayParts[1] || dayParts[0]);
            }

            updateOperationHourText();
        }

        /* 시설자산 선택값 반영 함수 */
        /* 사전 선택 시설자산 자동 반영 함수 */
        /* 사전 선택 시설자산 변경 제한 함수 */
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
        async function saveRegister(event) {
            event.preventDefault();

            var selectedFacilityNo = getEl("selectedFacilityNo").value;

            if (!selectedFacilityNo) {
                alertMessage("시설자산이 선택되지 않았습니다.");
                return;
            }

            /* 운영시간 최종 저장값 생성 */
            updateOperationHourText();

            /* 운영시간 부분 입력 검증 */
            if (!validateOperationHourInput()) {
                return;
            }

            updateDeleteFileUuids();

            try {
                //** 기본 form submit 우회와 저장 결과 확인 흐름
                await postForm(contextPath + "/manager/publicFacility/update/" + encodeURIComponent(mgmtOfcNo), new FormData(getEl("registerForm")));
                alertMessage("편의시설 운영정보가 저장되었습니다.");
                location.href = listUrl();
            } catch (err) {
                console.error(err);
                alertMessage(err.message || "편의시설 운영정보 저장 중 오류가 발생했습니다.");
            }
        }

        /* 초기 이벤트 연결 */
        document.addEventListener("DOMContentLoaded", function () {

            /* 운영요일/운영시간 자동 조합 이벤트 */
            ["oprDayType", "oprStartDay", "oprEndDay", "oprStartTime", "oprEndTime"].forEach(function (id) {
                getEl(id).addEventListener("change", updateOperationHourText);
                getEl(id).addEventListener("input", updateOperationHourText);
            });

            /* 사진 파일 선택 이벤트 */
            getEl("regImgInput").addEventListener("change", previewSelectedFiles);

            /* 기존 사진 삭제 체크 이벤트 */
            document.addEventListener("change", function (e) {
                if (e.target.classList.contains("js-delete-file-check")) updateDeleteFileUuids();
            });

            /* 저장/취소 이벤트 */
            getEl("registerForm").addEventListener("submit", saveRegister);
            getEl("backToListBtn").addEventListener("click", function () { history.back(); });


            applyExistingOperationHour();

            /* 공통 이미지 확대 모듈 연결 */
            if (window.CommonImageViewer) {
                CommonImageViewer.bind("#regFileManageList");
            }

            //** 운영관리 수정 진입 시설의 기존 사진 즉시 표시
            if (getEl("selectedFacilityNo").value) {
                loadExistingFiles(getEl("selectedFacilityNo").value);
            }

        });
    })();
</script>

<c:if test="${not empty detail.cmnFacilityNo}">
    <script>
        (function () {
            var config        = window.publicFacilityPageConfig || {};
            var contextPath   = config.contextPath || "";
            var mgmtOfcNo     = config.mgmtOfcNo  || "";
            var cmnFacilityNo = "${detail.cmnFacilityNo}";

            function sttsBadge(cd) {
                var map = {
                    OPEN:   ["#dceee0","#1f7a3f","사용가능"],
                    USE:    ["#dbeafe","#1e3a5f","사용중"],
                    REPAIR: ["#fef9c3","#854d0e","점검중"],
                    CLOSE:  ["#fee2e2","#b42318","사용중지"]
                };
                var s = map[cd] || ["#f3f4f6","#6b7280", cd || "-"];
                return '<span style="display:inline-flex;align-items:center;height:20px;padding:0 7px;border-radius:10px;font-size:11px;font-weight:700;background:' + s[0] + ';color:' + s[1] + ';">' + s[2] + '</span>';
            }

            function renderItemList(list) {
                var tbody = document.getElementById("itemListBody");
                if (!tbody) return;
                if (!list || list.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="4" style="padding:18px;text-align:center;font-size:12px;color:#8a9a8e;">등록된 자원이 없습니다.</td></tr>';
                    return;
                }
                tbody.innerHTML = list.map(function (item) {
                    var no  = item.cmnFacilityItemNo || "";
                    var nm  = item.itemNm || "-";
                    var cd  = item.cmnFacilitySttsCd || item.sttsCd || "";
                    return '<tr style="border-bottom:1px solid #d7dce2;">'
                        + '<td style="height:40px;padding:6px 10px;font-family:monospace;font-size:11px;color:#6b7a6e;">' + no + '</td>'
                        + '<td style="height:40px;padding:6px 10px;font-size:12px;">' + nm + '</td>'
                        + '<td style="height:40px;padding:6px 10px;text-align:center;">' + sttsBadge(cd) + '</td>'
                        + '<td style="height:40px;padding:6px 10px;text-align:center;">'
                        +   '<button type="button" style="height:26px;padding:0 9px;font-size:11px;border-radius:4px;border:1px solid #d7dce2;background:#fff;color:#4a5c4e;cursor:pointer;" class="js-item-edit-btn" data-item-no="' + no + '">수정</button>'
                        + '</td>'
                        + '</tr>';
                }).join("");
            }

            async function loadItemList() {
                try {
                    var res  = await fetch(contextPath + "/manager/publicFacility/grid-list/" + encodeURIComponent(mgmtOfcNo) + "?viewType=PUBLIC_ITEM");
                    var data = await res.json();
                    var list = (data.list || []).filter(function (item) { return item.cmnFacilityNo === cmnFacilityNo; });
                    renderItemList(list);
                } catch (e) {
                    var tbody = document.getElementById("itemListBody");
                    if (tbody) tbody.innerHTML = '<tr><td colspan="4" style="padding:18px;text-align:center;font-size:12px;color:#8a9a8e;">자원 목록을 불러오지 못했습니다.</td></tr>';
                }
            }

            function initModal() {
                if (!window.PublicFacilityItemModal || !cmnFacilityNo) return false;
                PublicFacilityItemModal.init({ contextPath: contextPath, mgmtOfcNo: mgmtOfcNo, cmnFacilityNo: cmnFacilityNo, isAdmin: false });
                return true;
            }

            document.addEventListener("DOMContentLoaded", function () {
                loadItemList();

                var insertBtn = document.getElementById("itemInsertBtn");
                if (insertBtn) {
                    insertBtn.addEventListener("click", function () {
                        if (!initModal()) return;
                        PublicFacilityItemModal.open("insert");
                        /* 시설 정보 직접 주입 - suggest API 의존 제거 */
                        var infoNm  = document.getElementById("pfInfoCmnFacilityNm");
                        var infoNo  = document.getElementById("pfInfoFacilityNo");
                        var infoCmn = document.getElementById("pfInfoCmnFacilityNo");
                        if (infoNm)  infoNm.textContent  = "${detail.cmnFacilityNm}";
                        if (infoNo)  infoNo.textContent   = "${detail.facilityNo}";
                        if (infoCmn) infoCmn.textContent  = cmnFacilityNo;
                        var searchSec = document.getElementById("pfFacilitySearchSection");
                        if (searchSec) searchSec.style.display = "none";
                        var infoSec = document.getElementById("pfFacilityInfoSection");
                        if (infoSec) infoSec.style.display = "";
                    });
                }

                var tbody = document.getElementById("itemListBody");
                if (tbody) {
                    tbody.addEventListener("click", function (e) {
                        var btn = e.target.closest(".js-item-edit-btn");
                        if (!btn) return;
                        var itemNo = btn.dataset.itemNo;
                        if (!itemNo || !initModal()) return;
                        PublicFacilityItemModal.open("update", itemNo);
                    });
                }

                document.addEventListener("pfItemSaved", loadItemList);
            });
        })();
    </script>
    <%@ include file="/WEB-INF/views/include/publicFacilityItemModal.jspf" %>
    <script src="${pageContext.request.contextPath}/js/manager/facility/publicFacility/publicFacilityItemModal.js"></script>
</c:if>

</body>
</html>
