/**
 * ============================================================
 * mngr-account-grid.js
 * 직원 계정 관리 화면 AG Grid 전용 스크립트
 *
 * 배포 위치: /js/manager/mngr-account-grid.js
 *
 * 전제 (로드 순서):
 *   1. ag-grid-community.min.js
 *   2. manager-common.js
 *   3. manager-agGrid.js
 *   4. AgRenderer.js          ← 추가됨
 *   5. mngr-account-grid.js  ← 이 파일
 * ============================================================
 */
(function () {

    /* ─────────────────────────────────────────────
       계정 관리 화면 전용 코드맵
       (AgRenderer.CODE 에 없는 이 화면만의 코드)
    ───────────────────────────────────────────── */

    /*
     * DUTY_TEXT
     * 직무코드 → 한글명 (상세 모달 텍스트 표시용)
     * ※ 그리드 배지는 AgRenderer.CODE.JOB_TY 사용
     */
    var DUTY_TEXT = {
        HEAD: '관리소장',
        ACNT: '회계담당',
        ADM:  '행정담당',
        FAC:  '시설담당'
    };

    /*
     * STTS_TEXT
     * 요청상태코드 → 한글명 (상세 모달 텍스트 표시용)
     * ※ 그리드 배지는 AgRenderer.CODE.ACNT_RQST_STTS 사용
     */
    var STTS_TEXT = {
        WAIT: '승인대기',
        OK:   '승인완료',
        RJCT: '반려',
        CNL:  '신청취소'
    };


    /* ─────────────────────────────────────────────
       텍스트 변환 유틸 (모달 표시용 — 그리드 외부에서 사용)
    ───────────────────────────────────────────── */

    /*
     * normalizeStatus(code)
     * 상태코드를 대문자로 통일해 대소문자 차이 방어
     */
    function normalizeStatus(code) {
        return String(code || '').toUpperCase();
    }

    /*
     * dutyText(code)
     * 직무코드 → 한글 직무명 (모달 표시용)
     */
    function dutyText(code) {
        return DUTY_TEXT[normalizeStatus(code)] || '-';
    }

    /*
     * sttsText(code)
     * 요청상태코드 → 한글 상태명 (모달 표시용)
     */
    function sttsText(code) {
        return STTS_TEXT[normalizeStatus(code)] || '-';
    }


    /* ─────────────────────────────────────────────
       createGrids(option)
       재직 직원 그리드 + 계정 생성 요청 그리드 생성
    ───────────────────────────────────────────── */

    /*
     * option.managerGridEl  : 재직 직원 그리드 DOM 요소
     * option.requestGridEl  : 요청 목록 그리드 DOM 요소
     * option.managerRowData : 재직 직원 목록 데이터
     * option.requestRowData : 요청 목록 데이터
     * option.isAdmin        : 현재 사용자가 ADMIN 인지 여부
     */
    function createGrids(option) {
        var managerGridEl  = option.managerGridEl;
        var requestGridEl  = option.requestGridEl;
        var managerRowData = option.managerRowData || [];
        var requestRowData = option.requestRowData || [];
        var isAdmin        = option.isAdmin === true;

        /* 기존 그리드 제거 후 재생성 */
        if (typeof destroyManagerGrid === 'function') {
            destroyManagerGrid(managerGridEl);
            destroyManagerGrid(requestGridEl);
        }

        if (typeof createManagerGrid !== 'function') return;

        /* ── 재직 직원 그리드 ── */
        createManagerGrid(
            managerGridEl,
            [
                {
                    /* 직원명 + 로그인 아이디 — AgRenderer.user.by 사용 */
                    headerName: '직원',
                    field:      'userNm',
                    width:      200,
                    cellRenderer: AgRenderer.user.by('userNm', 'userId')
                },
                {
                    /* 직무 배지 — AgRenderer.CODE.JOB_TY 사용 */
                    headerName:   '직무',
                    field:        'mngrDutyCd',
                    width:        120,
                    cellRenderer: AgRenderer.badge(AgRenderer.CODE.JOB_TY)
                },
                { headerName: '연락처', field: 'telno',   width: 140 },
                {
                    /* 이메일 말줄임 */
                    headerName:   '이메일',
                    field:        'userEml',
                    width:        200,
                    cellRenderer: AgRenderer.text
                },
                {
                    /* 활성/비활성 배지 — AgRenderer.yn 사용 */
                    headerName:   '상태',
                    field:        'userYn',
                    width:        90,
                    cellRenderer: AgRenderer.yn('활성', '비활성')
                },
                {
                    /*
                     * 관리 버튼
                     * ADMIN: 상세만 / 일반: 상세 + 수정
                     * data-action 값은 mngr-account.js 이벤트 위임에서 처리
                     */
                    headerName: '관리',
                    field:      'userNo',
                    width:      isAdmin ? 90 : 140,
                    sortable:   false,
                    filter:     false,
                    cellRenderer: isAdmin
                        ? AgRenderer.actions(['상세'])
                        : AgRenderer.actions([
                            { label: '상세', action: 'manager-detail', cls: 'btn-detail' },
                            { label: '수정', action: 'manager-edit',   cls: 'btn-edit'   }
                        ])
                }
            ],
            managerRowData,
            { domLayout: 'autoHeight', paginationPageSize: 10 }
        );

        /* ── 계정 생성 요청 그리드 ── */
        createManagerGrid(
            requestGridEl,
            [
                {
                    /* 요청 직원명 + 로그인 아이디 */
                    headerName:   '요청 직원',
                    field:        'rqstMngrNm',
                    width:        250,
                    cellRenderer: AgRenderer.user.by('rqstMngrNm', 'rqstLoginId')
                },
                {
                    /* 직무 배지 */
                    headerName:   '직무',
                    field:        'rqstDutyCd',
                    width:        150,
                    cellRenderer: AgRenderer.badge(AgRenderer.CODE.JOB_TY)
                },
                {
                    /* 요청일 yyyy.MM.dd */
                    headerName:   '요청일',
                    field:        'rqstDt',
                    width:        150,
                    cellRenderer: AgRenderer.date.dot
                },
                {
                    /* 처리일 yyyy.MM.dd */
                    headerName:   '처리일',
                    field:        'aprvDt',
                    width:        150,
                    cellRenderer: AgRenderer.date.dot
                },
                {
                    /* 요청상태 배지 */
                    headerName:   '상태',
                    field:        'rqstSttsCd',
                    width:        140,
                    cellRenderer: AgRenderer.badge(AgRenderer.CODE.ACNT_RQST_STTS)
                },
                {
                    /*
                     * 관리 버튼
                     * ADMIN: 상세만
                     * 일반 + WAIT: 상세 + 수정 + 취소
                     * 일반 + 기타: 상세만 (수정/취소는 WAIT만 가능하므로 JS에서 is-disabled 처리)
                     *
                     * ※ 상태별 비활성화는 mngr-account.js onCellClicked에서 normalizeStatus 체크
                     */
                    headerName: '관리',
                    field:      'rqstNo',
                    width:      230,
                    sortable:   false,
                    filter:     false,
                    cellRenderer: isAdmin
                        ? AgRenderer.actions(['상세'])
                        : AgRenderer.actions([
                            { label: '상세', action: 'request-detail', cls: 'btn-detail' },
                            { label: '수정', action: 'request-edit',   cls: 'btn-edit'   },
                            { label: '취소', action: 'request-cancel', cls: 'btn-delete' }
                        ])
                }
            ],
            requestRowData,
            { domLayout: 'autoHeight', paginationPageSize: 10 }
        );
    }


    /* ─────────────────────────────────────────────
       window.MngrAccountGrid
       mngr-account.js 에서 사용할 공개 API
       ※ 그리드 렌더링 관련만 공개, 화면 동작 로직은 mngr-account.js
    ───────────────────────────────────────────── */
    window.MngrAccountGrid = {
        /* 모달 텍스트 표시용 — 그리드 배지와 별개 */
        normalizeStatus: normalizeStatus,
        dutyText:        dutyText,
        sttsText:        sttsText,

        /* 그리드 데이터 갱신 */
        setRows: function (gridEl, rows) {
            if (typeof setGridRowData === 'function') {
                setGridRowData(gridEl, rows);
            } else if (gridEl && gridEl.__gridApi) {
                gridEl.__gridApi.setGridOption('rowData', rows || []);
            }
        },

        /* 그리드 생성 */
        createGrids: createGrids
    };

})();