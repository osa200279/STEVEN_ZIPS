
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

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-8 pt-28 max-w-8xl">
  <!-- Header Section -->
  <header class="flex flex-col gap-2 mb-8">


    <h1 class="text-3xl font-bold text-gray-900 mb-2">단지별 통계 조회</h1>


    <p class="text-gray-500 text-sm ">
      주택 단지 운영 및 계약 지표에 대한 실시간 분석 현황입니다.
    </p>
  </header>
  <!-- Filter Bar -->
  <section class="tonal-surface p-6 rounded-lg flex flex-wrap items-end gap-6 border border-outline-variant/30">
    <div class="flex-1 min-w-[200px] space-y-2">
      <label class="font-label-md text-on-surface-variant flex items-center gap-2"><span class="material-symbols-outlined text-sm">location_on</span>지역</label>
      <select class="w-full bg-surface-container-low border-none rounded-full px-6 py-3 focus:ring-2 focus:ring-primary-container text-body-md appearance-none">
        <option>전체 지역</option>
        <option>Seoul Metropolitan</option>
        <option>Gyeonggi-do</option>
        <option>Incheon</option>
      </select>
    </div>
    <div class="flex-1 min-w-[200px] space-y-2">
      <label class="font-label-md text-on-surface-variant flex items-center gap-2"><span class="material-symbols-outlined text-sm">domain</span>단지</label>
      <select class="w-full bg-surface-container-low border-none rounded-full px-6 py-3 focus:ring-2 focus:ring-primary-container text-body-md appearance-none">
        <option>단지 선택</option>
        <option>Green Valley Estates</option>
        <option>Emerald Heights</option>
        <option>Forest Park Prime</option>
      </select>
    </div>
    <div class="flex-1 min-w-[200px] space-y-2">
      <label class="font-label-md text-on-surface-variant flex items-center gap-2"><span class="material-symbols-outlined text-sm">calendar_today</span>연도</label>
      <select class="w-full bg-surface-container-low border-none rounded-full px-6 py-3 focus:ring-2 focus:ring-primary-container text-body-md appearance-none">
        <option>2024</option>
        <option>2023</option>
        <option>2022</option>
      </select>
    </div>
    <button class="bg-primary-container text-white px-10 py-3 rounded-full font-label-md hover:bg-primary transition-all active:scale-95 flex items-center gap-2"><span class="material-symbols-outlined">search</span>조회</button>
  </section>
  <!-- Summary Grid -->
  <section class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-gutter">
    <div class="tonal-surface p-8 rounded-lg border-l-4 border-primary-container group hover:translate-y-[-4px] transition-transform">
      <div class="flex justify-between items-start mb-4">
        <div class="p-3 rounded-full text-white" style="background-color: #FFB347;"><span class="material-symbols-outlined" data-icon="groups">groups</span></div>
        <span class="text-primary-container font-label-sm">+2.4%</span>
      </div>
      <p class="text-on-surface-variant font-label-md mb-1">총 세대수</p>
      <h3 class="font-h2 text-h2 text-on-surface">12,482</h3>
    </div>
    <div class="tonal-surface p-8 rounded-lg border-l-4 border-primary-container group hover:translate-y-[-4px] transition-transform">
      <div class="flex justify-between items-start mb-4">
        <div class="p-3 rounded-full text-white" style="background-color: #FFB347;"><span class="material-symbols-outlined" data-icon="groups">groups</span></div>
        <span class="text-primary-container font-label-sm">Active</span>
      </div>
      <p class="text-on-surface-variant font-label-md mb-1">공고 수</p>
      <h3 class="font-h2 text-h2 text-on-surface">156</h3>
    </div>
    <div class="tonal-surface p-8 rounded-lg border-l-4 border-primary-container group hover:translate-y-[-4px] transition-transform">
      <div class="flex justify-between items-start mb-4">
        <div class="p-3 rounded-full text-white" style="background-color: #FFB347;"><span class="material-symbols-outlined" data-icon="groups">groups</span></div>
        <div class="flex items-center gap-1 text-primary-container font-label-sm">
          <span class="material-symbols-outlined text-xs">trending_up</span>
          8%
        </div>
      </div>
      <p class="text-on-surface-variant font-label-md mb-1">계약률</p>
      <h3 class="font-h2 text-h2 text-on-surface">94.2%</h3>
    </div>
    <div class="tonal-surface p-8 rounded-lg border-l-4 border-primary-container group hover:translate-y-[-4px] transition-transform">
      <div class="flex justify-between items-start mb-4">
        <div class="p-3 rounded-full text-white" style="background-color: #FFB347;"><span class="material-symbols-outlined" data-icon="groups">groups</span></div>
        <span class="text-on-surface-variant font-label-sm">Total 2024</span>
      </div>
      <p class="text-on-surface-variant font-label-md mb-1">점검 건수</p>
      <h3 class="font-h2 text-h2 text-on-surface">1,024</h3>
    </div>
  </section>
  <!-- Visualization Row -->
  <section class="grid grid-cols-1 lg:grid-cols-3 gap-gutter">
    <!-- Monthly Status Bar Chart -->
    <div class="lg:col-span-2 tonal-surface p-8 rounded-lg">
      <div class="flex justify-between items-center mb-8">
        <h4 class="font-h3 text-h3 text-on-surface">월별 현황</h4>
        <div class="flex gap-4">
          <div class="flex items-center gap-2">
            <div class="w-3 h-3 rounded-full" style="background-color: #FFB347;"></div>
            <span class="text-label-sm text-on-surface-variant">입주</span>
          </div>
          <div class="flex items-center gap-2">
            <div class="w-3 h-3 rounded-full bg-primary-fixed-dim"></div>
            <span class="text-label-sm text-on-surface-variant">유지보수</span>
          </div>
        </div>
      </div>
      <div class="h-64 flex items-end gap-4 justify-between px-4">
        <!-- Bar items -->
        <div class="flex-1 flex flex-col items-center gap-2">
          <div class="w-full flex gap-1 items-end">
            <div class="flex-1 rounded-t-sm h-32" style="background-color: #FFB347;"></div>
            <div class="flex-1 bg-primary-fixed-dim rounded-t-sm h-16"></div>
          </div>
          <span class="font-label-sm text-on-surface-variant">Jan</span>
        </div>
        <div class="flex-1 flex flex-col items-center gap-2">
          <div class="w-full flex gap-1 items-end">
            <div class="flex-1 rounded-t-sm h-40" style="background-color: #FFB347;"></div>
            <div class="flex-1 bg-primary-fixed-dim rounded-t-sm h-20"></div>
          </div>
          <span class="font-label-sm text-on-surface-variant">Feb</span>
        </div>
        <div class="flex-1 flex flex-col items-center gap-2">
          <div class="w-full flex gap-1 items-end">
            <div class="flex-1 rounded-t-sm h-48" style="background-color: #FFB347;"></div>
            <div class="flex-1 bg-primary-fixed-dim rounded-t-sm h-24"></div>
          </div>
          <span class="font-label-sm text-on-surface-variant">Mar</span>
        </div>
        <div class="flex-1 flex flex-col items-center gap-2">
          <div class="w-full flex gap-1 items-end">
            <div class="flex-1 rounded-t-sm h-56" style="background-color: #FFB347;"></div>
            <div class="flex-1 bg-primary-fixed-dim rounded-t-sm h-28"></div>
          </div>
          <span class="font-label-sm text-on-surface-variant">Apr</span>
        </div>
        <div class="flex-1 flex flex-col items-center gap-2">
          <div class="w-full flex gap-1 items-end">
            <div class="flex-1 rounded-t-sm h-44" style="background-color: #FFB347;"></div>
            <div class="flex-1 bg-primary-fixed-dim rounded-t-sm h-22"></div>
          </div>
          <span class="font-label-sm text-on-surface-variant">May</span>
        </div>
        <div class="flex-1 flex flex-col items-center gap-2">
          <div class="w-full flex gap-1 items-end">
            <div class="flex-1 rounded-t-sm h-52" style="background-color: #FFB347;"></div>
            <div class="flex-1 bg-primary-fixed-dim rounded-t-sm h-26"></div>
          </div>
          <span class="font-label-sm text-on-surface-variant">Jun</span>
        </div>
      </div>
    </div>
    <!-- Contract Type Donut Chart -->
    <div class="tonal-surface p-8 rounded-lg flex flex-col">
      <h4 class="font-h3 text-h3 text-on-surface mb-8">계약 유형별 비율</h4>
      <div class="flex-1 flex items-center justify-center relative">
        <div class="w-48 h-48 rounded-full border-[18px] relative" style="border-color: #FFB347;">
          <div class="absolute top-[-18px] left-[-18px] w-48 h-48 rounded-full border-[18px] border-primary-fixed-dim border-t-transparent border-l-transparent -rotate-45"></div>
          <div class="absolute inset-0 flex flex-col items-center justify-center">
            <span class="font-h2 text-h2 text-[#FFB347]">68%</span>
            <span class="font-label-sm text-on-surface-variant">법인</span>
          </div>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-4 mt-8">
        <div class="flex items-center gap-3">
          <div class="w-3 h-3 rounded-full" style="background-color: #FFB347;"></div>
          <div class="flex flex-col">
            <span class="font-label-sm text-on-surface-variant">법인</span>
            <span class="font-label-md text-on-surface">68.2%</span>
          </div>
        </div>
        <div class="flex items-center gap-3">
          <div class="w-3 h-3 rounded-full bg-primary-fixed-dim"></div>
          <div class="flex flex-col">
            <span class="font-label-sm text-on-surface-variant">개인</span>
            <span class="font-label-md text-on-surface">31.8%</span>
          </div>
        </div>
      </div>
    </div>
  </section>
  <!-- Data Table -->
  <section class="tonal-surface rounded-lg overflow-hidden">
    <div class="px-8 py-6 border-b border-outline-variant/30 flex justify-between items-center">
      <h4 class="font-h3 text-h3 text-on-surface">단지 상세 정보</h4>
      <div class="flex gap-2">
        <button class="p-2 rounded-full hover:bg-surface-container-low text-on-surface-variant transition-colors">
          <span class="material-symbols-outlined">filter_list</span>
        </button>
        <button class="p-2 rounded-full hover:bg-surface-container-low text-on-surface-variant transition-colors">
          <span class="material-symbols-outlined">download</span>
        </button>
      </div>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-left">
        <thead>
        <tr class="bg-surface-container-low/50">
          <th class="px-8 py-4 font-label-md text-on-surface-variant">번호</th>
          <th class="px-8 py-4 font-label-md text-on-surface-variant">단지명</th>
          <th class="px-8 py-4 font-label-md text-on-surface-variant">지역</th>
          <th class="px-8 py-4 font-label-md text-on-surface-variant">세대수</th>
          <th class="px-8 py-4 font-label-md text-on-surface-variant">계약률</th>
          <th class="px-8 py-4 font-label-md text-on-surface-variant">상태</th>
          <th class="px-8 py-4 font-label-md text-on-surface-variant">작업</th>
        </tr>
        </thead>
        <tbody class="divide-y divide-outline-variant/20">
        <tr class="hover:bg-surface-container-low/30 transition-colors">
          <td class="px-8 py-5 font-body-md text-on-surface-variant">01</td>
          <td class="px-8 py-5 font-label-md text-on-surface">삼성아파트</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">서울</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">1,200</td>
          <td class="px-8 py-5">
            <div class="flex items-center gap-3">
              <div class="flex-1 bg-surface-container-low rounded-full h-1.5 min-w-[60px]">
                <div class="bg-primary-container h-1.5 rounded-full" style="width: 98%"></div>
              </div>
              <span class="font-label-sm text-primary-container">98%</span>
            </div>
          </td>
          <td class="px-8 py-5">
            <span class="px-3 py-1 bg-secondary-container text-on-secondary-container rounded-full font-label-sm">활성</span>
          </td>
          <td class="px-8 py-5">
            <button class="text-primary-container hover:underline font-label-sm">보고서 보기</button>
          </td>
        </tr>
        <tr class="hover:bg-surface-container-low/30 transition-colors">
          <td class="px-8 py-5 font-body-md text-on-surface-variant">02</td>
          <td class="px-8 py-5 font-label-md text-on-surface">이편한아파트</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">금산</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">850</td>
          <td class="px-8 py-5">
            <div class="flex items-center gap-3">
              <div class="flex-1 bg-surface-container-low rounded-full h-1.5 min-w-[60px]">
                <div class="bg-primary-container h-1.5 rounded-full" style="width: 92%"></div>
              </div>
              <span class="font-label-sm text-primary-container">92%</span>
            </div>
          </td>
          <td class="px-8 py-5">
            <span class="px-3 py-1 bg-secondary-container text-on-secondary-container rounded-full font-label-sm">활성</span>
          </td>
          <td class="px-8 py-5">
            <button class="text-primary-container hover:underline font-label-sm">보고서 보기</button>
          </td>
        </tr>
        <tr class="hover:bg-surface-container-low/30 transition-colors">
          <td class="px-8 py-5 font-body-md text-on-surface-variant">03</td>
          <td class="px-8 py-5 font-label-md text-on-surface">자이아파트</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">대구</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">2,100</td>
          <td class="px-8 py-5">
            <div class="flex items-center gap-3">
              <div class="flex-1 bg-surface-container-low rounded-full h-1.5 min-w-[60px]">
                <div class="bg-primary-container h-1.5 rounded-full" style="width: 85%"></div>
              </div>
              <span class="font-label-sm text-primary-container">85%</span>
            </div>
          </td>
          <td class="px-8 py-5">
            <span class="px-3 py-1 bg-tertiary-fixed text-on-tertiary-fixed-variant rounded-full font-label-sm">대기</span>
          </td>
          <td class="px-8 py-5">
            <button class="text-primary-container hover:underline font-label-sm">보고서 보기</button>
          </td>
        </tr>
        <tr class="hover:bg-surface-container-low/30 transition-colors">
          <td class="px-8 py-5 font-body-md text-on-surface-variant">04</td>
          <td class="px-8 py-5 font-label-md text-on-surface">롯데캐슬</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">속초</td>
          <td class="px-8 py-5 font-body-md text-on-surface-variant">1,420</td>
          <td class="px-8 py-5">
            <div class="flex items-center gap-3">
              <div class="flex-1 bg-surface-container-low rounded-full h-1.5 min-w-[60px]">
                <div class="bg-primary-container h-1.5 rounded-full" style="width: 95%"></div>
              </div>
              <span class="font-label-sm text-primary-container">95%</span>
            </div>
          </td>
          <td class="px-8 py-5">
            <span class="px-3 py-1 bg-secondary-container text-on-secondary-container rounded-full font-label-sm">활성</span>
          </td>
          <td class="px-8 py-5">
            <button class="text-primary-container hover:underline font-label-sm">보고서 보기</button>
          </td>
        </tr>
        </tbody>
      </table>
    </div>
    <!-- Pagination -->
    <div class="px-8 py-6 bg-surface-container-low/20 flex justify-between items-center">
      <p class="text-label-sm text-on-surface-variant">전체 24개 중 1-4 표시</p>
      <div class="flex gap-2">
        <button class="w-10 h-10 flex items-center justify-center rounded-full border border-outline-variant text-on-surface-variant hover:bg-surface-container-low transition-colors">
          <span class="material-symbols-outlined">chevron_left</span>
        </button>
        <button class="w-10 h-10 flex items-center justify-center rounded-full bg-primary-container text-white font-label-md">1</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-full border border-outline-variant text-on-surface-variant hover:bg-surface-container-low transition-colors">2</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-full border border-outline-variant text-on-surface-variant hover:bg-surface-container-low transition-colors">3</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-full border border-outline-variant text-on-surface-variant hover:bg-surface-container-low transition-colors">
          <span class="material-symbols-outlined">chevron_right</span>
        </button>
      </div>
    </div>
  </section>
</main>




</body>


</html>