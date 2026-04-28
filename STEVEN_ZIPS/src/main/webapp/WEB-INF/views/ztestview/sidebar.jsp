<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>




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
        <a class="px-4 py-2 text-sm ..."
           href="${pageContext.request.contextPath}/contract/notice.do">
          계약 공고
        </a>
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
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all"
           href="${pageContext.request.contextPath}/notice/list.do">
          공지사항
        </a>
        <a class="px-4 py-2 text-sm text-on-surface-variant/80 hover:text-primary hover:bg-primary/5 rounded-full transition-all"
           href="${pageContext.request.contextPath}/qna/list.do">
          문의게시판
        </a>
      </div>
    </details>
  </nav>

</aside>