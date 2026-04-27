<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<aside class="sidebar" id="sidebar">

    <%-- ── 로고 ── --%>
    <div class="sidebar-logo">
        <div class="logo-mark">
            <div class="logo-icon">
                <span class="material-symbols-rounded">home_work</span>
            </div>
            <div class="logo-text">
                <h1>우리집맵핑</h1>
                <p>관리사무소 시스템</p>
            </div>
        </div>
        <button type="button" class="collapse-btn" id="sidebarToggleBtn" title="사이드바 접기">
            <span class="material-symbols-rounded" style="font-size:18px;">left_panel_close</span>
        </button>
    </div>

    <%-- ── 네비게이션 ── --%>
    <nav class="sidebar-nav">

        <%-- 인사·인력 관리 --%>
        <div class="nav-group open">
            <button type="button" class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">badge</span>
                <span class="cat-label">인사·인력 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </button>
            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <span class="sub-group-label">직원 관리</span>

                    <a href="#" class="nav-item active"
                       data-parent="인사·인력 관리"
                       data-title="직원 계정 관리"
                       data-url="${pageContext.request.contextPath}/manager/employee/account">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">직원 계정 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="인사·인력 관리"
                       data-title="휴가 일정"
                       data-url="${pageContext.request.contextPath}/manager/vacation">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">휴가 일정</span>
                    </a>

                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <%-- 입주민 관리 --%>
        <div class="nav-group">
            <button type="button" class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">groups</span>
                <span class="cat-label">입주민 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </button>
            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <a href="#" class="nav-item"
                       data-parent="입주민 관리"
                       data-title="입주민 목록"
                       data-url="${pageContext.request.contextPath}/manager/resident/list">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주민 목록</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="입주민 관리"
                       data-title="권한 신청 처리"
                       data-url="${pageContext.request.contextPath}/manager/resident/auth">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">권한 신청 처리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="입주민 관리"
                       data-title="입주/퇴거 관리"
                       data-url="${pageContext.request.contextPath}/manager/resident/moveList">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주/퇴거 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="입주민 관리"
                       data-title="입주민 차량 관리"
                       data-url="${pageContext.request.contextPath}/manager/resident/auto">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주민 차량 관리</span>
                    </a>

                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <%-- 시설·공사 관리 --%>
        <div class="nav-group">
            <button type="button" class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">apartment</span>
                <span class="cat-label">시설·공사 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </button>
            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <span class="sub-group-label">시설 관리</span>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="시설 자산 관리"
                       data-url="${pageContext.request.contextPath}/manager/facilityList">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">시설 자산 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="공용 시설 관리"
                       data-url="${pageContext.request.contextPath}/manager/publicFacilityList">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">공용 시설 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="검침 관리"
                       data-url="${pageContext.request.contextPath}/manager/meterReading">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">검침 관리</span>
                    </a>

                    <span class="sub-group-label">공사·점검</span>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="유지보수·점검 이력"
                       data-url="${pageContext.request.contextPath}/manager/checkHistory">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">유지보수·점검 이력</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="공사·점검 일정"
                       data-url="${pageContext.request.contextPath}/manager/facility/workCalendar">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">공사·점검 일정</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="작업 진행 현황"
                       data-url="${pageContext.request.contextPath}/office/facility/workStatusFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">작업 진행 현황</span>
                    </a>

                    <span class="sub-group-label">협력업체</span>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="업체 조회·등록"
                       data-url="${pageContext.request.contextPath}/office/partner/listFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">업체 조회·등록</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="계약 만료 관리"
                       data-url="${pageContext.request.contextPath}/office/partner/contractFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">계약 만료 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="시설·공사 관리"
                       data-title="참여 이력"
                       data-url="${pageContext.request.contextPath}/office/partner/historyFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">참여 이력</span>
                    </a>

                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <%-- 회계·운영 관리 --%>
        <div class="nav-group">
            <button type="button" class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">receipt_long</span>
                <span class="cat-label">회계·운영 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </button>
            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <span class="sub-group-label">관리비</span>

                    <a href="#" class="nav-item"
                       data-parent="회계·운영 관리"
                       data-title="관리비 항목·집계"
                       data-url="${pageContext.request.contextPath}/office/account/feeFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">관리비 항목·집계</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="회계·운영 관리"
                       data-title="세대별 부과 내역"
                       data-url="${pageContext.request.contextPath}/office/account/chargeFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">세대별 부과 내역</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="회계·운영 관리"
                       data-title="연체 내역 관리"
                       data-url="${pageContext.request.contextPath}/office/account/arrearsFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">연체 내역 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="회계·운영 관리"
                       data-title="납부 고지서 등록"
                       data-url="${pageContext.request.contextPath}/office/account/billFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">납부 고지서 등록</span>
                    </a>

                    <span class="sub-group-label">지출·예산</span>

                    <a href="#" class="nav-item"
                       data-parent="회계·운영 관리"
                       data-title="지출 내역 관리"
                       data-url="${pageContext.request.contextPath}/office/budget/expenseFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">지출 내역 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="회계·운영 관리"
                       data-title="예산 편성·조회"
                       data-url="${pageContext.request.contextPath}/office/budget/planFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">예산 편성·조회</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="회계·운영 관리"
                       data-title="지출 통계"
                       data-url="${pageContext.request.contextPath}/office/budget/statsFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">지출 통계</span>
                    </a>

                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <%-- 소통·행정 관리 --%>
        <div class="nav-group">
            <button type="button" class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">campaign</span>
                <span class="cat-label">소통·행정 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </button>
            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <span class="sub-group-label">민원</span>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="민원 접수 현황"
                       data-url="${pageContext.request.contextPath}/office/civil/listFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">민원 접수 현황</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="민원 처리"
                       data-url="${pageContext.request.contextPath}/office/civil/processFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">민원 처리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="고위험 민원 알림"
                       data-url="${pageContext.request.contextPath}/office/civil/alertFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">고위험 민원 알림</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="1:1 채팅 문의"
                       data-url="${pageContext.request.contextPath}/office/civil/chatFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">1:1 채팅 문의</span>
                    </a>

                    <span class="sub-group-label">게시판</span>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="공지사항 관리"
                       data-url="${pageContext.request.contextPath}/office/board/noticeFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">공지사항 관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="생활안내·운영정보"
                       data-url="${pageContext.request.contextPath}/office/board/infoFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">생활안내·운영정보</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="긴급 SMS 발송"
                       data-url="${pageContext.request.contextPath}/office/board/smsFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">긴급 SMS 발송</span>
                    </a>

                    <span class="sub-group-label">투표·설문</span>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="투표 등록·관리"
                       data-url="${pageContext.request.contextPath}/office/vote/manageFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">투표 등록·관리</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="소통·행정 관리"
                       data-title="설문 등록·관리"
                       data-url="${pageContext.request.contextPath}/office/survey/manageFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">설문 등록·관리</span>
                    </a>

                </div>
            </div>
        </div>

        <div class="section-divider"></div>

        <%-- 단지 운영 관리 --%>
        <div class="nav-group">
            <button type="button" class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">home_work</span>
                <span class="cat-label">단지 운영 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </button>
            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <span class="sub-group-label">일정</span>

                    <a href="#" class="nav-item"
                       data-parent="단지 운영 관리"
                       data-title="단지 일정 캘린더"
                       data-url="${pageContext.request.contextPath}/office/complex/calendarFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">단지 일정 캘린더</span>
                    </a>

                    <span class="sub-group-label">시설 대여</span>

                    <a href="#" class="nav-item"
                       data-parent="단지 운영 관리"
                       data-title="대여 시설 목록"
                       data-url="${pageContext.request.contextPath}/office/rental/listFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">대여 시설 목록</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="단지 운영 관리"
                       data-title="예약 접수·승인"
                       data-url="${pageContext.request.contextPath}/office/rental/approveFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">예약 접수·승인</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="단지 운영 관리"
                       data-title="시설 이용 내역"
                       data-url="${pageContext.request.contextPath}/office/rental/historyFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">시설 이용 내역</span>
                    </a>

                    <span class="sub-group-label">차량</span>

                    <a href="#" class="nav-item"
                       data-parent="단지 운영 관리"
                       data-title="등록 차량 목록"
                       data-url="${pageContext.request.contextPath}/office/car/listFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">등록 차량 목록</span>
                    </a>

                    <a href="#" class="nav-item"
                       data-parent="단지 운영 관리"
                       data-title="방문 차량 승인"
                       data-url="${pageContext.request.contextPath}/office/car/visitorFragment">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">방문 차량 승인</span>
                    </a>

                </div>
            </div>
        </div>

    </nav>

    <%-- ── 하단 관리자 카드 ── --%>
    <div class="admin-card">
        <div class="admin-avatar">
            <span class="material-symbols-rounded" style="color:#fff; font-size:16px;">person</span>
        </div>
        <div class="admin-info">
            <p>관리소장님</p>
            <span>푸르지오 관리사무소</span>
        </div>
        <button type="button" class="icon-btn" title="로그아웃">
            <span class="material-symbols-rounded">logout</span>
        </button>
    </div>

</aside>

<%-- ── 사이드바 JS ── --%>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        var sidebar   = document.getElementById("sidebar");
        var toggleBtn = document.getElementById("sidebarToggleBtn");
        var logoArea  = document.querySelector(".sidebar-logo");

        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener("click", function () {
                sidebar.classList.toggle("collapsed");
            });
        }

        if (logoArea && sidebar) {
            logoArea.style.cursor = "pointer";
            logoArea.addEventListener("click", function (e) {
                if (!e.target.closest("#sidebarToggleBtn")) {
                    sidebar.classList.toggle("collapsed");
                }
            });
        }

        document.querySelectorAll(".cat-btn").forEach(function (btn) {
            btn.addEventListener("click", function () {
                var group = btn.closest(".nav-group");
                if (group) group.classList.toggle("open");
            });
        });

        document.querySelectorAll(".nav-item").forEach(function (item) {
            item.addEventListener("click", function (e) {
                e.preventDefault();

                document.querySelectorAll(".nav-item").forEach(function (el) {
                    el.classList.remove("active");
                });
                item.classList.add("active");

                var parent  = item.getAttribute("data-parent");
                var title   = item.getAttribute("data-title");
                var url     = item.getAttribute("data-url");

                var bcParent  = document.getElementById("bc-parent");
                var bcCurrent = document.getElementById("bc-current");
                if (bcParent)  bcParent.textContent  = parent;
                if (bcCurrent) bcCurrent.textContent = title;

                if (typeof loadContent === "function" && url) {
                    loadContent(url, title);
                }
            });
        });

    });
</script>
