<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>

<html class="light" lang="ko">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>단지 시설정보</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

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


        .facility-search-form{
            margin-bottom:40px;
            padding:24px;
            display:flex;
            align-items:center;
            gap:14px;
            background:#fff;
            border:1px solid #e5e7eb;
            border-radius:14px;
            box-shadow:0 2px 8px rgba(0,0,0,0.05);
        }

        .search-label{
            font-size:14px;
            font-weight:800;
            color:#475569;
            white-space:nowrap;
        }

        .search-select,
        .search-input{
            height:42px;
            border:0;
            border-radius:22px;
            background:#eef1ee;
            padding:0 18px;
            font-size:14px;
            color:#111827;
            outline:none;
        }

        .search-select{
            width:230px;
        }

        .search-input{
            flex:1;
            min-width:260px;
        }

        .search-button{
            height:42px;
            min-width:90px;
            border:0;
            border-radius:22px;
            background:#00583f;
            color:#fff;
            font-size:14px;
            font-weight:800;
            cursor:pointer;
        }

        .facility-card-section{
            margin-bottom:50px;
        }

        .facility-card-count{
            margin-bottom:20px;
            font-size:22px;
            font-weight:800;
            color:#00583f;
        }

        .facility-card-grid{
            display:grid;
            grid-template-columns:repeat(4, 1fr);
            gap:24px;
        }

        .facility-card{
            display:block;
            text-decoration:none;
            color:inherit;
            border:1px solid #e5e7eb;
            border-radius:18px;
            overflow:hidden;
            background:#fff;
            box-shadow:0 3px 10px rgba(15, 23, 42, 0.06);
        }

        .facility-card:hover{
            transform:translateY(-3px);
            box-shadow:0 8px 18px rgba(15, 23, 42, 0.12);
        }

        .facility-card-top{
            position:relative;
            height:150px;
            background:#eaf3ee;
            display:flex;
            align-items:center;
            justify-content:center;
        }

        .facility-card-badge{
            position:absolute;
            top:18px;
            left:18px;
            padding:7px 14px;
            border-radius:20px;
            background:#00583f;
            color:#fff;
            font-size:13px;
            font-weight:800;
        }

        .facility-card-icon{
            font-size:34px;
            color:#9bb9ad;
        }

        .facility-card-body{
            padding:24px;
        }

        .facility-card-title{
            font-size:20px;
            font-weight:800;
            color:#00583f;
            margin-bottom:8px;
        }

        .facility-card-address{
            font-size:14px;
            color:#94a3b8;
            margin-bottom:24px;
        }

        .facility-card-meta{
            display:flex;
            justify-content:space-between;
            font-size:13px;
            font-weight:800;
            color:#00583f;
        }

        .facility-empty-box{
            padding:60px;
            border:1px solid #e5e7eb;
            border-radius:14px;
            text-align:center;
            color:#64748b;
            background:#fff;
        }

    </style>
</head>

<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>

<main class="facility-page">
    <div class="facility-container">

        <!-- 페이지 제목 -->
        <h1 class="facility-page-title">단지 시설정보</h1>

        <p class="facility-page-desc">
            공동주택 시설 및 관리 현황을 확인할 수 있습니다.
        </p>

        <!-- 검색 영역 -->
        <form method="get"
              action="${pageContext.request.contextPath}/facility/history.do"
              class="facility-search-form">

            <%-- 조회 버튼을 눌렀는지 Controller에 전달 --%>
            <input type="hidden" name="searchYn" value="Y"/>

            <label class="search-label">지역</label>

            <%-- 시/도 검색 조건 --%>
                <select name="sidoNm"
                        id="sidoNm"
                        class="search-select">

                    <option value="">시/도 전체</option>

                    <c:forEach var="sido" items="${sidoList}">
                        <option value="${sido}"
                            ${dto.sidoNm eq sido ? 'selected' : ''}>
                                ${sido}
                        </option>
                    </c:forEach>

                </select>

            <%-- 시/군/구 검색 조건 --%>
                <select name="sigunguNm"
                        id="sigunguNm"
                        class="search-select">

                    <option value="">시/군/구</option>

                    <c:if test="${not empty sigunguList}">
                        <c:forEach var="sigungu" items="${sigunguList}">
                            <option value="${sigungu}"
                                ${dto.sigunguNm eq sigungu ? 'selected' : ''}>
                                    ${sigungu}
                            </option>
                        </c:forEach>
                    </c:if>

                </select>

            <label class="search-label">세대수</label>

            <%-- 세대수 구간 검색 조건 --%>
            <select name="unitRange" class="search-select">
                <option value="">전체</option>
                <option value="UNDER_300" ${dto.unitRange eq 'UNDER_300' ? 'selected' : ''}>300세대 미만</option>
                <option value="300_500" ${dto.unitRange eq '300_500' ? 'selected' : ''}>300세대 이상 500세대 미만</option>
                <option value="500_1000" ${dto.unitRange eq '500_1000' ? 'selected' : ''}>500세대 이상 1000세대 미만</option>
                <option value="OVER_1000" ${dto.unitRange eq 'OVER_1000' ? 'selected' : ''}>1000세대 이상</option>
            </select>

            <%-- 단지명 직접 검색 --%>
            <input type="text"
                   name="keyword"
                   value="${dto.keyword}"
                   class="search-input"
                   placeholder="단지명 검색"/>

            <button type="submit" class="search-button">검색</button>
        </form>

        <c:if test="${searched}">

            <section class="facility-card-section">

                <c:choose>
                    <c:when test="${not empty aptCardList}">

                        <div class="facility-card-count">
                            총 ${aptCardList.size()}개 단지
                        </div>

                        <div class="facility-card-grid">
                            <c:forEach var="apt" items="${aptCardList}">
                                <a class="facility-card"
                                   href="${pageContext.request.contextPath}/facility/history.do?searchYn=Y&sidoNm=${dto.sidoNm}&sigunguNm=${dto.sigunguNm}&unitRange=${dto.unitRange}&keyword=${dto.keyword}&aptCmplexNo=${apt.aptCmplexNo}">

                                    <div class="facility-card-top">
                                <span class="facility-card-badge">
                                    ${apt.sidoNm} ${apt.sigunguNm}
                                </span>
                                        <span class="material-symbols-outlined facility-card-icon">apartment</span>
                                    </div>

                                    <div class="facility-card-body">
                                        <div class="facility-card-title">${apt.aptCmplexNm}</div>
                                        <div class="facility-card-address">${apt.dorojuso}</div>

                                        <div class="facility-card-meta">
                                            <span>${apt.unitCnt}세대 ${apt.dongCnt}동</span>
                                            <span>${apt.bldYr} 준공</span>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>

                    </c:when>

                    <c:otherwise>
                        <div class="facility-empty-box">
                            조회 조건과 일치하는 단지가 없습니다. 지역, 세대수 또는 단지명을 변경하여 다시 검색해 주세요.
                        </div>
                    </c:otherwise>
                </c:choose>

            </section>

        </c:if>

        <c:choose>

            <%-- 처음 화면: 표는 유지하고 안내 문구 출력 --%>
            <c:when test="${not searched}">
                <section class="facility-section">
                    <h2 class="facility-section-title">단지 시설정보 조회</h2>

                    <table class="facility-table">
                        <tbody>
                        <tr>
                            <td style="text-align:center; padding:60px; color:#64748b;">
                                조회 조건을 선택한 후 검색 버튼을 눌러 단지 시설정보를 확인해 주세요.
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </section>
            </c:when>

            <%-- 조회 후 결과 있음 --%>
            <c:when test="${not empty aptInfo}">

                    <!-- 단지 기본정보 -->
                    <section class="facility-section">
                        <h2 class="facility-section-title">단지 기본정보</h2>

                        <table class="facility-table">
                            <tbody>
                            <tr>
                                <th>단지명</th>
                                <td colspan="3">${aptInfo.aptCmplexNm} (${aptInfo.aptCmplexNo})</td>
                            </tr>
                            <tr>
                                <th>법정동주소</th>
                                <td>${aptInfo.sidoNm} ${aptInfo.sigunguNm} ${aptInfo.emdNm}</td>
                                <th>도로명주소</th>
                                <td>${aptInfo.dorojuso}</td>
                            </tr>
                            <tr>
                                <th>난방방식</th>
                                <td>${aptInfo.heatTy}</td>
                                <th>준공년도</th>
                                <td>${aptInfo.bldYr}</td>
                            </tr>
                            <tr>
                                <th>최대층수</th>
                                <td>${aptInfo.maxFloor}층</td>
                                <th>동수 / 세대수</th>
                                <td>${aptInfo.dongCnt}동 / ${aptInfo.unitCnt}세대</td>
                            </tr>
                            <tr>
                                <th>주차가능대수</th>
                                <td>${aptInfo.pkgCnt}대</td>
                                <th>세대당 무료주차</th>
                                <td>${aptInfo.freePkgCnt}대</td>
                            </tr>
                            <tr>
                                <th>CCTV 수</th>
                                <td>${aptInfo.ccCnt}</td>
                                <th>시공사 / 시행사</th>
                                <td>${aptInfo.cnscoNm}</td>
                            </tr>
                            </tbody>
                        </table>
                    </section>

                    <!-- 관리사항 -->
                    <section class="facility-section">
                        <h2 class="facility-section-title">관리사항</h2>

                        <table class="facility-table">
                            <tbody>
                            <tr>
                                <th>협력업체</th>
                                <td colspan="3">
                                    <div class="facility-info-list">
                                        <c:choose>
                                            <c:when test="${not empty aptInfo.partnerList}">
                                                <span>${aptInfo.partnerList}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span>등록된 협력업체가 없습니다.</span>
                                            </c:otherwise>
                                        </c:choose>
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
                            <thead>
                            <tr>
                                <th>시설명</th>
                                <th>시설유형</th>
                                <th>위치 동</th>
                                <th>상세 위치</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:choose>
                                <c:when test="${not empty facilityInfoList}">
                                    <c:forEach var="item" items="${facilityInfoList}">
                                        <c:if test="${not empty item.facilityNo}">
                                            <tr>
                                                <td>${item.facilityNm}</td>
                                                <td>${item.facilityTyCd}</td>
                                                <td>${item.dongNo}</td>
                                                <td>${item.locCn}</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" style="text-align:center;">등록된 시설정보가 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </section>

                    <!-- 주변사항 -->
                    <section class="facility-section">
                        <h2 class="facility-section-title">주변사항</h2>

                        <table class="facility-table">
                            <tbody>
                            <tr>
                                <th>주변 인프라</th>
                                <td colspan="3">
                                    <c:choose>
                                        <c:when test="${not empty aptInfo.infraList}">
                                            ${aptInfo.infraList}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </section>

                    <!-- 입주편의시설 조회 -->
                    <section class="facility-section">
                        <h2 class="facility-section-title">입주편의시설 조회</h2>

                        <table class="facility-table">
                            <thead>
                            <tr>
                                <th>공용시설명</th>
                                <th>물품명</th>
                                <th>예약가능여부</th>
                                <th>이용금액</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:choose>
                                <c:when test="${not empty facilityInfoList}">
                                    <c:forEach var="item" items="${facilityInfoList}">
                                        <c:if test="${not empty item.cmnFacilityNo}">
                                            <tr>
                                                <td>${item.cmnFacilityNm}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty item.itemNm}">
                                                            ${item.itemNm}
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${item.cmnFacilityRsvYn}</td>
                                                <td>${item.cmnFacilityAmt}원</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" style="text-align:center;">등록된 입주편의시설이 없습니다.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </section>

            </c:when>

            <%-- 조회 후 결과 없음 --%>
            <c:otherwise>
                <section class="facility-section">
                    <h2 class="facility-section-title">단지 시설정보 조회</h2>

                    <table class="facility-table">
                        <tbody>
                        <tr>
                            <td style="text-align:center; padding:60px; color:#64748b;">
                                입력하신 조건과 일치하는 단지 시설정보가 없습니다.
                                검색 조건을 변경한 후 다시 조회해 주세요.
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </section>
            </c:otherwise>

        </c:choose>


    </div>
</main>

<script>

    /*
     * 시/도 변경 시 자동 조회
     *
     * onchange란?
     * → select 값이 바뀌었을 때 실행되는 이벤트.
     */
    document.getElementById("sidoNm")
        .addEventListener("change", function() {

            /*
             * 선택한 시/도 기준으로
             * Controller를 다시 호출하여
             * 시/군/구 목록 재조회.
             */
            location.href =
                "${pageContext.request.contextPath}/facility/history.do"
                + "?sidoNm=" + this.value;

        });

</script>

</body>
</html>