<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
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
        body { font-family: 'Manrope', sans-serif; background-color: #f8faf6; }
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }

        /* 진행상태 선 */
        .status-step { display: flex; align-items: flex-start; gap: 12px; position: relative; }
        .status-step:not(:last-child)::after {
            content: ''; position: absolute; left: 11px; top: 24px;
            width: 2px; height: calc(100% + 8px); background: #e2e8e0;
        }
        .status-step.done::after { background: #226046; }
    </style>
</head>
<body class="bg-[#f8faf6] text-[#191c1a]">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-8 pt-28">

    <div class="mb-6">
        <h1 class="text-xl font-bold text-[#004830] mb-1">계약 신청 조회</h1>
        <p class="text-sm text-slate-400">내가 신청한 계약 내역을 확인할 수 있습니다.</p>
    </div>

    <c:choose>
        <c:when test="${not empty list}">
            <c:forEach var="aplct" items="${list}">

                <div class="bg-white rounded-2xl shadow-sm border border-[#eef2eb] mb-5 overflow-hidden">
                    <div class="h-1 w-full bg-gradient-to-r from-[#004830] via-[#226046] to-[#95d4b3]"></div>

                    <!-- 신청 기본 정보 -->
                    <div class="p-6 border-b border-[#eef2eb]">
                        <div class="flex items-center justify-between">
                            <div class="space-y-1">
                                <p class="text-xs text-slate-400">신청번호</p>
                                <p class="text-lg font-bold text-[#004830]">${aplct.APLCT_NO}</p>
                            </div>
                            <div class="text-right space-y-1">
                                <c:choose>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'SUBMIT'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-blue-50 text-blue-600 text-xs font-bold">신청완료</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'WINNER'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-green-50 text-green-600 text-xs font-bold">당첨</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'LOSER'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-bold">낙첨</span>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'CANCEL'}">
                                        <span class="inline-block px-3 py-1 rounded-full bg-red-50 text-red-500 text-xs font-bold">취소</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="inline-block px-3 py-1 rounded-full bg-slate-100 text-slate-500 text-xs font-bold">${aplct.APLCT_STTS_CD}</span>
                                    </c:otherwise>
                                </c:choose>
                                    <%-- 신청일 .0 제거: 앞 16자(yyyy.MM.dd HH:mm)만 표시 --%>
                                <p class="text-xs text-slate-400">${fn:substring(fn:replace(aplct.REG_DT, '-', '.'), 0, 16)} 신청</p>
                            </div>
                        </div>
                    </div>

                    <!-- 공고 정보 + 진행상태 -->
                    <div class="grid grid-cols-3 gap-0">

                        <!-- 공고 정보 -->
                        <div class="col-span-2 p-6 border-r border-[#eef2eb]">
                            <p class="text-xs font-bold text-[#004830] mb-3 flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px]">apartment</span>
                                공고 정보
                            </p>
                            <div class="space-y-2 text-sm">
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">공고명</span>
                                    <span class="text-slate-700">${aplct.TTL}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">아파트 단지</span>
                                    <span class="text-slate-700 font-medium">${aplct.APT_CMPLEX_NM}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">공고번호</span>
                                    <span class="text-slate-700">${aplct.ANN_NO}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">타입</span>
                                    <span class="text-slate-700">${aplct.TY_NM}</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="text-slate-400 w-20 flex-shrink-0">전용면적</span>
                                    <span class="text-slate-700">${aplct.EXCLUSIVE_SIZE}㎡</span>
                                </div>
                            </div>
                        </div>

                        <!-- 진행 상태 -->
                        <div class="col-span-1 p-6">
                            <p class="text-xs font-bold text-[#004830] mb-4 flex items-center gap-2">
                                <span class="material-symbols-outlined text-[16px]">timeline</span>
                                진행 상태
                            </p>
                            <div class="space-y-4">

                                    <%-- 1단계: 신청 완료
                                         취소면 선 회색(done 없음), 나머지는 초록(done)
                                    --%>
                                <div class="status-step ${aplct.APLCT_STTS_CD != 'CANCEL' ? 'done' : ''}">
                                    <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-[#226046] text-white">
                                        <span class="material-symbols-outlined text-[14px]">check</span>
                                    </div>
                                    <div class="pb-4">
                                        <p class="text-sm font-semibold text-[#226046]">신청 완료</p>
                                        <p class="text-xs text-slate-400 mt-0.5">계약 신청이 완료되었습니다.</p>
                                    </div>
                                </div>

                                    <%-- 2단계: 추첨
                                         WINNER/LOSER → 초록 done
                                         SUBMIT/CANCEL → 회색 비활성
                                    --%>
                                <c:choose>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'WINNER' || aplct.APLCT_STTS_CD == 'LOSER'}">
                                        <div class="status-step done">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-[#226046] text-white">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-[#226046]">추첨</p>
                                                <p class="text-xs text-slate-400 mt-0.5">추첨이 완료되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="status-step">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-slate-100 text-slate-400">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div class="pb-4">
                                                <p class="text-sm font-semibold text-slate-400">추첨</p>
                                                <p class="text-xs text-slate-400 mt-0.5">
                                                    <c:choose>
                                                        <c:when test="${aplct.APLCT_STTS_CD == 'CANCEL'}">신청 취소로 추첨 대상이 아닙니다.</c:when>
                                                        <c:otherwise>추첨 결과를 기다려주세요.</c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                                    <%-- 3단계: 최종 결과 --%>
                                <c:choose>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'WINNER'}">
                                        <div class="status-step done">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-green-500 text-white">
                                                <span class="material-symbols-outlined text-[14px]">check</span>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-green-600">당첨</p>
                                                <p class="text-xs text-slate-400 mt-0.5">축하합니다! 당첨되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'LOSER'}">
                                        <div class="status-step done">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-amber-400 text-white">
                                                <span class="material-symbols-outlined text-[14px]">remove</span>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-amber-600">낙첨</p>
                                                <p class="text-xs text-slate-400 mt-0.5">아쉽게도 낙첨되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${aplct.APLCT_STTS_CD == 'CANCEL'}">
                                        <div class="status-step">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-red-400 text-white">
                                                <span class="material-symbols-outlined text-[14px]">close</span>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-red-400">취소</p>
                                                <p class="text-xs text-slate-400 mt-0.5">신청이 취소되었습니다.</p>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="status-step">
                                            <div class="w-6 h-6 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 bg-slate-100 text-slate-400">
                                                <span class="material-symbols-outlined text-[14px]">hourglass_empty</span>
                                            </div>
                                            <div>
                                                <p class="text-sm font-semibold text-slate-400">결과 대기</p>
                                                <p class="text-xs text-slate-400 mt-0.5">추첨 결과를 기다려주세요.</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>

                            </div>
                        </div>
                    </div>

                    <!-- 하단 버튼 -->
                    <div class="flex justify-end gap-2 px-6 py-4 border-t border-[#eef2eb] bg-[#f8faf6]">
                        <a href="/contract/detail.do?annNo=${aplct.ANN_NO}"
                           class="px-5 py-2 bg-white border border-slate-200 text-sm text-slate-600 rounded-full hover:bg-slate-50 transition-colors">
                            공고 보기
                        </a>
                        <c:if test="${aplct.APLCT_STTS_CD == 'SUBMIT'}">
                            <button onclick="cancelAplct('${aplct.APLCT_NO}')"
                                    class="px-5 py-2 bg-red-500 text-white rounded-full text-sm font-semibold hover:bg-red-600 transition-colors">
                                신청 취소
                            </button>
                        </c:if>
                        <c:if test="${aplct.APLCT_STTS_CD == 'WINNER'}">
                            <a href="/contract/submitDoc.do?aplctNo=${aplct.APLCT_NO}"
                               class="px-5 py-2 bg-[#004830] text-white rounded-full text-sm font-semibold hover:bg-[#226046] transition-colors">
                                서류 제출
                            </a>
                        </c:if>
                    </div>
                </div>

            </c:forEach>
        </c:when>
        <c:otherwise>
            <div class="bg-white rounded-2xl shadow-sm border border-[#eef2eb] p-16 text-center">
                <span class="material-symbols-outlined text-[48px] text-slate-200 mb-4 block">inbox</span>
                <p class="text-slate-400 text-sm mb-6">신청 내역이 없습니다.</p>
                <a href="/contract/notice.do"
                   class="inline-flex items-center gap-2 px-6 py-2.5 bg-[#004830] text-white text-sm font-bold rounded-full hover:bg-[#226046] transition-all">
                    공고 목록 보기
                </a>
            </div>
        </c:otherwise>
    </c:choose>

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
                    headers: {
                        'Content-Type': 'application/json',
                        [csrfHeader]: csrfToken
                    },
                    body: JSON.stringify({aplctNo: aplctNo})
                }).then(res => res.json()).then(result => {
                    if (result.success) {
                        Swal.fire({icon: 'success', title: '취소 완료', confirmButtonColor: '#004830'})
                            .then(() => location.reload());
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
