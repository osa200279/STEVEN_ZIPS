/**
 * ============================================================
 * mngr-account-grid.js
 * 직원 계정 관리 화면 AG Grid 전용 스크립트
 *
 * 역할
 * - 재직 직원 그리드 / 계정 생성 요청 그리드 생성
 * - 직무코드, 요청상태코드, 사용여부를 화면용 badge로 변환
 * - 날짜 포맷 변환
 * - AG Grid rowData 갱신
 *
 * 전제
 * - manager-agGrid.js 먼저 로드
 * - 이 파일은 화면 동작 처리보다 "그리드 출력"만 담당
 * ============================================================
 */
(function () {

    /*
     * DUTY_TEXT
     * - DB/공통코드에 저장된 직무코드를 화면에 보여줄 한글명으로 변환하기 위한 객체
     * - key: DB 코드값
     * - value: 화면 표시명
     */
    var DUTY_TEXT = {
        HEAD: "관리소장",
        ACNT: "회계담당",
        ADM:  "행정담당",
        FAC:  "시설담당"
    };

    /*
     * STTS_TEXT
     * - 계정 생성 요청 상태코드를 화면에 보여줄 한글명으로 변환하기 위한 객체
     * - WAIT: 승인대기
     * - OK: 승인완료
     * - RJCT: 반려
     * - CNL: 신청취소
     */
    var STTS_TEXT = {
        WAIT: "승인대기",
        OK:   "승인완료",
        RJCT: "반려",
        CNL:  "신청취소"
    };

    /*
     * safe(value)
     * - null, undefined 값이 화면에 그대로 출력되는 것을 방지
     * - 화면 출력이나 문자열 조합 전에 기본 문자열로 변환
     */
    function safe(value) {
        return value == null ? "" : String(value);
    }

    /*
     * escapeHtml(value)
     * - 서버 데이터가 HTML 문자열로 조립될 때 태그로 해석되지 않게 변환
     * - 사용자명, 아이디, 번호 등 외부 입력값을 cellRenderer 안에 넣을 때 사용
     */
    function escapeHtml(value) {
        return safe(value)
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/\"/g, "&quot;")
            .replace(/'/g, "&#39;");
    }

    /*
     * dutyText(code)
     * - 직무코드를 한글 직무명으로 변환
     * - 알 수 없는 코드면 "-" 표시
     */
    function dutyText(code) {
        return DUTY_TEXT[code] || "-";
    }

    /*
     * normalizeStatus(code)
     * - 상태코드가 소문자로 들어와도 비교 가능하도록 대문자로 통일
     * - WAIT/wait/Wait 모두 WAIT로 처리
     */
    function normalizeStatus(code) {
        return String(code || "").toUpperCase();
    }

    /*
     * sttsText(code)
     * - 요청 상태코드를 한글 상태명으로 변환
     * - 상태 비교 전 normalizeStatus()를 거쳐 대소문자 차이를 방어
     */
    function sttsText(code) {
        return STTS_TEXT[normalizeStatus(code)] || "-";
    }

    /*
     * badge(text, className)
     * - 그리드 안에서 공통 badge HTML 생성
     * - text: badge에 표시할 문구
     * - className: 색상/상태를 구분하기 위한 CSS 클래스명
     */
    function badge(text, className) {
        return '<span class="grid-badge ' + className + '">' + escapeHtml(text) + '</span>';
    }

    /*
     * dutyBadge(code)
     * - 직무코드에 맞는 CSS 클래스를 선택한 뒤 badge HTML 생성
     * - 직무별 색상 구분은 CSS 클래스에서 처리
     */
    function dutyBadge(code) {
        var cls = code === "ACNT" ? "duty-acnt"
            : code === "ADM" ? "duty-adm"
                : code === "FAC" ? "duty-fac"
                    : "gray";

        return badge(dutyText(code), cls);
    }

    /*
     * statusBadge(code)
     * - 요청상태코드에 맞는 CSS 클래스를 선택한 뒤 badge HTML 생성
     * - WAIT/OK/RJCT 외 상태는 gray로 표시
     */
    function statusBadge(code) {
        var status = normalizeStatus(code);

        var cls = status === "WAIT" ? "status-wait"
            : status === "OK" ? "status-aprv"
                : status === "RJCT" ? "status-rjct"
                    : "gray";

        return badge(sttsText(status), cls);
    }

    /*
     * useYnBadge(code)
     * - MEMBER.USER_YN 값을 활성/비활성 badge로 변환
     * - Y: 활성, 그 외: 비활성
     */
    function useYnBadge(code) {
        return badge(
            code === "Y" ? "활성" : "비활성",
            code === "Y" ? "status-active" : "status-inactive"
        );
    }

    /*
     * avatarCell(name, sub)
     * - 직원명/요청직원명을 아바타 형태로 보여주는 셀 HTML 생성
     * - name: 이름 영역에 표시할 값
     * - sub: 이름 아래 보조정보 영역에 표시할 값, 보통 로그인 아이디
     */
    function avatarCell(name, sub) {
        return '<div class="avatar-row">'
            + '<div class="avatar avatar-sm">' + escapeHtml(name ? name.charAt(0) : "-") + '</div>'
            + '<div class="avatar-info">'
            + '<div class="name">' + escapeHtml(name) + '</div>'
            + '<div class="sub">' + escapeHtml(sub) + '</div>'
            + '</div></div>';
    }

    /*
     * formatDate(value)
     * - 서버에서 받은 날짜를 화면 표시용으로 변환
     * - yyyy-MM-dd 형태가 포함되어 있으면 yyyy.MM.dd로 표시
     * - 값이 없으면 "-" 표시
     */
    function formatDate(value) {
        if (!value) return "-";

        var str = String(value);

        if (str.length >= 10 && str.indexOf("-") > -1) {
            return str.substring(0, 10).replaceAll("-", ".");
        }

        return str;
    }

    /*
     * setRows(gridEl, rows)
     * - 이미 생성된 AG Grid에 새 목록 데이터를 반영
     * - manager-agGrid.js의 setGridRowData()가 있으면 공통 함수 우선 사용
     * - 없으면 gridEl.__gridApi를 직접 사용
     */
    function setRows(gridEl, rows) {
        if (typeof setGridRowData === "function") {
            setGridRowData(gridEl, rows);
            return;
        }

        if (gridEl && gridEl.__gridApi) {
            gridEl.__gridApi.setGridOption("rowData", rows || []);
        }
    }

    /*
     * createGrids(option)
     * - 재직 직원 그리드와 계정 생성 요청 그리드를 생성
     *
     * option.managerGridEl  : 재직 직원 그리드를 그릴 DOM 요소
     * option.requestGridEl  : 요청 목록 그리드를 그릴 DOM 요소
     * option.managerRowData : 재직 직원 목록 데이터
     * option.requestRowData : 계정 생성 요청 목록 데이터
     * option.isAdmin        : 현재 사용자가 ADMIN인지 여부
     */
    function createGrids(option) {
        var managerGridEl = option.managerGridEl;
        var requestGridEl = option.requestGridEl;
        var managerRowData = option.managerRowData || [];
        var requestRowData = option.requestRowData || [];
        var isAdmin = option.isAdmin === true;

        /*
         * ADMIN은 조회만 가능하므로 수정 버튼에 비활성 클래스와 title 부여
         * 요청 목록의 수정/취소 버튼은 ADMIN에게 아예 렌더링하지 않음
         */
        var adminDisabled = isAdmin ? " is-disabled" : "";
        var adminTitle = isAdmin ? ' title="관리자는 조회만 가능합니다."' : "";

        /* 기존 그리드가 있으면 다시 생성하기 전에 제거 */
        if (typeof destroyManagerGrid === "function") {
            destroyManagerGrid(managerGridEl);
            destroyManagerGrid(requestGridEl);
        }

        /* 공통 그리드 생성 함수가 없으면 더 이상 진행하지 않음 */
        if (typeof createManagerGrid !== "function") return;

        /* 재직 직원 그리드 생성 */
        createManagerGrid(managerGridEl, [
            {
                headerName: "직원",
                field: "userNm",
                width: 200,
                cellRenderer: function (p) {
                    return avatarCell(p.data.userNm, p.data.userId);
                }
            },
            {
                headerName: "직무",
                field: "mngrDutyCd",
                width: 120,
                cellRenderer: function (p) {
                    return dutyBadge(p.value);
                }
            },
            { headerName: "연락처", field: "telno", width: 140 },
            { headerName: "이메일", field: "userEml", width: 200 },
            {
                headerName: "상태",
                field: "userYn",
                width: 90,
                cellRenderer: function (p) {
                    return useYnBadge(p.value);
                }
            },
            {
                headerName: "관리",
                field: "userNo",
                width: 140,
                sortable: false,
                cellRenderer: function (p) {
                    return '<div class="grid-actions">'
                        + '<button type="button" class="btn btn-detail" data-action="manager-detail" data-user-no="' + escapeHtml(p.data.userNo) + '">상세</button>'
                        + '<button type="button" class="btn btn-edit' + adminDisabled + '" data-action="manager-edit" data-user-no="' + escapeHtml(p.data.userNo) + '"' + adminTitle + '>수정</button>'
                        + '</div>';
                }
            }
        ], managerRowData, { domLayout: "autoHeight", paginationPageSize: 10 });

        /* 계정 생성 요청 그리드 생성 */
        createManagerGrid(requestGridEl, [
            {
                headerName: "요청 직원",
                field: "rqstMngrNm",
                width: 200,
                cellRenderer: function (p) {
                    return avatarCell(p.data.rqstMngrNm, p.data.rqstLoginId);
                }
            },
            {
                headerName: "직무",
                field: "rqstDutyCd",
                width: 120,
                cellRenderer: function (p) {
                    return dutyBadge(p.value);
                }
            },
            {
                headerName: "요청일",
                field: "rqstDt",
                width: 120,
                valueFormatter: function (p) {
                    return formatDate(p.value);
                }
            },
            {
                headerName: "처리일",
                field: "aprvDt",
                width: 120,
                valueFormatter: function (p) {
                    return formatDate(p.value);
                }
            },
            {
                headerName: "상태",
                field: "rqstSttsCd",
                width: 110,
                cellRenderer: function (p) {
                    return statusBadge(p.value);
                }
            },
            {
                headerName: "관리",
                field: "rqstNo",
                width: 180,
                sortable: false,
                cellRenderer: function (p) {
                    var status = normalizeStatus(p.data.rqstSttsCd);

                    /* WAIT 상태가 아니면 수정/취소 버튼은 보이되 동작하지 않게 처리 */
                    var statusDisabled = status === "WAIT" ? "" : " is-disabled";
                    var statusTitle = statusDisabled ? ' title="승인대기 상태의 요청만 가능합니다."' : "";

                    return '<div class="grid-actions">'
                        + '<button type="button" class="btn btn-detail" data-action="request-detail" data-rqst-no="' + escapeHtml(p.data.rqstNo) + '">상세</button>'
                        + (isAdmin ? "" : '<button type="button" class="btn btn-edit' + statusDisabled + '" data-action="request-edit" data-rqst-no="' + escapeHtml(p.data.rqstNo) + '"' + statusTitle + '>수정</button>')
                        + (isAdmin ? "" : '<button type="button" class="btn btn-delete' + statusDisabled + '" data-action="request-cancel" data-rqst-no="' + escapeHtml(p.data.rqstNo) + '"' + statusTitle + '>취소</button>')
                        + '</div>';
                }
            }
        ], requestRowData, { domLayout: "autoHeight", paginationPageSize: 10 });
    }

    /*
     * window.MngrAccountGrid
     * - mngr-account.js에서 사용할 수 있도록 그리드 관련 함수만 전역 객체로 공개
     * - 화면 이벤트/서버 통신 로직은 이 파일에 두지 않음
     */
    window.MngrAccountGrid = {
        safe: safe,
        escapeHtml: escapeHtml,
        dutyText: dutyText,
        sttsText: sttsText,
        normalizeStatus: normalizeStatus,
        formatDate: formatDate,
        setRows: setRows,
        createGrids: createGrids
    };

})();
