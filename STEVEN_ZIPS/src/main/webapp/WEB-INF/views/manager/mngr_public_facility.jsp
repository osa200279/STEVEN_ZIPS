<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="office-page" id="publicFacilityPage">

  <div class="page-header">
    <div class="page-title-block">
      <h2>공용 시설 관리</h2>
      <p>단지 내 공용 시설 정보를 등록·수정·조회합니다.</p>
    </div>
    <div class="page-actions">
      <button type="button" class="btn btn-primary" data-action="openRegister">
        <span class="material-symbols-rounded">add</span>
        시설 등록
      </button>
    </div>
  </div>

  <!-- 통계 (SM-005: 공용시설수 / 예약가능 / 오늘예약) -->
  <div class="stat-row" style="grid-template-columns:repeat(3,minmax(0,1fr));">
    <div class="stat-card" style="background:#2e5c38; border-color:#264e30;">
      <div>
        <div style="font-size:12px; color:rgba(255,255,255,0.7); margin-bottom:4px;">공용 시설 수</div>
        <div style="font-size:28px; font-weight:800; color:#fff;" id="statTotal">0</div>
        <div style="font-size:11px; color:rgba(255,255,255,0.55); margin-top:2px;">PUBLIC_FACILITY</div>
      </div>
    </div>
    <div class="stat-card">
      <div>
        <div style="font-size:12px; color:var(--text-tertiary); margin-bottom:4px;">예약 가능 시설</div>
        <div style="font-size:28px; font-weight:800; color:var(--text-primary);" id="statRsvY">0</div>
        <div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">예약 가능 기준</div>
      </div>
    </div>
    <div class="stat-card">
      <div>
        <div style="font-size:12px; color:var(--text-tertiary); margin-bottom:4px;">오늘 예약 건수</div>
        <div style="font-size:28px; font-weight:800; color:var(--text-primary);" id="statToday">0</div>
        <div style="font-size:11px; color:var(--text-tertiary); margin-top:2px;">예약 이력 기준</div>
      </div>
    </div>
  </div>

  <!-- 필터 + 목록 -->
  <div class="panel">
    <div class="filter-bar">
      <div class="search-wrap" style="width:220px;">
        <span class="material-symbols-rounded">search</span>
        <input type="text" class="form-input" id="filterKeyword" placeholder="시설명 검색">
      </div>

      <select class="form-select" id="filterRsvYn" style="width:140px;">
        <option value="">예약 가능 전체</option>
        <option value="Y">예약 가능</option>
        <option value="N">예약 불가</option>
      </select>

      <button type="button" class="btn btn-primary"   data-action="search">검색</button>
      <button type="button" class="btn btn-secondary" data-action="resetFilter">초기화</button>
    </div>

    <div class="panel-header">
      <h3 class="panel-title">
        <span class="material-symbols-rounded">meeting_room</span>
        공용 시설 목록
      </h3>
      <span class="list-count" id="facilityListCount">0건</span>
    </div>

    <div class="table-wrap">
      <table class="tbl">
        <thead>
        <tr>
          <th>시설번호</th>
          <th>시설명</th>
          <th>예약 가능</th>
          <th>운영시간</th>
          <th>이용 비용</th>
          <th style="width:120px;">관리</th>
        </tr>
        </thead>
        <tbody id="facilityTableBody"></tbody>
      </table>
    </div>
  </div>

  <!-- 등록/수정 모달 -->
  <div class="modal-overlay" id="publicFacilityModal">
    <div class="modal modal-md">
      <div class="modal-header primary">
        <h3 class="modal-title" id="modalTitle">공용 시설 등록</h3>
        <button type="button" class="modal-close" data-action="closeModal">
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>

      <form id="facilityForm">
        <input type="hidden" id="cmnFacilityNo">

        <div class="modal-body">
          <div class="form-section">
            <div class="form-section-title">
              <span class="material-symbols-rounded">meeting_room</span>
              시설 기본 정보
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">시설명 (CMN_FACILITY_NM) <span class="req">*</span></label>
                <input type="text" class="form-input" id="cmnFacilityNm" placeholder="예: 헬스장">
              </div>
            </div>

            <div class="form-row cols-2">
              <div class="form-field">
                <label class="field-label">예약 가능 여부 (CMN_FACILITY_RSV_YN)</label>
                <select class="form-select" id="cmnFacilityRsvYn">
                  <option value="Y">예약 가능</option>
                  <option value="N">예약 불가</option>
                </select>
              </div>
              <div class="form-field">
                <label class="field-label">이용 비용 (CMN_FACILITY_AMT)</label>
                <input type="number" class="form-input" id="cmnFacilityAmt" placeholder="0 (무료 시 0)">
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">운영시간 (CMN_FACILITY_OPR_HR)</label>
                <input type="text" class="form-input" id="cmnFacilityOprHr" placeholder="예: 06:00~22:00">
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">시설 안내 (CMN_FACILITY_CN)</label>
                <textarea class="form-textarea" id="cmnFacilityCn" placeholder="시설 이용 안내 사항을 입력하세요."></textarea>
              </div>
            </div>

            <div class="form-row cols-1">
              <div class="form-field">
                <label class="field-label">
                  시설 사진
                  <span style="font-size:10px; color:var(--text-tertiary); font-weight:400; margin-left:4px;">※ ERD 미반영 — 추후 ATCH_FILE_ID 컬럼 추가 예정</span>
                </label>
                <div id="fileUploadArea" style="border:2px dashed var(--border); border-radius:8px; padding:20px; text-align:center; cursor:pointer; transition:0.15s; background:#fafafa;"
                     onclick="document.getElementById('facilityFileInput').click()">
                  <span class="material-symbols-rounded" style="font-size:32px; color:var(--text-tertiary); display:block; margin-bottom:6px;">add_photo_alternate</span>
                  <div style="font-size:13px; color:var(--text-secondary); font-weight:600;">클릭하여 이미지 업로드</div>
                  <div style="font-size:11px; color:var(--text-tertiary); margin-top:4px;">JPG, PNG, GIF · 최대 10MB</div>
                </div>
                <input type="file" id="facilityFileInput" accept="image/*" multiple style="display:none;">
                <div id="filePreviewArea" style="display:flex; gap:8px; flex-wrap:wrap; margin-top:10px;"></div>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-action="closeModal">닫기</button>
          <button type="button" class="btn btn-primary" id="editBtn"
                  data-action="changeToEdit" style="display:none;">수정하기</button>
          <button type="submit" class="btn btn-primary" id="saveBtn">저장</button>
        </div>
      </form>
    </div>
  </div>

  <!-- 삭제 확인 모달 -->
  <div class="modal-overlay" id="deleteModal">
    <div class="modal modal-sm">
      <div class="modal-header primary">
        <h3 class="modal-title">공용 시설 삭제</h3>
        <button type="button" class="modal-close" data-action="closeDeleteModal">
          <span class="material-symbols-rounded">close</span>
        </button>
      </div>
      <div class="modal-body">
        <div style="display:flex; gap:10px; padding:14px 16px; background:#fff0f0; border:1px solid #e0a8a8; border-radius:8px; margin-bottom:16px;">
          <span class="material-symbols-rounded" style="color:#991b1b; font-size:20px; flex-shrink:0; margin-top:1px;">warning</span>
          <div style="font-size:13px; color:#7f1d1d; line-height:1.6;">
            선택한 공용 시설을 삭제하시겠습니까?<br>
            관련 예약 이력이 함께 조회되지 않을 수 있습니다.
          </div>
        </div>
        <div class="mngr-detail-grid" id="deleteTargetInfo"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-action="closeDeleteModal">취소</button>
        <button type="button" class="btn btn-danger" id="deleteConfirmBtn">삭제</button>
      </div>
    </div>
  </div>

</div>

<script>
  (function () {
    var page = document.getElementById("publicFacilityPage");
    if (!page || page.dataset.bound === "true") return;
    page.dataset.bound = "true";

    var modal       = document.getElementById("publicFacilityModal");
    var deleteModal = document.getElementById("deleteModal");
    var form        = document.getElementById("facilityForm");
    var modalTitle  = document.getElementById("modalTitle");
    var saveBtn     = document.getElementById("saveBtn");
    var editBtn     = document.getElementById("editBtn");
    var tbody       = document.getElementById("facilityTableBody");

    /* ── 더미 데이터
       PUBLIC_FACILITY: CMN_FACILITY_NO, APT_CMPLEX_NO, FACILITY_NO,
       CMN_FACILITY_NM, CMN_FACILITY_CN, CMN_FACILITY_AMT,
       CMN_FACILITY_RSV_YN, CMN_FACILITY_OPR_HR
       ※ CMN_FACILITY_STTS_CD — ERD에 없음, 제외
    ── */
    var rowData = [
      { cmnFacilityNo:"PF-001", cmnFacilityNm:"헬스장",    cmnFacilityRsvYn:"Y", cmnFacilityOprHr:"06:00~22:00", cmnFacilityAmt:0,      cmnFacilityCn:"매일 운영. 1회 2시간 제한." },
      { cmnFacilityNo:"PF-002", cmnFacilityNm:"회의실 A",  cmnFacilityRsvYn:"Y", cmnFacilityOprHr:"08:00~20:00", cmnFacilityAmt:5000,   cmnFacilityCn:"최대 10인 사용 가능." },
      { cmnFacilityNo:"PF-003", cmnFacilityNm:"게스트룸",  cmnFacilityRsvYn:"Y", cmnFacilityOprHr:"입실 15:00",  cmnFacilityAmt:30000,  cmnFacilityCn:"1박 30,000원. 최대 2박." },
      { cmnFacilityNo:"PF-004", cmnFacilityNm:"주민 카페", cmnFacilityRsvYn:"N", cmnFacilityOprHr:"09:00~21:00", cmnFacilityAmt:0,      cmnFacilityCn:"자유 이용 가능." }
    ];

    var deleteTargetIdx = null;

    /* ── 통계 ── */
    function updateStats(data) {
      document.getElementById("statTotal").textContent  = data.length;
      document.getElementById("statRsvY").textContent   = data.filter(function(r){ return r.cmnFacilityRsvYn === "Y"; }).length;
      document.getElementById("statToday").textContent  = 7; // 더미
    }

    /* ── 목록 렌더 ── */
    function renderTable(data) {
      document.getElementById("facilityListCount").textContent = data.length + "건";
      updateStats(data);

      if (data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="6" style="text-align:center; color:var(--text-tertiary);">등록된 공용 시설이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = data.map(function (row, idx) {
        var rsvBadge = row.cmnFacilityRsvYn === "Y"
                ? '<span class="badge badge-green">Y</span>'
                : '<span class="badge badge-gray">N</span>';
        var amt = row.cmnFacilityAmt === 0
                ? '<span style="color:var(--text-tertiary);">무료</span>'
                : row.cmnFacilityAmt.toLocaleString() + '원';

        return '<tr>'
                + '<td class="td-mono" style="font-size:12px;">' + row.cmnFacilityNo + '</td>'
                + '<td class="td-bold">' + row.cmnFacilityNm + '</td>'
                + '<td>' + rsvBadge + '</td>'
                + '<td>' + (row.cmnFacilityOprHr || "-") + '</td>'
                + '<td>' + amt + '</td>'
                + '<td><div class="grid-actions">'
                + '<button type="button" class="btn btn-xs btn-detail" data-action="detail" data-idx="' + idx + '">상세</button>'
                + '<button type="button" class="btn btn-xs btn-edit"   data-action="edit"   data-idx="' + idx + '">수정</button>'
                + '<button type="button" class="btn btn-xs btn-delete" data-action="delete" data-idx="' + idx + '">삭제</button>'
                + '</div></td>'
                + '</tr>';
      }).join("");
    }

    /* ── 필터 ── */
    function getFiltered() {
      var keyword = document.getElementById("filterKeyword").value.trim();
      var rsvYn   = document.getElementById("filterRsvYn").value;
      return rowData.filter(function(row){
        return (!keyword || row.cmnFacilityNm.indexOf(keyword) > -1)
                && (!rsvYn   || row.cmnFacilityRsvYn === rsvYn);
      });
    }

    function resetFilter() {
      document.getElementById("filterKeyword").value = "";
      document.getElementById("filterRsvYn").value   = "";
      renderTable(rowData);
    }

    /* ── 모달 ── */
    function openModal(mode, idx) {
      form.reset();
      saveBtn.style.display = "inline-flex";
      editBtn.style.display = "none";
      setFormDisabled(false);

      if (mode === "register") {
        modalTitle.textContent = "공용 시설 등록";
        document.getElementById("cmnFacilityNo").value = "";
      }
      if (mode === "detail" && idx !== undefined) {
        modalTitle.textContent = "공용 시설 상세";
        fillForm(rowData[idx]);
        setFormDisabled(true);
        saveBtn.style.display = "none";
        editBtn.style.display = "inline-flex";
        editBtn.dataset.idx   = idx;
      }
      if (mode === "edit" && idx !== undefined) {
        modalTitle.textContent = "공용 시설 수정";
        fillForm(rowData[idx]);
      }
      modal.classList.add("open");
    }

    function fillForm(row) {
      document.getElementById("cmnFacilityNo").value     = row.cmnFacilityNo    || "";
      document.getElementById("cmnFacilityNm").value     = row.cmnFacilityNm    || "";
      document.getElementById("cmnFacilityRsvYn").value  = row.cmnFacilityRsvYn || "Y";
      document.getElementById("cmnFacilityAmt").value    = row.cmnFacilityAmt   !== undefined ? row.cmnFacilityAmt : "";
      document.getElementById("cmnFacilityOprHr").value  = row.cmnFacilityOprHr || "";
      document.getElementById("cmnFacilityCn").value     = row.cmnFacilityCn    || "";
    }

    function setFormDisabled(disabled) {
      form.querySelectorAll("input, select, textarea").forEach(function(el){ el.disabled = disabled; });
    }

    function closeModal() { modal.classList.remove("open"); }

    /* ── 삭제 모달 ── */
    function openDeleteModal(idx) {
      deleteTargetIdx = idx;
      var row = rowData[idx];
      document.getElementById("deleteTargetInfo").innerHTML =
              '<div class="mngr-detail-item"><div class="mngr-detail-label">시설번호</div><div class="mngr-detail-value">' + row.cmnFacilityNo + '</div></div>'
              + '<div class="mngr-detail-item"><div class="mngr-detail-label">시설명</div><div class="mngr-detail-value">' + row.cmnFacilityNm + '</div></div>'
              + '<div class="mngr-detail-item"><div class="mngr-detail-label">예약가능</div><div class="mngr-detail-value">' + (row.cmnFacilityRsvYn === "Y" ? "가능" : "불가") + '</div></div>'
              + '<div class="mngr-detail-item"><div class="mngr-detail-label">운영시간</div><div class="mngr-detail-value">' + (row.cmnFacilityOprHr || "-") + '</div></div>';
      deleteModal.classList.add("open");
    }

    function closeDeleteModal() {
      deleteModal.classList.remove("open");
      deleteTargetIdx = null;
    }

    /* ── 이벤트 ── */
    page.addEventListener("click", function(e) {
      var btn = e.target.closest("[data-action]");
      if (!btn) return;

      var action = btn.dataset.action;
      var idx    = btn.dataset.idx !== undefined ? Number(btn.dataset.idx) : undefined;

      if (action === "openRegister")     openModal("register");
      if (action === "detail")           openModal("detail", idx);
      if (action === "edit")             openModal("edit", idx);
      if (action === "changeToEdit")     openModal("edit", Number(editBtn.dataset.idx));
      if (action === "closeModal")       closeModal();
      if (action === "delete")           openDeleteModal(idx);
      if (action === "closeDeleteModal") closeDeleteModal();
      if (action === "search")           renderTable(getFiltered());
      if (action === "resetFilter")      resetFilter();
    });

    document.getElementById("deleteConfirmBtn").addEventListener("click", function() {
      if (deleteTargetIdx === null) return;
      rowData.splice(deleteTargetIdx, 1);
      renderTable(rowData);
      closeDeleteModal();
      alert("삭제되었습니다.");
    });

    modal.addEventListener("click",       function(e){ if (e.target === modal)       closeModal(); });
    deleteModal.addEventListener("click", function(e){ if (e.target === deleteModal) closeDeleteModal(); });

    form.addEventListener("submit", function(e){
      e.preventDefault();
      if (!document.getElementById("cmnFacilityNm").value.trim()) {
        alert("시설명을 입력하세요."); return;
      }
      alert("저장 처리 연결 예정입니다.");
      closeModal();
    });

    /* ── 파일 업로드 미리보기 ── */
    document.getElementById("facilityFileInput").addEventListener("change", function() {
      var preview = document.getElementById("filePreviewArea");
      preview.innerHTML = "";
      Array.from(this.files).forEach(function(file) {
        var reader = new FileReader();
        reader.onload = function(e) {
          var wrap = document.createElement("div");
          wrap.style.cssText = "position:relative; width:80px; height:80px;";

          var img = document.createElement("img");
          img.src = e.target.result;
          img.style.cssText = "width:80px; height:80px; object-fit:cover; border-radius:6px; border:1px solid var(--border);";

          var del = document.createElement("button");
          del.type = "button";
          del.innerHTML = '<span class="material-symbols-rounded" style="font-size:14px;">close</span>';
          del.style.cssText = "position:absolute; top:-6px; right:-6px; width:20px; height:20px; border-radius:50%; background:#991b1b; color:#fff; border:none; cursor:pointer; display:flex; align-items:center; justify-content:center; padding:0;";
          del.onclick = function() { wrap.remove(); };

          wrap.appendChild(img);
          wrap.appendChild(del);
          preview.appendChild(wrap);
        };
        reader.readAsDataURL(file);
      });
    });

    /* 드래그앤드롭 */
    var uploadArea = document.getElementById("fileUploadArea");
    uploadArea.addEventListener("dragover", function(e) {
      e.preventDefault();
      this.style.borderColor = "#2e5c38";
      this.style.background  = "#f0f7f2";
    });
    uploadArea.addEventListener("dragleave", function() {
      this.style.borderColor = "var(--border)";
      this.style.background  = "#fafafa";
    });
    uploadArea.addEventListener("drop", function(e) {
      e.preventDefault();
      this.style.borderColor = "var(--border)";
      this.style.background  = "#fafafa";
      document.getElementById("facilityFileInput").files = e.dataTransfer.files;
      document.getElementById("facilityFileInput").dispatchEvent(new Event("change"));
    });

    renderTable(rowData);
  })();
</script>
