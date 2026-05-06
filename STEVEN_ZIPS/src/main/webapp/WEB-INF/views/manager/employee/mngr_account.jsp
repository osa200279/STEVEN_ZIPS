<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리사무소</title>
    <%-- Spring Security CSRF 토큰 메타 태그 (POST 요청 시 위조 방지용) --%>
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
        /* 필터 영역 레이아웃 */
        #mngrAccountPage .filter-card        { justify-content: space-between; }
        #mngrAccountPage .filter-left,
        #mngrAccountPage .filter-right       { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; }
        #mngrAccountPage .filter-right       { gap: 8px; margin-left: auto; }
        #mngrAccountPage .filter-select      { width: 150px; }
        #mngrAccountPage .filter-keyword     { width: 300px; }

        /* 그리드 영역 */
        #mngrAccountPage .manager-grid-wrap  { width: 100%; }
        #mngrAccountPage .manager-ag-grid    { width: 100%; }
        #mngrAccountPage .grid-actions       { display: flex; justify-content: center; align-items: center; gap: 6px; flex-wrap: nowrap; }
        #mngrAccountPage .grid-actions .btn  { flex-shrink: 0; }
        #mngrAccountPage .confirm-message    { font-size: 13px; color: var(--text-secondary); margin-bottom: 14px; }

        /* 회원 검색 모달 */
        #memberSearchModal .member-list      { max-height: 300px; overflow-y: auto; margin-top: 12px; }
        #memberSearchModal .member-item {
            display: flex; align-items: center; gap: 12px;
            padding: 10px 14px; border-radius: 8px; cursor: pointer;
            border: 1px solid var(--border); margin-bottom: 6px; transition: .15s;
        }
        #memberSearchModal .member-item:hover  { background: #f0f7f2; border-color: #2e5c38; }
        #memberSearchModal .member-item .m-avatar {
            width: 34px; height: 34px; border-radius: 50%;
            background: #e8f0ea; color: #2e5c38;
            display: flex; align-items: center; justify-content: center;
            font-size: 14px; font-weight: 700; flex-shrink: 0;
        }
        #memberSearchModal .member-item .m-name { font-size: 13px; font-weight: 700; }
        #memberSearchModal .member-item .m-sub  { font-size: 11px; color: var(--text-tertiary); }
        #memberSearchModal .member-empty        { text-align: center; padding: 24px; font-size: 13px; color: var(--text-tertiary); }

        #mngrAccountPage .btn.is-disabled {
            opacity: 1;
            color: #9ca3af;
            background: #f3f4f6;
            border: 1px solid #d1d5db;
            cursor: not-allowed;
            box-shadow: none;
        }

        #mngrAccountPage .btn.is-disabled:hover {
            background: #eceff3;
            border-color: #c5cad3;
            color: #7b8491;
        }

        #mngrAccountPage .btn:disabled {
            opacity: 1;
            color: #9ca3af;
            background: #f3f4f6;
            border: 1px solid #d1d5db;
            cursor: not-allowed;
            box-shadow: none;
        }

        /* disabled hover */
        #mngrAccountPage .btn:disabled:hover {
            background: #eceff3;
            border-color: #c5cad3;
            color: #7b8491;
        }

        /* 비활성 버튼 안 아이콘도 같이 회색 처리 */
        #mngrAccountPage .btn:disabled .material-symbols-rounded {
            color: #9ca3af;
        }

        /* 선택된 회원 표시 박스 (회원 선택 시 visible 클래스 추가로 표시) */
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
        #rqstSelectedMember .sel-info  { flex: 1; }
        #rqstSelectedMember .sel-name  { font-size: 13px; font-weight: 700; }
        #rqstSelectedMember .sel-sub   { font-size: 11px; color: var(--text-tertiary); }
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

                <%-- 페이지 헤더 영역 --%>
                <div class="page-header">
                    <div class="page-title-block">
                        <h2>직원 계정 관리</h2>
                        <p>
                            <c:out value="${aptCmplexNm}"/> · <c:out value="${mgmtOfcNm}"/>
                        </p>
                    </div>
                    <div class="page-actions">
                        <%-- data-action: JS 클릭 이벤트 위임의 구분자 역할 --%>
                            <%-- ADMIN은 조회 전용이므로 계정 생성 요청 비활성화 --%>
                            <c:if test="${isAdmin ne true}">
                                <button type="button" class="btn btn-primary" data-action="open-request-modal">
                                    <span class="material-symbols-rounded">person_add</span>계정 생성 요청
                                </button>
                            </c:if>
                    </div>
                </div>

                <%-- 현황 카드 영역 (숫자는 JS loadEmployeeList / loadRequestList 호출 후 갱신) --%>
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

                <%-- 탭 버튼 영역 --%>
                <div class="tab-bar">
                    <button type="button" class="tab-btn active" data-action="change-tab" data-tab="manager">
                        <span class="material-symbols-rounded">groups</span>재직 직원
                    </button>
                    <button type="button" class="tab-btn" data-action="change-tab" data-tab="request">
                        <span class="material-symbols-rounded">assignment_ind</span>생성 요청
                    </button>
                </div>

                <%-- ══════════════════════════════════════════
                     탭 패널 1: 재직 직원
                     ══════════════════════════════════════════ --%>
                <div class="tab-panel active" id="managerTabPanel">
                    <div class="panel">
                        <div class="panel-header">
                            <div class="panel-title"><span class="material-symbols-rounded">manage_accounts</span>재직 직원 목록</div>
                        </div>

                        <%-- 검색/필터 영역 --%>
                        <div class="filter-card">
                            <div class="filter-left">
                                <%-- 직무 필터 셀렉트박스
                                     ※ 직무 추가 시 JS의 DUTY_TEXT, XML 쿼리의 HEAD 조건도 함께 수정 대상 --%>
                                <select class="form-select filter-select" id="managerDutyFilter">
                                    <option value="">전체 직무</option>
                                    <option value="ACNT">회계담당</option>
                                    <option value="ADM">행정담당</option>
                                    <option value="FAC">시설담당</option>
                                </select>
                            </div>
                            <div class="filter-right">
                                <div class="search-wrap filter-keyword">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="managerKeyword" placeholder="이름, 아이디, 연락처 검색">
                                </div>
                                <button type="button" class="btn btn-primary"   data-action="search-manager">검색</button>
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
                                <span class="mini-badge inactive">직무/검색 조건으로 조회할 수 있습니다.</span>
                            </div>
                        </div>

                        <%-- AG Grid 렌더링 대상 div (JS createGrids()에서 그리드를 이 안에 그림) --%>
                        <div class="manager-grid-wrap">
                            <div id="managerGrid" class="ag-theme-alpine manager-ag-grid grid-size-auto"></div>
                        </div>
                    </div>
                </div>

                <%-- ══════════════════════════════════════════
                     탭 패널 2: 생성 요청
                     ══════════════════════════════════════════ --%>
                <div class="tab-panel" id="requestTabPanel">
                    <div class="panel">
                        <div class="panel-header">
                            <div class="panel-title"><span class="material-symbols-rounded">assignment</span>계정 생성 요청 목록</div>
                            <%-- ADMIN은 조회 전용이므로 요청 등록 비활성화 --%>
                            <c:if test="${isAdmin ne true}">
                                <button type="button" class="btn btn-primary btn-sm" data-action="open-request-modal">
                                    <span class="material-symbols-rounded">add</span>요청 등록
                                </button>
                            </c:if>
                        </div>

                        <%-- 검색/필터 영역 --%>
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
                                    <option value="OK">승인완료</option>
                                    <option value="RJCT">반려</option>
                                    <option value="CNL">신청취소</option>
                                </select>
                            </div>
                            <div class="filter-right">
                                <div class="search-wrap filter-keyword">
                                    <span class="material-symbols-rounded">search</span>
                                    <input type="text" class="form-input" id="requestKeyword" placeholder="이름, 아이디 검색">
                                </div>
                                <button type="button" class="btn btn-primary"   data-action="search-request">검색</button>
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


                <%-- ══════════════════════════════════════════
                     모달 1: 재직 직원 상세 / 직무 수정
                     - 상세 모드: 전체 필드 읽기 전용
                     - 수정 모드: 직무(accountDutyCd)만 활성화
                     ══════════════════════════════════════════ --%>
                <div class="modal-overlay" id="accountModal">
                    <div class="modal modal-lg">
                        <div class="modal-header">
                            <h3 class="modal-title" id="accountModalTitle">재직 직원 상세</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="accountForm">
                            <%-- 숨김 필드: 화면에 보이지 않지만 서버 전송 시 필요한 값 보관용 --%>
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
                                </div>
                            </div>
                            <%-- 모달 하단 버튼 영역: 상세/수정 모드에 따라 JS에서 동적으로 채움 --%>
                            <div class="modal-footer" id="accountModalFooter"></div>
                        </form>
                    </div>
                </div>


                <%-- ══════════════════════════════════════════
                     모달 2: 계정 생성 요청 등록 / 수정 / 상세
                     - 등록 모드: 회원 검색 후 직무 선택
                     - 수정 모드: 직무/비고만 수정 가능
                     - 상세 모드: 전체 읽기 전용
                     ══════════════════════════════════════════ --%>
                <div class="modal-overlay" id="requestModal">
                    <div class="modal modal-lg">
                        <div class="modal-header">
                            <h3 class="modal-title" id="requestModalTitle">계정 생성 요청 등록</h3>
                            <button type="button" class="modal-close" data-modal-close>
                                <span class="material-symbols-rounded">close</span>
                            </button>
                        </div>
                        <form id="requestForm">
                            <%-- 숨김 필드: 서버 전송 시 필요한 값 보관용 --%>
                            <input type="hidden" id="rqstNo">
                            <input type="hidden" id="rqstUserNo">
                            <input type="hidden" id="rqstMgmtOfcNoHidden">
                            <div class="modal-body">

                                <%-- 요청 기준 정보 섹션 --%>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">apartment</span>요청 기준 정보
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">관리사무소</label>
                                            <input type="text" class="form-input" id="requestMgmtOfcNoText" readonly>
                                        </div>
                                        <div class="form-field">
                                            <label class="field-label">단지</label>
                                            <input type="text" class="form-input" id="requestAptCmplexNmText" readonly>
                                        </div>
                                    </div>
                                    <div class="form-row cols-1">
                                        <div class="form-field">
                                            <label class="field-label">요청자</label>
                                            <input type="text" class="form-input" id="requestLoginUserNmText" readonly>
                                        </div>
                                    </div>
                                </div>

                                <%-- 회원 검색 섹션: 직원으로 등록할 기존 회원 선택 영역 --%>
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
                                    <%-- 선택된 회원 표시 박스: JS showSelectedMember() 호출 시 visible 클래스 추가로 표시 --%>
                                    <div id="rqstSelectedMember">
                                        <div class="sel-avatar" id="selMemberAvatar"></div>
                                        <div class="sel-info">
                                            <div class="sel-name" id="selMemberName"></div>
                                            <div class="sel-sub"  id="selMemberSub"></div>
                                        </div>
                                        <span class="material-symbols-rounded sel-clear" data-action="clear-member">close</span>
                                    </div>
                                </div>

                                <%-- 요청 정보 섹션: 선택된 회원 정보 자동 입력 + 직무 직접 선택 영역 --%>
                                <div class="form-section">
                                    <div class="form-section-title">
                                        <span class="material-symbols-rounded">assignment_ind</span>요청 정보
                                    </div>
                                    <div class="form-row cols-2">
                                        <div class="form-field">
                                            <label class="field-label">직원명</label>
                                            <%-- 회원 선택 시 JS에서 자동 입력되는 필드 --%>
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

                                <%-- 요청 상태 섹션: 상세/수정 모드일 때만 JS에서 display를 열어 표시 --%>
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
                                    <%-- 반려(RJCT) 상태일 때만 JS에서 display를 열어 표시 --%>
                                    <div class="form-row cols-1" id="rqstRjctBox" style="display:none;">
                                        <div class="form-field">
                                            <label class="field-label">반려 사유</label>
                                            <textarea class="form-textarea" id="rqstRjctRsnCn" readonly></textarea>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <%-- 모달 하단 버튼 영역: 등록/수정/상세 모드에 따라 JS에서 동적으로 채움 --%>
                            <div class="modal-footer" id="requestModalFooter"></div>
                        </form>
                    </div>
                </div>


                <%-- ══════════════════════════════════════════
                     모달 3: 회원 검색 팝업
                     - 요청 모달의 [검색] 버튼 클릭 시 열리는 팝업
                     - 항목 클릭 시 요청 폼에 회원 정보 자동 입력
                     ══════════════════════════════════════════ --%>
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
                            <%-- 검색 결과 목록 영역: JS doMemberSearch()에서 동적으로 채움 --%>
                            <div class="member-list" id="memberSearchResult">
                                <div class="member-empty">검색 중...</div>
                            </div>
                        </div>
                    </div>
                </div>


                <%-- ══════════════════════════════════════════
                     모달 4: 확인 모달
                     - 취소 등 위험 동작 전 한 번 더 확인용 팝업
                     - [확인] 버튼 클릭 시 JS confirmCallback 실행
                     ══════════════════════════════════════════ --%>
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
                            <%-- 사유 입력란: 취소 동작 시에만 JS에서 display를 열어 표시 --%>
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

<%-- 엑셀 다운로드 라이브러리 (SheetJS) --%>
<script src="https://cdn.sheetjs.com/xlsx-latest/package/dist/xlsx.full.min.js"></script>

<script>
    window.mngrAccountConfig = {
        contextPath: "${pageContext.request.contextPath}",
        mgmtOfcNo: "${mgmtOfcNo}",
        mgmtOfcNm: "${mgmtOfcNm}",
        aptCmplexNm: "${aptCmplexNm}",
        loginUserNm: "${loginUserNm}",
        isAdmin: "${isAdmin}" === "true"

    };
</script>

<script src="${pageContext.request.contextPath}/js/manager/mngr-account-grid.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/mngr-account.js"></script>

</body>
</html>
