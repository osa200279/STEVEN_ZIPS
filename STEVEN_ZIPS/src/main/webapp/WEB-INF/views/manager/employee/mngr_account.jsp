<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리사무소</title>
    <sec:csrfMetaTags/>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">
    <style>
        #mngrAccountPage .filter-card { justify-content: space-between; }
        #mngrAccountPage .filter-left,
        #mngrAccountPage .filter-right { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        #mngrAccountPage .filter-right { gap: 8px; margin-left: auto; }
        #mngrAccountPage .filter-select  { width: 150px; }
        #mngrAccountPage .filter-keyword { width: 300px; }
        #mngrAccountPage .manager-grid-wrap { width: 100%; }
        #mngrAccountPage .manager-ag-grid  { width: 100%; }
        #mngrAccountPage .grid-actions { display: flex; justify-content: center; align-items: center; gap: 6px; flex-wrap: nowrap; }
        #mngrAccountPage .grid-actions .btn { flex-shrink: 0; }
        #mngrAccountPage .confirm-message { font-size: 13px; color: var(--text-secondary); margin-bottom: 14px; }

        /* 회원 검색 모달 */
        #memberSearchModal .member-list { max-height: 300px; overflow-y: auto; margin-top: 12px; }
        #memberSearchModal .member-item {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 14px; border-radius: 8px; cursor: pointer;
            border: 1px solid var(--border); margin-bottom: 6px; transition: .15s;
        }
        #memberSearchModal .member-item:hover { background: #f0f7f2; border-color: #2e5c38; }
        #memberSearchModal .member-item .m-avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: #e8f0ea; color: #2e5c38;
            display: flex; align-items: center; justify-content: center;
            font-size: 14px; font-weight: 700; flex-shrink: 0;
        }
        #memberSearchModal .member-item .m-name { font-size: 13px; font-weight: 700; }
        #memberSearchModal .member-item .m-sub  { font-size: 11px; color: var(--text-tertiary); }
        #memberSearchModal .member-empty { text-align: center; padding: 24px; font-size: 13px; color: var(--text-tertiary); }

        /* 선택된 회원 표시 박스 */
        #rqstSelectedMember {
            display: none; align-items: center; gap: 10px;
            padding: 10px 14px; border-radius: 8px;
            background: #f0f7f2; border: 1px solid #b7d4bb; margin-top: 8px;
        }
        #rqstSelectedMember.visible { display: flex; }
        #rqstSelectedMember .sel-avatar {
            width: 32px; height: 32px; border-radius: 50%;
            background: #2e5c38; color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 13px; font-weight: 700; flex-shrink: 0;
        }
        #rqstSelectedMember .sel-info { flex: 1; }
        #rqstSelectedMember .sel-name { font-size: 13px; font-weight: 700; }
        #rqstSelectedMember .sel-sub  { font-size: 11px; color: var(--text-tertiary); }
        #rqstSelectedMember .sel-clear { cursor: pointer; color: var(--text-tertiary); }
    </style>
    <script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
    <script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>
</head>
<body>
<div class="app-wrapper">
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
    <div class="main-wrap">
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
        <main class="main-content">
            <div class="office-page" id="mngrAccountPage">

                <div class="page-header">
                    <div class="page-title-block">
                        <h2>직원 계정 관리</h2>
                        <p>관리사무소 직원 계정과 계정 생성 요청 상태를 관리합니다.</p>
                    </div>
                    <div class="page-actions">
                        <button type="button" class="btn btn-primary" data-action="open-request-modal">
                            <span class="material-symbols-rounded">person_add</span>계정 생성 요청
                        </button>
                    </div>
                </div>

                <!-- 현황 카드 -->
                <div class="stat-row">
                    <div class="stat-card">
                        <div class="stat-icon green"><span class="material-symbols-rounded">group</span></div>
                        <div><div class="stat-value" id="statManagerCount">0</div><div class="stat-label">재직 직원</div></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon blue"><span class="material-symbols-rounded">badge</span></div>
                        <div><div class="stat-value" id="statActiveCount">0</div><div class="stat-label">활성 계정</div></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon yellow"><span class="material-symbols-rounded">pending_actions</span></div>
                        <div><div class="stat-value" id="statWaitCount">0</div><div class="stat-label">승인대기 요청</div></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon red"><span class="material-symbols-rounded">block</span></div>
                        <div><div class="stat-value" id="statInactiveCount">0</div><div class="stat-label">비활성 계정</div></div>
                    </div>
                </div>

                <!-- 탭 -->
                <div class="tab-bar">
                    <button type="button" class="tab-btn active" data-action="change-tab" data-tab="manager">
                        <span class="material-symbols-rounded">groups</span>재직 직원
                    </button>
                    <button type="button" class="tab-btn" data-action="change-tab" data-tab="request">
                        <span class="material-symbols-rounded">assignment_ind</span>생성 요청
                    </button>
                </div>

                <!-- 재직 직원 탭 -->
                <div class="tab-panel active" id="managerTabPanel">
                    <div class="panel">
                        <div class="panel-header">
                            <div class="panel-title"><span class="material-symbols-rounded">manage_accounts</span>재직 직원 목록</div>
                        </div>
                        <div class="filter-card">
                            <div class="filter-left">
                                <select class="form-select filter-select" id="managerDutyFilter">
                                    <option value="">전체 직무</option>
                                    <option value="ACNT">회계담당</option>
                                    <option value="ADM">행정담당</option>
                                    <option value="FAC">시설담당</option>
                                </select>
                                <select class="form-select filter-select" id="managerUseFilter">
                                    <option value="">전체 상태</option>
                                    <option value="Y">활성</option>
                                    <option value="N">비활성</option>
                                </select>
                            </div>
                            <div class="filter-right">
                                <div class="search-wrap filter-keyword">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="managerKeyword" placeholder="이름, 아이디, 연락처 검색">
                                </div>
                                <button type="button" class="btn btn-primary" data-action="search-manager">검색</button>
                                <button type="button" class="btn btn-secondary" data-action="reset-manager">초기화</button>
                                <button type="button" class="btn btn-secondary" data-action="excel-download">엑셀 다운로드</button>
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

                <!-- 생성 요청 탭 -->
                <div class="tab-panel" id="requestTabPanel">
                    <div class="panel">
                        <div class="panel-header">
                            <div class="panel-title"><span class="material-symbols-rounded">assignment</span>계정 생성 요청 목록</div>
                            <button type="button" class="btn btn-primary btn-sm" data-action="open-request-modal">
                                <span class="material-symbols-rounded">add</span>요청 등록
                            </button>
                        </div>
                        <div class="filter-card">
                            <div class="filter-left">
                                <select class="form-select filter-select" id="requestDutyFilter">
                                    <option value="">전체 직무</option>
                                    <option value="ACNT">회계담당</option>
                                    <option value="ADM">행정담당</option>
                                    <option value="FAC">시설담당</option>
                                </select>
                                <select class="form-select filter-select" id="requestStatusFilter">
                                    <option value="">전체 상태</option>
                                    <option value="WAIT">승인대기</option>
                                    <option value="APRV">승인완료</option>
                                    <option value="RJCT">반려</option>
                                    <option value="HOLD">보류</option>
                                </select>
                            </div>
                            <div class="filter-right">
                                <div class="search-wrap filter-keyword">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="requestKeyword" placeholder="이름, 아이디 검색">
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

                <!-- ===== 재직 직원 상세/수정 모달 ===== -->
                <div class="modal-overlay" id="accountModal">
                    <div class="modal modal-lg">
                        <div class="modal-header">
                            <h3 class="modal-title" id="accountModalTitle">재직 직원 상세</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="accountForm">
                            <input type="hidden" id="accountUserNo">
                            <input type="hidden" id="accountMgmtOfcNo">
                            <input type="hidden" id="accountUserYn">
                            <div class="modal-body">
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">person</span>기본 정보
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">직원명</label>
                                            <input type="text" class="form-input" id="accountUserNm" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">로그인 아이디</label>
                                            <input type="text" class="form-input" id="accountUserId" readonly>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">연락처</label>
                                            <input type="text" class="form-input" id="accountTelno">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">이메일</label>
                                            <input type="text" class="form-input" id="accountUserEml">
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">생년월일</label>
                                            <input type="text" class="form-input" id="accountBirthDate" readonly placeholder="YYMMDD">
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">직무</label>
                                            <select class="form-select" id="accountDutyCd">
                                                <option value="">직무 선택</option>
                                                <option value="ACNT">회계담당</option>
                                                <option value="ADM">행정담당</option>
                                                <option value="FAC">시설담당</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">소속 단지</label>
                                            <input type="text" class="form-input" id="accountCmplexNm" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">관리사무소</label>
                                            <input type="text" class="form-input" id="accountMgmtOfcNm" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer" id="accountModalFooter"></div>
                        </form>
                    </div>
                </div>

                <!-- ===== 계정 생성 요청 모달 ===== -->
                <div class="modal-overlay" id="requestModal">
                    <div class="modal modal-lg">
                        <div class="modal-header">
                            <h3 class="modal-title" id="requestModalTitle">계정 생성 요청 등록</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="requestForm">
                            <input type="hidden" id="rqstNo">
                            <input type="hidden" id="rqstUserNo">
                            <input type="hidden" id="rqstMgmtOfcNoHidden">
                            <div class="modal-body">

                                <!-- 요청자 정보 -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">manage_accounts</span>
                                        요청자 정보
                                        <span style="font-size:11px;font-weight:400;color:var(--text-tertiary);margin-left:6px;">로그인한 관리소장 정보입니다.</span>
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">관리소장명</label>
                                            <input type="text" class="form-input" id="loginMngrNm" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">소속 단지</label>
                                            <input type="text" class="form-input" id="loginCmplexNm" readonly>
                                        </div>
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">소속 관리사무소</label>
                                            <input type="text" class="form-input" id="loginMgmtOfcNm" readonly>
                                        </div>
                                    </div>
                                </div>

                                <!-- 회원 검색 -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">manage_search</span>
                                        직원 회원 검색
                                        <span style="font-size:11px;font-weight:400;color:var(--text-tertiary);margin-left:6px;">기가입 회원 중 직원으로 등록할 회원을 검색·선택하세요.</span>
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">회원 검색 <span class="req">*</span></label>
                                            <div style="display:flex;gap:8px;">
                                                <input type="text" class="form-input" id="memberSearchKeyword" placeholder="이름 또는 아이디로 검색">
                                                <button type="button" class="btn btn-secondary" data-action="open-member-search">
                                                    <span class="material-symbols-rounded">search</span>검색
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <div id="rqstSelectedMember">
                                        <div class="sel-avatar" id="selMemberAvatar"></div>
                                        <div class="sel-info">
                                            <div class="sel-name" id="selMemberName"></div>
                                            <div class="sel-sub"  id="selMemberSub"></div>
                                        </div>
                                        <span class="material-symbols-rounded sel-clear" data-action="clear-member">close</span>
                                    </div>
                                </div>

                                <!-- 요청 정보 -->
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">assignment_ind</span>요청 정보
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">직원명</label>
                                            <input type="text" class="form-input" id="rqstMngrNm" placeholder="회원 선택 시 자동 입력" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">로그인 아이디</label>
                                            <input type="text" class="form-input" id="rqstLoginId" placeholder="회원 선택 시 자동 입력" readonly>
                                        </div>
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">직무 <span class="req">*</span></label>
                                            <select class="form-select" id="rqstDutyCd">
                                                <option value="">직무 선택</option>
                                                <option value="ACNT">회계담당</option>
                                                <option value="ADM">행정담당</option>
                                                <option value="FAC">시설담당</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">비고</label>
                                            <textarea class="form-textarea" id="rqstRmrkCn" placeholder="추가 메모나 요청 사항을 입력하세요."></textarea>
                                        </div>
                                    </div>
                                </div>

                                <!-- 요청 상태: 상세/수정 시에만 표시 -->
                                <div class="form-section" id="rqstStatusSection" style="display:none;">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">info</span>요청 상태
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">요청일</label>
                                            <input type="text" class="form-input" id="rqstDt" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">상태</label>
                                            <input type="text" class="form-input" id="rqstSttsCdText" readonly>
                                        </div>
                                    </div>
                                    <div class="form-row cols-1" id="rqstRjctBox" style="display:none;">
                                        <div class="form-field">
                                            <label class="field-label">반려 사유</label>
                                            <textarea class="form-textarea" id="rqstRjctRsnCn" readonly></textarea>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="modal-footer" id="requestModalFooter"></div>
                        </form>
                    </div>
                </div>

                <!-- ===== 회원 검색 팝업 모달 ===== -->
                <div class="modal-overlay" id="memberSearchModal">
                    <div class="modal modal-md">
                        <div class="modal-header">
                            <h3 class="modal-title">회원 검색</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div style="display:flex;gap:8px;">
                                <input type="text" class="form-input" id="memberModalKeyword" placeholder="이름 또는 아이디 입력">
                                <button type="button" class="btn btn-primary" data-action="do-member-search">검색</button>
                            </div>
                            <div class="member-list" id="memberSearchResult">
                                <div class="member-empty">검색 중...</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ===== 확인 모달 ===== -->
                <div class="modal-overlay" id="confirmModal">
                    <div class="modal modal-sm">
                        <div class="modal-header">
                            <h3 class="modal-title" id="confirmTitle">확인</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <p class="confirm-message" id="confirmMessage"></p>
                            <div class="form-row cols-1" id="confirmReasonBox" style="display:none;">
                                <div class="form-field">
                                    <label class="field-label">사유 / 메모</label>
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

            </div><%-- /#mngrAccountPage --%>
        </main>
    </div>
</div>

<script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        initMngrAccountPage();
    });

    function initMngrAccountPage() {
        var page = document.getElementById("mngrAccountPage");
        if (!page) return;

        var contextPath = "${pageContext.request.contextPath}";
        var managerRowData = [];
        var requestRowData = [];
        var loginInfo      = null;
        var managerGridEl  = document.getElementById("managerGrid");
        var requestGridEl  = document.getElementById("requestGrid");
        var confirmCallback = null;

        /* ── 유틸 ── */
        function safe(v) { return (v === null || v === undefined || v === "null") ? "" : String(v); }
        function getField(id) { var el = document.getElementById(id); return el ? el.value.trim() : ""; }
        function setField(id, v) { var el = document.getElementById(id); if (el) el.value = safe(v); }

        var DUTY_TEXT  = { HEAD:"관리소장", ACNT:"회계담당", ADM:"행정담당", FAC:"시설담당" };
        var DUTY_CLASS = { HEAD:"duty-head", ACNT:"duty-acnt", ADM:"duty-adm", FAC:"duty-fac" };
        var STTS_TEXT  = { WAIT:"승인대기", APRV:"승인완료", RJCT:"반려", HOLD:"보류", CNL:"취소" };
        var STTS_CLASS = { WAIT:"status-wait", APRV:"status-aprv", RJCT:"status-rjct", HOLD:"status-hold", CNL:"gray" };

        function dutyText(c)   { return DUTY_TEXT[c]  || "-"; }
        function dutyClass(c)  { return DUTY_CLASS[c] || "gray"; }
        function sttsText(c)   { return STTS_TEXT[c]  || "-"; }
        function sttsClass(c)  { return STTS_CLASS[c] || "gray"; }
        function useYnClass(c) { return c === "Y" ? "status-active" : "status-inactive"; }

        function formatDate(v) {
            if (!v) return "-";
            var s = String(v);
            if (s.length >= 10 && s.indexOf("-") > -1) return s.substring(0, 10).replaceAll("-", ".");
            if (s.length === 8 && !isNaN(s)) return s.substring(0,4)+"."+s.substring(4,6)+"."+s.substring(6,8);
            var d = new Date(s);
            if (!isNaN(d.getTime())) return d.getFullYear()+"."+String(d.getMonth()+1).padStart(2,"0")+"."+String(d.getDate()).padStart(2,"0");
            return s;
        }

        function renderBadge(text, cls) { return '<span class="grid-badge '+cls+'">'+text+'</span>'; }

        function avatarCell(name, sub) {
            return '<div class="avatar-row">'
                + '<div class="avatar avatar-sm">'+(name ? name.charAt(0) : "-")+'</div>'
                + '<div class="avatar-info"><div class="name">'+safe(name)+'</div><div class="sub">'+safe(sub)+'</div></div>'
                + '</div>';
        }

        /* ── Ajax ── */
        function getJson(url) {
            return fetch(url, { headers: { "X-Requested-With":"XMLHttpRequest" } })
                .then(function(r){ return r.json(); });
        }

        function postJson(url, data) {
            var ch = document.querySelector("meta[name='_csrf_header']");
            var ct = document.querySelector("meta[name='_csrf']");
            var headers = { "Content-Type":"application/json", "X-Requested-With":"XMLHttpRequest" };
            if (ch && ct) headers[ch.content] = ct.content;
            return fetch(url, { method:"POST", headers:headers, body:JSON.stringify(data) })
                .then(function(r){ return r.json(); });
        }

        function reloadData() {
            getJson(contextPath + "/manager/employee/info").then(function(data) {
                loginInfo = data.loginInfo;
                if (loginInfo) {
                    setField("loginMngrNm",   loginInfo.userNm);
                    setField("loginCmplexNm", loginInfo.aptCmplexNm);
                    setField("loginMgmtOfcNm", loginInfo.mgmtOfcNm);
                    document.getElementById("rqstMgmtOfcNoHidden").value = loginInfo.mgmtOfcNo || "";
                }
            });

            getJson(contextPath + "/manager/employee/manager/list").then(function(data) {
                managerRowData = data.list || [];
                updateStats();
                setRows(managerGridEl, managerRowData);
            });

            getJson(contextPath + "/manager/employee/request/list").then(function(data) {
                requestRowData = data.list || [];
                updateStats();
                setRows(requestGridEl, requestRowData);
            });
        }

        function reloadPage() { location.href = contextPath + "/manager/employee/account"; }

        function setRows(el, rows) {
            if (typeof setGridRowData === "function") { setGridRowData(el, rows); return; }
            if (el && el._gridApi) el._gridApi.setGridOption("rowData", rows);
        }

        /* ── 현황 카드 ── */
        function updateStats() {
            document.getElementById("statManagerCount").textContent  = managerRowData.length;
            document.getElementById("statActiveCount").textContent   = managerRowData.filter(function(r){ return r.userYn==="Y"; }).length;
            document.getElementById("statInactiveCount").textContent = managerRowData.filter(function(r){ return r.userYn==="N"; }).length;
            document.getElementById("statWaitCount").textContent     = requestRowData.filter(function(r){ return r.rqstSttsCd==="WAIT"; }).length;
        }

        /* ── AG Grid 생성 ── */
        function createGrids() {
            if (typeof destroyManagerGrid === "function") {
                destroyManagerGrid(managerGridEl);
                destroyManagerGrid(requestGridEl);
            }
            if (typeof createManagerGrid !== "function") return;

            createManagerGrid(managerGridEl, [
                { headerName:"직원",      field:"userNm",      width:200, cellRenderer: function(p){ return avatarCell(p.data.userNm, p.data.userId); } },
                { headerName:"직무",      field:"mngrDutyCd",  width:120, cellRenderer: function(p){ return renderBadge(dutyText(p.value), dutyClass(p.value)); } },
                { headerName:"소속 단지", field:"aptCmplexNm", width:200 },
                { headerName:"연락처",    field:"telno",       width:140 },
                { headerName:"상태",      field:"userYn",      width:90,  cellRenderer: function(p){ return renderBadge(p.value==="Y"?"활성":"비활성", useYnClass(p.value)); } },
                { headerName:"관리",      field:"userNo",      width:140, sortable:false,
                    cellRenderer: function(p) {
                        var no = p.data.userNo;
                        return '<div class="grid-actions">'
                            +'<button type="button" class="btn btn-detail" data-action="manager-detail" data-user-no="'+no+'">상세</button>'
                            +'<button type="button" class="btn btn-edit"   data-action="manager-edit"   data-user-no="'+no+'">수정</button>'
                            +'</div>';
                    }
                }
            ], managerRowData, { domLayout:"autoHeight", paginationPageSize:10 });

            createManagerGrid(requestGridEl, [
                { headerName:"요청 직원", field:"rqstMngrNm",  width:180, cellRenderer: function(p){ return avatarCell(p.data.rqstMngrNm, p.data.rqstLoginId); } },
                { headerName:"직무",      field:"rqstDutyCd",  width:120, cellRenderer: function(p){ return renderBadge(dutyText(p.value), dutyClass(p.value)); } },
                { headerName:"소속 단지", field:"aptCmplexNm", width:200 },
                { headerName:"요청일",    field:"rqstDt",      width:120, valueFormatter: function(p){ return formatDate(p.value); } },
                { headerName:"승인일",    field:"aprvDt",      width:120, valueFormatter: function(p){ return formatDate(p.value); } },
                { headerName:"상태",      field:"rqstSttsCd",  width:100, cellRenderer: function(p){ return renderBadge(sttsText(p.value), sttsClass(p.value)); } },
                { headerName:"관리",      field:"rqstNo",      width:180, sortable:false,
                    cellRenderer: function(p) {
                        var no  = p.data.rqstNo;
                        var dis = p.data.rqstSttsCd !== "WAIT" ? " disabled" : "";
                        return '<div class="grid-actions">'
                            +'<button type="button" class="btn btn-detail" data-action="request-detail" data-rqst-no="'+no+'">상세</button>'
                            +'<button type="button" class="btn btn-edit"   data-action="request-edit"   data-rqst-no="'+no+'"'+dis+'>수정</button>'
                            +'<button type="button" class="btn btn-delete" data-action="request-cancel" data-rqst-no="'+no+'"'+dis+'>취소</button>'
                            +'</div>';
                    }
                }
            ], requestRowData, { domLayout:"autoHeight", paginationPageSize:10 });
        }

        /* ── 필터 ── */
        function applyManagerFilter() {
            var duty  = document.getElementById("managerDutyFilter").value;
            var useYn = document.getElementById("managerUseFilter").value;
            var kw    = document.getElementById("managerKeyword").value.trim();
            setRows(managerGridEl, managerRowData.filter(function(r) {
                return (!duty  || r.mngrDutyCd === duty)
                    && (!useYn || r.userYn === useYn)
                    && (!kw    || [r.userNm, r.userId, r.telno].join(" ").indexOf(kw) > -1);
            }));
        }

        function applyRequestFilter() {
            var duty   = document.getElementById("requestDutyFilter").value;
            var status = document.getElementById("requestStatusFilter").value;
            var kw     = document.getElementById("requestKeyword").value.trim();
            setRows(requestGridEl, requestRowData.filter(function(r) {
                return (!duty   || r.rqstDutyCd === duty)
                    && (!status || r.rqstSttsCd === status)
                    && (!kw     || [r.rqstMngrNm, r.rqstLoginId].join(" ").indexOf(kw) > -1);
            }));
        }

        function resetManagerFilter() {
            document.getElementById("managerDutyFilter").value = "";
            document.getElementById("managerUseFilter").value  = "";
            document.getElementById("managerKeyword").value    = "";
            setRows(managerGridEl, managerRowData);
        }

        function resetRequestFilter() {
            document.getElementById("requestDutyFilter").value   = "";
            document.getElementById("requestStatusFilter").value = "";
            document.getElementById("requestKeyword").value      = "";
            setRows(requestGridEl, requestRowData);
        }

        /* ── 엑셀 다운로드 ── */
        function excelDownload() {
            var rows = managerRowData.map(function(r) {
                return {
                    "직원명":     safe(r.userNm),
                    "아이디":     safe(r.userId),
                    "직무":       dutyText(r.mngrDutyCd),
                    "소속 단지":  safe(r.aptCmplexNm),
                    "관리사무소": safe(r.mgmtOfcNm),
                    "연락처":     safe(r.telno),
                    "이메일":     safe(r.userEml),
                    "상태":       r.userYn === "Y" ? "활성" : "비활성"
                };
            });
            var ws = XLSX.utils.json_to_sheet(rows);
            var wb = XLSX.utils.book_new();
            XLSX.utils.book_append_sheet(wb, ws, "재직직원");
            XLSX.writeFile(wb, "재직직원목록.xlsx");
        }

        /* ── 탭 전환 ── */
        function changeTab(tab) {
            page.querySelectorAll(".tab-btn").forEach(function(b){ b.classList.toggle("active", b.dataset.tab === tab); });
            document.getElementById("managerTabPanel").classList.toggle("active", tab === "manager");
            document.getElementById("requestTabPanel").classList.toggle("active", tab === "request");
        }

        /* ── 모달 ── */
        function openModal(id)  { document.getElementById(id).classList.add("open"); }
        function closeModal(id) { document.getElementById(id).classList.remove("open"); }
        function closeAllModals() { page.querySelectorAll(".modal-overlay.open").forEach(function(m){ m.classList.remove("open"); }); }

        function setFormDisabled(formId, disabled) {
            document.getElementById(formId)
                .querySelectorAll("input:not([type=hidden]),select,textarea")
                .forEach(function(el){ el.disabled = disabled; });
        }

        /* ── 재직 직원 상세 ── */
        function openManagerDetail(row) {
            document.getElementById("accountModalTitle").textContent = "재직 직원 상세";
            setField("accountUserNo",    row.userNo);
            setField("accountMgmtOfcNo", row.mgmtOfcNo);
            setField("accountUserYn",    row.userYn);
            setField("accountUserNm",    row.userNm);
            setField("accountUserId",    row.userId);
            setField("accountTelno",     row.telno);
            setField("accountUserEml",   row.userEml);
            setField("accountBirthDate", safe(row.birthDate));
            setField("accountCmplexNm",  safe(row.aptCmplexNm));
            setField("accountMgmtOfcNm", safe(row.mgmtOfcNm));
            document.getElementById("accountDutyCd").value = row.mngrDutyCd || "";
            setFormDisabled("accountForm", true);
            document.getElementById("accountModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>'
                +'<button type="button" class="btn btn-primary" data-action="manager-edit" data-user-no="'+row.userNo+'">수정</button>';
            openModal("accountModal");
        }

        /* ── 재직 직원 수정 ── */
        function openManagerEdit(row) {
            document.getElementById("accountModalTitle").textContent = "재직 직원 수정";
            setField("accountUserNo",    row.userNo);
            setField("accountMgmtOfcNo", row.mgmtOfcNo);
            setField("accountUserYn",    row.userYn);
            setField("accountUserNm",    row.userNm);
            setField("accountUserId",    row.userId);
            setField("accountTelno",     row.telno);
            setField("accountUserEml",   row.userEml);
            setField("accountBirthDate", safe(row.birthDate));
            setField("accountCmplexNm",  safe(row.aptCmplexNm));
            setField("accountMgmtOfcNm", safe(row.mgmtOfcNm));
            document.getElementById("accountDutyCd").value = row.mngrDutyCd || "";
            setFormDisabled("accountForm", false);
            ["accountUserNm","accountUserId","accountBirthDate","accountCmplexNm","accountMgmtOfcNm"]
                .forEach(function(id){ document.getElementById(id).disabled = true; });
            document.getElementById("accountModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
                +'<button type="button" class="btn btn-primary" data-action="submit-manager-update">수정 저장</button>';
            openModal("accountModal");
        }

        /* ── 요청 폼 초기화 ── */
        function clearRequestForm() {
            document.getElementById("requestForm").reset();
            setField("rqstNo", "");
            setField("rqstUserNo", "");
            clearSelectedMember();
            document.getElementById("rqstStatusSection").style.display = "none";
            document.getElementById("rqstRjctBox").style.display = "none";
        }

        /* ── 요청 등록 ── */
        function openRequestInsert() {
            clearRequestForm();
            document.getElementById("requestModalTitle").textContent = "계정 생성 요청 등록";
            if (loginInfo) {
                setField("loginMngrNm",   loginInfo.userNm);
                setField("loginCmplexNm", loginInfo.aptCmplexNm);
                setField("loginMgmtOfcNm", loginInfo.mgmtOfcNm);
                document.getElementById("rqstMgmtOfcNoHidden").value = loginInfo.mgmtOfcNo || "";
            }
            setFormDisabled("requestForm", false);
            document.getElementById("requestModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
                +'<button type="button" class="btn btn-primary" data-action="submit-request-insert">등록 요청</button>';
            openModal("requestModal");
        }

        /* ── 요청 상세 ── */
        function openRequestDetail(row) {
            clearRequestForm();
            document.getElementById("requestModalTitle").textContent = "계정 생성 요청 상세";
            setField("rqstNo",      row.rqstNo);
            setField("rqstUserNo",  row.userNo);
            setField("rqstMngrNm",  row.rqstMngrNm);
            setField("rqstLoginId", row.rqstLoginId);
            setField("rqstRmrkCn",  row.rmrkCn);
            document.getElementById("rqstDutyCd").value          = row.rqstDutyCd || "";
            document.getElementById("rqstMgmtOfcNoHidden").value = row.mgmtOfcNo  || "";
            showSelectedMember({ userNo:row.userNo, userNm:row.rqstMngrNm, userId:row.rqstLoginId });
            document.getElementById("rqstStatusSection").style.display = "";
            setField("rqstDt",         formatDate(row.rqstDt));
            setField("rqstSttsCdText",  sttsText(row.rqstSttsCd));
            if (row.rqstSttsCd === "RJCT" && row.rjctRsnCn) {
                document.getElementById("rqstRjctBox").style.display = "";
                setField("rqstRjctRsnCn", row.rjctRsnCn);
            }
            setFormDisabled("requestForm", true);
            var footer = '<button type="button" class="btn btn-secondary" data-modal-close>닫기</button>';
            if (row.rqstSttsCd === "WAIT") {
                footer += '<button type="button" class="btn btn-primary" data-action="request-edit" data-rqst-no="'+row.rqstNo+'">수정</button>';
            }
            document.getElementById("requestModalFooter").innerHTML = footer;
            openModal("requestModal");
        }

        /* ── 요청 수정 ── */
        function openRequestEdit(row) {
            clearRequestForm();
            document.getElementById("requestModalTitle").textContent = "계정 생성 요청 수정";
            setField("rqstNo",      row.rqstNo);
            setField("rqstUserNo",  row.userNo);
            setField("rqstMngrNm",  row.rqstMngrNm);
            setField("rqstLoginId", row.rqstLoginId);
            setField("rqstRmrkCn",  row.rmrkCn);
            document.getElementById("rqstDutyCd").value          = row.rqstDutyCd || "";
            document.getElementById("rqstMgmtOfcNoHidden").value = row.mgmtOfcNo  || "";
            showSelectedMember({ userNo:row.userNo, userNm:row.rqstMngrNm, userId:row.rqstLoginId });
            setFormDisabled("requestForm", false);
            ["rqstMngrNm","rqstLoginId"].forEach(function(id){ document.getElementById(id).disabled = true; });
            document.getElementById("requestModalFooter").innerHTML =
                '<button type="button" class="btn btn-secondary" data-modal-close>취소</button>'
                +'<button type="button" class="btn btn-primary" data-action="submit-request-update">수정 저장</button>';
            openModal("requestModal");
        }

        /* ── 선택 회원 표시/해제 ── */
        function showSelectedMember(member) {
            document.getElementById("selMemberAvatar").textContent = member.userNm ? member.userNm.charAt(0) : "-";
            document.getElementById("selMemberName").textContent   = safe(member.userNm);
            document.getElementById("selMemberSub").textContent    = safe(member.userId);
            document.getElementById("rqstSelectedMember").classList.add("visible");
            setField("rqstMngrNm",  member.userNm);
            setField("rqstLoginId", member.userId);
            setField("rqstUserNo",  member.userNo);
        }

        function clearSelectedMember() {
            document.getElementById("rqstSelectedMember").classList.remove("visible");
            ["rqstMngrNm","rqstLoginId","rqstUserNo"].forEach(function(id){ setField(id, ""); });
        }

        /* ── 회원 검색 ── */
        function doMemberSearch() {
            var kw = document.getElementById("memberModalKeyword").value.trim();
            var resultBox = document.getElementById("memberSearchResult");
            resultBox.innerHTML = '<div class="member-empty">검색 중...</div>';

            fetch(contextPath + "/manager/employee/member/search?keyword=" + encodeURIComponent(kw), {
                headers: { "X-Requested-With":"XMLHttpRequest" }
            }).then(function(r){ return r.json(); })
                .then(function(data) {
                    var list = data.list || [];
                    if (list.length === 0) { resultBox.innerHTML = '<div class="member-empty">검색 결과가 없습니다.</div>'; return; }
                    resultBox.innerHTML = list.map(function(m) {
                        return '<div class="member-item" data-action="select-member"'
                            +' data-user-no="'+safe(m.userNo)+'" data-user-nm="'+safe(m.userNm)+'" data-user-id="'+safe(m.userId)+'">'
                            +'<div class="m-avatar">'+(m.userNm ? m.userNm.charAt(0) : "-")+'</div>'
                            +'<div><div class="m-name">'+safe(m.userNm)+'</div>'
                            +'<div class="m-sub">'+safe(m.userId)+" · "+safe(m.userTelno)+'</div></div>'
                            +'</div>';
                    }).join("");
                }).catch(function(){ resultBox.innerHTML = '<div class="member-empty">검색 중 오류가 발생했습니다.</div>'; });
        }

        /* ── 재직 직원 수정 저장 ── */
        function submitManagerUpdate() {
            if (!getField("accountTelno"))   { alert("연락처를 입력하세요."); return; }
            if (!getField("accountUserEml")) { alert("이메일을 입력하세요."); return; }
            if (!getField("accountDutyCd"))  { alert("직무를 선택하세요."); return; }
            postJson(contextPath + "/manager/employee/manager/update", {
                userNo:     getField("accountUserNo"),
                mgmtOfcNo:  getField("accountMgmtOfcNo"),
                mngrDutyCd: getField("accountDutyCd"),
                telno:      getField("accountTelno"),
                userEml:    getField("accountUserEml"),
                userYn:     getField("accountUserYn")
            }).then(function(r){
                if (r.success) { alert(r.message || "수정되었습니다."); reloadPage(); }
                else           { alert(r.message || "수정에 실패했습니다."); }
            }).catch(function(){ alert("처리 중 오류가 발생했습니다."); });
        }

        /* ── 요청 등록 저장 ── */
        function submitRequestInsert() {
            if (!getField("rqstUserNo"))          { alert("직원으로 등록할 회원을 선택하세요."); return; }
            if (!getField("rqstDutyCd"))          { alert("직무를 선택하세요."); return; }
            if (!getField("rqstMgmtOfcNoHidden")) { alert("소속 관리사무소 정보가 없습니다."); return; }
            postJson(contextPath + "/manager/employee/request/insert", {
                userNo:      getField("rqstUserNo"),
                rqstLoginId: getField("rqstLoginId"),
                rqstMngrNm:  getField("rqstMngrNm"),
                rqstDutyCd:  getField("rqstDutyCd"),
                mgmtOfcNo:   getField("rqstMgmtOfcNoHidden"),
                rmrkCn:      getField("rqstRmrkCn")
            }).then(function(r){
                if (r.success) { alert(r.message || "요청이 등록되었습니다."); reloadPage(); }
                else           { alert(r.message || "등록에 실패했습니다."); }
            }).catch(function(){ alert("처리 중 오류가 발생했습니다."); });
        }

        /* ── 요청 수정 저장 ── */
        function submitRequestUpdate() {
            if (!getField("rqstDutyCd")) { alert("직무를 선택하세요."); return; }
            postJson(contextPath + "/manager/employee/request/update", {
                rqstNo:     getField("rqstNo"),
                rqstDutyCd: getField("rqstDutyCd"),
                mgmtOfcNo:  getField("rqstMgmtOfcNoHidden"),
                rmrkCn:     getField("rqstRmrkCn")
            }).then(function(r){
                if (r.success) { alert(r.message || "수정되었습니다."); reloadPage(); }
                else           { alert(r.message || "수정에 실패했습니다."); }
            }).catch(function(){ alert("처리 중 오류가 발생했습니다."); });
        }

        /* ── 요청 취소 ── */
        function cancelRequest(rqstNo) {
            var row = requestRowData.find(function(r){ return String(r.rqstNo) === String(rqstNo); });
            if (!row || row.rqstSttsCd !== "WAIT") { alert("승인대기 상태의 요청만 취소할 수 있습니다."); return; }
            openConfirm("요청 취소", "선택한 계정 생성 요청을 취소하시겠습니까?", true, function() {
                postJson(contextPath + "/manager/employee/request/cancel", {
                    rqstNo: rqstNo,
                    rmrkCn: document.getElementById("confirmReason").value
                }).then(function(r){
                    if (r.success) { alert(r.message || "취소되었습니다."); reloadPage(); }
                    else           { alert(r.message || "취소에 실패했습니다."); }
                }).catch(function(){ alert("처리 중 오류가 발생했습니다."); });
            });
        }

        /* ── 확인 모달 ── */
        function openConfirm(title, message, showReason, callback) {
            document.getElementById("confirmTitle").textContent   = title;
            document.getElementById("confirmMessage").textContent = message;
            document.getElementById("confirmReason").value        = "";
            document.getElementById("confirmReasonBox").style.display = showReason ? "block" : "none";
            confirmCallback = callback;
            openModal("confirmModal");
        }

        /* ── 클릭 이벤트 위임 ── */
        page.addEventListener("click", function(e) {
            if (e.target.closest("[data-modal-close]")) { closeAllModals(); return; }

            var btn = e.target.closest("[data-action]");
            if (!btn) return;
            var action = btn.dataset.action;

            if (action === "open-request-modal") { openRequestInsert(); return; }
            if (action === "change-tab")         { changeTab(btn.dataset.tab); return; }
            if (action === "search-manager")     { applyManagerFilter(); return; }
            if (action === "reset-manager")      { resetManagerFilter(); return; }
            if (action === "search-request")     { applyRequestFilter(); return; }
            if (action === "reset-request")      { resetRequestFilter(); return; }
            if (action === "excel-download")     { excelDownload(); return; }

            if (action === "open-member-search") {
                document.getElementById("memberModalKeyword").value = document.getElementById("memberSearchKeyword").value.trim();
                openModal("memberSearchModal");
                doMemberSearch();
                return;
            }
            if (action === "do-member-search")  { doMemberSearch(); return; }
            if (action === "select-member") {
                showSelectedMember({ userNo:btn.dataset.userNo, userNm:btn.dataset.userNm, userId:btn.dataset.userId });
                closeModal("memberSearchModal");
                return;
            }
            if (action === "clear-member") { clearSelectedMember(); return; }

            if (action === "submit-manager-update") { submitManagerUpdate(); return; }
            if (action === "submit-request-insert") { submitRequestInsert(); return; }
            if (action === "submit-request-update") { submitRequestUpdate(); return; }

            if (action === "manager-detail") {
                var row = managerRowData.find(function(r){ return String(r.userNo) === btn.dataset.userNo; });
                if (row) openManagerDetail(row);
                return;
            }
            if (action === "manager-edit") {
                var row = managerRowData.find(function(r){ return String(r.userNo) === btn.dataset.userNo; });
                if (row) { closeModal("accountModal"); openManagerEdit(row); }
                return;
            }

            if (action === "request-detail") {
                var row = requestRowData.find(function(r){ return String(r.rqstNo) === btn.dataset.rqstNo; });
                if (row) openRequestDetail(row);
                return;
            }
            if (action === "request-edit") {
                var row = requestRowData.find(function(r){ return String(r.rqstNo) === btn.dataset.rqstNo; });
                if (!row || row.rqstSttsCd !== "WAIT") { alert("승인대기 상태의 요청만 수정할 수 있습니다."); return; }
                closeModal("requestModal");
                openRequestEdit(row);
                return;
            }
            if (action === "request-cancel") { cancelRequest(btn.dataset.rqstNo); return; }
        });

        document.getElementById("confirmActionBtn").addEventListener("click", function() {
            if (typeof confirmCallback === "function") confirmCallback();
        });

        /* ── 초기 실행 ── */
        createGrids();
        reloadData();
    }
</script>
</body>
</html>
