<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Manrope:wght@400;500;600;700&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
          rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "background": "#f8faf6",
                        "primary": "#004830",
                        "primary-container": "#226046",
                        "on-primary": "#ffffff",
                        "on-primary-container": "#99d8b7",
                        "secondary-container": "#aeedd5",
                        "on-secondary-container": "#316d5b",
                        "surface": "#f8faf6",
                        "on-surface": "#191c1a",
                        "primary-fixed": "#b1f0ce",
                        "primary-fixed-dim": "#95d4b3",
                    },
                    borderRadius: {
                        "DEFAULT": "1rem", "lg": "2rem", "xl": "3rem", "full": "9999px"
                    },
                    fontFamily: {
                        "headline": ["Plus Jakarta Sans"], "body": ["Manrope"], "label": ["Manrope"]
                    }
                }
            }
        }
    </script>
    <style>
        body {
            font-family: 'Manrope', sans-serif;
            background-color: #f8faf6;
            color: #191c1a;
        }

        .font-headline {
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

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

        .tab-btn:hover {
            color: #226046;
        }

        .tab-panel {
            display: none;
        }

        .tab-panel.active {
            display: block;
            animation: fadeIn .22s ease;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(6px);
            }
            to {
                opacity: 1;
                transform: none;
            }
        }

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.45);
            z-index: 50;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.open {
            display: flex;
        }
    </style>
</head>

<body class="bg-background text-on-surface overflow-x-hidden">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<div class="ml-80 min-h-screen flex flex-col">
    <main class="flex-1 p-8 pt-28 space-y-6">

        <!-- 브레드크럼 -->
        <div class="flex items-center justify-between">
            <div class="flex items-center gap-2 text-xs text-slate-400">
                <span>Home</span><span>›</span>
                <span>계약관리</span><span>›</span>
                <a href="${pageContext.request.contextPath}/contract/list.do"
                   class="hover:text-primary-container transition-colors">계약공고</a><span>›</span>
                <span class="text-primary-container font-semibold">상세보기</span>
            </div>
            <a href="${pageContext.request.contextPath}/contract/list.do"
               class="flex items-center gap-1.5 text-sm text-slate-500 hover:text-primary-container transition-colors font-medium">
                <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                목록으로
            </a>
        </div>

        <!-- 헤더 카드 -->
        <section class="bg-white rounded-lg border border-[#eef2eb] shadow-sm overflow-hidden">
            <div class="h-1.5 w-full bg-gradient-to-r from-[#004830] via-[#226046] to-[#95d4b3]"></div>
            <div class="p-8">
                <div class="flex flex-wrap items-center gap-2 mb-4">
                    <span class="bg-secondary-container text-on-secondary-container text-[11px] font-bold px-3 py-1 rounded-full">${announcement.statusNm}</span>
                    <span class="ml-auto text-xs text-slate-400 flex items-center gap-1">
            <span class="material-symbols-outlined text-[15px]">visibility</span> ${announcement.inqCnt} 조회
          </span>
                </div>
                <h1 class="font-headline text-2xl font-bold text-[#004830] leading-snug mb-6">${announcement.ttl}</h1>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
                        <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">공고번호</p>
                        <p class="text-sm font-bold text-[#004830]">${announcement.annNo}</p>
                    </div>
                    <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
                        <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">단지</p>
                        <p class="text-sm font-bold text-[#004830]">${announcement.aptCmplexNm}</p>
                    </div>
                    <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
                        <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">모집시작일</p>
                        <p class="text-sm font-bold text-[#004830]">${announcement.rcrtBgngDt}</p>
                    </div>
                    <div class="bg-[#f8faf6] rounded-lg p-4 space-y-1">
                        <p class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">모집마감일</p>
                        <p class="text-sm font-bold text-[#004830] flex items-center gap-1">
                            <span class="material-symbols-outlined text-[15px] text-slate-400">timer</span>${announcement.rcrtEndDt}
                        </p>
                    </div>
                </div>
            </div>
        </section>

        <!-- 레이아웃: 좌측 컨텐츠 + 우측 사이드바 -->
        <div class="grid grid-cols-3 gap-6 items-start">

            <!-- 좌측: 탭 + 공고 내용 -->
            <div class="col-span-2 space-y-6">
                <div class="bg-white rounded-lg border border-[#eef2eb] shadow-sm overflow-hidden">
                    <div class="flex border-b border-[#eef2eb] px-6">
                        <button class="tab-btn active px-5 py-4 text-sm" data-tab="detail">공고 내용</button>
                        <button class="tab-btn px-5 py-4 text-sm" data-tab="doc">제출 서류</button>
                    </div>
                    <div class="p-8">

                        <!-- 공고 내용 탭 -->
                        <div class="tab-panel active" id="tab-detail">
                            <div class="prose max-w-none text-sm text-slate-700 leading-relaxed">
                                ${announcement.cn}
                            </div>
                        </div>

                        <!-- 제출 서류 탭 -->
                        <div class="tab-panel" id="tab-doc">
                            <div class="space-y-3">
                                <p class="text-sm font-bold text-[#004830] mb-4">제출 서류 목록</p>
                                <c:if test="${not empty announcement.sbmsnDoc}">
                                    <c:forEach var="doc" items="${fn:split(announcement.sbmsnDoc, ',')}">
                                        <div class="flex items-center gap-3 p-3 bg-[#f8faf6] rounded-lg border border-[#eef2eb]">
                                            <span class="material-symbols-outlined text-[#226046] text-[18px]">description</span>
                                            <span class="text-sm text-slate-700">${doc}</span>
                                        </div>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${empty announcement.sbmsnDoc}">
                                    <p class="text-sm text-slate-400">제출 서류 정보가 없습니다.</p>
                                </c:if>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

            <!-- 우측 사이드바 -->
            <div class="col-span-1 space-y-4 sticky top-28">

                <!-- 청약 신청 버튼 -->
                <c:if test="${announcement.statusNm == '진행중'}">
                    <div class="bg-white rounded-lg border border-[#eef2eb] p-5">
                        <button onclick="openApplyModal()"
                                class="w-full bg-[#004830] text-white py-3 rounded-lg text-sm font-bold hover:bg-[#226046] transition-all">
                            청약 신청하기
                        </button>
                    </div>
                </c:if>

                <!-- 공고 정보 -->
                <div class="bg-white rounded-lg border border-[#eef2eb] p-5 space-y-3">
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-wider">공고 정보</p>
                    <div class="space-y-2.5 text-sm">
                        <div class="flex items-start justify-between gap-2">
                            <span class="text-slate-400 text-xs">공고번호</span>
                            <span class="font-bold text-[#004830] text-xs">${announcementDTO.annNo}</span>
                        </div>
                        <div class="border-t border-[#f1f3ef]"></div>
                        <div class="flex items-start justify-between gap-2">
                            <span class="text-slate-400 text-xs">단지명</span>
                            <span class="text-xs font-bold text-[#004830]">${announcementDTO.aptCmplexNm}</span>
                        </div>
                        <div class="border-t border-[#f1f3ef]"></div>
                        <div class="flex items-start justify-between gap-2">
                            <span class="text-slate-400 text-xs">주소</span>
                            <span class="font-medium text-slate-600 text-xs text-right">${announcement.dorojuso}</span>
                        </div>
                        <div class="border-t border-[#f1f3ef]"></div>
                        <div class="flex items-start justify-between gap-2">
                            <span class="text-slate-400 text-xs">모집기간</span>
                            <span class="font-medium text-slate-600 text-xs text-right">${announcement.rcrtBgngDt} ~ ${announcement.rcrtEndDt}</span>
                        </div>
                        <div class="border-t border-[#f1f3ef]"></div>
                        <div class="flex items-start justify-between gap-2">
                            <span class="text-slate-400 text-xs">공급세대수</span>
                            <span class="font-medium text-slate-600 text-xs">${announcement.supplyDisplay}</span>
                        </div>
                    </div>
                </div>

                <!-- 목록으로 버튼 -->
                <a href="${pageContext.request.contextPath}/contract/list.do"
                   class="flex items-center justify-center gap-2 w-full px-6 py-3 bg-white border border-[#eef2eb] rounded-lg text-sm font-medium text-slate-600 hover:bg-[#f8faf6] transition-colors">
                    <span class="material-symbols-outlined text-[16px]">list</span>
                    목록으로
                </a>

            </div>
        </div>
    </main>
</div>

<!-- 청약 신청 모달 -->
<div id="applyModal" class="modal-overlay">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg mx-4 p-8">

        <div class="flex justify-between items-center mb-6">
            <h2 class="text-xl font-bold text-gray-900">청약 신청</h2>
            <button onclick="closeApplyModal()" class="text-gray-400 hover:text-gray-600">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <!-- 공고 정보 -->
        <div class="bg-[#eef2e6] rounded-xl p-4 mb-6">
            <p class="text-xs text-[#4d5c2b] font-semibold mb-1">신청 공고</p>
            <p class="text-sm font-bold text-[#253000] mb-1">${announcement.ttl}</p>
            <p class="text-xs text-[#4d5c2b]">${announcement.aptCmplexNm}</p>
            <p class="text-xs text-gray-500 mt-1">모집 마감: ${announcement.rcrtEndDt}</p>
        </div>

        <!-- 신청자 정보 -->
        <div class="space-y-4 mb-6">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs text-gray-500 mb-1">이름</label>
                    <input type="text" value="${principal.member.userNm}" readonly
                           class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-gray-50 text-sm text-gray-500 cursor-not-allowed"/>
                </div>
                <div>
                    <label class="block text-xs text-gray-500 mb-1">연락처</label>
                    <input type="text" value="${principal.member.userTelno}" readonly
                           class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-gray-50 text-sm text-gray-500 cursor-not-allowed"/>
                </div>
            </div>
            <div>
                <label class="block text-xs text-gray-500 mb-1">주민번호 <span class="text-red-400">*</span></label>
                <input type="text" id="modalRrno" placeholder="000000-0000000" maxlength="14"
                       class="w-full px-4 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-[#5c6b2f]"/>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs text-gray-500 mb-1">대리인 이름 <span
                            class="text-gray-300">(선택)</span></label>
                    <input type="text" id="modalAgntNm" placeholder="대리인 이름"
                           class="w-full px-4 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-[#5c6b2f]"/>
                </div>
                <div>
                    <label class="block text-xs text-gray-500 mb-1">대리인 연락처 <span
                            class="text-gray-300">(선택)</span></label>
                    <input type="text" id="modalAgntTelno" placeholder="연락처"
                           class="w-full px-4 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-[#5c6b2f]"/>
                </div>
            </div>
            <div>
                <label class="block text-xs text-gray-500 mb-1">특약사항 <span class="text-gray-300">(선택)</span></label>
                <textarea id="modalSpcl" rows="3" placeholder="특약사항 입력"
                          class="w-full px-4 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-[#5c6b2f] resize-none"></textarea>
            </div>
        </div>

        <!-- 동의 -->
        <div class="space-y-2 mb-6">
            <label class="flex items-center gap-2 cursor-pointer text-sm text-gray-600">
                <input type="checkbox" id="agreePrivacy" class="w-4 h-4 accent-[#5c6b2f]"/>
                개인정보 수집 및 이용 동의 <span class="text-red-400 text-xs">[필수]</span>
            </label>
            <label class="flex items-center gap-2 cursor-pointer text-sm text-gray-600">
                <input type="checkbox" id="agreeFinance" class="w-4 h-4 accent-[#5c6b2f]"/>
                금융정보 제공 동의 <span class="text-red-400 text-xs">[필수]</span>
            </label>
        </div>

        <div class="flex justify-end gap-3">
            <button onclick="closeApplyModal()" class="px-5 py-2 bg-gray-200 rounded-full text-sm">취소</button>
            <button onclick="submitApply()" class="px-6 py-2 bg-[#5c6b2f] text-white rounded-full text-sm">청약 신청하기
            </button>
        </div>

    </div>
</div>

<input type="hidden" id="csrfToken" name="${_csrf.parameterName}" value="${_csrf.token}"/>
<input type="hidden" id="csrfHeader" value="${_csrf.headerName}"/>
<input type="hidden" id="annNo" value="${announcement.annNo}"/>
<input type="hidden" id="aptCmplexNo" value="${announcement.aptCmplexNo}">

<script>
    // 탭 전환
    document.querySelectorAll('.tab-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
            btn.classList.add('active');
            document.getElementById('tab-' + btn.dataset.tab).classList.add('active');
        });
    });

    // 모달 오픈/닫기
    function openApplyModal() {
        document.querySelector('#modalRrno').value = '';
        document.querySelector('#agreePrivacy').checked = false;
        document.querySelector('#agreeFinance').checked = false;
        document.querySelector('#applyModal').classList.add('open');
    }

    function closeApplyModal() {
        document.querySelector('#applyModal').classList.remove('open');
    }

    // 주민번호 자동 하이픈
    document.querySelector('#modalRrno').addEventListener('input', function () {
        let val = this.value.replace(/\D/g, '');
        if (val.length > 6) val = val.substring(0, 6) + '-' + val.substring(6, 13);
        this.value = val;
    });

    // 청약 신청 제출
    function submitApply() {
        const rrno = document.querySelector('#modalRrno').value.trim();
        if (!rrno) {
            Swal.fire({icon: 'warning', title: '주민번호 입력', text: '주민번호를 입력해주세요.', confirmButtonColor: '#5c6b2f'});
            return;
        }
        if (!document.querySelector('#agreePrivacy').checked || !document.querySelector('#agreeFinance').checked) {
            Swal.fire({icon: 'warning', title: '동의 필요', text: '필수 항목에 동의해주세요.', confirmButtonColor: '#5c6b2f'});
            return;
        }

        Swal.fire({
            icon: 'question',
            title: '청약 신청하시겠습니까?',
            text: '신청 후 심사 결과를 기다려주세요.',
            confirmButtonColor: '#5c6b2f',
            confirmButtonText: '신청하기',
            showCancelButton: true,
            cancelButtonText: '취소'
        }).then(result => {
            if (result.isConfirmed) {
                const data = {
                    annNo: document.querySelector('#annNo').value,
                    aptCmplexNo: document.querySelector('#aptCmplexNo').value,
                    userRrno: rrno,
                    agntNm: document.querySelector('#modalAgntNm').value,
                    agntTelno: document.querySelector('#modalAgntTelno').value,
                    spclStpltnCn: document.querySelector('#modalSpcl').value
                };

                fetch('${pageContext.request.contextPath}/contract/request.do', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        [document.querySelector('#csrfHeader').value]: document.querySelector('#csrfToken').value
                    },
                    body: JSON.stringify(data)
                })
                    .then(res => res.json())
                    .then(result => {
                        if (result.success) {
                            Swal.fire({
                                icon: 'success',
                                title: '청약 신청 완료',
                                text: '심사 결과를 기다려주세요.',
                                confirmButtonColor: '#5c6b2f'
                            }).then(() => {
                                window.location.href = '${pageContext.request.contextPath}/contract/history.do';
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: '오류',
                                text: '신청 중 오류가 발생했습니다.',
                                confirmButtonColor: '#5c6b2f'
                            });
                        }
                    });
            }
        });
    }

    // 모달 외부 클릭 닫기
    document.querySelector('#applyModal').addEventListener('click', function (e) {
        if (e.target === this) closeApplyModal();
    });
</script>

</body>
</html>
