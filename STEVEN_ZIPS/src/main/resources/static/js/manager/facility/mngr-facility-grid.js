/**
 * ============================================================
 * mngr-facility-grid.js
 * 시설자산 관리 AG Grid 전용 모듈
 *
 * 목록 컬럼 기준
 * 시설번호 / 시설명 / 시설유형 / 운영상태 / 동 / 상세위치 / 설치일자 / 관리
 *
 * 검침 연결·예정 점검은 상세 모달에서만 확인
 * ADMIN은 관리 컬럼에 상세 버튼만 표시
 * ============================================================
 */

var FacilityGrid = (function () {

    var gridTarget = null; // AG Grid 마운트 대상 DOM 요소

    /* ADMIN 여부 판별 (facilityPageConfig.isAdmin 기준) */
    function isAdminUser() {
        return window.facilityPageConfig
            && (window.facilityPageConfig.isAdmin === true
                || window.facilityPageConfig.isAdmin === "true");
    }

    /* HTML 특수문자 이스케이프 (XSS 방지) */
    function escapeHtml(value) {
        if (value == null) return "";
        return String(value)
            .replace(/&/g,  "&amp;")
            .replace(/</g,  "&lt;")
            .replace(/>/g,  "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g,  "&#39;");
    }

    /* 배지 HTML 생성 */
    function badge(cls, text) {
        return '<span class="badge ' + cls + '">' + escapeHtml(text) + '</span>';
    }

    /**
     * USE_YN → 운영상태 배지 렌더러
     * N: 사용 불가 / 그 외: 사용 가능
     */
    function useYnRenderer(params) {
        return params.value === "N"
            ? badge("badge-use-n", "사용 불가")
            : badge("badge-use-y", "사용 가능");
    }

    /**
     * 시설명 렌더러
     * 목록에서 가장 먼저 눈에 들어와야 하므로 굵게 표시
     */
    function facilityNameRenderer(params) {
        return '<span class="td-bold">' + escapeHtml(params.value || "-") + '</span>';
    }

    /**
     * 고정폭 렌더러
     * 시설번호처럼 코드값은 고정폭 글꼴로 표시
     */
    function monoRenderer(params) {
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }
        return '<span class="td-mono">' + escapeHtml(params.value) + '</span>';
    }

    /**
     * 상세위치 렌더러
     * 값이 길어질 수 있으므로 한 줄 말줄임 + title로 전체 확인
     */
    function locationRenderer(params) {
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }
        return '<span class="grid-ellipsis" title="' + escapeHtml(params.value) + '">'
            + escapeHtml(params.value)
            + '</span>';
    }

    /**
     * 관리 버튼 렌더러
     *
     * ADMIN : 상세 버튼만 표시
     * MNGR  : 상세 + 수정 버튼 표시
     *
     * data-action / data-row-key 를 화면 공통 클릭 핸들러로 전달
     * valueGetter로 facilityNo를 받아 field 중복 문제 해소
     */
    function actionRenderer(params) {
        var facilityNo = escapeHtml(params.value || ""); // 시설번호 (관리 버튼 키값)

        var html = '<div class="grid-actions">'
            + '<button type="button" class="btn btn-detail"'
            + '  data-action="detail" data-row-key="' + facilityNo + '">'
            + '상세</button>';

        /* ADMIN이 아닐 때만 수정 버튼 표시 */
        if (!isAdminUser()) {
            html += '<button type="button" class="btn btn-edit"'
                + '  data-action="edit" data-row-key="' + facilityNo + '">'
                + '수정</button>';
        }

        html += '</div>';
        return html;
    }

    /**
     * 시설자산 목록 컬럼 정의
     *
     * 검침 연결·예정 점검은 상세 모달에서만 확인
     * 관리 컬럼은 valueGetter로 facilityNo를 별도 추출해
     * 시설번호 컬럼(field:"facilityNo")과의 field 중복 문제 해소
     */
    function getColumnDefs() {
        return [
            {
                headerName: "시설번호",
                field: "facilityNo",
                width: 112, minWidth: 105,
                cellClass: "cell-center",
                cellRenderer: monoRenderer
            },
            {
                headerName: "시설명",
                field: "facilityNm",
                flex: 1.1, minWidth: 140,
                cellRenderer: facilityNameRenderer
            },
            {
                headerName: "시설유형",
                field: "facilityTyCd",
                width: 105, minWidth: 95,
                cellClass: "cell-center",
                cellRenderer: AgRenderer.badge(AgRenderer.CODE.FACILITY_TY)
            },
            {
                headerName: "운영상태",
                field: "useYn",
                width: 95, minWidth: 88,
                cellClass: "cell-center",
                cellRenderer: useYnRenderer
            },
            {
                headerName: "동",
                field: "dongNo",
                width: 70, minWidth: 65,
                cellClass: "cell-center",
                /* 동번호 없으면 공용으로 표시 */
                valueFormatter: function (params) {
                    return params.value ? params.value : "공용";
                }
            },
            {
                headerName: "상세위치",
                field: "locCn",
                flex: 1.45, minWidth: 160,
                cellRenderer: locationRenderer
            },
            {
                headerName: "설치일자",
                field: "instlDt",
                width: 105, minWidth: 95,
                cellClass: "cell-center",
                cellRenderer: AgRenderer.date
            },
            {
                headerName: "관리",
                /*
                 * field 중복 방지
                 * 시설번호 컬럼과 동일한 field를 쓰면 AG Grid 내부에서
                 * 클릭 이벤트가 첫 번째 컬럼과 충돌하여 상세 버튼이 동작하지 않음
                 * valueGetter로 facilityNo를 별도 추출하여 분리
                 */
                valueGetter: function (params) {
                    return params.data ? params.data.facilityNo : "";
                },
                width: isAdminUser() ? 90 : 140,
                minWidth: isAdminUser() ? 90 : 140,
                /* sizeColumnsToFit 호출 시 관리 컬럼이 압축되지 않도록 고정 */
                suppressSizeToFit: true,
                cellClass: "cell-center",
                sortable: false,
                resizable: false,
                cellRenderer: actionRenderer
            }
        ];
    }

    /**
     * 그리드 초기화
     *
     * @param targetId  그리드를 렌더링할 요소 ID
     * @returns         AG Grid API 객체
     */
    function init(targetId) {
        gridTarget = document.getElementById(targetId); // 그리드 마운트 대상
        if (!gridTarget) return null;

        createManagerGrid(gridTarget, getColumnDefs(), [], {
            paginationPageSize: 10,
            suppressCellFocus: true,
            onGridReady: function (params) {
                params.api.sizeColumnsToFit();
            }
        });

        return gridTarget.__gridApi;
    }

    /**
     * 그리드 데이터 갱신
     * @param rowData  표시할 시설 목록
     */
    function setRows(rowData) {
        setGridRowData(gridTarget, rowData || []);
    }

    /* 그리드 필터 초기화 */
    function reset() {
        resetGridFilter(gridTarget);
    }

    /* 컬럼 너비 재조정 (창 크기 변경 시 사용) */
    function refreshSize() {
        var api = gridTarget && gridTarget.__gridApi; // Grid API
        if (api && typeof api.sizeColumnsToFit === "function") {
            api.sizeColumnsToFit();
        }
    }

    /**
     * 현재 목록 CSV 내보내기
     * @param fileName  다운로드 파일명
     */
    function exportExcel(fileName) {
        var api = gridTarget && gridTarget.__gridApi; // Grid API
        if (!api || typeof api.exportDataAsCsv !== "function") return false;

        api.exportDataAsCsv({
            fileName:        fileName || "facility-list.csv",
            /* 관리 컬럼 제외 */
            columnKeys:      ["facilityNo", "facilityNm", "facilityTyCd", "useYn", "dongNo", "locCn", "instlDt"],
            allColumns:      false,
            skipPinnedTop:   true,
            skipPinnedBottom:true,
            prependContent:  "\ufeff" // 엑셀 한글 깨짐 방지 BOM
        });

        return true;
    }

    function getRows() {
        var api = gridTarget && gridTarget.__gridApi;
        var rows = [];

        if (!api || typeof api.forEachNode !== "function") {
            return rows;
        }

        api.forEachNode(function (node) {
            if (node && node.data) {
                rows.push(node.data);
            }
        });

        return rows;
    }

    return {
        init:        init,
        setRows:     setRows,
        reset:       reset,
        refreshSize: refreshSize,
        exportExcel: exportExcel,
        getRows:     getRows
    };

})();
