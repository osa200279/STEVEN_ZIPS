<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>편의시설(공용) 수정</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        #publicFacilityUpdatePage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb;
            --line:#d7dce2; --th-bg:#f3f5f3; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
        }
        #publicFacilityUpdatePage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityUpdatePage .page-title-block p  { color:var(--text-sec); font-size:12px; }
        #publicFacilityUpdatePage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityUpdatePage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityUpdatePage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityUpdatePage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityUpdatePage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityUpdatePage .panel-body .form-input,
        #publicFacilityUpdatePage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #publicFacilityUpdatePage .panel-body .form-input:focus,
        #publicFacilityUpdatePage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityUpdatePage .panel-body .form-textarea { font-size:12px; border-color:var(--line); border-radius:4px; resize:vertical; }
        #publicFacilityUpdatePage .panel-body .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
        #publicFacilityUpdatePage .btn { border-radius:4px; }
        #publicFacilityUpdatePage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityUpdatePage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityUpdatePage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:var(--text-sec); line-height:1.6; }
        #publicFacilityUpdatePage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #publicFacilityUpdatePage .field-help { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.5; }
        .form-section-title { display:flex; align-items:center; gap:4px; font-size:11px; font-weight:800; color:var(--text-sec,#4a5c4e); letter-spacing:0; text-transform:none; margin-bottom:10px; }
        .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent,#2e5c38); }

        /* 2컬럼 레이아웃 */
        .facility-modal-cols { display:grid; grid-template-columns:1fr 1fr; gap:0; }
        .facility-modal-col-left { padding-right:20px; border-right:1px solid var(--line,#d7dce2); }
        .facility-modal-col-right { padding-left:20px; }
        .facility-col-label { font-size:11px; font-weight:800; color:#8a9a8e; letter-spacing:.5px; text-transform:uppercase; padding-bottom:8px; border-bottom:1px solid var(--line,#d7dce2); margin-bottom:14px; }

        /* 사진 업로드: register 화면과 동일한 파일 선택 + 미리보기 구조 */
        #publicFacilityUpdatePage .file-upload-box { border:1px dashed var(--line); border-radius:4px; padding:12px; background:#fafcfb; }
        #publicFacilityUpdatePage .file-upload-title { display:flex; align-items:center; gap:5px; font-size:12px; font-weight:800; color:var(--text-sec); }
        #publicFacilityUpdatePage .file-upload-title .material-symbols-rounded { font-size:16px; color:var(--accent); }
        #publicFacilityUpdatePage .file-upload-desc { font-size:11px; color:var(--text-ter); line-height:1.5; }
        #publicFacilityUpdatePage .file-preview-list { display:grid; grid-template-columns:repeat(4,minmax(0,1fr)); gap:8px; margin-top:10px; }
        #publicFacilityUpdatePage .file-preview-item { position:relative; min-height:92px; border:1px solid var(--line); border-radius:4px; background:#fff; overflow:hidden; }
        #publicFacilityUpdatePage .file-preview-item img { width:100%; height:92px; object-fit:cover; display:block; cursor:zoom-in; }
        #publicFacilityUpdatePage .file-preview-name { padding:6px 7px; font-size:11px; color:var(--text-sec); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; border-top:1px solid var(--line); }
        #publicFacilityUpdatePage .file-preview-empty { padding:13px; border:1px solid var(--line); border-radius:4px; background:#fff; font-size:12px; color:var(--text-ter); }
        #publicFacilityUpdatePage .file-manage-list { display:flex; flex-direction:column; gap:7px; margin-bottom:8px; }
        #publicFacilityUpdatePage .file-manage-row { display:flex; align-items:center; gap:10px; padding:8px 10px; border:1px solid var(--line); border-radius:4px; background:#fff; }
        #publicFacilityUpdatePage .file-thumb { width:48px; height:48px; border-radius:4px; border:1px solid var(--line); object-fit:cover; background:#f4f7f4; flex-shrink:0; cursor:zoom-in; }
        #publicFacilityUpdatePage .file-thumb-empty { display:flex; align-items:center; justify-content:center; color:var(--text-ter); font-size:11px; }
        #publicFacilityUpdatePage .file-info { min-width:0; flex:1; }
        #publicFacilityUpdatePage .file-name { font-size:12px; font-weight:700; color:#111827; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        #publicFacilityUpdatePage .file-meta { margin-top:2px; font-size:11px; color:var(--text-ter); }
        #publicFacilityUpdatePage .file-delete-check { display:inline-flex; align-items:center; gap:4px; font-size:11px; color:#7f1d1d; font-weight:700; }
        #publicFacilityUpdatePage .file-delete-check input { width:14px; height:14px; }
        #publicFacilityUpdatePage .item-table { width:100%; border-collapse:collapse; border-top:1px solid var(--line); margin-top:8px; }
        #publicFacilityUpdatePage .item-table th,
        #publicFacilityUpdatePage .item-table td { padding:8px 9px; border-bottom:1px solid var(--line); font-size:12px; text-align:left; }
        #publicFacilityUpdatePage .item-table th { color:var(--text-ter); font-weight:800; background:var(--surface-sub); }
        #publicFacilityUpdatePage .item-empty { text-align:center; color:var(--text-ter); padding:14px 0; }

        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
        }
    </style>
    <script>
        /* 화면 설정값 */
        window.publicFacilityUpdateConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}",
            cmnFacilityNo: "${detail.cmnFacilityNo}"
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
            <div class="office-page" id="publicFacilityUpdatePage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>편의시설(공용) 수정</h2>
                        <p>시설자산(FACILITY)과 편의시설(공용) 운영정보(PUBLIC_FACILITY)를 수정합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>편의시설(공용) 정보 수정</h3>
                    </div>

                    <%-- 수정 흐름: FACILITY UPDATE → PUBLIC_FACILITY UPDATE --%>
                    <form id="updateForm" method="post" action="${pageContext.request.contextPath}/manager/publicFacility/update/${mgmtOfcNo}" enctype="multipart/form-data">
                        <sec:csrfInput/>

                        <%-- 수정 대상 식별값 --%>
                        <input type="hidden" name="facilityNo" value="${detail.facilityNo}">
                        <input type="hidden" name="cmnFacilityNo" value="${detail.cmnFacilityNo}">
                        <input type="hidden" name="mgmtOfcNo" value="${mgmtOfcNo}">
                        <input type="hidden" name="fileGroupNo" value="${detail.fileGroupNo}">
                        <%-- 삭제할 기존 사진 UUID 목록: submit 직전에 JS에서 콤마 문자열로 세팅 --%>
                        <input type="hidden" id="deleteFileUuids" name="deleteFileUuids" value="">

                        <div class="panel-body">
                            <div class="form-section" style="margin-bottom:14px;">
                                <div class="notice-box">
                                    <span class="material-symbols-rounded">info</span>
                                    <div>편의시설(공용) 수정 시 시설자산 기본정보와 편의시설(공용) 운영정보가 함께 저장됩니다.<br>
                                        사진 삭제가 필요한 경우 우측의 기존 사진 삭제 항목을 선택한 뒤 저장하세요.</div>
                                </div>
                            </div>

                            <div class="facility-modal-cols">

                                <%-- 좌측: FACILITY 기본정보 + PUBLIC_FACILITY 운영정보 --%>
                                <div class="facility-modal-col-left">
                                    <div class="facility-col-label">시설 정보</div>

                                    <%-- FACILITY 기본정보 --%>
                                    <div class="form-section" style="margin-bottom:14px;">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">apartment</span>시설자산 정보
                                        </div>

                                        <%-- 시설명 + 동: 한 줄 --%>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="updFacilityNm" name="facilityNm" value="${detail.facilityNm}" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">동</label>
                                                <select class="form-select" id="updDongNo" name="dongNo">
                                                    <option value="">선택 안 함</option>
                                                    <c:forEach var="dong" items="${dongList}">
                                                        <option value="${dong.dongNo}" <c:if test="${detail.dongNo eq dong.dongNo}">selected</c:if>>
                                                                ${fn:contains(dong.dongNo, '_') ? fn:substringAfter(dong.dongNo, '_') : (empty dong.dongNm ? dong.dongNo : dong.dongNm)}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </div>

                                        <%-- 상세위치: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">상세위치</label>
                                                <input type="text" class="form-input" id="updLocCn" name="locCn" value="${detail.locCn}" placeholder="예) 커뮤니티센터 2층">
                                            </div>
                                        </div>
                                    </div>

                                    <%-- PUBLIC_FACILITY 운영정보 --%>
                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">meeting_room</span>편의시설(공용) 운영정보
                                        </div>

                                        <%-- 공용시설명: PUBLIC_FACILITY 운영명 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">편의시설(공용)명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="updCmnNm" name="cmnFacilityNm" value="${detail.cmnFacilityNm}" placeholder="예) 헬스장" required>
                                                <p class="field-help">운영현황은 편의시설 자원 상태 집계로 표시되므로 이 화면에서는 직접 수정하지 않습니다.</p>
                                            </div>
                                        </div>

                                        <%-- 예약여부 + 이용요금: 한 줄 --%>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="updRsvYn" name="cmnFacilityRsvYn">
                                                    <option value="Y" <c:if test="${detail.cmnFacilityRsvYn eq 'Y'}">selected</c:if>>예약 가능</option>
                                                    <option value="N" <c:if test="${detail.cmnFacilityRsvYn eq 'N'}">selected</c:if>>예약 불가</option>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="updAmt" name="cmnFacilityAmt" value="${detail.cmnFacilityAmt}" placeholder="0 (무료)" min="0">
                                            </div>
                                        </div>

                                        <%-- 운영시간: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">운영시간</label>
                                                <input type="text" class="form-input" id="updOprHr" name="cmnFacilityOprHr" value="${detail.cmnFacilityOprHr}" placeholder="예) 06:00~22:00 (평일) / 08:00~20:00 (주말)">
                                            </div>
                                        </div>

                                        <%-- 시설 안내: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="updCn" name="cmnFacilityCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요.">${detail.cmnFacilityCn}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 우측: 사진 수정 --%>
                                <div class="facility-modal-col-right">
                                    <div class="facility-col-label">시설 사진</div>

                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">image</span>시설 사진
                                            <small style="font-weight:400;color:var(--text-ter);font-size:11px;">기존 사진 확인 · 새 사진 추가</small>
                                        </div>

                                        <%-- 기존 사진 목록: 표시 URL은 googleId, 삭제 값은 fileSaveUuid 사용 --%>
                                        <div class="file-manage-list" id="updFileManageList">
                                            <c:choose>
                                                <c:when test="${not empty fileList}">
                                                    <c:forEach var="file" items="${fileList}">
                                                        <div class="file-manage-row">
                                                            <c:choose>
                                                                <c:when test="${not empty file.googleId}">
                                                                    <img class="file-thumb js-image-preview"
                                                                         src="${pageContext.request.contextPath}/file/display/${file.googleId}"
                                                                         alt="${file.fileOgName}">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="file-thumb file-thumb-empty">이미지 없음</div>
                                                                </c:otherwise>
                                                            </c:choose>

                                                            <div class="file-info">
                                                                <div class="file-name">${file.fileOgName}</div>
                                                                <div class="file-meta">${empty file.fileExt ? 'image' : file.fileExt}</div>
                                                            </div>

                                                            <label class="file-delete-check">
                                                                <input type="checkbox" class="js-delete-file-check" value="${file.fileSaveUuid}">
                                                                삭제
                                                            </label>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="file-preview-empty">기존 등록 사진이 없습니다.</div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <%-- 새 사진 추가: register 화면과 같은 input multiple 전송 방식 --%>
                                        <div class="file-upload-box">
                                            <div class="file-upload-title">
                                                <span class="material-symbols-rounded">upload_file</span>사진 추가
                                            </div>
                                            <div class="file-upload-desc" style="margin-top:3px;margin-bottom:8px;">이미지 파일을 여러 장 선택할 수 있습니다.</div>
                                            <input type="file" class="form-input" id="updImgInput" name="facilityFiles" accept="image/*" multiple>
                                            <div class="file-preview-list" id="updImgGrid" style="margin-top:8px;">
                                                <div class="file-preview-empty">선택된 사진이 없습니다.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                            <button type="button" class="btn btn-secondary" id="moveDetailBtn">취소</button>
                            <button type="button" class="btn btn-secondary" id="backToListBtn">목록</button>
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
        /* 화면 설정 객체 */
        var config = window.publicFacilityUpdateConfig || {};

        /* 컨텍스트 경로 */
        var contextPath = config.contextPath || "";

        /* 관리사무소 번호 */
        var mgmtOfcNo = config.mgmtOfcNo || "";

        /* 공용시설 번호 */
        var cmnFacilityNo = config.cmnFacilityNo || "";

        /* 요소 조회 함수 */
        function getEl(id) {
            return document.getElementById(id);
        }

        /* 목록 주소 생성 함수 */
        function listUrl() {
            return contextPath + "/manager/publicFacility/list/" + encodeURIComponent(mgmtOfcNo);
        }

        /* 상세 주소 생성 함수 */
        function detailUrl() {
            return contextPath + "/manager/publicFacility/detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo);
        }

        /* 알림 출력 함수 */
        function alertMessage(msg) {
            if (typeof showAlert === "function") showAlert(msg);
            else alert(msg);
        }

        /* 삭제 UUID 갱신 함수 */
        function updateDeleteFileUuids() {
            var hidden = getEl("deleteFileUuids");
            var checked = Array.from(document.querySelectorAll(".js-delete-file-check:checked"))
                .map(function (box) { return box.value; })
                .filter(Boolean);

            if (hidden) {
                hidden.value = checked.join(",");
            }
        }

        /* 새 사진 미리보기 렌더링 함수 */
        function previewSelectedFiles() {
            var fileInput = getEl("updImgInput");
            var previewArea = getEl("updImgGrid");

            if (!fileInput || !previewArea) {
                return;
            }

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
                        img.addEventListener("click", function () {
                            CommonImageViewer.openUrl(this.src);
                        });
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

        /* 저장 전 검증 함수 */
        function validateUpdate() {
            updateDeleteFileUuids();

            if (!getEl("updFacilityNm").value.trim()) {
                alertMessage("시설명을 입력하세요.");
                return false;
            }

            if (!getEl("updCmnNm").value.trim()) {
                alertMessage("편의시설(공용)명을 입력하세요.");
                return false;
            }

            return true;
        }

        /* 저장 요청 함수 */
        function submitUpdate(event) {
            event.preventDefault();

            var form = getEl("updateForm");
            if (!form || !validateUpdate()) {
                return;
            }

            form.submit();
            return;

            fetch(form.action, {
                method: "POST",
                body: new FormData(form),
                credentials: "same-origin"
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error("수정 요청 실패");
                    }
                    return response.json();
                })
                .then(function (result) {
                    if (!result || result.success !== true) {
                        alertMessage(result && result.message ? result.message : "편의시설(공용) 수정에 실패했습니다.");
                        return;
                    }

                    alertMessage(result.message || "편의시설(공용)이 수정되었습니다.");
                    location.href = detailUrl();
                })
                .catch(function () {
                    alertMessage("편의시설(공용) 수정 중 오류가 발생했습니다.");
                });
        }

        /* 이벤트 연결 함수 */
        function bindEvents() {
            getEl("updateForm").addEventListener("submit", submitUpdate);
            getEl("updImgInput").addEventListener("change", previewSelectedFiles);

            document.addEventListener("change", function (e) {
                if (e.target.classList.contains("js-delete-file-check")) {
                    updateDeleteFileUuids();
                }
            });

            getEl("moveDetailBtn").addEventListener("click", function () {
                history.back();
            });

            getEl("backToListBtn").addEventListener("click", function () {
                location.href = listUrl();
            });

            if (window.CommonImageViewer && typeof window.CommonImageViewer.bind === "function") {
                window.CommonImageViewer.bind("#updFileManageList");
            }
        }

        /* 초기 실행 함수 */
        document.addEventListener("DOMContentLoaded", bindEvents);
    })();
</script>
</body>
</html>
