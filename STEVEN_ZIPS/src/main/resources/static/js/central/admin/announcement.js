/*
  중앙관리자 : 공고 관리 JS

  1. 조회 결과가 0건이면 alert를 띄우지 않고 목록 영역에 "조회된 공고가 없습니다." 출력
  2. alert는 서버 오류, URL 오류, XML 오류처럼 fetch 자체가 실패했을 때만 실행
  3. 단지 목록은 APT_COMPLEX 테이블에서 조회해서 select box에 넣음
*/

const TODAY = new Date();

let posts = [];
let filtered = [];
let aptComplexList = [];

let currentPage = 1;
const PAGE_SIZE = 10;

/*
  공고 상태 계산 함수

  상태란?
  → 현재 날짜가 모집기간보다 전/중/후인지 계산한 화면 표시값.
*/
function calcStatus(start, end) {
    if (!start || !end) {
        return "-";
    }

    const s = new Date(start);
    const e = new Date(end);

    if (TODAY < s) return "예정";
    if (TODAY > e) return "마감";
    return "진행중";
}

/*
  상태 배지 생성 함수

  배지란?
  → 진행중, 마감, 예정 같은 상태를 색상 라벨처럼 보여주는 UI.
*/
function badgeHtml(status) {
    const map = {
        "진행중": "c-badge--active",
        "마감": "c-badge--neutral",
        "예정": "c-badge--pending"
    };

    return '<span class="c-badge ' + (map[status] || "") + '">' + status + '</span>';
}

/*
  단지 목록 조회

  사용 이유
  → JSP에 단지명을 직접 적어두면 DB와 화면 데이터가 달라질 수 있음.
  → APT_COMPLEX 테이블 기준으로 select option을 자동 생성한다.
*/
function loadAptComplexList() {
    fetch("/centralAdmin/announcement/aptComplexList")
        .then(function (response) {
            if (!response.ok) {
                throw new Error("단지 목록 조회 실패");
            }
            return response.json();
        })
        .then(function (data) {
            aptComplexList = data || [];

            renderAptSelect("f-site", "단지 전체");
            renderAptSelect("f-fsite", "단지 선택");
        })
        .catch(function (error) {
            console.error(error);
            alert("단지 목록을 불러오지 못했습니다.");
        });
}

/*
  select box option 생성 함수
*/
function renderAptSelect(selectId, defaultText) {
    const select = document.getElementById(selectId);

    if (!select) {
        return;
    }

    let html = '<option value="">' + defaultText + '</option>';

    aptComplexList.forEach(function (apt) {
        html += '<option value="' + apt.aptCmplexNo + '" data-unit-cnt="' + (apt.unitCnt || 0) + '">';
        html += apt.aptCmplexNm;
        html += '</option>';
    });

    select.innerHTML = html;
}

/*
  공고 목록 조회

  중요
  → 조회 결과가 0건인 것은 오류가 아님.
  → 서버 응답이 정상 200이면 data가 빈 배열이어도 renderList()에서 처리한다.
*/
function loadAnnouncementList() {
    const params = new URLSearchParams();

    const title = document.getElementById("f-title").value;
    const aptCmplexNo = document.getElementById("f-site").value;
    const from = document.getElementById("f-from").value;
    const to = document.getElementById("f-to").value;
    const status = document.getElementById("f-status").value;

    if (title) params.append("searchTtl", title);
    if (aptCmplexNo) params.append("searchAptCmplexNo", aptCmplexNo);
    if (from) params.append("searchFrom", from);
    if (to) params.append("searchTo", to);
    if (status) params.append("searchStatus", status);

    fetch("/centralAdmin/announcement/list?" + params.toString())
        .then(function (response) {
            /*
              response.ok가 false인 경우
              → Controller 오류, XML 오류, DB 오류, URL 오류 등 서버 통신 실패.
              → 이때만 catch로 넘긴다.
            */
            if (!response.ok) {
                throw new Error("공고 목록 조회 실패");
            }

            return response.json();
        })
        .then(function (data) {
            /*
              data가 빈 배열 []이어도 정상 응답이다.
              → alert를 띄우지 않고 renderList()에서 빈 목록 메시지를 보여준다.
            */
            posts = data || [];
            filtered = posts.slice();

            currentPage = 1;
            renderList();
        })
        .catch(function (error) {

            /*
              console.error란?
              → 브라우저 개발자도구(F12 Console)에만 에러를 출력한다.

              왜 사용?
              → 사용자에게 alert 팝업은 안보이고,
                 개발자는 콘솔에서 실제 오류 원인을 확인 가능.
            */
            console.error(error);

            /*
              alert 제거
              → 화면 팝업 안뜨게 처리
            */

            /*
            alert("공고 목록 조회 중 서버 오류가 발생했습니다.");
            */

            /*
              목록 영역에 에러 메시지 출력
              → 실무에서는 alert보다 화면 메시지를 더 많이 사용.
            */
            document.getElementById("list-body").innerHTML = `
        <tr>
            <td colspan="6" style="text-align:center; padding:24px; color:red;">
                공고 목록 조회 중 오류가 발생했습니다.
            </td>
        </tr>
    `;
        });
}

/*
  목록 렌더링
*/
function renderList() {
    const tbody = document.getElementById("list-body");

    const start = (currentPage - 1) * PAGE_SIZE;
    const slice = filtered.slice(start, start + PAGE_SIZE);

    if (slice.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" style="text-align:center; padding:24px;">
                    조회된 공고가 없습니다.
                </td>
            </tr>
        `;

        document.getElementById("list-count").textContent = 0;
        renderPagination();
        return;
    }

    tbody.innerHTML = slice.map(function (p) {
        const st = p.statusNm || calcStatus(p.rcrtBgngDt, p.rcrtEndDt);

        return `
            <tr>
                <td>${p.ttl || "-"}</td>
                <td>${p.aptCmplexNm || "-"}</td>
                <td>${p.rcrtBgngDt || "-"} ~ ${p.rcrtEndDt || "-"}</td>
                <td>${p.unitCnt || 0}세대</td>
                <td>${p.sbmsnDocNm || "-"}</td>
                <td>${badgeHtml(st)}</td>
            </tr>
        `;
    }).join("");

    document.getElementById("list-count").textContent = filtered.length;
    renderPagination();
}

/*
  페이지 버튼 생성
*/
function renderPagination() {
    const pagination = document.getElementById("pagination");

    if (!pagination) {
        return;
    }

    const totalPage = Math.ceil(filtered.length / PAGE_SIZE);

    if (totalPage <= 1) {
        pagination.innerHTML = "";
        return;
    }

    let html = "";

    for (let i = 1; i <= totalPage; i++) {
        html += `
            <button class="c-page-btn ${i === currentPage ? "is-active" : ""}" onclick="movePage(${i})">
                ${i}
            </button>
        `;
    }

    pagination.innerHTML = html;
}

function movePage(page) {
    currentPage = page;
    renderList();
}

function doFilter() {
    loadAnnouncementList();
}

function resetFilter() {
    document.getElementById("f-title").value = "";
    document.getElementById("f-site").value = "";
    document.getElementById("f-from").value = "";
    document.getElementById("f-to").value = "";
    document.getElementById("f-status").value = "";

    loadAnnouncementList();
}

function openRegister() {
    document.getElementById("form-modal").classList.remove("is-hidden");
}

function closeFormModal() {
    document.getElementById("form-modal").classList.add("is-hidden");
}

function closeFormOutside(event) {
    if (event.target.id === "form-modal") {
        closeFormModal();
    }
}

/*
  모달 단지 선택 시 공급 세대수 자동 표시

  공급 세대수
  → CENTER_ANN_BOARD_POST에 저장하지 않음.
  → APT_COMPLEX.UNIT_CNT 또는 APT_UNIT 합계로 조회한 값을 화면에 표시한다.
*/
document.addEventListener("change", function (event) {
    if (event.target.id === "f-fsite") {
        const selected = event.target.options[event.target.selectedIndex];
        const unitCnt = selected.getAttribute("data-unit-cnt") || "";

        document.getElementById("f-funit").value = unitCnt;
    }
});

document.addEventListener("DOMContentLoaded", function () {
    loadAptComplexList();
    loadAnnouncementList();
});