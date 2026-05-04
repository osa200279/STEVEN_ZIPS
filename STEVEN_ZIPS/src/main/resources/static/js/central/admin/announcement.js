/*
  중앙관리자 : 공고 관리 JS
*/

const TODAY = new Date("2026-04-22");

function calcStatus(start, end) {
    const s = new Date(start);
    const e = new Date(end);

    if (TODAY < s) return "예정";
    if (TODAY > e) return "마감";
    return "진행중";
}

function badgeHtml(status) {
    const map = {
        진행중: "c-badge--active",
        마감: "c-badge--neutral",
        예정: "c-badge--pending"
    };

    return '<span class="c-badge ' + (map[status] || "") + '">' + status + '</span>';
}

let posts = [];
const sites = ["강남 센트럴", "한강 리버뷰", "자이 아파트"];

/*
  더미 데이터 생성
  → 실제로는 DB에서 가져와야 함
*/
for (let i = 1; i <= 24; i++) {
    const m = ((i * 2) % 6) + 1;
    const d = ((i * 5) % 25) + 1;

    const start = "2026-0" + m + "-" + String(d).padStart(2, "0");
    const endM = m + (i % 2);
    const end = "2026-0" + endM + "-" + String(((d + 14) % 28) + 1).padStart(2, "0");

    posts.push({
        id: i,
        title: "공고 #" + i,
        site: sites[i % sites.length],
        start: start,
        end: end,
        units: 100,
        docs: "신분증",
        content: "내용"
    });
}

let filtered = posts.slice();
let currentPage = 1;
const PAGE_SIZE = 10;

/*
  목록 렌더링
*/
function renderList() {
    const tbody = document.getElementById("list-body");

    const start = (currentPage - 1) * PAGE_SIZE;
    const slice = filtered.slice(start, start + PAGE_SIZE);

    tbody.innerHTML = slice.map(p => {
        const st = calcStatus(p.start, p.end);

        return `
      <tr>
        <td>${p.title}</td>
        <td>${p.site}</td>
        <td>${p.start} ~ ${p.end}</td>
        <td>${p.units}</td>
        <td>${p.docs}</td>
        <td>${badgeHtml(st)}</td>
      </tr>
    `;
    }).join("");

    document.getElementById("list-count").textContent = filtered.length;
}

/*
  검색
*/
function doFilter() {
    const title = document.getElementById("f-title").value.toLowerCase();

    filtered = posts.filter(p => p.title.toLowerCase().includes(title));

    currentPage = 1;
    renderList();
}

/*
  초기화
*/
function resetFilter() {
    document.getElementById("f-title").value = "";
    filtered = posts.slice();
    renderList();
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
*/
document.addEventListener("DOMContentLoaded", function () {
    renderList();
});