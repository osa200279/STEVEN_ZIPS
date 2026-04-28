<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>단지 정보 수정</title>

    <!-- Spring Security CSRF 메타 태그: 추후 POST/fetch 저장 처리 시 CSRF 토큰 사용 가능 -->
    <sec:csrfMetaTags/>

    <!-- Google Fonts: 화면 기본 한글 폰트(Noto Sans KR) -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />

    <!-- Google Fonts: 폰트 파일 로딩 최적화용 연결 -->
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

    <!-- Google Fonts: Noto Sans KR 폰트 -->
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <!-- Google Material Symbols: 아이콘 폰트(refresh, save, apartment 등) -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <!-- 프로젝트 공통 레이아웃 CSS: 관리사무소 사이드바/헤더/전체 레이아웃 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

    <!-- 프로젝트 관리사무소 공통 UI CSS: 버튼/패널/폼/테이블/모달 공통 스타일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        /* =========================================================
           단지 정보 수정 화면 전용 스타일
           - inline style 제거
           - 이미지 업로드 박스/미리보기 스타일 정리
        ========================================================= */

        .complex-readonly {
            background: var(--bg-secondary, #f5f5f5);
            color: var(--text-tertiary);
            cursor: not-allowed;
        }

        .complex-readonly-note {
            margin-left: 6px;
            font-size: 10px;
            font-weight: 400;
            color: var(--text-tertiary);
        }

        .complex-upload-box {
            padding: 16px;
            border: 2px dashed var(--border);
            border-radius: 8px;
            background: #fafafa;
            text-align: center;
            cursor: pointer;
            transition: 0.15s;
        }

        .complex-upload-box.drag-over {
            border-color: #2e5c38;
            background: #f0f7f2;
        }

        .complex-upload-box .material-symbols-rounded {
            display: block;
            margin-bottom: 4px;
            font-size: 28px;
            color: var(--text-tertiary);
        }

        .complex-upload-title {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .complex-upload-desc {
            margin-top: 2px;
            font-size: 11px;
            color: var(--text-tertiary);
        }

        .complex-preview {
            margin-top: 10px;
        }

        .complex-preview-list {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
        }

        .complex-preview-item {
            position: relative;
            width: 80px;
            height: 80px;
        }

        .complex-preview-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border: 1px solid var(--border);
            border-radius: 6px;
        }

        .complex-preview-remove {
            position: absolute;
            top: -6px;
            right: -6px;
            width: 20px;
            height: 20px;
            padding: 0;
            border: none;
            border-radius: 50%;
            background: #991b1b;
            color: #fff;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .complex-preview-remove .material-symbols-rounded {
            font-size: 14px;
        }

        .complex-footer-panel {
            padding: 0;
        }

        .complex-footer {
            border-top: none;
            padding: 16px 20px;
        }
    </style>
</head>

<body>
<div class="app-wrapper">
    <!-- 프로젝트 공통 JSP include: 관리사무소 사이드바 -->
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <!-- 프로젝트 공통 JSP include: 관리사무소 헤더 -->
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="complexEditPage">

                <!-- =====================================================
                     페이지 헤더
                     - 단지 정보 수정 화면 제목
                     - 상단 초기화/저장 버튼
                ====================================================== -->
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>단지 정보 수정</h2>
                        <p>아파트 단지의 기본 정보, 위치, 시설 현황을 수정합니다.</p>
                    </div>

                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary" id="btnResetComplex">
                            <span class="material-symbols-rounded">refresh</span>
                            초기화
                        </button>

                        <button type="button" class="btn btn-primary" id="btnSaveComplex">
                            <span class="material-symbols-rounded">save</span>
                            저장
                        </button>
                    </div>
                </div>

                <form id="complexEditForm" enctype="multipart/form-data">
                    <input type="hidden" id="aptCmplexNo" name="aptCmplexNo">

                    <!-- =====================================================
                         섹션 1. 기본 정보
                         - 단지명, 법정동 코드, 주소 정보
                    ====================================================== -->
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">apartment</span>
                                기본 정보
                            </h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-section">
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">
                                            아파트 단지명
                                            <span class="complex-readonly-note">※ 수정 불가</span>
                                        </label>
                                        <input type="text" class="form-input complex-readonly" id="aptCmplexNm" name="aptCmplexNm" readonly>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">법정동 코드</label>
                                        <input type="text" class="form-input" id="bjdCd" name="bjdCd" placeholder="예: 1111010100">
                                    </div>
                                </div>

                                <div class="form-row cols-3">
                                    <div class="form-field">
                                        <label class="field-label">시도명 <span class="req">*</span></label>
                                        <input type="text" class="form-input" id="sidoNm" name="sidoNm" placeholder="예: 서울특별시">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">시군구명 <span class="req">*</span></label>
                                        <input type="text" class="form-input" id="sigunguNm" name="sigunguNm" placeholder="예: 강남구">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">읍면동명 <span class="req">*</span></label>
                                        <input type="text" class="form-input" id="emdNm" name="emdNm" placeholder="예: 역삼동">
                                    </div>
                                </div>

                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">도로명 주소</label>
                                        <input type="text" class="form-input" id="dorojuso" name="dorojuso" placeholder="예: 서울특별시 강남구 테헤란로 123">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         섹션 2. 위치 정보
                         - 위도/경도 입력
                         - 추후 지도 API 연결 가능
                    ====================================================== -->
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">location_on</span>
                                위치 정보
                            </h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-section">
                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">위도</label>
                                        <input type="number" class="form-input" id="latVal" name="latVal" step="0.0000001" placeholder="예: 37.5012743">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">경도</label>
                                        <input type="number" class="form-input" id="lonVal" name="lonVal" step="0.0000001" placeholder="예: 127.0396597">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         섹션 3. 단지 현황
                         - 세대/동/층/주차/CCTV/준공/난방/건설사 정보
                    ====================================================== -->
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">domain</span>
                                단지 현황
                            </h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-section">
                                <div class="form-row cols-3">
                                    <div class="form-field">
                                        <label class="field-label">세대 수</label>
                                        <input type="number" class="form-input" id="unitCnt" name="unitCnt" min="0" placeholder="예: 500">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">동 수</label>
                                        <input type="number" class="form-input" id="dongCnt" name="dongCnt" min="0" placeholder="예: 10">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">최대 층수</label>
                                        <input type="number" class="form-input" id="maxFloor" name="maxFloor" min="0" placeholder="예: 25">
                                    </div>
                                </div>

                                <div class="form-row cols-3">
                                    <div class="form-field">
                                        <label class="field-label">주차 가능 대수</label>
                                        <input type="number" class="form-input" id="pkgCnt" name="pkgCnt" min="0" placeholder="예: 600">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">세대당 무료 주차 대수</label>
                                        <input type="number" class="form-input" id="freePkgCnt" name="freePkgCnt" min="0" placeholder="예: 1">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">CCTV 수</label>
                                        <input type="text" class="form-input" id="ccCnt" name="ccCnt" placeholder="예: 32">
                                    </div>
                                </div>

                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">준공 연도</label>
                                        <input type="text" class="form-input" id="bldYr" name="bldYr" maxlength="8" placeholder="예: 20050301">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">난방 방식</label>
                                        <select class="form-select" id="heatTyCd" name="heatTyCd">
                                            <option value="">선택</option>
                                            <option value="CENTRAL">중앙난방</option>
                                            <option value="INDIVIDUAL">개별난방</option>
                                            <option value="DISTRICT">지역난방</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">건설사명</label>
                                        <input type="text" class="form-input" id="cnscoNm" name="cnscoNm" placeholder="예: 현대건설">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         섹션 4. 단지 이미지
                         - 대표 이미지 1장
                         - 일반 단지 사진 최대 5장
                         - 현재는 화면 미리보기용 FileReader 처리
                    ====================================================== -->
                    <div class="panel">
                        <div class="panel-header">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">photo_library</span>
                                단지 이미지
                            </h3>
                        </div>

                        <div class="panel-body">
                            <div class="form-section">

                                <div class="form-section-title">
                                    <span class="material-symbols-rounded">star</span>
                                    대표 이미지
                                </div>

                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">현재 대표 이미지 번호</label>
                                        <input type="text" class="form-input complex-readonly" id="rprsntImgFileNo" name="rprsntImgFileNo" placeholder="기존 파일 번호" readonly>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">대표 이미지 교체</label>

                                        <div id="mainImgUploadArea" class="complex-upload-box">
                                            <span class="material-symbols-rounded">add_photo_alternate</span>
                                            <div class="complex-upload-title">클릭하여 대표 이미지 업로드</div>
                                            <div class="complex-upload-desc">JPG, PNG · 최대 10MB</div>
                                        </div>

                                        <input type="file" id="mainImgFileInput" name="mainImgFile" accept="image/*" style="display:none;">
                                        <div id="mainImgPreview" class="complex-preview"></div>
                                    </div>
                                </div>

                                <div class="form-section-title" style="margin-top:16px;">
                                    <span class="material-symbols-rounded">collections</span>
                                    단지 사진
                                </div>

                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">현재 이미지 파일 번호</label>
                                        <input type="text" class="form-input complex-readonly" id="imgFileNo" name="imgFileNo" placeholder="기존 파일 번호" readonly>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">단지 사진 추가/교체</label>

                                        <div id="complexImgUploadArea" class="complex-upload-box">
                                            <span class="material-symbols-rounded">add_photo_alternate</span>
                                            <div class="complex-upload-title">클릭하여 이미지 업로드</div>
                                            <div class="complex-upload-desc">JPG, PNG · 최대 10MB · 최대 5장</div>
                                        </div>

                                        <input type="file" id="complexImgFileInput" name="complexImgFiles" accept="image/*" multiple style="display:none;">
                                        <div id="complexImgPreview" class="complex-preview-list"></div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         하단 버튼
                         - 화면 하단에서도 초기화/저장 가능
                    ====================================================== -->
                    <div class="panel complex-footer-panel">
                        <div class="modal-footer complex-footer">
                            <button type="button" class="btn btn-secondary" id="btnResetComplexBottom">
                                <span class="material-symbols-rounded">refresh</span>
                                초기화
                            </button>

                            <button type="submit" class="btn btn-primary" id="btnSaveComplexBottom">
                                <span class="material-symbols-rounded">save</span>
                                저장
                            </button>
                        </div>
                    </div>

                </form>
            </div>
        </main>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        initComplexEditPage();
    });

    function initComplexEditPage() {
        /*
         * 화면 확인용 더미 데이터
         * 실제 DB 연결 시 서버에서 단지 정보 조회 후 model 또는 JSON으로 교체 예정
         */
        var complexData = {
            aptCmplexNo: "APT001",
            aptCmplexNm: "래미안 강남포레스트",
            bjdCd: "1168010500",
            sidoNm: "서울특별시",
            sigunguNm: "강남구",
            emdNm: "일원동",
            dorojuso: "서울특별시 강남구 개포로 621",
            latVal: 37.4870,
            lonVal: 127.0586,
            unitCnt: 2296,
            dongCnt: 15,
            maxFloor: 35,
            pkgCnt: 2800,
            freePkgCnt: 1,
            ccCnt: "120",
            bldYr: "20191122",
            heatTyCd: "DISTRICT",
            cnscoNm: "삼성물산",
            imgFileNo: "F0001",
            rprsntImgFileNo: "F0002"
        };

        function fillForm(data) {
            document.getElementById("aptCmplexNo").value = data.aptCmplexNo || "";
            document.getElementById("aptCmplexNm").value = data.aptCmplexNm || "";
            document.getElementById("bjdCd").value = data.bjdCd || "";
            document.getElementById("sidoNm").value = data.sidoNm || "";
            document.getElementById("sigunguNm").value = data.sigunguNm || "";
            document.getElementById("emdNm").value = data.emdNm || "";
            document.getElementById("dorojuso").value = data.dorojuso || "";
            document.getElementById("latVal").value = data.latVal || "";
            document.getElementById("lonVal").value = data.lonVal || "";
            document.getElementById("unitCnt").value = data.unitCnt || "";
            document.getElementById("dongCnt").value = data.dongCnt || "";
            document.getElementById("maxFloor").value = data.maxFloor || "";
            document.getElementById("pkgCnt").value = data.pkgCnt || "";
            document.getElementById("freePkgCnt").value = data.freePkgCnt !== undefined ? data.freePkgCnt : "";
            document.getElementById("ccCnt").value = data.ccCnt || "";
            document.getElementById("bldYr").value = data.bldYr || "";
            document.getElementById("heatTyCd").value = data.heatTyCd || "";
            document.getElementById("cnscoNm").value = data.cnscoNm || "";
            document.getElementById("imgFileNo").value = data.imgFileNo || "";
            document.getElementById("rprsntImgFileNo").value = data.rprsntImgFileNo || "";
        }

        function resetForm() {
            fillForm(complexData);

            document.getElementById("mainImgPreview").innerHTML = "";
            document.getElementById("complexImgPreview").innerHTML = "";
            document.getElementById("mainImgFileInput").value = "";
            document.getElementById("complexImgFileInput").value = "";
        }

        function validateForm() {
            var sidoNm = document.getElementById("sidoNm").value.trim();
            var sigunguNm = document.getElementById("sigunguNm").value.trim();
            var emdNm = document.getElementById("emdNm").value.trim();

            if (!sidoNm) {
                alert("시도명을 입력하세요.");
                document.getElementById("sidoNm").focus();
                return false;
            }

            if (!sigunguNm) {
                alert("시군구명을 입력하세요.");
                document.getElementById("sigunguNm").focus();
                return false;
            }

            if (!emdNm) {
                alert("읍면동명을 입력하세요.");
                document.getElementById("emdNm").focus();
                return false;
            }

            return true;
        }

        function saveComplex() {
            if (!validateForm()) return;

            /*
             * TODO
             * 실제 저장 연결 시 FormData로 multipart/form-data 전송
             * 대표 이미지/단지 사진 파일도 함께 서버로 전달
             */
            alert("단지 정보가 저장되었습니다.");
        }

        function createPreviewItem(src) {
            var wrap = document.createElement("div");
            wrap.className = "complex-preview-item";

            var img = document.createElement("img");
            img.src = src;
            img.className = "complex-preview-img";

            var removeBtn = document.createElement("button");
            removeBtn.type = "button";
            removeBtn.className = "complex-preview-remove";
            removeBtn.innerHTML = '<span class="material-symbols-rounded">close</span>';

            removeBtn.addEventListener("click", function () {
                wrap.remove();
            });

            wrap.appendChild(img);
            wrap.appendChild(removeBtn);

            return wrap;
        }

        function bindFilePreview(inputId, previewId, single) {
            document.getElementById(inputId).addEventListener("change", function () {
                var preview = document.getElementById(previewId);
                preview.innerHTML = "";

                var files = Array.from(this.files);

                if (single) {
                    files = files.slice(0, 1);
                } else {
                    files = files.slice(0, 5);
                }

                files.forEach(function (file) {
                    var reader = new FileReader();

                    reader.onload = function (event) {
                        preview.appendChild(createPreviewItem(event.target.result));
                    };

                    reader.readAsDataURL(file);
                });
            });
        }

        function bindUploadBox(areaId, inputId) {
            var area = document.getElementById(areaId);
            var input = document.getElementById(inputId);

            area.addEventListener("click", function () {
                input.click();
            });

            area.addEventListener("dragover", function (event) {
                event.preventDefault();
                area.classList.add("drag-over");
            });

            area.addEventListener("dragleave", function () {
                area.classList.remove("drag-over");
            });

            area.addEventListener("drop", function (event) {
                event.preventDefault();
                area.classList.remove("drag-over");

                input.files = event.dataTransfer.files;
                input.dispatchEvent(new Event("change"));
            });
        }

        document.getElementById("btnSaveComplex").addEventListener("click", saveComplex);
        document.getElementById("btnResetComplex").addEventListener("click", resetForm);
        document.getElementById("btnResetComplexBottom").addEventListener("click", resetForm);

        document.getElementById("complexEditForm").addEventListener("submit", function (event) {
            event.preventDefault();
            saveComplex();
        });

        bindFilePreview("mainImgFileInput", "mainImgPreview", true);
        bindFilePreview("complexImgFileInput", "complexImgPreview", false);

        bindUploadBox("mainImgUploadArea", "mainImgFileInput");
        bindUploadBox("complexImgUploadArea", "complexImgFileInput");

        fillForm(complexData);
    }
</script>
</body>
</html>