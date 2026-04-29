<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <title>시설 관리 이력 조회 - 우리집맵핑</title>
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

<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebarStyle.jsp" %>

<main class="flex-grow pt-32 pb-20 ml-64 bg-[#f8f7f4]">

  <div class="w-full px-10">


    <h1 class="text-3xl font-bold">문의게시판</h1>
    <!-- 제목 -->
    <p class="text-gray-500 mb-6">
      문의사항을 등록하고 답변을 확인할 수 있습니다.
    </p>

    <!-- 탭 -->
    <div class="flex gap-2 mb-6">
      <button class="tab-btn bg-[#5c6b2f] text-white px-4 py-2 rounded-full text-sm">전체</button>
      <button class="tab-btn bg-gray-200 px-4 py-2 rounded-full text-sm">답변대기</button>
      <button class="tab-btn bg-gray-200 px-4 py-2 rounded-full text-sm">답변완료</button>
      <button class="tab-btn bg-gray-200 px-4 py-2 rounded-full text-sm">내 문의</button>
    </div>

    <!-- 검색 -->
    <div class="bg-[#f1efea] p-4 rounded-2xl flex items-center gap-3 mb-6 shadow-sm">
      <input type="text" placeholder="문의 내용을 검색하세요"
             class="flex-1 px-4 py-2 rounded-md bg-white shadow-sm text-sm">
    </div>

    <!-- 리스트 -->
    <div class="bg-white rounded-2xl shadow-sm overflow-hidden mb-6">

      <table class="w-full text-sm">

        <thead class="bg-[#f3f1ec] text-gray-500">
        <tr>
          <th class="p-4 text-left w-20">No</th>
          <th class="p-4 text-left">제목</th>
          <th class="p-4 text-left w-32">작성자</th>
          <th class="p-4 text-left w-32">등록일</th>
          <th class="p-4 text-left w-32">상태</th>
        </tr>
        </thead>

        <tbody class="divide-y">

        <tr class="hover:bg-gray-50 cursor-pointer">
          <td class="p-4">243</td>
          <td class="p-4 font-semibold text-[#4d5c2b]">단지 내 가로등 점검 요청</td>
          <td class="p-4">홍길동</td>
          <td class="p-4">2024.05.20</td>
          <td class="p-4">
            <span class="bg-orange-100 text-orange-500 px-3 py-1 rounded-full text-xs">답변대기</span>
          </td>
        </tr>

        <tr class="hover:bg-gray-50 cursor-pointer">
          <td class="p-4">242</td>
          <td class="p-4">분리수거장 청소 상태 점검</td>
          <td class="p-4">이영희</td>
          <td class="p-4">2024.05.19</td>
          <td class="p-4">
            <span class="bg-green-100 text-green-600 px-3 py-1 rounded-full text-xs">답변완료</span>
          </td>
        </tr>

        </tbody>

      </table>

    </div>

    <!-- 상세 -->
    <div class="bg-white rounded-md shadow-sm p-6 mb-6">

      <h2 class="text-xl font-bold mb-2">단지 내 가로등 점검 요청</h2>

      <p class="text-sm text-gray-400 mb-4">
        작성자 홍길동 · 등록일 2024.05.20
      </p>

      <p class="text-sm text-gray-700 mb-6">
        103동 앞 가로등이 고장 나서 밤에 매우 어둡습니다. 빠른 점검 부탁드립니다.
      </p>

      <!-- 관리자 답변 -->
      <div class="bg-[#f1efea] p-4 rounded-md">

        <p class="font-semibold mb-2 text-[#4d5c2b]">관리자 답변</p>

        <p class="text-sm text-gray-700">
          확인 결과 해당 가로등은 전기 문제로 확인되었으며,
          금일 중 수리 진행 예정입니다.
        </p>

      </div>

    </div>

    <!-- 작성 -->
    <div class="bg-white rounded-md shadow-sm p-6">

      <h3 class="font-bold mb-4">새 문의 작성</h3>

      <input type="text" placeholder="제목을 입력하세요"
             class="w-full mb-3 px-4 py-2 rounded-md bg-gray-100 text-sm">

      <textarea placeholder="문의 내용을 입력하세요"
                class="w-full h-32 mb-4 px-4 py-2 rounded-md bg-gray-100 text-sm"></textarea>

      <div class="flex justify-end gap-2">
        <button class="px-4 py-2 bg-gray-200 rounded-full text-sm">취소</button>
        <button class="px-6 py-2 bg-[#5c6b2f] text-white rounded-full text-sm">등록</button>
      </div>

    </div>

  </div>

</main>
</body>


</html>