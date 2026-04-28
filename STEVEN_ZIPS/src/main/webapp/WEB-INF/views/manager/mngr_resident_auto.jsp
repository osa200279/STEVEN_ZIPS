<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>입주민 차량 관리</title>

  <!-- 공통 폰트 / 아이콘 -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

  <!-- 공통 레이아웃 / 관리사무소 공통 스타일 -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/office-layout.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/manager/manager-common.css">

  <style>
    .resident-car-col-dong{width:10%} .resident-car-col-ho{width:12%} .resident-car-col-resident{width:18%} .resident-car-col-name{width:20%} .resident-car-col-number{width:20%} .resident-car-col-action{width:150px}

    #residentCarPage .tbl-fixed th,#residentCarPage .tbl-fixed td{text-align:center!important;vertical-align:middle}
    #residentCarPage .grid-actions{display:inline-flex;align-items:center;justify-content:center;gap:8px;white-space:nowrap}
    #residentCarPage .td-bold,#residentCarPage .td-mono{text-align:center!important}

    .resident-car-empty{text-align:center;color:var(--text-tertiary)}
    .delete-warning-box{display:flex;gap:10px;padding:14px 16px;margin-bottom:16px;background:#fff0f0;border:1px solid #e0a8a8;border-radius:8px}
    .delete-warning-icon{color:#991b1b;font-size:20px;flex-shrink:0;margin-top:1px}
    .delete-warning-text{font-size:13px;color:#7f1d1d;line-height:1.6}
  </style>
</head>

<body>
<div class="app-wrapper">
  <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

  <div class="main-wrap">
    <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

    <main class="main-content">
      <div class="office-page" id="residentCarPage">

        <div class="page-header">
          <div class="page-title-block">
            <h2>입주민 차량 관리</h2>
            <p>세대별 등록 차량 정보를 조회하고 관리합니다.</p>
          </div>

          <div class="page-actions">
            <button type="button" class="btn btn-primary" data-action="openRegister">
              <span class="material-symbols-rounded">add</span>
              차량 등록
            </button>
          </div>
        </div>

        <!-- 검색 조건 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">manage_search</span>
              검색 조건
            </h3>
          </div>

          <div class="panel-body">
            <div class="form-row cols-3">
              <div class="form-field">
                <label class="field-label" for="filterDong">동</label>
                <input type="text" class="form-input" id="filterDong" placeholder="예: 101동">
              </div>

              <div class="form-field">
                <label class="field-label" for="filterHo">호수</label>
                <input type="text" class="form-input" id="filterHo" placeholder="예: 1203호">
              </div>

              <div class="form-field">
                <label class="field-label" for="filterKeyword">검색어</label>
                <div class="input-with-btn">
                  <input type="text" class="form-input" id="filterKeyword"
                         placeholder="입주민명, 차량번호, 차량명 검색">
                  <button type="button" class="btn btn-primary" data-action="search">검색</button>
                  <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 등록 차량 목록 -->
        <div class="panel">
          <div class="panel-header">
            <h3 class="panel-title">
              <span class="material-symbols-rounded">directions_car</span>
              등록 차량 목록
            </h3>
            <span class="list-count" id="carListCount">0건</span>
          </div>

          <div class="table-wrap">
            <table class="tbl tbl-fixed">
              <colgroup>
                <col class="resident-car-col-dong">
                <col class="resident-car-col-ho">
                <col class="resident-car-col-resident">
                <col class="resident-car-col-name">
                <col class="resident-car-col-number">
                <col class="resident-car-col-action">
              </colgroup>
              <thead>
              <tr>
                <th>동</th>
                <th>호수</th>
                <th>입주민명</th>
                <th>차량명</th>
                <th>차량번호</th>
                <th>관리</th>
              </tr>
              </thead>
              <tbody id="carTableBody"></tbody>
            </table>
          </div>
        </div>

        <!-- 등록 / 상세 / 수정 모달 -->
        <div class="modal-overlay" id="residentCarModal">
          <div class="modal modal-md">
            <div class="modal-header primary">
              <h3 class="modal-title" id="residentCarModalTitle">차량 등록</h3>
              <button type="button" class="modal-close" data-action="closeModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <form id="residentCarForm">
              <div class="modal-body">

                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">home</span>
                    세대 정보
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">동 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="dong" placeholder="예: 101동">
                    </div>

                    <div class="form-field">
                      <label class="field-label">호수 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="ho" placeholder="예: 1203호">
                    </div>
                  </div>

                  <div class="form-row cols-1">
                    <div class="form-field">
                      <label class="field-label">입주민명 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="userNm">
                    </div>
                  </div>
                </div>

                <div class="form-section">
                  <div class="form-section-title">
                    <span class="material-symbols-rounded">directions_car</span>
                    차량 정보
                  </div>

                  <div class="form-row cols-2">
                    <div class="form-field">
                      <label class="field-label">차량번호 <span class="req">*</span></label>
                      <input type="text" class="form-input" name="vhclNo" placeholder="예: 12가 3456">
                    </div>

                    <div class="form-field">
                      <label class="field-label" >차량명</label>
                      <input type="text" class="form-input input-center" name="vhclNm" placeholder="예: 현대 아반떼">
                    </div>
                  </div>
                </div>

              </div>

              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
                <button type="button" class="btn btn-primary" id="carEditBtn" data-action="changeToEdit">
                  수정하기
                </button>
                <button type="submit" class="btn btn-primary" id="carSaveBtn">저장</button>
              </div>
            </form>
          </div>
        </div>

        <!-- 삭제 확인 모달 -->
        <div class="modal-overlay" id="carDeleteModal">
          <div class="modal modal-sm">
            <div class="modal-header primary">
              <h3 class="modal-title">차량 삭제</h3>
              <button type="button" class="modal-close" data-action="closeDeleteModal">
                <span class="material-symbols-rounded">close</span>
              </button>
            </div>

            <div class="modal-body">
              <div class="delete-warning-box">
                <span class="material-symbols-rounded delete-warning-icon">warning</span>
                <div class="delete-warning-text">
                  선택한 차량 등록 정보를 삭제하시겠습니까?<br>
                  삭제 후에는 복구할 수 없습니다.
                </div>
              </div>

              <div class="mngr-detail-grid" id="deleteTargetInfo"></div>
            </div>

            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
              <button type="button" class="btn btn-danger" id="carDeleteConfirmBtn">삭제</button>
            </div>
          </div>
        </div>

      </div>
    </main>
  </div>
</div>

<script>
  (function () {
    var page = document.getElementById("residentCarPage");
    if (!page || page.dataset.bound === "true") return;
    page.dataset.bound = "true";

    var carModal = document.getElementById("residentCarModal");
    var deleteModal = document.getElementById("carDeleteModal");
    var form = document.getElementById("residentCarForm");
    var tbody = document.getElementById("carTableBody");
    var modalTitle = document.getElementById("residentCarModalTitle");
    var saveBtn = document.getElementById("carSaveBtn");
    var editBtn = document.getElementById("carEditBtn");
    var deleteConfirmBtn = document.getElementById("carDeleteConfirmBtn");

    var carList = [
      {
        rsidVhclNo: "V001",
        dong: "101동",
        ho: "1203호",
        userNm: "김민준",
        vhclNm: "현대 아반떼",
        vhclNo: "12가 3456"
      },
      {
        rsidVhclNo: "V002",
        dong: "102동",
        ho: "803호",
        userNm: "이서연",
        vhclNm: "기아 K5",
        vhclNo: "34나 7890"
      }
    ];

    var currentMode = "register";
    var currentIdx = null;
    var deleteIdx = null;

    function renderTable(list) {
      document.getElementById("carListCount").textContent = list.length + "건";

      if (list.length === 0) {
        tbody.innerHTML =
                '<tr>' +
                '<td colspan="6" class="resident-car-empty">등록된 차량이 없습니다.</td>' +
                '</tr>';
        return;
      }

      tbody.innerHTML = list.map(function (row, idx) {
        return ''
                + '<tr>'
                + '  <td>' + row.dong + '</td>'
                + '  <td>' + row.ho + '</td>'
                + '  <td class="td-bold">' + row.userNm + '</td>'
                + '  <td>' + (row.vhclNm || "-") + '</td>'
                + '  <td class="td-mono">' + row.vhclNo + '</td>'
                + '  <td>'
                + '    <div class="grid-actions">'
                + '      <button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + idx + '">상세</button>'
                + '      <button type="button" class="btn btn-xs btn-edit" data-action="edit" data-idx="' + idx + '">수정</button>'
                + '      <button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="' + idx + '">삭제</button>'
                + '    </div>'
                + '  </td>'
                + '</tr>';
      }).join("");
    }

    function getFilteredList() {
      var dong = document.getElementById("filterDong").value.trim();
      var ho = document.getElementById("filterHo").value.trim();
      var keyword = document.getElementById("filterKeyword").value.trim();

      return carList.filter(function (row) {
        var matchDong = !dong || row.dong.indexOf(dong) > -1;
        var matchHo = !ho || row.ho.indexOf(ho) > -1;
        var matchKeyword = !keyword
                || row.userNm.indexOf(keyword) > -1
                || row.vhclNo.indexOf(keyword) > -1
                || (row.vhclNm || "").indexOf(keyword) > -1;

        return matchDong && matchHo && matchKeyword;
      });
    }

    function resetFilter() {
      document.getElementById("filterDong").value = "";
      document.getElementById("filterHo").value = "";
      document.getElementById("filterKeyword").value = "";
      renderTable(carList);
    }

    function openCarModal(mode, idx) {
      currentMode = mode;
      currentIdx = idx == null ? null : Number(idx);

      form.reset();
      setFormDisabled(false);
      saveBtn.style.display = "inline-flex";
      editBtn.style.display = "none";

      if (mode === "register") {
        modalTitle.textContent = "차량 등록";
      }

      if (mode === "detail") {
        modalTitle.textContent = "차량 상세";
        fillForm(carList[currentIdx]);
        setFormDisabled(true);
        saveBtn.style.display = "none";
        editBtn.style.display = "inline-flex";
      }

      if (mode === "edit") {
        modalTitle.textContent = "차량 수정";
        fillForm(carList[currentIdx]);
      }

      carModal.classList.add("open");
    }

    function closeCarModal() {
      carModal.classList.remove("open");
    }

    function fillForm(row) {
      form.dong.value = row.dong || "";
      form.ho.value = row.ho || "";
      form.userNm.value = row.userNm || "";
      form.vhclNo.value = row.vhclNo || "";
      form.vhclNm.value = row.vhclNm || "";
    }

    function setFormDisabled(disabled) {
      form.querySelectorAll("input").forEach(function (input) {
        input.disabled = disabled;
      });
    }

    function openDeleteModal(idx) {
      deleteIdx = Number(idx);

      var row = carList[deleteIdx];
      document.getElementById("deleteTargetInfo").innerHTML = ''
              + '<div class="mngr-detail-item">'
              + '  <div class="mngr-detail-label">입주민</div>'
              + '  <div class="mngr-detail-value">' + row.userNm + '</div>'
              + '</div>'
              + '<div class="mngr-detail-item">'
              + '  <div class="mngr-detail-label">세대</div>'
              + '  <div class="mngr-detail-value">' + row.dong + ' ' + row.ho + '</div>'
              + '</div>'
              + '<div class="mngr-detail-item">'
              + '  <div class="mngr-detail-label">차량번호</div>'
              + '  <div class="mngr-detail-value">' + row.vhclNo + '</div>'
              + '</div>'
              + '<div class="mngr-detail-item">'
              + '  <div class="mngr-detail-label">차량명</div>'
              + '  <div class="mngr-detail-value">' + (row.vhclNm || "-") + '</div>'
              + '</div>';

      deleteModal.classList.add("open");
    }

    function closeDeleteModal() {
      deleteModal.classList.remove("open");
      deleteIdx = null;
    }

    page.addEventListener("click", function (event) {
      var btn = event.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;
      var idx = btn.dataset.idx;

      if (action === "openRegister") openCarModal("register");
      if (action === "detail") openCarModal("detail", idx);
      if (action === "edit") openCarModal("edit", idx);
      if (action === "changeToEdit") openCarModal("edit", currentIdx);
      if (action === "delete") openDeleteModal(idx);

      if (action === "search") renderTable(getFilteredList());
      if (action === "resetFilter") resetFilter();

      if (action === "closeModal") closeCarModal();
      if (action === "closeDeleteModal") closeDeleteModal();
    });

    form.addEventListener("submit", function (event) {
      event.preventDefault();

      alert("저장 처리 연결 예정입니다.");
      closeCarModal();
    });

    deleteConfirmBtn.addEventListener("click", function () {
      if (deleteIdx === null) return;

      carList.splice(deleteIdx, 1);
      renderTable(carList);
      closeDeleteModal();

      alert("삭제되었습니다.");
    });

    carModal.addEventListener("click", function (event) {
      if (event.target === carModal) closeCarModal();
    });

    deleteModal.addEventListener("click", function (event) {
      if (event.target === deleteModal) closeDeleteModal();
    });

    renderTable(carList);
  })();
</script>

</body>
</html>