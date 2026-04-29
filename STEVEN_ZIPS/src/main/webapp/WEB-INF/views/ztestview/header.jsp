<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="fixed top-0 w-full bg-white z-50 border-b border-gray-100 group transition-all duration-300 hover:shadow-md">

  <div class="max-w-7xl mx-auto flex items-center justify-between px-8 h-20 bg-white relative z-10">

    <div class="text-xl font-bold text-[#226046] w-40">
      우리집맵핑
    </div>

    <nav class="w-[850px]">
      <ul class="grid grid-cols-5 text-center text-base font-semibold text-gray-800">
        <li class="cursor-pointer hover:text-[#226046] py-2">서비스 안내</li>
        <li class="cursor-pointer hover:text-[#226046] py-2">계약 관리</li>
        <li class="cursor-pointer hover:text-[#226046] py-2">단지 정보</li>
        <li class="cursor-pointer hover:text-[#226046] py-2">시설 관리</li>
        <li class="cursor-pointer hover:text-[#226046] py-2">고객 센터</li>
      </ul>
    </nav>

    <div class="flex items-center justify-end gap-4 w-40">
      <button class="text-gray-500 hover:text-[#226046] text-sm font-medium">로그인</button>
      <button class="bg-[#226046] text-white px-5 py-2.5 rounded-full text-sm font-semibold hover:bg-[#1a4a35] transition-colors">
        회원가입
      </button>
    </div>

  </div>

  <div class="absolute left-0 top-full w-full bg-white border-t border-gray-100 shadow-lg invisible opacity-0 -translate-y-2 group-hover:visible group-hover:opacity-100 group-hover:translate-y-0 transition-all duration-300 z-0">
    <div class="max-w-7xl mx-auto flex items-start justify-between px-8 pt-6 pb-8">

      <div class="w-40"></div>

      <div class="w-[850px]">
        <div class="grid grid-cols-5 text-center gap-y-3">

          <div class="flex flex-col space-y-3">
            <a href="${pageContext.request.contextPath}/manage/intro" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">우리집맵핑 소개</a>
            <a href="${pageContext.request.contextPath}/manage/guide" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">이용 안내</a>
          </div>

          <div class="flex flex-col space-y-3">
            <a href="${pageContext.request.contextPath}/fee/guide" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">계약 공고</a>
            <a href="${pageContext.request.contextPath}/service/apply" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">계약 신청</a>
            <a href="${pageContext.request.contextPath}/service/list" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">계약 조회</a>
          </div>

          <div class="flex flex-col space-y-3">
            <a href="${pageContext.request.contextPath}/complex/list" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">단지 목록</a>
            <a href="${pageContext.request.contextPath}/complex/search" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">단지 검색</a>
          </div>

          <div class="flex flex-col space-y-3">
            <a href="${pageContext.request.contextPath}/facility/maintenance" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">유지보수 이력</a>
            <a href="${pageContext.request.contextPath}/facility/repair" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">하자보수 이력</a>
            <a href="${pageContext.request.contextPath}/facility/inspection" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">시설 점검 기록</a>
          </div>

          <div class="flex flex-col space-y-3">
            <a href="${pageContext.request.contextPath}/board/notice" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">공지사항</a>
            <a href="${pageContext.request.contextPath}/board/free" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">문의게시판</a>
            <a href="${pageContext.request.contextPath}/board/faq" class="text-sm text-gray-500 hover:text-[#226046] hover:font-bold">자주 묻는 질문</a>
          </div>

        </div>
      </div>

      <div class="w-40"></div>

    </div>
  </div>

</header>