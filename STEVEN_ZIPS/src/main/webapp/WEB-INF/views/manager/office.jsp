<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우리집맵핑 · 관리사무소</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <%-- 관리사무소 셸 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">

    <%-- 관리사무소 화면 공통 CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <%-- AG Grid CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-grid.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/ag-theme-alpine.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-agGrid.css">
</head>
<body>

<div class="app-wrapper">

    <%-- 사이드바 --%>
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%-- 헤더 --%>
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <%-- fragment 주입 영역 --%>
        <main class="main-content">
            <div id="contentArea">
                <div class="content-placeholder">
                    <h2>관리사무소</h2>
                    <p>좌측 메뉴를 클릭하면 해당 화면이 로드됩니다.</p>
                </div>
            </div>
        </main>

    </div>
</div>

<%-- 공통 라이브러리 JS --%>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js"></script>
<script src="${pageContext.request.contextPath}/js/common/sweetalert2.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/ag-grid-community.min.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/manager-common.js"></script>
<script src="${pageContext.request.contextPath}/js/manager/manager-agGrid.js"></script>

<script>
    var currentContentUrl = "";
    var contentRequestSeq = 0;

    function loadScriptElement(script) {
        return new Promise(function (resolve, reject) {
            var executableScript = document.createElement("script");

            Array.prototype.forEach.call(script.attributes, function (attr) {
                executableScript.setAttribute(attr.name, attr.value);
            });

            if (script.src) {
                executableScript.onload = resolve;
                executableScript.onerror = reject;
                executableScript.async = false;
            } else {
                executableScript.text = script.text || script.textContent || script.innerHTML || "";
            }

            script.parentNode.replaceChild(executableScript, script);

            if (!script.src) {
                resolve();
            }
        });
    }

    async function runFragmentScripts(container) {
        var scripts = Array.prototype.slice.call(container.querySelectorAll("script"));

        for (var i = 0; i < scripts.length; i++) {
            await loadScriptElement(scripts[i]);
        }
    }

    function runFragmentInit() {
        if (typeof window.initMngrAccountPage === "function") {
            window.initMngrAccountPage();
        }

        if (typeof window.initVacationPage === "function") {
            window.initVacationPage();
        }
    }

    function loadContent(url, title, option) {
        var contentArea = document.getElementById("contentArea");
        if (!contentArea) return;

        option = option || {};
        var forceReload = option.force === true;

        if (!forceReload && url === currentContentUrl) return;

        var requestSeq = ++contentRequestSeq;
        var hasLoadedContent = contentArea.children.length > 0 &&
            !contentArea.querySelector(".content-placeholder");

        if (!hasLoadedContent) {
            contentArea.innerHTML =
                '<div class="content-loading">' +
                '  <span class="material-symbols-rounded">progress_activity</span>' +
                '  <p>화면을 불러오는 중입니다.</p>' +
                '</div>';
        }

        fetch(url, {
            method: "GET",
            headers: {
                "X-Requested-With": "XMLHttpRequest"
            }
        })
            .then(function (response) {
                if (!response.ok) throw new Error("HTTP " + response.status);
                return response.text();
            })
            .then(async function (html) {
                if (requestSeq !== contentRequestSeq) return;

                currentContentUrl = url;
                contentArea.innerHTML = html;

                await runFragmentScripts(contentArea);
                runFragmentInit();
            })
            .catch(function (error) {
                if (requestSeq !== contentRequestSeq) return;

                contentArea.innerHTML =
                    '<div class="content-placeholder">' +
                    '  <h2>' + (title || "화면 로드 실패") + '</h2>' +
                    '  <p>화면을 불러오지 못했습니다.</p>' +
                    '</div>';

                console.error(error);
            });
    }

    window.loadContent = loadContent;

    window.reloadFragment = function (url, title) {
        loadContent(url, title || "", { force: true });
    };
</script>

</body>
</html>