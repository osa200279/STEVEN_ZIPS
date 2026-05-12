<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공용시설 수정</title>
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

        /* 사진 그리드 */
        #publicFacilityUpdatePage .img-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-top:4px; }
        #publicFacilityUpdatePage .img-cell {
            aspect-ratio:4/3; border-radius:6px; overflow:hidden;
            border:1px solid var(--line); background:var(--surface-sub);
            display:flex; align-items:center; justify-content:center;
            cursor:pointer; position:relative; transition:.12s;
        }
        #publicFacilityUpdatePage .img-cell:hover { border-color:var(--accent); }
        #publicFacilityUpdatePage .img-cell img { width:100%; height:100%; object-fit:cover; }
        #publicFacilityUpdatePage .img-placeholder { display:flex; flex-direction:column; align-items:center; gap:4px; color:var(--text-ter); font-size:11px; }
        #publicFacilityUpdatePage .img-placeholder .material-symbols-rounded { font-size:22px; }
        #publicFacilityUpdatePage .img-del {
            position:absolute; top:4px; right:4px; width:22px; height:22px; border-radius:50%;
            background:rgba(0,0,0,.5); color:#fff; display:none;
            align-items:center; justify-content:center; cursor:pointer; font-size:13px;
        }
        #publicFacilityUpdatePage .img-cell:hover .img-del { display:flex; }
        #publicFacilityUpdatePage .img-existing-label { position:absolute; left:6px; bottom:6px; padding:3px 6px; border-radius:999px; background:rgba(0,0,0,.52); color:#fff; font-size:10px; }
        #publicFacilityUpdatePage .delete-file-wrap { margin-top:9px; padding:9px 10px; border:1px solid var(--line); border-radius:6px; background:#fafcfb; }
        #publicFacilityUpdatePage .delete-file-title { margin-bottom:7px; font-size:11px; font-weight:800; color:var(--text-sec); }
        #publicFacilityUpdatePage .delete-file-item { display:flex; align-items:center; gap:6px; margin-top:5px; font-size:11px; color:var(--text-sec); }

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
        <main class="main-content">
            <div class="office-page" id="publicFacilityUpdatePage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>공용시설 수정</h2>
                        <p>시설자산(FACILITY)과 공용시설(PUBLIC_FACILITY) 정보를 수정합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>공용시설 정보 수정</h3>
                    </div>

                    <%-- 수정 흐름: FACILITY UPDATE → PUBLIC_FACILITY UPDATE --%>
                    <form id="updateForm" method="post" action="${pageContext.request.contextPath}/manager/publicFacility/update/${mgmtOfcNo}" enctype="multipart/form-data">
                        <sec:csrfInput/>

                        <%-- 수정 대상 식별값 --%>
                        <input type="hidden" name="facilityNo" value="${detail.facilityNo}">
                        <input type="hidden" name="cmnFacilityNo" value="${detail.cmnFacilityNo}">
                        <input type="hidden" name="mgmtOfcNo" value="${mgmtOfcNo}">
                        <input type="hidden" name="fileGroupNo" value="${detail.fileGroupNo}">

                        <div class="panel-body">
                            <div class="form-section" style="margin-bottom:14px;">
                                <div class="notice-box">
                                    <span class="material-symbols-rounded">info</span>
                                    <div>공용시설 수정 시 시설자산 기본정보와 공용시설 운영정보가 함께 저장됩니다.<br>
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
                                            <span class="material-symbols-rounded">meeting_room</span>공용시설 운영정보
                                        </div>

                                        <%-- 공용시설명 + 시설상태: 한 줄 --%>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">공용시설명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="updCmnNm" name="cmnFacilityNm" value="${detail.cmnFacilityNm}" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">시설 상태</label>
                                                <%-- 공통코드: PUBLIC_FACILITY_STTS --%>
                                                <select class="form-select" id="updStts" name="cmnFacilitySttsCd">
                                                    <option value="OPEN" <c:if test="${detail.cmnFacilitySttsCd eq 'OPEN'}">selected</c:if>>사용가능</option>
                                                    <option value="USE" <c:if test="${detail.cmnFacilitySttsCd eq 'USE'}">selected</c:if>>사용중</option>
                                                    <option value="REPAIR" <c:if test="${detail.cmnFacilitySttsCd eq 'REPAIR'}">selected</c:if>>점검중</option>
                                                    <option value="CLOSE" <c:if test="${detail.cmnFacilitySttsCd eq 'CLOSE'}">selected</c:if>>사용중지</option>
                                                </select>
                                            </div>
                                        </div>

                                        <%-- 예약여부 + 이용요금: 한 줄 --%>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="updRsvYn" name="rsvYn">
                                                    <option value="Y" <c:if test="${detail.rsvYn eq 'Y'}">selected</c:if>>예약 가능</option>
                                                    <option value="N" <c:if test="${detail.rsvYn eq 'N'}">selected</c:if>>예약 불가</option>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="updAmt" name="cmnAmt" value="${detail.cmnAmt}" placeholder="0 (무료)" min="0">
                                            </div>
                                        </div>

                                        <%-- 운영시간: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">운영시간</label>
                                                <input type="text" class="form-input" id="updOprHr" name="oprHr" value="${detail.oprHr}" placeholder="예) 06:00~22:00 (평일) / 08:00~20:00 (주말)">
                                            </div>
                                        </div>

                                        <%-- 시설 안내: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="updCn" name="cmnCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요.">${detail.cmnCn}</textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 우측: 사진 수정 --%>
                                <div class="facility-modal-col-right">
                                    <div class="facility-col-label">시설 사진</div>

                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">photo_library</span>사진 수정
                                            <small style="font-weight:400;color:var(--text-ter);font-size:11px;">기존 사진 확인 · 새 사진 추가</small>
                                        </div>

                                        <%-- 기존 사진 미리보기 + 새 사진 미리보기 슬롯 --%>
                                        <div class="img-grid" id="updImgGrid">
                                            <c:forEach var="file" items="${fileList}" varStatus="st">
                                                <c:if test="${st.index lt 4}">
                                                    <div class="img-cell existing-img-cell" data-slot="${st.index}">
                                                        <img src="${pageContext.request.contextPath}/file/view/${file.fileSaveUuid}" alt="${file.fileOgName}">
                                                        <span class="img-existing-label">기존 사진</span>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                            <c:forEach begin="${fn:length(fileList)}" end="3" var="slot">
                                                <div class="img-cell" data-slot="${slot}" data-action="clickImgSlot">
                                                    <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                                                </div>
                                            </c:forEach>
                                        </div>

                                        <%-- 실제 파일 input: img-cell 클릭 시 트리거 --%>
                                        <input type="file" id="updImgInput" name="facilityFiles" accept="image/*" multiple style="display:none;">
                                        <p style="margin-top:8px;font-size:11px;color:var(--text-ter);">빈 슬롯을 클릭하여 새 사진을 추가하세요.</p>

                                        <%-- 기존 사진 삭제 선택값 --%>
                                        <c:if test="${not empty fileList}">
                                            <div class="delete-file-wrap">
                                                <div class="delete-file-title">기존 사진 삭제 선택</div>
                                                <c:forEach var="file" items="${fileList}">
                                                    <label class="delete-file-item">
                                                        <input type="checkbox" name="deleteFileNoList" value="${file.fileNo}">
                                                        <span>${file.fileOgName}</span>
                                                    </label>
                                                </c:forEach>
                                            </div>
                                        </c:if>
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

        /* 사진 파일 배열 */
        var imgFiles = [null, null, null, null];

        /* 현재 선택 슬롯 번호 */
        var currentSlot = 0;

        /* 요소 조회 함수 */
        function getEl(id) {
            return document.getElementById(id);
        }

        /* 목록 주소 생성 함수 */
        function listUrl() {
            return contextPath + "/manager/publicFacilityList";
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

        /* 사진 슬롯 렌더링 함수 */
        function renderSlot(slot, file) {
            var grid = getEl("updImgGrid");
            var cell = grid ? grid.querySelector('[data-slot="' + slot + '"]') : null;
            if (!cell) return;

            if (file) {
                var url = URL.createObjectURL(file);
                cell.innerHTML = '<img src="' + url + '" alt="사진 ' + (slot + 1) + '">'
                    + '<span class="img-del" data-action="delImg" data-slot="' + slot + '">✕</span>';
            } else {
                cell.innerHTML = '<div class="img-placeholder">'
                    + '<span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>';
            }
        }

        /* 사진 그리드 클릭 처리 함수 */
        function handleImgGridClick(e) {
            var del = e.target.closest('[data-action="delImg"]');
            var cell = e.target.closest('[data-slot]');

            if (del) {
                var delSlot = Number(del.dataset.slot);
                imgFiles[delSlot] = null;
                renderSlot(delSlot, null);
                return;
            }

            /* 기존 사진 슬롯은 삭제 체크박스로만 관리 */
            if (cell && cell.classList.contains("existing-img-cell")) {
                alertMessage("기존 사진은 아래 삭제 선택 후 저장하거나, 빈 슬롯에 새 사진을 추가하세요.");
                return;
            }

            if (cell) {
                currentSlot = Number(cell.dataset.slot);
                getEl("updImgInput").click();
            }
        }

        /* 파일 선택 처리 함수 */
        function handleImgInputChange() {
            var file = this.files[0];
            if (!file) return;

            imgFiles[currentSlot] = file;
            renderSlot(currentSlot, file);
            this.value = "";
        }

        /* 저장 전 검증 함수 */
        function validateUpdate(event) {
            if (!getEl("updFacilityNm").value.trim()) {
                event.preventDefault();
                alertMessage("시설명을 입력하세요.");
                return;
            }

            if (!getEl("updCmnNm").value.trim()) {
                event.preventDefault();
                alertMessage("공용시설명을 입력하세요.");
            }
        }

        /* 이벤트 연결 함수 */
        function bindEvents() {
            getEl("updateForm").addEventListener("submit", validateUpdate);
            getEl("updImgGrid").addEventListener("click", handleImgGridClick);
            getEl("updImgInput").addEventListener("change", handleImgInputChange);

            getEl("moveDetailBtn").addEventListener("click", function () {
                location.href = detailUrl();
            });

            getEl("backToListBtn").addEventListener("click", function () {
                location.href = listUrl();
            });
        }

        /* 초기 실행 함수 */
        document.addEventListener("DOMContentLoaded", bindEvents);
    })();
</script>
</body>
</html>
