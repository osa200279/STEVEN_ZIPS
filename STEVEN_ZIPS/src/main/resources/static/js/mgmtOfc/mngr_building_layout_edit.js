document.addEventListener("DOMContentLoaded", async () => {

    let allHoList = [];

    let isEditMode = false;
    let imageChanged = false;
    let editingHoTyNo = null;

    const csrfToken = document.querySelector('meta[name="_csrf"]').content;

    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

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

                    case "DISABLED":
                        return "비활성";

                    default:
                        return params.value;
                }
            }
        }

    ];

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

                enableClickSelection: false,

                enableSelectionWithoutKeys: true
            },

            animateRows: true,

            onSelectionChanged: syncLayoutSelection
        }
    );

    // =========================
    // 데이터 조회
    // =========================
    try {

        const response = await fetch(
            `/manager/compolexEdit/hoList/${mgmtOfcNo}`
        );

        if (!response.ok) {
            throw new Error("호 목록 조회 실패");
        }

        const data = await response.json();

        console.log(data);

        allHoList = data;

        gridApi.setGridOption(
            "rowData",
            data
        );

        renderDongSelect(data);

        await loadHoTypeList();

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

    isEditMode = false;
    imageChanged = false;
    editingHoTyNo = null;

    document.querySelector("#tyNm").value = "";
    document.querySelector("#exclusiveSize").value = "";
    document.querySelector("#roomCnt").value = "";
    document.querySelector("#bathroomCnt").value = "";

    hoTypeImage.value = "";

    hoPreviewImg.src = "";

    hoPreviewCard.style.display = "none";

    hoUploadContent.style.display = "flex";

    document.querySelector(
        ".ho-type-modal-title"
    ).textContent = "새 평형 타입 추가";

    btnInsertHoType.textContent =
        "평형 타입 추가";

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

    isEditMode = false;
    imageChanged = false;
    editingHoTyNo = null;

}

const hoUploadBox =
    document.querySelector("#hoUploadBox");

const hoTypeImage =
    document.querySelector("#hoTypeImage");

const hoUploadContent =
    document.querySelector(".upload-content");

const hoPreviewImg =
    document.querySelector("#hoPreviewImg");

const hoPreviewCard =
    document.querySelector("#hoPreviewCard");

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
    imageChanged = true;

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

        hoUploadContent.style.display = "none";

        hoPreviewCard.style.display = "flex";

        hoRemoveBtn.style.display = "flex";

    };

    reader.readAsDataURL(file);

});

// 제거 버튼
hoRemoveBtn.addEventListener("click", e => {

    e.stopPropagation();

    imageChanged = true;

    hoTypeImage.value = "";

    hoPreviewImg.src = "";

    hoPreviewCard.style.display = "none";

    hoUploadContent.style.display = "flex";

});


async function loadHoTypeList(){

    try{

        const response = await fetch(
            `/manager/ho-type/hoTyList/${mgmtOfcNo}`
        );

        if(!response.ok){
            throw new Error("평형 타입 조회 실패");
        }

        const data = await response.json();

        console.log(data);

        renderHoTypeList(data);

        renderHoTypeSelect(data);

    }catch(error){

        console.error(error);

    }

}

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
                class="btn btn-sm btn-secondary btn-edit-type"
                data-hoty-no="${item.hoTyNo}"
                data-ty-nm="${item.tyNm}"
                data-exclusive-size="${item.exclusiveSize}"
                data-room-cnt="${item.roomCnt}"
                data-bathroom-cnt="${item.bathroomCnt}"
                data-google-id="${item.googleId}"
                >
        
            수정
        
        </button>

        <button type="button"
                class="btn btn-sm btn-danger btn-delete-type"
                data-hoty-no="${item.hoTyNo}">
        
            삭제
        
        </button>

    </div>

</div>

    `).join("");

    document
        .querySelectorAll(".btn-edit-type")
        .forEach(btn => {

            btn.addEventListener("click", () => {
                imageChanged = false;
                isEditMode = true;
                hoTypeImage.value = "";

                editingHoTyNo =
                    btn.dataset.hotyNo;

                // input 세팅
                document.querySelector("#tyNm").value =
                    btn.dataset.tyNm;

                document.querySelector("#exclusiveSize").value =
                    btn.dataset.exclusiveSize;

                document.querySelector("#roomCnt").value =
                    btn.dataset.roomCnt;

                document.querySelector("#bathroomCnt").value =
                    btn.dataset.bathroomCnt;

                // 이미지 세팅
                const googleId =
                    btn.dataset.googleId;

                if(googleId && googleId !== "null"){

                    hoPreviewImg.src =
                        `/file/display/${googleId}`;

                    hoUploadContent.style.display = "none";

                    hoPreviewCard.style.display = "flex";

                    hoRemoveBtn.style.display = "flex";
                }else{

                    hoPreviewImg.src = "";

                    hoRemoveBtn.style.display = "none";

                    hoPreviewCard.style.display = "none";

                    hoUploadContent.style.display = "flex";
                }

                // 타이틀 변경
                document.querySelector(
                    ".ho-type-modal-title"
                ).textContent = "평형 타입 수정";

                // 버튼 텍스트 변경
                btnInsertHoType.textContent =
                    "수정 완료";

                // 모달 열기
                hoTypeModal.classList.add("show");

                hoTypeModalBackdrop.classList.add("show");

            });

        });


    document
        .querySelectorAll(".btn-delete-type")
        .forEach(btn => {

            btn.addEventListener("click", async () => {

                const hoTyNo =
                    btn.dataset.hotyNo;

                const confirmed =
                    confirm("평형 타입을 삭제하시겠습니까?");

                if(!confirmed){
                    return;
                }

                try{

                    const formData =
                        new FormData();

                    formData.append(
                        "hoTyNo",
                        hoTyNo
                    );

                    const response =
                        await fetch(
                            `/manager/ho-type/delete/${mgmtOfcNo}`,
                            {
                                method: "POST",

                                headers: {
                                    [csrfHeader]: csrfToken
                                },

                                body: formData
                            }
                        );

                    if(!response.ok){
                        throw new Error("삭제 실패");
                    }

                    const result =
                        await response.json();

                    console.log(result);

                    if(!result.success){

                        alert(
                            result.message || "삭제 실패"
                        );

                        return;
                    }

                    alert("삭제 완료");

                    await loadHoTypeList();

                }catch(error){

                    console.error(error);

                    alert("삭제 실패");
                }

            });

        });


}



const btnInsertHoType =
    document.querySelector("#btnInsertHoType");

btnInsertHoType.addEventListener("click", insertHoType);

async function insertHoType(){

    const url = isEditMode
        ? `/manager/ho-type/update/${mgmtOfcNo}`
        : `/manager/ho-type/insert/${mgmtOfcNo}`;


    try{

        const formData = new FormData();

        formData.append(
            "imageChanged",
            imageChanged
        );

        formData.append(
            "mgmtOfcNo",
            mgmtOfcNo
        );

        formData.append(
            "tyNm",
            document.querySelector("#tyNm").value
        );

        formData.append(
            "exclusiveSize",
            document.querySelector("#exclusiveSize").value
        );

        formData.append(
            "roomCnt",
            document.querySelector("#roomCnt").value
        );

        formData.append(
            "bathroomCnt",
            document.querySelector("#bathroomCnt").value
        );

        if(isEditMode){
            formData.append(
                "hoTyNo",
                editingHoTyNo
            );
        }

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
            url,
            {
                method: "POST",

                headers: {
                    [csrfHeader]: csrfToken
                },

                body: formData
            }
        );

        if(!response.ok){
            throw new Error("평형 타입 등록 실패");
        }

        const result = await response.json();

        console.log(result);

        alert(
            isEditMode
                ? "수정 완료"
                : "등록 완료"
        );

        closeTypeModal();

        await loadHoTypeList();

    }catch(error){

        console.error(error);

        alert("등록 실패");

    }

}

    function renderDongSelect(list){

        const dongSelect =
            document.querySelector("#dongSelect");

        const dongMap = new Map();

        list.forEach(item => {

            if(!dongMap.has(item.dongNo)){

                dongMap.set(
                    item.dongNo,
                    item.dongNm
                );
            }

        });

        const sortedList =
            [...dongMap.entries()]
                .sort((a, b) =>
                    Number(String(a[1]).replace("동", "")) -
                    Number(String(b[1]).replace("동", ""))
                );

        dongSelect.innerHTML = `
        <option value="">동 선택</option>
    ` + sortedList.map(([dongNo, dongNm]) => `
        <option value="${dongNo}">
            ${dongNm}동
        </option>
    `).join("");

        // 최초 선택
        if(sortedList.length > 0){

            dongSelect.value = sortedList[0][0];

            changeDongLayout(sortedList[0][0]);
        }

    }


    function renderFloorLayout(list){

        const layoutGrid = document.querySelector("#unitLayoutGrid");

        if(!list || list.length === 0){

            layoutGrid.innerHTML = `
            <div class="empty-message">
                등록된 호 정보가 없습니다.
            </div>
        `;

            return;
        }

        // 층별 그룹핑
        const floorMap = {};

        list.forEach(item => {

            const floor = item.floor;

            if(!floorMap[floor]){
                floorMap[floor] = [];
            }

            floorMap[floor].push(item);



        });

        // 층 내 호 정렬
        Object.values(floorMap).forEach(floorList => {

            floorList.sort((a, b) => {
                return Number(a.ho) - Number(b.ho);
            });

        });

        // 층 내림차순
        const sortedFloors =
            Object.keys(floorMap)
                .map(Number)
                .sort((a, b) => b - a);

        layoutGrid.innerHTML =
            sortedFloors.map(floor => {

                const hoList = floorMap[floor];

                return `
                <div class="unit-floor-row">

                    <div class="unit-floor-label">
                        ${floor}F
                    </div>

                    ${hoList.map(ho => {

                    let statusClass = "";

                    switch(ho.hoSttsCd){

                        case "LIVE":
                            statusClass = "live";
                            break;

                        case "EMPTY":
                            statusClass = "empty";
                            break;

                        case "DISABLED":
                            statusClass = "disabled";
                            break;

                        default:
                            statusClass = "";
                    }

                    return `
                            <div class="unit-cell ${statusClass}"
                                 data-ho-no="${ho.hoNo}">
                                 
                                ${ho.ho}
                                
                            </div>
                        `;

                }).join("")}

                </div>
            `;

            }).join("");

        bindUnitCellEvent();

        syncLayoutSelection();

    }

    function bindUnitCellEvent(){

        document
            .querySelectorAll(".unit-cell")
            .forEach(cell => {

                cell.addEventListener("click", () => {

                    const hoNo =
                        cell.dataset.hoNo;

                    const isSelected =
                        cell.classList.contains("selected");

                    gridApi.forEachNode(node => {

                        if(node.data.hoNo === hoNo){

                            node.setSelected(!isSelected);

                        }

                    });

                });

            });

    }

    function syncLayoutSelection(){

        // 전체 선택 제거
        document
            .querySelectorAll(".unit-cell")
            .forEach(cell => {

                cell.classList.remove("selected");

            });

        // grid 선택 목록
        const selectedRows =
            gridApi.getSelectedRows();

        selectedRows.forEach(row => {

            const target =
                document.querySelector(
                    `.unit-cell[data-ho-no="${row.hoNo}"]`
                );

            if(target){

                target.classList.add("selected");

            }

        });

    }

    document
        .querySelector("#dongSelect")
        .addEventListener("change", e => {

            changeDongLayout(e.target.value);

        });

    function changeDongLayout(dongNo){

        const filteredList =
            allHoList.filter(item =>
                item.dongNo === dongNo
            );

        renderFloorLayout(filteredList);
    }

    function renderHoTypeSelect(list){

        const hoTypeSelect =
            document.querySelector("#hoTypeSelect");

        if(!list || list.length === 0){

            hoTypeSelect.innerHTML = `
            <option value="">
                평형 선택
            </option>
        `;

            return;
        }

        hoTypeSelect.innerHTML = `
        <option value="">
            평형 선택
        </option>
    ` + list.map(item => `

        <option value="${item.hoTyNo}">
            ${item.tyNm}
        </option>

    `).join("");

    }


});
