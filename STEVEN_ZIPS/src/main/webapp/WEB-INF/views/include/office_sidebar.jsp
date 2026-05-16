<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="uri" value="${pageContext.request.requestURI}" />
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="mgmtPath" value="${not empty mgmtOfcNo ? '/' : ''}${mgmtOfcNo}" />

<aside class="sidebar" id="sidebar">
    <div class="sidebar-logo">
        <div class="logo-mark">
            <div class="logo-icon">
                <span class="material-symbols-rounded">home_work</span>
            </div>
            <div class="logo-text">
                <h1>
                    <c:choose>
                        <c:when test="${not empty office.aptCmplexNm}">${office.aptCmplexNm}</c:when>
                        <c:otherwise>관리사무소</c:otherwise>
                    </c:choose>
                </h1>
                <p>관리사무소</p>
            </div>
        </div>
        <button type="button" class="collapse-btn" id="sidebarToggleBtn" title="사이드바 접기">
            <span class="material-symbols-rounded" style="font-size:18px;">left_panel_close</span>
        </button>
    </div>

    <nav class="sidebar-nav">
        <a href="${ctx}/manager/main${mgmtPath}"
           class="nav-item nav-dashboard ${fn:contains(uri, '/manager/main') ? 'active' : ''}">
            <span class="material-symbols-rounded nav-icon">dashboard</span>
            <span class="nav-text">대시보드</span>
        </a>

        <div class="section-divider"></div>

        <details class="nav-group" ${fn:contains(uri, '/manager/employee') or fn:contains(uri, '/manager/vacation') ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">badge</span>
                <span class="cat-label">인사·인력 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">직원 관리</span>

                    <a href="${ctx}/manager/employee/account${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/employee/account') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">직원 계정 관리</span>
                    </a>

                    <a href="${ctx}/manager/vacation${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/vacation') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">휴가 일정</span>
                    </a>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <details class="nav-group" ${fn:contains(uri, '/manager/resident') or fn:contains(uri, '/manager/visit/auto') ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">groups</span>
                <span class="cat-label">입주민 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <a href="${ctx}/manager/resident/list${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/resident/list') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주민 목록</span>
                    </a>
                    <a href="${ctx}/manager/resident/auth${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/resident/auth') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">회원 권한 변경</span>
                    </a>
                    <a href="${ctx}/manager/resident/moveList${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/resident/moveList') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주/퇴거 관리</span>
                    </a>
                    <a href="/manager/resident/auto/list/${mgmtOfcNo}" class="nav-item ${fn:contains(uri, '/manager/resident/auto') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">입주민 차량 관리</span>
                    </a>
                    <a href="${ctx}/manager/visit/auto${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/visit/auto') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">방문 차량 관리</span>
                    </a>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <%-- ═══════════════════════════════════════════════════════
             시설·공사 관리
        ════════════════════════════════════════════════════════ --%>
        <details class="nav-group"
        ${activeMenu eq 'facilityAsset'
                or activeMenu eq 'publicFacility'
                or activeMenu eq 'checkHistory'
                or activeMenu eq 'facilityPartner'
                or activeMenu eq 'facilityContract'
                ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">apartment</span>
                <span class="cat-label">시설·공사 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">

                    <span class="sub-group-label">시설 관리</span>
                    <a href="${ctx}/manager/facility/page${mgmtPath}" class="nav-item ${activeMenu eq 'facilityAsset' ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">시설자산 관리</span>
                    </a>
                    <a href="${ctx}/manager/publicFacility/page${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/publicFacility') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">편의시설 관리</span>
                    </a>

                    <%-- 공사·점검 --%>
                    <span class="sub-group-label">공사·점검</span>
                    <%--
                        checkHistory : 탭1 시설점검이력(FACILITY_CHECK_HSTRY)
                                       탭2 검침기록(METER_HSTRY) 포함
                        기존 meterReading 메뉴는 이 페이지 탭2로 흡수
                    --%>
                    <a href="${ctx}/manager/checkHistory${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/checkHistory') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">유지보수·점검 이력</span>
                    </a>
                    <a href="${ctx}/manager/facility/workCalendar${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/facility/workCalendar') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">공사·점검 일정</span>
                    </a>

                    <%-- 협력업체 --%>
                    <span class="sub-group-label">협력업체</span>
                    <a href="${ctx}/manager/facility/partnerList${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/facility/partnerList') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">협력업체 관리</span>
                    </a>
                    <a href="${ctx}/manager/facility/contractList${mgmtPath}"
                       class="nav-item ${fn:contains(uri, '/manager/facility/contractList') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">계약 관리</span>
                    </a>

                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <details class="nav-group" ${fn:contains(uri, '/manager/bill') or fn:contains(uri, '/manager/account/arrears') ? 'open="open"' : ''}>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">receipt_long</span>
                <span class="cat-label">회계·운영 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">관리비</span>
                    <a href="${ctx}/manager/bill/charge${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/charge') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">관리비 부과·연체</span>
                    </a>
                    <a href="${ctx}/manager/bill/issue${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/issue') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">고지서 등록</span>
                    </a>
                    <a href="${ctx}/manager/bill/item-summary${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/item-summary') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">관리비 항목·집계</span>
                    </a>

                    <span class="sub-group-label">지출·예산</span>
                    <a href="${ctx}/manager/bill/expense${mgmtPath}" class="nav-item ${fn:contains(uri, '/manager/bill/expense') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">지출 내역 관리</span>
                    </a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">예산 편성·조회</span>
                    </a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">지출 통계</span>
                    </a>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>

            <details class="nav-group" ${fn:contains(uri, '/mgmtOffice/mngrResidentNotice') ? 'open="open"' : ''}>
<%--        <details class="nav-group">--%>
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">campaign</span>
                <span class="cat-label">소통·행정 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">민원</span>
                    <a href="/manager/cvpl-list/${mgmtOfcNo}" class="nav-item" aria-disabled="true"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">민원 접수 현황</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">민원 처리</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">고위험 민원 알림</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">1:1 채팅 문의</span></a>

                    <span class="sub-group-label">게시판</span>
                    <a href="/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}" class="nav-item ${fn:contains(uri, '/mgmtOffice/mngrResidentNotice') ? 'active' : ''}">
<%--                    <a href="/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}" class="nav-item" aria-disabled="true">--%>
                        <span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">공지사항 관리</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">생활안내·운영정보</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">긴급 SMS 발송</span></a>

                    <span class="sub-group-label">투표·설문</span>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">투표 등록·관리</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">설문 등록·관리</span></a>
                </div>
            </div>
        </details>

        <div class="section-divider"></div>

        <details class="nav-group">
            <summary class="cat-btn">
                <span class="material-symbols-rounded nav-icon nav-icon-top">home_work</span>
                <span class="cat-label">단지 운영 관리</span>
                <span class="material-symbols-rounded cat-chevron">expand_more</span>
            </summary>
            <div class="submenu-wrap">
                <div class="submenu-inner">
                    <span class="sub-group-label">단지정보</span>
                    <a href="${ctx}/manager/complex/edit/${mgmtOfcNo}"
                       class="nav-item ${fn:contains(uri, '/manager/complex/edit') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">단지 기본정보 관리</span>
                    </a>
                    <a href="${ctx}/manager/complex/buildingLayOut/${mgmtOfcNo}" class="nav-item ${fn:contains(uri, '/manager/comlex/buildingLayOut') ? 'active' : ''}">
                        <span class="material-symbols-rounded nav-icon">chevron_right</span>
                        <span class="nav-text">단지 구조 관리</span>
                    </a>


                    <span class="sub-group-label">일정</span>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">단지 일정 캘린더</span></a>

                    <span class="sub-group-label">대여시설</span>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">대여시설 목록</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">예약 접수·확인</span></a>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">시설 이용 내역</span></a>

                    <span class="sub-group-label">차량</span>
                    <a href="javascript:void(0);" class="nav-item" aria-disabled="true" title="준비중"><span class="material-symbols-rounded nav-icon">chevron_right</span><span class="nav-text">등록 차량 목록</span></a>
                </div>
            </div>
        </details>
    </nav>

    <div class="admin-card">
        <div class="admin-avatar">
            <span class="material-symbols-rounded" style="color:#fff; font-size:16px;">person</span>
        </div>
        <div class="admin-info">
            <p><sec:authentication property="principal.member.userNm"/></p>
            <span>
                <c:choose>
                    <c:when test="${not empty office.mgmtOfcNm}">${office.mgmtOfcNm}</c:when>
                    <c:when test="${not empty office.aptCmplexNm}">${office.aptCmplexNm}</c:when>
                    <c:otherwise>관리사무소</c:otherwise>
                </c:choose>
            </span>
        </div>
        <a href="${ctx}/manager/main${mgmtPath}" class="icon-btn" title="메인">
            <span class="material-symbols-rounded">home</span>
        </a>
    </div>
</aside>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        var sidebar = document.getElementById("sidebar");
        var toggleBtn = document.getElementById("sidebarToggleBtn");
        var logoArea = document.querySelector(".sidebar-logo");
        var groups = Array.prototype.slice.call(document.querySelectorAll(".nav-group"));
        var currentPath = window.location.pathname;

        /* 현재 주소와 일치하는 메뉴만 active 처리 */
        document.querySelectorAll(".nav-item").forEach(function (item) {
            var href = item.getAttribute("href");

            item.classList.remove("active");

            /* 준비중 메뉴, # 메뉴는 주소 비교에서 제외 */
            if (!href || href === "#" || href.indexOf("javascript:") === 0) {
                return;
            }

            var linkPath;

            try {
                linkPath = new URL(item.href, window.location.origin).pathname;
            } catch (e) {
                return;
            }

            if (linkPath === currentPath) {
                item.classList.add("active");

                var activeGroup = item.closest(".nav-group");

                groups.forEach(function (group) {
                    group.removeAttribute("open");
                });

                if (activeGroup) {
                    activeGroup.setAttribute("open", "open");
                }
            }
        });

        /* 사이드바 접기 버튼 */
        if (toggleBtn && sidebar) {
            toggleBtn.addEventListener("click", function (e) {
                e.stopPropagation();
                sidebar.classList.toggle("collapsed");
            });
        }

        /* 로고 영역 클릭 시 사이드바 접기 */
        if (logoArea && sidebar) {
            logoArea.style.cursor = "pointer";
            logoArea.addEventListener("click", function (e) {
                if (!e.target.closest("#sidebarToggleBtn")) {
                    sidebar.classList.toggle("collapsed");
                }
            });
        }

        /* 카테고리 클릭 시 클릭한 그룹만 열기 */
        document.querySelectorAll(".nav-group > summary").forEach(function (summary) {
            summary.addEventListener("click", function (e) {
                e.preventDefault();

                var group = summary.closest(".nav-group");
                var isOpen = group.hasAttribute("open");

                groups.forEach(function (otherGroup) {
                    otherGroup.removeAttribute("open");
                });

                if (!isOpen) {
                    group.setAttribute("open", "open");
                }
            });
        });

        /* 메뉴 클릭 시 active 하나만 유지 */
        document.querySelectorAll(".nav-item").forEach(function (item) {
            item.addEventListener("click", function () {
                if (item.getAttribute("aria-disabled") === "true") {
                    return;
                }

                document.querySelectorAll(".nav-item").forEach(function (otherItem) {
                    otherItem.classList.remove("active");
                });

                item.classList.add("active");

                var group = item.closest(".nav-group");

                groups.forEach(function (otherGroup) {
                    if (otherGroup !== group) {
                        otherGroup.removeAttribute("open");
                    }
                });

                if (group) {
                    group.setAttribute("open", "open");
                }
            });
        });
    });
</script>
