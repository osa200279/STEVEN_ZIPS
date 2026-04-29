<%--
  Created by IntelliJ IDEA.
  User: lyr52
  Date: 2026-04-29
  Time: 오전 1:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!-- TopNavBar -->
<header class="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-xl shadow-[0_4px_30px_rgba(0,0,0,0.04)]">
    <nav class="flex justify-between items-center px-8 py-4 max-w-7xl mx-auto">
        <!-- 로고 -->
        <div class="text-xl font-bold tracking-tight text-primary font-headline flex-none">
            우리집맵핑
        </div>
        <!-- 메뉴 전체를 group으로 감싸야 메가메뉴 유지됨 -->
        <div class="hidden md:flex items-center justify-center flex-1 relative group">
            <!-- 상단 메뉴 -->
            <div class="flex gap-8 py-2">
                <a class="text-primary font-bold border-b-2 border-primary pb-1 cursor-pointer transition-colors hover:text-primary">
                    서비스 소개
                </a>
                <a class="text-slate-600 hover:text-primary cursor-pointer transition-colors">
                    계약공고
                </a>
                <a class="text-slate-600 hover:text-primary cursor-pointer transition-colors">계약
                    신청 및 조회</a>
                <a class="text-slate-600 hover:text-primary cursor-pointer transition-colors">아파트 찾기</a>
                <a class="text-slate-600 hover:text-primary cursor-pointer transition-colors">시설이력조회</a>
                <a class="text-slate-600 hover:text-primary cursor-pointer transition-colors">공지사항</a>
            </div>
            <!-- 🔥 메가메뉴 -->
            <div
                    class="mega-menu absolute left-1/2 -translate-x-1/2 top-full w-screen bg-[#226046ee] backdrop-blur-md border-t border-white/10">
                <div
                        class="max-w-7xl mx-auto px-8 py-10 grid grid-cols-6 gap-10 text-sm text-white">
                    <div class="space-y-4">
                        <h4 class="font-bold text-base border-b border-white/20 pb-2">서비스
                            소개</h4>
                    </div>
                    <div class="space-y-4">
                        <h4 class="font-bold text-base border-b border-white/20 pb-2">계약공고</h4>
                        <div class="flex flex-col gap-2 opacity-80">
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">계약
                                공고</p>
                        </div>
                    </div>
                    <div class="space-y-4">
                        <h4 class="font-bold text-base border-b border-white/20 pb-2">계약
                            신청 및 조회</h4>
                        <div class="flex flex-col gap-2 opacity-80">
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">계약
                                신청하기</p>
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">계약
                                조회</p>
                        </div>
                    </div>
                    <div class="space-y-4">
                        <h4 class="font-bold text-base border-b border-white/20 pb-2">아파트 찾기</h4>
                        <div class="flex flex-col gap-2 opacity-80">
                            <p class="hover:text-white hover:underline cursor-pointer transition-all">
                                아파트 목록
                            </p>
                            <p class="hover:text-white hover:underline cursor-pointer transition-all">
                                아파트 검색
                            </p>
                        </div>
                    </div>
                    <div class="space-y-4">
                        <h4 class="font-bold text-base border-b border-white/20 pb-2">시설이력
                            조회</h4>
                        <div class="flex flex-col gap-2 opacity-80">
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">시설
                                유지보수 이력</p>
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">시설
                                하자보수 이력</p>
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">시설
                                점검 기록 확인</p>
                        </div>
                    </div>
                    <div class="space-y-4">
                        <h4 class="font-bold text-base border-b border-white/20 pb-2">공지사항</h4>
                        <div class="flex flex-col gap-2 opacity-80">
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">공지사항</p>
                            <p
                                    class="hover:text-white hover:underline cursor-pointer transition-all">문의게시판</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- 오른쪽 버튼 -->
        <div class="flex items-center gap-4 flex-none">
            <sec:authorize access="isAnonymous()">
                <button type="button" id="loginFormBtn" class="text-slate-600 hover:text-primary px-4 py-2 text-sm font-medium">
                    로그인
                </button>
                <button type="button" id="joinFormBtn" class="bg-primary text-white px-6 py-2.5 rounded-full font-semibold hover:bg-primary/90 transition-colors">
                    회원가입
                </button>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <button type="button" id="myPageBtn" href="/member/myPage.do" class="bg-primary text-white px-6 py-2.5 rounded-full font-semibold hover:bg-primary/90 transition-colors">
                    마이페이지
                </button>
                <button type="button" id="logoutBtn" class="text-slate-600 hover:text-primary px-4 py-2 text-sm font-medium">
                    로그아웃
                </button>
                <%-- 로그아웃을 위한 히든 폼 --%>
                <form id="logoutForm" action="/logout" method="post" style="display: none;">
                    <sec:csrfInput/>
                </form>
            </sec:authorize>
        </div>
    </nav>
    <script src="${pageContext.request.contextPath}/js/common/conn.js"></script>
</header>
