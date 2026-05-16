<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리</title>
    <!-- 구글 아이콘 -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded"
          rel="stylesheet">

    <!-- 관리사무소 공통 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <style>

        body {
            margin: 0;
            background: #f5f6fa;
            font-family: Pretendard;
        }

        .notice-wrap {
            padding: 30px;
        }

        .notice-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            border: 1px solid #e5e7eb;
        }

        .notice-title {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .notice-sub {
            color: #888;
            margin-bottom: 30px;
        }

        .search-row {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
        }

        .search-input {
            flex: 1;
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 0 15px;
        }

        .btn {
            height: 45px;
            padding: 0 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
        }

        .btn-search {
            background: #1f6d3d;
            color: white;
        }

        .btn-write {
            background: #2563eb;
            color: white;
        }

        .btn-delete {
            background: #ef4444;
            color: white;
        }

        .notice-table {
            width: 100%;
            border-collapse: collapse;
        }

        .notice-table th {
            background: #f9fafb;
            height: 50px;
            border-bottom: 1px solid #ddd;
        }

        .notice-table td {
            height: 55px;
            text-align: center;
            border-bottom: 1px solid #eee;
        }

        .notice-title-cell {
            text-align: left !important;
            padding-left: 20px;
        }

        .urgent-badge {
            background: #ef4444;
            color: white;
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
            margin-right: 8px;
        }

        .write-box {
            margin-top: 30px;
        }

        .form-input {
            width: 100%;
            height: 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 0 15px;
            margin-bottom: 15px;
        }

        .form-textarea {
            width: 100%;
            height: 250px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            resize: none;
        }

        /*
         * padding-top
         * → 헤더 높이만큼 아래로 내림.
         * 안 하면 헤더와 겹침.
         */

    </style>

</head>

<body>
    <%-- app-wrapper
         → 전체 화면을 사이드바 + 본문으로 나누는 최상위 박스.
        사이드바는 main-wrap 밖에 있어야 함.
    --%>
    <div class="app-wrapper">
        <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>
        <div class="main-wrap">
            <%@ include file="/WEB-INF/views/include/office_header.jsp" %>
            <%-- main-content
                 → 실제 페이지 내용이 들어가는 스크롤 영역.
            --%>
            <main class="main-content">
                <%-- office-page
                     → 페이지별 CSS 범위를 제한하는 박스.(공지사항 화면에만 CSS 적용)
                --%>
                <div class="office-page" id="noticePage">
                    <!-- 기존 공지사항 화면 시작 -->
                    <div class="notice-wrap">

                        <!-- 상단 -->
                        <div class="notice-card">

                            <div class="notice-title">
                                공지사항 관리
                            </div>

                            <div class="notice-sub">
                                입주민 공지사항을 등록하고 관리합니다.
                            </div>

                            <!-- 검색 -->
                            <!-- 검색 -->
                            <form method="get">

                                <div class="search-row">

                                    <input type="text"
                                           name="searchTtl"
                                           class="search-input"
                                           placeholder="공지 제목 검색"
                                           value="${param.searchTtl}">

                                    <button type="submit"
                                            class="btn btn-search">
                                        검색
                                    </button>

                                </div>

                            </form>

                        </div>
                        <!-- 목록 -->
                        <div class="notice-card">

                            <table class="notice-table">

                                <thead>

                                <tr>

                                    <th>공지번호</th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>조회수</th>
                                    <th>관리</th>

                                </tr>

                                </thead>

                                <tbody>

                                <!--
                                    c:forEach
                                    → JSP 반복문.
                                    Java의 for문과 같은 역할.
                                -->

                                <c:forEach items="${noticeList}"
                                           var="notice">

                                    <tr>

                                        <td>
                                                ${notice.annNo}
                                        </td>

                                        <td class="notice-title-cell">

                                            <!--
                                                긴급공지 여부.
                                                TOP_FIX_YN = 'Y'
                                            -->

                                            <c:if test="${notice.topFixYn eq 'Y'}">

                                <span class="urgent-badge">
                                    긴급
                                </span>

                                            </c:if>

                                                ${notice.ttl}

                                        </td>

                                        <td>
                                                ${notice.wrtrId}
                                        </td>

                                        <td>

                                            <fmt:formatDate
                                                    value="${notice.regDttm}"
                                                    pattern="yyyy-MM-dd"/>

                                        </td>

                                        <td>
                                                ${notice.inqCnt}
                                        </td>

                                        <td>

                                            <button type="button"
                                                    class="btn btn-write">

                                                수정

                                            </button>

                                            <button type="button"
                                                    class="btn btn-delete">

                                                삭제

                                            </button>

                                        </td>

                                    </tr>

                                </c:forEach>

                                <!-- 데이터 없을 때 -->

                                <c:if test="${empty noticeList}">

                                    <tr>

                                        <td colspan="6">

                                            등록된 공지사항이 없습니다.

                                        </td>

                                    </tr>

                                </c:if>

                                </tbody>

                            </table>

                        </div>

                        <!-- 등록 -->
                        <div class="notice-card write-box">

                            <form method="post"
                                  action="${pageContext.request.contextPath}/mgmtOffice/notice/insert">

                                <!-- hidden -->
                                <input type="hidden"
                                       name="boardNo"
                                       value="${boardNo}">

                                <input type="hidden"
                                       name="wrtrId"
                                       value="${loginUserId}">

                                <input type="hidden"
                                       name="mgmtOfcNo"
                                       value="${mgmtOfcNo}">

                                <!--
                                    hidden
                                    → 화면에는 안 보이지만
                                      서버로 값 전달할 때 사용.
                                -->

                                <input type="text"
                                       name="ttl"
                                       class="form-input"
                                       placeholder="공지 제목">

                                <textarea name="cn"
                                          class="form-textarea"
                                          placeholder="공지 내용을 입력하세요"></textarea>

                                <div style="margin-top:15px;">

                                    <label>

                                        <input type="checkbox"
                                               name="topFixYn"
                                               value="Y">

                                        긴급 공지 등록

                                    </label>

                                </div>

                                <div style="margin-top:20px;">

                                    <button type="submit"
                                            class="btn btn-write">

                                        저장

                                    </button>

                                </div>

                            </form>

                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>


</body>
</html>