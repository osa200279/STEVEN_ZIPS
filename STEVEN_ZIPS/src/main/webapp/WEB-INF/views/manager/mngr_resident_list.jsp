<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="residentListPage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>입주민 목록</h2>
            <p>동·호수, 세대구분, 입주 상태 기준으로 입주민 정보를 조회합니다.</p>
        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">
                <span class="material-symbols-rounded">manage_search</span>
                검색 조건
            </h3>
        </div>

        <div class="panel-body">

            <div class="form-row cols-3">
                <div class="form-field">
                    <label class="field-label">단지명</label>
                    <select class="form-select" id="filterComplex">
                        <option value="">전체</option>
                        <option value="우리집아파트">우리집아파트</option>
                    </select>
                </div>

                <div class="form-field">
                    <label class="field-label">동</label>
                    <input type="text" class="form-input" id="filterDong" placeholder="예: 101동">
                </div>

                <div class="form-field">
                    <label class="field-label">호수</label>
                    <input type="text" class="form-input" id="filterHo" placeholder="예: 302호">
                </div>
            </div>

            <div class="form-row cols-3">
                <div class="form-field">
                    <label class="field-label">세대구분</label>
                    <select class="form-select" id="filterHouseholdType">
                        <option value="">전체</option>
                        <option value="HEAD">세대주</option>
                        <option value="MEMBER">세대원</option>
                    </select>
                </div>

                <div class="form-field">
                    <label class="field-label">입주상태</label>
                    <select class="form-select" id="filterMoveStatus">
                        <option value="">전체</option>
                        <option value="IN">입주</option>
                        <option value="OUT">전출</option>
                    </select>
                </div>

                <div class="form-field">
                    <label class="field-label">이름/연락처</label>
                    <div class="search-wrap">
                        <span class="material-symbols-rounded">search</span>
                        <input type="text" class="form-input" id="filterKeyword" placeholder="이름 또는 연락처 검색">
                    </div>
                </div>
            </div>

            <div class="form-row cols-3">
                <div class="form-field">
                    <label class="field-label">입주일 시작</label>
                    <input type="date" class="form-input" id="filterMoveInStart">
                </div>

                <div class="form-field">
                    <label class="field-label">입주일 종료</label>
                    <input type="date" class="form-input" id="filterMoveInEnd">
                </div>

                <div class="form-field">
                    <label class="field-label">&nbsp;</label>
                    <div class="page-actions" style="justify-content:flex-end;">
                        <button type="button" class="btn btn-secondary" id="btnResetResidentFilter">
                            <span class="material-symbols-rounded">refresh</span>
                            초기화
                        </button>
                        <button type="button" class="btn btn-primary" id="btnSearchResident">
                            <span class="material-symbols-rounded">search</span>
                            검색
                        </button>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="panel">
        <div class="panel-header">
            <h3 class="panel-title">
                <span class="material-symbols-rounded">groups</span>
                입주민 목록
            </h3>
            <span class="list-count" id="residentCount">0건</span>
        </div>

        <div class="manager-grid-wrap">
            <div id="residentGrid" class="ag-theme-alpine manager-ag-grid grid-size-10"></div>
        </div>
    </div>

    <div class="modal-overlay" id="residentModal">
        <div class="modal modal-lg">
            <form id="residentForm">
                <input type="hidden" id="residentNo" name="residentNo">

                <div class="modal-header primary" id="residentModalHeader">
                    <h3 class="modal-title" id="residentModalTitle">입주민 상세</h3>
                    <span class="badge badge-gray" id="residentModalBadge">상세</span>
                    <button type="button" class="modal-close" data-modal-close>
                        <span class="material-symbols-rounded">close</span>
                    </button>
                </div>

                <div class="modal-body">

                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-rounded">person</span>
                            기본 정보
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">이름</label>
                                <input type="text" class="form-input" id="userNm" readonly>
                            </div>

                            <div class="form-field">
                                <label class="field-label">연락처</label>
                                <input type="text" class="form-input" id="telno" readonly>
                            </div>
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">이메일</label>
                                <input type="text" class="form-input" id="userEml" readonly>
                            </div>

                            <div class="form-field">
                                <label class="field-label">회원번호</label>
                                <input type="text" class="form-input" id="userNo" readonly>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-rounded">home</span>
                            세대 정보
                        </div>

                        <div class="form-row cols-3">
                            <div class="form-field">
                                <label class="field-label">단지명</label>
                                <input type="text" class="form-input editable-field" id="complexName">
                            </div>

                            <div class="form-field">
                                <label class="field-label">동</label>
                                <input type="text" class="form-input editable-field" id="dong">
                            </div>

                            <div class="form-field">
                                <label class="field-label">호수</label>
                                <input type="text" class="form-input editable-field" id="ho">
                            </div>
                        </div>

                        <div class="form-row cols-3">
                            <div class="form-field">
                                <label class="field-label">세대구분</label>
                                <select class="form-select editable-field" id="householdType">
                                    <option value="HEAD">세대주</option>
                                    <option value="MEMBER">세대원</option>
                                </select>
                            </div>

                            <div class="form-field">
                                <label class="field-label">입주상태</label>
                                <select class="form-select editable-field" id="moveStatus">
                                    <option value="IN">입주</option>
                                    <option value="OUT">전출</option>
                                </select>
                            </div>

                            <div class="form-field">
                                <label class="field-label">입주일</label>
                                <input type="date" class="form-input editable-field" id="moveInDate">
                            </div>
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">퇴거일</label>
                                <input type="date" class="form-input editable-field" id="moveOutDate">
                            </div>

                            <div class="form-field">
                                <label class="field-label">비고</label>
                                <input type="text" class="form-input editable-field" id="rmrkCn">
                            </div>
                        </div>
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-modal-close>닫기</button>

                    <button type="button" class="btn btn-primary" id="btnChangeEditMode">
                        수정하기
                    </button>

                    <button type="submit" class="btn btn-primary" id="btnSaveResident" style="display:none;">
                        저장
                    </button>
                </div>
            </form>
        </div>
    </div>

</div>

<script>
    (function () {
        const page = document.getElementById("residentListPage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        const residentRowData = [
            {
                residentNo: 1,
                userNo: "U001",
                complexName: "우리집아파트",
                dong: "101동",
                ho: "302호",
                userNm: "김민수",
                telno: "010-1234-5678",
                userEml: "minsu@example.com",
                householdType: "HEAD",
                moveStatus: "IN",
                moveInDate: "2026-04-01",
                moveOutDate: "",
                rmrkCn: ""
            },
            {
                residentNo: 2,
                userNo: "U002",
                complexName: "우리집아파트",
                dong: "102동",
                ho: "804호",
                userNm: "이서연",
                telno: "010-9876-5432",
                userEml: "seoyeon@example.com",
                householdType: "MEMBER",
                moveStatus: "IN",
                moveInDate: "2026-04-10",
                moveOutDate: "",
                rmrkCn: "세대원"
            }
        ];

        let residentGridApi = null;

        function moveStatusBadge(value) {
            if (value === "IN")  return '<span class="grid-badge status-active">입주</span>';
            if (value === "OUT") return '<span class="grid-badge status-inactive">전출</span>';
            return '<span class="grid-badge gray">-</span>';
        }

        function householdBadge(value) {
            if (value === "HEAD")   return '<span class="grid-badge duty-head">세대주</span>';
            if (value === "MEMBER") return '<span class="grid-badge duty-adm">세대원</span>';
            return '<span class="grid-badge gray">-</span>';
        }

        function setResidentCount(count) {
            document.getElementById("residentCount").textContent = count + "건";
        }

        function getFilteredRows() {
            const complex      = document.getElementById("filterComplex").value;
            const dong         = document.getElementById("filterDong").value.trim();
            const ho           = document.getElementById("filterHo").value.trim();
            const householdType = document.getElementById("filterHouseholdType").value;
            const moveStatus   = document.getElementById("filterMoveStatus").value;
            const moveInStart  = document.getElementById("filterMoveInStart").value;
            const moveInEnd    = document.getElementById("filterMoveInEnd").value;
            const keyword      = document.getElementById("filterKeyword").value.trim();

            return residentRowData.filter(function (row) {
                return (!complex      || row.complexName === complex)
                    && (!dong         || row.dong.indexOf(dong) > -1)
                    && (!ho           || row.ho.indexOf(ho) > -1)
                    && (!householdType || row.householdType === householdType)
                    && (!moveStatus   || row.moveStatus === moveStatus)
                    && (!moveInStart  || row.moveInDate >= moveInStart)
                    && (!moveInEnd    || row.moveInDate <= moveInEnd)
                    && (!keyword      || row.userNm.indexOf(keyword) > -1 || row.telno.indexOf(keyword) > -1);
            });
        }

        function searchResidents() {
            const filteredRows = getFilteredRows();
            if (residentGridApi) residentGridApi.setGridOption("rowData", filteredRows);
            setResidentCount(filteredRows.length);
        }

        function resetResidentFilter() {
            ["filterComplex","filterDong","filterHo","filterHouseholdType",
                "filterMoveStatus","filterMoveInStart","filterMoveInEnd","filterKeyword"]
                .forEach(function(id){ document.getElementById(id).value = ""; });
            searchResidents();
        }

        function setModalMode(mode) {
            const isEdit = mode === "edit";

            document.getElementById("residentModalTitle").textContent  = isEdit ? "입주민 정보 수정" : "입주민 상세";
            document.getElementById("residentModalBadge").textContent  = isEdit ? "수정" : "상세";
            document.getElementById("residentModalBadge").className    = isEdit ? "badge badge-green" : "badge badge-gray";


            document.querySelectorAll("#residentModal .editable-field").forEach(function (el) {
                el.disabled = !isEdit;
                el.readOnly = !isEdit;
            });

            document.getElementById("btnChangeEditMode").style.display = isEdit ? "none"        : "inline-flex";
            document.getElementById("btnSaveResident").style.display   = isEdit ? "inline-flex" : "none";
        }

        function fillResidentForm(row) {
            document.getElementById("residentNo").value   = row.residentNo  || "";
            document.getElementById("userNo").value       = row.userNo      || "";
            document.getElementById("userNm").value       = row.userNm      || "";
            document.getElementById("telno").value        = row.telno       || "";
            document.getElementById("userEml").value      = row.userEml     || "";
            document.getElementById("complexName").value  = row.complexName || "";
            document.getElementById("dong").value         = row.dong        || "";
            document.getElementById("ho").value           = row.ho          || "";
            document.getElementById("householdType").value = row.householdType || "MEMBER";
            document.getElementById("moveStatus").value   = row.moveStatus  || "IN";
            document.getElementById("moveInDate").value   = row.moveInDate  || "";
            document.getElementById("moveOutDate").value  = row.moveOutDate || "";
            document.getElementById("rmrkCn").value       = row.rmrkCn      || "";
        }

        function openResidentModal(row, mode) {
            fillResidentForm(row);
            setModalMode(mode);
            document.getElementById("residentModal").classList.add("open");
        }

        function closeModal() {
            document.getElementById("residentModal").classList.remove("open");
        }

        function saveResident() {
            const residentNo = Number(document.getElementById("residentNo").value);
            const target = residentRowData.find(function (row) { return row.residentNo === residentNo; });
            if (!target) return;

            target.complexName  = document.getElementById("complexName").value;
            target.dong         = document.getElementById("dong").value;
            target.ho           = document.getElementById("ho").value;
            target.householdType = document.getElementById("householdType").value;
            target.moveStatus   = document.getElementById("moveStatus").value;
            target.moveInDate   = document.getElementById("moveInDate").value;
            target.moveOutDate  = document.getElementById("moveOutDate").value;
            target.rmrkCn       = document.getElementById("rmrkCn").value;

            searchResidents();
            closeModal();
            alert("입주민 세대 정보가 수정되었습니다.");
        }

        const columnDefs = [
            {
                headerName: "입주민",
                field: "userNm",
                flex: 1.2,
                minWidth: 150,
                cellRenderer: function (params) {
                    return '<div class="avatar-row">'
                        + '<div class="avatar avatar-sm">' + (params.data.userNm || "-").charAt(0) + '</div>'
                        + '<div class="avatar-info">'
                        + '<div class="name">' + (params.data.userNm || "-") + '</div>'
                        + '<div class="sub">'  + (params.data.telno  || "-") + '</div>'
                        + '</div></div>';
                }
            },
            { headerName: "단지명", field: "complexName",   flex: 1.1, minWidth: 140 },
            { headerName: "동",     field: "dong",           width: 100 },
            { headerName: "호수",   field: "ho",             width: 110 },
            { headerName: "세대구분", field: "householdType", width: 120,
                cellRenderer: function (p) { return householdBadge(p.value); } },
            { headerName: "입주상태", field: "moveStatus",    width: 120,
                cellRenderer: function (p) { return moveStatusBadge(p.value); } },
            { headerName: "입주일", field: "moveInDate",     width: 130 },
            {
                headerName: "관리",
                field: "residentNo",
                width: 150,
                pinned: "right",
                sortable: false,
                cellRenderer: function () {
                    return '<div class="grid-actions">'
                        + '<button type="button" class="btn btn-xs btn-detail" data-action="detail">상세</button>'
                        + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit">수정</button>'
                        + '</div>';
                }
            }
        ];

        const gridOptions = {
            theme: "legacy",
            columnDefs: columnDefs,
            rowData: residentRowData,
            defaultColDef: { sortable: true, filter: true, resizable: true },
            pagination: true,
            paginationPageSize: 10,
            paginationPageSizeSelector: [10, 20, 50],
            rowHeight: 46,
            headerHeight: 42,
            suppressCellFocus: true,
            onGridReady: function (params) {
                residentGridApi = params.api;
                setResidentCount(residentRowData.length);
            },
            onCellClicked: function (event) {
                const detailBtn = event.event.target.closest('[data-action="detail"]');
                const editBtn   = event.event.target.closest('[data-action="edit"]');
                if (detailBtn) openResidentModal(event.data, "detail");
                if (editBtn)   openResidentModal(event.data, "edit");
            }
        };

        const gridDiv = document.getElementById("residentGrid");
        if (gridDiv && window.agGrid) agGrid.createGrid(gridDiv, gridOptions);

        document.getElementById("btnSearchResident").addEventListener("click", searchResidents);
        document.getElementById("btnResetResidentFilter").addEventListener("click", resetResidentFilter);
        document.getElementById("btnChangeEditMode").addEventListener("click", function () { setModalMode("edit"); });
        document.getElementById("residentForm").addEventListener("submit", function (e) { e.preventDefault(); saveResident(); });

        page.addEventListener("click", function (event) {
            if (event.target.closest("[data-modal-close]") || event.target.classList.contains("modal-overlay")) {
                closeModal();
            }
        });
    })();
</script>
