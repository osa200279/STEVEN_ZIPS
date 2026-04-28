<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "surface-bright": "#fbf9f1",
            "outline-variant": "#c6c8b8",
            "on-error-container": "#93000a",
            "on-primary-fixed-variant": "#3f4c15",
            "secondary-fixed": "#d0e9d2",
            "secondary-container": "#d0e9d2",
            "on-secondary-container": "#546a58",
            "on-surface": "#1b1c1a",
            "surface-variant": "#e4e3da",
            "on-primary": "#ffffff",
            "outline": "#76786b",
            "on-surface-variant": "#46483c",
            "error-container": "#ffdad6",
            "on-tertiary-container": "#aae6c3",
            "primary-container": "#8a9a5b",
            "on-secondary": "#ffffff",
            "secondary": "#4e6452",
            "on-primary-fixed": "#161e00",
            "background": "#fbf9f5",
            "error": "#ba1a1a",
            "surface-tint": "#56642b",
            "on-tertiary-fixed": "#002112",
            "inverse-on-surface": "#f3f1e9",
            "on-secondary-fixed-variant": "#364c3b",
            "inverse-surface": "#30312b",
            "primary-fixed": "#d9eaa3",
            "on-secondary-fixed": "#0b2012",
            "on-tertiary-fixed-variant": "#145136",
            "surface-dim": "#dcdad2",
            "on-primary-container": "#cfe09a",
            "surface-container-lowest": "#ffffff",
            "surface-container": "#f0eee6",
            "surface-container-low": "#f6f4eb",
            "tertiary-container": "#30694d",
            "on-tertiary": "#ffffff",
            "primary-fixed-dim": "#bdce89",
            "on-error": "#ffffff",
            "tertiary-fixed-dim": "#98d3b1",
            "surface-container-high": "#eae8e0",
            "secondary-fixed-dim": "#b4cdb7",
            "tertiary-fixed": "#b3f0cc",
            "tertiary": "#30694d",
            "on-background": "#1b1c17",
            "inverse-primary": "#bdce89",
            "surface": "#fbf9f5",
            "primary": "#3f4c15",
            "surface-container-highest": "#e4e3da"
          },
          "borderRadius": {
            "DEFAULT": "0.25rem",
            "lg": "0.5rem",
            "xl": "0.75rem",
            "full": "9999px"
          },
          "spacing": {
            "base": "4px",
            "gutter": "1.5rem",
            "md": "1.5rem",
            "xs": "0.5rem",
            "sm": "1rem",
            "xl": "4rem",
            "margin": "2rem",
            "lg": "2.5rem"
          },
          "fontFamily": {
            "body-lg": ["Manrope"],
            "h2": ["Manrope"],
            "h1": ["Manrope"],
            "label-small": ["Manrope"],
            "body-md": ["Manrope"],
            "h3": ["Manrope"]
          },
          "fontSize": {
            "body-lg": ["1rem", {"lineHeight": "1.6", "fontWeight": "400"}],
            "h2": ["1.25rem", {"lineHeight": "1.4", "fontWeight": "700"}],
            "h1": ["3rem", {"lineHeight": "1.1", "letterSpacing": "-0.025em", "fontWeight": "700"}],
            "label-small": ["10px", {"lineHeight": "1rem", "letterSpacing": "0.1em", "fontWeight": "900"}],
            "body-md": ["0.875rem", {"lineHeight": "1.5", "fontWeight": "400"}],
            "h3": ["1.125rem", {"lineHeight": "1.5", "fontWeight": "600"}]
          }
        },
      },
    }
  </script>
  <style>
    body {
      background-color: #f8f7f4;
      font-family: 'Manrope', sans-serif;
    }
    .material-symbols-outlined {
      font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }
    .custom-scrollbar::-webkit-scrollbar {
      width: 4px;
    }
    .custom-scrollbar::-webkit-scrollbar-track {
      background: transparent;
    }
    .custom-scrollbar::-webkit-scrollbar-thumb {
      background: #e4e3da;
      border-radius: 10px;
    }
  </style>
</head>
  <%@ include file="/WEB-INF/views/ztestview/sidebarStyle.jsp" %>

  <body class="bg-[#f8faf6]">

  <%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
  <%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>
<!-- Main Content Area (Single Column Layout) -->
  <main class="ml-80 p-10 pt-28 bg-[#f8faf6] flex flex-col gap-10">
  <!-- Header & Title -->
  <div class="flex flex-col gap-2">
    <h2 class="font-h1 text-4xl text-primary">문의게시판</h2>
    <p class="text-on-surface-variant font-body-lg">우리집맵핑 입주민 및 파트너사의 소중한 의견을 신속하게 확인하고 처리합니다.</p>
  </div>
  <!-- Inquiry List Section -->
  <section class="flex flex-col gap-6">
    <!-- Filters & Search -->
    <div class="bg-white rounded-2xl shadow-sm p-4 flex flex-col md:flex-row items-center justify-between gap-4 border border-outline-variant/30">
      <div class="flex p-1 bg-surface-container rounded-full w-full md:w-auto">
        <button class="flex-1 md:flex-none px-4 py-2 rounded-full text-sm font-bold bg-primary text-white shadow-sm">전체</button>
        <button class="flex-1 md:flex-none px-4 py-2 rounded-full text-sm font-medium text-on-surface-variant hover:text-primary transition-colors">답변대기</button>
        <button class="flex-1 md:flex-none px-4 py-2 rounded-full text-sm font-medium text-on-surface-variant hover:text-primary transition-colors">답변완료</button>
        <button class="flex-1 md:flex-none px-4 py-2 rounded-full text-sm font-medium text-on-surface-variant hover:text-primary transition-colors">내 문의</button>
      </div>
      <div class="flex gap-2 w-full md:w-auto">
        <div class="relative flex-1 md:w-64">
          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline text-sm" data-icon="search">search</span>
          <input class="w-full bg-surface-container-low border-none rounded-full py-2 pl-9 pr-4 text-sm focus:ring-2 focus:ring-primary-container transition-all" placeholder="검색어 입력" type="text"/>
        </div>
        <button class="flex items-center gap-2 px-4 py-2 border border-outline-variant rounded-full text-sm font-medium text-on-surface-variant hover:bg-surface-container transition-all">
          <span class="material-symbols-outlined text-sm" data-icon="filter_list">filter_list</span>
          최신순
        </button>
      </div>
    </div>
    <!-- Table Container -->
    <div class="bg-white rounded-2xl shadow-sm overflow-hidden border border-outline-variant/30">
      <div class="overflow-x-auto">
        <table class="w-full text-left border-collapse min-w-[600px]">
          <thead>
          <tr class="bg-surface-container/50 border-b border-outline-variant/30">
            <th class="px-4 py-4 font-label-small text-outline uppercase tracking-wider text-center w-16">No</th>
            <th class="px-4 py-4 font-label-small text-outline uppercase tracking-wider">제목</th>
            <th class="px-4 py-4 font-label-small text-outline uppercase tracking-wider w-28">작성자</th>
            <th class="px-4 py-4 font-label-small text-outline uppercase tracking-wider w-32">등록일</th>
            <th class="px-4 py-4 font-label-small text-outline uppercase tracking-wider w-28 text-center">상태</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-outline-variant/20">

<c:forEach var="n" items="${noticeList}" varStatus="status">
    <tr class="hover:bg-gray-50">
        <td class="px-4 py-3 text-center">
            ${status.count}
        </td>
        <td class="px-4 py-3">
            ${n.title}
        </td>
        <td class="px-4 py-3 text-center">
            ${n.regDate}
        </td>
    </tr>
</c:forEach>
</tbody>

        </table>
      </div>
      <div class="px-4 py-4 flex flex-col sm:flex-row items-center justify-between bg-surface-container-lowest gap-4">
        <span class="text-sm text-on-surface-variant">총 <strong>1,240</strong>건의 문의</span>
        <div class="flex gap-1">
          <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container"><span class="material-symbols-outlined text-lg" data-icon="chevron_left">chevron_left</span></button>
          <button class="w-8 h-8 flex items-center justify-center rounded-lg bg-primary text-white text-sm font-bold shadow-sm">1</button>
          <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container text-sm">2</button>
          <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container text-sm">3</button>
          <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container text-sm">4</button>
          <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container"><span class="material-symbols-outlined text-lg" data-icon="chevron_right">chevron_right</span></button>
        </div>
      </div>
    </div>
  </section>
  <!-- Detail View Section (Flowing Naturally Below) -->
  <section class="bg-[#fcfbf9] rounded-lg shadow-sm p-4 border border-primary/20 relative overflow-hidden">
    <div class="absolute top-0 right-0 p-4">
      <span class="inline-flex items-center px-2 py-0.5 rounded-md bg-orange-100 text-orange-700 text-[10px] font-bold">CURRENT SELECTION</span>
    </div>
    <div class="mb-4">
      <div class="flex items-center flex-wrap gap-2 text-on-surface-variant text-xs mb-3">
        <div class="flex items-center gap-1">
          <span class="material-symbols-outlined text-xs" data-icon="person">person</span>
          <span>이수호 (No.42)</span>
        </div>
        <span class="hidden sm:inline mx-1 text-outline-variant">•</span>
        <div class="flex items-center gap-1">
          <span class="material-symbols-outlined text-xs" data-icon="calendar_today">calendar_today</span>
          <span>2024.05.21 14:30</span>
        </div>
      </div>
      <h3 class="font-h2 text-2xl md:text-3xl text-primary leading-tight">프리미엄 지도 데이터 업데이트 주기 문의</h3>
    </div>
    <div class="font-body-md text-on-surface leading-relaxed mb-10 max-w-3xl">
      안녕하세요. 이번에 새로 입주한 입주민입니다.<br/><br/>
      우리집맵핑 프리미엄 서비스에서 제공하는 지도 데이터의 업데이트 주기가 궁금합니다.
      최근에 단지 내 상가 리모델링이 완료되었는데, 맵핑 상에는 아직 이전 모습으로 보여서요.<br/><br/>
      주기적인 업데이트 일정이 있는지, 아니면 사용자 요청 시 반영되는지 답변 부탁드립니다.
    </div>
    <div class="bg-white/80 rounded-xl p-4 border border-outline-variant/30 shadow-inner">
      <div class="flex items-center gap-2 mb-4">
        <span class="material-symbols-outlined text-secondary" data-icon="support_agent">support_agent</span>
        <span class="font-h3 text-secondary text-base">관리자 답변</span>
      </div>
      <div class="font-body-md text-on-surface-variant text-sm italic mb-6">
        문의 내용을 확인 중입니다. 잠시만 기다려 주세요...
      </div>
      <div class="pt-6 border-t border-outline-variant/20">
        <label class="block font-label-small text-outline mb-2">답변 작성</label>
        <textarea class="w-full bg-surface-container-low border-none rounded-xl p-4 text-sm focus:ring-2 focus:ring-secondary transition-all resize-none mb-4 custom-scrollbar" placeholder="답변을 입력하세요 (관리자 전용)" rows="2"></textarea>
        <div class="flex justify-end">
          <button class="px-8 py-3 bg-secondary text-white text-sm font-bold rounded-xl hover:bg-secondary/90 active:scale-95 transition-all shadow-md">답변 완료 처리</button>
        </div>
      </div>
    </div>
  </section>
  <!-- New Inquiry Form Section -->
    <!-- 수정 -->
    <section class="bg-white rounded-lg shadow-sm p-4 border border-outline-variant/30 mb-6">
    <div class="flex items-center gap-3 mb-8">
      <div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
        <span class="material-symbols-outlined text-primary" data-icon="edit_square">edit_square</span>
      </div>
      <h3 class="font-h3 text-xl text-on-surface">신규 문의 작성</h3>
    </div>
    <div class="grid grid-cols-1 gap-4">
      <div>
        <label class="block font-label-small text-outline mb-2">문의 제목</label>
        <input class="w-full bg-surface-container border-none rounded-xl py-4 px-5 text-sm focus:ring-2 focus:ring-primary transition-all" placeholder="문의 제목을 입력하세요" type="text"/>
      </div>
      <div>
        <label class="block font-label-small text-outline mb-2">상세 문의 내용</label>
        <textarea class="w-full bg-surface-container border-none rounded-xl py-4 px-5 text-sm focus:ring-2 focus:ring-primary transition-all resize-none custom-scrollbar" placeholder="문의하실 내용을 상세히 적어주세요. 신속하고 정확한 답변에 도움이 됩니다." rows="8"></textarea>
      </div>
      <div class="flex flex-col sm:flex-row gap-2 mb-4">
        <button class="flex-1 py-4 rounded-xl border border-outline-variant text-sm font-bold text-on-surface-variant hover:bg-surface-container transition-all">작성 취소</button>
        <button class="flex-[2] py-4 rounded-xl bg-primary text-white text-sm font-bold shadow-lg hover:brightness-110 active:scale-[0.98] transition-all">문의 등록하기</button>
      </div>
    </div>
  </section>
</main>
</body></html>