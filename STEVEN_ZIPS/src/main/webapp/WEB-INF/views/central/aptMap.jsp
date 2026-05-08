<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html class="light" lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아파트 지도 - 우리집맵핑</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <script>
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        surface: "#fbf9f5",
                        primary: "#004830",
                        "primary-container": "#226046",
                        "on-surface": "#1b1c1a",
                        "surface-container": "#efeeea",
                        "surface-container-low": "#f5f3ef",
                        "outline-variant": "#c6c8b8"
                    },
                    fontFamily: {
                        headline: ["Manrope"],
                        body: ["Manrope"],
                        label: ["Manrope"]
                    }
                }
            }
        }
    </script>

    <style>
        body {
            font-family: 'Manrope', sans-serif;
        }

        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }

        .map-card {
            height: calc(100vh - 240px);
            min-height: 650px;
            border-radius: 28px;
            overflow: hidden;
            border: 1px solid #eef2eb;
            background: #ffffff;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.06);
            position: relative;
        }

        #map {
            width: 100%;
            height: 100%;
        }

        .map-info-window {
            padding: 14px 16px;
            min-width: 250px;
            line-height: 1.5;
            font-family: 'Manrope', sans-serif;
        }

        .map-info-title {
            color: #004830;
            font-weight: 800;
            font-size: 15px;
            margin-bottom: 5px;
            display: block;
        }

        .map-info-address {
            color: #64748b;
            font-size: 12px;
            margin-bottom: 8px;
            display: block;
        }

        .map-info-meta {
            color: #004830;
            font-size: 12px;
            font-weight: 800;
            display: block;
            margin-bottom: 10px;
        }

        .map-info-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 9999px;
            background: #004830;
            color: #ffffff !important;
            font-size: 12px;
            font-weight: 800;
            text-decoration: none;
        }

        .map-floating-panel {
            position: absolute;
            top: 22px;
            left: 22px;
            width: 320px;
            z-index: 10;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid #eef2eb;
            border-radius: 24px;
            box-shadow: 0 12px 28px rgba(15, 23, 42, 0.12);
            padding: 18px;
        }

        .map-count-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 12px;
            border-radius: 9999px;
            background: #004830;
            color: white;
            font-size: 12px;
            font-weight: 800;
        }

        .map-empty-box {
            position: absolute;
            top: 50%;
            left: 50%;
            z-index: 20;
            transform: translate(-50%, -50%);
            background: white;
            border: 1px solid #eef2eb;
            border-radius: 22px;
            padding: 28px 34px;
            text-align: center;
            box-shadow: 0 12px 30px rgba(15, 23, 42, 0.12);
        }
    </style>
</head>

<body class="bg-surface text-on-surface flex flex-col min-h-screen">

<%@ include file="/WEB-INF/views/include/main_headerLayout.jsp" %>
<%@ include file="/WEB-INF/views/include/central_sidebar.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/centralSidebarStyle.css">

<main class="ml-80 p-10 pt-28 flex-1">

    <!-- 상단 타이틀 -->
    <div class="flex flex-col md:flex-row md:items-center justify-between gap-6 mb-8">
        <div>
            <div class="flex items-center gap-2 text-slate-400 text-sm mb-2 font-label">
                <span>Home</span>
                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                <span>공공주택정보</span>
                <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                <span class="text-primary font-bold">지도에서 보기</span>
            </div>

            <h1 class="text-4xl font-extrabold tracking-tight text-on-surface mb-2">
                아파트 지도
            </h1>

            <p class="text-gray-500">
                지도에서 아파트 위치를 확인하고 단지 상세정보로 이동할 수 있습니다.
            </p>
        </div>

        <div class="flex items-center gap-3">
            <a href="${pageContext.request.contextPath}/main/apt/list.do"
               class="inline-flex items-center gap-2 px-5 py-2.5 rounded-full bg-white border border-[#e5eadf] text-sm font-bold text-slate-600 hover:text-primary hover:border-primary/40 transition-all shadow-sm">
                <span class="material-symbols-outlined text-[18px]">list</span>
                단지목록으로
            </a>
        </div>
    </div>

    <!-- 지도 카드 -->
    <section class="map-card">

        <!-- 지도 위 안내 패널 -->
        <div class="map-floating-panel">
            <div class="flex items-start justify-between gap-4 mb-4">
                <div>
                    <h2 class="text-xl font-extrabold text-slate-900 mb-1">
                        지도 기반 단지 검색
                    </h2>
                    <p class="text-sm text-slate-500 leading-relaxed">
                        마커를 클릭하면 단지 요약정보와 상세보기 버튼이 표시됩니다.
                    </p>
                </div>

                <span class="material-symbols-outlined text-primary text-3xl">map</span>
            </div>

            <div class="map-count-badge">
                <span class="material-symbols-outlined text-[16px]">apartment</span>
                총 ${fn:length(aptList)}개 단지
            </div>
        </div>

        <c:if test="${empty aptList}">
            <div class="map-empty-box">
                <span class="material-symbols-outlined text-primary text-5xl mb-3">location_off</span>
                <h3 class="text-lg font-extrabold text-slate-900 mb-2">표시할 단지가 없습니다.</h3>
                <p class="text-sm text-slate-500">좌표 정보가 등록된 단지가 없습니다.</p>
            </div>
        </c:if>

        <div id="map"></div>
    </section>

</main>

<div class="ml-80">
    <%@ include file="/WEB-INF/views/include/main_footerLayout.jsp" %>
</div>

<!-- 카카오 지도 SDK -->
<script type="text/javascript"
        src="//dapi.kakao.com/v2/maps/sdk.js?appkey=46f7d3996e1205738757a1e4f1ed1f04"></script>

<script>
    /*
     * Controller에서 model.addAttribute("aptList", aptList)로 넘긴 데이터
     */
    const aptList = [
        <c:forEach var="apt" items="${aptList}" varStatus="status">
        {
            aptCmplexNo: "${apt.aptCmplexNo}",
            aptCmplexNm: "${fn:escapeXml(apt.aptCmplexNm)}",
            sidoNm: "${fn:escapeXml(apt.sidoNm)}",
            sigunguNm: "${fn:escapeXml(apt.sigunguNm)}",
            dorojuso: "${fn:escapeXml(apt.dorojuso)}",
            latVal: ${empty apt.latVal ? "null" : apt.latVal},
            lonVal: ${empty apt.lonVal ? "null" : apt.lonVal},
            unitCnt: ${apt.unitCnt},
            dongCnt: ${apt.dongCnt}
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    /*
     * 기본 중심 좌표
     * 좌표 목록이 없을 경우 대전 중심으로 표시
     */
    let centerLat = 36.3504;
    let centerLng = 127.3845;

    /*
     * 좌표가 있는 첫 번째 단지를 지도 중심으로 사용
     */
    const firstApt = aptList.find(function (apt) {
        return apt.latVal !== null && apt.lonVal !== null;
    });

    if (firstApt) {
        centerLat = Number(firstApt.latVal);
        centerLng = Number(firstApt.lonVal);
    }

    const mapContainer = document.getElementById("map");

    const mapOption = {
        center: new kakao.maps.LatLng(centerLat, centerLng),
        level: 8
    };

    const map = new kakao.maps.Map(mapContainer, mapOption);

    /*
     * 지도 컨트롤 추가
     */
    const zoomControl = new kakao.maps.ZoomControl();
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

    const mapTypeControl = new kakao.maps.MapTypeControl();
    map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

    /*
     * 여러 마커의 범위를 자동으로 맞추기 위한 bounds
     */
    const bounds = new kakao.maps.LatLngBounds();

    /*
     * 현재 열려있는 인포윈도우 관리
     */
    let openedInfoWindow = null;

    aptList.forEach(function (apt) {
        const lat = Number(apt.latVal); // 위도
        const lng = Number(apt.lonVal); // 경도

        if (!lat || !lng) {
            return;
        }

        const position = new kakao.maps.LatLng(lat, lng);

        const marker = new kakao.maps.Marker({
            map: map,
            position: position,
            title: apt.aptCmplexNm
        });

        bounds.extend(position);

        const detailUrl = "${pageContext.request.contextPath}/main/apt/detail.do?aptCmplexNo=" + encodeURIComponent(apt.aptCmplexNo);

        const content =
            '<div class="map-info-window">' +
            '  <span class="map-info-title">' + apt.aptCmplexNm + '</span>' +
            '  <span class="map-info-address">' + apt.dorojuso + '</span>' +
            '  <span class="map-info-meta">' + apt.unitCnt + '세대 / ' + apt.dongCnt + '동</span>' +
            '  <a class="map-info-link" href="' + detailUrl + '">상세보기</a>' +
            '</div>';

        const infowindow = new kakao.maps.InfoWindow({
            content: content,
            removable: true
        });

        kakao.maps.event.addListener(marker, "click", function () {
            if (openedInfoWindow) {
                openedInfoWindow.close();
            }

            infowindow.open(map, marker);
            openedInfoWindow = infowindow;
        });
    });

    /*
     * 마커가 2개 이상이면 전체 마커가 보이도록 지도 범위 조정
     */
    if (aptList.length > 1 && firstApt) {
        map.setBounds(bounds);
    }
</script>

</body>
</html>