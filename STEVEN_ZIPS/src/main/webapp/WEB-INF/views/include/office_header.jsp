<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<header class="topbar">
    <div class="breadcrumb">
        <span class="material-symbols-rounded" style="font-size:14px;">dashboard</span>
        <span class="bc-current" style="margin-left:8px;">관리사무소</span>
    </div>

    <div class="topbar-actions">
        <span class="topbar-clock" id="currentTime"></span>

        <button type="button" class="topbar-icon-btn" title="알림">
            <span class="material-symbols-rounded">notifications</span>
            <span class="dot"></span>
        </button>

        <button type="button" class="topbar-icon-btn" title="설정">
            <span class="material-symbols-rounded">settings</span>
        </button>

        <div class="topbar-user">
            <div class="topbar-user-avatar">
                <span class="material-symbols-rounded">person</span>
            </div>
            <div class="topbar-user-info">
                <p>관리사무소</p>
                <span>업무 화면</span>
            </div>
        </div>
    </div>
</header>

<script>
document.addEventListener("DOMContentLoaded", function () {
    function renderClock() {
        var now = new Date();
        var pad = function (value) { return String(value).padStart(2, "0"); };
        var clock = document.getElementById("currentTime");

        if (!clock) {
            return;
        }

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
