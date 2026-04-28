<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

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
<!-- SideNavBar Shell -->
<aside class="h-[calc(100vh-64px)] w-80 fixed left-0 top-[64px] bg-surface-container-lowest border-r border-outline-variant/20 flex flex-col py-8 z-40 overflow-y-auto">
  <div class="px-8 mb-8">
    <h1 class="text-2xl font-black text-primary tracking-tighter font-headline">우리집맵핑</h1>
    <p class="text-on-surface-variant/60 text-[10px] font-label font-bold uppercase tracking-[0.2em] mt-1">Premium Concierge</p>
  </div>
  <nav class="flex flex-col gap-1 px-4">
    <!-- 1. 안내 공고 확인 -->
    <details class="nav-item group" open="">
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary" data-icon="campaign">campaign</span>
          <span class="font-label font-bold text-sm">서비스 소개</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform" data-icon="expand_more">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">서비스 소개</a>
      </div>
    </details>
    <!-- 2. 공공주택 정보 조회 -->
    <details class="nav-item group">
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary" data-icon="home_work">home_work</span>
          <span class="font-label font-bold text-sm">계약공고</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform" data-icon="expand_more">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="${pageContext.request.contextPath}/contract/notice.do">계약 공고</a>
      </div>
    </details>
    <!-- 3. 시설 이력 조회 -->
    <details class="nav-item group">
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary" data-icon="history_edu">history_edu</span>
          <span class="font-label font-bold text-sm">계약 신청 및 조회</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform" data-icon="expand_more">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all"  href="${pageContext.request.contextPath}/contract/apply.do">계약 신청</a>
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">계약 조회</a>
      </div>
    </details>
    <!-- 4. 계약 신청 및 조회 -->
    <details class="nav-item group">
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary" data-icon="assignment_turned_in">assignment_turned_in</span>
          <span class="font-label font-bold text-sm">공공주택정보</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform" data-icon="expand_more">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">단지 목록</a>
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">단지 검색</a>
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">단지별 통계 조회</a>
      </div>
    </details>
    <!-- 5. 문의게시판 -->
    <details class="nav-item group">
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary" data-icon="forum">forum</span>
          <span class="font-label font-bold text-sm">시설이력조회</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform" data-icon="expand_more">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">시설 유지보수 이력</a>
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">시설 하자보수 이력</a>
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">시설 점검 기록 확인</a>
      </div>
    </details>
    <!-- 6. 건물 간 비교 조회 -->
    <details class="nav-item group">
      <summary class="flex items-center justify-between px-4 py-3 rounded-full cursor-pointer hover:bg-primary/5 transition-colors text-on-surface">
        <div class="flex items-center gap-3">
          <span class="material-symbols-outlined text-primary" data-icon="compare">compare</span>
          <span class="font-label font-bold text-sm">공지사항</span>
        </div>
        <span class="material-symbols-outlined text-sm expand-icon transition-transform" data-icon="expand_more">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-9 pr-4 mb-2">
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">공지사항</a>
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all" href="#">문의게시판</a>
      </div>
    </details>
  </nav>

</aside>