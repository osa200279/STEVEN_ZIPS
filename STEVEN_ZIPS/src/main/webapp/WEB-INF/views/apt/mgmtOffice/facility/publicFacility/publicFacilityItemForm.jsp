<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fn"  uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%--
================================================================
publicFacilityItemForm.jsp
공용아이템 등록/수정 통합 화면

사용 방식
- 등록: mode = insert
- 수정: mode = update

필요 model
- mode                : insert 또는 update
- mgmtOfcNo           : 관리사무소 번호
- cmnFacilityNo       : 부모 공용시설 번호
- cmnFacilityItemNo   : 수정 시 공용아이템 번호
- detail              : 부모 공용시설 요약 정보
- item                : 수정 시 공용아이템 상세 정보
- isAdmin             : ADMIN 여부, IManagerModelService.addManagerViewModel()에서 세팅

저장 기준
- PUBLIC_ITEM 단독 저장
- PUBLIC_ITEM 테이블에는 FILE_GROUP_NO가 없으므로 아이템별 사진은 등록하지 않음
- 사진이 필요한 경우 상위 공용시설/시설자산 사진 관리 화면에서 등록
================================================================
--%>

<c:set var="pageMode" value="${empty mode ? 'insert' : mode}" />
<c:set var="isUpdate" value="${pageMode eq 'update'}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isUpdate ? '편의시설 자원 수정' : '편의시설 자원 등록'}</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #publicFacilityItemFormPage { --accent:#2e5c38; --accent-hover:#1f4027; --accent-light:#e8f0ea; --accent-dim:rgba(46,92,56,.08); --surface:#ffffff; --surface-sub:#f8f9fb; --line:#d7dce2; --text-pri:#1a1f1b; --text-sec:#4a5c4e; --text-ter:#8a9a8e; }
        #publicFacilityItemFormPage .page-title-block h2 { color:var(--text-pri); font-size:19px; letter-spacing:-.5px; }
        #publicFacilityItemFormPage .page-title-block p { color:var(--text-sec); font-size:12px; }
        #publicFacilityItemFormPage .panel { border-radius:6px; border:1px solid var(--line); box-shadow:none; margin:0; }
        #publicFacilityItemFormPage .panel-header { display:flex; align-items:center; justify-content:space-between; padding:13px 16px; border-bottom:1px solid var(--line); background:var(--surface); border-radius:6px 6px 0 0; }
        #publicFacilityItemFormPage .panel-title { display:flex; align-items:center; gap:6px; margin:0; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityItemFormPage .panel-title .material-symbols-rounded { font-size:17px; color:var(--accent); }
        #publicFacilityItemFormPage .panel-body { padding:14px 16px 16px; background:var(--surface); }
        #publicFacilityItemFormPage .form-input, #publicFacilityItemFormPage .form-select, #publicFacilityItemFormPage .form-textarea { font-size:12px; border-color:var(--line); background:var(--surface); border-radius:4px; }
        #publicFacilityItemFormPage .form-input, #publicFacilityItemFormPage .form-select { height:32px; }
        #publicFacilityItemFormPage .form-textarea { width:100%; min-height:118px; padding:9px 10px; resize:vertical; line-height:1.55; }
        #publicFacilityItemFormPage .form-input:focus, #publicFacilityItemFormPage .form-select:focus, #publicFacilityItemFormPage .form-textarea:focus { border-color:var(--accent); box-shadow:0 0 0 2px var(--accent-dim); outline:none; }
        #publicFacilityItemFormPage .form-input[readonly], #publicFacilityItemFormPage .form-textarea[readonly] { background:var(--surface-sub); color:var(--text-pri); opacity:1; cursor:default; }
        #publicFacilityItemFormPage .form-select:disabled { background:var(--surface-sub); color:var(--text-pri); opacity:1; cursor:default; }
        #publicFacilityItemFormPage .btn { border-radius:4px; }
        #publicFacilityItemFormPage .btn-primary { background:var(--accent); border-color:var(--accent); }
        #publicFacilityItemFormPage .btn-primary:hover { background:var(--accent-hover); border-color:var(--accent-hover); }
        #publicFacilityItemFormPage .notice-box { display:flex; gap:10px; padding:11px 13px; background:#f7faf7; border:1px solid var(--line); border-left:3px solid var(--accent); border-radius:0 4px 4px 0; font-size:12px; color:var(--text-sec); line-height:1.6; }
        #publicFacilityItemFormPage .notice-box .material-symbols-rounded { color:var(--accent); font-size:17px; flex-shrink:0; margin-top:2px; }
        #publicFacilityItemFormPage .field-help { margin-top:5px; font-size:11px; color:var(--text-ter); line-height:1.5; }
        #publicFacilityItemFormPage .form-section-title { display:flex; align-items:center; gap:4px; font-size:11px; font-weight:800; color:var(--text-sec); letter-spacing:0; text-transform:none; margin-bottom:10px; }
        #publicFacilityItemFormPage .form-section-title .material-symbols-rounded { font-size:15px; color:var(--accent); }
        #publicFacilityItemFormPage .item-form-cols { display:grid; grid-template-columns:1.05fr .95fr; gap:0; }
        #publicFacilityItemFormPage .item-form-col-left { padding-right:20px; border-right:1px solid var(--line); }
        #publicFacilityItemFormPage .item-form-col-right { padding-left:20px; }
        #publicFacilityItemFormPage .facility-summary { border:1px solid var(--line); background:var(--surface-sub); border-radius:6px; padding:12px; margin-bottom:14px; }
        #publicFacilityItemFormPage .summary-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px 12px; }
        #publicFacilityItemFormPage .summary-label { display:block; margin-bottom:4px; font-size:11px; font-weight:800; color:var(--text-ter); }
        #publicFacilityItemFormPage .summary-value { font-size:12px; font-weight:700; color:var(--text-pri); word-break:break-all; }
        #publicFacilityItemFormPage .guide-card { border:1px solid var(--line); background:var(--surface-sub); border-radius:6px; padding:14px; }
        #publicFacilityItemFormPage .guide-card + .guide-card { margin-top:12px; }
        #publicFacilityItemFormPage .guide-title { display:flex; align-items:center; gap:6px; margin:0 0 8px; font-size:13px; font-weight:800; color:var(--text-pri); }
        #publicFacilityItemFormPage .guide-title .material-symbols-rounded { font-size:18px; color:var(--accent); }
        #publicFacilityItemFormPage .guide-text { margin:0; font-size:12px; color:var(--text-sec); line-height:1.7; }
        #publicFacilityItemFormPage .guide-list { margin:9px 0 0; padding-left:17px; font-size:12px; color:var(--text-sec); line-height:1.75; }
        #publicFacilityItemFormPage .guide-actions { display:flex; align-items:center; gap:7px; flex-wrap:wrap; margin-top:12px; }
        @media (max-width:760px) { #publicFacilityItemFormPage .item-form-cols { grid-template-columns:1fr; } #publicFacilityItemFormPage .item-form-col-left { padding-right:0; border-right:none; border-bottom:1px solid var(--line); padding-bottom:16px; margin-bottom:16px; } #publicFacilityItemFormPage .item-form-col-right { padding-left:0; } #publicFacilityItemFormPage .summary-grid { grid-template-columns:1fr; } }
    </style>

    <script>
        window.publicFacilityItemFormConfig = {
            contextPath: "${pageContext.request.contextPath}",
            mode: "${pageMode}",
            mgmtOfcNo: "${mgmtOfcNo}",
            cmnFacilityNo: "${cmnFacilityNo}",
            cmnFacilityItemNo: "${isUpdate ? item.cmnFacilityItemNo : ''}",
            isAdmin: ${isAdmin ? 'true' : 'false'}
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
            <div class="office-page" id="publicFacilityItemFormPage">
                <div class="page-header">
                    <div class="page-title-block">
                    <h2>${isUpdate ? '편의시설 자원 수정' : '편의시설 자원 등록'}</h2>
                    <p>편의시설(공용) 하위 자원(PUBLIC_ITEM)을 ${isUpdate ? '수정' : '등록'}합니다. 개별 사진은 편의시설(공용) 사진 관리에서 처리합니다.</p>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <h3 class="panel-title"><span class="material-symbols-rounded">inventory_2</span>편의시설 자원 정보 입력</h3>
                    </div>

                    <%-- 저장 흐름: PUBLIC_ITEM 단독 저장, 파일 첨부 없음 --%>
                    <form id="itemForm" method="post" action="${pageContext.request.contextPath}/manager/publicFacility/item/${isUpdate ? 'update' : 'insert'}/${mgmtOfcNo}">
                        <sec:csrfInput/>
                        <input type="hidden" id="cmnFacilityNo" name="cmnFacilityNo" value="${cmnFacilityNo}">
                        <c:if test="${isUpdate}">
                            <input type="hidden" id="cmnFacilityItemNo" name="cmnFacilityItemNo" value="${item.cmnFacilityItemNo}">
                        </c:if>

                        <div class="panel-body">
                            <div class="form-section" style="margin-bottom:14px;">
                                <div class="notice-box">
                                    <span class="material-symbols-rounded">info</span>
                    <div>편의시설 자원은 자원명, 상태, 비고만 관리합니다.<br>사진이 필요한 경우 상위 편의시설(공용)의 사진 관리 화면에서 시설 전체 사진으로 등록해 주세요.</div>
                                </div>
                            </div>

                            <div class="item-form-cols">
                                <%-- 좌측: 부모 공용시설 정보 + 아이템 입력 --%>
                                <div class="item-form-col-left">
                                    <div class="form-section" style="margin-bottom:14px;">
                            <div class="form-section-title"><span class="material-symbols-rounded">meeting_room</span>편의시설(공용) 정보</div>
                                        <div class="facility-summary">
                                            <div class="summary-grid">
                                    <div><span class="summary-label">편의시설(공용)번호</span><span class="summary-value">${cmnFacilityNo}</span></div>
                                    <div><span class="summary-label">편의시설(공용)명</span><span class="summary-value">${empty detail.cmnFacilityNm ? '-' : detail.cmnFacilityNm}</span></div>
                                                <div><span class="summary-label">연결 시설명</span><span class="summary-value">${empty detail.facilityNm ? '-' : detail.facilityNm}</span></div>
                                                <div><span class="summary-label">위치</span><span class="summary-value">${empty detail.locCn ? '-' : detail.locCn}</span></div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-section">
                            <div class="form-section-title"><span class="material-symbols-rounded">edit_square</span>편의시설 자원 정보</div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">자원명 <span class="req">*</span></label>
                                                <input type="text" class="form-input" id="itemNm" name="itemNm" value="${isUpdate ? item.itemNm : ''}" placeholder="예) 러닝머신 1번, A-01 좌석, 게스트룸 101호" required ${isAdmin ? 'readonly' : ''}>
                                <div class="field-help">편의시설(공용) 안에서 구분할 수 있는 자원명을 입력하세요.</div>
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">상태 <span class="req">*</span></label>
                                                <select class="form-select" id="cmnFacilitySttsCd" name="cmnFacilitySttsCd" required ${isAdmin ? 'disabled' : ''}>
                                                    <option value="OPEN"   ${isUpdate and item.cmnFacilitySttsCd eq 'OPEN'   ? 'selected' : ''}>사용가능</option>
                                                    <option value="USE"    ${isUpdate and item.cmnFacilitySttsCd eq 'USE'    ? 'selected' : ''}>사용중</option>
                                                    <option value="REPAIR" ${isUpdate and item.cmnFacilitySttsCd eq 'REPAIR' ? 'selected' : ''}>점검중</option>
                                                    <option value="CLOSE"  ${isUpdate and item.cmnFacilitySttsCd eq 'CLOSE'  ? 'selected' : ''}>사용중지</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-row cols-1">
                                            <div class="form-field">
                                                <label class="field-label">비고 / 내용</label>
                                                <textarea class="form-textarea" id="itemCn" name="itemCn" placeholder="예) 창가 좌석, 벨트 점검 필요, 예약 제한 등" ${isAdmin ? 'readonly' : ''}>${isUpdate ? item.itemCn : ''}</textarea>
                                                <div class="field-help">자원 이용 시 참고할 내용이나 점검 메모를 입력하세요.</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <%-- 우측: 사진 대신 공용시설 사진 관리 안내 --%>
                                <div class="item-form-col-right">
                                    <div class="form-section">
                                        <div class="form-section-title"><span class="material-symbols-rounded">photo_library</span>사진 관리 안내</div>

                                        <div class="guide-card">
                                            <h4 class="guide-title"><span class="material-symbols-rounded">account_tree</span>아이템 사진 관리 기준</h4>
                            <p class="guide-text">PUBLIC_ITEM 테이블에는 파일 그룹 번호가 없으므로 자원별 사진은 이 화면에서 등록하지 않습니다. 시설 전경, 운영 안내 이미지, 공간 사진은 상위 편의시설(공용) 사진으로 관리해 주세요.</p>
                                            <ul class="guide-list">
                                                <li>아이템 정보: 자원명, 상태, 비고 관리</li>
                                <li>사진 정보: 상위 편의시설(공용)/시설자산 사진에서 관리</li>
                                                <li>개별 자원 사진이 꼭 필요하면 DB 컬럼 추가 후 별도 확장</li>
                                            </ul>
                                        </div>

                                        <div class="guide-card">
                            <h4 class="guide-title"><span class="material-symbols-rounded">open_in_new</span>편의시설(공용) 바로가기</h4>
                            <p class="guide-text">사진을 첨부해야 하는 경우 편의시설(공용) 수정 화면에서 시설 전체 사진으로 등록하세요. ADMIN은 조회만 가능하므로 수정 이동 버튼은 표시하지 않습니다.</p>
                                            <div class="guide-actions">
                                <a class="btn btn-secondary" href="${pageContext.request.contextPath}/manager/publicFacility/detail-page/${mgmtOfcNo}/${cmnFacilityNo}">편의시설(공용) 상세</a>
                                                <c:if test="${not isAdmin}">
                                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/manager/publicFacility/update-page/${mgmtOfcNo}/${cmnFacilityNo}">편의시설(공용) 사진 관리</a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="page-actions" style="justify-content:flex-end;margin-top:14px;">
                            <button type="button" class="btn btn-secondary" id="backToListBtn">취소</button>
                            <c:if test="${not isAdmin}">
                                <button type="submit" class="btn btn-primary">저장</button>
                            </c:if>
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
        var config = window.publicFacilityItemFormConfig || {};
        var contextPath = config.contextPath || "";
        var mode = config.mode || "insert";
        var mgmtOfcNo = config.mgmtOfcNo || "";
        var cmnFacilityNo = config.cmnFacilityNo || "";
        var isAdmin = config.isAdmin === true;

        /* DOM 요소 조회 함수 */
        function getEl(id) { return document.getElementById(id); }

        /* 편의시설(공용) 상세 주소 생성 함수 */
        function detailUrl() {
            return contextPath + "/manager/publicFacility/detail-page/" + encodeURIComponent(mgmtOfcNo) + "/" + encodeURIComponent(cmnFacilityNo);
        }

        /* 저장 요청 주소 생성 함수 */
        function saveUrl() {
            if (mode === "update") {
                return contextPath + "/manager/publicFacility/item/update/" + encodeURIComponent(mgmtOfcNo);
            }
            return contextPath + "/manager/publicFacility/item/insert/" + encodeURIComponent(mgmtOfcNo);
        }

        /* 알림 표시 함수 */
        function alertMessage(msg) {
            if (typeof showAlert === "function") showAlert(msg); else alert(msg);
        }

        /* CSRF 헤더 생성 함수 */
        function getCsrfHeaders() {
            var tokenMeta = document.querySelector('meta[name="_csrf"]');
            var headerMeta = document.querySelector('meta[name="_csrf_header"]');
            var headers = {};
            if (tokenMeta && headerMeta) headers[headerMeta.content] = tokenMeta.content;
            return headers;
        }

        /* JSON 요청 처리 함수 */
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

        /* FormData POST 처리 함수 */
        function postForm(url, formData) {
            return requestJson(url, { method:"POST", headers:getCsrfHeaders(), body:formData });
        }

        /* 공용아이템 저장 함수 */
        function saveItem(event) {
            event.preventDefault();

            /* ADMIN 직접 저장 요청 방지 */
            if (isAdmin) {
                return;
            }

            /* 필수 자원명 검증 */
            if (!getEl("itemNm").value.trim()) {
                alertMessage("자원명을 입력하세요.");
                return;
            }

            /* 파일 없이 PUBLIC_ITEM 필드만 전송 */
            var formData = new FormData(getEl("itemForm"));

            try {
                getEl("itemForm").submit();
                return;
                postForm(saveUrl(), formData);
                            alertMessage(mode === "update" ? "편의시설 자원이 수정되었습니다." : "편의시설 자원이 등록되었습니다.");
                location.href = detailUrl();
            } catch (err) {
                console.error(err);
                            alertMessage(err.message || "편의시설 자원 저장 중 오류가 발생했습니다.");
            }
        }

        /* 초기 이벤트 연결 함수 */
        document.addEventListener("DOMContentLoaded", function () {
            if (getEl("itemForm")) {
                getEl("itemForm").addEventListener("submit", saveItem);
            }

            if (getEl("backToListBtn")) {
                getEl("backToListBtn").addEventListener("click", function () { location.href = detailUrl(); });
            }
        });
    })();
</script>
</body>
</html>
