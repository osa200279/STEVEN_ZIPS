<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="mngrAccountPage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>직원 계정 관리</h2>
            <p>관리사무소 직원 계정과 계정 생성 요청 상태를 관리합니다.</p>
        </div>

        <div class="page-actions">
            <button type="button" class="btn btn-primary" data-action="open-request-modal">
                <span class="material-symbols-rounded">person_add</span>
                계정 생성 요청
            </button>
        </div>
    </div>

    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-icon green"><span class="material-symbols-rounded">group</span></div>
            <div>
                <div class="stat-value" id="statManagerCount">0</div>
                <div class="stat-label">재직 직원</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon blue"><span class="material-symbols-rounded">badge</span></div>
            <div>
                <div class="stat-value" id="statActiveCount">0</div>
                <div class="stat-label">활성 계정</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon yellow"><span class="material-symbols-rounded">pending_actions</span></div>
            <div>
                <div class="stat-value" id="statWaitCount">0</div>
                <div class="stat-label">승인대기 요청</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon red"><span class="material-symbols-rounded">block</span></div>
            <div>
                <div class="stat-value" id="statInactiveCount">0</div>
                <div class="stat-label">비활성 계정</div>
            </div>
        </div>
    </div>

    <div class="tab-bar">
        <button type="button" class="tab-btn active" data-action="change-tab" data-tab="manager">
            <span class="material-symbols-rounded">groups</span>
            재직 직원
        </button>
        <button type="button" class="tab-btn" data-action="change-tab" data-tab="request">
            <span class="material-symbols-rounded">assignment_ind</span>
            생성 요청
        </button>
    </div>

    <!-- 재직 직원 -->
    <div class="tab-panel active" id="managerTabPanel">
        <div class="panel">
            <div class="panel-header">
                <div class="panel-title">
                    <span class="material-symbols-rounded">manage_accounts</span>
                    재직 직원 목록
                </div>
            </div>

            <div class="filter-card" style="justify-content:space-between;">
                <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                    <select class="form-select" id="managerDutyFilter" style="width:150px;">
                        <option value="">전체 직무</option>
                        <option value="HEAD">관리소장</option>
                        <option value="ADM">행정담당</option>
                        <option value="FAC">시설담당</option>
                        <option value="ACNT">회계담당</option>
                    </select>
                    <select class="form-select" id="managerUseFilter" style="width:150px;">
                        <option value="">전체 상태</option>
                        <option value="Y">활성</option>
                        <option value="N">비활성</option>
                    </select>
                </div>
                <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-left:auto;">
                    <div class="search-wrap" style="width:300px;">
                        <span class="material-symbols-rounded">search</span>
                        <input type="text" class="form-input" id="managerKeyword" placeholder="이름, 아이디, 연락처 검색">
                    </div>
                    <button type="button" class="btn btn-primary" data-action="search-manager">검색</button>
                    <button type="button" class="btn btn-secondary" data-action="reset-manager">초기화</button>
                </div>
            </div>

            <div class="grid-summary">
                <div class="grid-summary-left">
                    <strong>직원 계정 현황</strong>
                    <span>승인 완료된 직원 계정을 기준으로 표시합니다.</span>
                </div>
                <div class="grid-summary-right">
                    <span class="mini-badge inactive">비활성 계정은 로그인 제한 상태입니다.</span>
                </div>
            </div>

            <div class="manager-grid-wrap">
                <div id="managerGrid" class="ag-theme-alpine manager-ag-grid grid-size-auto"></div>
            </div>
        </div>
    </div>

    <!-- 생성 요청 -->
    <div class="tab-panel" id="requestTabPanel">
        <div class="panel">
            <div class="panel-header">
                <div class="panel-title">
                    <span class="material-symbols-rounded">assignment</span>
                    계정 생성 요청 목록
                </div>
                <button type="button" class="btn btn-primary btn-sm" data-action="open-request-modal">
                    <span class="material-symbols-rounded">add</span>
                    요청 등록
                </button>
            </div>

            <div class="filter-card" style="justify-content:space-between;">
                <div style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                    <select class="form-select" id="requestDutyFilter" style="width:150px;">
                        <option value="">전체 직무</option>
                        <option value="HEAD">관리소장</option>
                        <option value="ADM">행정담당</option>
                        <option value="FAC">시설담당</option>
                        <option value="ACNT">회계담당</option>
                    </select>
                    <select class="form-select" id="requestStatusFilter" style="width:150px;">
                        <option value="">전체 상태</option>
                        <option value="WAIT">승인대기</option>
                        <option value="APRV">승인완료</option>
                        <option value="RJCT">반려</option>
                        <option value="HOLD">보류</option>
                    </select>
                </div>
                <div style="display:flex; gap:8px; align-items:center; flex-wrap:wrap; margin-left:auto;">
                    <div class="search-wrap" style="width:300px;">
                        <span class="material-symbols-rounded">search</span>
                        <input type="text" class="form-input" id="requestKeyword" placeholder="이름, 요청 아이디, 연락처 검색">
                    </div>
                    <button type="button" class="btn btn-primary" data-action="search-request">검색</button>
                    <button type="button" class="btn btn-secondary" data-action="reset-request">초기화</button>
                </div>
            </div>

            <div class="grid-summary">
                <div class="grid-summary-left">
                    <strong>생성 요청 현황</strong>
                    <span>승인대기 요청은 수정 또는 취소할 수 있습니다.</span>
                </div>
                <div class="grid-summary-right">
                    <span class="mini-badge wait">중앙관리자 승인 후 계정이 생성됩니다.</span>
                </div>
            </div>

            <div class="manager-grid-wrap">
                <div id="requestGrid" class="ag-theme-alpine manager-ag-grid grid-size-auto"></div>
            </div>
        </div>
    </div>

    <!-- 계정 모달 -->
    <div class="modal-overlay" id="accountModal">
        <div class="modal modal-lg">
            <div class="modal-header">
                <h3 class="modal-title">
                    <span id="accountModalTitle"></span>
                    <span class="badge" id="accountModalBadge"></span>
                </h3>
                <button type="button" class="modal-close" data-modal-close>
                    <span class="material-symbols-rounded">close</span>
                </button>
            </div>

            <form id="accountForm">
                <input type="hidden" name="userNo"      id="accountUserNo">
                <input type="hidden" name="mgmtOfcNo"   id="accountMgmtOfcNo">
                <input type="hidden" name="rqstNo"      id="accountRqstNo">
                <input type="hidden" name="userYn"      id="accountUserYn">
                <input type="hidden" name="rqstSttsCd"  id="accountRqstSttsCd">

                <div class="modal-body">
                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-rounded">person</span>
                            기본 정보
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-group">
                                <label class="form-label">직원명 <span class="req">*</span></label>
                                <input type="text" name="userNm" id="accountUserNm" class="form-input">
                            </div>
                            <div class="form-group">
                                <label class="form-label">로그인 아이디 <span class="req">*</span></label>
                                <input type="text" name="userId" id="accountUserId" class="form-input">
                            </div>
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-group">
                                <label class="form-label">연락처 <span class="req">*</span></label>
                                <input type="text" name="telno" id="accountTelno" class="form-input">
                            </div>
                            <div class="form-group">
                                <label class="form-label">이메일 <span class="req">*</span></label>
                                <input type="text" name="userEml" id="accountUserEml" class="form-input">
                            </div>
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-group">
                                <label class="form-label">직무 <span class="req">*</span></label>
                                <select name="mngrDutyCd" id="accountDutyCd" class="form-select">
                                    <option value="">직무 선택</option>
                                    <option value="HEAD">관리소장</option>
                                    <option value="ADM">행정담당</option>
                                    <option value="FAC">시설담당</option>
                                    <option value="ACNT">회계담당</option>
                                </select>
                            </div>
                            <div class="form-group" id="accountPasswordBox">
                                <label class="form-label">비밀번호 <span class="req">*</span></label>
                                <input type="password" name="rqstPw" id="accountRqstPw" class="form-input">
                            </div>
                        </div>

                        <div class="form-row cols-2" id="requestExtraBox">
                            <div class="form-group">
                                <label class="form-label">주민등록번호</label>
                                <input type="text" name="rqstRrno" id="accountRqstRrno" class="form-input">
                            </div>
                            <div class="form-group">
                                <label class="form-label">요청일</label>
                                <input type="text" name="rqstDt" id="accountRqstDt" class="form-input" readonly>
                            </div>
                        </div>

                        <div class="form-row cols-1" id="requestRemarkBox">
                            <div class="form-group">
                                <label class="form-label">비고</label>
                                <textarea name="rmrkCn" id="accountRmrkCn" class="form-textarea"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer" id="accountModalFooter"></div>
            </form>
        </div>
    </div>

    <!-- 확인 모달 -->
    <div class="modal-overlay" id="confirmModal">
        <div class="modal modal-sm">
            <div class="modal-header">
                <h3 class="modal-title" id="confirmTitle">확인</h3>
                <button type="button" class="modal-close" data-modal-close>
                    <span class="material-symbols-rounded">close</span>
                </button>
            </div>
            <div class="modal-body">
                <p id="confirmMessage" style="font-size:13px; color:var(--text-secondary); margin-bottom:14px;"></p>
                <div class="form-row cols-1" id="confirmReasonBox" style="display:none;">
                    <div class="form-group">
                        <label class="form-label">사유 / 메모</label>
                        <textarea class="form-textarea" id="confirmReason"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-modal-close>취소</button>
                <button type="button" class="btn btn-primary" id="confirmActionBtn">확인</button>
            </div>
        </div>
    </div>

</div>

<script>
    (function () {
        var contextPath = "${pageContext.request.contextPath}";

        var managerRowData = [
            <c:forEach var="manager" items="${managerList}" varStatus="st">
            {
                userNo:     "<c:out value='${manager.userNo}'/>",
                mgmtOfcNo:  "<c:out value='${manager.mgmtOfcNo}'/>",
                mngrDutyCd: "<c:out value='${manager.mngrDutyCd}'/>",
                userId:     "<c:out value='${manager.userId}'/>",
                userNm:     "<c:out value='${manager.userNm}'/>",
                telno:      "<c:out value='${manager.telno}'/>",
                userEml:    "<c:out value='${manager.userEml}'/>",
                userYn:     "<c:out value='${manager.userYn}'/>"
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        var requestRowData = [
            <c:forEach var="rqst" items="${requestList}" varStatus="st">
            {
                rqstNo:      "<c:out value='${rqst.rqstNo}'/>",
                rqstLoginId: "<c:out value='${rqst.rqstLoginId}'/>",
                rqstPw:      "<c:out value='${rqst.rqstPw}'/>",
                rqstMngrNm:  "<c:out value='${rqst.rqstMngrNm}'/>",
                rqstRrno:    "<c:out value='${rqst.rqstRrno}'/>",
                rqstTelno:   "<c:out value='${rqst.rqstTelno}'/>",
                rqstEml:     "<c:out value='${rqst.rqstEml}'/>",
                rqstDutyCd:  "<c:out value='${rqst.rqstDutyCd}'/>",
                rqstDt:      "<c:out value='${rqst.rqstDt}'/>",
                aprvDt:      "<c:out value='${rqst.aprvDt}'/>",
                rqstSttsCd:  "<c:out value='${rqst.rqstSttsCd}'/>",
                aprvId:      "<c:out value='${rqst.aprvId}'/>",
                rjctRsnCn:   "<c:out value='${rqst.rjctRsnCn}'/>",
                rmrkCn:      "<c:out value='${rqst.rmrkCn}'/>",
                userNo:      "<c:out value='${rqst.userNo}'/>"
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        var managerGridEl  = null;
        var requestGridEl  = null;
        var confirmCallback = null;

        /* ───────── 유틸 ───────── */

        function safe(v) {
            return (v === null || v === undefined || v === "null") ? "" : String(v);
        }

        function getField(id) {
            var el = document.getElementById(id);
            return el ? el.value.trim() : "";
        }

        function setField(id, value) {
            var el = document.getElementById(id);
            if (el) el.value = safe(value);
        }

        function dutyText(code) {
            return { HEAD: "관리소장", ADM: "행정담당", FAC: "시설담당", ACNT: "회계담당" }[code] || "-";
        }

        function dutyClass(code) {
            return { HEAD: "duty-head", ADM: "duty-adm", FAC: "duty-fac", ACNT: "duty-acnt" }[code] || "gray";
        }

        function statusText(code) {
            return { WAIT: "승인대기", APRV: "승인완료", RJCT: "반려", HOLD: "보류" }[code] || "-";
        }

        function statusClass(code) {
            return { WAIT: "status-wait", APRV: "status-aprv", RJCT: "status-rjct", HOLD: "status-hold" }[code] || "gray";
        }

        function useYnClass(code) {
            return code === "Y" ? "status-active" : "status-inactive";
        }

        function formatDate(v) {
            if (!v) return "-";
            var s = String(v);
            if (s.length >= 10 && s.indexOf("-") > -1) return s.substring(0, 10).replaceAll("-", ".");
            if (s.length >= 10 && s.indexOf("/") > -1) return s.substring(0, 10).replaceAll("/", ".");
            if (s.length === 8 && !isNaN(s))           return s.substring(0,4) + "." + s.substring(4,6) + "." + s.substring(6,8);
            var d = new Date(s);
            if (!isNaN(d.getTime())) {
                return d.getFullYear() + "." + String(d.getMonth()+1).padStart(2,"0") + "." + String(d.getDate()).padStart(2,"0");
            }
            return s;
        }

        function renderBadge(text, cls) {
            return '<span class="grid-badge ' + cls + '">' + text + '</span>';
        }

        function avatarCell(name, sub) {
            return '<div class="avatar-row">'
                + '<div class="avatar avatar-sm">' + (name ? name.charAt(0) : "-") + '</div>'
                + '<div class="avatar-info"><div class="name">' + safe(name) + '</div><div class="sub">' + safe(sub) + '</div></div>'
                + '</div>';
        }

        function postJsonSafe(url, data) {
            if (typeof postJson === "function") return postJson(url, data);
            return fetch(url, {
                method: "POST",
                headers: { "Content-Type": "application/json", "X-Requested-With": "XMLHttpRequest" },
                body: JSON.stringify(data)
            }).then(function (r) { return r.json(); });
        }

        function setRows(gridEl, rows) {
            if (typeof setGridRowData === "function") { setGridRowData(gridEl, rows); return; }
            if (gridEl && gridEl._gridApi) gridEl._gridApi.setGridOption("rowData", rows);
        }

        function reload() {
            reloadFragment(contextPath + "/manager/employee/account", "직원 계정 관리");
        }

        /* ───────── 통계 ───────── */

        function updateStats() {
            document.getElementById("statManagerCount").textContent  = managerRowData.length;
            document.getElementById("statActiveCount").textContent   = managerRowData.filter(function(r){ return r.userYn === "Y"; }).length;
            document.getElementById("statInactiveCount").textContent = managerRowData.filter(function(r){ return r.userYn === "N"; }).length;
            document.getElementById("statWaitCount").textContent     = requestRowData.filter(function(r){ return r.rqstSttsCd === "WAIT"; }).length;
        }

        /* ───────── 그리드 ───────── */

        function createGrids() {
            managerGridEl = document.getElementById("managerGrid");
            requestGridEl = document.getElementById("requestGrid");

            destroyManagerGrid(managerGridEl);
            destroyManagerGrid(requestGridEl);

            createManagerGrid(managerGridEl, [
                { headerName: "직원",   field: "userNm",     flex: 1.3, minWidth: 160,
                    cellRenderer: function(p){ return avatarCell(p.data.userNm, p.data.userId); } },
                { headerName: "직무",   field: "mngrDutyCd", width: 130,
                    cellRenderer: function(p){ return renderBadge(dutyText(p.value), dutyClass(p.value)); } },
                { headerName: "연락처", field: "telno",      flex: 1,   minWidth: 140 },
                { headerName: "이메일", field: "userEml",    flex: 1.3, minWidth: 190 },
                { headerName: "상태",   field: "userYn",     width: 110,
                    cellRenderer: function(p){ return renderBadge(p.value === "Y" ? "활성" : "비활성", useYnClass(p.value)); } },
                { headerName: "관리",   field: "userNo",     width: 190, sortable: false,
                    cellRenderer: function(p){
                        var no = p.data.userNo;
                        return '<div class="grid-actions">'
                            + '<button class="btn btn-detail" data-action="manager-detail"     data-user-no="' + no + '">상세</button>'
                            + '<button class="btn btn-edit"   data-action="manager-edit"       data-user-no="' + no + '">수정</button>'
                            + '<button class="btn btn-delete" data-action="manager-deactivate" data-user-no="' + no + '">비활성</button>'
                            + '</div>';
                    }
                }
            ], managerRowData, { domLayout: "autoHeight", paginationPageSize: 10 });

            createManagerGrid(requestGridEl, [
                { headerName: "요청 직원", field: "rqstMngrNm", flex: 1.2, minWidth: 160,
                    cellRenderer: function(p){ return avatarCell(p.data.rqstMngrNm, p.data.rqstLoginId); } },
                { headerName: "직무",     field: "rqstDutyCd",  width: 130,
                    cellRenderer: function(p){ return renderBadge(dutyText(p.value), dutyClass(p.value)); } },
                { headerName: "연락처",   field: "rqstTelno",   flex: 1, minWidth: 140 },
                { headerName: "요청일",   field: "rqstDt",      width: 150,
                    valueFormatter: function(p){ return formatDate(p.value); } },
                { headerName: "상태",     field: "rqstSttsCd",  width: 120,
                    cellRenderer: function(p){ return renderBadge(statusText(p.value), statusClass(p.value)); } },
                { headerName: "관리",     field: "rqstNo",      width: 220, sortable: false,
                    cellRenderer: function(p){
                        var no = p.data.rqstNo;
                        var dis = p.data.rqstSttsCd !== "WAIT" ? " disabled" : "";
                        return '<div class="grid-actions">'
                            + '<button class="btn btn-detail" data-action="request-detail" data-rqst-no="' + no + '">상세</button>'
                            + '<button class="btn btn-edit"   data-action="request-edit"   data-rqst-no="' + no + '"' + dis + '>수정</button>'
                            + '<button class="btn btn-delete" data-action="request-cancel" data-rqst-no="' + no + '"' + dis + '>취소</button>'
                            + '</div>';
                    }
                }
            ], requestRowData, { domLayout: "autoHeight", paginationPageSize: 10 });
        }

        /* ───────── 필터 ───────── */

        function applyManagerFilter() {
            var duty    = document.getElementById("managerDutyFilter").value;
            var useYn   = document.getElementById("managerUseFilter").value;
            var keyword = document.getElementById("managerKeyword").value.trim();

            setRows(managerGridEl, managerRowData.filter(function(r){
                var text = [r.userNm, r.userId, r.telno, r.userEml].join(" ");
                return (!duty    || r.mngrDutyCd === duty)
                    && (!useYn   || r.userYn     === useYn)
                    && (!keyword || text.indexOf(keyword) > -1);
            }));
        }

        function applyRequestFilter() {
            var duty    = document.getElementById("requestDutyFilter").value;
            var status  = document.getElementById("requestStatusFilter").value;
            var keyword = document.getElementById("requestKeyword").value.trim();

            setRows(requestGridEl, requestRowData.filter(function(r){
                var text = [r.rqstMngrNm, r.rqstLoginId, r.rqstTelno, r.rqstEml].join(" ");
                return (!duty    || r.rqstDutyCd  === duty)
                    && (!status  || r.rqstSttsCd  === status)
                    && (!keyword || text.indexOf(keyword) > -1);
            }));
        }

        function resetManagerFilter() {
            document.getElementById("managerDutyFilter").value = "";
            document.getElementById("managerUseFilter").value  = "";
            document.getElementById("managerKeyword").value    = "";
            setRows(managerGridEl, managerRowData);
        }

        function resetRequestFilter() {
            document.getElementById("requestDutyFilter").value  = "";
            document.getElementById("requestStatusFilter").value = "";
            document.getElementById("requestKeyword").value      = "";
            setRows(requestGridEl, requestRowData);
        }

        /* ───────── 탭 ───────── */

        function changeTab(tabName) {
            document.querySelectorAll("#mngrAccountPage .tab-btn").forEach(function(btn){
                btn.classList.toggle("active", btn.dataset.tab === tabName);
            });
            document.getElementById("managerTabPanel").classList.toggle("active", tabName === "manager");
            document.getElementById("requestTabPanel").classList.toggle("active", tabName === "request");
        }

        /* ───────── 모달 공통 ───────── */

        function openModal(id) {
            document.getElementById(id).classList.add("open");
        }

        function closeModal(id) {
            document.getElementById(id).classList.remove("open");
        }

        function clearAccountForm() {
            document.getElementById("accountForm").reset();
        }

        function disableAccountForm(disabled) {
            document.getElementById("accountForm").querySelectorAll("input:not([type=hidden]), select, textarea").forEach(function(el){
                el.disabled = disabled;
            });
        }

        /* ───────── 모달 열기 (목적별) ───────── */

        function openManagerDetail(row) {
            clearAccountForm();
            disableAccountForm(true);

            document.getElementById("accountModalTitle").textContent = "재직 직원 상세";
            document.getElementById("accountModalBadge").className   = "badge badge-gray";
            document.getElementById("accountModalBadge").textContent = "상세";

            document.getElementById("accountPasswordBox").style.display = "none";
            document.getElementById("requestExtraBox").style.display    = "none";
            document.getElementById("requestRemarkBox").style.display   = "none";

            setField("accountUserNo",    row.userNo);
            setField("accountMgmtOfcNo", row.mgmtOfcNo);
            setField("accountUserYn",    row.userYn);
            setField("accountUserNm",    row.userNm);
            setField("accountUserId",    row.userId);
            setField("accountTelno",     row.telno);
            setField("accountUserEml",   row.userEml);
            setField("accountDutyCd",    row.mngrDutyCd);

            document.getElementById("accountModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>'
                + '<button type="button" class="btn btn-primary" data-action="manager-edit" data-user-no="' + row.userNo + '">수정</button>';

            openModal("accountModal");
        }

        function openManagerEdit(row) {
            clearAccountForm();
            disableAccountForm(false);

            document.getElementById("accountModalTitle").textContent = "재직 직원 수정";
            document.getElementById("accountModalBadge").className   = "badge badge-blue";
            document.getElementById("accountModalBadge").textContent = "수정";

            document.getElementById("accountPasswordBox").style.display = "none";
            document.getElementById("requestExtraBox").style.display    = "none";
            document.getElementById("requestRemarkBox").style.display   = "none";

            setField("accountUserNo",    row.userNo);
            setField("accountMgmtOfcNo", row.mgmtOfcNo);
            setField("accountUserYn",    row.userYn);
            setField("accountUserNm",    row.userNm);
            setField("accountUserId",    row.userId);
            setField("accountTelno",     row.telno);
            setField("accountUserEml",   row.userEml);
            setField("accountDutyCd",    row.mngrDutyCd);

            document.getElementById("accountModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
                + '<button type="submit" class="btn btn-primary">수정 저장</button>';

            openModal("accountModal");
        }

        function openRequestDetail(row) {
            clearAccountForm();
            disableAccountForm(true);

            document.getElementById("accountModalTitle").textContent = "계정 생성 요청 상세";
            document.getElementById("accountModalBadge").className   = "badge badge-gray";
            document.getElementById("accountModalBadge").textContent = "상세";

            document.getElementById("accountPasswordBox").style.display = "";
            document.getElementById("requestExtraBox").style.display    = "";
            document.getElementById("requestRemarkBox").style.display   = "";
            document.getElementById("accountRqstPw").type = "text";

            setField("accountRqstNo",    row.rqstNo);
            setField("accountUserNo",    row.userNo);
            setField("accountRqstSttsCd", row.rqstSttsCd);
            setField("accountUserNm",    row.rqstMngrNm);
            setField("accountUserId",    row.rqstLoginId);
            setField("accountTelno",     row.rqstTelno);
            setField("accountUserEml",   row.rqstEml);
            setField("accountDutyCd",    row.rqstDutyCd);
            setField("accountRqstPw",    row.rqstPw);
            setField("accountRqstRrno",  row.rqstRrno);
            setField("accountRqstDt",    formatDate(row.rqstDt));
            setField("accountRmrkCn",    row.rmrkCn);

            var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';
            if (row.rqstSttsCd === "WAIT") {
                footer += '<button type="button" class="btn btn-primary" data-action="request-edit" data-rqst-no="' + row.rqstNo + '">수정</button>';
            }
            document.getElementById("accountModalFooter").innerHTML = footer;

            openModal("accountModal");
        }

        function openRequestEdit(row) {
            clearAccountForm();
            disableAccountForm(false);

            document.getElementById("accountModalTitle").textContent = "계정 생성 요청 수정";
            document.getElementById("accountModalBadge").className   = "badge badge-blue";
            document.getElementById("accountModalBadge").textContent = "수정";

            document.getElementById("accountPasswordBox").style.display = "";
            document.getElementById("requestExtraBox").style.display    = "";
            document.getElementById("requestRemarkBox").style.display   = "";
            document.getElementById("accountRqstPw").type = "password";

            setField("accountRqstNo",     row.rqstNo);
            setField("accountUserNo",     row.userNo);
            setField("accountRqstSttsCd", row.rqstSttsCd);
            setField("accountUserNm",     row.rqstMngrNm);
            setField("accountUserId",     row.rqstLoginId);
            setField("accountTelno",      row.rqstTelno);
            setField("accountUserEml",    row.rqstEml);
            setField("accountDutyCd",     row.rqstDutyCd);
            setField("accountRqstPw",     row.rqstPw);
            setField("accountRqstRrno",   row.rqstRrno);
            setField("accountRqstDt",     formatDate(row.rqstDt));
            setField("accountRmrkCn",     row.rmrkCn);

            document.getElementById("accountModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
                + '<button type="submit" class="btn btn-primary">수정 저장</button>';

            openModal("accountModal");
        }

        function openRequestInsert() {
            clearAccountForm();
            disableAccountForm(false);

            document.getElementById("accountModalTitle").textContent = "계정 생성 요청 등록";
            document.getElementById("accountModalBadge").className   = "badge badge-green";
            document.getElementById("accountModalBadge").textContent = "등록";

            document.getElementById("accountPasswordBox").style.display = "";
            document.getElementById("requestExtraBox").style.display    = "";
            document.getElementById("requestRemarkBox").style.display   = "";
            document.getElementById("accountRqstPw").type = "password";
            document.getElementById("accountRqstDt").value = "";

            document.getElementById("accountModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
                + '<button type="submit" class="btn btn-primary">등록 요청</button>';

            openModal("accountModal");
        }

        /* ───────── 폼 제출 ───────── */

        function submitAccountForm(e) {
            e.preventDefault();

            var isManager = document.getElementById("accountUserNo").value
                && !document.getElementById("accountRqstNo").value;

            if (isManager) {
                submitManagerUpdate();
            } else {
                submitRequestSave();
            }
        }

        async function submitManagerUpdate() {
            if (!getField("accountUserNm"))  { showAlert("직원명을 입력하세요.");     return; }
            if (!getField("accountUserId"))  { showAlert("아이디를 입력하세요.");     return; }
            if (!getField("accountTelno"))   { showAlert("연락처를 입력하세요.");     return; }
            if (!getField("accountUserEml")) { showAlert("이메일을 입력하세요.");     return; }
            if (!getField("accountDutyCd"))  { showAlert("직무를 선택하세요.");       return; }

            try {
                var result = await postJsonSafe(contextPath + "/manager/employee/manager/update", {
                    userNo:     getField("accountUserNo"),
                    mgmtOfcNo:  getField("accountMgmtOfcNo"),
                    mngrDutyCd: getField("accountDutyCd"),
                    userId:     getField("accountUserId"),
                    userNm:     getField("accountUserNm"),
                    telno:      getField("accountTelno"),
                    userEml:    getField("accountUserEml"),
                    userYn:     getField("accountUserYn")
                });

                if (result.success) { closeModal("accountModal"); showAlert(result.message || "수정되었습니다."); reload(); }
                else                { showAlert(result.message || "수정에 실패했습니다."); }
            } catch (err) {
                showAlert("처리 중 오류가 발생했습니다.");
                console.error(err);
            }
        }

        async function submitRequestSave() {
            if (!getField("accountUserNm"))  { showAlert("직원명을 입력하세요.");   return; }
            if (!getField("accountUserId"))  { showAlert("아이디를 입력하세요.");   return; }
            if (!getField("accountTelno"))   { showAlert("연락처를 입력하세요.");   return; }
            if (!getField("accountUserEml")) { showAlert("이메일을 입력하세요.");   return; }
            if (!getField("accountDutyCd"))  { showAlert("직무를 선택하세요.");     return; }
            if (!getField("accountRqstPw") && !getField("accountRqstNo")) {
                showAlert("비밀번호를 입력하세요."); return;
            }

            var isInsert = !getField("accountRqstNo");
            var url = isInsert
                ? contextPath + "/manager/employee/request/insert"
                : contextPath + "/manager/employee/request/update";

            try {
                var result = await postJsonSafe(url, {
                    rqstNo:     getField("accountRqstNo"),
                    rqstLoginId: getField("accountUserId"),
                    rqstPw:     getField("accountRqstPw"),
                    rqstMngrNm: getField("accountUserNm"),
                    rqstRrno:   getField("accountRqstRrno"),
                    rqstTelno:  getField("accountTelno"),
                    rqstEml:    getField("accountUserEml"),
                    rqstDutyCd: getField("accountDutyCd"),
                    rmrkCn:     getField("accountRmrkCn"),
                    userNo:     getField("accountUserNo")
                });

                if (result.success) { closeModal("accountModal"); showAlert(result.message || "저장되었습니다."); reload(); }
                else                { showAlert(result.message || "저장에 실패했습니다."); }
            } catch (err) {
                showAlert("처리 중 오류가 발생했습니다.");
                console.error(err);
            }
        }

        /* ───────── 확인 모달 ───────── */

        function openConfirm(title, message, showReason, callback) {
            document.getElementById("confirmTitle").textContent   = title;
            document.getElementById("confirmMessage").textContent = message;
            document.getElementById("confirmReason").value        = "";
            document.getElementById("confirmReasonBox").style.display = showReason ? "block" : "none";
            confirmCallback = callback;
            openModal("confirmModal");
        }

        async function deactivateManager(userNo) {
            openConfirm("계정 비활성화", "선택한 직원 계정을 비활성화하시겠습니까?", false, async function () {
                try {
                    var result = await postJsonSafe(contextPath + "/manager/employee/manager/deactivate", { userNo: userNo });
                    if (result.success) { closeModal("confirmModal"); showAlert(result.message || "비활성화되었습니다."); reload(); }
                    else                { showAlert(result.message || "비활성화에 실패했습니다."); }
                } catch (err) { showAlert("처리 중 오류가 발생했습니다."); console.error(err); }
            });
        }

        async function cancelRequest(rqstNo) {
            var row = requestRowData.find(function(r){ return String(r.rqstNo) === String(rqstNo); });
            if (!row || row.rqstSttsCd !== "WAIT") { showAlert("승인대기 상태의 요청만 취소할 수 있습니다."); return; }

            openConfirm("요청 취소", "선택한 계정 생성 요청을 취소하시겠습니까?", true, async function () {
                try {
                    var result = await postJsonSafe(contextPath + "/manager/employee/request/cancel", {
                        rqstNo: rqstNo,
                        rmrkCn: document.getElementById("confirmReason").value
                    });
                    if (result.success) { closeModal("confirmModal"); showAlert(result.message || "취소되었습니다."); reload(); }
                    else                { showAlert(result.message || "취소에 실패했습니다."); }
                } catch (err) { showAlert("처리 중 오류가 발생했습니다."); console.error(err); }
            });
        }

        /* ───────── 이벤트 바인딩 ───────── */

        function bindEvents() {
            var page = document.getElementById("mngrAccountPage");
            if (!page || page.dataset.bound === "true") return;
            page.dataset.bound = "true";

            page.addEventListener("click", function (e) {
                var btn = e.target.closest("[data-action]");
                if (!btn) return;

                var action = btn.dataset.action;

                if (action === "open-request-modal")  openRequestInsert();
                if (action === "change-tab")          changeTab(btn.dataset.tab);
                if (action === "search-manager")      applyManagerFilter();
                if (action === "reset-manager")       resetManagerFilter();
                if (action === "search-request")      applyRequestFilter();
                if (action === "reset-request")       resetRequestFilter();

                if (action === "manager-detail") {
                    var row = managerRowData.find(function(r){ return String(r.userNo) === btn.dataset.userNo; });
                    if (row) openManagerDetail(row);
                }
                if (action === "manager-edit") {
                    var row = managerRowData.find(function(r){ return String(r.userNo) === btn.dataset.userNo; });
                    if (row) { closeModal("accountModal"); openManagerEdit(row); }
                }
                if (action === "manager-deactivate") deactivateManager(btn.dataset.userNo);

                if (action === "request-detail") {
                    var row = requestRowData.find(function(r){ return String(r.rqstNo) === btn.dataset.rqstNo; });
                    if (row) openRequestDetail(row);
                }
                if (action === "request-edit") {
                    var row = requestRowData.find(function(r){ return String(r.rqstNo) === btn.dataset.rqstNo; });
                    if (!row || row.rqstSttsCd !== "WAIT") { showAlert("승인대기 상태의 요청만 수정할 수 있습니다."); return; }
                    closeModal("accountModal");
                    openRequestEdit(row);
                }
                if (action === "request-cancel") cancelRequest(btn.dataset.rqstNo);
            });

            page.addEventListener("click", function(e) {
                if (e.target.closest("[data-modal-close]")) {
                    document.querySelectorAll("#mngrAccountPage .modal-overlay.open").forEach(function(m){
                        m.classList.remove("open");
                    });
                }
            });

            document.getElementById("accountForm").addEventListener("submit", submitAccountForm);

            document.getElementById("confirmActionBtn").addEventListener("click", function () {
                if (typeof confirmCallback === "function") confirmCallback();
            });
        }

        /* ───────── 진입점 ───────── */

        window.initMngrAccountPage = function () {
            if (!document.getElementById("mngrAccountPage")) {
                return;
            }

            updateStats();
            createGrids();
            bindEvents();
        };
    })();
</script>
