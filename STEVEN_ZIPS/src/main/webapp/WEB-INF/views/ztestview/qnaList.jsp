<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>

<html lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            "surface": "#fbf9f1",
            "primary": "#3f4c15",
            "secondary": "#5b614c",
            "secondary-container": "#dfe5cb",
            "on-primary-container": "#cfe09a",
            "primary-container": "#56642b",
            "surface-container-low": "#f6f4eb",
            "on-surface": "#1b1c17",
            "on-surface-variant": "#46483c",
            "outline": "#76786b",
            "outline-variant": "#c7c8b8",
            "surface-container": "#f0eee6",
          }
        }
      }
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; background-color: #fbf9f1; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

    .forest-card {
      border: 1px solid #e2e2e0;
      border-radius: 16px;
      background-color: #ffffff;
      padding: 20px 24px;
      cursor: pointer;
      transition: box-shadow 0.2s;
    }
    .forest-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }

    .status-pill {
      border-radius: 9999px;
      padding: 4px 12px;
      font-size: 12px;
      font-weight: 600;
      display: inline-block;
    }

    .detail { display: none; }
    .detail.open { display: block; }

    .chevron { transition: transform 0.25s; }
    .forest-card.open .chevron { transform: rotate(180deg); }
  </style>
</head>

<body class="bg-surface text-on-surface min-h-screen">

<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebarStyle.jsp" %>

<main class="ml-80 p-10 pt-28">

  <!-- 제목 -->
  <div class="mb-8">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">문의게시판</h1>
    <p class="text-gray-500 text-sm">입주민 문의 내역을 확인하세요.</p>
  </div>

  <!-- 검색 + 버튼 -->
  <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div class="text-sm text-gray-500">
        총 <strong class="text-black">${fn:length(list)}</strong>건
      </div>
      <div class="flex items-center gap-3">
        <div class="relative w-64">
          <input class="w-full pl-4 pr-10 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm"
                 placeholder="문의 검색" type="text"/>
          <div class="absolute right-3 top-1/2 -translate-y-1/2">
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
          </div>
        </div>
        <button onclick="location.href='${pageContext.request.contextPath}/member/qna/writeForm.do'"
                class="px-5 py-2 rounded-full bg-[#6F7F3F] text-white text-sm font-medium hover:bg-[#5f6e35]">
          + 새 문의
        </button>
      </div>
    </div>
  </div>

  <!-- ✅ 카드형 아코디언 목록 (샘플 데이터 하드코딩) -->
  <div class="space-y-3">


 <c:if test="${empty list}">
    <div class="text-center text-gray-400 py-20">
      등록된 문의가 없습니다.
    </div>
  </c:if>

  <c:forEach var="qna" items="${list}">

    <div class="forest-card" onclick="toggleDetail(this)">

      <div class="flex justify-between items-center">
        <div class="flex-1 min-w-0 pr-4">
          <div class="text-xs text-gray-400 mb-1">
            NO.${qna.cvplNo}
          </div>
          <div class="text-base font-semibold text-gray-900">
            ${qna.cvplTtl}
          </div>
        </div>

        <div class="flex items-center gap-3 flex-shrink-0">
          <div class="flex flex-col items-end gap-1">

            <c:choose>

              <c:when test="${qna.cvplSttsCd eq '접수'}">
                <span class="status-pill bg-yellow-100 text-yellow-700">접수</span>
              </c:when>
              <c:when test="${qna.cvplSttsCd eq '처리중'}">
                <span class="status-pill bg-yellow-100 text-yellow-700">처리중</span>
              </c:when>
              <c:otherwise>
                <span class="status-pill bg-[#dfe5cb] text-[#3f4c15]">처리완료</span>
              </c:otherwise>
            </c:choose>

            <div class="text-xs text-gray-400">
              <fmt:formatDate value="${qna.cvplRegDt}" pattern="yyyy.MM.dd"/>
            </div>

          <c:if test="${qna.userNo eq sessionScope.SPRING_SECURITY_CONTEXT.authentication.principal.member.userNo}">
            <button onclick="deleteQna('${qna.cvplNo}')"
                    class="text-xs text-red-500 hover:underline">
              삭제
            </button>
          </c:if>


          </div>

          <span class="material-symbols-outlined chevron text-gray-400">expand_more</span>
        </div>
      </div>

      <div class="detail mt-5 border-t border-gray-100 pt-5">
        <div class="flex gap-4">
          <div class="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center">👤</div>
          <p class="text-sm text-gray-700 leading-relaxed pt-1">
            ${qna.cvplCn}
          </p>
        </div>
      </div>

    </div>

  </c:forEach>





  </div>
  <%-- 실제 서버 데이터 쓸 때는 위 하드코딩 대신 아래 c:forEach 사용
  <c:forEach var="qna" items="${qnaList}" varStatus="status">
    ...
  </c:forEach>
  --%>

  <!-- 페이징 -->
  <div class="mt-8 flex justify-center">
    <nav class="flex items-center gap-1">
      <button class="w-10 h-10 flex items-center justify-center rounded-lg border text-gray-400">&lt;</button>
      <button class="w-10 h-10 rounded-full bg-[#6F7F3F] text-white font-semibold">1</button>
      <button class="w-10 h-10 text-gray-600">2</button>
      <button class="w-10 h-10 text-gray-600">3</button>
      <button class="w-10 h-10 flex items-center justify-center rounded-lg border text-gray-400">&gt;</button>
    </nav>
  </div>

</main>
</body>

<script>
  function toggleDetail(card) {
    const detail = card.querySelector('.detail');
    if (!detail) return;

    const isOpen = detail.classList.contains('open');

    if (isOpen) {
      // 닫기
      detail.classList.remove('open');
      card.classList.remove('open');
    } else {
      // 열기 (다른거 건드리지 않음)
      detail.classList.add('open');
      card.classList.add('open');
    }
  }

  function deleteQna(cvplNo) {
    if (!confirm("삭제하시겠습니까?")) return;
    location.href = '${pageContext.request.contextPath}/member/qna/delete.do?cvplNo=' + cvplNo;
  }
</script>
</html>
