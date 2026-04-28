<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>단지 정보 수정</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        .complex-readonly {
            background: #f5f5f5;
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

    <%@ include file="../include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="../include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="complexEditPage">

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
                            수정
                        </button>
                    </div>
                </div>

                <form id="complexEditForm" enctype="multipart/form-data">
                    <input type="hidden" id="aptCmplexNo" name="aptCmplexNo" value="${complex.aptCmplexNo}">

                    <!-- =====================================================
                         섹션 1. 기본 정보
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
                                        <input type="text"
                                               class="form-input complex-readonly"
                                               id="aptCmplexNm"
                                               name="aptCmplexNm"
                                               value="${complex.aptCmplexNm}"
                                               readonly>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">법정동 코드</label>
                                        <input type="text"
                                               class="form-input"
                                               id="bjdCd"
                                               name="bjdCd"
                                               value="${complex.bjdCd}"
                                               placeholder="예: 1111010100">
                                    </div>
                                </div>

                                <div class="form-row cols-3">
                                    <div class="form-field">
                                        <label class="field-label">시도명 <span class="req">*</span></label>
                                        <input type="text"
                                               class="form-input"
                                               id="sidoNm"
                                               name="sidoNm"
                                               value="${complex.sidoNm}"
                                               placeholder="예: 서울특별시">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">시군구명 <span class="req">*</span></label>
                                        <input type="text"
                                               class="form-input"
                                               id="sigunguNm"
                                               name="sigunguNm"
                                               value="${complex.sigunguNm}"
                                               placeholder="예: 강남구">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">읍면동명 <span class="req">*</span></label>
                                        <input type="text"
                                               class="form-input"
                                               id="emdNm"
                                               name="emdNm"
                                               value="${complex.emdNm}"
                                               placeholder="예: 역삼동">
                                    </div>
                                </div>

                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">도로명 주소</label>
                                        <input type="text"
                                               class="form-input"
                                               id="dorojuso"
                                               name="dorojuso"
                                               value="${complex.dorojuso}"
                                               placeholder="예: 서울특별시 강남구 테헤란로 123">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         섹션 2. 위치 정보
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
                                        <input type="number"
                                               class="form-input"
                                               id="latVal"
                                               name="latVal"
                                               value="${complex.latVal}"
                                               step="0.0000001"
                                               placeholder="예: 37.5012743">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">경도</label>
                                        <input type="number"
                                               class="form-input"
                                               id="lonVal"
                                               name="lonVal"
                                               value="${complex.lonVal}"
                                               step="0.0000001"
                                               placeholder="예: 127.0396597">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         섹션 3. 단지 현황
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
                                        <input type="number"
                                               class="form-input"
                                               id="unitCnt"
                                               name="unitCnt"
                                               value="${complex.unitCnt}"
                                               min="0"
                                               placeholder="예: 500">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">동 수</label>
                                        <input type="number"
                                               class="form-input"
                                               id="dongCnt"
                                               name="dongCnt"
                                               value="${complex.dongCnt}"
                                               min="0"
                                               placeholder="예: 10">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">최대 층수</label>
                                        <input type="number"
                                               class="form-input"
                                               id="maxFloor"
                                               name="maxFloor"
                                               value="${complex.maxFloor}"
                                               min="0"
                                               placeholder="예: 25">
                                    </div>
                                </div>

                                <div class="form-row cols-3">
                                    <div class="form-field">
                                        <label class="field-label">주차 가능 대수</label>
                                        <input type="number"
                                               class="form-input"
                                               id="pkgCnt"
                                               name="pkgCnt"
                                               value="${complex.pkgCnt}"
                                               min="0"
                                               placeholder="예: 600">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">세대당 무료 주차 대수</label>
                                        <input type="number"
                                               class="form-input"
                                               id="freePkgCnt"
                                               name="freePkgCnt"
                                               value="${complex.freePkgCnt}"
                                               min="0"
                                               placeholder="예: 1">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">CCTV 수</label>
                                        <input type="text"
                                               class="form-input"
                                               id="ccCnt"
                                               name="ccCnt"
                                               value="${complex.ccCnt}"
                                               placeholder="예: 32">
                                    </div>
                                </div>

                                <div class="form-row cols-2">
                                    <div class="form-field">
                                        <label class="field-label">준공 연도</label>
                                        <input type="text"
                                               class="form-input"
                                               id="bldYr"
                                               name="bldYr"
                                               value="${complex.bldYr}"
                                               maxlength="8"
                                               placeholder="예: 20050301">
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">난방 방식</label>
                                        <select class="form-select" id="heatTy" name="heatTy">
                                            <option value="">선택</option>
                                            <option value="중앙난방" ${complex.heatTy eq '중앙난방' ? 'selected' : ''}>중앙난방</option>
                                            <option value="개별난방" ${complex.heatTy eq '개별난방' ? 'selected' : ''}>개별난방</option>
                                            <option value="지역난방" ${complex.heatTy eq '지역난방' ? 'selected' : ''}>지역난방</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="form-row cols-1">
                                    <div class="form-field">
                                        <label class="field-label">건설사명</label>
                                        <input type="text"
                                               class="form-input"
                                               id="cnscoNm"
                                               name="cnscoNm"
                                               value="${complex.cnscoNm}"
                                               placeholder="예: 현대건설">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         섹션 4. 단지 이미지
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
                                        <input type="text"
                                               class="form-input complex-readonly"
                                               id="rprsntImgFileNo"
                                               name="rprsntImgFileNo"
                                               value="${complex.rprsntImgFileNo}"
                                               placeholder="기존 파일 번호"
                                               readonly>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">대표 이미지 교체</label>

                                        <div id="mainImgUploadArea" class="complex-upload-box">
                                            <span class="material-symbols-rounded">add_photo_alternate</span>
                                            <div class="complex-upload-title">클릭하여 대표 이미지 업로드</div>
                                            <div class="complex-upload-desc">JPG, PNG · 최대 10MB</div>
                                        </div>

                                        <input type="file"
                                               id="mainImgFileInput"
                                               name="mainImgFile"
                                               accept="image/*"
                                               style="display:none;">

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
                                        <input type="text"
                                               class="form-input complex-readonly"
                                               id="imgFileNo"
                                               name="imgFileNo"
                                               value="${complex.imgFileNo}"
                                               placeholder="기존 파일 번호"
                                               readonly>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">단지 사진 추가/교체</label>

                                        <div id="complexImgUploadArea" class="complex-upload-box">
                                            <span class="material-symbols-rounded">add_photo_alternate</span>
                                            <div class="complex-upload-title">클릭하여 이미지 업로드</div>
                                            <div class="complex-upload-desc">JPG, PNG · 최대 10MB · 최대 5장</div>
                                        </div>

                                        <input type="file"
                                               id="complexImgFileInput"
                                               name="complexImgFiles"
                                               accept="image/*"
                                               multiple
                                               style="display:none;">

                                        <div id="complexImgPreview" class="complex-preview-list"></div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- =====================================================
                         하단 버튼
                    ====================================================== -->
                    <div class="panel complex-footer-panel">
                        <div class="modal-footer complex-footer">
                            <button type="button" class="btn btn-secondary" id="btnResetComplexBottom">
                                <span class="material-symbols-rounded">refresh</span>
                                초기화
                            </button>

                            <button type="submit" class="btn btn-primary" id="btnSaveComplexBottom">
                                <span class="material-symbols-rounded">save</span>
                                수정
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

        function resetForm() {
            document.getElementById("complexEditForm").reset();

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
            if (!validateForm()) {
                return;
            }

            var form = document.getElementById("complexEditForm");
            var formData = new FormData(form);

            // Spring Security CSRF 토큰 가져오기
            var csrfToken = document.querySelector("meta[name='_csrf']");
            var csrfHeader = document.querySelector("meta[name='_csrf_header']");

            var headers = {};

            if (csrfToken && csrfHeader) {
                headers[csrfHeader.getAttribute("content")] = csrfToken.getAttribute("content");
            }

            fetch("${pageContext.request.contextPath}/manager/complex/update", {
                method: "POST",
                headers: headers,
                body: formData
            })
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("서버 응답 오류" + response.status);
                }

                return response.json();
            })
            .then(function (result) {
                if (result.success) {
                    alert(result.message || "단지 정보가 수정되었습니다.");

                    var aptCmplexNo = document.getElementById("aptCmplexNo").value;
                    location.href = "${pageContext.request.contextPath}/manager/complex/edit?aptCmplexNo=" + encodeURIComponent(aptCmplexNo);
                } else {
                    alert(result.message || "수정 중 오류가 발생했습니다.");
                }
            })
            .catch(function (error) {
                console.error(error);
                alert("저장 요청 중 오류가 발생했습니다.");
            });
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
    }
</script>
</body>
</html>