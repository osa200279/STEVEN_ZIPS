<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
  <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Manrope:wght@400;500;600;700&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
  <script id="tailwind-config">
    tailwind.config = {
      darkMode: "class",
      theme: {
        extend: {
          "colors": {
            "outline-variant": "#bfc9c1",
            "inverse-primary": "#95d4b3",
            "background": "#f8faf6",
            "secondary-container": "#aeedd5",
            "on-secondary-container": "#316d5b",
            "surface-container": "#eceeea",
            "surface-container-high": "#e7e9e5",
            "surface-container-highest": "#e1e3df",
            "surface-container-low": "#f2f4f0",
            "surface-container-lowest": "#ffffff",
            "on-surface": "#191c1a",
            "on-surface-variant": "#404943",
            "outline": "#707973",
            "primary": "#004830",
            "on-primary": "#ffffff",
            "primary-container": "#226046",
            "on-primary-container": "#99d8b7",
            "primary-fixed": "#b1f0ce",
            "primary-fixed-dim": "#95d4b3",
            "secondary": "#2c6956",
            "on-secondary": "#ffffff",
            "surface": "#f8faf6",
            "surface-bright": "#f8faf6",
            "surface-dim": "#d8dbd7",
            "surface-variant": "#e1e3df",
            "surface-tint": "#2c694f",
            "error": "#ba1a1a",
            "error-container": "#ffdad6",
            "on-error": "#ffffff",
            "on-error-container": "#93000a",
            "tertiary": "#652d2e",
            "tertiary-container": "#814344",
            "on-tertiary": "#ffffff",
            "on-tertiary-container": "#ffb8b8",
            "inverse-surface": "#2e312f",
            "inverse-on-surface": "#eff1ed",
            "on-background": "#191c1a"
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
        }
      }
    }
  </script>
  <style>
    body { font-family: 'Manrope', sans-serif; background-color: #f8faf6; color: #191c1a; }
    .font-headline { font-family: 'Plus Jakarta Sans', sans-serif; }
    .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

    /* Timeline dot */
    .timeline-item::before {
      content: '';
      position: absolute;
      left: -6px;
      top: 50%;
      transform: translateY(-50%);
      width: 12px;
      height: 12px;
      border-radius: 50%;
      background: #95d4b3;
      border: 2px solid #226046;
    }
    .timeline-item.active::before {
      background: #226046;
      box-shadow: 0 0 0 4px rgba(34,96,70,0.15);
    }

    /* Tab underline */
    .tab-btn.active {
      color: #004830;
      border-bottom: 2.5px solid #226046;
      font-weight: 700;
    }
    .tab-btn {
      color: #9ca3af;
      border-bottom: 2.5px solid transparent;
      transition: all 0.18s;
    }
    .tab-btn:hover { color: #226046; }

    /* File hover */
    .file-row:hover { background: #f1f3ef; }

    /* Fade in */
    .tab-panel { display: none; }
    .tab-panel.active { display: block; animation: fadeIn .22s ease; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: none; } }

    /* Print */
    @media print {
      .no-print { display: none !important; }
      .ml-80 { margin-left: 0 !important; }
    }
  </style>
</head>

<body class="bg-background text-on-background selection:bg-primary-fixed selection:text-on-primary-fixed overflow-x-hidden">

<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>

<div class="ml-80 min-h-screen flex flex-col">
  <main class="flex-1 p-8 pt-28 space-y-6">

    <!-- Breadcrumb & Back -->
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-2 text-xs text-slate-400">
        <span>Home</span><span>›</span>
        <span>공지사항</span><span>›</span>
        <a href="#" class="hover:text-primary-container transition-colors">계약공고</a><span>›</span>
        <span class="text-primary-container font-semibold">상세보기</span>
      </div>
      <a href="#" class="no-print flex items-center gap-1.5 text-sm text-slate-500 hover:text-primary-container transition-colors font-medium">
        <span class="material-symbols-outlined text-[18px]">arrow_back</span>
        목록으로
      </a>
    </div>

    <!-- ── Hero Header Card ── -->
    <section class="bg-white rounded-lg border border-[#eef2eb] shadow-[0px_4px_20px_rgba(0,72,48,0.04)] overflow-hidden">
      <!-- Top accent bar -->
      <div class="h-1.5 w-full bg-gradient-to-r from-[#004830] via-[#226046] to-[#95d4b3]"></div>

      <div class="p-8">
        <!-- Status row -->
        <div class="flex flex-wrap items-center gap-2 mb-4">
          <span class="text-xs font-bold bg-[#eef2eb] text-[#004830] px-3 py-1 rounded">용역</span>
          <span class="bg-secondary-container text-on-secondary-container text-[11px] font-bold px-3 py-1 rounded-full">공고중</span>
          <span class="ml-auto text-xs text-slate-400 flex items-center gap-1">
            <span class="material-symbols-outlined text-[15px]">visibility</span> 1,240 조회
          </span>
        </div>

        <!-- Title -->
        <h1 class="font-headline text-2xl font-bold text-[#004830] leading-snug mb-6">
          서초그랑자이 단지 내 조경관리 용역업체 선정 공고
        </h1>

        <!-- Meta grid -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">공고번호</p>
            <p class="text-sm font-bold text-[#004830]">2024-085</p>
          </div>
          <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">지역</p>
            <p class="text-sm font-bold text-[#004830] flex items-center gap-1">
              <span class="material-symbols-outlined text-[15px] text-slate-400">location_on</span>서울 서초구
            </p>
          </div>
          <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">게시일</p>
            <p class="text-sm font-bold text-[#004830]">2024.05.20</p>
          </div>
          <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
            <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">마감일</p>
            <p class="text-sm font-bold text-[#004830] flex items-center gap-1">
              <span class="material-symbols-outlined text-[15px] text-slate-400">timer</span>2024.06.05
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- ── Layout: Left Content + Right Sidebar ── -->
    <div class="grid grid-cols-3 gap-6 items-start">

      <!-- ── LEFT: Tabs + Content ── -->
      <div class="col-span-2 space-y-6">

        <!-- Tab Navigation -->
        <div class="bg-white rounded-lg border border-[#eef2eb] shadow-sm overflow-hidden">
          <div class="flex border-b border-[#eef2eb] px-6 no-print">
            <button class="tab-btn active px-5 py-4 text-sm" data-tab="detail">공고 내용</button>
            <button class="tab-btn px-5 py-4 text-sm" data-tab="condition">입찰 조건</button>
            <button class="tab-btn px-5 py-4 text-sm" data-tab="schedule">일정 안내</button>
            <button class="tab-btn px-5 py-4 text-sm" data-tab="contact">문의처</button>
          </div>

          <div class="p-8">

            <!-- Tab: 공고 내용 -->
            <div class="tab-panel active" id="tab-detail">
              <div class="prose max-w-none text-sm text-slate-700 leading-relaxed space-y-5">
                <h2 class="font-headline text-base font-bold text-[#004830]">1. 공고 개요</h2>
                <p>서초그랑자이 입주자대표회의는 단지 내 조경관리 용역업체를 아래와 같이 공개 선정하오니, 참여를 희망하시는 업체께서는 기한 내에 제출서류를 갖추어 입찰에 참여하여 주시기 바랍니다.</p>

                <h2 class="font-headline text-base font-bold text-[#004830]">2. 용역 개요</h2>
                <table class="w-full text-sm border-collapse">
                  <tbody>
                  <tr class="border-b border-[#eef2eb]">
                    <td class="py-3 pr-4 text-xs font-bold text-slate-400 w-28">사업명</td>
                    <td class="py-3 text-slate-700">서초그랑자이 단지 내 조경관리 용역</td>
                  </tr>
                  <tr class="border-b border-[#eef2eb]">
                    <td class="py-3 pr-4 text-xs font-bold text-slate-400">위치</td>
                    <td class="py-3 text-slate-700">서울특별시 서초구 서초동 1234-5</td>
                  </tr>
                  <tr class="border-b border-[#eef2eb]">
                    <td class="py-3 pr-4 text-xs font-bold text-slate-400">계약기간</td>
                    <td class="py-3 text-slate-700">2024.07.01 ~ 2025.06.30 (1년)</td>
                  </tr>
                  <tr class="border-b border-[#eef2eb]">
                    <td class="py-3 pr-4 text-xs font-bold text-slate-400">예정금액</td>
                    <td class="py-3 font-bold text-[#004830]">월 4,800,000원 (부가세 포함)</td>
                  </tr>
                  <tr>
                    <td class="py-3 pr-4 text-xs font-bold text-slate-400">용역범위</td>
                    <td class="py-3 text-slate-700">수목 전지·전정, 잔디 관리, 화단 식재 및 제초, 계절별 화훼 교체, 병해충 방제</td>
                  </tr>
                  </tbody>
                </table>

                <h2 class="font-headline text-base font-bold text-[#004830]">3. 입찰 방법</h2>
                <p>본 공고는 <strong>제한경쟁입찰</strong> 방식으로 진행되며, 최저가 낙찰제를 원칙으로 합니다. 단, 예정금액의 80% 미만 입찰 시 낙찰에서 제외됩니다.</p>

                <div class="bg-[#f8faf6] border-l-4 border-[#226046] rounded-r-lg p-4">
                  <p class="text-[11px] font-bold text-[#226046] mb-1">⚠ 유의사항</p>
                  <p class="text-xs text-slate-600">입찰 관련 서류는 마감일 오후 5시까지 관리사무소 방문 제출을 원칙으로 하며, 우편·이메일 접수는 불가합니다. 제출 기한을 넘긴 서류는 일절 접수하지 않습니다.</p>
                </div>
              </div>
            </div>

            <!-- Tab: 입찰 조건 -->
            <div class="tab-panel" id="tab-condition">
              <div class="space-y-5 text-sm text-slate-700">
                <h2 class="font-headline text-base font-bold text-[#004830]">참가 자격</h2>
                <ul class="space-y-3">
                  <li class="flex items-start gap-3">
                    <span class="mt-0.5 w-5 h-5 rounded-full bg-secondary-container text-on-secondary-container text-[10px] font-bold flex items-center justify-center flex-shrink-0">1</span>
                    <span>조경산업기사 이상 자격 보유자를 포함한 법인 또는 개인사업자</span>
                  </li>
                  <li class="flex items-start gap-3">
                    <span class="mt-0.5 w-5 h-5 rounded-full bg-secondary-container text-on-secondary-container text-[10px] font-bold flex items-center justify-center flex-shrink-0">2</span>
                    <span>최근 3년 이내 공동주택 조경관리 용역 수행실적 1건 이상 보유</span>
                  </li>
                  <li class="flex items-start gap-3">
                    <span class="mt-0.5 w-5 h-5 rounded-full bg-secondary-container text-on-secondary-container text-[10px] font-bold flex items-center justify-center flex-shrink-0">3</span>
                    <span>사업자등록증 상 업종에 조경 관련 업종이 포함된 업체</span>
                  </li>
                  <li class="flex items-start gap-3">
                    <span class="mt-0.5 w-5 h-5 rounded-full bg-secondary-container text-on-secondary-container text-[10px] font-bold flex items-center justify-center flex-shrink-0">4</span>
                    <span>입찰 공고일 현재 국세 및 지방세 체납이 없는 업체</span>
                  </li>
                </ul>

                <h2 class="font-headline text-base font-bold text-[#004830] pt-2">제출 서류</h2>
                <div class="rounded-lg border border-[#eef2eb] overflow-hidden">
                  <table class="w-full text-sm">
                    <thead class="bg-[#f1f3ef]">
                    <tr>
                      <th class="px-4 py-3 text-left text-xs font-bold text-slate-500">서류명</th>
                      <th class="px-4 py-3 text-center text-xs font-bold text-slate-500">부수</th>
                      <th class="px-4 py-3 text-left text-xs font-bold text-slate-500">비고</th>
                    </tr>
                    </thead>
                    <tbody class="divide-y divide-[#eef2eb]">
                    <tr><td class="px-4 py-3">입찰 참가신청서</td><td class="px-4 py-3 text-center">1부</td><td class="px-4 py-3 text-slate-400 text-xs">소정 양식</td></tr>
                    <tr><td class="px-4 py-3">사업자등록증 사본</td><td class="px-4 py-3 text-center">1부</td><td class="px-4 py-3 text-slate-400 text-xs"></td></tr>
                    <tr><td class="px-4 py-3">자격증 사본</td><td class="px-4 py-3 text-center">1부</td><td class="px-4 py-3 text-slate-400 text-xs">조경산업기사 이상</td></tr>
                    <tr><td class="px-4 py-3">수행실적 증빙서류</td><td class="px-4 py-3 text-center">1부</td><td class="px-4 py-3 text-slate-400 text-xs">계약서 사본 등</td></tr>
                    <tr><td class="px-4 py-3">국세·지방세 완납증명서</td><td class="px-4 py-3 text-center">각 1부</td><td class="px-4 py-3 text-slate-400 text-xs">발급일 기준 1개월 이내</td></tr>
                    <tr><td class="px-4 py-3">입찰 견적서</td><td class="px-4 py-3 text-center">1부</td><td class="px-4 py-3 text-slate-400 text-xs">밀봉 제출</td></tr>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

            <!-- Tab: 일정 안내 -->
            <div class="tab-panel" id="tab-schedule">
              <div class="space-y-4 text-sm">
                <h2 class="font-headline text-base font-bold text-[#004830] mb-6">입찰 진행 일정</h2>
                <div class="relative pl-6 border-l-2 border-[#eef2eb] space-y-0">

                  <div class="timeline-item active relative pb-8">
                    <div class="bg-[#f8faf6] border border-[#eef2eb] rounded-lg p-4 ml-4">
                      <div class="flex items-center justify-between mb-1">
                        <p class="font-bold text-[#004830] text-xs">공고 게시</p>
                        <span class="text-[10px] bg-secondary-container text-on-secondary-container px-2 py-0.5 rounded-full font-bold">완료</span>
                      </div>
                      <p class="text-slate-500 text-xs">2024.05.20 (월)</p>
                    </div>
                  </div>

                  <div class="timeline-item relative pb-8">
                    <div class="bg-[#f8faf6] border border-[#eef2eb] rounded-lg p-4 ml-4">
                      <div class="flex items-center justify-between mb-1">
                        <p class="font-bold text-[#004830] text-xs">현장 설명회</p>
                        <span class="text-[10px] bg-[#eef2eb] text-slate-500 px-2 py-0.5 rounded-full font-bold">예정</span>
                      </div>
                      <p class="text-slate-500 text-xs">2024.05.27 (월) 오전 10:00 | 관리사무소 회의실</p>
                    </div>
                  </div>

                  <div class="timeline-item relative pb-8">
                    <div class="bg-[#f8faf6] border border-[#eef2eb] rounded-lg p-4 ml-4">
                      <div class="flex items-center justify-between mb-1">
                        <p class="font-bold text-[#004830] text-xs">서류 접수 마감</p>
                        <span class="text-[10px] bg-[#eef2eb] text-slate-500 px-2 py-0.5 rounded-full font-bold">예정</span>
                      </div>
                      <p class="text-slate-500 text-xs">2024.06.05 (수) 오후 5:00까지</p>
                    </div>
                  </div>

                  <div class="timeline-item relative pb-8">
                    <div class="bg-[#f8faf6] border border-[#eef2eb] rounded-lg p-4 ml-4">
                      <div class="flex items-center justify-between mb-1">
                        <p class="font-bold text-[#004830] text-xs">입찰 개봉 및 심사</p>
                        <span class="text-[10px] bg-[#eef2eb] text-slate-500 px-2 py-0.5 rounded-full font-bold">예정</span>
                      </div>
                      <p class="text-slate-500 text-xs">2024.06.10 (월) 오후 2:00 | 입주자대표 회의실</p>
                    </div>
                  </div>

                  <div class="timeline-item relative">
                    <div class="bg-[#f8faf6] border border-[#eef2eb] rounded-lg p-4 ml-4">
                      <div class="flex items-center justify-between mb-1">
                        <p class="font-bold text-[#004830] text-xs">낙찰자 발표 및 계약 체결</p>
                        <span class="text-[10px] bg-[#eef2eb] text-slate-500 px-2 py-0.5 rounded-full font-bold">예정</span>
                      </div>
                      <p class="text-slate-500 text-xs">2024.06.17 (월)</p>
                    </div>
                  </div>

                </div>
              </div>
            </div>

            <!-- Tab: 문의처 -->
            <div class="tab-panel" id="tab-contact">
              <div class="space-y-4 text-sm">
                <h2 class="font-headline text-base font-bold text-[#004830]">담당자 정보</h2>
                <div class="grid grid-cols-2 gap-4">
                  <div class="bg-[#f8faf6] rounded-lg p-5 space-y-3 border border-[#eef2eb]">
                    <div class="flex items-center gap-3">
                      <div class="w-9 h-9 bg-secondary-container rounded-full flex items-center justify-center">
                        <span class="material-symbols-outlined text-on-secondary-container text-[18px]">person</span>
                      </div>
                      <div>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">담당자</p>
                        <p class="text-sm font-bold text-[#004830]">김관리 (관리소장)</p>
                      </div>
                    </div>
                    <div class="space-y-2 text-xs text-slate-600">
                      <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-[15px] text-slate-400">call</span>
                        <span>02-1234-5678</span>
                      </div>
                      <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-[15px] text-slate-400">mail</span>
                        <span>granjay@apt.co.kr</span>
                      </div>
                    </div>
                  </div>
                  <div class="bg-[#f8faf6] rounded-lg p-5 space-y-3 border border-[#eef2eb]">
                    <div class="flex items-center gap-3">
                      <div class="w-9 h-9 bg-secondary-container rounded-full flex items-center justify-center">
                        <span class="material-symbols-outlined text-on-secondary-container text-[18px]">apartment</span>
                      </div>
                      <div>
                        <p class="text-[10px] text-slate-400 font-bold uppercase tracking-wider">관리사무소</p>
                        <p class="text-sm font-bold text-[#004830]">서초그랑자이 관리사무소</p>
                      </div>
                    </div>
                    <div class="space-y-2 text-xs text-slate-600">
                      <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-[15px] text-slate-400">location_on</span>
                        <span>서울 서초구 서초동 1234-5, 관리동 1층</span>
                      </div>
                      <div class="flex items-center gap-2">
                        <span class="material-symbols-outlined text-[15px] text-slate-400">schedule</span>
                        <span>평일 09:00 ~ 18:00 (점심 12:00~13:00 제외)</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>

      <!-- ── RIGHT Sidebar ── -->
      <div class="col-span-1 space-y-4 sticky top-28">

        <!-- D-Day Card -->
        <div class="bg-[#004830] rounded-lg p-6 text-white space-y-3">
          <div class="flex items-center justify-between">
            <p class="text-[11px] font-bold text-[#95d4b3] uppercase tracking-wider">마감까지</p>
            <span class="material-symbols-outlined text-[18px] text-[#95d4b3]">timer</span>
          </div>
          <p class="font-headline text-4xl font-bold">D-16</p>
          <p class="text-[#95d4b3] text-xs">2024.06.05 오후 5:00 마감</p>
          <div class="w-full bg-white/20 rounded-full h-1.5">
            <div class="bg-[#95d4b3] h-1.5 rounded-full" style="width: 35%"></div>
          </div>
          <p class="text-[10px] text-white/60">공고기간 35% 경과</p>
        </div>

        <!-- Quick Info -->
        <div class="bg-white rounded-lg border border-[#eef2eb] p-5 space-y-3">
          <p class="text-xs font-bold text-slate-400 uppercase tracking-wider">공고 정보</p>
          <div class="space-y-2.5 text-sm">
            <div class="flex items-start justify-between gap-2">
              <span class="text-slate-400 text-xs flex-shrink-0">공고번호</span>
              <span class="font-bold text-[#004830] text-xs text-right">2024-085</span>
            </div>
            <div class="border-t border-[#f1f3ef]"></div>
            <div class="flex items-start justify-between gap-2">
              <span class="text-slate-400 text-xs flex-shrink-0">유형</span>
              <span class="text-xs font-bold bg-[#eef2eb] text-[#004830] px-2 py-0.5 rounded">용역</span>
            </div>

            <div class="border-t border-[#f1f3ef]"></div>
            <div class="flex items-start justify-between gap-2">
              <span class="text-slate-400 text-xs flex-shrink-0">계약기간</span>
              <span class="font-medium text-slate-600 text-xs text-right">2024.07 ~ 2025.06</span>
            </div>
            <div class="border-t border-[#f1f3ef]"></div>
            <div class="flex items-start justify-between gap-2">
              <span class="text-slate-400 text-xs flex-shrink-0">담당자</span>
              <span class="font-medium text-slate-600 text-xs text-right">김관리 (02-1234-5678)</span>
            </div>
          </div>
        </div>




    <!-- Back to List Button (Bottom) -->
    <div class="flex justify-center pb-4 no-print">
      <a href="#" class="px-8 py-3 bg-white border border-[#eef2eb] rounded-lg text-sm font-medium text-slate-600 hover:bg-[#f8faf6] transition-colors flex items-center gap-2">
        <span class="material-symbols-outlined text-[16px]">list</span> 목록으로
      </a>
    </div>

  </main>
</div>

<script>
  // Tab switching
  const tabBtns = document.querySelectorAll('.tab-btn');
  const tabPanels = document.querySelectorAll('.tab-panel');

  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      tabBtns.forEach(b => b.classList.remove('active'));
      tabPanels.forEach(p => p.classList.remove('active'));
      btn.classList.add('active');
      document.getElementById('tab-' + btn.dataset.tab).classList.add('active');
    });
  });

  // Print button
  document.querySelector('button[class*="print"]')?.addEventListener('click', () => window.print());
</script>

</body>
</html>
