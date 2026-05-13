document.addEventListener("DOMContentLoaded", async () => {

    const wrap = document.querySelector(".unit-manage-wrap");

    const mgmtOfcNo = wrap.dataset.mgmtOfcNo;

    // =========================
    // 컬럼 정의
    // =========================
    const columnDefs = [

        {
            headerName: "동",
            field: "dongNm",

            comparator: (a, b) => {
                return Number(a) - Number(b);
            },

            sort: "asc"
        },

        {
            headerName: "호",
            field: "ho",

            comparator: (a, b) => {
                return Number(a) - Number(b);
            },

            sort: "asc"
        },

        {
            headerName: "층",
            field: "floor",
            width: 90
        },

        {
            headerName: "호 타입",
            field: "tyNm",
            width: 140
        },

        {
            headerName: "이미지",
            field: "imageNo",
            flex: 1,
            valueFormatter: params => params.value || "-"
        },

        {
            headerName: "파노라마",
            field: "panoImageNo",
            flex: 1,
            valueFormatter: params => params.value || "-"
        },

        {
            headerName: "상태",
            field: "hoSttsCd",
            width: 140,

            valueFormatter: params => {

                switch (params.value) {

                    case "EMPTY":
                        return "공실";

                    case "LIVE":
                        return "거주중";

                    default:
                        return params.value;
                }
            }
        }

    ];

    // =========================
    // Grid 생성
    // =========================
    const gridApi = agGrid.createGrid(

        document.querySelector("#unitGrid"),

        {
            columnDefs,

            rowData: [],

            defaultColDef: {
                sortable: true,
                filter: true,
                resizable: true
            },

            alwaysMultiSort: true,

            rowSelection: {
                mode: "multiRow",

                checkboxes: true,

                headerCheckbox: true,

                enableClickSelection: true,

                enableSelectionWithoutKeys: true
            },

            animateRows: true
        }
    );

    // =========================
    // 데이터 조회
    // =========================
    try {

        const response = await fetch(
            `/manager/complex/list/${mgmtOfcNo}`
        );

        if (!response.ok) {
            throw new Error("호 목록 조회 실패");
        }

        const data = await response.json();

        console.log(data);

        gridApi.setGridOption(
            "rowData",
            data
        );

    } catch (error) {

        console.error(error);

    }

// ======================================
// 평형 타입 Drawer
// =====================================

const btnOpenTypeDrawer =
    document.querySelector("#btnOpenTypeDrawer");

const btnCloseTypeDrawer =
    document.querySelector("#btnCloseTypeDrawer");

const hoTypeDrawer =
    document.querySelector("#hoTypeDrawer");

const drawerBackdrop =
    document.querySelector("#drawerBackdrop");

const hoTypeList = document.querySelector("#hoTypeList");

btnOpenTypeDrawer.addEventListener("click", async () => {

    hoTypeDrawer.classList.add("open");

    drawerBackdrop.classList.add("show");

    await loadHoTypeList();

});


// 닫기
btnCloseTypeDrawer.addEventListener("click", closeTypeDrawer);

drawerBackdrop.addEventListener("click", closeTypeDrawer);

function closeTypeDrawer(){

    hoTypeDrawer.classList.remove("open");

    drawerBackdrop.classList.remove("show");

}


// ======================================
// 평형 타입 추가 모달
// ======================================

const btnOpenTypeModal =
    document.querySelector("#btnOpenTypeModal");

const btnCloseTypeModal =
    document.querySelector("#btnCloseTypeModal");

const btnCancelTypeModal =
    document.querySelector("#btnCancelTypeModal");

const hoTypeModal =
    document.querySelector("#hoTypeModal");

const hoTypeModalBackdrop =
    document.querySelector("#hoTypeModalBackdrop");

// 열기
btnOpenTypeModal.addEventListener("click", () => {

    hoTypeModal.classList.add("show");

    hoTypeModalBackdrop.classList.add("show");

});

// 닫기
btnCloseTypeModal.addEventListener("click", closeTypeModal);

btnCancelTypeModal.addEventListener("click", closeTypeModal);

hoTypeModalBackdrop.addEventListener("click", closeTypeModal);

function closeTypeModal(){

    hoTypeModal.classList.remove("show");

    hoTypeModalBackdrop.classList.remove("show");

}

// ======================================
// 이미지 업로드 미리보기
// ======================================

const hoUploadBox =
    document.querySelector("#hoUploadBox");

const hoTypeImage =
    document.querySelector("#hoTypeImage");

const hoPreviewCard =
    document.querySelector("#hoPreviewCard");

const hoUploadContent =
    document.querySelector(".upload-content");

const hoPreviewImg =
    document.querySelector("#hoPreviewImg");

const hoRemoveBtn =
    document.querySelector("#hoRemoveBtn");

// 초기 숨김
hoPreviewCard.style.display = "none";

// 업로드 박스 클릭
hoUploadBox.addEventListener("click", () => {

    hoTypeImage.click();

});

// 파일 선택
hoTypeImage.addEventListener("change", e => {

    const file = e.target.files[0];

    if(!file){
        return;
    }

    // 이미지 체크
    if(!file.type.startsWith("image/")){

        alert("이미지 파일만 업로드 가능합니다.");

        return;
    }

    const reader = new FileReader();

    reader.onload = event => {

        hoPreviewImg.src = event.target.result;

        hoPreviewCard.style.display = "block";

        hoUploadContent.style.display = "none";

    };

    reader.readAsDataURL(file);

});

// 제거 버튼
hoRemoveBtn.addEventListener("click", e => {

    e.stopPropagation();

    hoTypeImage.value = "";

    hoPreviewImg.src = "";

    hoPreviewCard.style.display = "none";

    hoUploadContent.style.display = "flex";

});

// ======================================
// 평형 타입 목록 조회
// ======================================

async function loadHoTypeList(){

    try{

        const response = await fetch(
            `/manager/ho-type/list/${mgmtOfcNo}`
        );

        if(!response.ok){
            throw new Error("평형 타입 조회 실패");
        }

        const data = await response.json();

        console.log(data);

        renderHoTypeList(data);

    }catch(error){

        console.error(error);

    }

}

// ======================================
// 평형 타입 렌더링
// ======================================

function renderHoTypeList(list){

    if(!list || list.length === 0){

        hoTypeList.innerHTML = `
    <div class="empty-message">
        등록된 평형 타입이 없습니다.
</div>
    `;

        return;
    }

    hoTypeList.innerHTML = list.map(item => `

    <div class="ho-type-card">

        <div class="ho-type-card-top">

        <div>

        <strong class="ho-type-name">
        ${item.tyNm}
</strong>

    <p class="ho-type-size">
        전용 ${item.exclusiveSize}㎡
    </p>

</div>

</div>

    <div class="ho-type-card-info">

        방 ${item.roomCnt} · 욕실 ${item.bathroomCnt}

    </div>

    <div class="ho-type-card-actions">

        <button type="button"
                class="btn btn-sm btn-secondary">

            수정

        </button>

        <button type="button"
                class="btn btn-sm btn-danger">

            삭제

        </button>

    </div>

</div>

    `).join("");

}

// ======================================
// 평형 타입 등록
// ======================================

const btnInsertHoType =
    document.querySelector("#btnInsertHoType");

btnInsertHoType.addEventListener("click", insertHoType);

async function insertHoType(){

    try{

        const formData = new FormData();

        formData.append(
            "mgmtOfcNo",
            mgmtOfcNo
        );

        formData.append(
            "tyNm",
            document.querySelector("#tyNm").value
        );

        formData.append(
            "exclsvUseAr",
            document.querySelector("#exclsvUseAr").value
        );

        formData.append(
            "roomCnt",
            document.querySelector("#roomCnt").value
        );

        formData.append(
            "bathroomCnt",
            document.querySelector("#bathroomCnt").value
        );

        // 이미지
        const imageFile =
            hoTypeImage.files[0];

        if(imageFile){

            formData.append(
                "imageFile",
                imageFile
            );

        }

        const response = await fetch(
            "/manager/ho-type/insert",
            {
                method: "POST",
                body: formData
            }
        );

        if(!response.ok){
            throw new Error("평형 타입 등록 실패");
        }

        const result = await response.json();

        console.log(result);

        alert("등록 완료");

        closeTypeModal();

        await loadHoTypeList();

    }catch(error){

        console.error(error);

        alert("등록 실패");

    }

}



});
