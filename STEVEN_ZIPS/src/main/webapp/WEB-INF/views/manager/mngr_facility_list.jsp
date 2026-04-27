<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="facilityAssetPage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>시설 목록</h2>
            <p>시설 자산 등록·수정·조회 — FACILITY 기반</p>
        </div>
        <div class="page-actions">
            <button type="button" class="btn btn-primary" data-action="openRegister">
                <span class="material-symbols-rounded">add</span>
                시설 등록
            </button>
        </div>
    </div>

    <!-- 통계 -->
    <div class="stat-row" style="grid-template-columns:repeat(3,minmax(0,1fr));">
        <div class="stat-card" style="background:#2e5c38; border-color:#264e30;">
            <div>
                <div style="font-size:12px; color:rgba(255,255,255,0.7); margin-bottom:4px;">전체 등록 시설</div>
                <div style="font-size:28px; font-weight:800; color:#fff;" id="statTotal">0</div>
                <div style="font-size:11px; color:rgba(255,255,255,0.55); margin-top:2px;">FACILITY</div>
            </div>
        </div>
        <div class="stat-card">
            <div>
                <div style="font-size:12px; color:var(--text-tertiary); margin-bottom:4px;">승강기</div>
                <div style="font-size:28px; font-weight:800; color:var(--text-primary);" id="statElv">0</div>
                <div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">ELV</div>
            </div>
        </div>
        <div class="stat-card">
            <div>
                <div style="font-size:12px; color:var(--text-tertiary); margin-bottom:4px;">소방시설</div>
                <div style="font-size:28px; font-weight:800; color:var(--text-primary);" id="statFire">0</div>
                <div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">FIRE</div>
            </div>
        </div>
    </div>

    <!-- 필터 + 목록 -->
    <div class="panel">
        <div class="filter-bar">
            <select class="form-select" id="filterFacilityTy" style="width:150px;">
                <option value="">시설 유형 전체</option>
                <option value="ELV">승강기</option>
                <option value="WTR">급수시설</option>
                <option value="ELC">전기시설</option>
                <option value="GAS">가스시설</option>
                <option value="FIRE">소방시설</option>
                <option value="SEC">보안시설</option>
                <option value="ETC">기타시설</option>
            </select>

            <div class="search-wrap" style="width:260px;">
                <span class="material-symbols-rounded">search</span>
                <input type="text" class="form-input" id="filterKeyword" placeholder="시설명 검색">
            </div>

            <button type="button" class="btn btn-primary"   data-action="search">검색</button>
            <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
        </div>

        <div class="panel-header">
            <h3 class="panel-title">
                <span class="material-symbols-rounded">list_alt</span>
                시설 자산 목록
            </h3>
            <span class="list-count" id="facilityListCount">0건</span>
        </div>

        <div class="table-wrap">
            <table class="tbl">
                <thead>
                <tr>
                    <th>시설번호</th>
                    <th>시설명</th>
                    <th>유형</th>
                    <th>설치위치</th>
                    <th>설치일자</th>
                    <th style="width:120px;">관리</th>
                </tr>
                </thead>
                <tbody id="facilityTableBody"></tbody>
            </table>
        </div>
    </div>

    <!-- 등록/수정 모달 -->
    <div class="modal-overlay" id="facilityModal">
        <div class="modal modal-md">
            <div class="modal-header primary">
                <h3 class="modal-title" id="facilityModalTitle">시설 등록</h3>
                <button type="button" class="modal-close" data-action="closeModal">
                    <span class="material-symbols-rounded">close</span>
                </button>
            </div>

            <form id="facilityForm">
                <input type="hidden" id="facilityNo">

                <div class="modal-body">
                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-rounded">apartment</span>
                            시설 정보
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">시설 유형 <span class="req">*</span></label>
                                <select class="form-select" id="facilityTyCd">
                                    <option value="ELV">승강기</option>
                                    <option value="WTR">급수시설</option>
                                    <option value="ELC">전기시설</option>
                                    <option value="GAS">가스시설</option>
                                    <option value="FIRE">소방시설</option>
                                    <option value="SEC">보안시설</option>
                                    <option value="ETC">기타시설</option>
                                </select>
                            </div>
                            <div class="form-field">
                                <label class="field-label">설치일자</label>
                                <input type="date" class="form-input" id="instlDt">
                            </div>
                        </div>

                        <div class="form-row cols-1">
                            <div class="form-field">
                                <label class="field-label">시설명 <span class="req">*</span></label>
                                <input type="text" class="form-input" id="facilityNm" placeholder="예: 1호기 승강기">
                            </div>
                        </div>

                        <div class="form-row cols-1">
                            <div class="form-field">
                                <label class="field-label">
                                    설치위치
                                    <span style="font-size:10px; color:var(--text-tertiary); font-weight:400; margin-left:4px;">※ ERD 미반영 — 추후 컬럼 추가 예정 (INSTL_PLC)</span>
                                </label>
                                <input type="text" class="form-input" id="instlPlc" placeholder="예: 101동 지하 1층 기계실">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
                    <button type="button" class="btn btn-primary" id="facilityEditBtn"
                            data-action="changeToEdit" style="display:none;">수정하기</button>
                    <button type="submit" class="btn btn-primary" id="facilitySaveBtn">저장</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 삭제 확인 모달 -->
    <div class="modal-overlay" id="facilityDeleteModal">
        <div class="modal modal-sm">
            <div class="modal-header primary">
                <h3 class="modal-title">시설 삭제</h3>
                <button type="button" class="modal-close" data-action="closeDeleteModal">
                    <span class="material-symbols-rounded">close</span>
                </button>
            </div>
            <div class="modal-body">
                <div style="display:flex; gap:10px; padding:14px 16px; background:#fff0f0; border:1px solid #e0a8a8; border-radius:8px; margin-bottom:16px;">
                    <span class="material-symbols-rounded" style="color:#991b1b; font-size:20px; flex-shrink:0; margin-top:1px;">warning</span>
                    <div style="font-size:13px; color:#7f1d1d; line-height:1.6;">
                        선택한 시설을 삭제하시겠습니까?<br>
                        관련 점검 이력이 함께 조회되지 않을 수 있습니다.
                    </div>
                </div>
                <div class="mngr-detail-grid" id="facilityDeleteInfo"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
                <button type="button" class="btn btn-danger"    id="facilityDeleteConfirmBtn">삭제</button>
            </div>
        </div>
    </div>

</div>

<script>
    (function () {
        var page = document.getElementById("facilityAssetPage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        var modal       = document.getElementById("facilityModal");
        var deleteModal = document.getElementById("facilityDeleteModal");
        var form        = document.getElementById("facilityForm");
        var modalTitle  = document.getElementById("facilityModalTitle");
        var saveBtn     = document.getElementById("facilitySaveBtn");
        var editBtn     = document.getElementById("facilityEditBtn");
        var tbody       = document.getElementById("facilityTableBody");

        /* ── 더미 데이터
           ERD 컬럼: FACILITY_NO, FACILITY_TY_CD, FACILITY_NM, INSTL_DT, APT_CMPLEX_NO
           instlPlc: ERD 미반영, 추후 컬럼 추가 예정
        ── */
        var rowData = [
            { facilityNo:"FAC-001", facilityTyCd:"ELV",  facilityNm:"1호기 승강기",    instlDt:"2018-03-15", aptCmplexNo:"APT-001", instlPlc:"101동" },
            { facilityNo:"FAC-002", facilityTyCd:"ELV",  facilityNm:"2호기 승강기",    instlDt:"2018-03-15", aptCmplexNo:"APT-001", instlPlc:"102동" },
            { facilityNo:"FAC-003", facilityTyCd:"ELC",  facilityNm:"지하 1층 전기실", instlDt:"2018-01-10", aptCmplexNo:"APT-001", instlPlc:"지하 1층" },
            { facilityNo:"FAC-004", facilityTyCd:"FIRE", facilityNm:"스프링클러 설비", instlDt:"2018-01-10", aptCmplexNo:"APT-001", instlPlc:"전 동 공통" },
            { facilityNo:"FAC-005", facilityTyCd:"WTR",  facilityNm:"옥상 물탱크",    instlDt:"2018-02-20", aptCmplexNo:"APT-001", instlPlc:"옥상" },
            { facilityNo:"FAC-006", facilityTyCd:"SEC",  facilityNm:"CCTV 101동",     instlDt:"2020-06-01", aptCmplexNo:"APT-001", instlPlc:"101동 출입구" }
        ];

        var deleteTargetIdx = null;

        /* ── 공통코드 FACILITY_TY ── */
        var TY_TEXT  = { ELV:"승강기", WTR:"급수시설", ELC:"전기시설", GAS:"가스시설", FIRE:"소방시설", SEC:"보안시설", ETC:"기타시설" };
        var TY_BADGE = { ELV:"badge-blue", WTR:"badge-green", ELC:"badge-yellow", GAS:"badge-orange", FIRE:"badge-red", SEC:"badge-purple", ETC:"badge-gray" };

        function tyBadge(code) {
            return '<span class="badge ' + (TY_BADGE[code] || "badge-gray") + '">' + (TY_TEXT[code] || "-") + '</span>';
        }

        /* ── 통계 ── */
        function updateStats(data) {
            document.getElementById("statTotal").textContent = data.length;
            document.getElementById("statElv").textContent   = data.filter(function(r){ return r.facilityTyCd === "ELV"; }).length;
            document.getElementById("statFire").textContent  = data.filter(function(r){ return r.facilityTyCd === "FIRE"; }).length;
        }

        /* ── 목록 렌더 ── */
        function renderTable(data) {
            document.getElementById("facilityListCount").textContent = data.length + "건";
            updateStats(data);

            if (data.length === 0) {
                tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; color:var(--text-tertiary);">등록된 시설이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = data.map(function (row, idx) {
                return '<tr>'
                    + '<td class="td-mono" style="font-size:12px;">' + row.facilityNo + '</td>'
                    + '<td class="td-bold">' + row.facilityNm + '</td>'
                    + '<td>' + tyBadge(row.facilityTyCd) + '</td>'
                    + '<td>' + (row.instlPlc || "-") + '</td>'
                    + '<td>' + (row.instlDt  || "-") + '</td>'
                    + '<td><div class="grid-actions">'
                    + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + idx + '">상세</button>'
                    + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + idx + '">수정</button>'
                    + '<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="' + idx + '">삭제</button>'
                    + '</div></td>'
                    + '</tr>';
            }).join("");
        }

        /* ── 필터 ── */
        function getFiltered() {
            var ty      = document.getElementById("filterFacilityTy").value;
            var keyword = document.getElementById("filterKeyword").value.trim();
            return rowData.filter(function (row) {
                return (!ty      || row.facilityTyCd === ty)
                    && (!keyword || row.facilityNm.indexOf(keyword) > -1);
            });
        }

        function resetFilter() {
            document.getElementById("filterFacilityTy").value = "";
            document.getElementById("filterKeyword").value    = "";
            renderTable(rowData);
        }

        /* ── 모달 ── */
        function openModal(mode, idx) {
            form.reset();
            saveBtn.style.display = "inline-flex";
            editBtn.style.display = "none";
            setFormDisabled(false);

            if (mode === "register") {
                modalTitle.textContent = "시설 등록";
                document.getElementById("facilityNo").value = "";
            }
            if (mode === "detail" && idx !== undefined) {
                modalTitle.textContent = "시설 상세";
                fillForm(rowData[idx]);
                setFormDisabled(true);
                saveBtn.style.display = "none";
                editBtn.style.display = "inline-flex";
                editBtn.dataset.idx   = idx;
            }
            if (mode === "edit" && idx !== undefined) {
                modalTitle.textContent = "시설 수정";
                fillForm(rowData[idx]);
            }
            modal.classList.add("open");
        }

        function fillForm(row) {
            document.getElementById("facilityNo").value    = row.facilityNo   || "";
            document.getElementById("facilityTyCd").value  = row.facilityTyCd || "ELV";
            document.getElementById("facilityNm").value    = row.facilityNm   || "";
            document.getElementById("instlDt").value       = row.instlDt      || "";
            document.getElementById("instlPlc").value      = row.instlPlc     || "";
        }

        function setFormDisabled(disabled) {
            form.querySelectorAll("input, select").forEach(function(el){ el.disabled = disabled; });
        }

        function closeModal() { modal.classList.remove("open"); }

        /* ── 삭제 모달 ── */
        function openDeleteModal(idx) {
            deleteTargetIdx = idx;
            var row = rowData[idx];
            document.getElementById("facilityDeleteInfo").innerHTML =
                '<div class="mngr-detail-item"><div class="mngr-detail-label">시설번호</div><div class="mngr-detail-value">' + row.facilityNo + '</div></div>'
                + '<div class="mngr-detail-item"><div class="mngr-detail-label">시설명</div><div class="mngr-detail-value">' + row.facilityNm + '</div></div>'
                + '<div class="mngr-detail-item"><div class="mngr-detail-label">유형</div><div class="mngr-detail-value">' + (TY_TEXT[row.facilityTyCd] || "-") + '</div></div>'
                + '<div class="mngr-detail-item"><div class="mngr-detail-label">설치위치</div><div class="mngr-detail-value">' + (row.instlPlc || "-") + '</div></div>';
            deleteModal.classList.add("open");
        }

        function closeDeleteModal() {
            deleteModal.classList.remove("open");
            deleteTargetIdx = null;
        }

        /* ── 이벤트 ── */
        page.addEventListener("click", function (e) {
            var btn = e.target.closest("[data-action]");
            if (!btn) return;

            var action = btn.dataset.action;
            var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

            if (action === "openRegister")     openModal("register");
            if (action === "detail")           openModal("detail", idx);
            if (action === "edit")             openModal("edit", idx);
            if (action === "changeToEdit")     openModal("edit", Number(editBtn.dataset.idx));
            if (action === "closeModal")       closeModal();
            if (action === "delete")           openDeleteModal(idx);
            if (action === "closeDeleteModal") closeDeleteModal();
            if (action === "search")           renderTable(getFiltered());
            if (action === "resetFilter")      resetFilter();
        });

        document.getElementById("facilityDeleteConfirmBtn").addEventListener("click", function () {
            if (deleteTargetIdx === null) return;
            rowData.splice(deleteTargetIdx, 1);
            renderTable(rowData);
            closeDeleteModal();
            alert("삭제되었습니다.");
        });

        modal.addEventListener("click",       function(e){ if (e.target === modal)       closeModal(); });
        deleteModal.addEventListener("click", function(e){ if (e.target === deleteModal) closeDeleteModal(); });

        form.addEventListener("submit", function(e){
            e.preventDefault();
            var nm = document.getElementById("facilityNm").value.trim();
            if (!nm) { alert("시설명을 입력하세요."); return; }
            alert("저장 처리 연결 예정입니다.");
            closeModal();
        });

        renderTable(rowData);
    })();
</script>
