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
        .modal-btn {
            min-width: 78px !important;
            padding: 8px 14px !important;
            font-size: 12px !important;
            border-radius: 8px !important;
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

<div id="create-room-modal"
     onclick="outsideClose(e)"
     style="display:none;
            position:fixed;
            inset:0;
            background:rgba(0,0,0,0.45);
            z-index:9999;
            align-items:center;
            justify-content:center;">

    <div style="width:420px;
                background:white;
                border-radius:18px;
                padding:24px;
                box-shadow:0 10px 30px rgba(0,0,0,0.18);">

        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:18px;">
            <h3 style="margin:0;">채팅방 만들기</h3>

            <button onclick="closeCreateRoomModal()"
                    style="border:none;background:none;font-size:20px;cursor:pointer;">
                ×
            </button>
        </div>

        <div style="margin-bottom:14px;">
            <label style="display:block;margin-bottom:8px;font-size:13px;">
                채팅방 이름
            </label>

            <input type="text"
                   id="create-room-name"
                   class="fake-input"
                   placeholder="채팅방 이름 입력">
        </div>

        <div style="margin-bottom:18px;">

            <label style="display:block;margin-bottom:8px;font-size:13px;">
                채팅방 타입
            </label>

            <div style="display:flex;gap:18px;">

                <label style="display:flex;align-items:center;gap:6px;">
                    <input type="radio"
                           name="room-type"
                           value="NORMAL"
                           checked>
                    일반 채팅방
                </label>

                <label style="display:flex;align-items:center;gap:6px;">
                    <input type="radio"
                           name="room-type"
                           value="OPEN">
                    오픈 채팅방
                </label>

            </div>
        </div>

        <div style="display:flex;justify-content:flex-end;gap:10px;">

            <button onclick="submitCreateRoom()"
                    class="btn-main modal-btn">
                생성
            </button>

            <button onclick="closeCreateRoomModal()"
                    class="btn-ghost modal-btn">
                취소
            </button>

        </div>
    </div>
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