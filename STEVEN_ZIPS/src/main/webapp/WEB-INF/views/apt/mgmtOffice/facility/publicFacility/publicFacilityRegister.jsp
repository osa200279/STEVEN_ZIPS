<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공용시설 등록</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        #publicFacilityPage {
            --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea;
            --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb;
            --line:#d7dce2; --th-bg:#f3f5f3; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e;
        }
        #publicFacilityPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityPage .page-title-block p  { color:var(--text-sec); font-size:12px; }
        #publicFacilityPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityPage .panel-body .form-input,
        #publicFacilityPage .panel-body .form-select { height:32px; font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #publicFacilityPage .panel-body .form-input:focus,
        #publicFacilityPage .panel-body .form-select:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); }
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

        /* 사진 그리드 */
        #publicFacilityPage .img-grid { display:grid; grid-template-columns:1fr 1fr; gap:8px; margin-top:4px; }
        #publicFacilityPage .img-cell {
            aspect-ratio:4/3; border-radius:6px; overflow:hidden;
            border:1px solid var(--line); background:var(--surface-sub);
            display:flex; align-items:center; justify-content:center;
            cursor:pointer; position:relative; transition:.12s;
        }
        #publicFacilityPage .img-cell:hover { border-color:var(--accent); }
        #publicFacilityPage .img-cell img { width:100%; height:100%; object-fit:cover; }
        #publicFacilityPage .img-placeholder { display:flex; flex-direction:column; align-items:center; gap:4px; color:var(--text-ter); font-size:11px; }
        #publicFacilityPage .img-placeholder .material-symbols-rounded { font-size:22px; }
        #publicFacilityPage .img-del {
            position:absolute; top:4px; right:4px; width:22px; height:22px; border-radius:50%;
            background:rgba(0,0,0,.5); color:#fff; display:none;
            align-items:center; justify-content:center; cursor:pointer; font-size:13px;
        }
        #publicFacilityPage .img-cell:hover .img-del { display:flex; }

        @media (max-width:760px) {
            .facility-modal-cols { grid-template-columns:1fr; }
            .facility-modal-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line,#d7dce2); padding-bottom:16px; margin-bottom:16px; }
            .facility-modal-col-right { padding-left:0; }
        }
    </style>
    <script>
        window.publicFacilityPageConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mgmtOfcNo: "${mgmtOfcNo}"
        };
    </script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="publicFacilityPage">
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>공용시설 등록</h2>
                        <p>시설자산(FACILITY)과 공용시설(PUBLIC_FACILITY) 정보를 함께 등록합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">edit_square</span>공용시설 정보 입력</h3>
                    </div>

                    <%-- 저장 흐름: FACILITY INSERT → PUBLIC_FACILITY INSERT --%>
                    <form id="registerForm" enctype="multipart/form-data">

                        <div class="panel-body">
                            <div class="form-section" style="margin-bottom:14px;">
                                <div class="notice-box">
                                    <span class="material-symbols-rounded">info</span>
                                    <div>공용시설 등록 시 시설자산(FACILITY)과 공용시설(PUBLIC_FACILITY)이 함께 생성됩니다.<br>
                                        헬스장·독서실 등 편의시설의 예약·운영 관리는 등록 후 이 화면에서 진행합니다.</div>
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
                                                <input type="text" class="form-input" id="regFacilityNm" name="facilityNm" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
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

                                        <%-- 상세위치: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">상세위치</label>
                                                <input type="text" class="form-input" id="regLocCn" name="locCn" placeholder="예) 커뮤니티센터 2층">
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
                                                <input type="text" class="form-input" id="regCmnNm" name="cmnFacilityNm" placeholder="예) 헬스장" required>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">시설 상태</label>
                                                <%-- 공통코드: PUBLIC_FACILITY_STTS --%>
                                                <select class="form-select" id="regStts" name="cmnFacilitySttsCd">
                                                    <option value="OPEN">사용가능</option>
                                                    <option value="USE">사용중</option>
                                                    <option value="REPAIR">점검중</option>
                                                    <option value="CLOSE">사용중지</option>
                                                </select>
                                            </div>
                                        </div>

                                        <%-- 예약여부 + 이용요금: 한 줄 --%>
                                        <div class="form-row cols-2">
                                            <div class="form-field">
                                                <label class="field-label">예약 가능 여부</label>
                                                <select class="form-select" id="regRsvYn" name="rsvYn">
                                                    <option value="Y">예약 가능</option>
                                                    <option value="N">예약 불가</option>
                                                </select>
                                            </div>
                                            <div class="form-field">
                                                <label class="field-label">이용요금 (원)</label>
                                                <input type="number" class="form-input" id="regAmt" name="cmnAmt" placeholder="0 (무료)" min="0">
                                            </div>
                                        </div>

                                        <%-- 운영시간: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">운영시간</label>
                                                <input type="text" class="form-input" id="regOprHr" name="oprHr" placeholder="예) 06:00~22:00 (평일) / 08:00~20:00 (주말)">
                                            </div>
                                        </div>

                                        <%-- 시설 안내: 한 줄 --%>
                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">시설 안내</label>
                                                <textarea class="form-textarea" id="regCn" name="cmnCn" rows="3" placeholder="시설 이용 안내사항을 입력하세요."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 우측: 사진 등록 --%>
                                <div class="facility-modal-col-right">
                                    <div class="facility-col-label">시설 사진</div>

                                    <div class="form-section">
                                        <div class="form-section-title">
                                            <span class="material-symbols-rounded">photo_library</span>사진 등록
                                            <small style="font-weight:400;color:var(--text-ter);font-size:11px;">최대 4장 · JPG, PNG</small>
                                        </div>
                                        <div class="img-grid" id="regImgGrid">
                                            <div class="img-cell" data-slot="0" data-action="clickImgSlot">
                                                <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                                            </div>
                                            <div class="img-cell" data-slot="1" data-action="clickImgSlot">
                                                <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                                            </div>
                                            <div class="img-cell" data-slot="2" data-action="clickImgSlot">
                                                <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                                            </div>
                                            <div class="img-cell" data-slot="3" data-action="clickImgSlot">
                                                <div class="img-placeholder"><span class="material-symbols-rounded">add_photo_alternate</span>사진 추가</div>
                                            </div>
                                        </div>
                                        <%-- 실제 파일 input: img-cell 클릭 시 트리거 --%>
                                        <input type="file" id="regImgInput" name="facilityFiles" accept="image/*" multiple style="display:none;">
                                        <p style="margin-top:8px;font-size:11px;color:var(--text-ter);">슬롯을 클릭하여 사진을 추가하세요.</p>
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
            </div>
        </main>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script>
    (function () {
        var config = window.publicFacilityPageConfig || {};
        var contextPath = config.contextPath || "";
        var mgmtOfcNo  = config.mgmtOfcNo  || "";

        /* ── 공통 함수 ── */
        function getEl(id) { return document.getElementById(id); }
        function listUrl() { return contextPath + "/manager/publicFacilityList"; }
        function alertMessage(msg) { if (typeof showAlert === "function") showAlert(msg); else alert(msg); }

        function getCsrfHeaders() {
            var tokenMeta  = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
            return headers;
        }

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

        function postForm(url, formData) {
            return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData });
        }

        /* ── 사진 슬롯 관리 ── */
        /*
         * imgFiles: 슬롯별 File 객체 저장 배열 (최대 4개)
         * 슬롯 클릭 → file input 트리거 → 선택 파일을 해당 슬롯에 미리보기
         */
        var imgFiles = [null, null, null, null];
        var currentSlot = 0;

        function renderSlot(slot, file) {
            var cell = getEl("regImgGrid").querySelector('[data-slot="' + slot + '"]');
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

        getEl("regImgGrid").addEventListener("click", function (e) {
            var cell = e.target.closest("[data-slot]");
            var del  = e.target.closest('[data-action="delImg"]');

            if (del) {
                var slot = Number(del.dataset.slot);
                imgFiles[slot] = null;
                renderSlot(slot, null);
                return;
            }

            if (cell) {
                currentSlot = Number(cell.dataset.slot);
                getEl("regImgInput").click();
            }
        });

        getEl("regImgInput").addEventListener("change", function () {
            var file = this.files[0];
            if (!file) return;
            imgFiles[currentSlot] = file;
            renderSlot(currentSlot, file);
            this.value = "";
        });

        /* ── 저장 처리 ── */
        /*
         * FormData에 폼 필드 + 사진 파일을 담아 서버로 전송
         * 저장 흐름: FACILITY INSERT → PUBLIC_FACILITY INSERT
         */
        async function saveRegister(event) {
            event.preventDefault();

            if (!getEl("regFacilityNm").value.trim()) { alertMessage("시설명을 입력하세요."); return; }
            if (!getEl("regCmnNm").value.trim())      { alertMessage("공용시설명을 입력하세요."); return; }

            var formData = new FormData(getEl("registerForm"));

            /* 슬롯별 파일을 facilityFiles 키로 추가 */
            formData.delete("facilityFiles");
            imgFiles.forEach(function (file) {
                if (file) formData.append("facilityFiles", file);
            });

            try {
                await postForm(
                    contextPath + "/manager/publicFacility/insert/" + encodeURIComponent(mgmtOfcNo),
                    formData
                );
                alertMessage("공용시설이 등록되었습니다.");
                location.href = listUrl();
            } catch (err) {
                console.error(err);
                alertMessage(err.message || "공용시설 등록 중 오류가 발생했습니다.");
            }
        }

        /* ── 이벤트 연결 ── */
        getEl("registerForm").addEventListener("submit", saveRegister);
        getEl("backToListBtn").addEventListener("click", function () { location.href = listUrl(); });

    })();
</script>
</body>
</html>
