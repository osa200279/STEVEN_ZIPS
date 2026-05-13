"use strict";

/* =========================================================
   초기 실행
========================================================= */

document.addEventListener("DOMContentLoaded", function () {
    initComplexEditPage();
});

/* =========================================================
   메인 초기화
========================================================= */

function initComplexEditPage() {

    bindEvents();

    bindFileAddButtons();
    bindFileInputs();

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

function resetForm() {

    document.getElementById("complexEditForm").reset();

    document.getElementById("mainImgPreview").innerHTML = "";
    document.getElementById("complexImgPreview").innerHTML = "";

    document.getElementById("mainImgFileInput").value = "";
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

/* =========================================================
   이미지 미리보기 생성
========================================================= */

function createPreviewItem(src) {

    const wrap = document.createElement("div");

    wrap.className = "complex-preview-item";

    const img = document.createElement("img");

    img.src = src;
    img.className = "complex-preview-img";

    const removeBtn = document.createElement("button");

    removeBtn.type = "button";
    removeBtn.className = "complex-preview-remove";

    removeBtn.innerHTML =
        '<span class="material-symbols-rounded">close</span>';

    removeBtn.addEventListener("click", function () {

        wrap.remove();
    });

    wrap.appendChild(img);
    wrap.appendChild(removeBtn);

    return wrap;
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

            renderSelectedFiles(
                "layoutFileList",
                files
            );
        });

    // 단지 사진
    document.getElementById("complexImgFileInput")
        ?.addEventListener("change", function (e) {

            const files = Array.from(e.target.files);

            console.log("단지사진", files);

            renderSelectedFiles(
                "complexImageFileList",
                files
            );
        });
}

/* =========================================================
   파일 리스트 렌더링
========================================================= */

function renderSelectedFiles(listId, files) {

    const list =
        document.getElementById(listId);

    files.forEach(function (file) {

        const item =
            createFileItem(file);

        list.appendChild(item);
    });
}

/* =========================================================
   파일 아이템 생성
========================================================= */

function createFileItem(file) {

    const item = document.createElement("div");

    item.className = "complex-file-item";

    item.innerHTML = `

        <div class="complex-file-name">

            <span class="material-symbols-rounded">
                image
            </span>

            <span class="complex-file-name-text">
                ${file.name}
            </span>

        </div>

        <button type="button"
                class="complex-file-remove">

            <span class="material-symbols-rounded">
                close
            </span>

        </button>

    `;

    const previewUrl = URL.createObjectURL(file);

    const preview = document.createElement("div");

    preview.className = "complex-thumb-preview";

    preview.innerHTML = `
    <img src="${previewUrl}">
`;

    item.appendChild(preview);

    item.querySelector(".complex-file-remove")
        .addEventListener("click", function () {

            item.remove();
        });

    return item;
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
            ghostClass: "sortable-ghost"
        }
    );

    // 단지사진
    Sortable.create(
        document.getElementById("complexImageFileList"),
        {
            animation: 150,
            ghostClass: "sortable-ghost"
        }
    );
}