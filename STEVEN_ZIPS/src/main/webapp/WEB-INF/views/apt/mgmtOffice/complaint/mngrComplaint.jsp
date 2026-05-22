<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>민원 접수 현황 | 관리사무소</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <style>
        /* ── 테이블 ── */
        #cvplTable { table-layout: fixed; width: 100%; }
        #cvplTable th, #cvplTable td {
            text-align: center;
            vertical-align: middle;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        #cvplTable .col-no    { width: 80px; }
        #cvplTable .col-date  { width: 140px; }
        #cvplTable .col-unit  { width: 120px; }
        #cvplTable .col-name  { width: 140px; }
        #cvplTable .col-type  { width: 100px; }
        #cvplTable .col-stat  { width: 140px; }
        #cvplTable .col-mngr  { width: 120px; }
        #cvplTable .col-done  { width: 120px; }
        #cvplTable .col-act   { width: 120px; }

        /* ── 검색 조건 ── */
        .search-panel .search-row {
            display: flex;
            align-items: flex-end;
            gap: 12px;
            flex-wrap: wrap;
        }
        .search-panel .search-field {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .search-panel .search-field label {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-secondary);
            letter-spacing: 0.02em;
        }
        .search-panel .date-range {
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .search-panel .date-range input {
            width: 160px;
        }
        .search-panel .date-sep {
            font-size: 12px;
            color: var(--text-tertiary);
            flex-shrink: 0;
        }
        .search-panel select.filter-sel { width: 160px; }
        .search-panel .keyword-wrap {
            flex: 1;
            min-width: 220px;
            position: relative;
        }
        .search-panel .keyword-wrap .material-symbols-rounded {
            position: absolute;
            left: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
            color: var(--text-tertiary);
            pointer-events: none;
        }
        .search-panel .keyword-wrap input {
            width: 100%;
            padding-left: 34px;
            box-sizing: border-box;
        }
        .search-panel .search-actions {
            display: flex;
            gap: 8px;
            flex-shrink: 0;
        }
        /* 구분선 */
        .search-panel .search-divider {
            width: 1px;
            height: 32px;
            background: var(--border);
            flex-shrink: 0;
            align-self: flex-end;
            margin: 0 2px;
        }

        /* ── 슬라이드오버 ── */
        #cvplDetailModal .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 10px;
        }
        #cvplDetailModal .detail-grid .full { grid-column: span 2; }
        #cvplDetailModal .history-box {
            background: var(--gray-100);
            border: 1px solid var(--border);
            border-radius: var(--r-sm);
            padding: 12px 14px;
            font-size: 13px;
            line-height: 1.7;
            color: var(--text-secondary);
            min-height: 60px;
        }
    </style>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="complaintPage">

                <!-- 페이지 헤더 -->
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>민원 접수 현황</h2>
                        <p>입주민이 접수한 민원을 조회하고 처리 상태를 관리합니다.</p>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary" data-action="exportExcel">
                            <span class="material-symbols-rounded">download</span>
                            엑셀 다운로드
                        </button>
                    </div>
                </div>

                <!-- 검색 조건 -->
                <div class="panel search-panel">
                    <div class="panel-body">
                        <div class="search-row">
                            <!-- 접수 기간 -->
                            <div class="search-field">
                                <label>접수 기간</label>
                                <div class="date-range">
                                    <input type="date" class="form-input" id="filterDateFrom">
                                    <span class="date-sep">~</span>
                                    <input type="date" class="form-input" id="filterDateTo">
                                </div>
                            </div>

                            <div class="search-divider"></div>

                            <!-- 민원 유형 -->
                            <div class="search-field">
                                <label>민원 유형</label>
                                <select class="form-select filter-sel" id="filterType">
                                    <option value="">전체</option>
                                    <option value="FAC">시설/하자</option>
                                    <option value="SEC">보안/안전</option>
                                    <option value="ACC">회계/관리비</option>
                                    <option value="ENV">환경/위생</option>
                                    <option value="ETC">기타</option>
                                </select>
                            </div>

                            <!-- 처리 상태 -->
                            <div class="search-field">
                                <label>처리 상태</label>
                                <select class="form-select filter-sel" id="filterStatus">
                                    <option value="">전체</option>
                                    <option value="APLY">민원 신청됨</option>
                                    <option value="RCPT">민원 접수됨</option>
                                    <option value="SUPL">보완 요청</option>
                                    <option value="REJS">처리 불가</option>
                                    <option value="RJCT">반려</option>
                                    <option value="COMP">처리 완료</option>
                                    <option value="END">종결</option>
                                    <option value="CNCL">민원 취소됨</option>
                                </select>
                            </div>

                            <div class="search-divider"></div>

                            <!-- 검색어 -->
                            <div class="search-field" style="flex:1; min-width:150px;">
                                <label>검색어</label>
                                <div class="keyword-wrap">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="filterKeyword"
                                           placeholder="동/호수, 신고자명, 민원 제목">
                                </div>
                            </div>

                            <!-- 버튼 -->
                            <div class="search-actions">
                                <button type="button" class="btn btn-primary" data-action="search">검색</button>
                                <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 민원 목록 -->
                <div class="panel">
                    <div class="panel-header">
                        <div class="list-header-left">
                            <h3 class="panel-title">
                                <span class="material-symbols-rounded">format_list_bulleted</span>
                                민원 목록
                            </h3>
                            <span class="list-count" id="cvplListCount">0건</span>
                        </div>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl" id="cvplTable">
                            <colgroup>
                                <col class="col-no">
                                <col class="col-date">
                                <col class="col-unit">
                                <col class="col-name">
                                <col class="col-type">
                                <col class="col-title">
                                <col class="col-stat">
                                <col class="col-mngr">
                                <col class="col-done">
                                <col class="col-act">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>접수일시</th>
                                <th>동/호</th>
                                <th>신고자</th>
                                <th>유형</th>
                                <th style="text-align:left;">민원 제목</th>
                                <th>상태</th>
                                <th>담당자</th>
                                <th>처리일</th>
                                <th>관리</th>
                            </tr>
                            </thead>
                            <tbody id="cvplTableBody"></tbody>
                        </table>
                    </div>

                    <!-- 페이지네이션 -->
                    <div class="pagination">
                        <span class="pagination-info" id="pageInfo"></span>
                        <div class="pagination-btns" id="pageBtns"></div>
                    </div>
                </div>

            </div><!-- /office-page -->

            <!-- 민원 상세 슬라이드오버 모달 -->
            <div class="modal-overlay slideover" id="cvplDetailModal">
                <div class="modal modal-lg">
                    <div class="modal-header primary">
                        <h3 class="modal-title" id="detailModalTitle">민원 상세</h3>
                        <button type="button" class="modal-close" data-action="closeDetail">
                            <span class="material-symbols-rounded">close</span>
                        </button>
                    </div>

                    <div class="modal-body">
                        <!-- 기본 정보 -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <span class="material-symbols-rounded">info</span>
                                기본 정보
                            </div>
                            <div class="detail-grid">
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">민원번호</div>
                                    <div class="mngr-detail-value" id="dNo">-</div>
                                </div>
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">접수일시</div>
                                    <div class="mngr-detail-value" id="dDate">-</div>
                                </div>
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">신고자 (세대)</div>
                                    <div class="mngr-detail-value" id="dReporter">-</div>
                                </div>
                                <div class="mngr-detail-item">
                                    <div class="mngr-detail-label">민원 유형</div>
                                    <div class="mngr-detail-value" id="dType">-</div>
                                </div>
                                <div class="mngr-detail-item full">
                                    <div class="mngr-detail-label">현재 상태</div>
                                    <div class="mngr-detail-value" id="dStatus">-</div>
                                </div>
                            </div>
                        </div>

                        <!-- 민원 내용 -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <span class="material-symbols-rounded">description</span>
                                민원 내용
                            </div>
                            <div class="form-field" style="margin-bottom:10px;">
                                <label class="field-label">제목</label>
                                <div class="history-box" id="dTitle">-</div>
                            </div>
                            <div class="form-field">
                                <label class="field-label">상세 내용</label>
                                <div class="history-box" id="dContent" style="min-height:90px; white-space:pre-wrap;">-</div>
                            </div>
                        </div>

                        <!-- 처리 내역 -->
                        <div class="form-section">
                            <div class="form-section-title">
                                <span class="material-symbols-rounded">engineering</span>
                                처리 내역
                            </div>
                            <div class="form-row cols-2">
                                <div class="form-field">
                                    <label class="field-label">처리 담당자</label>
                                    <select class="form-select" id="dMngr">
                                        <option value="">담당자 선택</option>
                                        <option value="김관리">김관리</option>
                                        <option value="이담당">이담당</option>
                                        <option value="박직원">박직원</option>
                                        <option value="최주임">최주임</option>
                                    </select>
                                </div>
                                <div class="form-field">
                                    <label class="field-label">처리 상태 변경</label>
                                    <select class="form-select" id="dStatusChange">
                                        <option value="APLY">민원 신청됨</option>
                                        <option value="RCPT">민원 접수됨</option>
                                        <option value="SUPL">보완 요청</option>
                                        <option value="REJS">처리 불가</option>
                                        <option value="RJCT">반려</option>
                                        <option value="COMP">처리 완료</option>
                                        <option value="END">종결</option>
                                        <option value="CNCL">민원 취소됨</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-field">
                                <label class="field-label">처리 메모</label>
                                <textarea class="form-textarea" id="dMemo"
                                          placeholder="처리 내용, 사유 등을 입력하세요."
                                          style="min-height:80px;"></textarea>
                            </div>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-action="closeDetail">닫기</button>
                        <button type="button" class="btn btn-primary" data-action="saveDetail">
                            <span class="material-symbols-rounded">save</span>
                            처리 저장
                        </button>
                    </div>
                </div>
            </div>

            <script>
                (function () {
                    var page = document.getElementById("complaintPage");
                    if (!page || page.dataset.bound === "true") return;
                    page.dataset.bound = "true";

                    /* ── 더미 데이터 ── */
                    var rowData = [
                        { no:"C2025-001", date:"2025.05.22 09:14", dong:"101동", ho:"503호",  reporter:"김민준", type:"ETC",  title:"윗집 새벽 발소리 소음 심각",           content:"매일 새벽 1~3시 사이 윗집에서 쿵쿵 소리가 나 수면에 방해가 됩니다.", status:"APLY", mngr:"",      doneDate:"",           memo:"" },
                        { no:"C2025-002", date:"2025.05.22 10:31", dong:"102동", ho:"1203호", reporter:"이서연", type:"ETC",  title:"비장애인 장애인 주차구역 무단 주차 반복", content:"B동 장애인 주차구역에 동일 차량이 반복 주차합니다.",                    status:"RCPT", mngr:"김관리", doneDate:"",           memo:"현장 확인 후 차량 소유자 연락 예정" },
                        { no:"C2025-003", date:"2025.05.21 14:05", dong:"103동", ho:"201호",  reporter:"박준혁", type:"FAC",  title:"엘리베이터 버튼 고장 (3F 누름 안됨)",   content:"103동 엘리베이터 3층 버튼이 작동하지 않습니다.",                      status:"RCPT", mngr:"이담당", doneDate:"",           memo:"시설팀 출동 요청, 부품 수급 중" },
                        { no:"C2025-004", date:"2025.05.21 09:52", dong:"101동", ho:"1101호", reporter:"최지우", type:"ENV",  title:"지하주차장 쓰레기 악취 심함",            content:"지하주차장 P2 구역 근처 음식물 쓰레기 방치 악취.",                    status:"COMP", mngr:"박직원", doneDate:"2025.05.22", memo:"음식물 수거 완료. 해당 세대 경고 발송" },
                        { no:"C2025-005", date:"2025.05.20 16:20", dong:"104동", ho:"702호",  reporter:"정수아", type:"SEC",  title:"계단실 흡연으로 인한 연기 유입",          content:"계단실에서 담배 냄새가 올라옵니다. CCTV 확인 요청드립니다.",          status:"COMP", mngr:"최주임", doneDate:"2025.05.21", memo:"금연 스티커 추가 부착, CCTV 모니터링 강화" },
                        { no:"C2025-006", date:"2025.05.20 11:37", dong:"102동", ho:"305호",  reporter:"한동훈", type:"ETC",  title:"반려동물 짖는 소리 (밤 11시 이후)",      content:"밤 11시 이후에도 옆집 강아지가 계속 짖어 수면을 방해합니다.",        status:"RCPT", mngr:"김관리", doneDate:"",           memo:"해당 세대에 안내문 발송 완료" },
                        { no:"C2025-007", date:"2025.05.20 09:00", dong:"103동", ho:"904호",  reporter:"유수진", type:"FAC",  title:"공용 복도 조명 교체 필요",               content:"903호~905호 사이 복도 형광등이 나가 있어 밤에 매우 어둡습니다.",     status:"COMP", mngr:"이담당", doneDate:"2025.05.20", memo:"조명 교체 완료" },
                        { no:"C2025-008", date:"2025.05.19 17:45", dong:"101동", ho:"801호",  reporter:"임재원", type:"ETC",  title:"이중주차로 출차 불가",                   content:"이중주차된 차량 때문에 출차를 못 했습니다. 차량번호 34나7890.",       status:"COMP", mngr:"박직원", doneDate:"2025.05.20", memo:"차량 이동 완료. 주차 위반 스티커 부착" },
                        { no:"C2025-009", date:"2025.05.19 13:10", dong:"104동", ho:"101호",  reporter:"오민석", type:"FAC",  title:"옥상 방수 불량으로 누수 발생",            content:"비가 오면 천장에서 물이 새 가구가 손상됩니다.",                       status:"RCPT", mngr:"최주임", doneDate:"",           memo:"방수 업체 점검 일정 조율 중 (05/24 예정)" },
                        { no:"C2025-010", date:"2025.05.18 10:55", dong:"102동", ho:"601호",  reporter:"강현아", type:"ETC",  title:"택배 무단 개봉 의심",                    content:"공용 택배함에 보관된 택배가 훼손된 채로 발견되었습니다.",              status:"APLY", mngr:"",      doneDate:"",           memo:"" },
                        { no:"C2025-011", date:"2025.05.17 15:30", dong:"103동", ho:"1502호", reporter:"서지훈", type:"ETC",  title:"피아노 연주 소음 (평일 낮)",              content:"낮에도 수 시간 피아노 연주 소리가 납니다.",                           status:"RJCT", mngr:"김관리", doneDate:"2025.05.19", memo:"낮 시간대 악기 연주는 규약상 제재 어려움" },
                        { no:"C2025-012", date:"2025.05.16 08:40", dong:"101동", ho:"302호",  reporter:"윤지민", type:"ENV",  title:"음식물 쓰레기통 위치 이전 요청",          content:"입구 쪽 음식물 쓰레기통에서 냄새가 심합니다.",                       status:"COMP", mngr:"이담당", doneDate:"2025.05.18", memo:"덮개 추가 설치 완료" },
                        { no:"C2025-013", date:"2025.05.15 14:20", dong:"104동", ho:"1001호", reporter:"배준수", type:"ETC",  title:"장기 방치 차량 처리 요청",               content:"A동 주차장에 같은 차량이 2주째 방치되어 있습니다.",                   status:"COMP", mngr:"박직원", doneDate:"2025.05.17", memo:"차량 소유자 연락 후 이동 완료" },
                        { no:"C2025-014", date:"2025.05.14 11:05", dong:"102동", ho:"1405호", reporter:"문소희", type:"FAC",  title:"헬스장 기구 파손 수리 요청",              content:"헬스장 런닝머신 2번 기계가 작동 불량입니다.",                         status:"RCPT", mngr:"최주임", doneDate:"",           memo:"업체 방문 점검 예약 완료 (05/23)" },
                        { no:"C2025-015", date:"2025.05.13 09:30", dong:"103동", ho:"404호",  reporter:"이준하", type:"ETC",  title:"어린이놀이터 안전 펜스 파손",             content:"놀이터 입구 펜스가 부러져 아이들이 다칠 위험이 있습니다.",            status:"COMP", mngr:"이담당", doneDate:"2025.05.15", memo:"펜스 수리 완료" }
                    ];

                    /* ── 상수 맵 ── */
                    var TYPE_TEXT  = { FAC:"시설/하자", SEC:"보안/안전", ACC:"회계/관리비", ENV:"환경/위생", ETC:"기타" };
                    var TYPE_BADGE = { FAC:"badge-green", SEC:"badge-red", ACC:"badge-blue", ENV:"badge-orange", ETC:"badge-gray" };
                    var STAT_TEXT  = { APLY:"민원 신청됨", RCPT:"민원 접수됨", SUPL:"보완 요청", REJS:"처리 불가", RJCT:"반려", COMP:"처리 완료", END:"종결", CNCL:"민원 취소됨" };
                    var STAT_BADGE = { APLY:"badge-yellow", RCPT:"badge-blue", SUPL:"badge-orange", REJS:"badge-gray", RJCT:"badge-gray", COMP:"badge-green", END:"badge-green", CNCL:"badge-gray" };

                    /* ── DOM 참조 ── */
                    var tbody       = document.getElementById("cvplTableBody");
                    var listCount   = document.getElementById("cvplListCount");
                    var pageInfo    = document.getElementById("pageInfo");
                    var pageBtns    = document.getElementById("pageBtns");
                    var detailModal = document.getElementById("cvplDetailModal");

                    /* ── 페이징 상태 ── */
                    var PAGE_SIZE   = 10;
                    var currentPage = 1;
                    var currentData = rowData.slice();

                    /* ── 배지 HTML ── */
                    function typeBadge(code) {
                        return '<span class="badge ' + (TYPE_BADGE[code] || "badge-gray") + '">' + (TYPE_TEXT[code] || code) + '</span>';
                    }
                    function statBadge(code) {
                        return '<span class="badge ' + (STAT_BADGE[code] || "badge-gray") + '">' + (STAT_TEXT[code] || code) + '</span>';
                    }

                    /* ── 테이블 렌더링 ── */
                    function renderTable(data, page) {
                        currentData = data;
                        currentPage = page || 1;

                        var total    = data.length;
                        var start    = (currentPage - 1) * PAGE_SIZE;
                        var end      = Math.min(start + PAGE_SIZE, total);
                        var pageData = data.slice(start, end);

                        listCount.textContent = total + "건";
                        pageInfo.textContent  = total === 0 ? "0건" : (start + 1) + "–" + end + " / " + total + "건";

                        if (pageData.length === 0) {
                            tbody.innerHTML = '<tr><td colspan="10" style="padding:34px 12px; color:var(--text-tertiary);">조건에 맞는 민원이 없습니다.</td></tr>';
                        } else {
                            tbody.innerHTML = pageData.map(function (row, i) {
                                var seq = start + i + 1;
                                return '<tr>'
                                    + '<td>' + seq + '</td>'
                                    + '<td class="td-mono">' + row.date + '</td>'
                                    + '<td>' + row.dong + ' ' + row.ho + '</td>'
                                    + '<td>' + row.reporter + '</td>'
                                    + '<td>' + typeBadge(row.type) + '</td>'
                                    + '<td style="text-align:left;" title="' + row.title + '">' + row.title + '</td>'
                                    + '<td>' + statBadge(row.status) + '</td>'
                                    + '<td>' + (row.mngr || '<span style="color:var(--text-tertiary)">-</span>') + '</td>'
                                    + '<td class="td-mono">' + (row.doneDate || '-') + '</td>'
                                    + '<td><button type="button" class="btn btn-xs btn-detail" data-action="openDetail" data-no="' + row.no + '">상세</button></td>'
                                    + '</tr>';
                            }).join("");
                        }
                        renderPager(total);
                    }

                    /* ── 페이지네이션 ── */
                    function renderPager(total) {
                        var totalPages = Math.ceil(total / PAGE_SIZE) || 1;
                        var html = '<button type="button" class="page-btn" data-page="prev"><span class="material-symbols-rounded">chevron_left</span></button>';
                        for (var p = 1; p <= totalPages; p++) {
                            html += '<button type="button" class="page-btn' + (p === currentPage ? ' active' : '') + '" data-page="' + p + '">' + p + '</button>';
                        }
                        html += '<button type="button" class="page-btn" data-page="next"><span class="material-symbols-rounded">chevron_right</span></button>';
                        pageBtns.innerHTML = html;
                    }

                    /* ── 필터링 ── */
                    function getFiltered() {
                        var type    = document.getElementById("filterType").value;
                        var status  = document.getElementById("filterStatus").value;
                        var keyword = document.getElementById("filterKeyword").value.trim();
                        var from    = document.getElementById("filterDateFrom").value;
                        var to      = document.getElementById("filterDateTo").value;

                        return rowData.filter(function (row) {
                            var dateStr = row.date.substring(0, 10).replace(/\./g, "-");
                            return (!type    || row.type === type)
                                && (!status  || row.status === status)
                                && (!keyword || row.reporter.indexOf(keyword) > -1
                                    || row.title.indexOf(keyword) > -1
                                    || (row.dong + " " + row.ho).indexOf(keyword) > -1)
                                && (!from    || dateStr >= from)
                                && (!to      || dateStr <= to);
                        });
                    }

                    /* ── 필터 초기화 ── */
                    function resetFilter() {
                        ["filterType","filterStatus","filterKeyword","filterDateFrom","filterDateTo"].forEach(function(id){
                            document.getElementById(id).value = "";
                        });
                        renderTable(rowData, 1);
                    }

                    /* ── 상세 모달 열기 ── */
                    function openDetail(no) {
                        var row = rowData.filter(function(r){ return r.no === no; })[0];
                        if (!row) return;

                        document.getElementById("detailModalTitle").textContent = "민원 상세 — " + row.no;
                        document.getElementById("dNo").textContent       = row.no;
                        document.getElementById("dDate").textContent     = row.date;
                        document.getElementById("dReporter").textContent = row.reporter + " (" + row.dong + " " + row.ho + ")";
                        document.getElementById("dType").textContent     = TYPE_TEXT[row.type] || row.type;
                        document.getElementById("dStatus").innerHTML     = statBadge(row.status);
                        document.getElementById("dTitle").textContent    = row.title;
                        document.getElementById("dContent").textContent  = row.content;
                        document.getElementById("dMngr").value           = row.mngr || "";
                        document.getElementById("dStatusChange").value   = row.status;
                        document.getElementById("dMemo").value           = row.memo || "";

                        detailModal.dataset.currentNo = no;
                        detailModal.classList.add("open");
                    }

                    /* ── 상세 모달 닫기 ── */
                    function closeDetail() {
                        detailModal.classList.remove("open");
                    }

                    /* ── 처리 저장 ── */
                    function saveDetail() {
                        var no  = detailModal.dataset.currentNo;
                        var row = rowData.filter(function(r){ return r.no === no; })[0];
                        if (!row) return;

                        row.mngr   = document.getElementById("dMngr").value;
                        row.status = document.getElementById("dStatusChange").value;
                        row.memo   = document.getElementById("dMemo").value;

                        if (row.status === "COMP" || row.status === "END" || row.status === "RJCT") {
                            var today = new Date();
                            var pad = function(v){ return String(v).padStart(2,"0"); };
                            row.doneDate = today.getFullYear() + "." + pad(today.getMonth()+1) + "." + pad(today.getDate());
                        }

                        renderTable(getFiltered(), currentPage);
                        closeDetail();
                    }

                    /* ── 이벤트 위임 ── */
                    page.addEventListener("click", function (e) {
                        var btn = e.target.closest("[data-action]");
                        if (!btn) return;
                        var action = btn.dataset.action;
                        if (action === "search")      renderTable(getFiltered(), 1);
                        if (action === "resetFilter") resetFilter();
                        if (action === "openDetail")  openDetail(btn.dataset.no);
                        if (action === "exportExcel") alert("엑셀 다운로드 기능은 서버 연동 후 구현 예정입니다.");
                    });

                    /* ── 검색어 엔터키 ── */
                    document.getElementById("filterKeyword").addEventListener("keydown", function(e){
                        if (e.key === "Enter") renderTable(getFiltered(), 1);
                    });

                    pageBtns.addEventListener("click", function (e) {
                        var btn = e.target.closest("[data-page]");
                        if (!btn) return;
                        var p = btn.dataset.page;
                        var totalPages = Math.ceil(currentData.length / PAGE_SIZE) || 1;
                        if (p === "prev")      currentPage = Math.max(1, currentPage - 1);
                        else if (p === "next") currentPage = Math.min(totalPages, currentPage + 1);
                        else                   currentPage = Number(p);
                        renderTable(currentData, currentPage);
                    });

                    detailModal.addEventListener("click", function (e) {
                        if (e.target === detailModal) closeDetail();
                        var btn = e.target.closest("[data-action]");
                        if (!btn) return;
                        if (btn.dataset.action === "closeDetail") closeDetail();
                        if (btn.dataset.action === "saveDetail")  saveDetail();
                    });

                    /* ── 초기 렌더 ── */
                    renderTable(rowData, 1);
                })();
            </script>
        </main>
    </div>
</div>
</body>
</html>
