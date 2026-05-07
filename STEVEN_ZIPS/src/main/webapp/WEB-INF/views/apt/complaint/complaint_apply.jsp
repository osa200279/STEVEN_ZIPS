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
        .select {
            width: 100%;
            border: 1px solid #d8ddd4;
            border-radius: 10px;
            font-size: 13px;
            color: var(--text-dark);
            box-sizing: border-box;

            /* 화살표 커스텀 설정 */
            appearance: none;
            -webkit-appearance: none;
            /* 오른쪽에서 13px 띄움 */
            background: #fff url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23666%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E') no-repeat right 13px center;
            background-size: 10px; /* 화살표 크기 조절 */
            /* 화살표와 텍스트가 겹치지 않게 여백 추가 */
            padding: 11px 30px 11px 13px;
        }

        input.a-input, .a-textarea {
            width: 100%;
            border: 1px solid #d8ddd4;
            background: #fff;
            border-radius: 10px;
            padding: 11px 13px;
            font-size: 13px;
            color: var(--text-dark);
            box-sizing: border-box;
        }

        .a-textarea {
            height: 240px;
        }
    </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">
            <div class="breadcrumb">
                <a href="/apt/main/${apt.aptCmplexNo}">${apt.aptCmplexNm}</a>
                <span>›</span>
                <a href="javascript:void(0);">민원접수</a>
                <span>›</span>
                <span class="cur">민원신청</span>
            </div>
            <h1 class="page-title">민원신청</h1>
            <p class="page-desc">민원 카테고리 선택, 제목/내용/증빙파일 입력, 최근 접수 내역 확인 화면입니다.</p>

            <section class="grid-2">
                <div class="panel">
                    <div class="section-hd">
                        <h3>민원 접수 작성</h3>
                        <span>신청 폼</span>
                    </div>
                    <form name="cvplApplyForm" id="cvplApplyForm" method="post" enctype="multipart/form-data">
                        <div class="form-grid">
                            <div class="th">카테고리</div>
                            <div class="td">
                                <select name="cvplTyCd" class="select">
                                    <option value="FAC">시설/하자</option>
                                    <option value="SEC">보안/안전</option>
                                    <option value="ACC">회계/관리비</option>
                                    <option value="ENV">환경/위생</option>
                                    <option value="ETC">기타</option>
                                </select>
                            </div>
                            <div class="th">제목</div>
                            <div class="td">
                                <input type="text" name="cvplTtl" class="a-input"
                                       placeholder="제목을 입력하세요(ex. 승강기 멈춤)"/>
                            </div>
                            <div class="th">발생장소</div>
                            <div class="td">
                                <input type="text" name="cvplLoc" class="a-input"
                                       placeholder="구체적인 장소를 입력해주세요(ex.101동 지하 1층 주차장 B구역)"/>
                            </div>
                            <div class="th">증빙파일</div>
                            <div class="td">
                                <input type="file" name="attachFiles" class="a-input" multiple/>
                            </div>
                            <div class="th">설명</div>
                            <div class="td">
                                <textarea name="cvplCn" class="a-textarea"></textarea>
                            </div>
                            <div>
                                <input type="text" name="aptCmplexNo" hidden/>
                            </div>
                        </div>
                        <div class="btn-row">
                            <button id="submitBtn" class="btn-main">민원 접수</button>
                        </div>
                    </form>
                </div>
                <div class="panel">
                    <div class="section-hd">
                        <h3>내 민원 내역</h3>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>접수일</th>
                                <th>제목</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cvpl" items="${cvplList}">
                                <tr>
                                    <td><fmt:formatDate value="${cvpl.cvplRegDt}" pattern="yyyy.MM.dd HH:mm"/></td>
                                    <td>${cvpl.cvplTtl}</td>
                                    <c:choose>
                                        <c:when test="${cvpl.cvplSttsCd eq 'APLY'}">
                                            <td><span class="badge wait">민원 신청됨</span></td>
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
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        // 민원 접수 버튼 클릭 이벤트
        const submitBtn = document.querySelector("#submitBtn");
        submitBtn.addEventListener("click", async (e) => {
            e.preventDefault();

            const form = document.querySelector('#cvplApplyForm');
            const formData = new FormData(form);
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;

            const aptCmplexNo = "${apt.aptCmplexNo}";

            try {
                const resp = await fetch(`/apt/complaint/apply/${aptCmplexNo}`, {
                    method: 'POST',
                    headers: {
                        [csrfHeader]: csrfToken
                    },
                    body: formData
                });

                const result = await resp.json();
                if (resp.ok) {
                    alert(result.message);
                    // 민원 등록 후 폼 리셋
                    form.reset();
                } else {
                    alert("접수 실패 : " + result.message);
                }
            } catch (error) {
                console.error(error);
                alert("서버와 통신 중 문제가 발생했습니다.")
            }
        });
    });
</script>
</body>
</html>
