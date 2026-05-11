<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>자유게시판 - 목록 – 대덕아파트</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

  <style>
    body {font-family: 'Noto Sans KR', sans-serif !important;background: var(--bg);color: var(--text-dark);margin: 0;}
    .material-symbols-outlined { font-family: 'Material Symbols Outlined' !important; }
    .main-shell {display:flex;align-items:stretch;width:100%;min-height:calc(100vh - 114px);margin-top:114px;background:var(--bg);}
    .content-area {flex:1;min-width:0;padding:32px 40px 64px;}
    .page-content-wrap {max-width:1080px;width:100%;margin:0 auto;}
    .breadcrumb {display:flex;align-items:center;gap:6px;font-size:12px;color:var(--text-light);margin-bottom:18px;}
    .breadcrumb a {color:var(--text-light);text-decoration:none;} .breadcrumb .cur {color:var(--green-dark);font-weight:700;}
    .page-title {font-size:22px;font-weight:800;color:var(--text-dark);padding-bottom:14px;border-bottom:2px solid var(--green-dark);margin-bottom:16px;letter-spacing:-.4px;}
    .page-desc {font-size:13px;line-height:1.8;color:var(--text-light);margin-bottom:24px;}
    .hero-card,.card,.panel {background:var(--white);border:1px solid var(--border);border-radius:14px;box-shadow:0 10px 24px rgba(30,60,40,.05);}
    .section-hd {display:flex;align-items:center;justify-content:space-between;margin-bottom:14px;padding-bottom:10px;border-bottom:1px solid var(--border);} .section-hd h3 {margin:0;font-size:15px;font-weight:800;color:var(--text-dark);} .section-hd span {font-size:12px;color:var(--text-light);} .card,.panel {padding:20px;margin-bottom:20px;}
    .data-table {width:100%;border-collapse:collapse;font-size:13px;background:#fff;overflow:hidden;border-radius:12px;} .data-table thead th {background:var(--green-pale);color:var(--text-mid);padding:12px 14px;text-align:left;font-weight:700;border-bottom:1px solid var(--border);} .data-table tbody td {padding:13px 14px;border-bottom:1px solid #edf0eb;color:var(--text-dark);vertical-align:top;} .data-table tbody tr:last-child td {border-bottom:none;}
    .fake-input,.fake-select,.fake-textarea {width:100%;border:1px solid #d8ddd4;background:#fff;border-radius:10px;padding:11px 13px;font-size:13px;color:var(--text-dark);box-sizing:border-box;}
    .inline-fields {display:flex;gap:10px;flex-wrap:wrap;} .btn-row {display:flex;justify-content:center;gap:10px;margin-top:22px;flex-wrap:wrap;}
    .btn-main,.btn-sub,.btn-danger,.btn-ghost {display:inline-flex;align-items:center;justify-content:center;min-width:120px;padding:12px 18px;border-radius:10px;font-size:13px;font-weight:800;text-decoration:none;border:none;cursor:pointer;box-sizing:border-box;} .btn-main {background:var(--green-dark);color:#fff;} .btn-sub {background:#edf5ef;color:var(--green-dark);} .btn-danger {background:#b64444;color:#fff;} .btn-ghost {background:#fff;color:var(--text-mid);border:1px solid var(--border);}
    .search-row {display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px;} .search-row .fake-input,.search-row .fake-select {max-width:220px;}
    @media (max-width:900px){.main-shell{flex-direction:column}.content-area{padding:24px 18px 48px}.page-content-wrap{max-width:100%}}
  </style>
</head>
<body>
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
        <span class="cur">자유게시판 - 목록</span>
      </div>
      <h1 class="page-title">자유게시판 - 목록</h1>
      <p class="page-desc">게시글 검색 및 필터 선택, 목록 조회, 페이징 구조를 담은 자유게시판 목록 화면입니다.</p>

      <section class="panel">
        <form id="filterForm" action="/resident/boardFreeList/${aptCmplexNo}" method="get"
              data-total-page="${pagingVO.totalPage}">
          <input type="hidden" name="page" value="${pagingVO.currentPage}" id="f-page"/>
          <input type="hidden" name="searchType" value="${searchType}"/>
          <input type="hidden" name="searchWord" value="${searchWord}"/>
        </form>
        <div class="search-row">
          <select name="searchType" class="fake-select">
            <option value="ttl" ${searchType == 'ttl' ? 'selected' : ''}>제목</option>
            <option value="wrtrId" ${searchType == 'wrtrId' ? 'selected' : ''}>작성자</option>
            <option value="cn" ${searchType == 'cn' ? 'selected' : ''}>내용</option>
          </select>
          <input class="fake-input" name="searchWord" value="${searchWord}" placeholder="검색어를 입력하세요"/>
          <button class="btn-sub" onclick="doSearch()">검색</button>
          <a href="${pageContext.request.contextPath}/resident/board/free/write/${aptCmplexNo}" class="btn-main">글쓰기</a>
        </div>

        <table class="data-table">
          <thead>
          <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
            <th>조회수</th>
          </tr>
          </thead>
          <tbody>
          <c:choose>
            <c:when test="${empty pagingVO.dataList}">
              <tr>
                <td colspan="5" style="text-align:center; padding:30px; color:var(--text-light);">
                  등록된 게시글이 없습니다.
                </td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:forEach var="board" items="${pagingVO.dataList}">
                <tr style="cursor:pointer;" onclick="location.href='/resident/boardFreeDetail/${board.postNo}/${aptCmplexNo}'">
                  <td>${board.postNo}</td>
                  <td>${board.ttl}</td>
                  <td>${board.wrtrId}</td>
                  <td><fmt:formatDate value="${board.regDttm}" pattern="yyyy-MM-dd HH:mm"/></td>
                  <td>${board.inqCnt}</td>
                </tr>
              </c:forEach>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>

        <div class="btn-row">
          <c:if test="${pagingVO.startPage > 1}">
            <button class="btn-ghost" onclick="goPage(${pagingVO.startPage - pagingVO.blockSize})">이전</button>
          </c:if>
          <c:forEach begin="${pagingVO.startPage}" end="${pagingVO.endPage <= pagingVO.totalPage ? pagingVO.endPage : pagingVO.totalPage}" var="i">
            <button class="${i == pagingVO.currentPage ? 'btn-sub' : 'btn-ghost'}" onclick="goPage(${i})">${i}</button>
          </c:forEach>
          <c:if test="${pagingVO.endPage < pagingVO.totalPage}">
            <button class="btn-ghost" onclick="goPage(${pagingVO.endPage + 1})">다음</button>
          </c:if>
        </div>
      </section>

    </div>
  </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
<script>
  let aptCmplexNo = '${aptCmplexNo}';
  let searchType = '${searchType}';
  let searchWord = '${searchWord}';

  function goPage(page) {
    var max = parseInt(document.getElementById('filterForm').dataset.totalPage, 10) || 1;
    if (page < 1 || page > max) return;
    document.getElementById('f-page').value = page;
    document.getElementById('filterForm').submit();
  }

  function doSearch() {
    searchType = document.querySelector('select[name="searchType"]').value;
    searchWord = document.querySelector('input[name="searchWord"]').value;
    document.querySelector('input[name="searchType"]').value = searchType;
    document.querySelector('input[name="searchWord"]').value = searchWord;
    document.getElementById('f-page').value = 1;
    document.getElementById('filterForm').submit();
  }
</script>
</html>
