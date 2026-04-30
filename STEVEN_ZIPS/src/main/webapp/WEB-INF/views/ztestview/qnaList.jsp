<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>

<html lang="ko"><head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <script src="https://cdn.tailwindcss.com"></script>
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            "surface": "#fbf9f1",
            "primary": "#3f4c15",
            "secondary": "#5b614c",
            "secondary-container": "#dfe5cb",
            "on-primary-container": "#cfe09a",
            "primary-container": "#56642b",
            "surface-container-low": "#f6f4eb",
            "on-surface": "#1b1c17",
            "on-surface-variant": "#46483c",
            "outline": "#76786b",
            "outline-variant": "#c7c8b8",
            "surface-container": "#f0eee6",
          }
        }
      }
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; background-color: #fbf9f1; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

    .forest-card {
      border: 1px solid #e2e2e0;
      border-radius: 16px;
      background-color: #ffffff;
      padding: 20px 24px;
      cursor: pointer;
      transition: box-shadow 0.2s;
    }
    .forest-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.08); }

    .status-pill {
      border-radius: 9999px;
      padding: 4px 12px;
      font-size: 12px;
      font-weight: 600;
      display: inline-block;
    }

    .detail { display: none; }
    .detail.open { display: block; }

    .chevron { transition: transform 0.25s; }
    .forest-card.open .chevron { transform: rotate(180deg); }
  </style>
</head>

<body class="bg-surface text-on-surface min-h-screen">

<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebarStyle.jsp" %>

<main class="ml-80 p-10 pt-28">

  <!-- 제목 -->
  <div class="mb-8">
    <h1 class="text-3xl font-bold text-gray-900 mb-2">문의게시판</h1>
    <p class="text-gray-500 text-sm">입주민 문의 내역을 확인하세요.</p>
  </div>

  <!-- 검색 + 버튼 -->
  <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6">
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
      <div class="text-sm text-gray-500">
        총 <strong class="text-black">4</strong>건
      </div>
      <div class="flex items-center gap-3">
        <div class="relative w-64">
          <input class="w-full pl-4 pr-10 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm"
                 placeholder="문의 검색" type="text"/>
          <div class="absolute right-3 top-1/2 -translate-y-1/2">
            <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
            </svg>
          </div>
        </div>
        <button onclick="location.href='${pageContext.request.contextPath}/qna/writeForm.do'"
                class="px-5 py-2 rounded-full bg-[#6F7F3F] text-white text-sm font-medium hover:bg-[#5f6e35]">
          + 새 문의
        </button>
      </div>
    </div>
  </div>

  <!-- ✅ 카드형 아코디언 목록 (샘플 데이터 하드코딩) -->
  <div class="space-y-3">

    <!-- 항목 1: 처리완료 + 답변 있음 -->
    <div class="forest-card" onclick="toggleDetail(this)">
      <div class="flex justify-between items-center">
        <div class="flex-1 min-w-0 pr-4">
          <div class="text-xs text-gray-400 mb-1">NO.128</div>
          <div class="text-base font-semibold text-gray-900">단지 내 가로등 점검 요청</div>
        </div>
        <div class="flex items-center gap-3 flex-shrink-0">
          <div class="flex flex-col items-end gap-1">
            <span class="status-pill bg-[#dfe5cb] text-[#3f4c15]">처리완료</span>
            <div class="text-xs text-gray-400">2023.10.24</div>
          </div>
          <span class="material-symbols-outlined chevron text-gray-400">expand_more</span>
        </div>
      </div>
      <div class="detail mt-5 border-t border-gray-100 pt-5">
        <div class="flex gap-4 mb-5">
          <div class="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0 text-sm">👤</div>
          <p class="text-sm text-gray-700 leading-relaxed pt-1">
            104동 앞 산책로 가로등이 어제저녁부터 깜빡거립니다. 밤에 아이들이 다니기에 조금 어두운 것 같아 빠른 점검 부탁드립니다.
          </p>
        </div>
        <div class="bg-[#f6f4eb] border border-[#e2e2e0] rounded-xl p-5">
          <div class="flex items-center gap-2 mb-2">
            <span class="text-sm font-semibold text-[#3f4c15]">관리실 답변</span>
            <span class="text-xs text-gray-400">2023.10.25 09:30</span>
          </div>
          <p class="text-sm text-gray-700 leading-relaxed">
            안녕하십니까, 입주민님. 시설관리팀입니다. 요청하신 104동 앞 산책로 가로등은 오늘 오전 전구 교체 및 회로 점검을 완료하였습니다. 불편을 드려 죄송하며, 항상 쾌적한 단지 환경을 위해 노력하겠습니다.
          </p>
        </div>
      </div>
    </div>

    <!-- 항목 2: 처리중 + 답변 없음 -->
    <div class="forest-card" onclick="toggleDetail(this)">
      <div class="flex justify-between items-center">
        <div class="flex-1 min-w-0 pr-4">
          <div class="text-xs text-gray-400 mb-1">NO.127</div>
          <div class="text-base font-semibold text-gray-900">커뮤니티 센터 요가 클래스 증설 문의</div>
        </div>
        <div class="flex items-center gap-3 flex-shrink-0">
          <div class="flex flex-col items-end gap-1">
            <span class="status-pill bg-yellow-100 text-yellow-700">처리중</span>
            <div class="text-xs text-gray-400">2023.10.22</div>
          </div>
          <span class="material-symbols-outlined chevron text-gray-400">expand_more</span>
        </div>
      </div>
      <div class="detail mt-5 border-t border-gray-100 pt-5">
        <div class="flex gap-4">
          <div class="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0 text-sm">👤</div>
          <p class="text-sm text-gray-700 leading-relaxed pt-1">
            현재 요가 클래스가 주 2회인데, 수요가 많아 자리가 부족합니다. 클래스 횟수를 늘려주실 수 있을까요?
          </p>
        </div>
        <p class="text-xs text-gray-400 mt-4 ml-13">아직 답변이 등록되지 않았습니다.</p>
      </div>
    </div>

    <!-- 항목 3: 처리완료 -->
    <div class="forest-card" onclick="toggleDetail(this)">
      <div class="flex justify-between items-center">
        <div class="flex-1 min-w-0 pr-4">
          <div class="text-xs text-gray-400 mb-1">NO.126</div>
          <div class="text-base font-semibold text-gray-900">지하주차장 B2 구역 환기 시설 소음</div>
        </div>
        <div class="flex items-center gap-3 flex-shrink-0">
          <div class="flex flex-col items-end gap-1">
            <span class="status-pill bg-[#dfe5cb] text-[#3f4c15]">처리완료</span>
            <div class="text-xs text-gray-400">2023.10.20</div>
          </div>
          <span class="material-symbols-outlined chevron text-gray-400">expand_more</span>
        </div>
      </div>
      <div class="detail mt-5 border-t border-gray-100 pt-5">
        <div class="flex gap-4 mb-5">
          <div class="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0 text-sm">👤</div>
          <p class="text-sm text-gray-700 leading-relaxed pt-1">
            B2 구역 환기 팬에서 며칠째 소음이 납니다. 새벽에 특히 심한 것 같습니다.
          </p>
        </div>
        <div class="bg-[#f6f4eb] border border-[#e2e2e0] rounded-xl p-5">
          <div class="flex items-center gap-2 mb-2">
            <span class="text-sm font-semibold text-[#3f4c15]">관리실 답변</span>
            <span class="text-xs text-gray-400">2023.10.21 14:00</span>
          </div>
          <p class="text-sm text-gray-700 leading-relaxed">
            확인 결과 팬 베어링 마모로 인한 소음이었습니다. 부품 교체 완료하였습니다. 감사합니다.
          </p>
        </div>
      </div>
    </div>

    <!-- 항목 4: 처리중 -->
    <div class="forest-card" onclick="toggleDetail(this)">
      <div class="flex justify-between items-center">
        <div class="flex-1 min-w-0 pr-4">
          <div class="text-xs text-gray-400 mb-1">NO.125</div>
          <div class="text-base font-semibold text-gray-900">재활용 수거함 위치 변경 제안</div>
        </div>
        <div class="flex items-center gap-3 flex-shrink-0">
          <div class="flex flex-col items-end gap-1">
            <span class="status-pill bg-yellow-100 text-yellow-700">처리중</span>
            <div class="text-xs text-gray-400">2023.10.18</div>
          </div>
          <span class="material-symbols-outlined chevron text-gray-400">expand_more</span>
        </div>
      </div>
      <div class="detail mt-5 border-t border-gray-100 pt-5">
        <div class="flex gap-4">
          <div class="w-9 h-9 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0 text-sm">👤</div>
          <p class="text-sm text-gray-700 leading-relaxed pt-1">
            현재 수거함 위치가 어린이 놀이터 바로 옆이라 냄새가 납니다. 다른 위치로 옮겨주시면 좋겠습니다.
          </p>
        </div>
        <p class="text-xs text-gray-400 mt-4">아직 답변이 등록되지 않았습니다.</p>
      </div>
    </div>

  </div>
  <%-- 실제 서버 데이터 쓸 때는 위 하드코딩 대신 아래 c:forEach 사용
  <c:forEach var="qna" items="${qnaList}" varStatus="status">
    ...
  </c:forEach>
  --%>

  <!-- 페이징 -->
  <div class="mt-8 flex justify-center">
    <nav class="flex items-center gap-1">
      <button class="w-10 h-10 flex items-center justify-center rounded-lg border text-gray-400">&lt;</button>
      <button class="w-10 h-10 rounded-full bg-[#6F7F3F] text-white font-semibold">1</button>
      <button class="w-10 h-10 text-gray-600">2</button>
      <button class="w-10 h-10 text-gray-600">3</button>
      <button class="w-10 h-10 flex items-center justify-center rounded-lg border text-gray-400">&gt;</button>
    </nav>
  </div>

</main>
</body>

<script>
  function toggleDetail(card) {
    const detail = card.querySelector('.detail');
    if (!detail) return;

    const isOpen = detail.classList.contains('open');

    if (isOpen) {
      // 닫기
      detail.classList.remove('open');
      card.classList.remove('open');
    } else {
      // 열기 (다른거 건드리지 않음)
      detail.classList.add('open');
      card.classList.add('open');
    }
  }
</script>
</html>
