// rentMap.js
// 임대 매물 지도 화면 JS
// DB 데이터: /rent/list-data

let rentListingList = [];
let map;
let geocoder;
let markers = [];
let selectedRentNo = null;
let selectedAptCmplexNo = null;
let currentType = "ALL";

document.addEventListener("DOMContentLoaded", function () {
    initMap();
    bindEvents();
    loadRentListings();
});

/**
 * 카카오 지도 초기화
 */
function initMap() {
    const mapContainer = document.getElementById("rentMap");

    if (!mapContainer) {
        console.error("#rentMap 영역을 찾을 수 없습니다.");
        return;
    }

    const mapOption = {
        center: new kakao.maps.LatLng(37.5665, 126.9780),
        level: 7
    };

    map = new kakao.maps.Map(mapContainer, mapOption);

    if (kakao.maps.services) {
        geocoder = new kakao.maps.services.Geocoder();
    } else {
        console.error("카카오 services 라이브러리가 없습니다. SDK에 &libraries=services 를 추가해야 합니다.");
    }
}

/**
 * DB 매물 목록 조회
 */
function loadRentListings() {
    const apiUrl = (typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "") + "/rent/list-data";

    fetch(apiUrl)
        .then(function (response) {
            if (!response.ok) {
                throw new Error("매물 목록 조회 실패");
            }

            return response.json();
        })
        .then(function (data) {
            console.log("매물 목록 데이터:", data);

            if (!data.success) {
                alert(data.message || "매물 목록을 불러오지 못했습니다.");
                return;
            }

            rentListingList = normalizeRentList(data.list || []);

            if (rentListingList.length === 0) {
                showEmptyMapMessage();
                return;
            }

            renderMarkers();
        })
        .catch(function (error) {
            console.error("매물 목록 조회 오류:", error);
            alert("매물 목록 조회 중 오류가 발생했습니다.");
        });
}

/**
 * DB 데이터 화면용 보정
 */
function normalizeRentList(list) {
    return list.map(function (item, index) {
        const normalized = Object.assign({}, item);

        normalized.rentLstgNo = nvl(item.rentLstgNo);
        normalized.rentTypeCd = nvl(item.rentTypeCd);
        normalized.rentTypeNm = nvl(item.rentTypeNm, item.rentTypeCd);
        normalized.rentTtl = nvl(item.rentTtl, item.aptCmplexNm);
        normalized.aptCmplexNo = nvl(item.aptCmplexNo);
        normalized.aptCmplexNm = nvl(item.aptCmplexNm, "아파트 단지");
        normalized.dorojuso = nvl(item.dorojuso);
        normalized.dongNm = nvl(item.dongNm, item.dongNo);
        normalized.dongNo = nvl(item.dongNo);
        normalized.ho = nvl(item.ho);
        normalized.floor = item.floor || "-";
        normalized.empty = nvl(item.empty, "-");
        normalized.dpstAmt = Number(item.dpstAmt || 0);
        normalized.mthlyRentAmt = Number(item.mthlyRentAmt || 0);
        normalized.rentLstgCn = nvl(item.rentLstgCn, "등록된 매물 설명이 없습니다.");
        normalized.rcrtBggnDt = nvl(item.rcrtBggnDt);
        normalized.rcrtEndDt = nvl(item.rcrtEndDt);
        normalized.unitCnt = item.unitCnt || 0;
        normalized.dongCnt = item.dongCnt || 0;
        normalized.bldYr = nvl(item.bldYr, "-");
        normalized.cnscoNm = nvl(item.cnscoNm, "-");
        normalized.pkgCnt = item.pkgCnt || 0;
        normalized.ccCnt = item.ccCnt || "-";
        normalized.dongMaxFloor = item.dongMaxFloor || "-";
        normalized.exclusiveSize = item.exclusiveSize || "-";

        /*
         * DB에 이미지가 아직 없으므로 임시 이미지 사용
         */
        normalized.imgUrl = item.imgUrl || getDefaultImage(index);

        return normalized;
    });
}

function getDefaultImage(index) {
    const images = [
        "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=1200",
        "https://images.unsplash.com/photo-1560518883-ce09059eeffa?q=80&w=1200",
        "https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=1200"
    ];

    return images[index % images.length];
}

/**
 * 검색어, 거래유형 필터 이벤트 연결
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
 * 같은 단지에 매물이 여러 개 있어도 마커는 하나만 만든다.
 */
function getComplexMarkerList() {
    const complexMap = {};
    const filteredList = getFilteredList();

    filteredList.forEach(function (item) {
        if (!item.aptCmplexNo) {
            return;
        }

        if (!complexMap[item.aptCmplexNo]) {
            complexMap[item.aptCmplexNo] = {
                aptCmplexNo: item.aptCmplexNo,
                aptCmplexNm: item.aptCmplexNm,
                dorojuso: item.dorojuso,
                latVal: item.latVal,
                lonVal: item.lonVal,
                rentCount: 0,
                minMonthlyRentAmt: null,
                maxDpstAmt: null,
                firstRent: item
            };
        }

        complexMap[item.aptCmplexNo].rentCount++;

        /*
         * JS: 전세임대
         * PE: 영구임대(월세)
         */
        if (item.rentTypeCd === "PE") {
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
 */
function renderMarkers() {
    clearMarkers();

    if (!map) {
        return;
    }

    const complexList = getComplexMarkerList();

    if (complexList.length === 0) {
        return;
    }

    const bounds = new kakao.maps.LatLngBounds();
    let markerCount = 0;

    complexList.forEach(function (complex) {
        createComplexMarker(complex, function (position) {
            bounds.extend(position);
            markerCount++;

            if (markerCount > 0) {
                map.setBounds(bounds);
            }
        });
    });
}

/**
 * 단지 마커 생성
 * lat/lon이 있으면 사용하고, 없으면 dorojuso 주소검색으로 좌표 생성
 */
function createComplexMarker(complex, afterCreate) {
    if (complex.latVal != null && complex.lonVal != null) {
        const position = new kakao.maps.LatLng(Number(complex.latVal), Number(complex.lonVal));
        addComplexOverlay(complex, position);

        if (afterCreate) {
            afterCreate(position);
        }

        return;
    }

    if (!geocoder) {
        console.error("geocoder가 초기화되지 않았습니다.");
        return;
    }

    if (!complex.dorojuso) {
        console.warn("주소가 없는 단지:", complex);
        return;
    }

    geocoder.addressSearch(complex.dorojuso, function (result, status) {
        if (status !== kakao.maps.services.Status.OK || !result || result.length === 0) {
            console.warn("주소 변환 실패:", complex.dorojuso);
            return;
        }

        const lat = Number(result[0].y);
        const lng = Number(result[0].x);
        const position = new kakao.maps.LatLng(lat, lng);

        /*
         * 같은 단지 매물들은 이후 지도 이동에 쓸 수 있게 좌표를 저장
         */
        rentListingList.forEach(function (item) {
            if (item.aptCmplexNo === complex.aptCmplexNo) {
                item.latVal = lat;
                item.lonVal = lng;
            }
        });

        complex.latVal = lat;
        complex.lonVal = lng;

        addComplexOverlay(complex, position);

        if (afterCreate) {
            afterCreate(position);
        }
    });
}

/**
 * 커스텀 오버레이 추가
 */
function addComplexOverlay(complex, position) {
    const markerContent =
        '<div class="rent-marker" onclick="selectComplex(\'' + escapeJs(complex.aptCmplexNo) + '\')">'
        + escapeHtml(getComplexMarkerText(complex))
        + '</div>';

    const customOverlay = new kakao.maps.CustomOverlay({
        position: position,
        content: markerContent,
        yAnchor: 1.3
    });

    customOverlay.setMap(map);
    markers.push(customOverlay);
}

/**
 * 단지 마커 문구
 */
function getComplexMarkerText(complex) {
    if (complex.minMonthlyRentAmt != null && complex.minMonthlyRentAmt > 0) {
        return "월 " + formatMoneyShort(complex.minMonthlyRentAmt);
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

        return ''
            + '<article class="complex-rent-card ' + activeClass + '" onclick="selectRent(\'' + escapeJs(item.rentLstgNo) + '\')">'
            + '  <div class="complex-rent-card-top">'
            + '    <span class="rent-type-badge">' + escapeHtml(item.rentTypeNm) + '</span>'
            + '    <span style="font-size:12px; color:#667085;">' + escapeHtml(formatDate(item.rcrtEndDt)) + ' 마감</span>'
            + '  </div>'
            + '  <h3 class="complex-rent-title">' + escapeHtml(item.aptCmplexNm) + ' ' + escapeHtml(item.dongNm) + '</h3>'
            + '  <p class="complex-rent-price">' + escapeHtml(formatPrice(item)) + '</p>'
            + '  <p class="complex-rent-info">'
            +       escapeHtml(item.exclusiveSize) + '㎡ · '
            +       escapeHtml(item.floor) + '층 · '
            +       escapeHtml(item.ho) + '호<br>'
            +       escapeHtml(item.dorojuso)
            + '  </p>'
            + '</article>';
    }).join("");
}

/**
 * 매물 선택
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

    const complexRentList = getRentListByComplex(item.aptCmplexNo);

    if (complexRentList.length > 0) {
        renderComplexRentList(item, complexRentList);
    }

    if (map && item.latVal != null && item.lonVal != null) {
        map.panTo(new kakao.maps.LatLng(item.latVal, item.lonVal));
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
        heroEl.className = "rent-detail-hero-area";
        heroEl.innerHTML =
            '<img src="' + escapeHtml(item.imgUrl) + '"'
            + ' alt="' + escapeHtml(item.aptCmplexNm) + '"'
            + ' style="width:100%;height:100%;display:block;object-fit:cover;object-position:center center;">';
    }

    detailEl.className = "";
    detailEl.innerHTML = ''
        + '<div class="rent-detail-content">'
        + '  <span class="rent-type-badge">' + escapeHtml(item.rentTypeNm) + '</span>'
        + '  <h2>' + escapeHtml(item.aptCmplexNm) + '</h2>'
        + '  <p style="color:#667085; margin-top:0;">' + escapeHtml(item.dongNm) + ' ' + escapeHtml(item.ho) + '호</p>'
        + '  <div class="rent-detail-price">' + escapeHtml(formatPrice(item)) + '</div>'

        + '  <div class="rent-info-grid">'
        + '    <div class="rent-info-item"><span class="rent-info-label">전용면적</span><span class="rent-info-value">' + escapeHtml(item.exclusiveSize) + '㎡</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">층수</span><span class="rent-info-value">' + escapeHtml(item.floor) + '층 / 최고 ' + escapeHtml(item.dongMaxFloor) + '층</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">호 상태</span><span class="rent-info-value">' + escapeHtml(item.empty) + '</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">모집 기간</span><span class="rent-info-value">' + escapeHtml(formatDate(item.rcrtBggnDt)) + ' ~ ' + escapeHtml(formatDate(item.rcrtEndDt)) + '</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">세대수</span><span class="rent-info-value">' + escapeHtml(formatNumber(item.unitCnt)) + '세대</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">동수</span><span class="rent-info-value">' + escapeHtml(item.dongCnt) + '동</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">준공년도</span><span class="rent-info-value">' + escapeHtml(item.bldYr) + '</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">건설사</span><span class="rent-info-value">' + escapeHtml(nvl(item.cnscoNm, "-")) + '</span></div>'
        + '  </div>'

        + '  <h3 class="rent-detail-section-title">주소</h3>'
        + '  <p class="rent-detail-desc">' + escapeHtml(item.dorojuso) + '</p>'

        + '  <h3 class="rent-detail-section-title">매물 설명</h3>'
        + '  <p class="rent-detail-desc">' + escapeHtml(item.rentLstgCn) + '</p>'

        + '  <button type="button" class="rent-detail-btn" onclick="goRentDetail(\'' + escapeJs(item.rentLstgNo) + '\')">'
        + '    매물 상세보기'
        + '  </button>'
        + '</div>';
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
    if (item.rentTypeCd === "JS") {
        return "전세 " + formatMoney(item.dpstAmt);
    }

    if (item.rentTypeCd === "PE") {
        return "보증금 " + formatMoney(item.dpstAmt) + " / 월 " + formatMoney(item.mthlyRentAmt);
    }

    return formatMoney(item.dpstAmt);
}

/**
 * 금액 포맷
 * DB 금액은 원 단위 기준
 */
function formatMoney(value) {
    if (value == null || value === "") {
        return "-";
    }

    const num = Number(value);

    if (num === 0) {
        return "0원";
    }

    const eok = Math.floor(num / 100000000);
    const man = Math.floor((num % 100000000) / 10000);

    if (eok > 0 && man > 0) {
        return eok + "억 " + man.toLocaleString() + "만";
    }

    if (eok > 0) {
        return eok + "억";
    }

    if (man > 0) {
        return man.toLocaleString() + "만";
    }

    return num.toLocaleString() + "원";
}

/**
 * 마커용 짧은 금액 포맷
 */
function formatMoneyShort(value) {
    if (value == null || value === "") {
        return "-";
    }

    const num = Number(value);

    if (num === 0) {
        return "0";
    }

    const eok = Math.floor(num / 100000000);
    const man = Math.floor((num % 100000000) / 10000);

    if (eok > 0 && man > 0) {
        return eok + "." + Math.floor(man / 1000) + "억";
    }

    if (eok > 0) {
        return eok + "억";
    }

    if (man > 0) {
        return man.toLocaleString() + "만";
    }

    return num.toLocaleString();
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
        if (/^\d{8}$/.test(value)) {
            return value.substring(0, 4) + "-" + value.substring(4, 6) + "-" + value.substring(6, 8);
        }

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

    if (value == null || value === "") {
        return defaultValue;
    }

    return String(value);
}

/**
 * HTML escape
 */
function escapeHtml(value) {
    if (value == null) {
        return "";
    }

    return String(value)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}

/**
 * onclick 문자열 escape
 */
function escapeJs(value) {
    if (value == null) {
        return "";
    }

    return String(value).replaceAll("\\", "\\\\").replaceAll("'", "\\'");
}

/**
 * 상세 페이지 이동
 */
function goRentDetail(rentLstgNo) {
    const contextPath = typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "";
    location.href = contextPath + "/rent/detail/" + encodeURIComponent(rentLstgNo);
}

/**
 * 데이터 없음 메시지
 */
function showEmptyMapMessage() {
    const listEl = document.getElementById("complexRentList");

    if (listEl) {
        listEl.innerHTML =
            '<div class="rent-empty-message">등록된 매물이 없습니다.</div>';
    }
}