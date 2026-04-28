

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="fixed top-0 w-full bg-white z-50 border-b border-gray-100">

  <div class="max-w-7xl mx-auto flex items-center justify-between px-8 py-4">

    <!-- 로고 -->
    <div class="text-xl font-bold text-[#226046]">
      우리집맵핑
    </div>

    <!-- 메뉴 -->
    <div class="flex items-center gap-8 text-sm font-medium text-gray-600">

      <!-- 서비스 소개 -->
      <div class="relative group">
        <span class="cursor-pointer hover:text-[#226046] border-b-2 border-transparent group-hover:border-[#226046] pb-1">
          서비스 소개
        </span>

        <div class="absolute hidden group-hover:block top-full mt-3 w-48 bg-white rounded-xl shadow-lg border p-2">
          <a href="${pageContext.request.contextPath}/manage/intro"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            서비스 소개
          </a>
        </div>
      </div>

      <!-- 계약공고 -->
      <div class="relative group">
        <span class="cursor-pointer hover:text-[#226046] border-b-2 border-transparent group-hover:border-[#226046] pb-1">
          계약공고
        </span>

        <div class="absolute hidden group-hover:block top-full mt-3 w-48 bg-white rounded-xl shadow-lg border p-2">
          <a href="${pageContext.request.contextPath}/fee/guide"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            계약공고
          </a>
        </div>
      </div>

      <!-- 계약 신청 및 조회 -->
      <div class="relative group">
        <span class="cursor-pointer hover:text-[#226046] border-b-2 border-transparent group-hover:border-[#226046] pb-1">
          계약 신청 및 조회
        </span>

        <div class="absolute hidden group-hover:block top-full mt-3 w-56 bg-white rounded-xl shadow-lg border p-2">
          <a href="${pageContext.request.contextPath}/service/moving"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            계약 신청
          </a>
          <a href="${pageContext.request.contextPath}/service/car"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            계약 조회
          </a>
        </div>
      </div>

      <!-- 단지찾기 -->
      <div class="relative group">
        <span class="cursor-pointer hover:text-[#226046] border-b-2 border-transparent group-hover:border-[#226046] pb-1">
          단지찾기
        </span>

        <div class="absolute hidden group-hover:block top-full mt-3 w-48 bg-white rounded-xl shadow-lg border p-2">
          <a href="${pageContext.request.contextPath}/complaint/apply"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            단지목록
          </a>
          <a href="${pageContext.request.contextPath}/complaint/live"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            단지검색
          </a>
        </div>
      </div>

      <!-- 시설이력조회 -->
      <div class="relative group">
        <span class="cursor-pointer hover:text-[#226046] border-b-2 border-transparent group-hover:border-[#226046] pb-1">
          시설이력조회
        </span>

        <div class="absolute hidden group-hover:block top-full mt-3 w-56 bg-white rounded-xl shadow-lg border p-2">
          <a href="${pageContext.request.contextPath}/vote/resident"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            시설 유지보수 이력
          </a>
          <a href="${pageContext.request.contextPath}/vote/resident"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            시설 하자보수 이력
          </a>
          <a href="${pageContext.request.contextPath}/vote/survey"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            시설 점검 기록
          </a>
        </div>
      </div>

      <!-- 공지사항 -->
      <div class="relative group">
        <span class="cursor-pointer hover:text-[#226046] border-b-2 border-transparent group-hover:border-[#226046] pb-1">
          공지사항
        </span>

        <div class="absolute hidden group-hover:block top-full mt-3 w-48 bg-white rounded-xl shadow-lg border p-2">
          <a href="${pageContext.request.contextPath}/board/notice"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            공지사항
          </a>
          <a href="${pageContext.request.contextPath}/board/free"
             class="block px-3 py-2 rounded-lg hover:bg-gray-100">
            문의게시판
          </a>
        </div>
      </div>

    </div>

    <!-- 오른쪽 -->
    <div class="flex items-center gap-4">
      <button class="text-gray-500 hover:text-[#226046] text-sm">로그인</button>
      <button class="bg-[#226046] text-white px-5 py-2 rounded-full text-sm font-semibold">
        회원가입
      </button>
    </div>

  </div>
</header>