<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>민원 내역 - ${aptInfo.aptComplexInfo.aptCmplexNm}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">
    <style>
        .modal-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(4px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2000;
        }
        .modal-content {
            width: 100%;
            max-width: 800px;
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
        .modal-close-btn:hover { color: var(--danger); }
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        #modalCn {
            white-space: pre-wrap;
            word-break: break-all;
            font-size: 13px;
            line-height: 1.8;
            color: var(--text-dark);
        }
        .panel { width: 100%; }
        .pagination-wrap { margin-top: 20px; display: flex; justify-content: center; }
        .pagination { display: flex; list-style: none; padding: 0; margin: 0; gap: 4px; }
        .pagination .page-item .page-link {
            display: inline-flex; align-items: center; justify-content: center;
            width: 32px; height: 32px; border-radius: 6px;
            border: 1px solid var(--green-dark); color: var(--green-dark);
            text-decoration: none; font-size: 13px; cursor: pointer;
        }
        .pagination .page-item.active .page-link {
            background: var(--green-dark); color: #fff; border-color: var(--green-dark);
        }
        .pagination .page-item .page-link:hover {
            background: var(--green-dark); color: #fff;
        }
        .pagination .page-item.disabled .page-link {
            cursor: default; border: none; color: var(--text-light);
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
                <a href="/apt/main/${aptInfo.aptComplexInfo.aptCmplexNo}">${aptInfo.aptComplexInfo.aptCmplexNm}</a>
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
                        <th>민원 번호</th>
                        <th>접수일</th>
                        <th>카테고리</th>
                        <th>제목</th>
                        <th>발생장소</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody id="cvplBody">
                    <c:forEach var="cvpl" items="${cvplList}">
                        <tr onclick="openCvplDetail('${cvpl.cvplNo}')" style="cursor:pointer;">
                            <td>${cvpl.cvplNo}</td>
                            <td><fmt:formatDate value="${cvpl.cvplRegDt}" pattern="yyyy.MM.dd HH:mm"/></td>
                            <c:choose>
                                <c:when test="${cvpl.cvplTyCd eq 'FAC'}">
                                    <td><span class="badge wait">시설/하자</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'SEC'}">
                                    <td><span class="badge cancel">보안/안전</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'ACC'}">
                                    <td><span class="badge ok">회계/관리비</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'ENV'}">
                                    <td><span class="badge wait">환경/위생</span></td>
                                </c:when>
                                <c:when test="${cvpl.cvplTyCd eq 'ETC'}">
                                    <td><span class="badge wait">기타</span></td>
                                </c:when>
                                <c:otherwise>
                                    <td>${cvpl.cvplTyCd}</td>
                                </c:otherwise>
                            </c:choose>
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
                        </tr>
                    </c:forEach>
                    <c:if test="${empty cvplList}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 40px; color: var(--text-light);">
                                접수된 민원이 없습니다.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>

                <%-- 페이징 --%>
                <c:if test="${page.totalRecord > 0}">
                    <div class="pagination-wrap">
                        <%=((kr.or.ddit.common.model.PaginationInfoVO)request.getAttribute("page")).getPagingHTML()%>
                    </div>
                </c:if>
            </div>
        </div>
    </main>
</div>

<%-- 민원 상세 내역 모달 --%>
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
                <div class="th">민원 번호</div>
                <div id="modalNo" class="td" style="grid-column: span 3;"></div>

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
                 style="background: var(--bg); border-color: var(--border); margin-bottom: 20px;"></div>

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
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
<script>
    const aptCmplexNo = '${aptInfo.aptComplexInfo.aptCmplexNo}';

    function closeModal() {
        document.querySelector('#cvplDetailModal').style.display = 'none';
        document.body.style.overflow = 'auto';
    }

    async function openCvplDetail(cvplNo) {
        try {
            const url = '/apt/complaint/detail/' + aptCmplexNo + '/' + cvplNo;
            const resp = await fetch(url);
            if (!resp.ok) throw new Error("상세 정보를 불러올 수 없습니다.");

            const data = await resp.json();
            const cvpl = data.detail;
            const files = data.files;

            document.querySelector('#modalNo').innerText     = cvpl.cvplNo;
            document.querySelector('#modalTtl').innerText    = cvpl.cvplTtl;
            document.querySelector('#modalTy').innerText     = getCategoryText(cvpl.cvplTyCd);
            document.querySelector('#modalDate').innerText   = new Date(cvpl.cvplRegDt).toLocaleString('ko-KR');
            document.querySelector('#modalLoc').innerText    = cvpl.cvplLoc || '장소 미지정';
            document.querySelector('#modalCn').innerText     = cvpl.cvplCn  || '';
            document.querySelector('#modalStatus').innerText = getStatusText(cvpl.cvplSttsCd);

            const fileBox = document.querySelector('#modalFiles');
            if (files && files.length > 0) {
                fileBox.innerHTML = files.map(f =>
                    '<a href="/download/' + f.fileNo + '" class="chip" style="background: var(--green-dark); cursor:pointer;">' +
                    '<span class="material-symbols-outlined" style="font-size:14px;">download</span>' +
                    f.orgnlFileNm + '</a>'
                ).join('');
            } else {
                fileBox.innerHTML = '<span class="chip" style="background: var(--text-light);">첨부된 파일이 없습니다.</span>';
            }

            document.querySelector('#cvplDetailModal').style.display = 'flex';
            document.body.style.overflow = 'hidden';

        } catch (error) {
            alert(error.message);
        }
    }

    function getCategoryText(tyCd) {
        const categoryMap = {
            'FAC': '시설/하자',
            'SEC': '보안/안전',
            'ACC': '회계/관리비',
            'ENV': '환경/위생',
            'ETC': '기타'
        };
        return categoryMap[tyCd] || tyCd;
    }

    function getStatusText(statusCd) {
        const statusMap = {
            'APLY': '민원 신청됨',
            'CNCL': '민원 취소됨',
            'RCPT': '민원 접수됨',
            'SUPL': '보완 요청',
            'REJS': '처리 불가',
            'RJCT': '반려',
            'COMP': '처리 완료',
            'END' : '종결'
        };
        return statusMap[statusCd] || '알 수 없음';
    }

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') closeModal();
    });

    document.querySelector('#cvplDetailModal').addEventListener('click', function(e) {
        if (e.target === this) closeModal();
    });

    document.addEventListener('click', function(e) {
        const pageLink = e.target.closest('[data-page]');
        if (pageLink) {
            e.preventDefault();
            const pageNum = pageLink.getAttribute('data-page');
            location.href = '/apt/complaint/list/' + aptCmplexNo + '?curPage=' + pageNum;
        }
    });
</script>
</html>
