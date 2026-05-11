// rentMap.js
// 임대 매물 지도 화면 JS
// 현재는 하드코딩 데이터 사용
// 추후 /rent/map/list API에서 RentListingMapDTO 목록을 받아오면 이 데이터만 교체할 예정

let rentListingList = [
    {
        // RENT_LISTING
        rentLstgNo: "RENT001",
        rentTypeCd: "JEONSE",
        rentTypeNm: "전세",
        dpstAmt: 105000,
        mthlyRentAmt: 0,
        rentLstgCn: "대단지, 학군 우수, 역세권에 위치한 공공주택 임대 매물입니다.",
        hoNo: "HO001",
        rcrtEndDt: "2026-05-31",
        rentTtl: "송파삼성래미안 전세 매물",
        rcrtBggnDt: "2026-05-01",

        // APT_DETAIL
        floor: 10,
        ho: "1004",
        exclusiveSize: "84",
        empty: "Y",
        imageNo: null,
        panoImageNo: null,

        // APT_UNIT
        dongNo: "DONG001",
        dongNm: "101동",
        dongMaxFloor: 15,
        dongUnitCnt: 120,

        // APT_COMPLEX
        aptCmplexNo: "APT001",
        aptCmplexNm: "송파삼성래미안",
        bjdCd: "1171010100",
        sidoNm: "서울특별시",
        sigunguNm: "송파구",
        emdNm: "오금동",
        latVal: 37.5052,
        lonVal: 127.1121,
        unitCnt: 845,
        heatTyCd: "HT001",
        ccCnt: "120",
        pkgCnt: 964,
        freePkgCnt: 1,
        dongCnt: 13,
        maxFloor: 25,
        bldYr: "2001",
        cnscoNm: "삼성물산",
        imgFileNo: null,
        rprsntImgFileNo: null,
        dorojuso: "서울특별시 송파구 오금로32길 14",

        // 화면 임시 이미지
        imgUrl: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1200"
    },
    {
        rentLstgNo: "RENT002",
        rentTypeCd: "MONTHLY",
        rentTypeNm: "월세",
        dpstAmt: 5000,
        mthlyRentAmt: 120,
        rentLstgCn: "생활 인프라가 우수하고 교통이 편리한 단지입니다.",
        hoNo: "HO002",
        rcrtEndDt: "2026-05-20",
        rentTtl: "잠실5단지 월세 매물",
        rcrtBggnDt: "2026-05-01",

        floor: 8,
        ho: "804",
        exclusiveSize: "76",
        empty: "Y",
        imageNo: null,
        panoImageNo: null,

        dongNo: "DONG002",
        dongNm: "503동",
        dongMaxFloor: 15,
        dongUnitCnt: 132,

        aptCmplexNo: "APT002",
        aptCmplexNm: "잠실5단지아파트",
        bjdCd: "1171010200",
        sidoNm: "서울특별시",
        sigunguNm: "송파구",
        emdNm: "잠실동",
        latVal: 37.5145,
        lonVal: 127.1012,
        unitCnt: 3930,
        heatTyCd: "HT002",
        ccCnt: "180",
        pkgCnt: 2500,
        freePkgCnt: 1,
        dongCnt: 30,
        maxFloor: 15,
        bldYr: "1978",
        cnscoNm: "대한주택공사",
        imgFileNo: null,
        rprsntImgFileNo: null,
        dorojuso: "서울특별시 송파구 송파대로 567",

        imgUrl: "https://images.unsplash.com/photo-1560518883-ce09059eeffa?q=80&w=1200"
    },
    {
        rentLstgNo: "RENT003",
        rentTypeCd: "MONTHLY",
        rentTypeNm: "월세",
        dpstAmt: 3000,
        mthlyRentAmt: 95,
        rentLstgCn: "주변 편의시설이 많고 관리 상태가 좋은 매물입니다.",
        hoNo: "HO003",
        rcrtEndDt: "2026-05-28",
        rentTtl: "가락현대아파트 월세 매물",
        rcrtBggnDt: "2026-05-05",

        floor: 6,
        ho: "604",
        exclusiveSize: "59",
        empty: "Y",
        imageNo: null,
        panoImageNo: null,

        dongNo: "DONG003",
        dongNm: "202동",
        dongMaxFloor: 12,
        dongUnitCnt: 96,

        aptCmplexNo: "APT003",
        aptCmplexNm: "가락현대아파트",
        bjdCd: "1171010300",
        sidoNm: "서울특별시",
        sigunguNm: "송파구",
        emdNm: "가락동",
        latVal: 37.4975,
        lonVal: 127.1220,
        unitCnt: 720,
        heatTyCd: "HT001",
        ccCnt: "90",
        pkgCnt: 600,
        freePkgCnt: 1,
        dongCnt: 8,
        maxFloor: 12,
        bldYr: "1997",
        cnscoNm: "현대건설",
        imgFileNo: null,
        rprsntImgFileNo: null,
        dorojuso: "서울특별시 송파구 가락동",

        imgUrl: "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=1200"
    }
];

let map;
let markers = [];
let selectedRentNo = null;
let currentType = "ALL";

document.addEventListener("DOMContentLoaded", function () {
    initMap();
    bindEvents();
    renderRentList();
    renderMarkers();
});

/**
 * 카카오 지도 초기화
 */
function initMap() {
    const mapContainer = document.getElementById("rentMap");

    const mapOption = {
        center: new kakao.maps.LatLng(37.5052, 127.1121),
        level: 5
    };

    map = new kakao.maps.Map(mapContainer, mapOption);
}

/**
 * 검색어, 거래유형 필터 이벤트 연결
 */
function bindEvents() {
    const keywordInput = document.getElementById("rentKeyword");

    if (keywordInput) {
        keywordInput.addEventListener("input", function () {
            renderRentList();
            renderMarkers();
        });
    }

    document.querySelectorAll(".filter-btn").forEach(function (btn) {
        btn.addEventListener("click", function () {
            document.querySelectorAll(".filter-btn").forEach(function (item) {
                item.classList.remove("active");
            });

            btn.classList.add("active");
            currentType = btn.dataset.type;

            renderRentList();
            renderMarkers();
        });
    });
}

/**
 * 현재 필터 조건에 맞는 매물 목록 반환
 */
function getFilteredList() {
    const keywordEl = document.getElementById("rentKeyword");
    const keyword = keywordEl ? keywordEl.value.trim() : "";

    return rentListingList.filter(function (item) {
        const typeMatched =
            currentType === "ALL" || item.rentTypeCd === currentType;

        const keywordMatched =
            keyword === "" ||
            nvl(item.aptCmplexNm).includes(keyword) ||
            nvl(item.dorojuso).includes(keyword) ||
            nvl(item.rentTtl).includes(keyword) ||
            nvl(item.sidoNm).includes(keyword) ||
            nvl(item.sigunguNm).includes(keyword) ||
            nvl(item.emdNm).includes(keyword);

        return typeMatched && keywordMatched;
    });
}

/**
 * 좌측 매물 리스트 렌더링
 */
function renderRentList() {
    const listEl = document.getElementById("rentList");
    const filteredList = getFilteredList();

    if (!listEl) {
        return;
    }

    if (filteredList.length === 0) {
        listEl.innerHTML = `
            <div style="padding:24px; color:#667085;">
                검색된 매물이 없습니다.
            </div>
        `;
        return;
    }

    listEl.innerHTML = filteredList.map(function (item) {
        const activeClass = item.rentLstgNo === selectedRentNo ? "active" : "";

        return `
            <article class="rent-card ${activeClass}" onclick="selectRent('${item.rentLstgNo}')">
                <div class="rent-card-top">
                    <span class="rent-type-badge">${item.rentTypeNm}</span>
                    <span style="font-size:12px; color:#667085;">
                        ${formatDate(item.rcrtEndDt)} 마감
                    </span>
                </div>

                <h3 class="rent-card-title">
                    ${item.aptCmplexNm} ${item.dongNm}
                </h3>

                <p class="rent-card-price">
                    ${formatPrice(item)}
                </p>

                <p class="rent-card-desc">
                    ${item.exclusiveSize}㎡ · ${item.floor}층 · ${item.ho}호<br>
                    ${item.dorojuso}
                </p>
            </article>
        `;
    }).join("");
}

/**
 * 중앙 상세 패널 렌더링
 */
function renderDetail(item) {
    const detailEl = document.getElementById("rentDetail");

    if (!detailEl) {
        return;
    }

    detailEl.className = "";
    detailEl.innerHTML = `
        <div class="rent-detail-hero" style="background-image:url('${item.imgUrl}')"></div>

        <div class="rent-detail-content">
            <span class="rent-type-badge">${item.rentTypeNm}</span>

            <h2>${item.aptCmplexNm}</h2>
            <p style="color:#667085; margin-top:0;">
                ${item.dongNm} ${item.ho}호
            </p>

            <div class="rent-detail-price">
                ${formatPrice(item)}
            </div>

            <div class="rent-info-grid">
                <div class="rent-info-item">
                    <span class="rent-info-label">전용면적</span>
                    <span class="rent-info-value">${item.exclusiveSize}㎡</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">층수</span>
                    <span class="rent-info-value">${item.floor}층 / 최고 ${item.dongMaxFloor}층</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">공실 여부</span>
                    <span class="rent-info-value">${item.empty === "Y" ? "공실" : "입주중"}</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">모집 기간</span>
                    <span class="rent-info-value">
                        ${formatDate(item.rcrtBggnDt)} ~ ${formatDate(item.rcrtEndDt)}
                    </span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">세대수</span>
                    <span class="rent-info-value">${formatNumber(item.unitCnt)}세대</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">동수</span>
                    <span class="rent-info-value">${item.dongCnt}동</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">준공년도</span>
                    <span class="rent-info-value">${item.bldYr}</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">건설사</span>
                    <span class="rent-info-value">${nvl(item.cnscoNm, "-")}</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">주차대수</span>
                    <span class="rent-info-value">${formatNumber(item.pkgCnt)}대</span>
                </div>

                <div class="rent-info-item">
                    <span class="rent-info-label">CCTV</span>
                    <span class="rent-info-value">${nvl(item.ccCnt, "-")}대</span>
                </div>
            </div>

            <h3 class="rent-detail-section-title">주소</h3>
            <p class="rent-detail-desc">
                ${item.dorojuso}
            </p>

            <h3 class="rent-detail-section-title">매물 설명</h3>
            <p class="rent-detail-desc">
                ${item.rentLstgCn}
            </p>

            <button type="button"
                    class="rent-detail-btn"
                    onclick="goRentDetail('${item.rentLstgNo}')">
                매물 상세보기
            </button>
        </div>
    `;
}

/**
 * 지도 마커 렌더링
 */
function renderMarkers() {
    clearMarkers();

    const filteredList = getFilteredList();

    filteredList.forEach(function (item) {
        if (item.latVal == null || item.lonVal == null) {
            return;
        }

        const position = new kakao.maps.LatLng(item.latVal, item.lonVal);

        const markerContent = `
            <div class="rent-marker" onclick="selectRent('${item.rentLstgNo}')">
                ${item.rentTypeNm} ${getMarkerPrice(item)}
            </div>
        `;

        const customOverlay = new kakao.maps.CustomOverlay({
            position: position,
            content: markerContent,
            yAnchor: 1.3
        });

        customOverlay.setMap(map);
        markers.push(customOverlay);
    });
}

/**
 * 기존 지도 마커 제거
 */
function clearMarkers() {
    markers.forEach(function (marker) {
        marker.setMap(null);
    });

    markers = [];
}

/**
 * 매물 선택
 * - 좌측 리스트 / 지도 마커 클릭 시 실행
 * - 상세 패널이 닫혀 있으면 자동으로 다시 연다
 * - 중앙 상세 패널 변경
 * - 지도 중심 이동
 */
function selectRent(rentLstgNo) {
    const item = rentListingList.find(function (rent) {
        return rent.rentLstgNo === rentLstgNo;
    });

    if (!item) {
        return;
    }

    selectedRentNo = rentLstgNo;

    const page = document.querySelector(".rent-map-page");
    const isCollapsed = page && page.classList.contains("detail-collapsed");

    /*
     * 상세 패널이 닫혀 있으면
     * 지도 마커 또는 리스트 클릭 시 자동으로 다시 연다.
     */
    if (isCollapsed) {
        page.classList.remove("detail-collapsed");

        /*
         * 그리드 폭이 바뀐 뒤 카카오맵을 다시 그려야
         * 지도 타일이 깨지지 않는다.
         */
        setTimeout(function () {
            if (map) {
                map.relayout();

                if (item.latVal != null && item.lonVal != null) {
                    map.setCenter(new kakao.maps.LatLng(item.latVal, item.lonVal));
                }
            }
        }, 260);
    }

    renderRentList();
    renderDetail(item);

    if (map && item.latVal != null && item.lonVal != null) {
        const moveLatLng = new kakao.maps.LatLng(item.latVal, item.lonVal);
        map.panTo(moveLatLng);
    }
}

/**
 * 가격 표시
 * RENT_LISTING 기준
 * - 전세: 보증금만 표시
 * - 월세: 보증금 / 월 임대료 표시
 */
function formatPrice(item) {
    if (item.rentTypeCd === "JEONSE") {
        return "전세 " + formatMoney(item.dpstAmt);
    }

    if (item.rentTypeCd === "MONTHLY") {
        return "보증금 " + formatMoney(item.dpstAmt) + " / 월 " + formatMoney(item.mthlyRentAmt);
    }

    return formatMoney(item.dpstAmt);
}

/**
 * 지도 마커용 짧은 가격
 */
function getMarkerPrice(item) {
    if (item.rentTypeCd === "JEONSE") {
        return formatMoneyShort(item.dpstAmt);
    }

    if (item.rentTypeCd === "MONTHLY") {
        return "월 " + formatMoneyShort(item.mthlyRentAmt);
    }

    return formatMoneyShort(item.dpstAmt);
}

/**
 * 금액 포맷
 * 현재 DPST_AMT, MTHLY_RENT_AMT는 만원 단위라고 가정
 */
function formatMoney(value) {
    if (value == null || value === "") {
        return "-";
    }

    value = Number(value);

    if (value >= 10000) {
        const eok = Math.floor(value / 10000);
        const man = value % 10000;

        if (man === 0) {
            return eok + "억";
        }

        return eok + "억 " + man.toLocaleString();
    }

    return value.toLocaleString();
}

/**
 * 마커용 짧은 금액 포맷
 */
function formatMoneyShort(value) {
    if (value == null || value === "") {
        return "-";
    }

    value = Number(value);

    if (value >= 10000) {
        const eok = Math.floor(value / 10000);
        const man = value % 10000;

        if (man === 0) {
            return eok + "억";
        }

        return eok + "." + Math.floor(man / 1000) + "억";
    }

    return value.toLocaleString();
}

/**
 * 숫자 콤마
 */
function formatNumber(value) {
    if (value == null || value === "") {
        return "-";
    }

    return Number(value).toLocaleString();
}

/**
 * 날짜 표시
 * 하드코딩 문자열 또는 JSON Date 문자열 모두 대응
 */
function formatDate(value) {
    if (value == null || value === "") {
        return "-";
    }

    if (typeof value === "string") {
        return value.substring(0, 10);
    }

    return value;
}

/**
 * null 방어
 */
function nvl(value, defaultValue) {
    if (defaultValue === undefined) {
        defaultValue = "";
    }

    if (value == null) {
        return defaultValue;
    }

    return String(value);
}

/**
 * 상세 페이지 이동
 */
function goRentDetail(rentLstgNo) {
    // 나중에 상세 화면 만들고 해당 주소로 연결할 예정
    location.href = "/rent/detail/" + rentLstgNo;
}

/**
 * 상세 패널 닫기
 * - 가운데 상세 패널을 접고 지도 영역을 넓힌다.
 */
function closeDetailPanel() {
    const page = document.querySelector(".rent-map-page");

    if (!page) {
        return;
    }

    page.classList.add("detail-collapsed");

    /*
     * 카카오맵은 영역 크기가 바뀐 뒤 relayout()을 호출해야
     * 지도 타일이 정상적으로 다시 그려진다.
     */
    setTimeout(function () {
        if (map) {
            map.relayout();

            const selectedItem = rentListingList.find(function (item) {
                return item.rentLstgNo === selectedRentNo;
            });

            if (selectedItem && selectedItem.latVal != null && selectedItem.lonVal != null) {
                map.setCenter(new kakao.maps.LatLng(selectedItem.latVal, selectedItem.lonVal));
            }
        }
    }, 260);
}