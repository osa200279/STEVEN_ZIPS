<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
    <title>차량등록 – 대덕아파트</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/apt/apt.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/resident/residentVhcl.css">

</head>
<body>
<%@ include file="/WEB-INF/views/include/apt_headerLayout.jsp" %>
<div class="main-shell">
    <%@ include file="/WEB-INF/views/include/apt_sidebarLayout.jsp" %>
    <main class="content-area">
        <div class="page-content-wrap">
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/">HOME</a>
                <span>›</span>
                <a href="javascript:void(0);">생활지원서비스</a>
                <span>›</span>
                <span class="cur">차량등록</span>
            </div>
            <h1 class="page-title">차량등록</h1>
            <p class="page-desc">차량 등록을 진행 하고, 등록 차량 목록을 확인할 수 있습니다.</p>
            <div style="display:flex; justify-content:flex-end; margin-bottom:16px;">
                <button class="btn-main" id="openModalBtn">
                    + 차량 등록
                </button>
            </div>
            <section>
                <div class="panel vhcl-table-wrap">
                    <div class="section-hd"><h3>등록한 차량 목록</h3><span>최근 등록</span></div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>동/호</th>
                                <th>차량번호</th>
                                <th>차종</th>
                                <th>등록일</th>
                                <th>상태</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div id="pagination" class="btn-row" style="margin-top:auto;"></div>
            </section>

        </div>
    </main>
</div>
<div class="modal-wrap" id="vhclModal">
    <div class="modal-box">

        <div class="modal-header">
            <h3>차량 등록</h3>
            <button class="close-btn" id="closeModalBtn">×</button>
        </div>

<div class="form-grid">

    <div class="th">차종</div>
    <div class="td">
        <input
                id="vhclNmData"
                class="fake-input"
                placeholder="ex) 현대 아반떼"
        />
    </div>

    <div class="th">차량번호</div>
    <div class="td">
        <div style="display:flex; gap:8px;">
            <input
                    id="vhclNoFront"
                    class="fake-input"
                    style="width:120px;"
                    placeholder="ex) 12가"
            />

            <input
                    id="vhclNoBack"
                    class="fake-input"
                    style="width:140px;"
                    maxlength="4"
                    placeholder="ex) 1234"
            />
        </div>

        <div class="field-guide">
            차량번호 형식 : 12가 1234
        </div>
    </div>

    <div class="th">동 / 호수</div>
    <div class="td">

        <select id="hoSelect" class="fake-input">
            <c:forEach var="apt" items="${aptList}">
                <option
                        value="${apt.ho}"
                        data-dong="${apt.dongNm}">
                    ${apt.dongNm}동 ${apt.ho}호
                </option>
            </c:forEach>
        </select>

    </div>

    <div class="th th-column">
        차량등록증
        <small>이미지 파일만 업로드 가능합니다</small>
    </div>

    <div class="td">

        <div id="uploadBox" class="upload-box">

            <input
                    type="file"
                    id="fileInput"
                    hidden
                    accept="image/*"
            >

            <!-- 기본 상태 -->
            <div class="upload-content">
                <div class="plus">+</div>

                <div class="text">
                    파일을 드래그하거나 클릭하여 업로드
                </div>
            </div>

            <!-- 썸네일 -->
            <div id="previewCard" class="preview-card">

                <img
                        id="previewImg"
                        class="preview-img"
                >

                <button
                        type="button"
                        id="removeBtn"
                        class="remove-btn">
                    ×
                </button>

            </div>

        </div>

    </div>

</div>

        <div class="btn-row">
            <button class="btn-main" id="registerBtn">
                차량 등록
            </button>
        </div>

    </div>
</div>
<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>
<script !src="">

    document.addEventListener("DOMContentLoaded", function () {
        loadMyVhcl();
    });

    let isSubmitting = false;

    const csrfToken = document.querySelector('meta[name="_csrf"]').content;
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;

    const registerBtn = document.querySelector("#registerBtn");
    const aptCmplexNo = "${aptCmplexNo}";
    const userNo = "${userNo}";

    const uploadBox = document.getElementById("uploadBox");
    const fileInput = document.getElementById("fileInput");
    const previewCard = document.getElementById("previewCard");
    const previewImg = document.getElementById("previewImg");
    const removeBtn = document.getElementById("removeBtn");
    const uploadContent = document.querySelector(".upload-content");

    const vhclModal = document.getElementById("vhclModal");

    document.getElementById("openModalBtn")
        .addEventListener("click", () => {
            vhclModal.classList.add("active");
        });

    document.getElementById("closeModalBtn")
        .addEventListener("click", () => {
            vhclModal.classList.remove("active");
        });

    vhclModal.addEventListener("click", (e) => {
        if(e.target === vhclModal){
            vhclModal.classList.remove("active");
        }
    });


    /*유효성체크*/
    function validateVhclNo(front, back) {

        const frontRegex = /^[0-9]{2,3}[가-힣]$/;
        const backRegex = /^[0-9]{4}$/;

        const frontInput = document.getElementById("vhclNoFront");
        const backInput = document.getElementById("vhclNoBack");

        let isValid = true;

        if (!frontRegex.test(front)) {
            isValid = false;
        }

        if (!backRegex.test(back)) {
            isValid = false;
        }

        if (!isValid) {
            alert("차량번호 형식을 확인하세요 (예: 12가 1234)");

            if (!frontRegex.test(front)) {
                highlightError(frontInput);
            }

            if (!backRegex.test(back)) {
                highlightError(backInput);
            }

            return false;
        }

        return true;
    }

    // 틀렸을시 강조해주는 함수
    function highlightError(el) {
        el.classList.add("input-error");

        setTimeout(() => {
            el.classList.remove("input-error");
        }, 800);
    }

    // 파일 선택
    uploadBox.addEventListener("click", () => {
        fileInput.click();
    });

    // 파일 선택
    fileInput.addEventListener("change", () => {
        const file = fileInput.files[0];
        if (!file) return;

        if (!file.type.startsWith("image/")) {
            alert("이미지만 업로드 가능");
            fileInput.value = "";
            return;
        }

        const reader = new FileReader();

        reader.onload = (e) => {
            previewImg.src = e.target.result;

            uploadContent.style.display = "none";
            previewCard.style.display = "flex";
        };

        reader.readAsDataURL(file);
    });

    removeBtn.addEventListener("click", (e) => {
        e.stopPropagation();

        fileInput.value = "";
        previewImg.src = "";

        previewCard.style.display = "none";
        uploadContent.style.display = "block";
    });

    uploadBox.addEventListener("dragover", (e) => {
        e.preventDefault();
        uploadBox.classList.add("dragover");
    });

    uploadBox.addEventListener("dragleave", () => {
        uploadBox.classList.remove("dragover");
    });

    uploadBox.addEventListener("drop", (e) => {
        e.preventDefault();
        uploadBox.classList.remove("dragover");

        const file = e.dataTransfer.files[0];

        if (!file) return;

        if (!validateFile(file)) return;

        fileInput.files = e.dataTransfer.files;
        imgPreview(fileInput, document.getElementById("uploadBox"));

    });

    function validateFile(file) {
        if (!file.type.startsWith("image/")) {
            alert("이미지 파일만 업로드 가능합니다");
            return false;
        }
        return true;
    }

    function imgPreview(file, previewDiv) {
        if (file.files && file.files[0]) {
            const reader = new FileReader();

            reader.onload = function (event) {
                previewDiv.innerHTML = `
                <img src='\${event.target.result}' class='preview-img'>
                `;
            };
            reader.readAsDataURL(file.files[0]);
        }
    }

    registerBtn.addEventListener("click", function () {

        if (isSubmitting) return;

        isSubmitting = true;
        registerBtn.disabled = true;
        registerBtn.innerText = "등록 중...";

        const hoSelect = document.getElementById("hoSelect");
        const selectedOption = hoSelect.options[hoSelect.selectedIndex];

        const formData = new FormData();
        formData.append("ho", hoSelect.value);
        formData.append("dong", selectedOption.dataset.dong);

        fetch("/vhcl/check/" + aptCmplexNo, {
            method: "POST",
            headers: {
                [csrfHeader]: csrfToken
            },
            body: formData
        })
            .then(res => res.text())
            .then(result => {

                if (result === "EXTRA_REQUIRED") {

                    if (!confirm("추가 차량 등록은 비용이 발생합니다. 진행하시겠습니까?")) {
                        resetButton();
                        return;
                    }

                    submitVhcl(true);

                } else {
                    submitVhcl(false);
                }
            })
            .catch(() => resetButton());
    });


    function loadMyVhcl() {

        fetch(`/vhcl/myVhcl/` + aptCmplexNo, {
            method: "GET",
            headers: {
                [csrfHeader]: csrfToken
            }
        })
            .then(res => {
                if (!res.ok) {
                    throw new Error("서버 오류: " + res.status);
                }
                return res.json();
            })
            .then(list => {
                let html = "";

                list.forEach(car => {
                    let badgeClass = "";
                    let statusText = "";

                    let hoNo = car.hoNo;
                    let parts = hoNo.split("_");

                    let dong = parts[1];
                    let ho = parts[2];

                    if (car.vhclSttsCd === 'APRV') {
                        badgeClass = "ok";
                        statusText = "승인";
                    } else if (car.vhclSttsCd === 'WAIT') {
                        badgeClass = "wait";
                        statusText = "승인대기";
                    } else {
                        badgeClass = "danger";
                        statusText = "반려";
                    }

                    html += `
                            <tr>
                                <td>\${dong}동 \${ho}호</td>
                                <td>\${car.vhclNo}</td>
                                <td>\${car.vhclNm}</td>
                                <td>\${car.regDt ? car.regDt.substring(0,10) : ''}</td>
                                <td>
                                    <span class="badge \${badgeClass}">\${statusText}</span>
                                </td>
                                <td>
                                    <span class="delete-text"
                                          data-vhcl-id="\${car.rsidVhclNo}">
                                        삭제
                                    </span>
                                </td>
                            </tr>
                            `;
                });

                document.querySelector(".data-table tbody").innerHTML = html;
            })
            .catch(err => {
                console.error(err);
                alert("차량 목록 불러오기 실패");
            });
    }

    function submitVhcl(isExtra) {

        const formData = new FormData();
        const vhclNm = document.getElementById("vhclNmData").value.trim();

        if (!vhclNm) {
            alert("차종을 입력해주세요.");

            const input = document.getElementById("vhclNmData");
            input.focus();
            highlightError(input);

            resetButton();
            return;
        }

        formData.append("vhclNm", vhclNm);

        const front = document.getElementById("vhclNoFront").value.trim();
        const back = document.getElementById("vhclNoBack").value.trim();
        if (!validateVhclNo(front, back)) {
            resetButton();
            return;
        }

        if (!fileInput.files[0]) {
            alert("차량등록증을 등록해주세요.");

            highlightError(uploadBox);

            resetButton();
            return;
        }

        const vhclNo = front + back;
        formData.append("vhclNo", vhclNo);

        const hoSelect = document.getElementById("hoSelect");
        const selectedOption = hoSelect.options[hoSelect.selectedIndex];

        formData.append("dong", selectedOption.dataset.dong);
        formData.append("ho", hoSelect.value);
        formData.append("isExtra", isExtra);

        if (fileInput.files[0]) {
            formData.append("file", fileInput.files[0]);
        }

        fetch("/vhcl/register/" + aptCmplexNo, {
            method: "POST",
            headers: {
                [csrfHeader]: csrfToken
            },
            body: formData
        })
            .then(res => {
                if (!res.ok) throw new Error("등록 실패");
                return res.text();
            })
            .then(() => {
                alert("등록 완료");
                vhclModal.classList.remove("active");
                resetForm();
                loadMyVhcl();
            })
            .catch(err => {
                alert(err.message);
            })
            .finally(() => {
                resetButton();
            });
    }

    function resetForm() {

        // 입력값 초기화
        document.getElementById("vhclNmData").value = "";
        document.getElementById("vhclNoFront").value = "";
        document.getElementById("vhclNoBack").value = "";

        // select 초기화
        const hoSelect = document.getElementById("hoSelect");
        hoSelect.selectedIndex = 0;

        // 파일 초기화
        fileInput.value = "";
        previewImg.src = "";

        // UI 복구
        previewCard.style.display = "none";
        uploadContent.style.display = "block";
    }


    function resetButton() {
        isSubmitting = false;
        registerBtn.disabled = false;
        registerBtn.innerText = "차량 등록";
    }

    document.querySelector(".data-table tbody").addEventListener("click", function(e) {
        if (e.target.classList.contains("delete-text")) {

            const rsidVhclNo = e.target.dataset.vhclId;

            if (!confirm("삭제하시겠습니까?")) return;

            deleteVhcl(rsidVhclNo);
        }
    });

    function deleteVhcl(rsidVhclNo) {
        console.log(rsidVhclNo)

        fetch(`/vhcl/delete/\${rsidVhclNo}`, {
            method: "DELETE",
            headers: {
                [csrfHeader]: csrfToken
            }
        })
            .then(res => {
                if (!res.ok) throw new Error("삭제 실패");
                return res.text();
            })
            .then(() => {
                alert("삭제 완료");
                loadMyVhcl(); // 다시 로드
            })
            .catch(err => {
                alert(err.message);
            });
    }


</script>
</body>
</html>