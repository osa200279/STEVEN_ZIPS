/*
 * ============================================================
 * publicFacility-agGrid.js
 * 공용시설 관리 AG Grid 전용 모듈
 *
 * 역할
 * - 공용시설 탭 Grid 컬럼 정의
 * - 공용 아이템 탭 Grid 컬럼 정의
 * - AG Grid 생성
 * - 탭 변경 시 컬럼 교체
 * - rowData 반영
 * - CSV 다운로드
 *
 * ERD 연결 기준
 * - FACILITY.FACILITY_NO = PUBLIC_FACILITY.FACILITY_NO
 * - PUBLIC_FACILITY.CMN_FACILITY_NO = PUBLIC_ITEM.CMN_FACILITY_NO
 *
 * 주의
 * - 탭 전환 로직은 JSP 안 스크립트에서 처리
 * - 검색 조건 필터링도 JSP 안 스크립트에서 처리
 * - 이 파일은 AG Grid 그리는 역할만 담당
 * ============================================================
 */
window.PublicFacilityAgGrid = (function () {

    /*
     * 공용시설/자원 상태 표시명
     * - PUBLIC_ITEM도 ERD상 CMN_FACILITY_STTS_CD를 사용
     */
    var STTS_TEXT = {
        OPEN: "사용가능",
        USE: "사용중",
        REPAIR: "점검중",
        CLOSE: "사용중지"
    };

    /*
     * 상태 배지 클래스
     * - 상태 코드별 색상 클래스 매핑
     */
    var STTS_BADGE = {
        OPEN: "badge-green",
        USE: "badge-blue",
        REPAIR: "badge-yellow",
        CLOSE: "badge-red"
    };

    /*
     * 공용시설 운영현황 표시명
     * - PUBLIC_FACILITY에는 상태 컬럼이 없으므로 PUBLIC_ITEM 집계 결과를 화면용으로 표시
     */
    var OPER_STATUS_TEXT = {
        NORMAL: "정상",
        REPAIR_PART: "일부 점검중",
        CLOSE_PART: "일부 사용중지"
    };

    /*
     * 공용시설 운영현황 배지 클래스
     * - 자원 일부 문제는 공용시설 전체 사용불가와 분리
     */
    var OPER_STATUS_BADGE = {
        NORMAL: "badge-green",
        REPAIR_PART: "badge-yellow",
        CLOSE_PART: "badge-red"
    };

    /**
     * null 방지 문자열 변환
     */
    function text(value) {
        if (value == null) {
            return "";
        }
        return String(value);
    }

    /**
     * 배지 HTML 생성
     */
    function badge(cls, label) {
        return '<span class="badge ' + cls + '">' + label + '</span>';
    }

    /**
     * 공용시설 상태 배지 렌더링
     */
    function statusBadge(code) {
        var badgeClass = STTS_BADGE[code] || "badge-gray";
        var badgeLabel = STTS_TEXT[code] || code || "-";
        return badge(badgeClass, badgeLabel);
    }

    /**
     * 예약여부 배지 렌더링
     */
    function reserveBadge(value) {
        var isReservable = value === "Y";
        return isReservable ? badge("badge-green", "예약제") : badge("badge-gray", "자유이용");
    }


    /**
     * 운영시간 값 반환
     */
    function getOperationHour(row) {
        var data = row || {};
        var operationHour = data.cmnFacilityOprHr || data.oprHr;
        return text(operationHour);
    }

    /**
     * 동/위치 표시값 반환
     */
    function getDongLocation(row) {
        var data = row || {};
        var dongText = text(data.dongNm || data.dongName || data.dongNo || data.buildingNm || data.buildingNo);
        var locText = text(data.locCn || data.locationCn || data.facilityLocCn);

        if (dongText && locText) {
            return dongText + " / " + locText;
        }
        return dongText || locText || "-";
    }

    /**
     * 수정일자 표시값 반환
     */
    function getModifiedDate(row) {
        var data = row || {};
        return text(data.mdfDt || data.modDt || data.updateDt || data.updatedAt || "-");
    }

    /**
     * 공용시설 운영현황 코드 반환
     */
    function getOperationStatus(row) {
        var data = row || {};
        var directStatus = data.operStatus || data.operationStatus || data.operStatusCd || data.operationStatusCd;
        var repairCount = Number(data.repairCnt || data.repairItemCnt || data.itemRepairCnt || 0);
        var closeCount = Number(data.closeCnt || data.closeItemCnt || data.itemCloseCnt || 0);

        if (directStatus) {
            return directStatus;
        }
        if (closeCount > 0) {
            return "CLOSE_PART";
        }
        if (repairCount > 0) {
            return "REPAIR_PART";
        }
        return "NORMAL";
    }

    /**
     * 공용시설 운영현황 배지 렌더링
     */
    function operationStatusBadge(code) {
        var badgeClass = OPER_STATUS_BADGE[code] || "badge-gray";
        var badgeLabel = OPER_STATUS_TEXT[code] || code || "-";
        return badge(badgeClass, badgeLabel);
    }


    /**
     * 번호 컬럼 생성
     */
    function numberColumn() {
        return {
            headerName: "번호",
            valueGetter: function (params) {
                var totalCount = params.api.getDisplayedRowCount();
                var rowIndex = params.node.rowIndex;
                return totalCount - rowIndex;
            },
            width: 70,
            minWidth: 45,
            cellClass: "cell-center",
            sortable: false,
            resizable: true
        };
    }

    /**
     * 공용시설 Grid 컬럼 정의 생성
     */
    function createFacilityColumnDefs() {
        return [
            numberColumn(),
            {
                headerName: "공용시설명",
                field: "cmnFacilityNm",
                flex: 1.05,
                minWidth: 90,
                cellClass: "cell-left",
                cellRenderer: function (params) {
                    var name = text(params.value || "-");
                    return '<span class="grid-ellipsis" title="' + name + '">' + name + '</span>';
                }
            },
            {
                headerName: "동/위치",
                field: "locCn",
                flex: 1.15,
                minWidth: 100,
                cellClass: "cell-left",
                valueGetter: function (params) {
                    return getDongLocation(params.data || {});
                },
                cellRenderer: function (params) {
                    var location = text(params.value || "-");
                    return '<span class="grid-ellipsis" title="' + location + '">' + location + '</span>';
                }
            },
            {
                headerName: "예약여부",
                field: "cmnFacilityRsvYn",
                width: 95,
                minWidth: 75,
                valueGetter: function (params) {
                    return params.data.cmnFacilityRsvYn || params.data.rsvYn || "";
                },
                cellRenderer: function (params) {
                    return reserveBadge(params.value);
                }
            },
            {
                headerName: "운영시간",
                field: "cmnFacilityOprHr",
                flex: .95,
                minWidth: 95,
                cellClass: "cell-left",
                valueGetter: function (params) {
                    return getOperationHour(params.data || {});
                },
                cellRenderer: function (params) {
                    var hour = text(params.value || "—");
                    return '<span class="grid-ellipsis" title="' + hour + '">' + hour + '</span>';
                }
            },
            {
                headerName: "운영현황",
                field: "operStatus",
                width: 120,
                minWidth: 90,
                valueGetter: function (params) {
                    return getOperationStatus(params.data || {});
                },
                cellRenderer: function (params) {
                    return operationStatusBadge(params.value);
                }
            },
            {
                headerName: "수정일자",
                field: "mdfDt",
                width: 110,
                minWidth: 85,
                cellClass: "cell-center",
                valueGetter: function (params) {
                    return getModifiedDate(params.data || {});
                }
            },
            {
                headerName: "관리",
                field: "cmnFacilityNo",
                width: 240,
                minWidth: 190,
                cellClass: "cell-center",
                sortable: false,
                resizable: true,
                cellRenderer: function () {
                    return '<div class="grid-actions">'
                        + '<button type="button" class="btn btn-xs btn-detail" data-action="facilityDetail">상세</button>'
                        + '<button type="button" class="btn btn-xs btn-edit" data-action="facilityEdit">수정</button>'
                        + '<button type="button" class="btn btn-xs btn-delete" data-action="facilityDelete">삭제</button>'
                        + '</div>';
                }
            }
        ];
    }

    /**
     * 공용 아이템 Grid 컬럼 정의 생성
     */
    function createItemColumnDefs() {
        return [
            numberColumn(),
            {
                headerName: "자원번호",
                field: "cmnFacilityItemNo",
                width: 135,
                minWidth: 90,
                cellClass: "cell-mono"
            },
            {
                headerName: "공용시설번호",
                field: "cmnFacilityNo",
                width: 120,
                minWidth: 85,
                cellClass: "cell-mono"
            },
            {
                headerName: "공용시설명",
                field: "cmnFacilityNm",
                flex: 1.1,
                minWidth: 95,
                cellClass: "cell-left",
                cellRenderer: function (params) {
                    var facilityName = text(params.value || "-");
                    return '<span class="grid-ellipsis">' + facilityName + '</span>';
                }
            },
            {
                headerName: "자원명",
                field: "itemNm",
                flex: 1.2,
                minWidth: 95,
                cellClass: "cell-left",
                cellRenderer: function (params) {
                    var itemName = text(params.value || "-");
                    return '<span class="grid-ellipsis">' + itemName + '</span>';
                }
            },
            {
                headerName: "상태",
                field: "cmnFacilitySttsCd",
                width: 110,
                minWidth: 80,
                cellRenderer: function (params) {
                    return statusBadge(params.value);
                }
            },
            {
                headerName: "관리",
                field: "cmnFacilityItemNo",
                width: 240,
                minWidth: 190,
                cellClass: "cell-center",
                sortable: false,
                resizable: true,
                cellRenderer: function () {
                    return '<div class="grid-actions">'
                        + '<button type="button" class="btn btn-xs btn-detail" data-action="itemDetail">상세</button>'
                        + '<button type="button" class="btn btn-xs btn-edit" data-action="itemEdit">수정</button>'
                        + '<button type="button" class="btn btn-xs btn-delete" data-action="itemDelete">삭제</button>'
                        + '</div>';
                }
            }
        ];
    }

    /**
     * 현재 탭에 맞는 컬럼 정의 반환
     */
    function getColumnDefs(viewType) {
        if (viewType === "PUBLIC_ITEM") {
            return createItemColumnDefs();
        }
        return createFacilityColumnDefs();
    }

    /**
     * 컬럼 폭 강제 맞춤
     */
    function fitColumns(api) {
        if (api && typeof api.sizeColumnsToFit === "function") {
            api.sizeColumnsToFit();
        }
    }

    /**
     * AG Grid 생성
     */
    function create(options) {
        var gridApi = null;
        var currentViewType = options.viewType || "PUBLIC_FACILITY";
        var gridDiv = document.getElementById(options.gridId);

        if (!gridDiv || !window.agGrid) {
            return {
                setRows: function () {},
                changeView: function () {},
                exportCsv: function () {},
                refreshSize: function () {}
            };
        }

        var gridOptions = {
            theme: "legacy",
            columnDefs: getColumnDefs(currentViewType),
            rowData: [],
            domLayout: "autoHeight",
            defaultColDef: {
                sortable: true,
                filter: false,
                floatingFilter: false,
                resizable: true,
                suppressMovable: false
            },
            pagination: true,
            paginationPageSize: 10,
            paginationPageSizeSelector: [10, 20, 50],
            rowHeight: 46,
            headerHeight: 42,
            suppressCellFocus: true,
            suppressHorizontalScroll: true,
            animateRows: true,
            suppressDragLeaveHidesColumns: true,
            /* 컬럼 리사이즈 기준
             * - 오른쪽 컬럼과 폭을 주고받는 방식 유지
             * - 컬럼별 maxWidth 제거로 드래그 자유도 확보
             */
            colResizeDefault: "shift",
            onGridReady: function (params) {
                gridApi = params.api;
                fitColumns(params.api);
            },
            onFirstDataRendered: function (params) {
                fitColumns(params.api);
            },
            onGridSizeChanged: function (params) {
                fitColumns(params.api);
            },
            onCellClicked: function (event) {
                var btn = event.event.target.closest("[data-action]");
                if (!btn || !event.data) {
                    return;
                }

                var action = btn.dataset.action;

                if (action === "facilityDetail") options.onFacilityDetail(event.data.cmnFacilityNo);
                if (action === "facilityEdit") options.onFacilityEdit(event.data.cmnFacilityNo);
                if (action === "facilityDelete") options.onFacilityDelete(event.data.cmnFacilityNo);
                if (action === "itemDetail") options.onItemDetail(event.data.cmnFacilityItemNo);
                if (action === "itemEdit") options.onItemEdit(event.data.cmnFacilityItemNo);
                if (action === "itemDelete") options.onItemDelete(event.data.cmnFacilityItemNo);
            }
        };

        gridApi = agGrid.createGrid(gridDiv, gridOptions);

        return {
            setRows: function (rows) {
                var rowData = rows || [];
                if (gridApi) {
                    gridApi.setGridOption("rowData", rowData);
                }
                fitColumns(gridApi);
            },
            changeView: function (viewType) {
                currentViewType = viewType;

                if (!gridApi) {
                    return;
                }

                gridApi.setGridOption("columnDefs", getColumnDefs(currentViewType));
                gridApi.setGridOption("rowData", []);
                fitColumns(gridApi);
            },
            exportCsv: function (fileName) {
                if (!gridApi) {
                    return;
                }

                gridApi.exportDataAsCsv({
                    fileName: fileName,
                    allColumns: false,
                    skipPinnedTop: true,
                    skipPinnedBottom: true,
                    prependContent: "\ufeff"
                });
            },
            refreshSize: function () {
                fitColumns(gridApi);
            }
        };
    }

    return {
        create: create
    };

})();
