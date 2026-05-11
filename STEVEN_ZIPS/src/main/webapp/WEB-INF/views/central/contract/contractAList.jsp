
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html class="light" lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>시설 관리 이력 조회 - 우리집맵핑</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "surface": "#fbf9f5",
            "primary": "#56642b",
            "on-primary-container": "#253000",
            "surface-container": "#efeeea",
            "on-surface": "#1b1c1a",
            "on-error": "#ffffff",
            "inverse-surface": "#30312e",
            "surface-tint": "#56642b",
            "surface-container-low": "#f5f3ef",
            "inverse-primary": "#bdce89",
            "secondary-fixed-dim": "#b4cdb7",
            "background": "#fbf9f5",
            "secondary-fixed": "#d0e9d2",
            "on-primary-fixed-variant": "#3e4c16",
            "on-secondary": "#ffffff",
            "on-background": "#1b1c1a",
            "surface-container-high": "#eae8e4",
            "primary-fixed": "#d9eaa3",
            "on-tertiary-fixed-variant": "#155037",
            "tertiary": "#30694d",
            "on-primary": "#ffffff",
            "on-secondary-container": "#546a58",
            "on-tertiary-container": "#003320",
            "error": "#ba1a1a",
            "on-surface-variant": "#46483c",
            "outline": "#76786b",
            "surface-variant": "#e4e2de",
            "inverse-on-surface": "#f2f0ed",
            "surface-container-highest": "#e4e2de",
            "tertiary-fixed": "#b4f0cd",
            "primary-fixed-dim": "#bdce89",
            "surface-container-lowest": "#ffffff",
            "on-tertiary-fixed": "#002113",
            "tertiary-container": "#669f80",
            "surface-dim": "#dbdad6",
            "error-container": "#ffdad6",
            "outline-variant": "#c6c8b8",
            "on-primary-fixed": "#161f00",
            "secondary-container": "#d0e9d2",
            "tertiary-fixed-dim": "#98d3b2",
            "secondary": "#4e6452",
            "on-error-container": "#93000a",
            "on-tertiary": "#ffffff",
            "primary-container": "#8a9a5b",
            "on-secondary-fixed-variant": "#364c3b",
            "on-secondary-fixed": "#0b2012",
            "surface-bright": "#fbf9f5"
          },
          "borderRadius": {
            "DEFAULT": "0.25rem",
            "lg": "0.5rem",
            "xl": "0.75rem",
            "full": "9999px"
          },
          "fontFamily": {
            "headline": ["Manrope"],
            "body": ["Manrope"],
            "label": ["Manrope"]
          }
        },
      },
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; }
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
  </style>
</head>
<body class="bg-surface text-on-surface flex flex-col min-h-screen">
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-8 pt-28 max-w-8xl">

  <!-- 제목 -->
  <div class="mb-8">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">
      계약 신청 조회
    </h1>
    <p class="text-gray-500 text-sm">
      내가 제출한 신청서를 확인할 수 있습니다.
    </p>
  </div>

  <!-- 상태 카드 -->
  <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6">
    <div class="flex justify-between items-center">

      <div>
        <p class="text-sm text-gray-400">신청번호</p>
        <p class="text-lg font-semibold">APT20260502001</p>
      </div>

      <div class="text-right">
        <span class="px-4 py-1 rounded-full bg-yellow-100 text-yellow-700 text-sm font-semibold">
          심사중
        </span>
        <p class="text-xs text-gray-400 mt-1">2026.05.02 제출</p>
      </div>

    </div>
  </div>

  <!-- 제출 서류 -->
  <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6">
    <h2 class="text-lg font-semibold mb-4 text-[#4d5c2b]">제출 서류</h2>

    <div class="space-y-3">

      <div class="flex justify-between items-center border-b pb-3">
       <span>${residentFile}</span>

<c:choose>

    <c:when test="${not empty residentFile}">
        <span class="text-green-600 text-sm">
            제출 완료
        </span>
    </c:when>

    <c:otherwise>
        <span class="text-gray-400 text-sm">
            미제출
        </span>
    </c:otherwise>

</c:choose>
      </div>

      <div class="flex justify-between items-center border-b pb-3">
      <span>${familyFile}</span>

<c:choose>

    <c:when test="${not empty familyFile}">
        <span class="text-green-600 text-sm">
            제출 완료
        </span>
    </c:when>

    <c:otherwise>
        <span class="text-gray-400 text-sm">
            미제출
        </span>
    </c:otherwise>

</c:choose>
      </div>

      <div class="flex justify-between items-center">
      <span>${financeFile}</span>

<c:choose>

    <c:when test="${not empty financeFile}">
        <span class="text-green-600 text-sm">
            제출 완료
        </span>
    </c:when>

    <c:otherwise>
        <span class="text-gray-400 text-sm">
            미제출
        </span>
    </c:otherwise>

</c:choose>
      </div>

    </div>
  </div>

  <!-- 진행 상태 -->
  <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6">
    <h2 class="text-lg font-semibold mb-4 text-[#4d5c2b]">진행 상태</h2>

      <div class="space-y-2 text-sm text-gray-600">
          <c:choose>
              <c:when test="${not empty list}">
                  <c:set var="stts" value="${list[0].ctrtSttsCd}"/>
                  <div class="${stts == 'SUB' || stts == 'PND' || stts == 'APR' || stts == 'RJC' || stts == 'CNL' || stts == 'EXP' ? 'text-green-600' : 'text-gray-400'}">
                      ✔ 신청서 제출 완료
                  </div>
                  <div class="${stts == 'PND' || stts == 'APR' || stts == 'RJC' ? 'text-green-600' : 'text-gray-400'}">
                      <c:choose>
                          <c:when test="${stts == 'PND' || stts == 'APR' || stts == 'RJC'}">✔</c:when>
                          <c:otherwise>-</c:otherwise>
                      </c:choose>
                      서류 검토
                  </div>
                  <div class="${stts == 'APR' ? 'text-green-600' : stts == 'RJC' ? 'text-red-600' : stts == 'CNL' ? 'text-gray-400' : 'text-gray-400'}">
                      <c:choose>
                          <c:when test="${stts == 'APR'}">✔ 승인됨</c:when>
                          <c:when test="${stts == 'RJC'}">✘ 반려</c:when>
                          <c:when test="${stts == 'CNL'}">- 취소</c:when>
                          <c:when test="${stts == 'EXP'}">- 만료됨</c:when>
                          <c:otherwise>- 계약 승인 대기</c:otherwise>
                      </c:choose>
                  </div>
              </c:when>
              <c:otherwise>
                  <div class="text-gray-400">- 신청서 미제출</div>
              </c:otherwise>
          </c:choose>
      </div>
  </div>

  <!-- 버튼 -->
  <div class="flex justify-end gap-3">

    <button type="button"
            onclick="location.href='${pageContext.request.contextPath}/contract/apply.do'"
            class="px-5 py-2 bg-gray-200 rounded-full text-sm">
      수정
    </button>

    <button class="px-5 py-2 bg-red-500 text-white rounded-full text-sm" id="deleteBtn">
        신청 취소
    </button>
  </div>
</main>
</body>
<script>
</script>
</html>
