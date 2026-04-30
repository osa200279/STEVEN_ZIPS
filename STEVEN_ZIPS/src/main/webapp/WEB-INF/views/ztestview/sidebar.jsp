<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<aside class="min-h-screen w-64 fixed left-0 top-0 bg-white border-r border-gray-200 flex flex-col z-40 overflow-y-auto">
  <div class="text-xl font-bold text-[#226046] px-6 h-20 flex items-center bg-[#e6f4ee] border-b border-[#d0e8dd]/30 shrink-0">
    우리집맵핑🏠
  </div>

  <nav class="flex flex-col gap-1 px-3 mt-6 pb-10" id="sidebar-nav">

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">campaign</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">서비스 소개</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"   href="${pageContext.request.contextPath}/apt/intro.do">서비스 소개</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">home_work</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">계약공고</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/contract/notice.do">계약 공고</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">history_edu</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">계약 신청 및 조회</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/contract/apply.do">계약 신청</a>
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap" href="#">계약 조회</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">assignment_turned_in</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">공공주택정보</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/apt/list.do">단지 목록</a>

        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/apt/search.do">단지 검색</a>

        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/apt/dashboard.do">단지별 통계 조회</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">forum</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">시설이력조회</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"href="/apt/facilityHistory.do">시설 유지보수 이력</a>
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap" href="#">시설 점검 기록 확인</a>
      </div>
    </details>

    <details class="nav-item group">
      <summary class="flex items-center justify-between px-3 py-3 rounded-full cursor-pointer hover:bg-white/50 transition-colors">
        <div class="flex items-center gap-2">
          <span class="material-symbols-outlined text-[#226046] text-xl">compare</span>
          <span class="font-bold text-sm text-gray-700 whitespace-nowrap">공지사항</span>
        </div>
        <span class="material-symbols-outlined text-sm transition-transform group-open:rotate-180">expand_more</span>
      </summary>
      <div class="flex flex-col gap-1 mt-1 ml-8 pr-2 mb-2">
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/notice/list.do">공지사항</a>
        <a class="px-3 py-2 text-sm text-gray-600 hover:text-[#226046] hover:bg-white/70 rounded-full transition-all whitespace-nowrap"
           href="${pageContext.request.contextPath}/qna/list.do">문의게시판</a>
      </div>
    </details>
  </nav>

</aside>

<script>
  const detailsList = document.querySelectorAll('#sidebar-nav details');

  // 저장된 상태 불러오기
  detailsList.forEach((d, index) => {
    const isOpen = localStorage.getItem('sidebar_' + index);
    if (isOpen === 'true') {
      d.open = true;
    }
  });

  // 열고 닫을 때 저장
  detailsList.forEach((d, index) => {
    d.addEventListener('toggle', () => {
      localStorage.setItem('sidebar_' + index, d.open);
    });
  });
</script>