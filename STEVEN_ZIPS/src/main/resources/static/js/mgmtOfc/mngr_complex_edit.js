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

/* =========================================================
   메인 초기화
========================================================= */

function initComplexEditPage() {

    bindEvents();

    bindFileAddButtons();
    bindFileInputs();

    loadExistFiles();

    initSortable();
}


/* =========================================================
   이벤트 바인딩
========================================================= */

function bindEvents() {

    document.getElementById("btnSaveComplex")
        ?.addEventListener("click", saveComplex);

    document.getElementById("btnResetComplex")
        ?.addEventListener("click", resetForm);

    document.getElementById("btnResetComplexBottom")
        ?.addEventListener("click", resetForm);

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

    renderFileList("layout");
    renderFileList("complex");

    await loadExistFiles();

    document.getElementById("layoutFileInput").value = "";
    document.getElementById("complexImgFileInput").value = "";
}

/* =========================================================
   유효성 검사
========================================================= */

function validateForm() {

    const sidoNm = document.getElementById("sidoNm").value.trim();
    const sigunguNm = document.getElementById("sigunguNm").value.trim();
    const emdNm = document.getElementById("emdNm").value.trim();

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

/* =========================================================
   저장
========================================================= */

function saveComplex() {

    if (!validateForm()) {
        return;
    }

    const form = document.getElementById("complexEditForm");

    const formData = new FormData(form);

    appendFilesToFormData(formData);
    appendSortOrderToFormData(formData);

    const csrfToken =
        document.querySelector("meta[name='_csrf']");

    const csrfHeader =
        document.querySelector("meta[name='_csrf_header']");

    const headers = {};

    if (csrfToken && csrfHeader) {

        headers[csrfHeader.getAttribute("content")]
            = csrfToken.getAttribute("content");
    }

    fetch(
        CONTEXT_PATH + "/manager/complex/update/" + MGMT_OFC_NO,
        {
            method: "POST",
            headers: headers,
            body: formData
        }
    )
        .then(function (response) {

            if (!response.ok) {

                throw new Error("서버 응답 오류 : " + response.status);
            }

            return response.json();
        })
        .then(function (result) {

            if (result.success) {

                alert(result.message || "단지 정보가 수정되었습니다.");

                location.href =
                    CONTEXT_PATH + "/manager/complex/edit/" + MGMT_OFC_NO;

            } else {

                alert(result.message || "수정 중 오류가 발생했습니다.");
            }
        })
        .catch(function (error) {

            console.error(error);

            alert("저장 요청 중 오류가 발생했습니다.");
        });
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
            fileItem.filePath;
    }

    item.innerHTML = `

    <div class="complex-file-main">

        <div class="complex-thumb-wrap">

            <img src="${previewUrl}"
                 class="complex-thumb-img">

        </div>

        <div class="complex-file-info">

            <div class="complex-file-name">
                ${fileItem.fileOgName}
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

    complexFileState[category] =
        complexFileState[category]
            .filter(item => item.fileKey !== fileKey);

    renderFileList(category);
}

/* =========================================================
   파일 정렬
========================================================= */

function initSortable() {

    // 배치도
    Sortable.create(
        document.getElementById("layoutFileList"),
        {
            animation: 150,
            ghostClass: "sortable-ghost",
            onEnd: function () {

                syncSortOrder("layout");
            }
        }
    );

    // 단지사진
    Sortable.create(
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

async function loadExistFiles() {

    try{

        const response =
            await fetch(
                CONTEXT_PATH
                + "/manager/complex/files/"
                + MGMT_OFC_NO
            );

        const result =
            await response.json();

        loadExistFileItems(
            "layout",
            result.layoutFiles || []
        );

        loadExistFileItems(
            "complex",
            result.complexFiles || []
        );

    }catch(error){

        console.error(error);
    }
}

function loadExistFileItems(category, files){

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

    renderFileList(category);
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

    formData.append(
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

    formData.append(
        "complexSortOrder",
        JSON.stringify(
            complexFileState.layout.map(item => ({
                fileKey: item.fileKey,
                fileType: item.fileType,
                fileSaveUuid: item.fileSaveUuid || null,
                fileSortOrder: item.fileSortOrder
            }))
        )
    );
}