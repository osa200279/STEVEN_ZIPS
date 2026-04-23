<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>우리집맵핑 · 관리사무소</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
</head>
<body>

<div class="app-wrapper">

    <%-- 사이드바 --%>
    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%-- 헤더 --%>
        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <%-- 바디: fragment가 이 안으로 주입됩니다 --%>
        <main class="main-content">
            <div id="contentArea">
                <div class="content-placeholder">
                    <h2>직원 계정 관리</h2>
                    <p>좌측 메뉴를 클릭하면 해당 화면이 로드됩니다.</p>
                </div>
            </div>
        </main>

    </div>
</div>

<script>
    var currentContentUrl = "";
    var contentRequestSeq = 0;

    function runFragmentScripts(container) {
        var scripts = container.querySelectorAll("script");

        scripts.forEach(function (script) {
            var executableScript = document.createElement("script");

            Array.prototype.forEach.call(script.attributes, function (attr) {
                executableScript.setAttribute(attr.name, attr.value);
            });

            executableScript.text = script.text || script.textContent || script.innerHTML || "";
            script.parentNode.replaceChild(executableScript, script);
        });
    }

    function loadContent(url, title) {
        var contentArea = document.getElementById("contentArea");
        if (!contentArea) return;
        if (url === currentContentUrl) return;

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
            headers: { "X-Requested-With": "XMLHttpRequest" }
        })
            .then(function (response) {
                if (!response.ok) throw new Error("HTTP " + response.status);
                return response.text();
            })
            .then(function (html) {
                if (requestSeq !== contentRequestSeq) return;
                currentContentUrl = url;
                contentArea.innerHTML = html;
                runFragmentScripts(contentArea);


                fetch(url, {
                    method: "GET",
                    headers: { "X-Requested-With": "XMLHttpRequest" }
                })
                    .then(function (response) {
                        if (!response.ok) throw new Error("HTTP " + response.status);
                        return response.text();
                    })
                    .then(function (html) {
                        if (requestSeq !== contentRequestSeq) return;

                        currentContentUrl = url;
                        contentArea.innerHTML = html;
                        runFragmentScripts(contentArea);

                        if (typeof window.initVacationPage === "function") {
                            window.initVacationPage();
                        }
                    })
                    .catch(function (error) {
                        if (requestSeq !== contentRequestSeq) return;
                        contentArea.innerHTML = '';
                    });
            })
            .catch(function (error) {
                if (requestSeq !== contentRequestSeq) return;
                contentArea.innerHTML =
                    '<div class="content-placeholder">' +
                    '  <h2>' + title + '</h2>' +
                    '  <p>아직 연결되지 않은 화면입니다.</p>' +
                    '</div>';
                console.error(error);
            });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.20/index.global.min.js"></script>
</body>
</html>
