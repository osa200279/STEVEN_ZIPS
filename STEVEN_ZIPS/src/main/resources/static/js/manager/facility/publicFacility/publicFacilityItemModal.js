/**
 * publicFacilityItemModal.js
 * 편의시설 자원 모달 공용 JS
 *
 * 모드:
 *   insert - 자원 등록 (여러 행 추가 가능)
 *   detail - 자원 상세 (읽기전용 + 시설정보 + 형제 자원 목록)
 *   update - 자원 수정 (detail과 같은 모달, 자원명/상태만 편집)
 *
 * 공개 API:
 *   PublicFacilityItemModal.init(config)
 *   PublicFacilityItemModal.open(mode, itemNo)
 *   PublicFacilityItemModal.close()
 *   PublicFacilityItemModal.save()
 *   PublicFacilityItemModal.confirmDelete()
 */
(function () {

    /* ============================================================
       내부 상태
    ============================================================ */
    var _cfg          = {};    /* contextPath, mgmtOfcNo, cmnFacilityNo, isAdmin */
    var _mode         = null;  /* insert | detail | update */
    var _itemNo       = null;  /* 현재 선택된 자원번호 */
    var _facilityNo   = null;  /* 선택된 편의시설번호 */
    var _suggestTimer = null;
    var _bound        = false; /* 정적 이벤트 중복 바인딩 방지 */

    /* ============================================================
       초기화
    ============================================================ */
    function init(config) {
        _cfg        = config || {};
        _facilityNo = _cfg.cmnFacilityNo || null;
        if (!_bound) { _bindStaticEvents(); _bound = true; }
    }

    /* ============================================================
       CSRF
    ============================================================ */
    function _csrf() {
        var t = document.querySelector('meta[name="_csrf"]');
        var h = document.querySelector('meta[name="_csrf_header"]');
        var headers = { "Content-Type": "application/json" };
        if (t && h) headers[h.content] = t.content;
        return headers;
    }

    /* ============================================================
       fetch JSON
    ============================================================ */
    async function _fetch(url, opts) {
        var res = await fetch(url, opts);
        if (!res.ok) throw new Error("서버 오류: " + res.status);
        return res.json();
    }

    /* ============================================================
       DOM 헬퍼
    ============================================================ */
    function _el(id)       { return document.getElementById(id); }
    function _show(id)     { var e = _el(id); if (e) e.style.display = ""; }
    function _hide(id)     { var e = _el(id); if (e) e.style.display = "none"; }
    function _val(id)      { var e = _el(id); return e ? e.value : ""; }
    function _setVal(id,v) { var e = _el(id); if (e) e.value = v; }
    function _text(id,v)   { var e = _el(id); if (e) e.textContent = v; }
    function _alert(msg)   { if (typeof showAlert === "function") showAlert(msg); else alert(msg); }

    /* ============================================================
       상태 배지
    ============================================================ */
    function _badge(cd) {
        var m = {
            OPEN:   ["stts-open",   "사용가능"],
            USE:    ["stts-use",    "사용중"],
            REPAIR: ["stts-repair", "점검중"],
            CLOSE:  ["stts-close",  "사용중지"]
        };
        var s = m[cd];
        if (!s) return '<span class="stts-badge">' + (cd || "-") + '</span>';
        return '<span class="stts-badge ' + s[0] + '">' + s[1] + '</span>';
    }

    /* ============================================================
       모달 열기
    ============================================================ */
    function open(mode, itemNo) {
        _mode   = mode;
        _itemNo = itemNo || null;

        _resetSections();
        _setTitle(mode);

        if (mode === "insert") {
            _openInsert();
        } else {
            _loadDetail(itemNo, mode);
        }
    }

    /* ============================================================
       모달 닫기
    ============================================================ */
    function close() {
        var modal = _el("pfItemModal");
        if (modal) modal.classList.remove("is-open");
        _mode = null; _itemNo = null;
    }

    /* ============================================================
       모달 표시
    ============================================================ */
    function _showModal() {
        var modal = _el("pfItemModal");
        if (modal) modal.classList.add("is-open");
    }

    /* ============================================================
       섹션 전체 숨기기 및 초기화
    ============================================================ */
    function _resetSections() {
        ["pfFacilitySearchSection", "pfFacilityInfoSection",
            "pfItemInfoSection", "pfItemInsertSection", "pfSiblingSection"].forEach(_hide);

        var footer = _el("pfModalFooter");
        var rows   = _el("pfItemRows");
        var sib    = _el("pfSiblingList");
        var box    = _el("pfFacilitySuggestBox");
        var inp    = _el("pfFacilitySearchInput");

        if (footer) footer.innerHTML = "";
        if (rows)   rows.innerHTML   = "";
        if (sib)    sib.innerHTML    = "";
        if (box)    { box.classList.remove("is-open"); box.innerHTML = ""; }
        if (inp)    inp.value = "";
    }

    /* ============================================================
       타이틀
    ============================================================ */
    function _setTitle(mode) {
        var map = {
            insert: "편의시설 자원 등록",
            detail: "편의시설 자원 상세",
            update: "편의시설 자원 수정"
        };
        _text("pfModalTitle", map[mode] || "편의시설 자원");
    }

    /* ============================================================
       등록 모드 열기
    ============================================================ */
    function _openInsert() {
        _addItemRow(); /* 기본 1행 */
        _setFooter("insert");

        if (_facilityNo) {
            /* 시설이 이미 정해진 경우 (detail.jsp에서 열기) */
            _loadFacilityDetail(_facilityNo, function (facility) {
                _fillFacilityInfo(facility, _facilityNo);
                _show("pfFacilityInfoSection");
                _show("pfItemInsertSection");
                _loadSiblingsForInsert(_facilityNo);
                _showModal();
            });
        } else {
            /* 시설 미정 (list.jsp에서 열기) - 검색창 표시 */
            _show("pfFacilitySearchSection");
            _show("pfItemInsertSection");
            _showModal();
        }
    }

    /* ============================================================
       상세/수정 데이터 로드
    ============================================================ */
    function _loadDetail(itemNo, mode) {
        var url = _cfg.contextPath
            + "/manager/publicFacility/item/detail/"
            + encodeURIComponent(_cfg.mgmtOfcNo) + "/"
            + encodeURIComponent(itemNo);

        _fetch(url)
            .then(function (data) {
                if (!data.success) { _alert("자원 정보를 불러오지 못했습니다."); return; }

                var item     = data.item        || {};
                var facility = data.facility    || {};
                var siblings = data.siblingList || [];

                /* 편의시설 정보 */
                _fillFacilityInfo(facility, item.cmnFacilityNo);
                _show("pfFacilityInfoSection");

                /* 자원 정보 */
                _setVal("pfItemNo",        item.cmnFacilityItemNo || "");
                _setVal("pfItemNoDisplay", item.cmnFacilityItemNo || "");
                _setVal("pfItemNm",        item.itemNm            || "");
                _setVal("pfItemStts",      item.cmnFacilitySttsCd || "OPEN");
                _show("pfItemInfoSection");
                _setEditable(mode === "update");

                /* 형제 자원 목록 */
                _renderSiblings(siblings, item.cmnFacilityItemNo);
                if (siblings.length > 0) _show("pfSiblingSection");

                _setFooter(mode);
                _showModal();
            })
            .catch(function (err) {
                console.error(err);
                _alert("자원 정보 조회 중 오류가 발생했습니다.");
            });
    }

    /* ============================================================
       편의시설 정보 채우기
    ============================================================ */
    function _fillFacilityInfo(facility, cmnFacilityNo) {
        _text("pfInfoFacilityNo",    (facility && facility.facilityNo)    || "-");
        _text("pfInfoCmnFacilityNo", cmnFacilityNo                        || "-");
        _text("pfInfoCmnFacilityNm", (facility && facility.cmnFacilityNm) || "-");
    }

    /* ============================================================
       편집 가능 여부
    ============================================================ */
    function _setEditable(editable) {
        var nm   = _el("pfItemNm");
        var stts = _el("pfItemStts");
        if (nm)   nm.readOnly   = !editable;
        if (stts) stts.disabled = !editable;
    }

    /* ============================================================
       형제 자원 목록 렌더링
    ============================================================ */
    function _renderSiblings(list, currentItemNo) {
        var wrap = _el("pfSiblingList");
        if (!wrap) return;
        if (!list || list.length === 0) {
            wrap.innerHTML = '<div style="padding:12px;font-size:12px;color:#8a9a8e;text-align:center;">등록된 자원이 없습니다.</div>';
            return;
        }
        wrap.innerHTML = list.map(function (item) {
            var isCurrent = item.cmnFacilityItemNo === currentItemNo;
            return '<div class="pf-sibling-row' + (isCurrent ? " is-current" : "") + '">'
                + '<span class="pf-sibling-no">'   + (item.cmnFacilityItemNo || "") + '</span>'
                + '<span class="pf-sibling-nm">'   + (item.itemNm || "-")           + '</span>'
                + '<span class="pf-sibling-stts">' + _badge(item.cmnFacilitySttsCd) + '</span>'
                + '</div>';
        }).join("");
    }

    /* ============================================================
       편의시설 상세 조회 (등록 시 시설 선택 후)
       - grid-list API에서 해당 시설만 찾아서 반환
    ============================================================ */
    function _loadFacilityDetail(cmnFacilityNo, callback) {
        /*
            * 모달용 상위 편의시설 정보 조회
            * - PUBLIC_FACILITY 타입은 자원 탭 필터 자동완성과 분리하기 위한 값
            * - 선택한 CMN 번호 기준으로 편의시설명/시설번호를 다시 조회
    */
        var url = _cfg.contextPath
            + "/manager/publicFacility/item/suggest/"
            + encodeURIComponent(_cfg.mgmtOfcNo)
            + "?suggestType=PUBLIC_FACILITY&keyword="
            + encodeURIComponent(cmnFacilityNo.replace(/^CMN/, ""));

        _fetch(url)
            .then(function (data) {
                var list = data.list || [];
                var found = list.find(function (f) { return f.cmnFacilityNo === cmnFacilityNo; });
                /* suggest 결과로 cmnFacilityNm 채우고, facilityNo는 없으므로 "-" 처리 */
                if (callback) {
                    callback(found ? {
                        cmnFacilityNm: found.cmnFacilityNm,
                        facilityNo: found.facilityNo || "-"
                    } : {});
                }
            })
            .catch(function () { if (callback) callback({}); });
    }

    /* ============================================================
       등록 모드 형제 자원 로드
    ============================================================ */
    function _loadSiblingsForInsert(cmnFacilityNo) {
        var url = _cfg.contextPath
            + "/manager/publicFacility/item/paging/"
            + encodeURIComponent(_cfg.mgmtOfcNo)
            + "?facilityNo=" + encodeURIComponent(cmnFacilityNo.replace(/^CMN/, ""))
            + "&pageSize=50&page=1";

        _fetch(url)
            .then(function (data) {
                var list = data.list || [];
                _renderSiblings(list, null);
                _show("pfSiblingSection"); /* 자원 없어도 섹션 표시 */
            })
            .catch(function () { _show("pfSiblingSection"); });
    }

    /* ============================================================
       자원 등록 행 추가
    ============================================================ */
    function _addItemRow() {
        var rows = _el("pfItemRows");
        if (!rows) return;

        var idx = rows.children.length;
        var div = document.createElement("div");
        div.className = "pf-field-row";

        div.innerHTML =
            '<div class="pf-field">'
            + (idx === 0 ? '<label>자원명 <span class="req">*</span></label>' : '<label>&nbsp;</label>')
            + '<input type="text" class="pf-input pf-row-nm" placeholder="예) 러닝머신 ' + (idx + 1) + '번">'
            + '</div>'
            + '<div class="pf-field">'
            + (idx === 0 ? '<label>상태</label>' : '<label>&nbsp;</label>')
            + '<select class="pf-select pf-row-stts">'
            + '<option value="OPEN">사용가능</option>'
            + '<option value="USE">사용중</option>'
            + '<option value="REPAIR">점검중</option>'
            + '<option value="CLOSE">사용중지</option>'
            + '</select>'
            + '</div>'
            + '<button type="button" class="pf-del-btn pf-row-del" title="행 삭제">'
            + '<span class="material-symbols-rounded">remove</span>'
            + '</button>';

        div.querySelector(".pf-row-del").addEventListener("click", function () {
            if (rows.children.length <= 1) return; /* 최소 1행 유지 */
            div.remove();
        });

        rows.appendChild(div);
    }

    /* ============================================================
       푸터 버튼
    ============================================================ */
    function _setFooter(mode) {
        var footer = _el("pfModalFooter");
        if (!footer) return;

        var html = '<button type="button" class="pf-btn" id="pfCloseBtnFooter">닫기</button>';

        if (mode === "detail" && !_cfg.isAdmin) {
            html += '<button type="button" class="pf-btn pf-btn-primary" id="pfToUpdateBtn">수정</button>'; /* 수정 */
        }

        if (mode === "update" && !_cfg.isAdmin) {
            html += '<button type="button" class="pf-btn pf-btn-save" id="pfSaveBtn">저장</button>'; /* 저장 */
        }

        if (mode === "insert" && !_cfg.isAdmin) {
            html += '<button type="button" class="pf-btn pf-btn-save" id="pfSaveBtn">저장</button>'; /* 등록 */
        }

        footer.innerHTML = html;

        var c = _el("pfCloseBtnFooter");
        var u = _el("pfToUpdateBtn");
        var s = _el("pfSaveBtn");

        if (c) c.addEventListener("click", close);        /* 닫기 */
        if (u) u.addEventListener("click", _switchToUpdate); /* 수정전환 */
        if (s) s.addEventListener("click", save);         /* 저장 */
    }
    /* ============================================================
       상세 → 수정 전환 (같은 모달)
    ============================================================ */
    function _switchToUpdate() {
        _mode = "update";
        _setTitle("update");
        _setEditable(true);
        _setFooter("update");
    }

    /* ============================================================
       저장 (등록/수정 분기)
    ============================================================ */
    function save() {
        if (_mode === "insert") _saveInsert();
        else if (_mode === "update") _saveUpdate();
    }

    /* 등록 저장 */
    async function _saveInsert() {
        if (!_facilityNo) { _alert("편의시설을 먼저 선택하세요."); return; }

        var rows  = _el("pfItemRows");
        var items = [];
        Array.from(rows.querySelectorAll(".pf-field-row")).forEach(function (row) {
            var nm   = row.querySelector(".pf-row-nm").value.trim();
            var stts = row.querySelector(".pf-row-stts").value;
            if (nm) items.push({ cmnFacilityNo: _facilityNo, itemNm: nm, cmnFacilitySttsCd: stts });
        });

        if (items.length === 0) { _alert("자원명을 입력하세요."); return; }

        try {
            for (var i = 0; i < items.length; i++) {
                await _fetch(
                    _cfg.contextPath + "/manager/publicFacility/item/insert/" + encodeURIComponent(_cfg.mgmtOfcNo),
                    { method: "POST", headers: _csrf(), body: JSON.stringify(items[i]) }
                );
            }
            _alert(items.length + "개 자원이 등록되었습니다.");
            close();
            _refresh();
        } catch (e) {
            console.error(e);
            _alert("등록 중 오류가 발생했습니다.");
        }
    }

    /* 수정 저장 */
    async function _saveUpdate() {
        var nm = _val("pfItemNm").trim();
        if (!nm) { _alert("자원명을 입력하세요."); return; }

        var payload = {
            cmnFacilityItemNo: _val("pfItemNo"),
            cmnFacilityNo:     _facilityNo || _cfg.cmnFacilityNo || "",
            itemNm:            nm,
            cmnFacilitySttsCd: _val("pfItemStts")
        };

        try {
            var data = await _fetch(
                _cfg.contextPath + "/manager/publicFacility/item/update/" + encodeURIComponent(_cfg.mgmtOfcNo),
                { method: "POST", headers: _csrf(), body: JSON.stringify(payload) }
            );
            if (data.success) { _alert(data.message || "수정되었습니다."); close(); _refresh(); }
            else { _alert(data.message || "수정에 실패했습니다."); }
        } catch (e) {
            console.error(e);
            _alert("수정 중 오류가 발생했습니다.");
        }
    }

    /* ============================================================
       삭제
    ============================================================ */
    function confirmDelete() {
        if (!confirm("이 자원을 삭제하시겠습니까?")) return;

        _fetch(
            _cfg.contextPath + "/manager/publicFacility/item/delete/" + encodeURIComponent(_cfg.mgmtOfcNo),
            { method: "POST", headers: _csrf(), body: JSON.stringify({ cmnFacilityItemNo: _itemNo }) }
        )
            .then(function (data) {
                if (data.success) { _alert(data.message || "삭제되었습니다."); close(); _refresh(); }
                else { _alert(data.message || "삭제에 실패했습니다."); }
            })
            .catch(function (e) { console.error(e); _alert("삭제 중 오류가 발생했습니다."); });
    }

    /* ============================================================
       저장/삭제 후 목록 갱신
    ============================================================ */
    function _refresh() {
        var tbody = document.getElementById("dtlItemBody");
        var facilityNo = _facilityNo || _cfg.cmnFacilityNo || "";

        if (tbody && facilityNo) {
            /* detail.jsp 인라인 테이블 갱신 */
            var url = _cfg.contextPath
                + "/manager/publicFacility/item/paging/"
                + encodeURIComponent(_cfg.mgmtOfcNo)
                + "?facilityNo=" + encodeURIComponent(facilityNo.replace(/^CMN/, ""))
                + "&pageSize=50&page=1";

            fetch(url)
                .then(function (r) { return r.json(); })
                .then(function (data) { _renderDetailTable(data.list || []); })
                .catch(function () { location.reload(); });
        } else {
            location.reload();
        }
    }

    /* ============================================================
       detail.jsp 자원 테이블 갱신
    ============================================================ */
    function _renderDetailTable(list) {
        var tbody = document.getElementById("dtlItemBody");
        if (!tbody) return;

        if (!list.length) {
            tbody.innerHTML = '<tr id="emptyRow"><td class="item-empty" colspan="4">등록된 자원이 없습니다.</td></tr>';
            return;
        }
        tbody.innerHTML = list.map(function (item) {
            return '<tr data-item-no="'  + (item.cmnFacilityItemNo || "") + '"'
                + ' data-item-nm="'     + (item.itemNm || "").replace(/"/g, "&quot;") + '"'
                + ' data-stts="'        + (item.cmnFacilitySttsCd || "") + '">'
                + '<td style="text-align:center;font-size:12px;">' + (item.cmnFacilityItemNo || "") + '</td>'
                + '<td style="padding-left:10px;">'                + (item.itemNm || "-")           + '</td>'
                + '<td style="text-align:center;">'                + _badge(item.cmnFacilitySttsCd) + '</td>'
                + '<td><div style="display:flex;gap:4px;justify-content:center;">'
                + '<button type="button" class="row-btn" data-action="edit">수정</button>'
                + '<button type="button" class="row-btn row-btn-danger" data-action="delete">삭제</button>'
                + '</div></td>'
                + '</tr>';
        }).join("");
    }

    /* ============================================================
       정적 이벤트 바인딩 (init 시 1회)
    ============================================================ */
    function _bindStaticEvents() {
        /* 모달 외부 클릭 닫기 */
        var modal = _el("pfItemModal");
        if (modal) {
            modal.addEventListener("click", function (e) {
                if (e.target === modal) close();
            });
        }

        /* X 버튼 */
        var xBtn = _el("pfModalCloseBtn");
        if (xBtn) xBtn.addEventListener("click", close);

        /* + 자원 추가 버튼 */
        var addBtn = _el("pfAddRowBtn");
        if (addBtn) addBtn.addEventListener("click", _addItemRow);

        /* 편의시설번호 자동완성 (등록 검색창) */
        var inp = _el("pfFacilitySearchInput");
        var box = _el("pfFacilitySuggestBox");
        if (inp && box) {
            inp.addEventListener("input", function () {
                var kw = this.value.trim();
                clearTimeout(_suggestTimer);
                if (!kw) { box.classList.remove("is-open"); box.innerHTML = ""; return; }
                _suggestTimer = setTimeout(function () {
                    fetch(_cfg.contextPath
                        + "/manager/publicFacility/item/suggest/"
                        + encodeURIComponent(_cfg.mgmtOfcNo)
                        + "?suggestType=PUBLIC_FACILITY&keyword=" + encodeURIComponent(kw))
                        .then(function (r) { return r.json(); })
                        .then(function (data) { _renderFacilitySuggest(data.list || []); })
                        .catch(function () {});
                }, 200);
            });

            document.addEventListener("click", function (e) {
                if (!inp.contains(e.target) && !box.contains(e.target)) {
                    box.classList.remove("is-open");
                }
            });
        }
    }

    /* ============================================================
       편의시설 자동완성 렌더링
    ============================================================ */
    function _renderFacilitySuggest(list) {
        var box = _el("pfFacilitySuggestBox");
        if (!box) return;

        if (!list.length) {
            box.innerHTML = '<div class="pf-suggest-empty">검색 결과가 없습니다.</div>';
            box.classList.add("is-open");
            return;
        }

        box.innerHTML = list.map(function (item) {
            return '<div class="pf-suggest-item" data-no="' + (item.cmnFacilityNo || "") + '">'
                + '<span class="pf-suggest-main">' + (item.cmnFacilityNo  || "") + '</span>'
                + '<span class="pf-suggest-sub">'  + (item.cmnFacilityNm  || "") + '</span>'
                + '</div>';
        }).join("");
        box.classList.add("is-open");

        box.querySelectorAll(".pf-suggest-item").forEach(function (item) {
            item.addEventListener("click", function () {
                var no = item.getAttribute("data-no");
                _el("pfFacilitySearchInput").value = no.replace(/^CMN/, "");
                box.classList.remove("is-open");
                _facilityNo = no;

                /* 시설 정보 로드 후 표시 */
                _loadFacilityDetail(no, function (facility) {
                    _fillFacilityInfo(facility, no);
                    _show("pfFacilityInfoSection");
                    _loadSiblingsForInsert(no);
                });
            });
        });
    }

    /* ============================================================
       공개 API
    ============================================================ */
    window.PublicFacilityItemModal = {
        init:          init,
        open:          open,
        close:         close,
        save:          save,
        confirmDelete: confirmDelete
    };

})();