/*
  중앙관리자 : 공고 관리 JS
*/

/*
  TODAY
  → 오늘 날짜를 기준으로 공고 상태를 계산하기 위한 값.
*/
const TODAY = new Date();

/*
  공고 상태 계산 함수

  start: 모집 시작일
  end: 모집 종료일

  사용 상황
  → DB에서 상태값이 따로 없을 때, 모집기간 기준으로 예정/진행중/마감을 화면에서 계산한다.
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
  상태 배지 HTML 생성 함수

  badge란?
  → 상태를 색상 라벨처럼 보여주는 UI 요소.
*/
function badgeHtml(status) {
    const map = {
        진행중: "c-badge--active",
        마감: "c-badge--neutral",
        예정: "c-badge--pending"
    };

    return '<span class="c-badge ' + (map[status] || "") + '">' + status + '</span>';
}

/*
  posts
  → DB에서 조회한 전체 공고 목록을 담는 배열.

  filtered
  → 화면에 실제로 보여줄 공고 목록.
*/
let posts = [];
let filtered = [];

let currentPage = 1;
const PAGE_SIZE = 10;

/*
  공고 목록 DB 조회 함수
*/
function loadAnnouncementList() {
    const params = new URLSearchParams();

    /*
      검색 조건 가져오기
    */
    const title = document.getElementById("f-title").value;
    const from = document.getElementById("f-from").value;
    const to = document.getElementById("f-to").value;
    const status = document.getElementById("f-status").value;

    /*
      Controller의 AnnouncementVO 검색 필드명과 맞춰서 보낸다.

      searchTtl     → 제목 검색
      searchFrom    → 모집 시작일 검색
      searchTo      → 모집 종료일 검색
      searchStatus  → 상태 검색
    */
    if (title) params.append("searchTtl", title);
    if (from) params.append("searchFrom", from);
    if (to) params.append("searchTo", to);
    if (status) params.append("searchStatus", status);

    /*
      실제 요청 URL
      Controller:
      @GetMapping("/list")
      /centralAdmin/announcement/list
    */
    fetch("/centralAdmin/announcement/list?" + params.toString())
        .then(function (response) {
            if (!response.ok) {
                throw new Error("공고 목록 조회 실패");
            }

            return response.json();
        })
        .then(function (data) {
            /*
              data
              → Controller에서 JSON으로 응답한 공고 목록
            */
            posts = data;
            filtered = posts.slice();

            currentPage = 1;
            renderList();
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 목록을 불러오지 못했습니다.");
        });
}

/*
  목록 렌더링 함수
*/
function renderList() {
    const tbody = document.getElementById("list-body");

    const start = (currentPage - 1) * PAGE_SIZE;
    const slice = filtered.slice(start, start + PAGE_SIZE);

    /*
      조회 결과가 없을 때
    */
    if (slice.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" style="text-align:center;">조회된 공고가 없습니다.</td>
            </tr>
        `;

        document.getElementById("list-count").textContent = 0;
        return;
    }

    tbody.innerHTML = slice.map(function (p) {
        /*
          DB/XML에서 statusNm을 만들어서 내려주면 그 값을 사용.
          없으면 JS에서 모집기간 기준으로 계산.
        */
        const st = p.statusNm || calcStatus(p.rcrtBgngDt, p.rcrtEndDt);

        return `
            <tr>
                <td>${p.ttl || "-"}</td>
                <td>${p.boardNm || "-"}</td>
                <td>${p.rcrtBgngDt || "-"} ~ ${p.rcrtEndDt || "-"}</td>
                <td>-</td>
                <td>-</td>
                <td>${badgeHtml(st)}</td>
            </tr>
        `;
    }).join("");

    document.getElementById("list-count").textContent = filtered.length;
}

/*
  검색 버튼 클릭 시 실행
*/
function doFilter() {
    loadAnnouncementList();
}

/*
  초기화 버튼 클릭 시 실행
*/
function resetFilter() {
    document.getElementById("f-title").value = "";
    document.getElementById("f-site").value = "";
    document.getElementById("f-from").value = "";
    document.getElementById("f-to").value = "";
    document.getElementById("f-status").value = "";

    loadAnnouncementList();
}

/*
  모달 열기
*/
function openRegister() {
    document.getElementById("form-modal").classList.remove("is-hidden");
}

/*
  모달 닫기
*/
function closeFormModal() {
    document.getElementById("form-modal").classList.add("is-hidden");
}

/*
  최초 실행
  DB에서 목록을 가져온 뒤 renderList() 실행
*/
document.addEventListener("DOMContentLoaded", function () {
    loadAnnouncementList();
});