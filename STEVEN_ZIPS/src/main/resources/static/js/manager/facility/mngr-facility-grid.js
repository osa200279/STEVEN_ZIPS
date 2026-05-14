/**
 * ============================================================
 * mngr-facility-grid.js
 * 시설자산 관리 AG Grid 전용 모듈
 *
 * 정리 기준
 * - AG Grid 전체 폭 맞춤
 * - 가로 스크롤 방지
 * - 번호 컬럼 표시
 * - 전체 데이터 기준 역순 번호 표시
 *   예: 총 18개면 18, 17, 16 ... 1
 * - 번호 컬럼 폭 조절 가능
 * ============================================================
 */

var FacilityGrid = (function () {

    /* AG Grid가 붙을 대상 div 요소 */
    var gridTarget = null;

    /**
     * ADMIN 사용자 여부 확인
     */
    function isAdminUser() {
        /* JSP에서 내려준 화면 설정 정보 존재 여부 */
        var pageConfig = window.facilityPageConfig;

        /* ADMIN 여부 값 */
        var isAdmin = pageConfig
            && (pageConfig.isAdmin === true || pageConfig.isAdmin === "true");

        return isAdmin;
    }

    /**
     * HTML 특수문자 변환
     */
    function escapeHtml(value) {
        /* 빈 값 방어 처리 */
        if (value == null) return "";

        /* 문자열 변환 값 */
        var text = String(value);

        /* HTML 특수문자 치환 결과 */
        return text
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    /**
     * 배지 HTML 생성
     */
    function badge(cls, text) {
        /* 배지 클래스명 */
        var badgeClass = cls;

        /* 배지 표시 문구 */
        var badgeText = escapeHtml(text);

        return '<span class="badge ' + badgeClass + '">' + badgeText + '</span>';
    }

    /**
     * 사용여부 표시 렌더러
     */
    function useYnRenderer(params) {
        /* 사용 불가 여부 */
        var isDisabled = params.value === "N";

        /* 상태 CSS 클래스명 */
        var cls = isDisabled ? "status-text is-disabled" : "status-text is-available";

        /* 상태 표시 문구 */
        var text = isDisabled ? "비활성" : "활성";

        return '<span class="' + cls + '">' + escapeHtml(text) + '</span>';
    }

    /**
     * 시설유형명 반환
     */
    function getFacilityTypeText(row) {
        /* 행 데이터 기본값 */
        row = row || {};

        /* 시설유형 코드별 기본 표시명 */
        var fallbackMap = {
            ELV: "승강기",
            WTR: "급수시설",
            ELC: "전기시설",
            GAS: "가스시설",
            SEC: "보안시설",
            ETC: "기타시설",
            MEET: "회의실",
            PARK: "입주민주차장",
            PLAY: "놀이시설",
            COMM: "커뮤니티시설",
            FIRE: "소방시설",
            GYM: "피트니스센터",
            STUDY: "독서실",
            PARKING: "방문차량주차구역"
        };

        /* DB에서 조회된 시설유형명 우선 사용 */
        var typeName = row.facilityTyNm;

        /* 코드 기준 기본 표시명 */
        var fallbackName = fallbackMap[row.facilityTyCd];

        /* 최종 시설유형 표시명 */
        return typeName || fallbackName || row.facilityTyCd || "-";
    }

    /**
     * 시설유형 배지 렌더러
     */
    function facilityTypeRenderer(params) {
        /* 현재 행 데이터 */
        var row = params.data || {};

        /* 시설유형 표시명 */
        var typeText = getFacilityTypeText(row);

        return badge("badge-blue", typeText);
    }

    function publicOperationRenderer(params) {
        var row = params.data || {};
        var isPublicType = row.facilityKind === "PUBLIC";
        var isRegistered = row.publicOperRegisteredYn === "Y" || !!row.cmnFacilityNo;

        if (!isPublicType) {
            return '<span class="td-empty">-</span>';
        }

        return isRegistered
            ? badge("badge-teal", "운영등록")
            : badge("badge-gray", "운영미등록");
    }

    /**
     * 시설명 강조 렌더러
     */
    function facilityNameRenderer(params) {
        /* 시설명 표시값 */
        var facilityName = params.value || "-";

        return '<span class="td-bold">' + escapeHtml(facilityName) + '</span>';
    }

    /**
     * 고정폭 문자 렌더러
     */
    function monoRenderer(params) {
        /* 빈 값 표시 처리 */
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }

        /* 고정폭 표시값 */
        var text = escapeHtml(params.value);

        return '<span class="td-mono">' + text + '</span>';
    }

    /**
     * 동 번호 표시값 변환
     */
    function formatDongNo(value) {
        /* 공용 위치 표시 처리 */
        if (value == null || value === "") return "공용";

        /* 동 번호 문자열 */
        var text = String(value);

        /* 언더바 위치 */
        var idx = text.lastIndexOf("_");

        /* 실제 동 번호 */
        var dong = idx > -1 ? text.slice(idx + 1) : text;

        return dong || "공용";
    }

    /**
     * 상세위치 말줄임 렌더러
     */
    function locationRenderer(params) {
        /* 빈 값 표시 처리 */
        if (params.value == null || params.value === "") {
            return '<span class="td-empty">-</span>';
        }

        /* 상세위치 표시값 */
        var locationText = escapeHtml(params.value);

        return '<span class="grid-ellipsis" title="' + locationText + '">'
            + locationText
            + '</span>';
    }

    /**
     * 관리 버튼 렌더러
     */
    function actionRenderer(params) {
        /* 현재 행 데이터 */
        var row = params.data || {};

        /* 시설번호 */
        var facilityNo = escapeHtml(params.value || "");

        /* 현재 활성여부 */
        /* var useYn = row.useYn === "N" ? "N" : "Y"; */

        /* 활성여부 전환 버튼 문구 */
        /* var toggleText = useYn === "N" ? "활성" : "비활성"; */

        /* 관리 버튼 영역 시작 */
        var html = '<div class="grid-actions">'
            + '<button type="button" class="btn btn-detail"'
            + ' data-action="detail" data-row-key="' + facilityNo + '">'
            + '상세</button>';

        /* ADMIN이 아니면 수정 버튼 표시 */
        if (!isAdminUser()) {
            html += '<button type="button" class="btn btn-edit"'
                + ' data-action="edit" data-row-key="' + facilityNo + '">'
                + '수정</button>';

            /* 활성/비활성 처리는 수정 화면에서 진행 */
            /* html += '<button type="button" class="btn btn-secondary"'
                + ' data-action="toggleUseYn" data-row-key="' + facilityNo + '" data-use-yn="' + useYn + '">'
                + toggleText + '</button>'; */
        }

        /* 관리 버튼 영역 종료 */
        html += '</div>';

        return html;
    }

    /**
     * AG Grid 컬럼 정의 생성
     */
    function getColumnDefs() {
        return [
            {
                headerName: "번호",
                valueGetter: function (params) {
                    /*
                     * 전체 데이터 기준 역순 번호
                     * - 전체 18개면 첫 번째 행은 18번
                     * - 다음 행은 17번
                     * - 페이지 이동 후에도 전체 기준 유지
                     * - 필터 적용 시 필터 결과 기준 재계산
                     */

                    /* 현재 그리드에 표시되는 전체 행 수 */
                    var totalCount = params.api.getDisplayedRowCount();

                    /* 현재 행의 전체 표시 기준 인덱스 */
                    var rowIndex = params.node.rowIndex;

                    /* 전체 기준 역순 번호 */
                    var reverseNo = totalCount - rowIndex;

                    return reverseNo;
                },
                width: 70,
                minWidth: 45,
                cellClass: "cell-center",
                sortable: false,
                resizable: true
            },
            {
                headerName: "시설번호",
                field: "facilityNo",
                width: 105,
                minWidth: 80,
                cellClass: "cell-center",
                cellRenderer: monoRenderer
            },
            {
                headerName: "시설명",
                field: "facilityNm",
                flex: 1.1,
                minWidth: 110,
                cellRenderer: facilityNameRenderer
            },
            {
                headerName: "시설유형",
                field: "facilityTyCd",
                width: 105,
                minWidth: 80,
                cellClass: "cell-center",
                cellRenderer: facilityTypeRenderer
            },
            {
                headerName: "운영관리",
                field: "publicOperRegisteredYn",
                width: 105,
                minWidth: 85,
                cellClass: "cell-center",
                cellRenderer: publicOperationRenderer
            },
            {
                headerName: "활성여부",
                field: "useYn",
                width: 95,
                minWidth: 75,
                cellClass: "cell-center",
                cellRenderer: useYnRenderer
            },
            {
                headerName: "동",
                field: "dongNo",
                width: 65,
                minWidth: 45,
                cellClass: "cell-center",
                valueFormatter: function (params) {
                    /* 동 번호 표시값 */
                    var dongText = formatDongNo(params.value);

                    return dongText;
                }
            },
            {
                headerName: "상세위치",
                field: "locCn",
                flex: 1.2,
                minWidth: 110,
                cellRenderer: locationRenderer
            },
            {
                headerName: "설치일자",
                field: "instlDt",
                width: 105,
                minWidth: 80,
                cellClass: "cell-center",
                cellRenderer: AgRenderer.date
            },
            {
                headerName: "관리",
                valueGetter: function (params) {
                    /* 현재 행 데이터 */
                    var row = params.data;

                    /* 관리 버튼에 전달할 시설번호 */
                    var facilityNo = row ? row.facilityNo : "";

                    return facilityNo;
                },
                width: isAdminUser() ? 80 : 120,
                minWidth: isAdminUser() ? 70 : 100,
                cellClass: "cell-center",
                sortable: false,
                resizable: true,
                cellRenderer: actionRenderer
            }
        ];
    }

    /**
     * AG Grid 초기화
     */
    function init(targetId) {
        /* 그리드 대상 요소 조회 */
        gridTarget = document.getElementById(targetId);

        /* 그리드 대상 요소 없음 처리 */
        if (!gridTarget) return null;

        /* AG Grid 생성 */
        createManagerGrid(gridTarget, getColumnDefs(), [], {
            domLayout: "autoHeight",
            paginationPageSize: 10,
            suppressCellFocus: true,
            suppressHorizontalScroll: true,

            /**
             * 그리드 준비 완료 후 처리
             */
            onGridReady: function (params) {
                /*
                 * 전체 폭 강제 맞춤
                 * - 컬럼이 화면 밖으로 밀려 가로 스크롤 생기는 상황 방지
                 */
                params.api.sizeColumnsToFit();
            },

            /**
             * 최초 데이터 렌더링 후 처리
             */
            onFirstDataRendered: function (params) {
                /* 최초 렌더링 이후 컬럼 폭 재조정 */
                params.api.sizeColumnsToFit();
            }
        });

        /* 생성된 AG Grid API 반환 */
        return gridTarget.__gridApi;
    }

    /**
     * 그리드 행 데이터 설정
     */
    function setRows(rowData) {
        /* 그리드에 넣을 행 데이터 */
        var rows = rowData || [];

        /* AG Grid 행 데이터 반영 */
        setGridRowData(gridTarget, rows);

        /* 컬럼 폭 재조정 */
        refreshSize();
    }

    /**
     * 그리드 필터 초기화
     */
    function reset() {
        /* 공통 그리드 필터 초기화 */
        resetGridFilter(gridTarget);
    }

    /**
     * 그리드 컬럼 폭 재조정
     */
    function refreshSize() {
        /* AG Grid API */
        var api = gridTarget && gridTarget.__gridApi;

        /* 컬럼 폭 맞춤 가능 여부 확인 */
        var canResize = api && typeof api.sizeColumnsToFit === "function";

        /* 컬럼 폭 재조정 실행 */
        if (canResize) {
            api.sizeColumnsToFit();
        }
    }

    /**
     * CSV 파일 내보내기
     */
    function exportExcel(fileName) {
        /* AG Grid API */
        var api = gridTarget && gridTarget.__gridApi;

        /* CSV 내보내기 가능 여부 확인 */
        var canExport = api && typeof api.exportDataAsCsv === "function";

        /* 내보내기 불가 처리 */
        if (!canExport) return false;

        /* CSV 내보내기 실행 */
        api.exportDataAsCsv({
            fileName: fileName || "facility-list.csv",
            columnKeys: [
                "facilityNo",
                "facilityNm",
                "facilityTyCd",
                "publicOperRegisteredYn",
                "useYn",
                "dongNo",
                "locCn",
                "instlDt"
            ],
            allColumns: false,
            skipPinnedTop: true,
            skipPinnedBottom: true,
            prependContent: "\ufeff"
        });

        return true;
    }

    /**
     * 현재 그리드 행 데이터 반환
     */
    function getRows() {
        /* AG Grid API */
        var api = gridTarget && gridTarget.__gridApi;

        /* 행 데이터 배열 */
        var rows = [];

        /* 노드 순회 가능 여부 확인 */
        if (!api || typeof api.forEachNode !== "function") {
            return rows;
        }

        /* 전체 노드 순회 */
        api.forEachNode(function (node) {
            /* 행 데이터 존재 여부 */
            var hasData = node && node.data;

            /* 행 데이터 추가 */
            if (hasData) {
                rows.push(node.data);
            }
        });

        return rows;
    }

    /**
     * 외부 공개 함수 목록
     */
    return {
        init: init,
        setRows: setRows,
        reset: reset,
        refreshSize: refreshSize,
        exportExcel: exportExcel,
        getRows: getRows
    };

})();
