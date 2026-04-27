<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="residentMovePage">

  <div class="page-header">
    <div class="page-title-block">
      <h2>입주/퇴거 관리</h2>
      <p>세대별 입주 및 퇴거 내역을 조회하고 처리 상태를 관리합니다.</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-primary" data-action="openRegister">
        <span class="material-symbols-rounded">add</span>
        입주 등록
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
          <label class="field-label">입퇴거 상태</label>
          <select class="form-select" id="filterOccpSt">
            <option value="">전체</option>
            <option value="WAIT">입주대기</option>
            <option value="LIVE">입주</option>
            <option value="OUT">퇴거</option>
            <option value="MID">중도퇴거</option>
          </select>
        </div>

        <div class="form-field">
          <label class="field-label">세대주 여부</label>
          <select class="form-select" id="filterHeadYn">
            <option value="">전체</option>
            <option value="Y">세대주</option>
            <option value="N">세대원</option>
          </select>
        </div>

        <div class="form-field">
          <label class="field-label">동</label>
          <input type="text" class="form-input" id="filterDong" placeholder="예: 101동">
        </div>
      </div>

      <div class="form-row cols-3">
        <div class="form-field">
          <label class="field-label">호수</label>
          <input type="text" class="form-input" id="filterHo" placeholder="예: 1203호">
        </div>

        <div class="form-field">
          <label class="field-label">입주일 시작</label>
          <input type="date" class="form-input" id="filterStartDate">
        </div>

        <div class="form-field">
          <label class="field-label">입주일 종료</label>
          <input type="date" class="form-input" id="filterEndDate">
        </div>
      </div>

      <div class="form-row cols-1">
        <div class="form-field">
          <label class="field-label">검색어</label>
          <div class="input-with-btn">
            <input type="text" class="form-input" id="filterKeyword"
                   placeholder="입주민명, 연락처를 입력하세요.">
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
        <span class="material-symbols-rounded">list_alt</span>
        입주/퇴거 목록
      </h3>
      <span class="list-count" id="moveListCount">0건</span>
    </div>

    <div class="table-wrap">
      <table class="tbl" id="residentMoveTable">
        <thead>
        <tr>
          <th>상태</th>
          <th>동</th>
          <th>호수</th>
          <th>입주민명</th>
          <th>연락처</th>
          <th>세대주</th>
          <th>입주일</th>
          <th>퇴거일</th>
          <th style="width:120px;">관리</th>
        </tr>
        </thead>
        <tbody id="moveTableBody"></tbody>
      </table>
    </div>
  </div>

  <!-- 등록/상세/수정 모달 -->
  <div class="modal-overlay" id="residentMoveModal">
    <div class="modal modal-md">
      <div class="modal-header primary" id="residentMoveModalHeader">
        <h3 class="modal-title" id="residentMoveModalTitle">입주 등록</h3>
        <button type="button" class="modal-close" data-action="closeModal">
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>

      <form id="residentMoveForm">
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
          </div>

          <div class="form-section">
            <div class="form-section-title">
              <span class="material-symbols-rounded">person</span>
              입주민 정보
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">입주민명 <span class="req">*</span></label>
                <input type="text" class="form-input" name="residentName">
              </div>
              <div class="form-field">
                <label class="field-label">연락처</label>
                <input type="text" class="form-input" name="telno" placeholder="010-0000-0000">
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">세대주 여부</label>
                <select class="form-select" name="headYn">
                  <option value="Y">세대주</option>
                  <option value="N">세대원</option>
                </select>
              </div>
              <div class="form-field">
                <label class="field-label">입퇴거 상태 <span class="req">*</span></label>
                <select class="form-select" name="occpSt">
                  <option value="WAIT">입주대기</option>
                  <option value="LIVE">입주</option>
                  <option value="OUT">퇴거</option>
                  <option value="MID">중도퇴거</option>
                </select>
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">입주일</label>
                <input type="date" class="form-input" name="moveInDt">
              </div>
              <div class="form-field">
                <label class="field-label">퇴거일</label>
                <input type="date" class="form-input" name="moveOutDt">
              </div>
            </div>
          </div>

        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
          <button type="button" class="btn btn-primary" id="residentMoveEditBtn"
                  data-action="changeToEdit" style="display:none;">수정하기</button>
          <button type="submit" class="btn btn-primary" id="residentMoveSaveBtn">저장</button>
        </div>
      </form>
    </div>
  </div>

</div>

<script>
  (function () {
    var page = document.getElementById("residentMovePage");
    if (!page || page.dataset.bound === "true") return;
    page.dataset.bound = "true";

    var modal     = document.getElementById("residentMoveModal");
    var form      = document.getElementById("residentMoveForm");
    var modalTitle = document.getElementById("residentMoveModalTitle");
    var saveBtn   = document.getElementById("residentMoveSaveBtn");
    var editBtn   = document.getElementById("residentMoveEditBtn");
    var tbody     = document.getElementById("moveTableBody");

    /* ───────── 더미 데이터 ───────── */
    var rowData = [
      {
        dong: "101동", ho: "1203호", residentName: "김민준",
        telno: "010-1234-5678", headYn: "Y", occpSt: "LIVE",
        moveInDt: "2026-05-14", moveOutDt: ""
      },
      {
        dong: "102동", ho: "803호", residentName: "이서연",
        telno: "010-9876-5432", headYn: "N", occpSt: "OUT",
        moveInDt: "2024-03-01", moveOutDt: "2026-05-20"
      }
    ];

    /* ───────── 코드 → 텍스트/뱃지 ───────── */
    var OCCP_ST_TEXT = { WAIT: "입주대기", LIVE: "입주", OUT: "퇴거", MID: "중도퇴거" };
    var OCCP_ST_BADGE = {
      WAIT: "badge-yellow",
      LIVE: "badge-green",
      OUT:  "badge-gray",
      MID:  "badge-red"
    };

    function occpBadge(code) {
      return '<span class="badge ' + (OCCP_ST_BADGE[code] || "badge-gray") + '">'
              + (OCCP_ST_TEXT[code] || "-") + '</span>';
    }

    function headBadge(yn) {
      return yn === "Y"
              ? '<span class="badge badge-blue">세대주</span>'
              : '<span class="badge badge-gray">세대원</span>';
    }

    /* ───────── 목록 렌더 ───────── */
    function renderTable(data) {
      document.getElementById("moveListCount").textContent = data.length + "건";

      if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="9" style="text-align:center; color:var(--text-tertiary);">조회된 내역이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(function (row, idx) {
        return '<tr>'
                + '<td>' + occpBadge(row.occpSt) + '</td>'
                + '<td>' + row.dong + '</td>'
                + '<td>' + row.ho + '</td>'
                + '<td class="td-bold">' + row.residentName + '</td>'
                + '<td>' + (row.telno || "-") + '</td>'
                + '<td>' + headBadge(row.headYn) + '</td>'
                + '<td>' + (row.moveInDt || "-") + '</td>'
                + '<td>' + (row.moveOutDt || "-") + '</td>'
                + '<td><div class="grid-actions">'
                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + idx + '">상세</button>'
                + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + idx + '">수정</button>'
                + '</div></td>'
                + '</tr>';
      }).join("");
    }

    /* ───────── 필터 ───────── */
    function getFiltered() {
      var occpSt    = document.getElementById("filterOccpSt").value;
      var headYn    = document.getElementById("filterHeadYn").value;
      var dong      = document.getElementById("filterDong").value.trim();
      var ho        = document.getElementById("filterHo").value.trim();
      var startDate = document.getElementById("filterStartDate").value;
      var endDate   = document.getElementById("filterEndDate").value;
      var keyword   = document.getElementById("filterKeyword").value.trim();

      return rowData.filter(function (row) {
        return (!occpSt    || row.occpSt === occpSt)
                && (!headYn    || row.headYn === headYn)
                && (!dong      || row.dong.indexOf(dong) > -1)
                && (!ho        || row.ho.indexOf(ho) > -1)
                && (!startDate || row.moveInDt >= startDate)
                && (!endDate   || row.moveInDt <= endDate)
                && (!keyword   || row.residentName.indexOf(keyword) > -1
                        || row.telno.indexOf(keyword) > -1);
      });
    }

    function resetFilter() {
      ["filterOccpSt","filterHeadYn","filterDong","filterHo",
        "filterStartDate","filterEndDate","filterKeyword"]
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
        modalTitle.textContent = "입주 등록";
      }

      if (mode === "detail" && idx !== undefined) {
        modalTitle.textContent = "입주/퇴거 상세";
        fillForm(rowData[idx]);
        setFormDisabled(true);
        saveBtn.style.display = "none";
        editBtn.style.display = "inline-flex";
        editBtn.dataset.idx   = idx;
      }

      if (mode === "edit" && idx !== undefined) {
        modalTitle.textContent = "입주/퇴거 수정";
        fillForm(rowData[idx]);
      }

      modal.classList.add("open");
    }

    function fillForm(row) {
      form.dong.value         = row.dong        || "";
      form.ho.value           = row.ho          || "";
      form.residentName.value = row.residentName || "";
      form.telno.value        = row.telno       || "";
      form.headYn.value       = row.headYn      || "Y";
      form.occpSt.value       = row.occpSt      || "WAIT";
      form.moveInDt.value     = row.moveInDt    || "";
      form.moveOutDt.value    = row.moveOutDt   || "";
    }

    function setFormDisabled(disabled) {
      form.querySelectorAll("input, select").forEach(function (el) {
        el.disabled = disabled;
      });
    }

    function closeModal() {
      modal.classList.remove("open");
    }

    /* ───────── 이벤트 ───────── */
    page.addEventListener("click", function (e) {
      var btn = e.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;
      var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

      if (action === "openRegister") openModal("register");
      if (action === "detail")       openModal("detail", idx);
      if (action === "edit")         openModal("edit", idx);
      if (action === "changeToEdit") openModal("edit", Number(editBtn.dataset.idx));
      if (action === "closeModal")   closeModal();
      if (action === "search")       renderTable(getFiltered());
      if (action === "resetFilter")  resetFilter();
    });

    modal.addEventListener("click", function (e) {
      if (e.target === modal) closeModal();
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
