
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

<main class="ml-80 p-10 pt-28">
  <!-- Header with Search (Re-integrated cleaner into page content) -->
  <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8">
    <div>
      <!-- Breadcrumbs -->
      <div class="flex items-center gap-2 text-slate-400 text-sm mb-2 font-label-md">
        <span>Home</span>
        <span class="material-symbols-outlined text-[16px]" data-icon="chevron_right">chevron_right</span>
        <span>공공주택정보</span>
        <span class="material-symbols-outlined text-[16px]" data-icon="chevron_right">chevron_right</span>
        <span class="text-primary font-bold">단지목록</span>
      </div>
      <h1 class="text-4xl font-bold tracking-tight text-on-surface mb-2">
        단지목록
      </h1>

      <p class="text-gray-500 mb-6">
        단지정보를 조회하고 확인할 수 있습니다.
      </p>
    </div>
    <!-- Search bar integrated into header -->
    <div class="relative group max-w-sm w-full">
      <span class="absolute left-4 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400" data-icon="search">search</span>
      <input class="pl-12 pr-4 py-3 bg-white border border-[#eef2eb] rounded-full w-full focus:ring-2 focus:ring-primary/20 transition-all text-sm shadow-sm" placeholder="단지명 또는 공고문 검색" type="text"/>
    </div>
  </div>
  <!-- Search & Filter Area -->
  <div class="bg-white p-6 rounded-2xl border border-[#eef2eb] mb-8 shadow-sm">
    <div class="flex flex-wrap items-center gap-4">
      <div class="flex items-center gap-2 min-w-[140px] flex-1">
        <span class="text-sm font-bold text-slate-500 shrink-0">지역</span>
        <select class="filter-select w-full bg-[#f1f3ef] border-none rounded-full px-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
          <option>시/도 전체</option>
          <option>서울</option>
          <option>경기</option>
        </select>
      </div>
      <div class="flex items-center gap-2 min-w-[140px] flex-1">
        <select class="filter-select w-full bg-[#f1f3ef] border-none rounded-full px-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
          <option>시/군/구</option>
        </select>
      </div>
      <div class="flex items-center gap-2 min-w-[140px] flex-1">
        <span class="text-sm font-bold text-slate-500 shrink-0">세대수</span>
        <select class="filter-select w-full bg-[#f1f3ef] border-none rounded-full px-4 py-2 text-sm focus:ring-2 focus:ring-primary/20">
          <option>전체</option>
        </select>
      </div>
      <div class="flex-grow min-w-[200px]">
        <input class="w-full bg-[#f1f3ef] border-none rounded-full px-6 py-2 text-sm focus:ring-2 focus:ring-primary/20" placeholder="단지명 검색" type="text"/>
      </div>
      <div class="flex gap-2 shrink-0">
        <button class="px-6 py-2 bg-white border border-slate-200 text-slate-600 rounded-full font-bold text-sm hover:bg-slate-50 transition-colors">초기화</button>
        <button class="px-8 py-2 bg-primary text-white rounded-full font-bold text-sm hover:bg-opacity-90 transition-all">검색</button>
      </div>
    </div>
  </div>
  <!-- Summary Info & Toggle -->
  <div class="flex items-center justify-between mb-6">
    <div class="flex items-center gap-2">
      <span class="text-primary font-bold">총 48개 단지</span>
    </div>
    <div class="flex bg-[#f1f3ef] p-1 rounded-full">
      <button class="bg-primary text-white px-4 py-1.5 rounded-full text-xs font-bold flex items-center gap-1">
        <span class="material-symbols-outlined text-sm" data-icon="grid_view">grid_view</span>
        카드형
      </button>
      <button class="text-slate-500 px-4 py-1.5 rounded-full text-xs font-bold flex items-center gap-1 hover:text-primary">
        <span class="material-symbols-outlined text-sm" data-icon="list">list</span>
        목록형
      </button>
    </div>
  </div>
  <!-- Complex Grid -->
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
    <!-- Card 1 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">서울</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">OO아파트</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">서울특별시 강남구 테헤란로 123</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">248세대 4동</span>
          <span class="text-primary">공고 12</span>
        </div>
      </div>
    </div>
    <!-- Card 2 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">경기</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">△△단지</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">경기도 성남시 분당구 판교로 45</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">380세대 6동</span>
          <span class="text-primary">공고 8</span>
        </div>
      </div>
    </div>
    <!-- Card 3 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">인천</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">□□하우스</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">인천광역시 연수구 송도대로 88</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">152세대 3동</span>
          <span class="text-primary">공고 6</span>
        </div>
      </div>
    </div>
    <!-- Card 4 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">부산</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">◇◇빌리지</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">부산광역시 해운대구 해운대로 200</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">428세대 8동</span>
          <span class="text-primary">공고 9</span>
        </div>
      </div>
    </div>
    <!-- Card 5 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">대전</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">☆☆파크</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">대전광역시 유성구 대학로 56</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">156세대 2동</span>
          <span class="text-primary">공고 4</span>
        </div>
      </div>
    </div>
    <!-- Card 6 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">광주</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">▽▽그린</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">광주광역시 북구 첨단과기로 11</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">312세대 5동</span>
          <span class="text-primary">공고 7</span>
        </div>
      </div>
    </div>
    <!-- Card 7 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">울산</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">OO타운</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">울산광역시 남구 삼산로 77</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">264세대 4동</span>
          <span class="text-primary">공고 5</span>
        </div>
      </div>
    </div>
    <!-- Card 8 -->
    <div class="complex-card bg-white rounded-2xl border border-[#eef2eb] overflow-hidden">
      <div class="h-40 bg-[#e8f0eb] relative flex items-center justify-center">
        <span class="material-symbols-outlined text-primary/20 text-6xl" data-icon="apartment">apartment</span>
        <span class="absolute top-4 left-4 bg-primary text-white px-3 py-1 rounded-full text-[10px] font-bold">대구</span>
      </div>
      <div class="p-5">
        <h4 class="font-bold text-primary mb-1">□□센트럴</h4>
        <p class="text-xs text-slate-400 mb-4 line-clamp-1">대구광역시 수성구 범어로 14</p>
        <div class="flex justify-between items-center text-[11px] font-bold">
          <span class="text-slate-600">510세대 9동</span>
          <span class="text-primary">공고 11</span>
        </div>
      </div>
    </div>
  </div>
  <!-- Pagination -->
  <div class="flex justify-center items-center gap-2 mb-16">
    <button class="p-2 text-slate-400 hover:text-primary transition-colors">
      <span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
    </button>
    <button class="w-8 h-8 rounded-full bg-primary text-white text-sm font-bold">1</button>
    <button class="w-8 h-8 rounded-full text-slate-400 text-sm font-bold hover:bg-slate-100 transition-all">2</button>
    <button class="w-8 h-8 rounded-full text-slate-400 text-sm font-bold hover:bg-slate-100 transition-all">3</button>
    <button class="p-2 text-slate-400 hover:text-primary transition-colors">
      <span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
    </button>
  </div>
  <!-- Detail Info Section (Selected Complex) -->
  <section class="bg-white rounded-3xl border border-[#eef2eb] overflow-hidden shadow-sm">
    <div class="bg-primary px-8 py-4 flex justify-between items-center">
      <h3 class="text-white font-bold flex items-center gap-2">
        <span class="material-symbols-outlined" data-icon="info">info</span>
        단지 상세 정보
      </h3>
      <button class="text-white/60 hover:text-white">
        <span class="material-symbols-outlined" data-icon="close">close</span>
      </button>
    </div>
    <div class="p-8 flex flex-col md:flex-row gap-8">
      <div class="w-full md:w-64 h-48 bg-[#e8f0eb] rounded-2xl flex items-center justify-center shrink-0">
        <span class="material-symbols-outlined text-primary/20 text-8xl" data-icon="apartment">apartment</span>
      </div>
      <div class="flex-1">
        <div class="flex items-center gap-3 mb-4">
          <h4 class="text-2xl font-black text-primary">OO아파트</h4>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-y-4 gap-x-12 text-sm">
          <div class="flex justify-between border-b border-slate-100 pb-2">
            <span class="text-slate-400">주소</span>
            <span class="text-primary font-medium">서울시 강남구 테헤란로 123</span>
          </div>
          <div class="flex justify-between border-b border-slate-100 pb-2">
            <span class="text-slate-400">세대수</span>
            <span class="text-primary font-medium">248세대</span>
          </div>
          <div class="flex justify-between border-b border-slate-100 pb-2">
            <span class="text-slate-400">동수</span>
            <span class="text-primary font-medium">4개동</span>
          </div>
          <div class="flex justify-between border-b border-slate-100 pb-2">
            <span class="text-slate-400">준공연도</span>
            <span class="text-primary font-medium">2008년</span>
          </div>
          <div class="flex justify-between border-b border-slate-100 pb-2">
            <span class="text-slate-400">관리사무소</span>
            <span class="text-primary font-medium">02-1234-5678</span>
          </div>
          <div class="flex justify-between border-b border-slate-100 pb-2">
            <span class="text-slate-400">계약공고</span>
            <span class="text-primary font-medium">진행 중 12건</span>
          </div>
        </div>
        <div class="flex flex-wrap gap-2 mt-8">
          <button class="bg-primary text-white px-6 py-2 rounded-full text-sm font-bold hover:bg-opacity-90 transition-all">계약공고 보기</button>
          <button class="bg-white border border-slate-200 text-slate-600 px-6 py-2 rounded-full text-sm font-bold hover:bg-slate-50 transition-colors">시설이력 보기</button>
          <button class="bg-white border border-slate-200 text-slate-600 px-6 py-2 rounded-full text-sm font-bold hover:bg-slate-50 transition-colors">통계 보기</button>
        </div>
      </div>
    </div>
  </section>
</main>

</body>


</html>