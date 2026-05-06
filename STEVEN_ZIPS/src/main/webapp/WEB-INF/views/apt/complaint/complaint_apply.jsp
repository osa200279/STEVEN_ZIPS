<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>민원신청 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">
</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">
            <div class="breadcrumb">
                <a href="/apt/main/${apt.aptCmplexNo}">HOME</a>
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
                                <input class="fake-input" value="지하주차장 조명 점검 요청"/>
                            </div>
                            <div class="th">발생장소</div>
                            <div class="td">
                                <input class="fake-input" value="지하 1층 B구역"/>
                            </div>
                            <div class="th">증빙파일</div>
                            <div class="td">
                                <input class="fake-input" value="parking_issue.jpg"/>
                            </div>
                            <div class="th">설명</div>
                            <div class="td">
                                <textarea class="fake-textarea">일부 구간 조명이 어두워 야간 이동 시 불편합니다.</textarea>
                            </div>
                        </div>
                        <div class="btn-row">
                            <button class="btn-main">민원 접수</button>
                        </div>
                    </form>
                </div>
                <div class="panel">
                    <div class="section-hd">
                        <h3>최근 접수 내역</h3>
                        <span>최근 3건</span>
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
                        <tr>
                            <td>2026-04-23</td>
                            <td>주차선 보수 요청</td>
                            <td><span class="badge ok">처리완료</span></td>
                        </tr>
                        <tr>
                            <td>2026-04-21</td>
                            <td>분리수거장 청소 요청</td>
                            <td><span class="badge wait">접수</span></td>
                        </tr>
                        <tr>
                            <td>2026-04-20</td>
                            <td>엘리베이터 소음 문의</td>
                            <td><span class="badge info">답변완료</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
</body>
</html>
