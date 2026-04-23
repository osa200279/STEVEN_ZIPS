<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<header class="topbar">

    <%-- ── 브레드크럼 ── --%>
    <div class="breadcrumb">
        <span class="material-symbols-rounded" style="font-size:14px;">home</span>
        <span style="margin:0 4px;">/</span>
        <span id="bc-parent">인사·인력 관리</span>
        <span style="margin:0 4px;">/</span>
        <span class="bc-current" id="bc-current">직원 계정 관리</span>
    </div>

    <%-- ── 우측 액션 영역 ── --%>
    <div class="topbar-actions">

        <%-- 시계 --%>
        <span class="topbar-clock" id="currentTime"></span>

        <%-- 알림 --%>
        <button type="button" class="topbar-icon-btn" title="알림">
            <span class="material-symbols-rounded">notifications</span>
            <span class="dot"></span>
        </button>

        <%-- 설정 --%>
        <button type="button" class="topbar-icon-btn" title="설정">
            <span class="material-symbols-rounded">settings</span>
        </button>

        <%-- 사용자 정보 --%>
        <div class="topbar-user">
            <div class="topbar-user-avatar">
                <span class="material-symbols-rounded">person</span>
            </div>
            <div class="topbar-user-info">
                <p>관리소장님</p>
                <span>푸르지오 관리사무소</span>
            </div>
        </div>

    </div>
</header>

<%-- ── 시계 JS ── --%>
<script>
document.addEventListener("DOMContentLoaded", function () {

    function renderClock() {
        var now  = new Date();
        var pad  = function (v) { return String(v).padStart(2, "0"); };
        var clock = document.getElementById("currentTime");
        if (!clock) return;
        clock.textContent =
            now.getFullYear() + "." +
            pad(now.getMonth() + 1) + "." +
            pad(now.getDate()) + " " +
            pad(now.getHours()) + ":" +
            pad(now.getMinutes());
    }

    renderClock();
    setInterval(renderClock, 60000);

});
</script>
