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



});
