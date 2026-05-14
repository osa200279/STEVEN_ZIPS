"use strict";



/* =========================================================
   초기 실행
========================================================= */

document.addEventListener("DOMContentLoaded", function () {
    initComplexEditPage();
});

const complexFileState = {
    layout: [],
    complex: []
};
let layoutSortable = null;
let complexSortable = null;
/* =========================================================
   메인 초기화
========================================================= */

async function initComplexEditPage() {

    bindEvents();

    bindFileAddButtons();
    bindFileInputs();

    await loadComplexDetail();

    initSortable();
}


/* =========================================================
   이벤트 바인딩
========================================================= */

function bindEvents() {

    document.getElementById("complexEditForm")
        ?.addEventListener("submit", function (event) {

            event.preventDefault();

            saveComplex();
        });
}

/* =========================================================
   폼 초기화
========================================================= */

async function resetForm() {

    document.getElementById("complexEditForm").reset();

    complexFileState.layout = [];
    complexFileState.complex = [];

    await loadComplexDetail();

    document.getElementById("layoutFileInput").value = "";
    document.getElementById("complexImgFileInput").value = "";
}

/* =========================================================
   저장
========================================================= */

async function saveComplex() {

    const form =
        document.getElementById("complexEditForm");

    const formData =
        new FormData(form);

    appendFilesToFormData(formData);
    appendSortOrderToFormData(formData);

    const csrfToken =
        document.querySelector("meta[name='_csrf']");

    const csrfHeader =
        document.querySelector("meta[name='_csrf_header']");

    const headers = {};

    if (csrfToken && csrfHeader) {

        headers[
            csrfHeader.getAttribute("content")
            ] = csrfToken.getAttribute("content");
    }

    try {

        const response =
            await fetch(
                CONTEXT_PATH
                + "/manager/complex/update/"
                + MGMT_OFC_NO,
                {
                    method: "POST",
                    headers: headers,
                    body: formData
                }
            );

        if(!response.ok){
            throw new Error(
                "서버 응답 오류 : "
                + response.status
            );
        }

        const result =
            await response.json();

        if(result.success){

            alert(
                result.message
                || "단지 정보가 수정되었습니다."
            );


            complexFileState.layout = [];
            complexFileState.complex = [];

            await loadComplexDetail();

        }else{

            alert(
                result.message
                || "수정 중 오류가 발생했습니다."
            );
        }

    } catch(error){

        console.error(error);

        alert("저장 요청 중 오류가 발생했습니다.");
    }
}

const syncButton =
    document.getElementById("btnSyncAddress");

syncButton?.addEventListener("click", function () {

    syncButton.classList.add("syncing");


    setTimeout(function () {

        syncButton.classList.remove("syncing");

    }, 1500);
});


/* =========================================================
   파일 추가 버튼
========================================================= */

function bindFileAddButtons() {

    document.getElementById("btnAddLayout")
        ?.addEventListener("click", function () {

            document.getElementById("layoutFileInput").click();
        });

    document.getElementById("btnAddComplexImage")
        ?.addEventListener("click", function () {

            document.getElementById("complexImgFileInput").click();
        });
}

/* =========================================================
   파일 선택
========================================================= */

function bindFileInputs() {

    // 배치도
    document.getElementById("layoutFileInput")
        ?.addEventListener("change", function (e) {

            const files = Array.from(e.target.files);

            console.log("배치도", files);

            handleSelectedFiles(
                "layout",
                files
            );
        });

    // 단지 사진
    document.getElementById("complexImgFileInput")
        ?.addEventListener("change", function (e) {

            const files = Array.from(e.target.files);

            console.log("단지사진", files);

            handleSelectedFiles(
                "complex",
                files
            );
        });
}

/* =========================================================
   파일 리스트 렌더링
========================================================= */

/**
 * 여러개의 file 을 for문돌려서 순서대로 add하기 위해서 만듬
 * add 후에 랜더링 해서 순서대로 띄워줌
 * @param category 배치도인지, 단지 사진인지 구분용 파라메타
 * @param files 파일들 정보
 */
function handleSelectedFiles(category, files) {

    files.forEach(function(file){

        addNewFile(category, file);

    });

    renderFileList(category);
}

/**
 * 신규 파일 추가
 * @param category 배치도인지, 단지사진인지 구분용 파라메타
 * @param file 파일정보
 */
function addNewFile(category, file) {

    document.getElementById("isImageChanged").value = "Y";

    const targetList =
        complexFileState[category];

    targetList.push({
        fileKey: "new_" + crypto.randomUUID(),
        fileType: "new",
        file: file,
        fileOgName: file.name,
        fileSortOrder: targetList.length
    });
}

/**
 * 파일 랜더링용 함수 순서대로 띄워줘야하기에
 * @param category 배치도인지 단지사진인지 구분용
 */
function renderFileList(category) {

    const listEl = getListElement(category);

    listEl.innerHTML = "";

    complexFileState[category]
        .forEach(function(fileItem, index){

            fileItem.fileSortOrder = index;

            const itemEl =
                createFileItemElement(category, fileItem);

            listEl.appendChild(itemEl);
        });
}




function createFileItemElement(category, fileItem) {

    const item = document.createElement("div");

    item.className = "complex-file-item";

    item.dataset.fileKey = fileItem.fileKey;
    item.dataset.fileType = fileItem.fileType;

    item.dataset.fileGroupNo =
        fileItem.fileGroupNo || "";

    item.dataset.fileSaveUuid =
        fileItem.fileSaveUuid || "";

    item.dataset.googleId =
        fileItem.googleId || "";

    item.dataset.fileSortOrder =
        fileItem.fileSortOrder;

    let previewUrl = "";

    if(fileItem.fileType === "new"){
        previewUrl =
            URL.createObjectURL(fileItem.file);

    }else{
        previewUrl =
            CONTEXT_PATH
            + "/file/display/"
            + fileItem.googleId;
    }

    item.innerHTML = `

    <div class="complex-file-main">
    
        <div class="complex-file-info">
    
            <div class="complex-file-name">
    
                ${fileItem.fileOgName}
    
                <div class="complex-thumb-hover">
                    <img src="${previewUrl}"
                         class="complex-thumb-img">
                </div>
    
            </div>
    
        </div>
    
    </div>
    
    <button type="button"
            class="complex-file-remove">
    
        <span class="material-symbols-rounded">
            close
        </span>
    
    </button>
    `;

    item.querySelector(".complex-file-remove")
        .addEventListener("click", function(){

            removeFile(category, fileItem.fileKey);

        });

    return item;
}


/**
 *
 * @param category
 * @returns {HTMLElement|null}
 */
function getListElement(category) {

    if(category === "layout"){
        return document.getElementById("layoutFileList");
    }

    if(category === "complex"){
        return document.getElementById("complexImageFileList");
    }

    return null;
}


/**
 * 파일삭제용
 * @param category
 * @param fileKey
 */
function removeFile(category, fileKey){

    document.getElementById("isImageChanged").value = "Y";

    complexFileState[category] =
        complexFileState[category]
            .filter(item => item.fileKey !== fileKey);

    renderFileList(category);
}

/* =========================================================
   파일 정렬
========================================================= */

function initSortable() {

    if(layoutSortable){
        layoutSortable.destroy();
    }

    if(complexSortable){
        complexSortable.destroy();
    }

    layoutSortable = Sortable.create(
        document.getElementById("layoutFileList"),
        {
            animation: 150,
            ghostClass: "sortable-ghost",
            onEnd: function () {

                syncSortOrder("layout");
            }
        }
    );

    complexSortable = Sortable.create(
        document.getElementById("complexImageFileList"),
        {
            animation: 150,
            ghostClass: "sortable-ghost",
            onEnd: function () {

                syncSortOrder("complex");
            }
        }
    );
}

function loadExistFileItems(category, files){

    complexFileState[category] = [];

    files.forEach(function(file){

        complexFileState[category].push({

            fileKey:
                "old_" + file.fileSaveUuid,

            fileType: "old",

            fileGroupNo:
            file.fileGroupNo,

            fileSaveUuid:
            file.fileSaveUuid,

            googleId:
            file.googleId,

            fileOgName:
            file.fileOgName,

            filePath:
            file.filePath,

            fileSortOrder:
            file.fileSortOrder
        });

    });

    renderFileList(category);
}

function syncSortOrder(category){

    document.getElementById("isImageChanged").value = "Y";

    const listEl =
        getListElement(category);

    const orderedKeys =
        Array.from(
            listEl.querySelectorAll(".complex-file-item")
        ).map(el => el.dataset.fileKey);

    complexFileState[category]
        .sort((a, b) => {

            return orderedKeys.indexOf(a.fileKey)
                - orderedKeys.indexOf(b.fileKey);
        });
}

function appendFilesToFormData(formData){

    complexFileState.layout
        .forEach(function(fileItem){

            if(fileItem.fileType === "new"){

                formData.append(
                    "layoutFiles",
                    fileItem.file
                );
            }
        });

    complexFileState.complex
        .forEach(function(fileItem){

            if(fileItem.fileType === "new"){

                formData.append(
                    "complexImgFiles",
                    fileItem.file
                );
            }
        });
}

function appendSortOrderToFormData(formData){

    formData.set(
        "layoutSortOrder",
        JSON.stringify(
            complexFileState.layout.map(item => ({
                fileKey: item.fileKey,
                fileType: item.fileType,
                fileSaveUuid: item.fileSaveUuid || null,
                fileSortOrder: item.fileSortOrder
            }))
        )
    );

    formData.set(
        "complexSortOrder",
        JSON.stringify(
            complexFileState.complex.map(item => ({
                fileKey: item.fileKey,
                fileType: item.fileType,
                fileSaveUuid: item.fileSaveUuid || null,
                fileSortOrder: item.fileSortOrder
            }))
        )
    );
}

async function loadComplexDetail() {

    try {

        const response =
            await fetch(
                CONTEXT_PATH
                + "/manager/complex/detail/"
                + MGMT_OFC_NO
            );

        if(!response.ok){
            throw new Error("상세조회 실패");
        }

        const result =
            await response.json();

        renderComplexDetail(result);

        loadExistFileItems(
            "layout",
            result.layoutFiles || []
        );

        loadExistFileItems(
            "complex",
            result.complexFiles || []
        );

    } catch(error) {

        console.error(error);

        alert("단지 정보를 불러오지 못했습니다.");
    }

    document.getElementById("isImageChanged").value = "N";
}

function renderComplexDetail(detail) {

    const complex = detail.complex;

    /*
        기본 정보
     */
    setValue(
        "aptCmplexNo",
        complex.aptCmplexNo
    );

    setValue(
        "aptCmplexNm",
        complex.aptCmplexNm
    );

    setValue(
        "bjdCd",
        complex.bjdCd
    );

    setValue(
        "latVal",
        complex.latVal
    );

    setValue(
        "lonVal",
        complex.lonVal
    );

    setValue(
        "sidoNm",
        complex.sidoNm
    );

    setValue(
        "sigunguNm",
        complex.sigunguNm
    );

    setValue(
        "emdNm",
        complex.emdNm
    );

    setValue(
        "dorojuso",
        complex.dorojuso
    );

    /*
        단지 현황
     */
    setValue(
        "unitCnt",
        complex.unitCnt
    );

    setValue(
        "dongCnt",
        complex.dongCnt
    );

    setValue(
        "maxFloor",
        complex.maxFloor
    );

    setValue(
        "pkgCnt",
        complex.pkgCnt
    );

    setValue(
        "freePkgCnt",
        complex.freePkgCnt
    );

    setValue(
        "ccCnt",
        complex.ccCnt
    );

    setValue(
        "bldYr",
        complex.bldYr
    );

    setValue(
        "cnscoNm",
        complex.cnscoNm
    );

    document.getElementById("heatTy").value =
        complex.heatTy || "";

    setValue(
        "imgFileNo",
        complex.imgFileNo
    );

    setValue(
        "rprsntImgFileNo",
        complex.rprsntImgFileNo
    );
}

function setValue(id, value) {

    const element =
        document.getElementById(id);

    if(!element){
        return;
    }

    element.value = value || "";
}