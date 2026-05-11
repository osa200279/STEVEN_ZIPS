  <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
  <!DOCTYPE html>
  <html lang="ko">
  <head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>계약공고 - 우리집맵핑</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=Manrope:wght@400;500;600;700&family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
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
              "secondary": "#2c6956",
              "secondary-container": "#aeedd5",
              "on-secondary-container": "#316d5b",
              "surface": "#f8faf6",
              "on-surface": "#191c1a",
              "outline": "#707973",
              "surface-container": "#eceeea",
            },
            borderRadius: {
              "DEFAULT": "1rem",
              "lg": "2rem",
              "xl": "3rem",
              "full": "9999px"
            },
            fontFamily: {
              "headline": ["Plus Jakarta Sans"],
              "body": ["Manrope"],
              "label": ["Manrope"]
            }
          },
        },
      }
    </script>
    <style>
      body { font-family: 'Manrope', sans-serif; background-color: #f8faf6; color: #191c1a; }
      .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; }
      .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.45); z-index: 50; align-items: center; justify-content: center; }
      .modal-overlay.open { display: flex; }
    </style>
  </head>
  <body class="bg-background text-on-surface overflow-x-hidden">

  <%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
  <%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

  <div class="ml-80 min-h-screen flex flex-col">
    <main class="flex-1 p-8 pt-28 space-y-8">

      <!-- 페이지 헤더 -->
      <div class="flex justify-between items-end">
        <div class="space-y-2">
          <h1 class="text-3xl font-bold text-gray-900 mb-2">계약공고</h1>
          <p class="text-gray-500 text-sm">진행 중인 계약 공고를 확인하고 참여할 수 있습니다.</p>
        </div>
      </div>

      <!-- 검색 필터 -->
      <section class="bg-white p-6 rounded-lg border border-[#eef2eb] shadow-sm space-y-4">
        <div class="grid grid-cols-4 gap-4">
          <div class="space-y-2">
            <label class="text-xs font-bold text-slate-500 ml-1">지역</label>
            <select id="searchRegion" class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm">
              <option value="">전체</option>
              <option value="서울">서울</option>
              <option value="경기">경기</option>
              <option value="인천">인천</option>
            </select>
          </div>
          <div class="space-y-2">
            <label class="text-xs font-bold text-slate-500 ml-1">상태</label>
            <select id="searchStatus" class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm">
              <option value="">전체</option>
              <option value="진행중">진행중</option>
              <option value="마감">마감</option>
            </select>
          </div>
          <div class="space-y-2">
            <label class="text-xs font-bold text-slate-500 ml-1">시작일</label>
            <input type="date" id="searchFrom" class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm"/>
          </div>
          <div class="space-y-2">
            <label class="text-xs font-bold text-slate-500 ml-1">종료일</label>
            <input type="date" id="searchTo" class="w-full bg-[#f1f3ef] border-none rounded-lg py-3 px-4 text-sm"/>
          </div>
        </div>
        <div class="flex gap-3">
          <input id="searchTtl" class="flex-1 bg-[#f1f3ef] border-none rounded-lg py-4 px-5 text-sm" placeholder="공고명 또는 아파트명을 입력하세요" type="text"/>
          <button onclick="searchList()" class="bg-[#6F7F3F] text-white px-10 py-4 rounded-lg font-bold hover:bg-[#5f6e35] transition-all">검색</button>
        </div>
      </section>

      <!-- 공고 목록 테이블 -->
      <div class="bg-white rounded-lg border border-[#eef2eb] shadow-sm overflow-hidden">
        <table class="w-full text-left border-collapse">
          <thead class="bg-[#f1f3ef]/50 border-b border-[#eef2eb]">
          <tr>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase">번호</th>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase">공고명</th>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase">단지</th>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase text-center">첨부</th>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase">모집기간</th>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase">상태</th>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase">조회수</th>
            <th class="px-6 py-4 text-xs font-bold text-slate-500 uppercase">신청</th>
          </tr>
          </thead>
          <tbody class="divide-y divide-[#eef2eb]">
          <c:choose>
            <c:when test="${not empty list}">
              <c:forEach var="ann" items="${list}" varStatus="status">
                <tr class="hover:bg-[#f8faf6] transition-colors group">
                  <td class="px-6 py-5 text-sm text-slate-400">${ann.annNo}</td>
                  <td class="px-6 py-5 text-sm font-semibold text-[#004830]">
                    <a href="${pageContext.request.contextPath}/contract/detail.do?annNo=${ann.annNo}" class="group-hover:underline cursor-pointer">
                        ${ann.ttl}
                    </a>
                  </td>
                  <td class="px-6 py-5 text-sm text-slate-600">${ann.aptCmplexNm}</td>
                  <td class="px-6 py-5 text-center">
                    <c:if test="${ann.hasFileYn == 'Y'}">
                      <span class="material-symbols-outlined text-slate-400 text-[20px]">attachment</span>
                    </c:if>
                  </td>
                  <td class="px-6 py-5 text-sm text-slate-500">${ann.rcrtBgngDt} ~ ${ann.rcrtEndDt}</td>
                  <td class="px-6 py-5">
                    <c:choose>
                      <c:when test="${ann.statusNm == '진행중'}">
                        <span class="bg-secondary-container text-on-secondary-container text-[11px] font-bold px-3 py-1 rounded-full">공고중</span>
                      </c:when>
                      <c:otherwise>
                        <span class="bg-slate-200 text-slate-500 text-[11px] font-bold px-3 py-1 rounded-full">${ann.statusNm}</span>
                      </c:otherwise>
                    </c:choose>
                  </td>
                  <td class="px-6 py-5 text-sm text-slate-400">${ann.inqCnt}</td>
                  <td class="px-6 py-5">
                    <c:if test="${ann.statusNm == '진행중'}">
                      <button onclick="openApplyModal('${ann.annNo}', '${ann.ttl}', '${ann.aptCmplexNm}', '${ann.rcrtEndDt}', '${ann.aptCmplexNo}')"
                              class="bg-[#5c6b2f] text-white text-xs px-4 py-2 rounded-full hover:bg-[#4a5826] transition-all">
                        신청하기
                      </button>
                    </c:if>
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td colspan="8" class="px-6 py-16 text-center text-slate-400 text-sm">공고가 없습니다.</td>
              </tr>
            </c:otherwise>
          </c:choose>
          </tbody>
        </table>
      </div>

      <!-- 페이지네이션 -->
      <div class="flex justify-center items-center gap-2 py-4">
        <button class="w-10 h-10 flex items-center justify-center rounded-full border border-[#eef2eb] hover:bg-white text-slate-400">
          <span class="material-symbols-outlined">chevron_left</span>
        </button>
        <button class="w-10 h-10 flex items-center justify-center rounded-full bg-primary-container text-white font-bold">1</button>
        <button class="w-10 h-10 flex items-center justify-center rounded-full border border-[#eef2eb] hover:bg-white text-slate-400">
          <span class="material-symbols-outlined">chevron_right</span>
        </button>
      </div>

    </main>
  </div>

  <!-- 청약 신청 모달 -->
  <div id="applyModal" class="modal-overlay">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-lg mx-4 p-8">

      <!-- 모달 헤더 -->
      <div class="flex justify-between items-center mb-6">
        <h2 class="text-xl font-bold text-gray-900">청약 신청</h2>
        <button onclick="closeApplyModal()" class="text-gray-400 hover:text-gray-600">
          <span class="material-symbols-outlined">close</span>
        </button>
      </div>

      <!-- 공고 정보 -->
      <div class="bg-[#eef2e6] rounded-xl p-4 mb-6">
        <p class="text-xs text-[#4d5c2b] font-semibold mb-1">신청 공고</p>
        <p id="modalAnnNm" class="text-sm font-bold text-[#253000] mb-1"></p>
        <p id="modalAptNm" class="text-xs text-[#4d5c2b]"></p>
        <p class="text-xs text-gray-500 mt-1">모집 마감: <span id="modalEndDt"></span></p>
      </div>

      <!-- 신청자 정보 -->
      <div class="space-y-4 mb-6">
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-500 mb-1">이름</label>
            <input type="text" id="modalUserNm"
                   value="${principal.member.userName}"
                   readonly
                   class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-gray-50 text-sm text-gray-500 cursor-not-allowed"/>
          </div>
          <div>
            <label class="block text-xs text-gray-500 mb-1">연락처</label>
            <input type="text" id="modalTelno"
                   value="${principal.member.userTelno}"
                   readonly
                   class="w-full px-4 py-2 rounded-xl border border-gray-200 bg-gray-50 text-sm text-gray-500 cursor-not-allowed"/>
          </div>
        </div>
        <div>
          <label class="block text-xs text-gray-500 mb-1">주민번호 <span class="text-red-400">*</span></label>
          <input type="text" id="modalRrno"
                 placeholder="000000-0000000"
                 maxlength="14"
                 class="w-full px-4 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-[#5c6b2f]"/>
        </div>
        <div class="grid grid-cols-2 gap-4">
          <div>
            <label class="block text-xs text-gray-500 mb-1">대리인 이름 <span class="text-gray-300">(선택)</span></label>
            <input type="text" id="modalAgntNm"
                   placeholder="대리인 이름"
                   class="w-full px-4 py-2 rounded-xl border border-gray-200 text-sm focus:outline-none focus:border-[#5c6b2f]"/>
          </div>
          <div>
            <label class="block text-xs text-gray-500 mb-1">대리인 연락처 <span class="text-gray-300">(선택)</span></label>
            <input type="text" id="modalAgntTelno"
                   placeholder="연락처"
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

      <!-- 버튼 -->
      <div class="flex justify-end gap-3">
        <button onclick="closeApplyModal()" class="px-5 py-2 bg-gray-200 rounded-full text-sm">취소</button>
        <button onclick="submitApply()" class="px-6 py-2 bg-[#5c6b2f] text-white rounded-full text-sm">청약 신청하기</button>
      </div>

    </div>
  </div>

  <input type="hidden" id="csrfToken" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  <input type="hidden" id="csrfHeader" value="${_csrf.headerName}"/>
  <input type="hidden" id="currentAnnNo" value=""/>
  <input type="hidden" id="currentAptCmplexNo" value=""/>

  <script>
    // 검색
    function searchList() {
      const params = new URLSearchParams({
        searchTtl: document.querySelector('#searchTtl').value,
        searchFrom: document.querySelector('#searchFrom').value,
        searchTo: document.querySelector('#searchTo').value,
        searchStatus: document.querySelector('#searchStatus').value
      });
      window.location.href = '${pageContext.request.contextPath}/contract/list.do?' + params.toString();
    }

    // 엔터 검색
    document.querySelector('#searchTtl').addEventListener('keypress', function(e) {
      if (e.key === 'Enter') searchList();
    });

    // 모달 오픈
    function openApplyModal(annNo, annNm, aptNm, endDt, aptCmplexNo) {
      document.querySelector('#currentAnnNo').value = annNo;
      document.querySelector('#currentAptCmplexNo').value = aptCmplexNo;
      document.querySelector('#modalAnnNm').innerText = annNm;
      document.querySelector('#modalAptNm').innerText = aptNm;
      document.querySelector('#modalEndDt').innerText = endDt;
      document.querySelector('#modalRrno').value = '';
      document.querySelector('#agreePrivacy').checked = false;
      document.querySelector('#agreeFinance').checked = false;
      document.querySelector('#applyModal').classList.add('open');
    }

    // 모달 닫기
    function closeApplyModal() {
      document.querySelector('#applyModal').classList.remove('open');
    }

    // 주민번호 자동 하이픈
    document.querySelector('#modalRrno').addEventListener('input', function() {
      let val = this.value.replace(/\D/g, '');
      if (val.length > 6) val = val.substring(0, 6) + '-' + val.substring(6, 13);
      this.value = val;
    });

    // 청약 신청 제출
    function submitApply() {
      const rrno = document.querySelector('#modalRrno').value.trim();
      if (!rrno) {
        Swal.fire({ icon: 'warning', title: '주민번호 입력', text: '주민번호를 입력해주세요.', confirmButtonColor: '#5c6b2f' });
        return;
      }
      if (!document.querySelector('#agreePrivacy').checked || !document.querySelector('#agreeFinance').checked) {
        Swal.fire({ icon: 'warning', title: '동의 필요', text: '필수 항목에 동의해주세요.', confirmButtonColor: '#5c6b2f' });
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
            annNo: document.querySelector('#currentAnnNo').value,
            userRrno: rrno,
            aptCmplexNo: document.querySelector('#currentAptCmplexNo').value,
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
                      Swal.fire({ icon: 'error', title: '오류', text: '신청 중 오류가 발생했습니다.', confirmButtonColor: '#5c6b2f' });
                    }
                  });
            }
      });
    }

    // 모달 외부 클릭 시 닫기
    document.querySelector('#applyModal').addEventListener('click', function(e) {
      if (e.target === this) closeApplyModal();
    });
  </script>

  </body>
  </html>
