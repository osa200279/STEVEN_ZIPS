

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="ko"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>시설 관리 이력 조회 - 우리집맵핑</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
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
<!-- SideNavBar Shell -->

<!-- TopNavBar -->

<main class="flex-grow pt-32 pb-20 px-8 ml-80">
    <!-- Page Title & Intro -->
    <div class="mb-12">
        <h1 class="text-5xl font-bold tracking-tight text-on-surface mb-4">시설 유지보수 이력</h1>
        <p class="text-secondary opacity-80 text-lg">우리 단지의 모든 시설 유지보수 및 점검 이력을 투명하게 확인하실 수 있습니다.</p>
    </div>
    <!-- Search/Filter Bar -->
    <section class="bg-surface-container-low p-8 rounded-xl mb-12 flex flex-wrap items-end gap-6 shadow-sm border border-outline-variant/10">
        <div class="flex-1 min-w-[280px]">
            <label class="block text-sm font-semibold text-primary mb-2">조회 기간</label>
            <div class="flex items-center gap-2">
                <input class="w-full bg-surface-container-lowest border-none rounded-lg px-4 py-3 focus:ring-2 focus:ring-primary/20 text-on-surface" type="date"/>
                <span class="text-stone-400">~</span>
                <input class="w-full bg-surface-container-lowest border-none rounded-lg px-4 py-3 focus:ring-2 focus:ring-primary/20 text-on-surface" type="date"/>
            </div>
        </div>
        <div class="flex-1 min-w-[280px]">
            <label class="block text-sm font-semibold text-primary mb-2">시설명 검색</label>
            <div class="relative">
                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-stone-400">search</span>
                <input class="w-full bg-surface-container-lowest border-none rounded-lg pl-10 pr-4 py-3 focus:ring-2 focus:ring-primary/20 text-on-surface" placeholder="검색할 시설명을 입력하세요" type="text"/>
            </div>
        </div>
        <button class="bg-primary text-on-primary px-8 py-3 rounded-full font-semibold hover:opacity-90 transition-all flex items-center gap-2">
            <span class="material-symbols-outlined">filter_alt</span>
            검색하기
        </button>
    </section>
    <!-- Action Bar -->
    <div class="flex justify-between items-center mb-6">
        <div class="text-stone-500 font-medium">전체 <span class="text-primary font-bold">124</span>건의 이력이 있습니다.</div>
        <div class="flex gap-3">
            <button class="bg-surface-container-high text-primary px-5 py-2.5 rounded-full text-sm font-semibold flex items-center gap-2 hover:bg-surface-container-highest transition-colors">
                <span class="material-symbols-outlined text-[20px]">picture_as_pdf</span>
                PDF 출력
            </button>
            <button class="bg-primary-container text-on-primary-container px-5 py-2.5 rounded-full text-sm font-semibold flex items-center gap-2 hover:opacity-90 transition-all">
                <span class="material-symbols-outlined text-[20px]">download</span>
                다운로드
            </button>
        </div>
    </div>
    <!-- History Table -->
    <div class="overflow-x-auto rounded-xl border border-outline-variant/10 shadow-sm bg-surface-container-lowest">
        <table class="w-full text-left border-collapse">
            <thead>
            <tr class="bg-surface-container-high/50 text-stone-600 font-semibold border-b border-outline-variant/10">
                <th class="px-6 py-5 text-sm uppercase tracking-wider">구분</th>
                <th class="px-6 py-5 text-sm uppercase tracking-wider">시설명</th>
                <th class="px-6 py-5 text-sm uppercase tracking-wider">점검일자</th>
                <th class="px-6 py-5 text-sm uppercase tracking-wider">점검내용</th>
                <th class="px-6 py-5 text-sm uppercase tracking-wider">담당자명</th>
                <th class="px-6 py-5 text-sm uppercase tracking-wider text-right">상태</th>
            </tr>
            </thead>
            <tbody class="divide-y divide-outline-variant/10">
            <tr class="hover:bg-surface-container-low/30 transition-colors group cursor-pointer"
                onclick="location.href='/fac/facilityHistoryDetail.do?id=1'">

                <td class="px-6 py-5">
                    <span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-bold">유지보수</span>
                </td>
                <td class="px-6 py-5 font-bold text-primary">제1지하주차장 환풍기</td>
                <td class="px-6 py-5 text-stone-600">2024.03.15</td>
                <td class="px-6 py-5 text-stone-600">노후 베어링 교체 및 윤활유 주입 작업 완료</td>
                <td class="px-6 py-5 text-stone-600">김철수 팀장</td>
                <td class="px-6 py-5 text-right">
                    <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">완료</span>
                </td>
            </tr>
            <tr class="hover:bg-surface-container-low/30 transition-colors group">

                <!-- 구분 추가 (이게 핵심) -->
                <td class="px-6 py-5">
        <span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-bold">
            유지보수
        </span>
                </td>
                <td class="px-6 py-5 font-bold text-primary">중앙광장 바닥분수</td>
                <td class="px-6 py-5 text-stone-600">2024.03.12</td>
                <td class="px-6 py-5 text-stone-600">필터 청소 및 수압 조절 밸브 정기 점검</td>
                <td class="px-6 py-5 text-stone-600">이영희 대리</td>
                <td class="px-6 py-5 text-right">
                    <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">완료</span>
                </td>
            </tr>
            <tr class="hover:bg-surface-container-low/30 transition-colors group">

                <td class="px-6 py-5">
                    <span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-bold">하자보수</span>
                </td>
                </td>
                <td class="px-6 py-5 font-bold text-primary">102동 승강기 #2</td>
                <td class="px-6 py-5 text-stone-600">2024.03.10</td>
                <td class="px-6 py-5 text-stone-600">도어 센서 감도 조절 및 비상통화 장치 테스트</td>
                <td class="px-6 py-5 text-stone-600">현대엘리베이터(박준형)</td>
                <td class="px-6 py-5 text-right">
                    <span class="bg-orange-100 text-orange-700 px-3 py-1 rounded-full text-xs font-bold">보완필요</span>
                </td>
            </tr>
            <tr class="hover:bg-surface-container-low/30 transition-colors group">
                <td class="px-6 py-5">
        <span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-bold">
            유지보수
        </span>
                </td>
                <td class="px-6 py-5 font-bold text-primary">어린이놀이터 (해든마루)</td>
                <td class="px-6 py-5 text-stone-600">2024.03.05</td>
                <td class="px-6 py-5 text-stone-600">놀이기구 고정 상태 및 탄성포장재 균열 정기 점검</td>
                <td class="px-6 py-5 text-stone-600">최민수 주임</td>
                <td class="px-6 py-5 text-right">
                    <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">완료</span>
                </td>
            </tr>

            <tr>

                <td class="px-6 py-5">
                    <span class="bg-red-100 text-red-700 px-3 py-1 rounded-full text-xs font-bold">하자보수</span>
                </td>

                <td class="px-6 py-5 font-bold text-primary">화장실 누수</td>
                <td class="px-6 py-5 text-stone-600">2024.03.18</td>
                <td class="px-6 py-5 text-stone-600">배관 누수 발생</td>
                <td class="px-6 py-5 text-stone-600">박설비 기사</td>
                <td class="px-6 py-5 text-right">
                    <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-bold">
                        처리중
                    </span>
                                </td>
            </tr>



            <tr class="hover:bg-surface-container-low/30 transition-colors group">
                <td class="px-6 py-5">
        <span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-xs font-bold">
            유지보수
        </span>
                <td class="px-6 py-5 font-bold text-primary">단지 내 가로등 (동쪽 산책로)</td>
                <td class="px-6 py-5 text-stone-600">2024.02.28</td>
                <td class="px-6 py-5 text-stone-600">LED 모듈 교체 (총 5개소) 및 타이머 설정 확인</td>
                <td class="px-6 py-5 text-stone-600">김철수 팀장</td>
                <td class="px-6 py-5 text-right">
                    <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">완료</span>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
    <!-- Pagination -->
    <div class="mt-10 flex justify-center items-center gap-2">
        <button class="w-10 h-10 flex items-center justify-center rounded-lg hover:bg-surface-container-high transition-colors text-stone-400">
            <span class="material-symbols-outlined">chevron_left</span>
        </button>
        <button class="w-10 h-10 flex items-center justify-center rounded-lg bg-primary text-on-primary font-bold">1</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-lg hover:bg-surface-container-high transition-colors text-stone-600">2</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-lg hover:bg-surface-container-high transition-colors text-stone-600">3</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-lg hover:bg-surface-container-high transition-colors text-stone-600">4</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-lg hover:bg-surface-container-high transition-colors text-stone-600">5</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-lg hover:bg-surface-container-high transition-colors text-stone-400">
            <span class="material-symbols-outlined">chevron_right</span>
        </button>
    </div>
</main>
<!-- Footer -->

</body></html>