<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec"
           uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">

<head>

    <meta charset="UTF-8">

    <title>
        설문 상세
    </title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/office-layout.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager/manager-common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>

        #surveyDetailPage .detail-layout{
            display:flex;
            flex-direction:column;
            gap:16px;
        }

        #surveyDetailPage .detail-header{
            display:flex;
            justify-content:space-between;
            align-items:flex-start;
            gap:16px;
            flex-wrap:wrap;
        }

        #surveyDetailPage .detail-title{
            font-size:28px;
            font-weight:800;
            color:var(--text-primary);
        }

        #surveyDetailPage .detail-sub{
            margin-top:8px;
            color:var(--text-secondary);
            font-size:14px;
        }

        #surveyDetailPage .detail-status{
            display:inline-flex;
            align-items:center;
            padding:6px 12px;
            border-radius:8px;
            font-size:13px;
            font-weight:700;
            background:#dcfce7;
            color:#166534;
        }

        #surveyDetailPage .detail-grid{
            display:grid;
            grid-template-columns:repeat(3, 1fr);
            gap:12px;
        }

        #surveyDetailPage .detail-box{
            background:#fff;
            border:1px solid var(--border);
            border-radius:12px;
            padding:18px;
        }

        #surveyDetailPage .detail-label{
            font-size:12px;
            color:var(--text-tertiary);
            margin-bottom:6px;
        }

        #surveyDetailPage .detail-value{
            font-size:15px;
            font-weight:700;
            color:var(--text-primary);
        }

        #surveyDetailPage .question-box{
            border:1px solid #dfe5ec;
            border-radius:12px;
            padding:18px;
            background:#fafbfc;
        }

        #surveyDetailPage .question-box + .question-box{
            margin-top:14px;
        }

        #surveyDetailPage .question-title{
            font-size:16px;
            font-weight:700;
            margin-bottom:14px;
        }

        #surveyDetailPage .option-item{
            display:flex;
            align-items:center;
            gap:10px;
            padding:10px 14px;
            border-radius:8px;
            background:#fff;
            border:1px solid #e4e7eb;
            margin-bottom:10px;
        }

        #surveyDetailPage .option-no{
            width:28px;
            height:28px;
            border-radius:50%;
            background:#e7efe9;
            color:#2f6b3d;
            display:flex;
            align-items:center;
            justify-content:center;
            font-size:12px;
            font-weight:700;
        }


    </style>

</head>

<body>

<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">

            <div class="office-page"
                 id="surveyDetailPage">

                <div class="detail-layout">

                    <!-- 상단 -->
                    <div class="panel">

                        <div class="panel-body">

                            <div class="detail-header">

                                <div>

                                    <div class="detail-title">
                                        주차장 만족도 조사
                                    </div>

                                    <div class="detail-sub">
                                        입주민 대상 만족도 설문입니다.
                                    </div>

                                </div>

                                <div style="display:flex; gap:8px;">

                                    <button type="button"
                                            class="btn btn-secondary">

                                        결과 보기

                                    </button>

                                    <button type="button"
                                            class="btn btn-primary">

                                        수정

                                    </button>

                                    <button type="button"
                                            class="btn btn-danger">

                                        삭제

                                    </button>

                                </div>

                            </div>

                        </div>

                    </div>

                    <!-- 정보 -->
                    <div class="detail-grid">

                        <div class="detail-box">

                            <div class="detail-label">
                                상태
                            </div>

                            <div class="detail-value">
                                <span class="detail-status">
                                    진행중
                                </span>
                            </div>

                        </div>

                        <div class="detail-box">

                            <div class="detail-label">
                                구분
                            </div>

                            <div class="detail-value">
                                설문
                            </div>

                        </div>

                        <div class="detail-box">

                            <div class="detail-label">
                                기간
                            </div>

                            <div class="detail-value">
                                2026-05-19 ~ 2026-05-29
                            </div>

                        </div>

                    </div>

                    <!-- 질문 -->
                    <div class="panel">

                        <div class="panel-header">

                            <h3 class="panel-title">
                                질문 목록
                            </h3>

                        </div>

                        <div class="panel-body">

                            <!-- 질문 1 -->
                            <div class="question-box">

                                <div class="question-title">
                                    Q1.
                                    주차장이 부족하다고 생각하십니까?
                                </div>

                                <div class="option-item">

                                    <div class="option-no">
                                        1
                                    </div>

                                    <div>
                                        매우 그렇다
                                    </div>

                                </div>

                                <div class="option-item">

                                    <div class="option-no">
                                        2
                                    </div>

                                    <div>
                                        그렇다
                                    </div>

                                </div>

                                <div class="option-item">

                                    <div class="option-no">
                                        3
                                    </div>

                                    <div>
                                        보통이다
                                    </div>

                                </div>

                            </div>

                            <!-- 질문 2 -->
                            <div class="question-box">

                                <div class="question-title">
                                    Q2.
                                    추가 의견이 있다면 작성해주세요.
                                </div>

                                <textarea class="form-textarea"
                                          rows="5"
                                          readonly>

예시 답변 영역

                                </textarea>

                            </div>

                        </div>

                    </div>

                </div>

            </div>

        </main>

    </div>

</div>
<script src="${pageContext.request.contextPath}/js/office-layout.js"></script>
</body>

</html>
