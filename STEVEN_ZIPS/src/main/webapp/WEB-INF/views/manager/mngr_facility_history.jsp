<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리사무소</title>

    <!-- Spring Security CSRF 토큰: fetch/ajax POST 연결 시 사용 가능 -->
    <sec:csrfMetaTags/>

    <!-- 공통 한글 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <!-- 공통 아이콘 폰트: material-symbols-rounded 클래스에서 사용 -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <!-- 전체 관리사무소 레이아웃 CSS: 사이드바, 헤더, main-wrap 등 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

    <!-- 관리사무소 공통 화면 CSS: page-header, panel, modal, form, table, badge, button 등 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>
        #facilityCheckHistoryPage .filter-select{width:150px} #facilityCheckHistoryPage .filter-date{width:150px} #facilityCheckHistoryPage .filter-keyword{width:280px}
        #facilityCheckHistoryPage .tbl{width:100%;table-layout:auto;border-collapse:collapse} #facilityCheckHistoryPage .tbl th,#facilityCheckHistoryPage .tbl td{box-sizing:border-box;vertical-align:middle;white-space:nowrap;text-align:center!important}
        #facilityCheckHistoryPage .td-mono,#facilityCheckHistoryPage .manage-col{text-align:center!important}
        #facilityCheckHistoryPage .grid-actions{display:inline-flex;align-items:center;justify-content:center;gap:8px;white-space:nowrap}
        #facilityCheckHistoryPage #deleteBtn{display:none}
    </style>

    <!-- 관리사무소 공통 JS: 사이드바/공통 이벤트가 있으면 사용 -->
    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
</head>

<body>
<div class="app-wrapper">

    <!-- 관리사무소 좌측 사이드바 include -->
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <!-- 관리사무소 상단 헤더 include -->
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">
            <div class="office-page" id="facilityCheckHistoryPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>유지보수·점검 이력</h2>
                        <p>시설별 유지보수 및 점검 이력을 조회하고 등록·수정합니다.</p>
                    </div>

                    <div class="page-actions">
                        <button type="button" class="btn btn-secondary" data-action="reset">
                            <span class="material-symbols-rounded">refresh</span>
                            초기화
                        </button>
                        <button type="button" class="btn btn-primary" data-action="open-create">
                            <span class="material-symbols-rounded">add</span>
                            이력 등록
                        </button>
                    </div>
                </div>

                <div class="summary-row">
                    <div class="summary-card s-blue">
                        <div class="s-icon">
                            <span class="material-symbols-rounded">history</span>
                        </div>
                        <div>
                            <div class="s-val" id="totalCount">2</div>
                            <div class="s-label">전체 이력</div>
                        </div>
                    </div>

                    <div class="summary-card s-green">
                        <div class="s-icon">
                            <span class="material-symbols-rounded">check_circle</span>
                        </div>
                        <div>
                            <div class="s-val" id="normalCount">1</div>
                            <div class="s-label">정상 이력</div>
                        </div>
                    </div>

                    <div class="summary-card s-yellow">
                        <div class="s-icon">
                            <span class="material-symbols-rounded">build_circle</span>
                        </div>
                        <div>
                            <div class="s-val" id="progressCount">1</div>
                            <div class="s-label">진행 중</div>
                        </div>
                    </div>

                    <div class="summary-card s-red">
                        <div class="s-icon">
                            <span class="material-symbols-rounded">error</span>
                        </div>
                        <div>
                            <div class="s-val" id="issueCount">0</div>
                            <div class="s-label">이상 이력</div>
                        </div>
                    </div>
                </div>

                <div class="filter-card">
                    <select class="form-select filter-select" id="filterType">
                        <option value="">점검유형 전체</option>
                        <option value="정기">정기</option>
                        <option value="법정">법정</option>
                        <option value="긴급">긴급</option>
                        <option value="유지보수">유지보수</option>
                    </select>

                    <select class="form-select filter-select" id="filterStatus">
                        <option value="">상태 전체</option>
                        <option value="정상">정상</option>
                        <option value="진행중">진행중</option>
                        <option value="이상">이상</option>
                    </select>

                    <input type="date" class="form-input filter-date" id="filterStartDate">
                    <input type="date" class="form-input filter-date" id="filterEndDate">

                    <div class="search-wrap filter-keyword">
                        <span class="material-symbols-rounded">search</span>
                        <input type="text" class="form-input" id="filterKeyword"
                               placeholder="이력번호, 시설번호, 업체번호 검색">
                    </div>

                    <button type="button" class="btn btn-primary" data-action="search">
                        조회
                    </button>
                </div>

                <div class="panel">
                    <div class="panel-header">
                        <div>
                            <div class="panel-title">
                                <span class="material-symbols-rounded">fact_check</span>
                                이력 목록
                            </div>
                        </div>
                        <span class="list-count">FACILITY_CHECK_HISTORY</span>
                    </div>

                    <div class="table-wrap">
                        <table class="tbl">
                            <thead>
                            <tr>
                                <th>이력번호</th>
                                <th>시설번호</th>
                                <th>업체번호</th>
                                <th>점검유형</th>
                                <th>점검일자</th>
                                <th>점검상태</th>
                                <th>점검내용</th>
                                <th class="manage-col">관리</th>
                            </tr>
                            </thead>
                            <tbody id="historyTbody"></tbody>
                        </table>
                    </div>
                </div>

                <div class="modal-overlay" id="historyModal">
                    <div class="modal modal-lg">
                        <div class="modal-header">
                            <h3 class="modal-title" id="historyModalTitle">이력 등록</h3>
                            <button type="button" class="modal-close" data-action="close-modal">
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>

                        <form id="historyForm">
                            <div class="modal-body">
                                <input type="hidden" id="formMode" value="create">

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">info</span>
                                        점검 기본 정보
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">시설점검이력번호</label>
                                            <input type="text" class="form-input" id="facChkHstryNo"
                                                   placeholder="신규 등록 시 자동 생성 예정">
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">점검일자 <span class="req">*</span></label>
                                            <input type="date" class="form-input" id="chkDt" required>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">시설번호 <span class="req">*</span></label>
                                            <input type="text" class="form-input" id="facilityNo"
                                                   placeholder="예: FAC-001" required>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">업체번호 <span class="req">*</span></label>
                                            <input type="text" class="form-input" id="partnerNo"
                                                   placeholder="예: PT-001" required>
                                        </div>
                                    </div>

                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">점검유형코드</label>
                                            <select class="form-select" id="chkTyCd">
                                                <option value="정기">정기</option>
                                                <option value="법정">법정</option>
                                                <option value="긴급">긴급</option>
                                                <option value="유지보수">유지보수</option>
                                            </select>
                                        </div>

                                        <div class="form-field">
                                            <label class="field-label">점검상태코드</label>
                                            <select class="form-select" id="chkSttsCd">
                                                <option value="정상">정상</option>
                                                <option value="진행중">진행중</option>
                                                <option value="이상">이상</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">description</span>
                                        점검 내용
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">점검내용</label>
                                            <textarea class="form-textarea" id="chkCn"
                                                      placeholder="점검 내용 또는 유지보수 조치 내용을 입력하세요."></textarea>
                                        </div>
                                    </div>

                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">비고</label>
                                            <textarea class="form-textarea" id="rmk"
                                                      placeholder="특이사항이 있으면 입력하세요."></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-action="close-modal">취소</button>
                                <button type="button" class="btn btn-danger" id="deleteBtn" data-action="delete">
                                    삭제
                                </button>
                                <button type="submit" class="btn btn-primary">저장</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                (function () {
                    const page = document.getElementById('facilityCheckHistoryPage');
                    if (!page || page.dataset.bound === 'true') return;
                    page.dataset.bound = 'true';

                    const historyList = [
                        {
                            facChkHstryNo: 'FCH-001',
                            facilityNo: 'FAC-001',
                            partnerNo: 'PT-001',
                            chkTyCd: '정기',
                            chkDt: '2026-04-20',
                            chkSttsCd: '정상',
                            chkCn: '승강기 안전장치 및 운행 상태 점검 완료',
                            rmk: '특이사항 없음'
                        },
                        {
                            facChkHstryNo: 'FCH-002',
                            facilityNo: 'FAC-014',
                            partnerNo: 'PT-003',
                            chkTyCd: '유지보수',
                            chkDt: '2026-04-22',
                            chkSttsCd: '진행중',
                            chkCn: '지하 급수펌프 소음 확인 및 부품 교체 진행',
                            rmk: '교체 완료 후 재점검 필요'
                        }
                    ];

                    function statusBadge(status) {
                        if (status === '정상') return '<span class="badge badge-green">정상</span>';
                        if (status === '진행중') return '<span class="badge badge-orange">진행중</span>';
                        if (status === '이상') return '<span class="badge badge-red">이상</span>';
                        return '<span class="badge badge-gray">' + status + '</span>';
                    }

                    function renderTable(list) {
                        const tbody = document.getElementById('historyTbody');
                        tbody.innerHTML = '';

                        list.forEach(function (item) {
                            const tr = document.createElement('tr');

                            tr.innerHTML =
                                '<td class="td-mono">' + item.facChkHstryNo + '</td>' +
                                '<td>' + item.facilityNo + '</td>' +
                                '<td>' + item.partnerNo + '</td>' +
                                '<td>' + item.chkTyCd + '</td>' +
                                '<td>' + item.chkDt + '</td>' +
                                '<td>' + statusBadge(item.chkSttsCd) + '</td>' +
                                '<td>' + item.chkCn + '</td>' +
                                '<td>' +
                                '<div class="grid-actions">' +
                                '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-id="' + item.facChkHstryNo + '">상세</button>' +
                                '<button type="button" class="btn btn-xs btn-edit" data-action="edit" data-id="' + item.facChkHstryNo + '">수정</button>' +
                                '</div>' +
                                '</td>';

                            tbody.appendChild(tr);
                        });

                        updateSummary(list);
                    }

                    function updateSummary(list) {
                        document.getElementById('totalCount').textContent = list.length;
                        document.getElementById('normalCount').textContent =
                            list.filter(function (item) {
                                return item.chkSttsCd === '정상';
                            }).length;

                        document.getElementById('progressCount').textContent =
                            list.filter(function (item) {
                                return item.chkSttsCd === '진행중';
                            }).length;

                        document.getElementById('issueCount').textContent =
                            list.filter(function (item) {
                                return item.chkSttsCd === '이상';
                            }).length;
                    }

                    function findHistory(id) {
                        return historyList.find(function (item) {
                            return item.facChkHstryNo === id;
                        });
                    }

                    function openModal(mode, data) {
                        document.getElementById('formMode').value = mode;

                        document.getElementById('historyModalTitle').textContent =
                            mode === 'create' ? '이력 등록' :
                                mode === 'detail' ? '이력 상세' : '이력 수정';

                        document.getElementById('deleteBtn').style.display =
                            mode === 'edit' ? 'inline-flex' : 'none';

                        document.getElementById('facChkHstryNo').value = data ? data.facChkHstryNo : '';
                        document.getElementById('facilityNo').value = data ? data.facilityNo : '';
                        document.getElementById('partnerNo').value = data ? data.partnerNo : '';
                        document.getElementById('chkTyCd').value = data ? data.chkTyCd : '정기';
                        document.getElementById('chkDt').value = data ? data.chkDt : '';
                        document.getElementById('chkSttsCd').value = data ? data.chkSttsCd : '정상';
                        document.getElementById('chkCn').value = data ? data.chkCn : '';
                        document.getElementById('rmk').value = data ? data.rmk : '';

                        const readonly = mode === 'detail';

                        page.querySelectorAll('#historyForm input, #historyForm select, #historyForm textarea')
                            .forEach(function (el) {
                                if (el.id !== 'formMode') {
                                    el.disabled = readonly;
                                }
                            });

                        page.querySelector('#historyForm button[type="submit"]').style.display =
                            readonly ? 'none' : 'inline-flex';

                        document.getElementById('historyModal').style.display = 'flex';
                    }

                    function closeModal() {
                        document.getElementById('historyModal').style.display = 'none';

                        page.querySelectorAll('#historyForm input, #historyForm select, #historyForm textarea')
                            .forEach(function (el) {
                                el.disabled = false;
                            });
                    }

                    function searchList() {
                        const type = document.getElementById('filterType').value;
                        const status = document.getElementById('filterStatus').value;
                        const startDate = document.getElementById('filterStartDate').value;
                        const endDate = document.getElementById('filterEndDate').value;
                        const keyword = document.getElementById('filterKeyword').value.trim();

                        const filtered = historyList.filter(function (item) {
                            const matchType = !type || item.chkTyCd === type;
                            const matchStatus = !status || item.chkSttsCd === status;
                            const matchStart = !startDate || item.chkDt >= startDate;
                            const matchEnd = !endDate || item.chkDt <= endDate;
                            const matchKeyword = !keyword ||
                                item.facChkHstryNo.includes(keyword) ||
                                item.facilityNo.includes(keyword) ||
                                item.partnerNo.includes(keyword);

                            return matchType && matchStatus && matchStart && matchEnd && matchKeyword;
                        });

                        renderTable(filtered);
                    }

                    page.addEventListener('click', function (event) {
                        const btn = event.target.closest('[data-action]');
                        if (!btn) return;

                        const action = btn.dataset.action;
                        const id = btn.dataset.id;
                        const data = id ? findHistory(id) : null;

                        if (action === 'open-create') openModal('create');
                        if (action === 'detail' && data) openModal('detail', data);
                        if (action === 'edit' && data) openModal('edit', data);
                        if (action === 'close-modal') closeModal();
                        if (action === 'search') searchList();

                        if (action === 'reset') {
                            document.getElementById('filterType').value = '';
                            document.getElementById('filterStatus').value = '';
                            document.getElementById('filterStartDate').value = '';
                            document.getElementById('filterEndDate').value = '';
                            document.getElementById('filterKeyword').value = '';
                            renderTable(historyList);
                        }

                        if (action === 'delete') {
                            alert('삭제 로직은 백엔드 연결 시 FAC_CHK_HSTRY_NO 기준으로 처리하면 됩니다.');
                            closeModal();
                        }
                    });

                    document.getElementById('historyForm').addEventListener('submit', function (event) {
                        event.preventDefault();

                        alert('저장 로직은 백엔드 연결 시 insert/update로 분기하면 됩니다.');
                        closeModal();
                    });

                    renderTable(historyList);
                })();
            </script>
        </main>
    </div>
</div>
</body>
</html>