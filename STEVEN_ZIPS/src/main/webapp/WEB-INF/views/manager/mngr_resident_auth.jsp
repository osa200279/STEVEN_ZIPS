<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="residentAuthPage">

    <div class="page-header">
        <div class="page-title-block">
            <h2>회원 권한 변경</h2>
            <p>입주민 권한 신청 내역을 확인하고 승인 또는 반려 처리합니다.</p>
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
                    <label class="field-label">요청유형</label>
                    <select class="form-select" id="filterRqstTy">
                        <option value="">전체</option>
                        <option value="MVIN">입주신청</option>
                        <option value="MVOT">퇴거신청</option>
                        <option value="CHG">명의변경</option>
                    </select>
                </div>

                <div class="form-field">
                    <label class="field-label">처리상태</label>
                    <select class="form-select" id="filterStatus">
                        <option value="">전체</option>
                        <option value="WAIT">대기</option>
                        <option value="APRV">승인</option>
                        <option value="RJCT">반려</option>
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
                    <label class="field-label">접수일 시작</label>
                    <input type="date" class="form-input" id="filterStartDt">
                </div>

                <div class="form-field">
                    <label class="field-label">접수일 종료</label>
                    <input type="date" class="form-input" id="filterEndDt">
                </div>

                <div class="form-field">
                    <label class="field-label">&nbsp;</label>
                    <div class="page-actions" style="justify-content:flex-end;">
                        <button type="button" class="btn btn-secondary" id="btnResetFilter">
                            <span class="material-symbols-rounded">refresh</span>
                            초기화
                        </button>
                        <button type="button" class="btn btn-primary" id="btnSearch">
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
                <span class="material-symbols-rounded">how_to_reg</span>
                권한 신청 목록
            </h3>
            <span class="list-count" id="rqstCount">0건</span>
        </div>

        <div class="table-wrap">
            <table class="tbl">
                <thead>
                <tr>
                    <th>신청번호</th>
                    <th>신청자</th>
                    <th>연락처</th>
                    <th>요청유형</th>
                    <th>동/호수</th>
                    <th>입주예정일</th>
                    <th>접수일</th>
                    <th>상태</th>
                    <th>관리</th>
                </tr>
                </thead>
                <tbody id="rqstTableBody"></tbody>
            </table>
        </div>
    </div>

    <!-- 상세 모달 -->
    <div class="modal-overlay" id="rqstModal">
        <div class="modal modal-lg">
            <form id="rqstForm">
                <input type="hidden" id="rqstNo">

                <div class="modal-header primary">
                    <h3 class="modal-title">권한 신청 상세</h3>
                    <button type="button" class="modal-close" data-modal-close>
                        <span class="material-symbols-rounded">close</span>
                    </button>
                </div>

                <div class="modal-body">
                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-rounded">person</span>
                            신청자 정보
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">신청자</label>
                                <input type="text" class="form-input" id="detailUserNm" readonly>
                            </div>
                            <div class="form-field">
                                <label class="field-label">연락처</label>
                                <input type="text" class="form-input" id="detailTelno" readonly>
                            </div>
                        </div>
                    </div>

                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-rounded">home</span>
                            신청 정보
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">요청유형</label>
                                <input type="text" class="form-input" id="detailRqstTy" readonly>
                            </div>
                            <div class="form-field">
                                <label class="field-label">처리상태</label>
                                <input type="text" class="form-input" id="detailStatus" readonly>
                            </div>
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">동/호수</label>
                                <input type="text" class="form-input" id="detailUnit" readonly>
                            </div>
                            <div class="form-field">
                                <label class="field-label">접수일</label>
                                <input type="text" class="form-input" id="detailRcptDt" readonly>
                            </div>
                        </div>

                        <div class="form-row cols-2">
                            <div class="form-field">
                                <label class="field-label">입주예정일</label>
                                <input type="text" class="form-input" id="detailMvinPrdDt" readonly>
                            </div>
                            <div class="form-field">
                                <label class="field-label">퇴거예정일</label>
                                <input type="text" class="form-input" id="detailMvoutPrdDt" readonly>
                            </div>
                        </div>

                        <div class="form-row cols-1">
                            <div class="form-field">
                                <label class="field-label">퇴거사유/비고</label>
                                <textarea class="form-textarea" id="detailReason" readonly></textarea>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-modal-close>닫기</button>
                    <button type="button" class="btn btn-danger" id="btnReject">반려</button>
                    <button type="button" class="btn btn-primary" id="btnApprove">승인</button>
                </div>
            </form>
        </div>
    </div>

    <!-- 승인 확인 모달 -->
    <div class="modal-overlay" id="approveModal">
        <div class="modal modal-sm">
            <div class="modal-header primary">
                <h3 class="modal-title">승인 처리</h3>
                <button type="button" class="modal-close" data-close-approve>
                    <span class="material-symbols-rounded">close</span>
                </button>
            </div>

            <div class="modal-body">
                <div style="display:flex; gap:10px; padding:14px 16px; background:#f0f7f2; border:1px solid #a8ccb0; border-radius:8px; margin-bottom:18px;">
                    <span class="material-symbols-rounded" style="color:#2e5c38; font-size:20px; flex-shrink:0; margin-top:1px;">info</span>
                    <div style="font-size:13px; color:#1e4a2e; line-height:1.6;">
                        승인 처리 시 해당 신청자에게 <strong>입주민 권한이 즉시 부여</strong>됩니다.<br>
                        아래 내용을 다시 한 번 확인한 후 승인해 주세요.
                    </div>
                </div>

                <div class="mngr-detail-grid" id="approveDetailGrid" style="margin-bottom:18px;"></div>

                <div style="display:flex; align-items:flex-start; gap:10px; padding:12px 14px; background:#fffbf0; border:1px solid #e8d080; border-radius:8px;">
                    <input type="checkbox" id="approveConfirmCheck" style="margin-top:2px; width:16px; height:16px; cursor:pointer; accent-color:#2e5c38;">
                    <label for="approveConfirmCheck" style="font-size:13px; color:#6b4400; cursor:pointer; line-height:1.5;">
                        위 신청 내용을 확인하였으며, 해당 신청자에게 입주민 권한을 부여하는 것에 동의합니다.
                    </label>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-close-approve>취소</button>
                <button type="button" class="btn btn-primary" id="btnApproveConfirm" disabled
                        style="opacity:0.45; cursor:not-allowed;">
                    승인 완료
                </button>
            </div>
        </div>
    </div>

    <!-- 반려 확인 모달 -->
    <div class="modal-overlay" id="rejectModal">
        <div class="modal modal-sm">
            <div class="modal-header" style="background:#7f1d1d; border-bottom-color:#6b1818;">
                <h3 class="modal-title" style="color:#fff;">반려 처리</h3>
                <button type="button" class="modal-close" data-close-reject
                        style="background:rgba(255,255,255,0.14); color:rgba(255,255,255,0.85);">
                    <span class="material-symbols-rounded">close</span>
                </button>
            </div>

            <div class="modal-body">
                <div style="display:flex; gap:10px; padding:14px 16px; background:#fff0f0; border:1px solid #e0a8a8; border-radius:8px; margin-bottom:18px;">
                    <span class="material-symbols-rounded" style="color:#991b1b; font-size:20px; flex-shrink:0; margin-top:1px;">warning</span>
                    <div style="font-size:13px; color:#7f1d1d; line-height:1.6;">
                        반려 처리 시 신청자에게 <strong>반려 알림이 발송</strong>됩니다.<br>
                        반려 사유는 신청자에게 공개되므로 명확하게 작성해 주세요.
                    </div>
                </div>

                <div class="form-section" style="margin-bottom:0;">
                    <div class="form-row cols-1">
                        <div class="form-field">
                            <label class="field-label">반려 사유 <span class="req">*</span></label>
                            <textarea class="form-textarea" id="rejectReason" placeholder="반려 사유를 구체적으로 입력하세요." style="min-height:100px;"></textarea>
                            <span class="form-hint" id="rejectReasonHint" style="color:#991b1b; display:none;">반려 사유를 입력해야 합니다.</span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-close-reject>취소</button>
                <button type="button" class="btn btn-danger" id="btnRejectConfirm">반려 처리</button>
            </div>
        </div>
    </div>

</div>

<script>
    (function () {
        var page = document.getElementById("residentAuthPage");
        if (!page || page.dataset.bound === "true") return;
        page.dataset.bound = "true";

        var rqstRowData = [
            {
                rqstNo: 1, userNm: "김민수", telno: "010-1234-5678",
                rqstTyCd: "MVIN", dong: "101동", ho: "302호",
                mvinPrdDt: "2026-05-01", mvoutPrdDt: "", mvoutRsnCn: "",
                rcptDt: "2026-04-20", rqstSttsCd: "WAIT"
            },
            {
                rqstNo: 2, userNm: "이서연", telno: "010-9876-5432",
                rqstTyCd: "CHG", dong: "102동", ho: "804호",
                mvinPrdDt: "2026-05-10", mvoutPrdDt: "", mvoutRsnCn: "세대주 명의 변경 요청",
                rcptDt: "2026-04-22", rqstSttsCd: "WAIT"
            }
        ];

        var currentRqst = null;

        /* ───────── 코드 변환 ───────── */
        function rqstTypeText(code) {
            return { MVIN: "입주신청", MVOT: "퇴거신청", CHG: "명의변경" }[code] || "-";
        }

        function statusText(code) {
            return { WAIT: "대기", APRV: "승인", RJCT: "반려" }[code] || "-";
        }

        function statusBadge(code) {
            var map = { WAIT: "badge-yellow", APRV: "badge-green", RJCT: "badge-red" };
            return '<span class="badge ' + (map[code] || "badge-gray") + '">' + statusText(code) + '</span>';
        }

        /* ───────── 목록 렌더 ───────── */
        function getFilteredRows() {
            var rqstTy  = document.getElementById("filterRqstTy").value;
            var status  = document.getElementById("filterStatus").value;
            var keyword = document.getElementById("filterKeyword").value.trim();
            var startDt = document.getElementById("filterStartDt").value;
            var endDt   = document.getElementById("filterEndDt").value;

            return rqstRowData.filter(function (row) {
                return (!rqstTy  || row.rqstTyCd    === rqstTy)
                    && (!status  || row.rqstSttsCd  === status)
                    && (!keyword || row.userNm.indexOf(keyword) > -1 || row.telno.indexOf(keyword) > -1)
                    && (!startDt || row.rcptDt >= startDt)
                    && (!endDt   || row.rcptDt <= endDt);
            });
        }

        function renderTable() {
            var rows  = getFilteredRows();
            var tbody = document.getElementById("rqstTableBody");

            document.getElementById("rqstCount").textContent = rows.length + "건";

            if (rows.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" style="text-align:center;">조회된 신청 내역이 없습니다.</td></tr>';
                return;
            }

            tbody.innerHTML = rows.map(function (row) {
                return '<tr>'
                    + '<td class="td-mono">RQ' + String(row.rqstNo).padStart(3, "0") + '</td>'
                    + '<td class="td-bold">' + row.userNm + '</td>'
                    + '<td>' + row.telno + '</td>'
                    + '<td>' + rqstTypeText(row.rqstTyCd) + '</td>'
                    + '<td>' + row.dong + ' ' + row.ho + '</td>'
                    + '<td>' + (row.mvinPrdDt || "-") + '</td>'
                    + '<td>' + row.rcptDt + '</td>'
                    + '<td>' + statusBadge(row.rqstSttsCd) + '</td>'
                    + '<td><div class="grid-actions">'
                    + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-rqst-no="' + row.rqstNo + '">상세</button>'
                    + '</div></td>'
                    + '</tr>';
            }).join("");
        }

        function resetFilter() {
            ["filterRqstTy","filterStatus","filterKeyword","filterStartDt","filterEndDt"]
                .forEach(function(id){ document.getElementById(id).value = ""; });
            renderTable();
        }

        /* ───────── 상세 모달 ───────── */
        function openDetailModal(row) {
            currentRqst = row;

            document.getElementById("rqstNo").value          = row.rqstNo;
            document.getElementById("detailUserNm").value    = row.userNm   || "";
            document.getElementById("detailTelno").value     = row.telno    || "";
            document.getElementById("detailRqstTy").value    = rqstTypeText(row.rqstTyCd);
            document.getElementById("detailStatus").value    = statusText(row.rqstSttsCd);
            document.getElementById("detailUnit").value      = (row.dong || "-") + " " + (row.ho || "");
            document.getElementById("detailRcptDt").value    = row.rcptDt      || "";
            document.getElementById("detailMvinPrdDt").value = row.mvinPrdDt   || "";
            document.getElementById("detailMvoutPrdDt").value = row.mvoutPrdDt || "";
            document.getElementById("detailReason").value    = row.mvoutRsnCn  || "";

            var isWait = row.rqstSttsCd === "WAIT";
            document.getElementById("btnApprove").style.display = isWait ? "inline-flex" : "none";
            document.getElementById("btnReject").style.display  = isWait ? "inline-flex" : "none";

            document.getElementById("rqstModal").classList.add("open");
        }

        function closeDetailModal() {
            document.getElementById("rqstModal").classList.remove("open");
        }

        /* ───────── 승인 모달 ───────── */
        function openApproveModal() {
            if (!currentRqst) return;

            // 확인용 상세 그리드 채우기
            var row = currentRqst;
            var items = [
                ["신청자",    row.userNm],
                ["연락처",    row.telno],
                ["요청유형",  rqstTypeText(row.rqstTyCd)],
                ["동/호수",   row.dong + " " + row.ho],
                ["입주예정일", row.mvinPrdDt || "-"],
                ["접수일",    row.rcptDt]
            ];

            document.getElementById("approveDetailGrid").innerHTML = items.map(function(item) {
                return '<div class="mngr-detail-item">'
                    + '<div class="mngr-detail-label">' + item[0] + '</div>'
                    + '<div class="mngr-detail-value">' + item[1] + '</div>'
                    + '</div>';
            }).join("");

            // 체크박스 초기화
            var check = document.getElementById("approveConfirmCheck");
            var btn   = document.getElementById("btnApproveConfirm");
            check.checked  = false;
            btn.disabled   = true;
            btn.style.opacity = "0.45";
            btn.style.cursor  = "not-allowed";

            document.getElementById("approveModal").classList.add("open");
        }

        function closeApproveModal() {
            document.getElementById("approveModal").classList.remove("open");
        }

        /* ───────── 반려 모달 ───────── */
        function openRejectModal() {
            if (!currentRqst) return;

            document.getElementById("rejectReason").value       = "";
            document.getElementById("rejectReasonHint").style.display = "none";
            document.getElementById("rejectModal").classList.add("open");
        }

        function closeRejectModal() {
            document.getElementById("rejectModal").classList.remove("open");
        }

        /* ───────── 처리 ───────── */
        function approveRqst() {
            if (!currentRqst) return;
            currentRqst.rqstSttsCd = "APRV";
            renderTable();
            closeApproveModal();
            closeDetailModal();
            alert("승인 처리되었습니다.");
        }

        function rejectRqst() {
            if (!currentRqst) return;

            var reason = document.getElementById("rejectReason").value.trim();
            var hint   = document.getElementById("rejectReasonHint");

            if (!reason) {
                hint.style.display = "block";
                document.getElementById("rejectReason").focus();
                return;
            }

            hint.style.display = "none";
            currentRqst.rqstSttsCd = "RJCT";
            currentRqst.mvoutRsnCn = reason;

            renderTable();
            closeRejectModal();
            closeDetailModal();
            alert("반려 처리되었습니다.");
        }

        /* ───────── 이벤트 ───────── */
        document.getElementById("btnSearch").addEventListener("click", renderTable);
        document.getElementById("btnResetFilter").addEventListener("click", resetFilter);

        // 승인 버튼 → 승인 확인 모달
        document.getElementById("btnApprove").addEventListener("click", function () {
            closeDetailModal();
            openApproveModal();
        });

        // 반려 버튼 → 반려 확인 모달
        document.getElementById("btnReject").addEventListener("click", function () {
            closeDetailModal();
            openRejectModal();
        });

        // 체크박스 → 승인 버튼 활성화
        document.getElementById("approveConfirmCheck").addEventListener("change", function () {
            var btn = document.getElementById("btnApproveConfirm");
            btn.disabled          = !this.checked;
            btn.style.opacity     = this.checked ? "1"            : "0.45";
            btn.style.cursor      = this.checked ? "pointer"      : "not-allowed";
        });

        document.getElementById("btnApproveConfirm").addEventListener("click", approveRqst);
        document.getElementById("btnRejectConfirm").addEventListener("click", rejectRqst);

        page.addEventListener("click", function (e) {
            // 상세 버튼
            var detailBtn = e.target.closest('[data-action="detail"]');
            if (detailBtn) {
                var rqstNo = Number(detailBtn.dataset.rqstNo);
                var row = rqstRowData.find(function(r){ return r.rqstNo === rqstNo; });
                if (row) openDetailModal(row);
            }

            if (e.target.closest("[data-modal-close]"))  closeDetailModal();
            if (e.target.closest("[data-close-approve]")) closeApproveModal();
            if (e.target.closest("[data-close-reject]"))  closeRejectModal();

            if (e.target.id === "rqstModal")    closeDetailModal();
            if (e.target.id === "approveModal") closeApproveModal();
            if (e.target.id === "rejectModal")  closeRejectModal();
        });

        renderTable();
    })();
</script>
