<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body{font-family:'Manrope',sans-serif;background:#f0f4f0}
        .material-symbols-outlined{font-variation-settings:'FILL' 0,'wght' 400,'GRAD' 0,'opsz' 24}
        .card{background:#fff;border:1px solid #dde8dd;border-radius:14px}
        .sec-title{font-size:15px;font-weight:800;color:#004830;display:flex;align-items:center;gap:8px;margin-bottom:16px;padding-bottom:12px;border-bottom:2px solid #004830}
        .ir{display:flex;align-items:center;padding:13px 0;border-bottom:1px solid #f1f5f0;font-size:14px}
        .ir:last-child{border-bottom:none}
        .il{width:100px;flex-shrink:0;font-size:13px;color:#9ca3af}
        .iv{font-weight:700;color:#1f2937}
        .th-row{display:grid;grid-template-columns:2fr 1fr 1fr;padding:10px 24px;background:#f4f7f4;border-bottom:1px solid #dde8dd;font-size:12px;font-weight:700;color:#6b7280}
        .doc-row{display:grid;grid-template-columns:2fr 1fr 1fr;align-items:center;padding:15px 24px;border-bottom:1px solid #f1f5f0;font-size:14px}
        .doc-row:last-child{border-bottom:none}
        .badge{display:inline-flex;padding:4px 12px;border-radius:20px;font-size:12px;font-weight:700}
    </style>
</head>
<body class="text-[#191c1a]">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-10 pt-28">
    <c:set var="status" value="SUPPLEMENT"/>

    <!-- 브레드크럼 -->
    <div class="flex items-center gap-2 text-xs text-slate-400 mb-2">
        <a href="/contract/history.do" class="hover:text-[#004830]">계약 신청 조회</a>
        <span>›</span><span class="text-[#004830] font-semibold">상세보기</span>
    </div>

    <!-- 제목 + 목록버튼 -->
    <div class="flex items-center justify-between mb-6">
        <h1 class="text-2xl font-bold text-[#004830]">계약 신청 상세</h1>
        <a href="/contract/history.do" class="flex items-center gap-1.5 text-sm text-slate-500 border border-slate-200 px-4 py-2.5 rounded-full bg-white hover:bg-slate-50">
            <span class="material-symbols-outlined text-[16px]">arrow_back</span> 목록으로
        </a>
    </div>

    <!-- 헤더 카드 -->
    <div class="card mb-6 overflow-hidden">
        <div class="h-1.5 w-full bg-gradient-to-r from-[#004830] via-[#226046] to-[#95d4b3]"></div>
        <div class="px-8 py-5 flex items-center justify-between">
            <div>
                <p class="text-xs text-slate-400 mb-1">신청번호</p>
                <p class="text-xl font-bold text-[#004830]">${aplct.}</p>
            </div>
            <c:choose>
                <c:when test="${status == 'SUBMIT'}"><span class="badge bg-blue-50 text-blue-600">신청완료</span></c:when>
                <c:when test="${status == 'WINNER'}"><span class="badge bg-blue-50 text-blue-600">서류 제출 필요</span></c:when>
                <c:when test="${status == 'SUPPLEMENT'}"><span class="badge bg-orange-50 text-orange-500">서류 보완 필요</span></c:when>
                <c:when test="${status == 'QUALIFIED'}"><span class="badge bg-green-50 text-green-600">검증 완료</span></c:when>
                <c:when test="${status == 'LOSER'}"><span class="badge bg-amber-50 text-amber-600">낙첨</span></c:when>
                <c:when test="${status == 'CANCEL'}"><span class="badge bg-red-50 text-red-500">취소</span></c:when>
            </c:choose>
        </div>
    </div>

    <!-- 진행 상태 스텝퍼 -->
    <div class="card px-10 py-7 mb-6">
        <p class="sec-title"><span class="material-symbols-outlined text-[18px]">timeline</span>진행 상태</p>
        <div class="flex items-start justify-between relative mt-2">
            <div class="absolute top-5 left-0 right-0 h-0.5 bg-[#e2e8e0] z-0"></div>

            <!-- 1단계 -->
            <div class="flex flex-col items-center gap-2.5 z-10 flex-1">
                <c:choose>
                    <c:when test="${status == 'CANCEL'}">
                        <div class="w-10 h-10 rounded-full bg-red-400 text-white flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">close</span></div>
                        <p class="text-sm font-bold text-red-400">취소</p>
                        <p class="text-xs text-slate-400">2026.05.14</p>
                    </c:when>
                    <c:when test="${status == 'LOSER'}">
                        <div class="w-10 h-10 rounded-full bg-amber-400 text-white flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">remove</span></div>
                        <p class="text-sm font-bold text-amber-500">낙첨</p>
                        <p class="text-xs text-slate-400">2026.05.14</p>
                    </c:when>
                    <c:otherwise>
                        <div class="w-10 h-10 rounded-full bg-[#226046] text-white flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">check</span></div>
                        <p class="text-sm font-bold text-[#226046]">신청 완료</p>
                        <p class="text-xs text-slate-400">2026.05.14 11:44</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 2단계 -->
            <div class="flex flex-col items-center gap-2.5 z-10 flex-1">
                <c:choose>
                    <c:when test="${status == 'QUALIFIED'}">
                        <div class="w-10 h-10 rounded-full bg-[#226046] text-white flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">check</span></div>
                        <p class="text-sm font-bold text-[#226046]">서류 제출 완료</p>
                        <p class="text-xs text-slate-400">2026.05.15</p>
                    </c:when>
                    <c:when test="${status == 'WINNER'}">
                        <div class="w-10 h-10 rounded-full bg-blue-400 text-white flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">upload_file</span></div>
                        <p class="text-sm font-bold text-blue-500">서류 제출 필요</p>
                        <p class="text-xs text-slate-400">제출 필요</p>
                    </c:when>
                    <c:when test="${status == 'SUPPLEMENT'}">
                        <div class="w-10 h-10 rounded-full bg-orange-400 text-white flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">warning</span></div>
                        <p class="text-sm font-bold text-orange-500">서류 보완 필요</p>
                        <p class="text-xs text-slate-400">보완 필요</p>
                    </c:when>
                    <c:otherwise>
                        <div class="w-10 h-10 rounded-full bg-slate-100 text-slate-400 flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">upload_file</span></div>
                        <p class="text-sm font-semibold text-slate-400">서류 제출</p>
                        <p class="text-xs text-slate-300">대기</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- 3단계 -->
            <div class="flex flex-col items-center gap-2.5 z-10 flex-1">
                <c:choose>
                    <c:when test="${status == 'QUALIFIED'}">
                        <div class="w-10 h-10 rounded-full bg-[#004830] text-white flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">verified</span></div>
                        <p class="text-sm font-bold text-[#004830]">검증 완료</p>
                        <p class="text-xs text-slate-400">2026.05.16</p>
                    </c:when>
                    <c:otherwise>
                        <div class="w-10 h-10 rounded-full bg-slate-100 text-slate-400 flex items-center justify-center shadow-sm"><span class="material-symbols-outlined text-[18px]">verified</span></div>
                        <p class="text-sm font-semibold text-slate-400">검증 완료</p>
                        <p class="text-xs text-slate-300">대기</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 공고정보 + 신청자정보 2단 -->
    <div class="grid grid-cols-2 gap-6 mb-6">

        <!-- 공고 정보 -->
        <div class="card p-7">
            <p class="sec-title">
                <span class="material-symbols-outlined text-[18px]">apartment</span>공고 정보
                <a href="/contract/detail.do?annNo=ANN0007" class="ml-auto text-sm text-[#226046] font-normal hover:underline flex items-center gap-0.5">
                    공고 보기 <span class="material-symbols-outlined text-[14px]">open_in_new</span>
                </a>
            </p>
            <div class="ir"><span class="il">공고명</span><span class="iv">공덕한화꿈에그린 2026년 모집공고</span></div>
            <div class="ir"><span class="il">공고번호</span><span class="iv">ANN0007</span></div>
            <div class="ir"><span class="il">타입</span><span class="iv">A타입 · 65㎡</span></div>
            <div class="ir"><span class="il">모집기간</span><span class="iv">2026.05.01 ~ 2026.05.31</span></div>
        </div>

        <!-- 신청자 정보 -->
        <div class="card p-7">
            <p class="sec-title"><span class="material-symbols-outlined text-[18px]">person</span>신청자 정보</p>
            <div class="ir"><span class="il">이름</span><span class="iv">송지훈</span></div>
            <div class="ir"><span class="il">연락처</span><span class="iv">010-1234-5678</span></div>
            <div class="ir"><span class="il">신청일시</span><span class="iv">2026.05.14 11:44</span></div>
        </div>
    </div>

    <!-- 서류 제출 현황 -->
    <c:if test="${status == 'WINNER' || status == 'SUPPLEMENT' || status == 'QUALIFIED'}">
        <div class="card overflow-hidden mb-6">
            <div class="px-7 py-5 border-b-2 border-[#004830] flex items-center justify-between bg-[#f4f7f4]">
                <p class="text-base font-bold text-[#004830] flex items-center gap-2">
                    <span class="material-symbols-outlined text-[18px]">folder_open</span>서류 제출 현황
                </p>
                <c:choose>
                    <c:when test="${status == 'WINNER'}"><span class="text-sm text-blue-500 font-semibold flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">info</span> 서류를 제출해 주세요</span></c:when>
                    <c:when test="${status == 'SUPPLEMENT'}"><span class="text-sm text-orange-500 font-semibold flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">warning</span> 반려 서류를 보완해 주세요</span></c:when>
                    <c:when test="${status == 'QUALIFIED'}"><span class="text-sm text-green-600 font-semibold flex items-center gap-1"><span class="material-symbols-outlined text-[14px]">check_circle</span> 검토 완료</span></c:when>
                </c:choose>
            </div>

            <div class="th-row">
                <span>서류명</span><span class="text-center">제출일</span><span class="text-center">상태</span>
            </div>

            <div class="doc-row">
                <div class="flex items-center gap-2.5"><span class="material-symbols-outlined text-[20px] text-[#226046]">description</span><span class="font-semibold text-slate-700">주민등록등본</span></div>
                <span class="text-sm text-slate-500 text-center">2026.05.14</span>
                <div class="text-center"><span class="badge bg-green-50 text-green-600">제출완료</span></div>
            </div>

            <div class="doc-row">
                <div class="flex items-center gap-2.5"><span class="material-symbols-outlined text-[20px] text-[#226046]">description</span><span class="font-semibold text-slate-700">금융정보제공동의서</span></div>
                <span class="text-sm text-slate-500 text-center">2026.05.14</span>
                <div class="text-center"><span class="badge bg-green-50 text-green-600">제출완료</span></div>
            </div>

            <!-- 반려 -->
            <div class="bg-red-50 border-b border-[#f1f5f0]">
                <div class="doc-row bg-transparent border-none">
                    <div class="flex items-center gap-2.5"><span class="material-symbols-outlined text-[20px] text-red-400">description</span><span class="font-semibold text-slate-700">소득확인증명서</span></div>
                    <span class="text-sm text-slate-500 text-center">2026.05.14</span>
                    <div class="text-center"><span class="badge bg-red-100 text-red-500">반려</span></div>
                </div>
                <div class="px-6 pb-4 pl-14 flex items-start gap-2">
                    <span class="material-symbols-outlined text-[14px] text-red-400 mt-0.5">error</span>
                    <p class="text-sm text-red-400">발급일로부터 3개월 이내의 서류를 제출해 주세요.</p>
                </div>
            </div>

            <div class="doc-row">
                <div class="flex items-center gap-2.5"><span class="material-symbols-outlined text-[20px] text-slate-300">description</span><span class="font-semibold text-slate-300">가족관계증명서</span></div>
                <span class="text-sm text-slate-300 text-center">-</span>
                <div class="text-center"><span class="badge bg-slate-100 text-slate-400">미제출</span></div>
            </div>

            <div class="doc-row">
                <div class="flex items-center gap-2.5"><span class="material-symbols-outlined text-[20px] text-slate-300">description</span><span class="font-semibold text-slate-300">자산보유사실확인서</span></div>
                <span class="text-sm text-slate-300 text-center">-</span>
                <div class="text-center"><span class="badge bg-slate-100 text-slate-400">미제출</span></div>
            </div>

            <c:if test="${status == 'WINNER' || status == 'SUPPLEMENT' || status == 'SUBMIT'}">
                <div class="px-7 py-5 border-t border-[#eef2eb] bg-[#f4f7f4] flex justify-end gap-3">
                    <c:if test="${status == 'WINNER' || status == 'SUPPLEMENT'}">
                        <a href="/contract/submitDoc.do?aplctNo=260514_t_700_01"
                           class="flex items-center gap-2 px-7 py-3 bg-[#004830] text-white rounded-full text-sm font-bold hover:bg-[#226046] transition-colors">
                            <span class="material-symbols-outlined text-[17px]">upload_file</span>서류 제출하기
                        </a>
                    </c:if>
                    <button onclick="cancelAplct('260514_t_700_01')"
                            class="flex items-center gap-2 px-7 py-3 bg-red-500 text-white rounded-full text-sm font-bold hover:bg-red-600 transition-colors">
                        <span class="material-symbols-outlined text-[17px]">close</span>신청 취소
                    </button>
                </div>
            </c:if>
        </div>
    </c:if>

    <!-- SUBMIT일 때 취소버튼 단독 -->
    <c:if test="${status == 'SUBMIT'}">
        <div class="flex justify-end mb-6">
            <button onclick="cancelAplct('260514_t_700_01')"
                    class="flex items-center gap-2 px-7 py-3 bg-red-500 text-white rounded-full text-sm font-bold hover:bg-red-600 transition-colors">
                <span class="material-symbols-outlined text-[17px]">close</span>신청 취소
            </button>
        </div>
    </c:if>

    <!-- LOSER 안내 -->
    <c:if test="${status == 'LOSER'}">
        <div class="bg-amber-50 rounded-xl border border-amber-100 p-6 flex items-start gap-4 mb-6">
            <span class="material-symbols-outlined text-[28px] text-amber-400 flex-shrink-0">info</span>
            <div>
                <p class="text-base font-bold text-amber-600 mb-1.5">낙첨 안내</p>
                <p class="text-sm text-amber-500 leading-relaxed">이번 추첨에서 안타깝게 낙첨되었습니다. 다음 공고를 통해 다시 신청하실 수 있습니다.</p>
                <a href="/contract/notice.do" class="inline-flex items-center gap-1 mt-3 text-sm text-amber-600 font-bold hover:underline">
                    다른 공고 보기 <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                </a>
            </div>
        </div>
    </c:if>

    <!-- CANCEL 안내 -->
    <c:if test="${status == 'CANCEL'}">
        <div class="bg-red-50 rounded-xl border border-red-100 p-6 flex items-start gap-4 mb-6">
            <span class="material-symbols-outlined text-[28px] text-red-400 flex-shrink-0">cancel</span>
            <div>
                <p class="text-base font-bold text-red-500 mb-1.5">신청 취소 완료</p>
                <p class="text-sm text-red-400 leading-relaxed">신청이 취소되었습니다. 동일 공고에 재신청은 불가합니다.</p>
                <a href="/contract/notice.do" class="inline-flex items-center gap-1 mt-3 text-sm text-red-500 font-bold hover:underline">
                    다른 공고 보기 <span class="material-symbols-outlined text-[14px]">arrow_forward</span>
                </a>
            </div>
        </div>
    </c:if>

    <!-- QUALIFIED 안내 -->
    <c:if test="${status == 'QUALIFIED'}">
        <div class="bg-green-50 rounded-xl border border-green-100 p-6 flex items-start gap-4 mb-6">
            <span class="material-symbols-outlined text-[28px] text-green-500 flex-shrink-0">check_circle</span>
            <div>
                <p class="text-base font-bold text-green-600 mb-1.5">검증 완료</p>
                <p class="text-sm text-green-500 leading-relaxed">모든 서류가 확인되었습니다. 담당자가 계약 일정을 안내드릴 예정입니다.</p>
            </div>
        </div>
    </c:if>

    <input type="hidden" id="csrfToken" value="${_csrf.token}"/>
    <input type="hidden" id="csrfHeader" value="${_csrf.headerName}"/>
</main>

<script>
    function cancelAplct(aplctNo) {
        Swal.fire({
            icon: 'warning', title: '신청을 취소하시겠습니까?', text: '취소 후 복구가 불가능합니다.',
            confirmButtonColor: '#ef4444', confirmButtonText: '취소하기',
            showCancelButton: true, cancelButtonText: '닫기'
        }).then(result => {
            if (result.isConfirmed) {
                const csrfToken = document.querySelector('#csrfToken').value;
                const csrfHeader = document.querySelector('#csrfHeader').value;
                fetch('/contract/cancel.do', {
                    method: 'PUT',
                    headers: {'Content-Type': 'application/json', [csrfHeader]: csrfToken},
                    body: JSON.stringify({aplctNo: aplctNo})
                }).then(res => res.json()).then(result => {
                    if (result.success) {
                        Swal.fire({icon: 'success', title: '취소 완료', confirmButtonColor: '#004830'})
                            .then(() => location.href = '/contract/history.do');
                    } else {
                        Swal.fire({icon: 'error', title: '오류', text: '취소 중 오류가 발생했습니다.', confirmButtonColor: '#004830'});
                    }
                });
            }
        });
    }
</script>
</body>
</html>