<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

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
                저장
            </button>
        </div>
    </div>

    <form id="complexEditForm" enctype="multipart/form-data">
        <input type="hidden" id="aptCmplexNo" name="aptCmplexNo">

        <!-- ────────────────── 섹션 1: 기본 정보 ────────────────── -->
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
                                <span style="font-size:10px; color:var(--text-tertiary); font-weight:400; margin-left:6px;">※ 수정 불가</span>
                            </label>
                            <input type="text" class="form-input" id="aptCmplexNm" name="aptCmplexNm"
                                   readonly style="background:var(--bg-secondary,#f5f5f5); color:var(--text-tertiary); cursor:not-allowed;">
                        </div>

                        <div class="form-field">
                            <label class="field-label">법정동 코드 (BJD_CD)</label>
                            <input type="text" class="form-input" id="bjdCd" name="bjdCd" placeholder="예: 1111010100">
                        </div>
                    </div>

                    <div class="form-row cols-3">
                        <div class="form-field">
                            <label class="field-label">시도명 (SIDO_NM) <span class="req">*</span></label>
                            <input type="text" class="form-input" id="sidoNm" name="sidoNm" placeholder="예: 서울특별시">
                        </div>

                        <div class="form-field">
                            <label class="field-label">시군구명 (SIGUNGU_NM) <span class="req">*</span></label>
                            <input type="text" class="form-input" id="sigunguNm" name="sigunguNm" placeholder="예: 강남구">
                        </div>

                        <div class="form-field">
                            <label class="field-label">읍면동명 (EMD_NM) <span class="req">*</span></label>
                            <input type="text" class="form-input" id="emdNm" name="emdNm" placeholder="예: 역삼동">
                        </div>
                    </div>

                    <div class="form-row cols-1">
                        <div class="form-field">
                            <label class="field-label">도로명 주소 (DOROJUSO)</label>
                            <input type="text" class="form-input" id="dorojuso" name="dorojuso" placeholder="예: 서울특별시 강남구 테헤란로 123">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ────────────────── 섹션 2: 위치 정보 ────────────────── -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">
                    <span class="material-symbols-rounded">location_on</span>
                    위치 정보 - 지도로 보이게 수정할 예정
                </h3>
            </div>

            <div class="panel-body">
                <div class="form-section">
                    <div class="form-row cols-2">
                        <div class="form-field">
                            <label class="field-label">위도 (LAT_VAL)</label>
                            <input type="number" class="form-input" id="latVal" name="latVal"
                                   step="0.0000001" placeholder="예: 37.5012743">
                        </div>

                        <div class="form-field">
                            <label class="field-label">경도 (LON_VAL)</label>
                            <input type="number" class="form-input" id="lonVal" name="lonVal"
                                   step="0.0000001" placeholder="예: 127.0396597">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ────────────────── 섹션 3: 단지 현황 ────────────────── -->
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
                            <label class="field-label">세대 수 (UNIT_CNT)</label>
                            <input type="number" class="form-input" id="unitCnt" name="unitCnt"
                                   min="0" placeholder="예: 500">
                        </div>

                        <div class="form-field">
                            <label class="field-label">동 수 (DONG_CNT)</label>
                            <input type="number" class="form-input" id="dongCnt" name="dongCnt"
                                   min="0" placeholder="예: 10">
                        </div>

                        <div class="form-field">
                            <label class="field-label">최대 층수 (MAX_FLOOR)</label>
                            <input type="number" class="form-input" id="maxFloor" name="maxFloor"
                                   min="0" placeholder="예: 25">
                        </div>
                    </div>

                    <div class="form-row cols-3">
                        <div class="form-field">
                            <label class="field-label">주차 가능 대수 (PKG_CNT)</label>
                            <input type="number" class="form-input" id="pkgCnt" name="pkgCnt"
                                   min="0" placeholder="예: 600">
                        </div>

                        <div class="form-field">
                            <label class="field-label">세대당 무료 주차 대수 (FREE_PKG_CNT)</label>
                            <input type="number" class="form-input" id="freePkgCnt" name="freePkgCnt"
                                   min="0" placeholder="예: 1">
                        </div>

                        <div class="form-field">
                            <label class="field-label">CCTV 수 (CC_CNT)</label>
                            <input type="text" class="form-input" id="ccCnt" name="ccCnt"
                                   placeholder="예: 32">
                        </div>
                    </div>

                    <div class="form-row cols-2">
                        <div class="form-field">
                            <label class="field-label">준공 연도 (BLD_YR)</label>
                            <input type="text" class="form-input" id="bldYr" name="bldYr"
                                   maxlength="8" placeholder="예: 20050301">
                        </div>

                        <div class="form-field">
                            <label class="field-label">난방 방식 코드 (HEAT_TY_CD)</label>
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
                            <label class="field-label">건설사명 (CNSCO_NM)</label>
                            <input type="text" class="form-input" id="cnscoNm" name="cnscoNm"
                                   placeholder="예: 현대건설">
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ────────────────── 섹션 4: 이미지 ────────────────── -->
        <div class="panel">
            <div class="panel-header">
                <h3 class="panel-title">
                    <span class="material-symbols-rounded">photo_library</span>
                    단지 이미지
                </h3>
            </div>

            <div class="panel-body">
                <div class="form-section">

                    <!-- 대표 이미지 -->
                    <div class="form-section-title">
                        <span class="material-symbols-rounded">star</span>
                        대표 이미지
                    </div>

                    <div class="form-row cols-2">
                        <div class="form-field">
                            <label class="field-label">현재 대표 이미지 번호 (RPRSNT_IMG_FILE_NO)</label>
                            <input type="text" class="form-input" id="rprsntImgFileNo" name="rprsntImgFileNo"
                                   placeholder="기존 파일 번호" readonly
                                   style="background:var(--bg-secondary,#f5f5f5); color:var(--text-tertiary);">
                        </div>

                        <div class="form-field">
                            <label class="field-label">대표 이미지 교체</label>
                            <div id="mainImgUploadArea"
                                 style="border:2px dashed var(--border); border-radius:8px; padding:16px; text-align:center; cursor:pointer; transition:0.15s; background:#fafafa;"
                                 onclick="document.getElementById('mainImgFileInput').click()">
                                <span class="material-symbols-rounded" style="font-size:28px; color:var(--text-tertiary); display:block; margin-bottom:4px;">add_photo_alternate</span>
                                <div style="font-size:13px; color:var(--text-secondary); font-weight:600;">클릭하여 대표 이미지 업로드</div>
                                <div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">JPG, PNG · 최대 10MB</div>
                            </div>
                            <input type="file" id="mainImgFileInput" name="mainImgFile" accept="image/*" style="display:none;">
                            <div id="mainImgPreview" style="margin-top:10px;"></div>
                        </div>
                    </div>

                    <!-- 일반 이미지 -->
                    <div class="form-section-title" style="margin-top:16px;">
                        <span class="material-symbols-rounded">collections</span>
                        단지 사진
                    </div>

                    <div class="form-row cols-2">
                        <div class="form-field">
                            <label class="field-label">현재 이미지 파일 번호 (IMG_FILE_NO)</label>
                            <input type="text" class="form-input" id="imgFileNo" name="imgFileNo"
                                   placeholder="기존 파일 번호" readonly
                                   style="background:var(--bg-secondary,#f5f5f5); color:var(--text-tertiary);">
                        </div>

                        <div class="form-field">
                            <label class="field-label">단지 사진 추가/교체</label>
                            <div id="complexImgUploadArea"
                                 style="border:2px dashed var(--border); border-radius:8px; padding:16px; text-align:center; cursor:pointer; transition:0.15s; background:#fafafa;"
                                 onclick="document.getElementById('complexImgFileInput').click()">
                                <span class="material-symbols-rounded" style="font-size:28px; color:var(--text-tertiary); display:block; margin-bottom:4px;">add_photo_alternate</span>
                                <div style="font-size:13px; color:var(--text-secondary); font-weight:600;">클릭하여 이미지 업로드 (다중 선택 가능)</div>
                                <div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">JPG, PNG · 최대 10MB · 최대 5장</div>
                            </div>
                            <input type="file" id="complexImgFileInput" name="complexImgFiles" accept="image/*" multiple style="display:none;">
                            <div id="complexImgPreview" style="display:flex; gap:8px; flex-wrap:wrap; margin-top:10px;"></div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- ────────────────── 하단 버튼 ────────────────── -->
        <div class="panel" style="padding:0;">
            <div class="modal-footer" style="border-top:none; padding:16px 20px;">
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
</div><!-- /office-page -->


<script>
    (function () {

        /* ──────────────── 더미 데이터 (실제 환경에서는 서버에서 ${complex} 등 EL로 채움) ──────────────── */
        var complexData = {
            aptCmplexNo    : "APT001",
            aptCmplexNm    : "래미안 강남포레스트",
            bjdCd          : "1168010500",
            sidoNm         : "서울특별시",
            sigunguNm      : "강남구",
            emdNm          : "일원동",
            dorojuso       : "서울특별시 강남구 개포로 621",
            latVal         : 37.4870,
            lonVal         : 127.0586,
            unitCnt        : 2296,
            dongCnt        : 15,
            maxFloor       : 35,
            pkgCnt         : 2800,
            freePkgCnt     : 1,
            ccCnt          : "120",
            bldYr          : "20191122",
            heatTyCd       : "DISTRICT",
            cnscoNm        : "삼성물산",
            imgFileNo      : "F0001",
            rprsntImgFileNo: "F0002"
        };

        /* ──────────────── 폼 채우기 ──────────────── */
        function fillForm(data) {
            document.getElementById("aptCmplexNo").value     = data.aptCmplexNo      || "";
            document.getElementById("aptCmplexNm").value     = data.aptCmplexNm      || "";
            document.getElementById("bjdCd").value           = data.bjdCd            || "";
            document.getElementById("sidoNm").value          = data.sidoNm           || "";
            document.getElementById("sigunguNm").value       = data.sigunguNm        || "";
            document.getElementById("emdNm").value           = data.emdNm            || "";
            document.getElementById("dorojuso").value        = data.dorojuso         || "";
            document.getElementById("latVal").value          = data.latVal           || "";
            document.getElementById("lonVal").value          = data.lonVal           || "";
            document.getElementById("unitCnt").value         = data.unitCnt          || "";
            document.getElementById("dongCnt").value         = data.dongCnt          || "";
            document.getElementById("maxFloor").value        = data.maxFloor         || "";
            document.getElementById("pkgCnt").value          = data.pkgCnt           || "";
            document.getElementById("freePkgCnt").value      = data.freePkgCnt       !== undefined ? data.freePkgCnt : "";
            document.getElementById("ccCnt").value           = data.ccCnt            || "";
            document.getElementById("bldYr").value           = data.bldYr            || "";
            document.getElementById("heatTyCd").value        = data.heatTyCd         || "";
            document.getElementById("cnscoNm").value         = data.cnscoNm          || "";
            document.getElementById("imgFileNo").value       = data.imgFileNo        || "";
            document.getElementById("rprsntImgFileNo").value = data.rprsntImgFileNo  || "";
        }

        /* ──────────────── 폼 초기화 ──────────────── */
        function resetForm() {
            fillForm(complexData);
            document.getElementById("mainImgPreview").innerHTML    = "";
            document.getElementById("complexImgPreview").innerHTML = "";
            document.getElementById("mainImgFileInput").value      = "";
            document.getElementById("complexImgFileInput").value   = "";
        }

        /* ──────────────── 유효성 검사 ──────────────── */
        function validateForm() {
            var sidoNm    = document.getElementById("sidoNm").value.trim();
            var sigunguNm = document.getElementById("sigunguNm").value.trim();
            var emdNm     = document.getElementById("emdNm").value.trim();

            if (!sidoNm)    { alert("시도명을 입력하세요.");   document.getElementById("sidoNm").focus();    return false; }
            if (!sigunguNm) { alert("시군구명을 입력하세요."); document.getElementById("sigunguNm").focus(); return false; }
            if (!emdNm)     { alert("읍면동명을 입력하세요."); document.getElementById("emdNm").focus();     return false; }
            return true;
        }

        /* ──────────────── 저장 ──────────────── */
        function saveComplex() {
            if (!validateForm()) return;
            // TODO: 실제 AJAX 또는 form submit 연결
            alert("단지 정보가 저장되었습니다.");
        }

        /* ──────────────── 이미지 미리보기 공통 함수 ──────────────── */
        function bindFilePreview(inputId, previewId, single) {
            document.getElementById(inputId).addEventListener("change", function () {
                var preview = document.getElementById(previewId);
                preview.innerHTML = "";
                var files = Array.from(this.files);

                if (single) { files = files.slice(0, 1); }
                else        { files = files.slice(0, 5); }

                files.forEach(function (file) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var wrap = document.createElement("div");
                        wrap.style.cssText = "position:relative; width:80px; height:80px;";

                        var img = document.createElement("img");
                        img.src = e.target.result;
                        img.style.cssText = "width:80px; height:80px; object-fit:cover; border-radius:6px; border:1px solid var(--border);";

                        var del = document.createElement("button");
                        del.type = "button";
                        del.innerHTML = '<span class="material-symbols-rounded" style="font-size:14px;">close</span>';
                        del.style.cssText = "position:absolute; top:-6px; right:-6px; width:20px; height:20px; border-radius:50%; background:#991b1b; color:#fff; border:none; cursor:pointer; display:flex; align-items:center; justify-content:center; padding:0;";
                        del.onclick = function () { wrap.remove(); };

                        wrap.appendChild(img);
                        wrap.appendChild(del);
                        preview.appendChild(wrap);
                    };
                    reader.readAsDataURL(file);
                });
            });
        }

        /* ──────────────── 드래그앤드롭 ──────────────── */
        function bindDragDrop(areaId, inputId) {
            var area = document.getElementById(areaId);
            area.addEventListener("dragover", function (e) {
                e.preventDefault();
                this.style.borderColor = "#2e5c38";
                this.style.background  = "#f0f7f2";
            });
            area.addEventListener("dragleave", function () {
                this.style.borderColor = "var(--border)";
                this.style.background  = "#fafafa";
            });
            area.addEventListener("drop", function (e) {
                e.preventDefault();
                this.style.borderColor = "var(--border)";
                this.style.background  = "#fafafa";
                document.getElementById(inputId).files = e.dataTransfer.files;
                document.getElementById(inputId).dispatchEvent(new Event("change"));
            });
        }

        /* ──────────────── 이벤트 바인딩 ──────────────── */
        document.getElementById("btnSaveComplex").addEventListener("click", saveComplex);
        document.getElementById("btnResetComplex").addEventListener("click", resetForm);
        document.getElementById("btnResetComplexBottom").addEventListener("click", resetForm);

        document.getElementById("complexEditForm").addEventListener("submit", function (e) {
            e.preventDefault();
            saveComplex();
        });

        bindFilePreview("mainImgFileInput",    "mainImgPreview",    true);
        bindFilePreview("complexImgFileInput", "complexImgPreview", false);
        bindDragDrop("mainImgUploadArea",    "mainImgFileInput");
        bindDragDrop("complexImgUploadArea", "complexImgFileInput");

        /* ──────────────── 초기 데이터 로드 ──────────────── */
        fillForm(complexData);

    })();
</script>
