// rentMap.js
// 임대 매물 지도 화면 JS
// 현재는 하드코딩 데이터 사용
// 추후 /rent/map/list API에서 RentListingMapDTO 목록을 받아오면 이 데이터만 교체할 예정

let rentListingList = [
    {
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

        floor: 10,
        ho: "1004",
        exclusiveSize: "84",
        empty: "Y",
        imageNo: null,
        panoImageNo: null,

        dongNo: "DONG001",
        dongNm: "101동",
        dongMaxFloor: 15,
        dongUnitCnt: 120,

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

        imgUrl: "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1200"
    },
    {
        rentLstgNo: "RENT004",
        rentTypeCd: "MONTHLY",
        rentTypeNm: "월세",
        dpstAmt: 3000,
        mthlyRentAmt: 110,
        rentLstgCn: "송파삼성래미안 단지 내 월세 매물입니다. 저층 선호 세대에 적합합니다.",
        hoNo: "HO004",
        rcrtEndDt: "2026-06-10",
        rentTtl: "송파삼성래미안 월세 매물",
        rcrtBggnDt: "2026-05-15",

        floor: 5,
        ho: "504",
        exclusiveSize: "59",
        empty: "Y",
        imageNo: null,
        panoImageNo: null,

        dongNo: "DONG001",
        dongNm: "101동",
        dongMaxFloor: 15,
        dongUnitCnt: 120,

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
let selectedAptCmplexNo = null;
let currentType = "ALL";

document.addEventListener("DOMContentLoaded", function () {
    initMap();
    bindEvents();
    renderMarkers();
});

/**
 * 카카오 지도 초기화
 */
function initMap() {
    const mapContainer = document.getElementById("rentMap");

    if (!mapContainer) {
        return;
    }

    const mapOption = {
        center: new kakao.maps.LatLng(37.5052, 127.1121),
        level: 5
    };

    map = new kakao.maps.Map(mapContainer, mapOption);
}

/**
 * 검색어, 거래유형 필터 이벤트 연결
 * 현재 rentMap.jsp에 필터 UI가 없으면 실행되지 않아도 문제 없음
 */
function bindEvents() {
    const keywordInput = document.getElementById("rentKeyword");

    if (keywordInput) {
        keywordInput.addEventListener("input", function () {
            renderMarkers();

            if (selectedAptCmplexNo) {
                selectComplex(selectedAptCmplexNo);
            }
        });
    }

    document.querySelectorAll(".filter-btn").forEach(function (btn) {
        btn.addEventListener("click", function () {
            document.querySelectorAll(".filter-btn").forEach(function (item) {
                item.classList.remove("active");
            });

            btn.classList.add("active");
            currentType = btn.dataset.type;

            renderMarkers();

            if (selectedAptCmplexNo) {
                selectComplex(selectedAptCmplexNo);
            }
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
 * 단지 번호 기준 매물 목록 조회
 */
function getRentListByComplex(aptCmplexNo) {
    return getFilteredList().filter(function (item) {
        return item.aptCmplexNo === aptCmplexNo;
    });
}

/**
 * 지도 마커용 단지 목록 생성
 * 같은 단지에 매물이 여러 개 있어도 마커는 하나만 만든다.
 */
function getComplexMarkerList() {
    const complexMap = {};
    const filteredList = getFilteredList();

    filteredList.forEach(function (item) {
        if (!complexMap[item.aptCmplexNo]) {
            complexMap[item.aptCmplexNo] = {
                aptCmplexNo: item.aptCmplexNo,
                aptCmplexNm: item.aptCmplexNm,
                latVal: item.latVal,
                lonVal: item.lonVal,
                rentCount: 0,
                minMonthlyRentAmt: null,
                maxDpstAmt: null,
                firstRent: item
            };
        }

        complexMap[item.aptCmplexNo].rentCount++;

        if (item.rentTypeCd === "MONTHLY") {
            if (
                complexMap[item.aptCmplexNo].minMonthlyRentAmt == null ||
                item.mthlyRentAmt < complexMap[item.aptCmplexNo].minMonthlyRentAmt
            ) {
                complexMap[item.aptCmplexNo].minMonthlyRentAmt = item.mthlyRentAmt;
            }
        }

        if (
            complexMap[item.aptCmplexNo].maxDpstAmt == null ||
            item.dpstAmt > complexMap[item.aptCmplexNo].maxDpstAmt
        ) {
            complexMap[item.aptCmplexNo].maxDpstAmt = item.dpstAmt;
        }
    });

    return Object.values(complexMap);
}

/**
 * 지도 마커 렌더링
 * 단지별 마커 1개씩 표시
 */
function renderMarkers() {
    clearMarkers();

    const complexList = getComplexMarkerList();

    complexList.forEach(function (complex) {
        if (complex.latVal == null || complex.lonVal == null) {
            return;
        }

        const position = new kakao.maps.LatLng(complex.latVal, complex.lonVal);

        const markerContent = `
            <div class="rent-marker" onclick="selectComplex('${complex.aptCmplexNo}')">
                ${getComplexMarkerText(complex)}
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
 * 단지 마커 문구
 */
function getComplexMarkerText(complex) {
    if (complex.minMonthlyRentAmt != null) {
        return "월세 월 " + formatMoneyShort(complex.minMonthlyRentAmt);
    }

    return "전세 " + formatMoneyShort(complex.maxDpstAmt);
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
 * 지도 마커 클릭 시 실행
 * - 해당 단지의 매물 목록 패널 오픈
 * - 첫 번째 매물 상세정보 표시
 */
function selectComplex(aptCmplexNo) {
    const complexRentList = getRentListByComplex(aptCmplexNo);

    if (complexRentList.length === 0) {
        return;
    }

    selectedAptCmplexNo = aptCmplexNo;

    const firstItem = complexRentList[0];

    const page = document.querySelector(".rent-map-page");

    if (page && page.classList.contains("panels-collapsed")) {
        page.classList.remove("panels-collapsed");

        setTimeout(function () {
            if (map) {
                map.relayout();
            }
        }, 260);
    }

    renderComplexRentList(firstItem, complexRentList);
    selectRent(firstItem.rentLstgNo);

    if (map && firstItem.latVal != null && firstItem.lonVal != null) {
        map.panTo(new kakao.maps.LatLng(firstItem.latVal, firstItem.lonVal));
    }
}

/**
 * 선택한 단지의 매물 목록 렌더링
 */
function renderComplexRentList(complexInfo, complexRentList) {
    const complexNameEl = document.getElementById("selectedComplexName");
    const listEl = document.getElementById("complexRentList");

    if (complexNameEl) {
        complexNameEl.textContent =
            complexInfo.aptCmplexNm + " · 총 " + complexRentList.length + "건";
    }

    if (!listEl) {
        return;
    }

    listEl.innerHTML = complexRentList.map(function (item) {
        const activeClass = item.rentLstgNo === selectedRentNo ? "active" : "";

        return `
            <article class="complex-rent-card ${activeClass}"
                     onclick="selectRent('${item.rentLstgNo}')">

                <div class="complex-rent-card-top">
                    <span class="rent-type-badge">${item.rentTypeNm}</span>
                    <span style="font-size:12px; color:#667085;">
                        ${formatDate(item.rcrtEndDt)} 마감
                    </span>
                </div>

                <h3 class="complex-rent-title">
                    ${item.aptCmplexNm} ${item.dongNm}
                </h3>

                <p class="complex-rent-price">
                    ${formatPrice(item)}
                </p>

                <p class="complex-rent-info">
                    ${item.exclusiveSize}㎡ · ${item.floor}층 · ${item.ho}호<br>
                    ${item.dorojuso}
                </p>
            </article>
        `;
    }).join("");
}

/**
 * 매물 선택
 * - 좌측 단지 매물 목록 클릭 시 실행
 * - 가운데 상세 패널 변경
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
    selectedAptCmplexNo = item.aptCmplexNo;

    const page = document.querySelector(".rent-map-page");

    if (page && page.classList.contains("panels-collapsed")) {
        page.classList.remove("panels-collapsed");

        setTimeout(function () {
            if (map) {
                map.relayout();
            }
        }, 260);
    }

    renderDetail(item);

    /*
     * 왼쪽 단지 매물 목록의 active 상태 갱신
     */
    const complexRentList = getRentListByComplex(item.aptCmplexNo);

    if (complexRentList.length > 0) {
        renderComplexRentList(item, complexRentList);
    }

    if (map && item.latVal != null && item.lonVal != null) {
        const moveLatLng = new kakao.maps.LatLng(item.latVal, item.lonVal);
        map.panTo(moveLatLng);
    }
}

/**
 * 가운데 상세 패널 렌더링
 */
function renderDetail(item) {
    const heroEl = document.getElementById("rentDetailHero");
    const detailEl = document.getElementById("rentDetail");

    if (!detailEl) {
        return;
    }

    if (heroEl) {
        // 이미지 영역 자체도 강제로 패널 전체 폭 사용
        heroEl.className = "rent-detail-hero-area";
        heroEl.style.width = "100%";
        heroEl.style.height = "200px";
        heroEl.style.margin = "0";
        heroEl.style.padding = "0";
        heroEl.style.overflow = "hidden";
        heroEl.style.flexShrink = "0";
        heroEl.style.display = "block";

        // img도 inline style로 강제 적용
        heroEl.innerHTML = `
        <img src="${item.imgUrl}"
             alt="${item.aptCmplexNm}"
             style="
                 width:100%;
                 height:100%;
                 display:block;
                 object-fit:cover;
                 object-position:center center;
                 margin:0;
                 padding:0;
                 border:0;
             ">
    `;
    }

    detailEl.className = "";
    detailEl.innerHTML = `
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
 * 단지 매물목록 + 상세 패널 닫기
 */
function closeRentPanels() {
    const page = document.querySelector(".rent-map-page");

    if (!page) {
        return;
    }

    page.classList.add("panels-collapsed");

    setTimeout(function () {
        if (map) {
            map.relayout();

            if (selectedAptCmplexNo) {
                const selectedItem = rentListingList.find(function (item) {
                    return item.aptCmplexNo === selectedAptCmplexNo;
                });

                if (selectedItem && selectedItem.latVal != null && selectedItem.lonVal != null) {
                    map.setCenter(new kakao.maps.LatLng(selectedItem.latVal, selectedItem.lonVal));
                }
            }
        }
    }, 260);
}

/**
 * 가격 표시
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
    location.href = "/rent/detail/" + rentLstgNo;
}