

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&amp;family=Manrope:wght@400;500;600;700&amp;family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "outline-variant": "#bfc9c1",
            "inverse-primary": "#95d4b3",
            "tertiary-fixed-dim": "#ffb3b2",
            "inverse-surface": "#2e312f",
            "on-error": "#ffffff",
            "surface-container-highest": "#e1e3df",
            "on-secondary-fixed-variant": "#0d503f",
            "surface-container": "#eceeea",
            "secondary-container": "#aeedd5",
            "secondary-fixed": "#b1efd8",
            "on-secondary-fixed": "#002118",
            "background": "#f8faf6",
            "secondary-fixed-dim": "#96d3bd",
            "on-tertiary-container": "#ffb8b8",
            "on-primary": "#ffffff",
            "on-background": "#191c1a",
            "primary-fixed": "#b1f0ce",
            "tertiary-fixed": "#ffdad9",
            "surface-container-high": "#e7e9e5",
            "surface-tint": "#2c694f",
            "tertiary": "#652d2e",
            "on-error-container": "#93000a",
            "on-surface": "#191c1a",
            "surface-container-low": "#f2f4f0",
            "on-secondary-container": "#316d5b",
            "surface-bright": "#f8faf6",
            "secondary": "#2c6956",
            "inverse-on-surface": "#eff1ed",
            "tertiary-container": "#814344",
            "on-tertiary-fixed-variant": "#703536",
            "outline": "#707973",
            "on-primary-fixed-variant": "#0e5138",
            "surface-container-lowest": "#ffffff",
            "primary": "#004830",
            "on-primary-fixed": "#002114",
            "on-surface-variant": "#404943",
            "primary-container": "#226046",
            "error-container": "#ffdad6",
            "primary-fixed-dim": "#95d4b3",
            "surface": "#f8faf6",
            "on-tertiary-fixed": "#390b0e",
            "on-primary-container": "#99d8b7",
            "error": "#ba1a1a",
            "on-secondary": "#ffffff",
            "surface-dim": "#d8dbd7",
            "surface-variant": "#e1e3df",
            "on-tertiary": "#ffffff"
          },
          "borderRadius": {
            "DEFAULT": "1rem",
            "lg": "2rem",
            "xl": "3rem",
            "full": "9999px"
          },
          "fontFamily": {
            "headline": ["Plus Jakarta Sans"],
            "body": ["Manrope"],
            "label": ["Manrope"]
          }
        },
      },
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; background-color: #f8faf6; color: #191c1a; }
    .font-headline { font-family: 'Plus Jakarta Sans', sans-serif; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

    /* Accordion custom styling */
    .nav-item[open] summary .expand-icon { transform: rotate(180deg); }
    .nav-item summary::-webkit-details-marker { display: none; }
    .nav-item summary { list-style: none; }
  </style>
</head>
<!-- SideNavBar -->
<body class="bg-background text-on-background selection:bg-primary-fixed selection:text-on-primary-fixed overflow-x-hidden">

<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>

<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>
<!-- Main Wrapper -->


<div class="ml-80 min-h-screen flex flex-col">



  <!-- Main Content -->
  <main class="flex-1 p-8 pt-28 space-y-8">
    <!-- Page Header & Breadcrumbs -->
    <div class="flex justify-between items-end">
      <div class="space-y-2">

        <div class="flex items-center gap-2 text-xs text-slate-400">
          <span>Home</span>
          <span>›</span>
          <span>공지사항</span>
          <span>›</span>
          <span class="text-primary-container font-semibold">계약공고</span>
        </div>

        <h1 class="text-5xl font-bold tracking-tight text-on-surface mt-4 mb-2">
          계약공고
        </h1>

        <p class="text-gray-500">
          문의사항을 등록하고 답변을 확인할 수 있습니다.
        </p>

      </div>
      <div class="flex gap-2">
        <button class="px-4 py-2 bg-white border border-[#eef2eb] rounded-lg text-sm font-medium hover:bg-[#f8faf6] transition-colors">내보내기</button>
        <button class="px-4 py-2 bg-primary-container text-white rounded-lg text-sm font-medium hover:bg-[#003825] transition-colors flex items-center gap-2">
          <span class="material-symbols-outlined text-sm" data-icon="add">add</span> 공고 등록
        </button>
      </div>
    </div>
    <!-- Filter Section -->
    <section class="bg-white p-6 rounded-lg border border-[#eef2eb] shadow-[0px_4px_20px_rgba(0,72,48,0.04)] space-y-6">
      <div class="grid grid-cols-4 gap-4">
        <div class="space-y-2">
          <label class="text-xs font-bold text-slate-500 ml-1">유형</label>
          <div class="relative">
            <select class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm appearance-none focus:ring-2 focus:ring-primary-container">
              <option>전체</option>
              <option>용역</option>
              <option>공사</option>
              <option>물품</option>
            </select>
            <span class="material-symbols-outlined absolute right-3 top-3 text-slate-400 pointer-events-none" data-icon="expand_more">expand_more</span>
          </div>
        </div>
        <div class="space-y-2">
          <label class="text-xs font-bold text-slate-500 ml-1">지역</label>
          <div class="relative">
            <select class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm appearance-none focus:ring-2 focus:ring-primary-container">
              <option>서울</option>
              <option>경기</option>
              <option>인천</option>
              <option>강원</option>
            </select>
            <span class="material-symbols-outlined absolute right-3 top-3 text-slate-400 pointer-events-none" data-icon="location_on">location_on</span>
          </div>
        </div>
        <div class="space-y-2">
          <label class="text-xs font-bold text-slate-500 ml-1">상태</label>
          <div class="relative">
            <select class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm appearance-none focus:ring-2 focus:ring-primary-container">
              <option>진행중</option>
              <option>마감</option>
              <option>취소</option>
            </select>
            <span class="material-symbols-outlined absolute right-3 top-3 text-slate-400 pointer-events-none" data-icon="timer">timer</span>
          </div>
        </div>
        <div class="space-y-2">
          <label class="text-xs font-bold text-slate-500 ml-1">공고일자</label>
          <div class="relative">
            <input class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm focus:ring-2 focus:ring-primary-container" placeholder="mm/dd/yyyy" type="text"/>
            <span class="material-symbols-outlined absolute right-3 top-3 text-slate-400 pointer-events-none" data-icon="calendar_month">calendar_month</span>
          </div>
        </div>
      </div>
      <div class="flex gap-3">
        <div class="relative flex-1">
          <input class="w-full bg-[#f1f3ef] border-none rounded-lg py-4 px-12 text-sm focus:ring-2 focus:ring-primary-container" placeholder="공고명 또는 아파트명을 입력하세요" type="text"/>
          <span class="material-symbols-outlined absolute left-4 top-4 text-slate-400" data-icon="search">search</span>
        </div>
        <button class="bg-primary-container text-white px-10 py-4 rounded-lg font-bold hover:shadow-lg transition-all active:scale-95">검색</button>
      </div>
    </section>
    <!-- List Section Header -->
    <div class="flex justify-between items-center">
      <p class="text-sm text-slate-600">전체 <span class="font-bold text-primary-container">85</span>건 | <span class="text-slate-400">1/2페이지</span></p>
      <div class="flex bg-white border border-[#eef2eb] p-1 rounded-lg">
        <button class="p-2 bg-[#eef2eb] text-primary-container rounded-md"><span class="material-symbols-outlined text-[20px]" data-icon="list">list</span></button>
        <button class="p-2 text-slate-400 hover:text-primary-container"><span class="material-symbols-outlined text-[20px]" data-icon="grid_view">grid_view</span></button>
      </div>
    </div>
    <!-- Data Table -->
    <div class="bg-white rounded-lg border border-[#eef2eb] shadow-sm overflow-hidden">
      <table class="w-full text-left border-collapse">
        <thead class="bg-[#f1f3ef]/50 border-b border-[#eef2eb]">
        <tr>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">번호</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">유형</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">공고명</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">지역</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider text-center">첨부</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">게시일</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">마감일</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">상태</th>
          <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase tracking-wider">조회수</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-[#eef2eb]">
        <!-- Row 1 -->
        <tr class="hover:bg-[#f8faf6] transition-colors group">
          <td class="px-6 py-5 text-sm text-slate-400">85</td>
          <td class="px-6 py-5"><span class="text-xs font-bold bg-[#eef2eb] text-[#004830] px-2 py-1 rounded">용역</span></td>
          <td class="px-6 py-5 text-sm font-semibold text-[#004830]">
            <a href="/contract/detail.do?annNo=ANN001"
               class="group-hover:underline cursor-pointer">
              서초그랑자이 단지 내 조경관리 용역업체 선정 공고
            </a>
          </td>
          <td class="px-6 py-5 text-sm text-slate-600">서울 서초구</td>
          <td class="px-6 py-5 text-center"><span class="material-symbols-outlined text-slate-300 text-[20px]" data-icon="attachment">attachment</span></td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.05.20</td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.06.05</td>
          <td class="px-6 py-5"><span class="bg-secondary-container text-on-secondary-container text-[11px] font-bold px-3 py-1 rounded-full">공고중</span></td>
          <td class="px-6 py-5 text-sm text-slate-400">1,240</td>
        </tr>
        <!-- Row 2 -->
        <tr class="hover:bg-[#f8faf6] transition-colors group">
          <td class="px-6 py-5 text-sm text-slate-400">84</td>
          <td class="px-6 py-5"><span class="text-xs font-bold bg-[#eef2eb] text-[#004830] px-2 py-1 rounded">공사</span></td>
          <td class="px-6 py-5 text-sm font-semibold text-[#004830] group-hover:underline cursor-pointer">반포자이 커뮤니티 센터 지하주차장 LED 교체 공사</td>
          <td class="px-6 py-5 text-sm text-slate-600">서울 서초구</td>
          <td class="px-6 py-5 text-center"><span class="material-symbols-outlined text-slate-300 text-[20px]" data-icon="attachment">attachment</span></td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.05.18</td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.06.01</td>
          <td class="px-6 py-5"><span class="bg-secondary-container text-on-secondary-container text-[11px] font-bold px-3 py-1 rounded-full">공고중</span></td>
          <td class="px-6 py-5 text-sm text-slate-400">856</td>
        </tr>
        <!-- Row 3 -->
        <tr class="hover:bg-[#f8faf6] transition-colors group">
          <td class="px-6 py-5 text-sm text-slate-400">83</td>
          <td class="px-6 py-5"><span class="text-xs font-bold bg-[#eef2eb] text-[#004830] px-2 py-1 rounded">용역</span></td>
          <td class="px-6 py-5 text-sm font-semibold text-[#004830] group-hover:underline cursor-pointer">갤러리아 포레 통합 보안 및 경비 시스템 위탁 업체 입찰</td>
          <td class="px-6 py-5 text-sm text-slate-600">서울 성동구</td>
          <td class="px-6 py-5 text-center"><span class="material-symbols-outlined text-slate-300 text-[20px]" data-icon="attachment">attachment</span></td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.05.15</td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.05.30</td>
          <td class="px-6 py-5"><span class="bg-slate-200 text-slate-500 text-[11px] font-bold px-3 py-1 rounded-full">마감</span></td>
          <td class="px-6 py-5 text-sm text-slate-400">2,104</td>
        </tr>
        <!-- Row 4 -->
        <tr class="hover:bg-[#f8faf6] transition-colors group">
          <td class="px-6 py-5 text-sm text-slate-400">82</td>
          <td class="px-6 py-5"><span class="text-xs font-bold bg-[#eef2eb] text-[#004830] px-2 py-1 rounded">물품</span></td>
          <td class="px-6 py-5 text-sm font-semibold text-[#004830] group-hover:underline cursor-pointer">디에이치 아너힐즈 입주민 전용 카페 라운지 원두 납품</td>
          <td class="px-6 py-5 text-sm text-slate-600">서울 강남구</td>
          <td class="px-6 py-5 text-center"><span class="material-symbols-outlined text-slate-300 text-[20px]" data-icon="attachment">attachment</span></td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.05.12</td>
          <td class="px-6 py-5 text-sm text-slate-500">2024.05.28</td>
          <td class="px-6 py-5"><span class="bg-secondary-container text-on-secondary-container text-[11px] font-bold px-3 py-1 rounded-full">공고중</span></td>
          <td class="px-6 py-5 text-sm text-slate-400">432</td>
        </tr>
        </tbody>
      </table>
    </div>
    <!-- Pagination -->
    <div class="flex justify-center items-center gap-2 py-4">
      <button class="w-10 h-10 flex items-center justify-center rounded-full border border-[#eef2eb] hover:bg-white transition-colors text-slate-400">
        <span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
      </button>
      <button class="w-10 h-10 flex items-center justify-center rounded-full bg-primary-container text-white font-bold">1</button>
      <button class="w-10 h-10 flex items-center justify-center rounded-full hover:bg-white transition-colors text-slate-600 font-medium">2</button>
      <button class="w-10 h-10 flex items-center justify-center rounded-full hover:bg-white transition-colors text-slate-600 font-medium">3</button>
      <span class="text-slate-300 mx-1">...</span>
      <button class="w-10 h-10 flex items-center justify-center rounded-full hover:bg-white transition-colors text-slate-600 font-medium">9</button>
      <button class="w-10 h-10 flex items-center justify-center rounded-full border border-[#eef2eb] hover:bg-white transition-colors text-slate-400">
        <span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
      </button>
    </div>
    <!-- Bottom Summary Cards -->

  </main>
  <script>
    // Simple script to handle single accordion open at a time (optional)
    const details = document.querySelectorAll('.nav-item');
    details.forEach((targetDetail) => {
      targetDetail.addEventListener('click', () => {
        details.forEach((detail) => {
          if (detail !== targetDetail) {
            detail.removeAttribute('open');
          }
        });
      });
    });
  </script>
  </body>
</html>