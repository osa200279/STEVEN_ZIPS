<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>민원신청 ${apt.aptCmplexNm}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">
    <style>
        /* 모달 배경 레이어 */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2000;
        }

        /* 모달 컨텐츠 박스 */
        .modal-content {
            width: 100%;
            max-width: 800px; /* 상세 정보라 조금 넓게 잡음 */
            max-height: 90vh;
            overflow-y: auto;
            animation: modalFadeIn 0.3s ease-out;
        }

        .modal-close-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: var(--text-light);
            display: flex;
            align-items: center;
        }

        .modal-close-btn:hover {
            color: var(--danger);
        }

        @keyframes modalFadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 모달 내 텍스트 영역 가독성 보완 */
        #modalCn {
            white-space: pre-wrap;
            word-break: break-all;
            font-size: 13px;
            line-height: 1.8;
            color: var(--text-dark);
        }

        .panel {
            width: 100%;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">
            <div class="breadcrumb">
                <a href="/apt/main/${apt.aptCmplexNo}">${apt.aptCmplexNm}</a>
                <span>›</span>
                <a href="javascript:void(0);">민원접수</a>
                <span>›</span>
                <span class="cur">민원 내역</span>
            </div>
            <h1 class="page-title">우리 아파트 민원 내역</h1>
            <div class="panel">
                <div class="section-hd">
                    <h3>민원 내역</h3>
                </div>
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>접수일</th>
                        <th>민원인ID</th>
                        <th>카테고리</th>
                        <th>제목</th>
                        <th>발생장소</th>
                        <th>상태</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="cvplBody">
                    <c:forEach var="cvpl" items="${cvplList}">
                        <tr onclick="openCvplDetail('${cvpl.cvplNo}')" style="cursor:pointer;">
                            <td><fmt:formatDate value="${cvpl.cvplRegDt}" pattern="yyyy.MM.dd HH:mm"/></td>
                            <td>${cvpl.userId}</td>
                            <td>${cvpl.cvplTyCd}</td>
                            <td>${cvpl.cvplTtl}</td>
                            <td>${cvpl.cvplLoc}</td>
                            <c:choose>
                                <c:when test="${cvpl.cvplSttsCd eq 'APLY'}">
                                    <td><span class="badge wait">민원 신청됨</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'CNCL'}">
                                    <td><span class="badge cancel">민원 취소됨</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'RCPT'}">
                                    <td><span class="badge ok">민원 접수됨</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'SUPL'}">
                                    <td><span class="badge wait">보완 요청</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'REJS'}">
                                    <td><span class="badge wait">처리 불가</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'RJCT'}">
                                    <td><span class="badge wait">반려</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'COMP'}">
                                    <td><span class="badge info">처리 완료</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplSttsCd eq 'END'}">
                                    <td><span class="badge info">종결</span></td>
                                </c:when>
                            </c:choose>
                            <%--<td><button class="btn-sz-outline">상세보기</button></td>--%>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</div>

<%-- 민원 상세 내역 모달창 --%>
<div id="cvplDetailModal" class="modal-overlay" style="display: none;">
    <div class="modal-content panel">
        <div class="section-hd">
            <h3>민원 상세 내역</h3>
            <button type="button" class="modal-close-btn" onclick="closeModal()">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="modal-body">
            <div class="label-grid">
                <div class="th">제목</div>
                <div id="modalTtl" class="td" style="grid-column: span 3;"></div>

                <div class="th">카테고리</div>
                <div id="modalTy" class="td"></div>
                <div class="th">접수일시</div>
                <div id="modalDate" class="td"></div>

                <div class="th">발생장소</div>
                <div id="modalLoc" class="td" style="grid-column: span 3;"></div>

                <div class="th">처리상태</div>
                <div id="modalStatus" class="td" style="grid-column: span 3;"></div>
            </div>

            <div class="section-hd" style="margin-top: 24px; border-bottom: none;">
                <h3>민원 설명</h3>
            </div>
            <div id="modalCn" class="fake-textarea"
                 style="background: var(--bg); border-color: var(--border); margin-bottom: 20px;">
            </div>

            <div class="section-hd" style="border-bottom: none;">
                <h3>첨부 파일</h3>
            </div>
            <div id="modalFiles" class="chip-row"
                 style="background: var(--bg); padding: 15px; border-radius: 12px; border: 1px solid var(--border);">
                <span class="chip" style="background: var(--text-light);">첨부된 파일이 없습니다.</span>
            </div>
        </div>

        <div class="btn-row">
            <button class="btn-ghost" onclick="closeModal()">닫기</button>
            <button id="modalModifyBtn" class="btn-main">수정하기</button>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
<script>
    function closeModal() {
        document.querySelector('#cvplDetailModal').style.display = 'none';
        document.body.style.overflow = 'auto'; // 스크롤 복구
    }

    // 2. 민원 상세 조회 및 모달 오픈
    async function openCvplDetail(cvplNo) {
        try {
            // 상세 데이터를 가져오는 API 호출 (예시 주소)
            const resp = await fetch(`/apt/complaint/detail/${cvplNo}`);
            if (!resp.ok) throw new Error("상세 정보를 불러올 수 없습니다.");

            const cvpl = await resp.json();

            // 모달 데이터 매핑
            document.querySelector('#modalTtl').innerText = cvpl.cvplTtl;
            document.querySelector('#modalTy').innerText = cvpl.cvplTyNm; // 카테고리 한글명
            document.querySelector('#modalDate').innerText = new Date(cvpl.cvplRegDt).toLocaleString();
            document.querySelector('#modalLoc').innerText = cvpl.cvplLoc || '장소 미지정';
            document.querySelector('#modalCn').innerText = cvpl.cvplCn;

            // 배지 처리 (상태 코드에 따른 HTML 생성)
            const statusBox = document.querySelector('#modalStatus');
            statusBox.innerHTML = getBadgeHtml(cvpl.cvplSttsCd); // 기존에 만든 getBadgeHtml 재사용

            // 파일 칩 처리
            const fileBox = document.querySelector('#modalFiles');
            if (cvpl.fileList && cvpl.fileList.length > 0) {
                fileBox.innerHTML = cvpl.fileList.map(f => `
                <a href="/download/${f.fileNo}" class="chip" style="background: var(--green-dark); cursor:pointer;">
                    <span class="material-symbols-outlined" style="font-size:14px;">download</span>
                    ${f.orgnlFileNm}
                </a>
            `).join('');
            } else {
                fileBox.innerHTML = '<span class="chip" style="background: var(--text-light);">첨부된 파일이 없습니다.</span>';
            }

            // 모달 표시
            document.querySelector('#cvplDetailModal').style.display = 'flex';
            document.body.style.overflow = 'hidden'; // 배경 스크롤 방지

        } catch (error) {
            alert(error.message);
        }
    }

    function getBadgeHtml(statusCd) {
        const statusMap = {
            'APLY': {text: '민원 신청됨', cls: 'wait'},
            'RCPT': {text: '민원 접수됨', cls: 'ok'},
            'SUPL': {text: '보완 요청', cls: 'wait'},
            'REJS': {text: '처리 불가', cls: 'wait'},
            'RJCT': {text: '반려', cls: 'wait'},
            'COMP': {text: '처리 완료', cls: 'info'},
            'END': {text: '종결', cls: 'info'}
        };
        const res = statusMap[statusCd] || {text: '대기', cls: 'wait'};
        return `<span class="badge ${res.cls}">${res.text}</span>`;
    }
</script>
</html>
