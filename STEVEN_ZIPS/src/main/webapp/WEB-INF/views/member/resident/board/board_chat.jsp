<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>그룹채팅방 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <style>
        .fake-input, .fake-select, .fake-textarea {
            width: 100%;
            border: 1px solid #d8ddd4;
            background: #fff;
            border-radius: 10px;
            padding: 11px 13px;
            font-size: 13px;
            color: var(--text-dark);
            box-sizing: border-box;
        }

        .message-stream {
            max-height: 400px;
            overflow-y: auto;
        }

        .page-desc-wrap {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .page-desc {
            margin: 0;
        }
    </style>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">

</head>
<body>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs/lib/stomp.min.js"></script>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">

            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">입주민게시판</a>
                <span>›</span>
                <span class="cur">그룹채팅방</span>
            </div>

            <h1 class="page-title">그룹채팅방</h1>

            <div class="page-desc-wrap">
                <p class="page-desc">
                    채팅방 목록 검색, 실시간 채팅을 지원합니다.
                </p>

                <button class="btn-sub" onclick="openDiscover()" style="margin-bottom: 5px">
                    오픈채팅 찾기
                </button>
            </div>

            <section class="chat-layout">
                <div class="chat-list">
                    <%--js로 myChatRoom List 붙는 영역--%>
                </div>

                <div class="chat-box" id="chat-content">
                    <%--js로 오픈채팅방 들어오는 영역--%>
                </div>
            </section>

        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>

<script>
    const userNo = '${userNo}';
    const contextPath = '${pageContext.request.contextPath}';
    const aptCmplexNo = '${aptCmplexNo}';
</script>
<script src="${pageContext.request.contextPath}/js/member/resident/residentBoardChat.js"></script>

</html>