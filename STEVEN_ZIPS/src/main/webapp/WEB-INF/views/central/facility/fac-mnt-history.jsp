

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html class="light" lang="ko"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>단지 시설정보</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>


    <style>

        body{
            font-family:'Malgun Gothic', sans-serif;
            background:#fff;
            color:#222;
        }
        .facility-page{
            margin-left:260px;
            padding:120px 48px 80px;
            background:#fff;
            min-height:100vh;
        }

        .facility-container{
            max-width:1400px;
            margin:0 auto;
        }

        .facility-page-title{
            font-size:42px;
            font-weight:800;
            color:#111827;
            margin-bottom:12px;
            letter-spacing:-1px;
        }

        .facility-page-desc{
            font-size:14px;
            color:#666;
            margin-bottom:45px;
        }

        .facility-section{
            margin-bottom:60px;
        }

        .facility-section-title{
            font-size:36px;
            font-weight:800;
            color:#1f3d6d;
            margin-bottom:16px;
            letter-spacing:-1px;
        }

        .facility-table{
            width:100%;
            border-collapse:collapse;
            table-layout:fixed;
            border-top:2px solid #444;
        }

        .facility-table th{
            width:220px;
            background:#f5f5f5;
            border-bottom:1px solid #d9d9d9;
            border-right:1px solid #d9d9d9;
            padding:15px 16px;
            font-size:14px;
            font-weight:700;
            text-align:center;
            color:#333;
            vertical-align:middle;
            word-break:keep-all;
        }

        .facility-table td{
            border-bottom:1px solid #d9d9d9;
            border-right:1px solid #d9d9d9;
            padding:15px 18px;
            font-size:14px;
            color:#222;
            vertical-align:middle;
            word-break:keep-all;
            background:#fff;
        }

        .facility-table tr th:last-child,
        .facility-table tr td:last-child{
            border-right:none;
        }

        .facility-info-list{
            display:flex;
            flex-wrap:wrap;
            gap:10px 22px;
        }

        .facility-info-list span{
            position:relative;
            padding-left:12px;
        }

        .facility-info-list span::before{
            content:"•";
            position:absolute;
            left:0;
            top:0;
            color:#666;
        }

        .facility-notice{
            margin-top:12px;
            font-size:13px;
            color:#666;
            line-height:1.7;
        }

        .facility-red{
            color:#d90429;
            font-weight:700;
        }

    </style>
</head>







<body class="bg-surface text-on-surface flex flex-col min-h-screen">
<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">
<!-- SideNavBar Shell -->

<!-- TopNavBar -->

<main class="facility-page">

    <div class="facility-container">

        <!-- 페이지 제목 -->
        <h1 class="facility-page-title">단지 시설정보</h1>

        <p class="facility-page-desc">
            공동주택 시설 및 관리 현황을 확인할 수 있습니다.
        </p>

        <!-- 관리사항 -->
        <section class="facility-section">

            <h2 class="facility-section-title">관리사항</h2>

            <table class="facility-table">

                <tbody>

                <tr>
                    <th>일반관리</th>

                    <td colspan="3">
                        <div class="facility-info-list">
                            <span>관리방식 : 위탁관리</span>
                            <span>인원 : 4</span>
                            <span>계약업체 : 세화종합관리(주)</span>
                        </div>
                    </td>
                </tr>

                <tr>
                    <th>경비관리</th>

                    <td colspan="3">
                        <div class="facility-info-list">
                            <span>관리방식 : 위탁관리</span>
                            <span>인원 : 4</span>
                            <span>계약업체 : (주)이데아그룹</span>
                        </div>
                    </td>
                </tr>

                <tr>
                    <th>청소관리</th>

                    <td colspan="3">
                        <div class="facility-info-list">
                            <span>관리방식 : 위탁관리</span>
                            <span>인원 : 3</span>
                            <span>음식물처리방법 : 음식물쓰레기종량제</span>
                            <span>계약업체 : 이데아그룹</span>
                        </div>
                    </td>
                </tr>

                <tr>
                    <th>소독관리</th>

                    <td colspan="3">
                        <div class="facility-info-list">
                            <span>관리방식 : 위탁관리</span>
                            <span>연간소독횟수 : 12</span>
                            <span>소독방법 : 분무식</span>
                            <span>계약업체 : (주)와브이시스템</span>
                        </div>
                    </td>
                </tr>

                </tbody>

            </table>

        </section>

        <!-- 시설사항 -->
        <section class="facility-section">

            <h2 class="facility-section-title">시설사항</h2>

            <table class="facility-table">

                <tbody>

                <tr>
                    <th>건물구조</th>
                    <td>철골철근콘크리트구조</td>

                    <th>수전용량</th>
                    <td>800 Kw</td>
                </tr>

                <tr>
                    <th>세대전기계약방식</th>
                    <td>단일계약</td>

                    <th>전기안전관리자법정 선임여부</th>
                    <td>위탁선임</td>
                </tr>

                <tr>
                    <th>화재수신반방식</th>
                    <td>R형</td>

                    <th>급수방식</th>
                    <td>부스터방식</td>
                </tr>

                <tr>
                    <th>승강기관리형태</th>
                    <td>위탁관리</td>

                    <th>승강기대수</th>
                    <td>8</td>
                </tr>

                <tr>
                    <th>주차대수</th>

                    <td colspan="3">

                        <div class="facility-info-list">
                            <span>지상 : 59</span>
                            <span>지하 : 263</span>
                            <span>총 322대</span>
                        </div>

                    </td>
                </tr>

                <tr>
                    <th>CCTV대수</th>
                    <td>45</td>

                    <th>부대 · 복리시설</th>
                    <td>관리사무소, 노인정, 어린이놀이터</td>
                </tr>

                </tbody>

            </table>

        </section>

        <!-- 긴급차량 -->
        <section class="facility-section">

            <h2 class="facility-section-title">긴급차량 출입관리</h2>

            <table class="facility-table">

                <tbody>

                <tr>
                    <th>홈네트워크</th>

                    <th>긴급자동차 출입가능한 출입문</th>

                    <th>
                        선택한 출입문의<br>
                        주차관제 시스템
                    </th>

                    <th>긴급자동차 출입방법</th>

                    <th>긴급자동차 즉시통과</th>
                </tr>

                <tr>

                    <td style="text-align:center;">무</td>

                    <td style="text-align:center;">
                        정문
                    </td>

                    <td style="text-align:center;">
                        무
                    </td>

                    <td>

                        <span class="facility-red">
                            ※ 주차관제시스템이 “무”인 경우 입력이 불필요합니다.
                        </span>

                    </td>

                    <td style="text-align:center;">
                        가능
                    </td>

                </tr>

                </tbody>

            </table>

            <p class="facility-notice">
                ※ 무인차단기가 긴급자동차(경찰차, 소방차, 119 구급차 등)의 전용번호판을 자동으로 인식하여 차량을 통과시키는 기능이 있는지를 묻는 항목입니다.
            </p>

        </section>

    </div>

</main>
<!-- Footer -->

</body></html>