<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- =====================================================
     MNGR_ACCOUNT.jsp
     직원 계정 관리 — MANAGER / ADMINISTRATOR / MANAGER_RQST
     office-layout.css 의존 (office.jsp에서 로드됨)
===================================================== --%>

<style>
    /* ── 이 페이지 전용 스타일 ── */
    .page-tab-bar {
        display: flex;
        border-bottom: 1px solid var(--border);
        margin-bottom: 24px;
        margin-top: -28px;
        margin-left: -28px;
        margin-right: -28px;
        padding: 0 28px;
        background: var(--card);
    }
    .page-tab-btn {
        display: flex;
        align-items: center;
        gap: 6px;
        padding: 12px 18px;
        font-size: 13px;
        font-weight: 600;
        color: var(--text-tertiary);
        cursor: pointer;
        border: none;
        background: none;
        font-family: inherit;
        border-bottom: 2px solid transparent;
        margin-bottom: -1px;
        transition: .15s;
        white-space: nowrap;
    }
    .page-tab-btn .material-symbols-rounded { font-size: 16px; }
    .page-tab-btn:hover  { color: var(--text-primary); }
    .page-tab-btn.active { color: var(--btn-primary); border-bottom-color: var(--btn-primary); }

    .page-tab-panel         { display: none; }
    .page-tab-panel.active  { display: block; }

    /* 페이지 타이틀 */
    .frag-title             { margin-bottom: 20px; }
    .frag-title h2          { font-size: 18px; font-weight: 800; color: #111827; letter-spacing: -.3px; }
    .frag-title p           { font-size: 12px; color: #374151; margin-top: 4px; }

    /* 테이블 텍스트 진하게 */
    .tbl-main   { font-size: 13px; font-weight: 700; color: #111827; }
    .tbl-sub    { font-size: 13px; color: #1f2937; }
    .tbl-muted  { font-size: 12px; color: #4b5563; }
    .tbl-mono   { font-family: monospace; font-size: 12px; color: #1f2937; }

    /* 직원 아바타 */
    .avatar-row { display: flex; align-items: center; gap: 10px; }
    .emp-avatar {
        width: 32px; height: 32px; border-radius: 50%;
        display: inline-flex; align-items: center; justify-content: center;
        color: #fff; font-size: 13px; font-weight: 700; flex-shrink: 0;
    }
    .emp-name { font-size: 13px; font-weight: 700; color: #111827; }
    .emp-no   { font-size: 11px; color: #9ca3af; }

    /* 폼 유틸 */
    .input-with-btn          { display: flex; gap: 8px; }
    .input-with-btn .form-input { flex: 1; }
</style>

<div class="frag-title">
    <h2>직원 계정 관리</h2>
    <p>관리사무소 직원 계정을 등록·조회·수정하고 계정 생성 요청 상태를 함께 확인합니다</p>
</div>

<div style="display:flex; justify-content:flex-end; gap:8px; margin-bottom:16px">
    <button class="btn btn-primary" onclick="openMngrModal('modalMngrRqst')">
        <span class="material-symbols-rounded">person_add</span>계정 생성 요청
    </button>
</div>

<div class="stat-row" style="margin-bottom:20px">
    <div class="stat-card">
        <div class="stat-icon green"><span class="material-symbols-rounded">groups</span></div>
        <div><div class="stat-value">12</div><div class="stat-label">전체 직원</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon blue"><span class="material-symbols-rounded">check_circle</span></div>
        <div><div class="stat-value">9</div><div class="stat-label">재직 중</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon yellow"><span class="material-symbols-rounded">beach_access</span></div>
        <div><div class="stat-value">1</div><div class="stat-label">휴가 중</div></div>
    </div>
    <div class="stat-card">
        <div class="stat-icon red"><span class="material-symbols-rounded">pending</span></div>
        <div><div class="stat-value">2</div><div class="stat-label">승인 대기</div></div>
    </div>
</div>

<div class="panel">
    <div class="filter-bar">
        <select class="form-select" id="mngrTypeFilter" style="width:140px" onchange="renderMngrIntegrated()">
            <option value="">구분 전체</option>
            <option value="staff">재직 직원</option>
            <option value="request">계정 생성 요청</option>
        </select>
        <div class="search-wrap">
            <span class="material-symbols-rounded">search</span>
            <input class="form-input" type="text" id="mngrKeyword" placeholder="이름, 아이디, 이메일 검색…" style="width:220px" oninput="renderMngrIntegrated()" />
        </div>
        <select class="form-select" id="mngrPstnFilter" style="width:120px" onchange="renderMngrIntegrated()">
            <option value="">직무 전체</option>
            <option>관리소장</option><option>행정</option>
            <option>시설관리</option><option>회계</option>
        </select>
        <select class="form-select" id="mngrStatusFilter" style="width:130px" onchange="renderMngrIntegrated()">
            <option value="">상태 전체</option>
            <option>재직</option>
            <option>대기</option><option>승인</option><option>반려</option>
        </select>
        <button class="btn btn-secondary btn-sm" onclick="resetMngrFilters()">
            <span class="material-symbols-rounded">refresh</span>초기화
        </button>
    </div>

    <div class="table-wrap">
        <table>
            <thead>
            <tr>
                <th style="width:44px"><input type="checkbox" /></th>
                <th style="width:100px">구분</th>
                <th>직원</th>
                <th>로그인 아이디</th>
                <th>직무</th>
                <th>연락처</th>
                <th>이메일 / 권한</th>
                <th>상태</th>
                <th>등록일 / 요청일</th>
                <th>처리일</th>
                <th style="width:120px">관리</th>
            </tr>
            </thead>
            <tbody id="mngrIntegratedTbody"></tbody>
        </table>
    </div>

    <div class="pagination">
        <div class="pagination-info">총 <strong id="mngrTotalCount">0</strong>건</div>
        <div class="pagination-btns">
            <button class="page-btn"><span class="material-symbols-rounded">chevron_left</span></button>
            <button class="page-btn active">1</button>
            <button class="page-btn">2</button>
            <button class="page-btn"><span class="material-symbols-rounded">chevron_right</span></button>
        </div>
    </div>
</div>

<%-- ══ MODAL: 계정 생성 요청서 (→ MANAGER_RQST) ══ --%>
<div class="modal-overlay" id="modalMngrRqst">
    <div class="modal" style="width:680px">
        <div class="modal-header">
            <div class="modal-title">직원 계정 생성 요청</div>
            <button class="modal-close" onclick="closeMngrModal('modalMngrRqst')">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>
        <div class="modal-body">

            <div style="background:#eff6ff; border:1px solid #bfdbfe; border-radius:var(--r-sm);
                padding:12px 16px; margin-bottom:20px; font-size:13px; color:#1e40af;
                display:flex; align-items:flex-start; gap:8px">
                <span class="material-symbols-rounded" style="font-size:16px;flex-shrink:0;margin-top:1px">info</span>
                작성한 요청서는 중앙관리자에게 전달됩니다. 승인 후 직원 계정이 생성됩니다.
            </div>

            <div class="form-section">
                <div class="form-section-title">
                    <span class="material-symbols-rounded">person</span>인적사항 (MEMBER)
                </div>
                <div class="form-row cols-2">
                    <div class="form-group">
                        <label class="form-label">이름 <span class="req">*</span></label>
                        <input class="form-input" type="text" placeholder="홍길동" />
                        <span class="form-hint">USER_NM</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">연락처 <span class="req">*</span></label>
                        <input class="form-input" type="tel" placeholder="010-0000-0000" />
                        <span class="form-hint">USER_TELNO</span>
                    </div>
                </div>
                <div class="form-row cols-2">
                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <input class="form-input" type="email" placeholder="example@email.com" />
                        <span class="form-hint">USER_EML</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">주민등록번호 <span class="req">*</span></label>
                        <input class="form-input" type="text" placeholder="XXXXXX-XXXXXXX" />
                        <span class="form-hint">USER_RRNO (암호화 저장)</span>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">
                    <span class="material-symbols-rounded">key</span>계정 정보
                </div>
                <div class="form-row cols-2">
                    <div class="form-group">
                        <label class="form-label">로그인 아이디 <span class="req">*</span></label>
                        <div class="input-with-btn">
                            <input class="form-input" type="text" placeholder="영문·숫자 4~20자" />
                            <button type="button" class="btn btn-secondary btn-sm" style="flex-shrink:0">중복확인</button>
                        </div>
                        <span class="form-hint">USER_ID</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">임시 비밀번호 <span class="req">*</span></label>
                        <input class="form-input" type="password" placeholder="8자 이상 (영문+숫자+특수문자)" />
                        <span class="form-hint">USER_PW</span>
                    </div>
                </div>
                <div class="form-row cols-2">
                    <div class="form-group">
                        <label class="form-label">부여할 권한 <span class="req">*</span></label>
                        <select class="form-select">
                            <option value="">권한 선택</option>
                            <option value="ROLE_MANAGER">관리소장</option>
                            <option value="ROLE_ADMIN">관리원 (행정)</option>
                            <option value="ROLE_FACILITY">관리원 (시설)</option>
                            <option value="ROLE_ACCOUNT">관리원 (회계)</option>
                        </select>
                        <span class="form-hint">USER_ROLE_CD</span>
                    </div>
                    <div class="form-group">
                        <label class="form-label">직무 <span class="req">*</span></label>
                        <select class="form-select">
                            <option value="">직무 선택</option>
                            <option>관리소장</option><option>행정</option>
                            <option>시설관리</option><option>회계</option>
                        </select>
                        <span class="form-hint">PSTN_NM</span>
                    </div>
                </div>
            </div>

            <div class="form-section">
                <div class="form-section-title">
                    <span class="material-symbols-rounded">notes</span>비고
                </div>
                <div class="form-row cols-1">
                    <div class="form-group">
                        <textarea class="form-textarea" placeholder="특이사항, 업무 메모 등"></textarea>
                    </div>
                </div>
            </div>

        </div>
        <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeMngrModal('modalMngrRqst')">취소</button>
            <button class="btn btn-primary" onclick="closeMngrModal('modalMngrRqst')">
                <span class="material-symbols-rounded">send</span>요청 제출
            </button>
        </div>
    </div>
</div>

<%-- ══ MODAL: 직원 정보 수정 ══ --%>
<div class="modal-overlay" id="modalMngrEdit">
    <div class="modal" style="width:480px">
        <div class="modal-header">
            <div class="modal-title">직원 정보 수정</div>
            <button class="modal-close" onclick="closeMngrModal('modalMngrEdit')">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>
        <div class="modal-body">
            <div class="form-section">
                <div class="form-section-title">
                    <span class="material-symbols-rounded">person</span>기본 정보
                </div>
                <div class="form-row cols-2">
                    <div class="form-group">
                        <label class="form-label">이름</label>
                        <input class="form-input" type="text" id="editMngrNm" />
                    </div>
                    <div class="form-group">
                        <label class="form-label">연락처</label>
                        <input class="form-input" type="tel" id="editMngrTel" />
                    </div>
                </div>
                <div class="form-row cols-1">
                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <input class="form-input" type="email" id="editMngrEmail" />
                    </div>
                </div>
            </div>
            <div class="form-section">
                <div class="form-section-title">
                    <span class="material-symbols-rounded">business_center</span>근무 정보
                </div>
                <div class="form-row cols-1">
                    <div class="form-group">
                        <label class="form-label">직무</label>
                        <select class="form-select" id="editMngrPstn">
                            <option>관리소장</option><option>행정</option>
                            <option>시설관리</option><option>회계</option>
                        </select>
                    </div>
                </div>
                <div class="form-row cols-1">
                    <div class="form-group">
                        <label class="form-label">계정 상태</label>
                        <div style="display:flex; gap:16px; margin-top:4px">
                            <label style="display:flex;align-items:center;gap:6px;font-size:13px;cursor:pointer">
                                <input type="radio" name="mngrEditStatus" value="Y" checked /> 활성 (재직)
                            </label>
                            <label style="display:flex;align-items:center;gap:6px;font-size:13px;cursor:pointer">
                                <input type="radio" name="mngrEditStatus" value="N" /> 비활성
                            </label>
                        </div>
                        <span class="form-hint">USER_YN</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-danger btn-sm" style="margin-right:auto"
                    onclick="if(confirm('정말 삭제하시겠습니까?')) closeMngrModal('modalMngrEdit')">
                <span class="material-symbols-rounded">delete</span>삭제
            </button>
            <button class="btn btn-secondary" onclick="closeMngrModal('modalMngrEdit')">취소</button>
            <button class="btn btn-primary" onclick="closeMngrModal('modalMngrEdit')">
                <span class="material-symbols-rounded">save</span>저장
            </button>
        </div>
    </div>
</div>

<%-- ══ MODAL: 요청 상세 ══ --%>
<div class="modal-overlay" id="modalMngrRqstDetail">
    <div class="modal" style="width:440px">
        <div class="modal-header">
            <div class="modal-title">계정 생성 요청 상세</div>
            <button class="modal-close" onclick="closeMngrModal('modalMngrRqstDetail')">
                <span class="material-symbols-rounded">close</span>
            </button>
        </div>
        <div class="modal-body">
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px" id="rqstDetailGrid"></div>
        </div>
        <div class="modal-footer">
            <button class="btn btn-danger btn-sm" id="rqstCancelBtn" style="margin-right:auto"
                    onclick="if(confirm('요청을 취소하시겠습니까?')) closeMngrModal('modalMngrRqstDetail')">
                <span class="material-symbols-rounded">cancel</span>요청 취소
            </button>
            <button class="btn btn-secondary" onclick="closeMngrModal('modalMngrRqstDetail')">닫기</button>
        </div>
    </div>
</div>

<script>
    (function () {

        var staffList = [
            { no:'MGR001', name:'홍길동', id:'hong123', dept:'행정팀', pstn:'관리소장', telno:'010-1234-5678', email:'hong@apt.kr',   status:'재직', reg:'2024-03-01', color:'#16a34a' },
            { no:'MGR002', name:'김민수', id:'kim_ms',  dept:'시설팀', pstn:'시설관리',  telno:'010-2345-6789', email:'kimms@apt.kr',  status:'재직', reg:'2024-04-15', color:'#2563eb' },
            { no:'MGR003', name:'이영희', id:'lee_yh',  dept:'회계팀', pstn:'회계',  telno:'010-3456-7890', email:'leeyh@apt.kr',  status:'재직', reg:'2024-06-01', color:'#d97706' },
            { no:'MGR004', name:'박지현', id:'park_jh', dept:'행정팀', pstn:'행정',  telno:'010-4567-8901', email:'parkjh@apt.kr', status:'휴가', reg:'2023-11-10', color:'#9333ea' }
        ];

        var rqstList = [
            { no:'RQ001', name:'최성철', dept:'시설팀', pstn:'시설관리', role:'관리원 (시설)', rqstDt:'2026-04-20', procDt:'',           status:'대기', rejectRsn:'' },
            { no:'RQ002', name:'장민호', dept:'행정팀', pstn:'행정', role:'관리원 (행정)', rqstDt:'2026-04-18', procDt:'',           status:'대기', rejectRsn:'' },
            { no:'RQ003', name:'윤서연', dept:'회계팀', pstn:'회계', role:'관리원 (회계)', rqstDt:'2026-04-10', procDt:'2026-04-12', status:'승인', rejectRsn:'' },
            { no:'RQ004', name:'강태양', dept:'시설팀', pstn:'시설관리', role:'관리원 (시설)', rqstDt:'2026-04-05', procDt:'2026-04-07', status:'반려', rejectRsn:'서류 미비 (주민등록번호 오류)' }
        ];

        var staffBadge = { '재직':'badge-green', '휴가':'badge-yellow' };
        var rqstBadge  = { '대기':'badge-blue',  '승인':'badge-green', '반려':'badge-red' };

        function getIntegratedList() {
            var staffRows = staffList.map(function (e) {
                return {
                    type: 'staff',
                    typeLabel: '재직 직원',
                    no: e.no,
                    name: e.name,
                    id: e.id,
                    pstn: e.pstn,
                    telno: e.telno,
                    emailOrRole: e.email || '—',
                    status: e.status,
                    statusBadge: staffBadge[e.status] || 'badge-gray',
                    date1: e.reg,
                    date2: '—',
                    color: e.color,
                    rejectRsn: '',
                    raw: e
                };
            });

            var rqstRows = rqstList.map(function (r) {
                return {
                    type: 'request',
                    typeLabel: '생성 요청',
                    no: r.no,
                    name: r.name,
                    id: '—',
                    pstn: r.pstn,
                    telno: '—',
                    emailOrRole: r.role,
                    status: r.status,
                    statusBadge: rqstBadge[r.status] || 'badge-gray',
                    date1: r.rqstDt,
                    date2: r.procDt || '—',
                    color: '#6b7280',
                    rejectRsn: r.rejectRsn || '',
                    raw: r
                };
            });

            return staffRows.concat(rqstRows);
        }

        window.renderMngrIntegrated = function () {
            var tbody = document.getElementById('mngrIntegratedTbody');
            if (!tbody) return;

            var typeVal = document.getElementById('mngrTypeFilter').value;
            var keywordVal = document.getElementById('mngrKeyword').value.trim().toLowerCase();
            var pstnVal = document.getElementById('mngrPstnFilter').value;
            var statusVal = document.getElementById('mngrStatusFilter').value;

            var list = getIntegratedList().filter(function (item) {
                var matchedType = !typeVal || item.type === typeVal;
                var matchedPstn = !pstnVal || item.pstn === pstnVal;
                var matchedStatus = !statusVal || item.status === statusVal;
                var matchedKeyword = !keywordVal ||
                    item.name.toLowerCase().indexOf(keywordVal) > -1 ||
                    item.no.toLowerCase().indexOf(keywordVal) > -1 ||
                    String(item.id).toLowerCase().indexOf(keywordVal) > -1 ||
                    String(item.emailOrRole).toLowerCase().indexOf(keywordVal) > -1;

                return matchedType && matchedPstn && matchedStatus && matchedKeyword;
            });

            document.getElementById('mngrTotalCount').textContent = list.length;

            tbody.innerHTML = list.map(function (item) {
                return '<tr>' +
                    '<td><input type="checkbox" /></td>' +
                    '<td><span class="badge ' + (item.type === 'staff' ? 'badge-green' : 'badge-blue') + '">' + item.typeLabel + '</span></td>' +
                    '<td><div class="avatar-row">' +
                    '<div class="emp-avatar" style="background:linear-gradient(135deg,' + item.color + ',' + item.color + 'cc)">' + item.name[0] + '</div>' +
                    '<div><div class="emp-name">' + item.name + '</div><div class="emp-no">' + item.no + '</div></div>' +
                    '</div></td>' +
                    '<td class="tbl-mono">' + item.id + '</td>' +
                    '<td><span class="tbl-sub">' + item.pstn + '</span></td>' +
                    '<td class="tbl-sub">' + item.telno + '</td>' +
                    '<td class="tbl-muted">' + item.emailOrRole + '</td>' +
                    '<td><span class="badge ' + item.statusBadge + '">' + item.status + '</span></td>' +
                    '<td class="tbl-muted">' + item.date1 + '</td>' +
                    '<td class="tbl-muted">' + item.date2 + '</td>' +
                    '<td><div style="display:flex;gap:4px">' +
                    (item.type === 'staff'
                            ? '<button class="btn btn-secondary btn-xs" onclick="openMngrEditModal(\'' + item.no + '\')">수정</button>' +
                            '<button class="btn btn-danger btn-xs" onclick="if(confirm(`삭제하시겠습니까?`))alert(`삭제되었습니다`)">삭제</button>'
                            : '<button class="btn btn-secondary btn-xs" onclick="openRqstDetail(\'' + item.no + '\')">상세</button>'
                    ) +
                    '</div></td>' +
                    '</tr>';
            }).join('');
        };

        window.resetMngrFilters = function () {
            document.getElementById('mngrTypeFilter').value = '';
            document.getElementById('mngrKeyword').value = '';
            document.getElementById('mngrPstnFilter').value = '';
            document.getElementById('mngrStatusFilter').value = '';
            renderMngrIntegrated();
        };

        window.openMngrEditModal = function (no) {
            var e = staffList.find(function (x) { return x.no === no; });
            if (!e) return;
            document.getElementById('editMngrNm').value    = e.name;
            document.getElementById('editMngrTel').value   = e.telno;
            document.getElementById('editMngrEmail').value = e.email || '';
            openMngrModal('modalMngrEdit');
        };

        window.openRqstDetail = function (no) {
            var r = rqstList.find(function (x) { return x.no === no; });
            if (!r) return;
            var items = [
                ['요청번호', r.no], ['이름', r.name],
                ['직무', r.pstn],
                ['권한', r.role],   ['요청일', r.rqstDt],
                ['처리일', r.procDt || '—'], ['상태', r.status]
            ];
            var grid = document.getElementById('rqstDetailGrid');
            grid.innerHTML = items.map(function (i) {
                return '<div style="padding:12px;background:var(--gray-100);border-radius:var(--r-sm)">' +
                    '<div style="font-size:11px;color:var(--text-tertiary);margin-bottom:4px">' + i[0] + '</div>' +
                    '<div style="font-size:13px;font-weight:600;color:#111827">' + i[1] + '</div>' +
                    '</div>';
            }).join('');
            if (r.rejectRsn) {
                grid.innerHTML += '<div style="grid-column:span 2;padding:12px;background:#fef2f2;border:1px solid #fca5a5;border-radius:var(--r-sm)">' +
                    '<div style="font-size:11px;color:#dc2626;margin-bottom:4px">반려 사유</div>' +
                    '<div style="font-size:13px;color:#111827">' + r.rejectRsn + '</div>' +
                    '</div>';
            }
            document.getElementById('rqstCancelBtn').style.display = r.status === '대기' ? '' : 'none';
            openMngrModal('modalMngrRqstDetail');
        };

        window.openMngrModal = function (id) {
            var el = document.getElementById(id);
            if (el) el.classList.add('open');
        };
        window.closeMngrModal = function (id) {
            var el = document.getElementById(id);
            if (el) el.classList.remove('open');
        };

        document.querySelectorAll('.modal-overlay').forEach(function (o) {
            o.addEventListener('click', function (e) {
                if (e.target === o) o.classList.remove('open');
            });
        });

        renderMngrIntegrated();

    }());
</script>
