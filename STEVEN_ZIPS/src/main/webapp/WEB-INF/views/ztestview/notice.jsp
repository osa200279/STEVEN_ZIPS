
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html lang="ko"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>우리집맵핑 - 공지사항</title>
    <!-- BEGIN: External Scripts -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- BEGIN: Custom Styles -->
    <style data-purpose="typography">
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500;700&display=swap');
        body {
            font-family: 'Noto+Sans+KR', sans-serif;
            background-color: #F8FAFB;
        }
    </style>
    <style data-purpose="custom-colors">
        /* Emerald Green matches the reference image button color */
        .bg-brand-green { background-color: #14A852; }
        .text-brand-green { color: #14A852; }
        .border-brand-green { border-color: #14A852; }
        .hover-bg-brand-green:hover { background-color: #118e45; }
    </style>
    <style data-purpose="component-styling">
        /* Table row hover and transition */
        .notice-row {
            transition: background-color 0.2s ease-in-out;
        }
        .notice-row:hover {
            background-color: #F0FDF4;
            cursor: pointer;
        }

        /* Custom scrollbar for aesthetic consistency */
        ::-webkit-scrollbar {
            width: 8px;
        }
        ::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        ::-webkit-scrollbar-thumb {
            background: #ccc;
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #999;
        }
    </style>
    <!-- END: Custom Styles -->
</head>

<%@ include file="/WEB-INF/views/ztestview/sidebarStyle.jsp" %>

<body class="p-4 md:p-8">
<%@ include file="/WEB-INF/views/ztestview/header.jsp" %>
<%@ include file="/WEB-INF/views/ztestview/sidebar.jsp" %>

<main class="ml-80 p-10 pt-28 bg-[#f8faf6]">
    <!-- BEGIN: PageHeader -->
    <div class="mb-8" data-purpose="page-title-section">
        <h1 class="text-3xl font-bold text-gray-900 mb-2">공지사항</h1>
        <p class="text-gray-500 text-sm">우리집맵핑의 새로운 소식과 안내사항을 확인하세요.</p>
    </div>
    <!-- END: PageHeader -->
    <!-- BEGIN: SearchAndFilters -->
    <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mb-6" data-purpose="filter-bar">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <!-- Category Chips -->
            <div class="flex flex-wrap gap-2" data-purpose="category-filters">
                <button class="px-5 py-2 rounded-full bg-brand-green text-white text-sm font-medium transition-colors">전체</button>
                <button class="px-5 py-2 rounded-full bg-gray-100 text-gray-600 text-sm font-medium hover:bg-gray-200 transition-colors">안내</button>
                <button class="px-5 py-2 rounded-full bg-gray-100 text-gray-600 text-sm font-medium hover:bg-gray-200 transition-colors">점검</button>
            </div>
            <!-- Search Input -->
            <div class="relative w-full md:w-80" data-purpose="search-container">
                <input class="w-full pl-4 pr-10 py-2.5 bg-gray-50 border-gray-200 rounded-xl focus:ring-brand-green focus:border-brand-green text-sm transition-all" placeholder="검색어를 입력하세요" type="text"/>
                <div class="absolute right-3 top-1/2 -translate-y-1/2">
                    <svg class="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewbox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                        <path d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"></path>
                    </svg>
                </div>
            </div>
        </div>
    </div>
    <!-- END: SearchAndFilters -->
    <!-- BEGIN: NoticeList -->
    <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden" data-purpose="notice-table-container">
        <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse" id="notice-table">
                <thead>
                <tr class="bg-gray-50 border-b border-gray-100">
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600 w-20 text-center">번호</th>
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600 w-28 text-center">분류</th>
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600">제목</th>
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600 w-32 text-center">등록일</th>
                    <th class="px-6 py-4 text-sm font-semibold text-gray-600 w-24 text-center">조회수</th>
                </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                <!-- Row 1: Important/Notice -->
                <tr class="notice-row" data-purpose="notice-item">
                    <td class="px-6 py-5 text-sm text-gray-400 text-center">124</td>
                    <td class="px-6 py-5 text-center">
                        <span class="px-3 py-1 bg-green-100 text-green-700 text-xs font-bold rounded-md">안내</span>
                    </td>
                    <td class="px-6 py-5">
                        <div class="flex items-center gap-2">
                            <span class="text-sm font-medium text-gray-900">우리집맵핑 서비스 고도화 작업 안내</span>
                            <span class="inline-block w-2 h-2 bg-red-500 rounded-full" title="New content"></span>
                        </div>
                    </td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">2024.05.15</td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">1,204</td>
                </tr>
                <!-- Row 2: Maintenance -->
                <tr class="notice-row" data-purpose="notice-item">
                    <td class="px-6 py-5 text-sm text-gray-400 text-center">123</td>
                    <td class="px-6 py-5 text-center">
                        <span class="px-3 py-1 bg-blue-100 text-blue-700 text-xs font-bold rounded-md">점검</span>
                    </td>
                    <td class="px-6 py-5">
                        <span class="text-sm font-medium text-gray-900">[공지] 서버 정기 점검 안내 (05월 20일)</span>
                    </td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">2024.05.10</td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">856</td>
                </tr>


                <!-- Row 4: Default Notice -->
                <tr class="notice-row" data-purpose="notice-item">
                    <td class="px-6 py-5 text-sm text-gray-400 text-center">121</td>
                    <td class="px-6 py-5 text-center">
                        <span class="px-3 py-1 bg-green-100 text-green-700 text-xs font-bold rounded-md">안내</span>
                    </td>
                    <td class="px-6 py-5">
                        <span class="text-sm font-medium text-gray-900">개인정보 처리방침 개정 안내</span>
                    </td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">2024.04.28</td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">532</td>
                </tr>
                <!-- Row 5 -->
                <tr class="notice-row" data-purpose="notice-item">
                    <td class="px-6 py-5 text-sm text-gray-400 text-center">120</td>
                    <td class="px-6 py-5 text-center">
                        <span class="px-3 py-1 bg-green-100 text-green-700 text-xs font-bold rounded-md">안내</span>
                    </td>
                    <td class="px-6 py-5">
                        <span class="text-sm font-medium text-gray-900">중앙관리자 권한 신청 절차 변경 공지</span>
                    </td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">2024.04.22</td>
                    <td class="px-6 py-5 text-sm text-gray-500 text-center">1,102</td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
    <!-- END: NoticeList -->
    <!-- BEGIN: Pagination -->
    <div class="mt-8 flex justify-center" data-purpose="pagination-section">
        <nav class="flex items-center gap-1">
            <!-- Previous Button -->
            <button class="w-10 h-10 flex items-center justify-center rounded-lg border border-gray-200 text-gray-400 hover:bg-gray-50 transition-colors">
                <svg class="h-5 w-5" fill="currentColor" viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                    <path clip-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" fill-rule="evenodd"></path>
                </svg>
            </button>
            <!-- Page Numbers -->
            <button class="w-10 h-10 flex items-center justify-center rounded-lg bg-brand-green text-white font-medium text-sm">1</button>
            <button class="w-10 h-10 flex items-center justify-center rounded-lg text-gray-600 hover:bg-gray-100 text-sm font-medium transition-colors">2</button>
            <button class="w-10 h-10 flex items-center justify-center rounded-lg text-gray-600 hover:bg-gray-100 text-sm font-medium transition-colors">3</button>
            <button class="w-10 h-10 flex items-center justify-center rounded-lg text-gray-600 hover:bg-gray-100 text-sm font-medium transition-colors">4</button>
            <button class="w-10 h-10 flex items-center justify-center rounded-lg text-gray-600 hover:bg-gray-100 text-sm font-medium transition-colors">5</button>
            <!-- Next Button -->
            <button class="w-10 h-10 flex items-center justify-center rounded-lg border border-gray-200 text-gray-400 hover:bg-gray-50 transition-colors">
                <svg class="h-5 w-5" fill="currentColor" viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                    <path clip-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" fill-rule="evenodd"></path>
                </svg>
            </button>
        </nav>
    </div>
    <!-- END: Pagination -->
</main>
<!-- END: MainContentArea -->
</body></html>