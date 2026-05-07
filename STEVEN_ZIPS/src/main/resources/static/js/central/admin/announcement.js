/*
  중앙관리자 : 공고 관리 JS
*/

const TODAY = new Date();

let posts = [];
let filtered = [];
let aptComplexList = [];

let currentPage = 1;
const PAGE_SIZE = 10;

let currentAnnNo = null;
let formMode = "insert";

/*
  CSRF 헤더 생성

  CSRF란?
  → 로그인한 사용자의 권한을 악용한 위조 요청을 막는 보안 토큰.
  왜 사용?
  → Spring Security 사용 시 POST/PUT/DELETE 요청에 필요할 수 있다.
*/
function getCsrfHeaders() {
    const tokenMeta = document.querySelector('meta[name="_csrf"]');
    const headerMeta = document.querySelector('meta[name="_csrf_header"]');

    const headers = {
        "Content-Type": "application/json"
    };

    if (tokenMeta && headerMeta) {
        headers[headerMeta.getAttribute("content")] = tokenMeta.getAttribute("content");
    }

    return headers;
}

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

function badgeHtml(status) {
    const map = {
        "진행중": "c-badge--active",
        "마감": "c-badge--neutral",
        "예정": "c-badge--pending"
    };

    return '<span class="c-badge ' + (map[status] || "") + '">' + status + '</span>';
}

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
            if (!response.ok) {
                throw new Error("공고 목록 조회 실패");
            }
            return response.json();
        })
        .then(function (data) {
            posts = data || [];
            filtered = posts.slice();

            currentPage = 1;
            renderList();
        })
        .catch(function (error) {
            console.error(error);

            document.getElementById("list-body").innerHTML = `
                <tr>
                    <td colspan="6" style="text-align:center; padding:24px; color:red;">
                        공고 목록 조회 중 오류가 발생했습니다.
                    </td>
                </tr>
            `;
        });
}

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
            <tr onclick="openDetail('${p.annNo}')" style="cursor:pointer;">
                <td>${p.ttl || "-"}</td>
                <td style="text-align:left;">${p.aptCmplexNm || "-"}</td>
                <td>${p.rcrtBgngDt || "-"} ~ ${p.rcrtEndDt || "-"}</td>
                <td>${p.unitCnt || 0}세대</td>
                <td>${p.sbmsnDocNm || "-"}</td>
                <td style="text-align:center;">${badgeHtml(st)}</td>
            </tr>
        `;
    }).join("");

    document.getElementById("list-count").textContent = filtered.length;
    renderPagination();
}

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
    formMode = "insert";
    currentAnnNo = null;

    clearForm();

    document.getElementById("form-title").textContent = "입주자 모집 공고 등록";
    document.getElementById("form-submit-btn").innerHTML = '<span class="material-symbols-rounded">check</span>등록';

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

function clearForm() {
    document.getElementById("f-ftitle").value = "";
    document.getElementById("f-fsite").value = "";
    document.getElementById("f-pblanc-start").value = "";
    document.getElementById("f-pblanc-end").value = "";
    document.getElementById("f-fstart").value = "";
    document.getElementById("f-fend").value = "";
    document.getElementById("f-funit").value = "";
    document.getElementById("f-content").value = "";

    clearErrors();
}

function clearErrors() {
    document.querySelectorAll(".err-msg").forEach(function (el) {
        el.textContent = "";
    });
}

function validateForm() {
    clearErrors();

    let valid = true;

    const ttl = document.getElementById("f-ftitle").value.trim();
    const aptCmplexNo = document.getElementById("f-fsite").value;
    const rcrtBgngDt = document.getElementById("f-fstart").value;
    const rcrtEndDt = document.getElementById("f-fend").value;
    const cn = document.getElementById("f-content").value.trim();

    if (!ttl) {
        document.getElementById("e-ftitle").textContent = "공고 제목을 입력해주세요.";
        valid = false;
    }

    if (!aptCmplexNo) {
        document.getElementById("e-fsite").textContent = "단지를 선택해주세요.";
        valid = false;
    }

    if (!rcrtBgngDt || !rcrtEndDt) {
        document.getElementById("e-fdate").textContent = "모집 기간을 입력해주세요.";
        valid = false;
    }

    if (rcrtBgngDt && rcrtEndDt && rcrtBgngDt > rcrtEndDt) {
        document.getElementById("e-fdate").textContent = "모집 시작일은 종료일보다 늦을 수 없습니다.";
        valid = false;
    }

    if (!cn) {
        document.getElementById("e-content").textContent = "공고 내용을 입력해주세요.";
        valid = false;
    }

    return valid;
}

function submitForm() {
    if (!validateForm()) {
        return;
    }

    const payload = {
        ttl: document.getElementById("f-ftitle").value.trim(),
        aptCmplexNo: document.getElementById("f-fsite").value,
        pblancBgngDt: document.getElementById("f-pblanc-start").value,
        pblancEndDt: document.getElementById("f-pblanc-end").value,
        rcrtBgngDt: document.getElementById("f-fstart").value,
        rcrtEndDt: document.getElementById("f-fend").value,
        cn: document.getElementById("f-content").value.trim()
    };

    const url = formMode === "update"
        ? "/centralAdmin/announcement/" + currentAnnNo
        : "/centralAdmin/announcement";

    const method = formMode === "update" ? "PUT" : "POST";

    fetch(url, {
        method: method,
        headers: getCsrfHeaders(),
        body: JSON.stringify(payload)
    })
        .then(function (response) {
            if (!response.ok) {
                throw new Error("공고 저장 실패");
            }
            return response.json();
        })
        .then(function (data) {
            if (!data.success) {
                alert("공고 저장에 실패했습니다.");
                return;
            }

            alert(formMode === "update" ? "공고가 수정되었습니다." : "공고가 등록되었습니다.");

            closeFormModal();
            loadAnnouncementList();
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 저장 중 오류가 발생했습니다.");
        });
}

function openDetail(annNo) {
    currentAnnNo = annNo;

    fetch("/centralAdmin/announcement/" + annNo)
        .then(function (response) {
            if (!response.ok) {
                throw new Error("공고 상세 조회 실패");
            }
            return response.json();
        })
        .then(function (data) {
            renderDetail(data);
            document.getElementById("detail-modal").classList.remove("is-hidden");
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 상세 정보를 불러오지 못했습니다.");
        });
}

function renderDetail(data) {
    /*
      공고 상세 조회 화면

      readonly-box란?
      → 수정 가능한 input이 아니라,
        input처럼 보이지만 읽기만 하는 박스.
      왜 사용?
      → 상세보기 화면을 등록/수정 모달과 비슷한 UI로 맞추기 위해.
    */
    const st = data.statusNm || calcStatus(data.rcrtBgngDt, data.rcrtEndDt);

    document.getElementById("detail-status-badge").innerHTML = badgeHtml(st);
    document.getElementById("modal-content").innerHTML = `
    
        <!-- 상세 정보 -->
        <div class="detail-form-grid">
    
            <div class="c-field">
                <label class="c-label">공고 제목</label>
                <div class="detail-readonly-box">${data.ttl || "-"}</div>
            </div>
    
            <div class="c-field">
                <label class="c-label">단지</label>
                <div class="detail-readonly-box">${data.aptCmplexNm || "-"}</div>
            </div>
    
            <div class="c-field">
                <label class="c-label">공고 게시 기간</label>
                <div class="detail-readonly-box">
                    ${data.pblancBgngDt || "-"} ~ ${data.pblancEndDt || "-"}
                </div>
            </div>
    
            <div class="c-field">
                <label class="c-label">모집 기간</label>
                <div class="detail-readonly-box">
                    ${data.rcrtBgngDt || "-"} ~ ${data.rcrtEndDt || "-"}
                </div>
            </div>
    
            <div class="c-field">
                <label class="c-label">공급 세대수</label>
                <div class="detail-readonly-box">${data.unitCnt || 0}세대</div>
            </div>
    
            <div class="c-field">
                <label class="c-label">제출 서류</label>
                <div class="detail-readonly-box">${data.sbmsnDocNm || "-"}</div>
            </div>
    
            <div class="c-field detail-full">
                <label class="c-label">공고 내용</label>
    
                <div class="detail-readonly-box detail-readonly-box--content">
                    ${data.cn || "-"}
                </div>
            </div>
    
        </div>
    `;
}

function closeModal() {
    document.getElementById("detail-modal").classList.add("is-hidden");
}

function closeOutside(event) {
    if (event.target.id === "detail-modal") {
        closeModal();
    }
}

function editFromModal() {
    if (!currentAnnNo) {
        return;
    }

    fetch("/centralAdmin/announcement/" + currentAnnNo)
        .then(function (response) {
            if (!response.ok) {
                throw new Error("공고 수정 조회 실패");
            }
            return response.json();
        })
        .then(function (data) {
            formMode = "update";

            document.getElementById("f-ftitle").value = data.ttl || "";
            document.getElementById("f-fsite").value = data.aptCmplexNo || "";
            document.getElementById("f-pblanc-start").value = data.pblancBgngDt || "";
            document.getElementById("f-pblanc-end").value = data.pblancEndDt || "";
            document.getElementById("f-fstart").value = data.rcrtBgngDt || "";
            document.getElementById("f-fend").value = data.rcrtEndDt || "";
            document.getElementById("f-funit").value = data.unitCnt || "";
            document.getElementById("f-content").value = data.cn || "";

            document.getElementById("form-title").textContent = "입주자 모집 공고 수정";
            document.getElementById("form-submit-btn").innerHTML = '<span class="material-symbols-rounded">check</span>수정';

            closeModal();
            document.getElementById("form-modal").classList.remove("is-hidden");
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 수정 정보를 불러오지 못했습니다.");
        });
}

function deleteFromModal() {
    if (!currentAnnNo) {
        return;
    }

    if (!confirm("공고를 삭제하시겠습니까?")) {
        return;
    }

    fetch("/centralAdmin/announcement/" + currentAnnNo, {
        method: "DELETE",
        headers: getCsrfHeaders()
    })
        .then(function (response) {
            if (!response.ok) {
                throw new Error("공고 삭제 실패");
            }
            return response.json();
        })
        .then(function (data) {
            if (!data.success) {
                alert("공고 삭제에 실패했습니다.");
                return;
            }

            alert("공고가 삭제되었습니다.");
            closeModal();
            loadAnnouncementList();
        })
        .catch(function (error) {
            console.error(error);
            alert("공고 삭제 중 오류가 발생했습니다.");
        });
}

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