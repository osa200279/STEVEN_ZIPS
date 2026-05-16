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

        #noticePage {
            color: #111827;
        }

        /* 페이지 제목 영역 */
        #noticePage .page-title-block {
            margin-bottom: 22px;
        }

        #noticePage .page-title-block h2 {
            font-size: 22px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        #noticePage .page-title-block p {
            font-size: 13px;
            color: #8a94a6;
        }

        /* 공통 카드 */
        #noticePage .notice-card {
            background: #fff;
            border: 1px solid #d8dde6;
            border-radius: 7px;
            margin-bottom: 20px;
            overflow: hidden;
        }

        /* 카드 제목 */
        #noticePage .card-header {
            height: 55px;
            padding: 0 22px;
            border-bottom: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
            font-weight: 800;
        }

        #noticePage .card-header .material-symbols-rounded {
            font-size: 18px;
            color: #8a94a6;
        }

        /* 검색 조건 */
        #noticePage .search-body {
            padding: 22px;
        }

        #noticePage .search-row {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 16px;
        }

        #noticePage .search-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        #noticePage .search-label {
            font-size: 12px;
            font-weight: 800;
            color: #374151;
        }

        #noticePage .search-input {
            width: 100%;
            height: 37px;
            border: 1px solid #d5dbe5;
            border-radius: 5px;
            background: #fff;
            padding: 0 12px;
            font-size: 13px;
            outline: none;
        }

        #noticePage .search-input:focus {
            border-color: #265c30;
            box-shadow: 0 0 0 2px rgba(38, 92, 48, 0.08);
        }

        /* 작성일 기간 */
        #noticePage .date-range {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        #noticePage .date-tilde {
            font-size: 13px;
            font-weight: 700;
            color: #6b7280;
        }

        /* 버튼 영역 */
        #noticePage .search-actions {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-top: 18px;
        }

        #noticePage .btn {
            height: 37px;
            min-width: 78px;
            padding: 0 16px;
            border-radius: 5px;
            border: 1px solid transparent;
            cursor: pointer;
            font-size: 13px;
            font-weight: 800;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 5px;
        }

        #noticePage .btn-search {
            background: #265c30;
            color: #fff;
        }

        #noticePage .btn-reset {
            background: #fff;
            color: #374151;
            border-color: #d5dbe5;
        }

        /* 목록 카드 */
        #noticePage .list-header {
            height: 55px;
            padding: 0 22px;
            border-bottom: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        #noticePage .list-title {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 15px;
            font-weight: 800;
        }

        #noticePage .list-title .material-symbols-rounded {
            font-size: 18px;
            color: #8a94a6;
        }

        #noticePage .list-count {
            background: #f3f4f6;
            color: #8a94a6;
            border-radius: 999px;
            padding: 2px 9px;
            font-size: 12px;
            font-weight: 800;
        }

        /* 테이블 */
        #noticePage .notice-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 13px;
        }

        #noticePage .notice-table th {
            height: 40px;
            background: #f8fafc;
            color: #8a94a6;
            font-size: 12px;
            font-weight: 800;
            border-bottom: 1px solid #d8dde6;
            text-align: center;
        }

        #noticePage .notice-table td {
            height: 54px;
            border-bottom: 1px solid #eef1f5;
            text-align: center;
            color: #111827;
        }

        #noticePage .notice-title-cell {
            text-align: left !important;
            padding-left: 18px;
            font-weight: 700;
        }

        /* 긴급 배지 */
        #noticePage .urgent-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 22px;
            padding: 0 8px;
            border-radius: 5px;
            background: #fff1ef;
            color: #ef4444;
            border: 1px solid #fecaca;
            font-size: 11px;
            font-weight: 800;
            margin-right: 8px;
        }

        /* 관리 버튼 영역 */
        #noticePage .notice-table td:last-child {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        /* 수정 버튼: 초기화 버튼 느낌 */
        #noticePage .btn-write {
            background: #fff;
            color: #374151;
            border: 1px solid #d5dbe5;
            border-radius: 5px;
            min-width: 66px;
            height: 34px;
        }

        /* 삭제 버튼: 검색 버튼 느낌 */
        #noticePage .btn-delete {
            background: #265c30;
            color: #fff;
            border: 1px solid #265c30;
            border-radius: 5px;
            min-width: 66px;
            height: 34px;
        }

        /* 글쓰기 버튼 */
        #noticePage .btn-register {
            background: #265c30;
            color: #fff;
            border: 1px solid #265c30;
            /*border-radius: 999px;*/
            /*
               버튼 크기
           */
            min-width: 60px;
            height: 36px;
            /*
               버튼 내부 좌우 여백
           */
            padding: 0 12px;
        }

        /* 목록 오른쪽 영역 */
        #noticePage .list-actions {
            display: flex;
            align-items: center;
            gap: 37px;
        }

        /* 모달 배경 */
        #noticePage .notice-modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(17, 24, 39, 0.45);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }

        /* open 클래스가 붙으면 모달 보이기 */
        #noticePage .notice-modal-overlay.open {
            display: flex;
        }

        /* 모달 박스 */
        #noticePage .notice-modal {
            width: 560px;
            background: #fff;
            border-radius: 7px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(17, 24, 39, 0.18);
        }

        /* 모달 제목 */
        #noticePage .notice-modal-header {
            height: 54px;
            padding: 0 18px;
            border-bottom: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            justify-content: space-between;
            font-weight: 800;
        }

        /* 모달 내용 */
        #noticePage .notice-modal-body {
            padding: 18px;
        }

        #noticePage .form-section-title {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 800;
            color: #8a94a6;
            padding-bottom: 10px;
            border-bottom: 1px solid #d8dde6;
            margin-bottom: 16px;
        }

        /* 입력 묶음 */
        #noticePage .form-field {
            display: flex;
            flex-direction: column;
            gap: 7px;
            margin-bottom: 14px;
        }

        #noticePage .field-label {
            font-size: 12px;
            font-weight: 800;
            color: #374151;
        }

        #noticePage .req {
            color: #ef4444;
        }

        #noticePage .form-input,
        #noticePage .form-textarea {
            width: 100%;
            border: 1px solid #d5dbe5;
            border-radius: 5px;
            padding: 0 12px;
            font-size: 13px;
            outline: none;
        }

        #noticePage .form-input {
            height: 37px;
        }

        #noticePage .form-textarea {
            height: 180px;
            padding: 12px;
            resize: none;
        }

        #noticePage .form-input:focus,
        #noticePage .form-textarea:focus {
            border-color: #265c30;
            box-shadow: 0 0 0 2px rgba(38, 92, 48, 0.08);
        }

        /* 체크박스 */
        #noticePage .check-row {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 13px;
            font-weight: 700;
            color: #374151;
        }

        /* 모달 하단 버튼 */
        #noticePage .notice-modal-footer {
            height: 64px;
            padding: 0 18px;
            border-top: 1px solid #d8dde6;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 8px;
        }

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

                    <div class="page-title-block">
                        <h2>공지사항 관리</h2>
                        <p>입주민 공지사항을 등록하고 관리합니다.</p>
                    </div>
                    <!-- 상단 -->
                    <div class="notice-card">
                        <div class="card-header">
                            <span class="material-symbols-rounded">manage_search</span>
                            검색 조건
                        </div>

                        <div class="search-body">
                            <form method="get"
                                  action="${pageContext.request.contextPath}/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}">

                                <div class="search-row">

                                    <div class="search-group">
                                        <label class="search-label">공지번호</label>
                                        <input type="text" name="searchAnnNo" class="search-input"
                                               placeholder="공지번호 검색" value="${param.searchAnnNo}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">제목</label>
                                        <input type="text" name="searchTtl" class="search-input"
                                               placeholder="제목 검색" value="${param.searchTtl}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">작성자</label>
                                        <input type="text" name="searchWrtrId" class="search-input"
                                               placeholder="작성자 검색" value="${param.searchWrtrId}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">작성일 시작</label>
                                        <input type="date" name="searchStartDt" class="search-input"
                                               value="${param.searchStartDt}">
                                    </div>

                                    <div class="search-group">
                                        <label class="search-label">작성일 종료</label>
                                        <input type="date" name="searchEndDt" class="search-input"
                                               value="${param.searchEndDt}">
                                    </div>

                                </div>

                                <div class="search-actions">
                                    <button type="button" class="btn btn-reset"
                                            onclick="location.href='${pageContext.request.contextPath}/mgmtOffice/mngrResidentNotice/${mgmtOfcNo}'">
                                        초기화
                                    </button>

                                    <button type="submit" class="btn btn-search">
                                        <span class="material-symbols-rounded" style="font-size:16px;">search</span>
                                        검색
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- 목록 카드 -->
                    <div class="notice-card">
                        <!-- 목록 헤더 -->
                        <div class="list-header">
                            <div class="list-title">
                                <span class="material-symbols-rounded">campaign</span>
                                공지사항 목록
                            </div>
                            <div class="list-actions">
                                <!-- 글쓰기 버튼 -->
                                <button type="button"
                                        class="btn btn-register"
                                        id="openNoticeModalBtn">
                <span class="material-symbols-rounded"
                      style="font-size:16px;">
                    edit
                </span>
                                    글쓰기
                                </button>
                                <!-- 목록 건수 -->
                                <span class="list-count">
                ${empty noticeList ? 0 : noticeList.size()}건
            </span>
                            </div>
                        </div>
                        <!-- 공지사항 테이블 -->
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
                                → noticeList 반복 출력.
                            -->
                            <c:forEach items="${noticeList}"
                                       var="notice">
                                <tr>
                                    <td>
                                            ${notice.annNo}
                                    </td>
                                    <td class="notice-title-cell">

                                        <!-- 긴급 공지 -->
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

                    <!-- 공지사항 등록 모달 -->
                    <div class="notice-modal-overlay" id="noticeModal">
                        <div class="notice-modal">

                            <div class="notice-modal-header">
                                <span>공지사항 등록</span>

                                <button type="button"
                                        class="btn btn-reset"
                                        id="closeNoticeModalBtn">
                                    닫기
                                </button>
                            </div>

                            <form method="post"
                                  action="${pageContext.request.contextPath}/mgmtOffice/notice/insert">

                                <div class="notice-modal-body">

                                    <input type="hidden" name="boardNo" value="${boardNo}">
                                    <input type="hidden" name="wrtrId" value="${loginUserId}">
                                    <input type="hidden" name="mgmtOfcNo" value="${mgmtOfcNo}">

                                    <div class="form-field">
                                        <label class="field-label">
                                            공지 제목 <span class="req">*</span>
                                        </label>

                                        <input type="text"
                                               name="ttl"
                                               class="form-input"
                                               placeholder="공지 제목을 입력하세요"
                                               required>
                                    </div>

                                    <div class="form-field">
                                        <label class="field-label">
                                            공지 내용 <span class="req">*</span>
                                        </label>

                                        <textarea name="cn"
                                                  class="form-textarea"
                                                  placeholder="공지 내용을 입력하세요"
                                                  required></textarea>
                                    </div>

                                    <label class="check-row">
                                        <input type="checkbox"
                                               name="topFixYn"
                                               value="Y">
                                        긴급공지 등록
                                    </label>

                                </div>

                                <div class="notice-modal-footer">
                                    <button type="button"
                                            class="btn btn-reset"
                                            id="cancelNoticeModalBtn">
                                        취소
                                    </button>

                                    <button type="submit"
                                            class="btn btn-search">
                                        저장
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        var modal = document.getElementById("noticeModal");
        var openBtn = document.getElementById("openNoticeModalBtn");
        var closeBtn = document.getElementById("closeNoticeModalBtn");
        var cancelBtn = document.getElementById("cancelNoticeModalBtn");

        function openModal() {
            modal.classList.add("open");
        }

        function closeModal() {
            modal.classList.remove("open");
        }

        if (openBtn) {
            openBtn.addEventListener("click", openModal);
        }

        if (closeBtn) {
            closeBtn.addEventListener("click", closeModal);
        }

        if (cancelBtn) {
            cancelBtn.addEventListener("click", closeModal);
        }

        modal.addEventListener("click", function (e) {
            if (e.target === modal) {
                closeModal();
            }
        });
    });
</script>

</body>
</html>