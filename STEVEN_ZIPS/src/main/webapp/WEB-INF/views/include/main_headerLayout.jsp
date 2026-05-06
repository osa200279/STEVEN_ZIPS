<%--
  Created by IntelliJ IDEA.
  User: 이용로
  Date: 2026-04-29
  Time: 오전 1:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- TopNavBar -->
<header class="fixed top-0 w-full z-50 bg-white/80 backdrop-blur-xl shadow-[0_4px_30px_rgba(0,0,0,0.04)]">
    <nav class="flex justify-between items-center px-8 py-4 max-w-7xl mx-auto">
        <!-- 로고 -->
        <div class="text-xl font-bold tracking-tight text-primary font-headline flex-none">
            <a href="/">우리집맵핑</a>
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
                <a class="text-slate-600 hover:text-primary cursor-pointer transition-colors">공공주택 정보</a>
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
                        <h4 class="font-bold text-base border-b border-white/20 pb-2">공공주택 정보</h4>
                        <div class="flex flex-col gap-2 opacity-80">
                            <p class="hover:text-white hover:underline cursor-pointer transition-all">
                                단지 목록
                            </p>
                            <p class="hover:text-white hover:underline cursor-pointer transition-all">
                                단지 검색
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
                <button type="button" id="loginFormBtn"
                        class="text-slate-600 hover:text-primary px-4 py-2 text-sm font-medium">
                    로그인
                </button>
                <button type="button" id="joinFormBtn"
                        class="bg-primary text-white px-6 py-2.5 rounded-full font-semibold hover:bg-primary/90 transition-colors">
                    회원가입
                </button>
            </sec:authorize>

            <sec:authorize access="isAuthenticated()">
                <button type="button" id="myAptBtn"
                        class="text-slate-600 hover:text-primary px-4 py-2 text-sm font-medium">🏢나의 아파트️
                </button>
                <button type="button" id="myPageBtn"
                        class="bg-primary text-white px-6 py-2.5 rounded-full font-semibold hover:bg-primary/90 transition-colors">
                    마이페이지
                </button>
                <button type="button" id="logoutBtn"
                        class="text-slate-600 hover:text-primary px-4 py-2 text-sm font-medium">
                    로그아웃
                </button>
                <%-- 로그아웃을 위한 히든 폼 --%>
                <form id="logoutForm" action="/logout" method="post" style="display: none;">
                    <sec:csrfInput/>
                </form>
            </sec:authorize>

            <script>
                document.addEventListener("DOMContentLoaded", () => {
                    const myAptBtn = document.getElementById("myAptBtn");
                    if (myAptBtn) {
                        myAptBtn.addEventListener("click", openAptSelection);
                    }
                });

                // 팝업창을 중앙에 띄우는 함수
                function openAptSelection() {
                    const width = 600;
                    const height = 400;
                    const left = (window.screen.width / 2) + 100;
                    const top = (window.screen.height / 2) - height;

                    const url = "${pageContext.request.contextPath}/resident/myApt";
                    const features = "width=" + width +
                     ",height=" + height +
                     ",left=" + left +
                     ",top=" + top +
                     ",resizable=yes,scrollbars=yes";

                    // 'aptSelectionPopup'이라는 이름의 팝업창을 엽니다.
                    window.open(url, "aptSelectionPopup", features);
                }
            </script>

        </div>
    </nav>
    <script src="${pageContext.request.contextPath}/js/common/conn.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</header>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const myAptBtn = document.getElementById("myAptBtn");

        if (myAptBtn) {
            myAptBtn.addEventListener("click", openAptSelection);
        }


    });

    function selectApt(aptCmplexNo) {
        // 1. 나를 열어준 부모창(opener)의 주소를 이동시킴
        // 팁: 부모창이 이미 메인이라면 이동하고, 아니면 메인으로 보냅니다.
        if (window.opener && !window.opener.closed) {
            window.opener.location.href = "${pageContext.request.contextPath}/main?aptCmplexNo=" + aptCmplexNo;

            // 2. 팝업은 임무 완료 후 퇴장
            window.close();
        } else {
            alert("부모 창을 찾을 수 없습니다. 메인 페이지를 새로고침 해주세요.");
        }
    }
</script>
<jsp:include page="/WEB-INF/views/include/websocket.jsp"/>
