<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>방문자 차량등록 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">

    <style>

        .upload-box:hover {
            background: #f7fbf8;
        }

        .upload-box.dragover {
            border-color: #2a6d44;
            background: #eef8f0;
        }

        .upload-content .plus {
            font-size: 40px;
            font-weight: bold;
            color: #2a6d44;
        }

        .upload-content .text {
            font-size: 13px;
            color: #666;
            margin-top: 8px;
        }

        .file-name {
            margin-top: 10px;
            font-size: 13px;
            color: #333;
        }

        /* 업로드 박스 */
        .upload-box {
            width: 400px;
            height: 300px;

            border: 2px dashed #cfd7cf;
            border-radius: 12px;
            position: relative;

            display: flex;
            align-items: center;
            justify-content: center;

            cursor: pointer;
        }

        /* 기본 + 상태 */
        .upload-content {
            text-align: center;
        }

        /* 썸네일 카드 */
        .preview-card {
            width: 70%;
            height: 70%;
            background: transparent;
            border-radius: 20px;

            display: none;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .preview-img {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;

            border-radius: 16px;
            background: #fff;
            padding: 6px;

            box-shadow: 0 4px 10px rgba(0, 0, 0, .15);
        }

        .remove-btn {
            position: absolute;
            top: 2px;
            right: -8px;

            width: 32px;
            height: 32px;
            border-radius: 50%;

            background: #e53935;
            color: #fff;
            border: none;

            font-size: 18px;
            cursor: pointer;

            display: flex;
            align-items: center;
            justify-content: center;
        }

        .delete-text {
            color: #e57373;
            font-size: 12px;
            cursor: pointer;
            font-weight: 600;
        }

        .delete-text:hover {
            color: #d32f2f;
            text-decoration: underline;
        }

        @keyframes errorFlash {
            0% {
                border-color: #e53935;
                background-color: #fff5f5;
            }
            50% {
                border-color: #e53935;
                background-color: #ffecec;
            }
            100% {
                border-color: #d8ddd4;
                background-color: #fff;
            }
        }

        .input-error {
            animation: errorFlash .8s ease;
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
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">생활지원서비스</a>
                <span>›</span>
                <span class="cur">방문자 차량등록</span>
            </div>
            <h1 class="page-title">방문자 차량등록</h1>
            <p class="page-desc">방문 예약을 할 수 있는 페이지 입니다.</p>

            <section class="grid-2">
                <div class="panel">
                    <div class="section-hd">
                        <h3>방문 차량 예약</h3>
                        <span>사전 등록</span>
                    </div>
                    <div class="form-grid">
                        <%--차량유형적는곳--%>
                        <div class="th">차량 유형</div>
                        <div class="td">
                            <select id="vstVhclTyCd" class="fake-select">

                                <option value="">선택</option>

                                <option value="SEDAN">승용차</option>
                                <option value="SUV">SUV</option>
                                <option value="VAN">승합차</option>
                                <option value="TRUCK">트럭</option>
                                <option value="BIKE">오토바이</option>

                            </select>
                        </div>

                            <%--방문 날짜 적는곳--%>
                        <div class="th">
                            방문일시
                        </div>
                        <div class="td">
                            <input
                                    type="datetime-local"
                                    id="visitDt"
                                    class="fake-input"/>
                        </div>

                            <%-- 체류 시간 적는곳--%>
                        <div class="th">체류시간</div>
                        <div class="td">
                            <div class="inline-fields">

                                <input
                                        type="number"
                                        id="stayHour"
                                        class="fake-input"
                                        min="1"
                                        max="168"
                                        placeholder="시간 입력"
                                        style="max-width:140px;">

                                <span style="display:flex;align-items:center;">
                                    시간
                                </span>

                            </div>
                        </div>

                                <%-- 차량 번호 적는곳--%>
                        <div class="th">
                            차량번호
                        </div>
                        <div class="td">
                            <input
                                    type="text"
                                    id="vhclNo"
                                    class="fake-input"
                                    maxlength="9"
                                    placeholder="예) 123가4567"/>
                        </div>

                            <%-- 방문자 명 --%>
                        <div class="th">
                            방문자명
                        </div>
                        <div class="td">
                            <input
                                    type="text"
                                    id="visitorNm"
                                    class="fake-input"
                                    maxlength="20"
                                    placeholder="방문자 이름 입력"/>
                        </div>
                        <div class="th">
                            연락처
                        </div>
                        <div class="td">
                            <input
                                    type="text"
                                    id="visitorTel"
                                    class="fake-input"
                                    maxlength="13"
                                    placeholder="010-0000-0000"/>
                        </div>
                        <div class="th">
                            방문 목적
                        </div>
                        <div class="td">
                            <input
                                    type="text"
                                    id="visitPurpose"
                                    class="fake-input"
                                    maxlength="50"
                                    placeholder="방문 목적 입력"/>
                        </div>
                    </div>
                    <div class="btn-row">
                        <button
                                type="button"
                                id="registerBtn"
                                class="btn-main">
                            방문 예약 신청
                        </button>
                    </div>
                </div>
                <div class="panel">
                    <div class="section-hd">
                        <h3>최근 등록한 방문 차량</h3>
                        <span>목록</span></div>
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>방문일시</th>
                            <th>차량번호</th>
                            <th>방문자</th>
                            <th>상태</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>2026-04-25 18:00</td>
                            <td>12가 3456</td>
                            <td>이민호</td>
                            <td><span class="badge ok">승인</span></td>
                        </tr>
                        <tr>
                            <td>2026-04-26 10:30</td>
                            <td>98다 7654</td>
                            <td>최수진</td>
                            <td><span class="badge wait">대기</span></td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </section>

        </div>
    </main>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
<script>

    // 연락처 자동 하이픈
    document.getElementById("visitorTel")
        .addEventListener("input", function (e) {

            let value = e.target.value
                .replace(/[^0-9]/g, "")
                .slice(0, 11);

            if (value.length < 4) {
                e.target.value = value;
            } else if (value.length < 8) {
                e.target.value =
                    value.slice(0, 3) + "-" +
                    value.slice(3);
            } else {
                e.target.value =
                    value.slice(0, 3) + "-" +
                    value.slice(3, 7) + "-" +
                    value.slice(7);
            }
        });

    // 차량번호 공백 제거
    document.getElementById("vhclNo")
        .addEventListener("input", function (e) {

            e.target.value =
                e.target.value.replace(/\s/g, "");
        });

</script>
</body>
</html>
