<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="residentCarPage">

  <div class="page-header">
    <div class="page-title-block">
      <h2>방문 차량 관리</h2>
      <p>세대별 방문 차량 정보를 조회하고 관리합니다.</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-primary" data-action="openRegister">
        <span class="material-symbols-rounded">add</span>
        차량 등록
      </button>
    </div>
  </div>

  <!-- 검색조건 -->
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
          <label class="field-label">차량 유형</label>
          <select class="form-select" id="filterVhclTy">
            <option value="">전체</option>
            <option value="GEN">일반방문</option>
            <option value="WRK">업무/공사</option>
            <option value="DLV">배달/택배</option>
            <option value="MOV">이사차량</option>
            <option value="EMG">긴급/공용</option>
          </select>
        </div>

        <div class="form-field">
          <label class="field-label">동</label>
          <input type="text" class="form-input" id="filterDong" placeholder="예: 101동">
        </div>

        <div class="form-field">
          <label class="field-label">호수</label>
          <input type="text" class="form-input" id="filterHo" placeholder="예: 1203호">
        </div>
      </div>

      <div class="form-row cols-1">
        <div class="form-field">
          <label class="field-label">검색어</label>
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

  <!-- 목록 -->
  <div class="panel">
    <div class="panel-header">
      <h3 class="panel-title">
        <span class="material-symbols-rounded">directions_car</span>
        등록 차량 목록
      </h3>
      <span class="list-count" id="carListCount">0건</span>
    </div>

    <div class="table-wrap">
      <table class="tbl">
        <thead>
        <tr>
          <th>동</th>
          <th>호수</th>
          <th>입주민명</th>
          <th>차량유형</th>
          <th>차량명</th>
          <th>차량번호</th>
          <th style="width:120px;">관리</th>
        </tr>
        </thead>
        <tbody id="carTableBody"></tbody>
      </table>
    </div>
  </div>

  <!-- 등록/상세/수정 모달 -->
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
                <label class="field-label">차량 유형 <span class="req">*</span></label>
                <select class="form-select" name="vstVhclTyCd">
                  <option value="GEN">일반방문</option>
                  <option value="WRK">업무/공사</option>
                  <option value="DLV">배달/택배</option>
                  <option value="MOV">이사차량</option>
                  <option value="EMG">긴급/공용</option>
                </select>
              </div>
              <div class="form-field">
                <label class="field-label">차량번호 <span class="req">*</span></label>
                <input type="text" class="form-input" name="vhclNo" placeholder="예: 12가 3456">
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">차량명</label>
                <input type="text" class="form-input" name="vhclNm" placeholder="예: 현대 아반떼">
              </div>
            </div>
          </div>

        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
          <button type="button" class="btn btn-primary" id="carEditBtn"
                  data-action="changeToEdit" style="display:none;">수정하기</button>
          <button type="submit" class="btn btn-primary" id="carSaveBtn">저장</button>
        </div>
      </form>
    </div>
  </div>

  <!-- 삭제 확인 모달 -->
  <div class="modal-overlay" id="carDeleteModal">
    <div class="modal modal-sm">
      <div class="modal-header primary">
        <h3 class="modal-title">차량 등록 삭제</h3>
        <button type="button" class="modal-close" data-action="closeDeleteModal">
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>
      <div class="modal-body">
        <div style="display:flex; gap:10px; padding:14px 16px; background:#fff0f0; border:1px solid #e0a8a8; border-radius:8px; margin-bottom:16px;">
          <span class="material-symbols-rounded" style="color:#991b1b; font-size:20px; flex-shrink:0; margin-top:1px;">warning</span>
          <div style="font-size:13px; color:#7f1d1d; line-height:1.6;">
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

<script>
  (function () {
    var page = document.getElementById("residentCarPage");
    if (!page || page.dataset.bound === "true") return;
    page.dataset.bound = "true";

    var modal       = document.getElementById("residentCarModal");
    var deleteModal = document.getElementById("carDeleteModal");
    var form        = document.getElementById("residentCarForm");
    var modalTitle  = document.getElementById("residentCarModalTitle");
    var saveBtn     = document.getElementById("carSaveBtn");
    var editBtn     = document.getElementById("carEditBtn");
    var tbody       = document.getElementById("carTableBody");

    /* ───────── 더미 데이터 ───────── */
    var rowData = [
      {
        rsidVhclNo: "V001", dong: "101동", ho: "1203호",
        userNm: "김민준", vstVhclTyCd: "GEN",
        vhclNm: "현대 아반떼", vhclNo: "12가 3456"
      },
      {
        rsidVhclNo: "V002", dong: "102동", ho: "803호",
        userNm: "이서연", vstVhclTyCd: "GEN",
        vhclNm: "기아 K5", vhclNo: "34나 7890"
      }
    ];

    var deleteTargetIdx = null;

    /* ───────── 코드 변환 ───────── */
    var VHCL_TY_TEXT = {
      GEN: "일반방문", WRK: "업무/공사",
      DLV: "배달/택배", MOV: "이사차량", EMG: "긴급/공용"
    };
    var VHCL_TY_BADGE = {
      GEN: "badge-gray",  WRK: "badge-blue",
      DLV: "badge-yellow", MOV: "badge-green", EMG: "badge-red"
    };

    function vhclBadge(code) {
      return '<span class="badge ' + (VHCL_TY_BADGE[code] || "badge-gray") + '">'
              + (VHCL_TY_TEXT[code] || "-") + '</span>';
    }

    /* ───────── 목록 렌더 ───────── */
    function renderTable(data) {
      document.getElementById("carListCount").textContent = data.length + "건";

      if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center; color:var(--text-tertiary);">등록된 차량이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(function (row, idx) {
        return '<tr>'
                + '<td>' + row.dong + '</td>'
                + '<td>' + row.ho + '</td>'
                + '<td class="td-bold">' + row.userNm + '</td>'
                + '<td>' + vhclBadge(row.vstVhclTyCd) + '</td>'
                + '<td>' + (row.vhclNm || "-") + '</td>'
                + '<td class="td-mono">' + row.vhclNo + '</td>'
                + '<td><div class="grid-actions">'
                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + idx + '">상세</button>'
                + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + idx + '">수정</button>'
                + '<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="' + idx + '">삭제</button>'
                + '</div></td>'
                + '</tr>';
      }).join("");
    }

    /* ───────── 필터 ───────── */
    function getFiltered() {
      var vhclTy  = document.getElementById("filterVhclTy").value;
      var dong    = document.getElementById("filterDong").value.trim();
      var ho      = document.getElementById("filterHo").value.trim();
      var keyword = document.getElementById("filterKeyword").value.trim();

      return rowData.filter(function (row) {
        return (!vhclTy  || row.vstVhclTyCd === vhclTy)
                && (!dong    || row.dong.indexOf(dong) > -1)
                && (!ho      || row.ho.indexOf(ho) > -1)
                && (!keyword || row.userNm.indexOf(keyword) > -1
                        || row.vhclNo.indexOf(keyword) > -1
                        || (row.vhclNm || "").indexOf(keyword) > -1);
      });
    }

    function resetFilter() {
      ["filterVhclTy","filterDong","filterHo","filterKeyword"]
              .forEach(function(id){ document.getElementById(id).value = ""; });
      renderTable(rowData);
    }

    /* ───────── 모달 ───────── */
    function openModal(mode, idx) {
      form.reset();
      saveBtn.style.display = "inline-flex";
      editBtn.style.display = "none";
      setFormDisabled(false);

      if (mode === "register") {
        modalTitle.textContent = "차량 등록";
      }

      if (mode === "detail" && idx !== undefined) {
        modalTitle.textContent = "차량 상세";
        fillForm(rowData[idx]);
        setFormDisabled(true);
        saveBtn.style.display = "none";
        editBtn.style.display = "inline-flex";
        editBtn.dataset.idx   = idx;
      }

      if (mode === "edit" && idx !== undefined) {
        modalTitle.textContent = "차량 수정";
        fillForm(rowData[idx]);
      }

      modal.classList.add("open");
    }

    function fillForm(row) {
      form.dong.value        = row.dong          || "";
      form.ho.value          = row.ho            || "";
      form.userNm.value      = row.userNm        || "";
      form.vstVhclTyCd.value = row.vstVhclTyCd   || "GEN";
      form.vhclNo.value      = row.vhclNo        || "";
      form.vhclNm.value      = row.vhclNm        || "";
    }

    function setFormDisabled(disabled) {
      form.querySelectorAll("input, select").forEach(function (el) {
        el.disabled = disabled;
      });
    }

    function closeModal() {
      modal.classList.remove("open");
    }

    /* ───────── 삭제 모달 ───────── */
    function openDeleteModal(idx) {
      deleteTargetIdx = idx;
      var row = rowData[idx];

      document.getElementById("deleteTargetInfo").innerHTML =
              '<div class="mngr-detail-item"><div class="mngr-detail-label">입주민</div><div class="mngr-detail-value">' + row.userNm + '</div></div>'
              + '<div class="mngr-detail-item"><div class="mngr-detail-label">세대</div><div class="mngr-detail-value">' + row.dong + ' ' + row.ho + '</div></div>'
              + '<div class="mngr-detail-item"><div class="mngr-detail-label">차량번호</div><div class="mngr-detail-value">' + row.vhclNo + '</div></div>'
              + '<div class="mngr-detail-item"><div class="mngr-detail-label">차량명</div><div class="mngr-detail-value">' + (row.vhclNm || "-") + '</div></div>';

      deleteModal.classList.add("open");
    }

    function closeDeleteModal() {
      deleteModal.classList.remove("open");
      deleteTargetIdx = null;
    }

    /* ───────── 이벤트 ───────── */
    page.addEventListener("click", function (e) {
      var btn = e.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;
      var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

      if (action === "openRegister")  openModal("register");
      if (action === "detail")        openModal("detail", idx);
      if (action === "edit")          openModal("edit", idx);
      if (action === "changeToEdit")  openModal("edit", Number(editBtn.dataset.idx));
      if (action === "closeModal")    closeModal();
      if (action === "delete")        openDeleteModal(idx);
      if (action === "closeDeleteModal") closeDeleteModal();
      if (action === "search")        renderTable(getFiltered());
      if (action === "resetFilter")   resetFilter();
    });

    document.getElementById("carDeleteConfirmBtn").addEventListener("click", function () {
      if (deleteTargetIdx === null) return;
      rowData.splice(deleteTargetIdx, 1);
      renderTable(rowData);
      closeDeleteModal();
      alert("삭제되었습니다.");
    });

    modal.addEventListener("click", function (e) {
      if (e.target === modal) closeModal();
    });

    deleteModal.addEventListener("click", function (e) {
      if (e.target === deleteModal) closeDeleteModal();
    });

    form.addEventListener("submit", function (e) {
      e.preventDefault();
      alert("저장 처리 연결 예정입니다.");
      closeModal();
    });

    /* ───────── 초기 렌더 ───────── */
    renderTable(rowData);
  })();
</script>
