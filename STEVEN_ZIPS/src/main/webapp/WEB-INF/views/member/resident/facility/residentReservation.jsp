<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<style>.pf-wrap{padding:24px}.pf-page-title{font-size:24px;font-weight:700;color:#1f2d1f;margin-bottom:6px}.pf-page-desc{font-size:13px;color:#6b7280;margin-bottom:22px}.pf-card{background:#fff;border:1px solid #dfe5df;border-radius:8px;margin-bottom:16px}.pf-card-hd{display:flex;justify-content:space-between;align-items:center;padding:14px 18px;border-bottom:1px solid #e5e7eb;font-weight:700}.pf-card-bd{padding:16px 18px}.pf-search-grid{display:grid;grid-template-columns:repeat(6,1fr) 1.5fr auto auto;gap:10px;align-items:end}.pf-field label{display:block;font-size:12px;font-weight:700;color:#374151;margin-bottom:6px}.pf-field input,.pf-field select{width:100%;height:36px;border:1px solid #d7ded7;border-radius:5px;padding:0 10px;font-size:13px}.pf-btn{height:36px;border:1px solid #245b36;border-radius:5px;padding:0 14px;font-weight:700;cursor:pointer}.pf-btn-primary{background:#245b36;color:#fff}.pf-btn-light{background:#fff;color:#374151;border-color:#d7ded7}.pf-table{width:100%;border-collapse:collapse;font-size:13px}.pf-table th{background:#f2f6f1;border-bottom:1px solid #d7ded7;padding:12px;text-align:center;color:#374151}.pf-table td{border-bottom:1px solid #edf0ed;padding:11px;text-align:center}.pf-badge{display:inline-block;min-width:66px;padding:4px 8px;border-radius:6px;font-size:12px;font-weight:700}.pf-badge-ok{background:#e7f5ec;color:#1f7a3a}.pf-badge-wait{background:#eef2f7;color:#4b5563}.pf-badge-stop{background:#fff0f0;color:#b91c1c}.pf-badge-info{background:#e8f1ff;color:#1d4ed8}.pf-paging{display:flex;justify-content:center;margin-top:18px}.pagination{display:flex;gap:4px;list-style:none;padding:0}.page-link{display:block;padding:6px 10px;border:1px solid #d7ded7;border-radius:4px;color:#374151;text-decoration:none}.page-item.active .page-link{background:#245b36;color:#fff;border-color:#245b36}.pf-modal{display:none;position:fixed;inset:0;background:rgba(0,0,0,.35);z-index:9999}.pf-modal.is-open{display:flex;align-items:center;justify-content:center}.pf-modal-box{width:620px;background:#fff;border-radius:10px;padding:20px}.pf-modal-title{font-size:18px;font-weight:700;margin-bottom:12px}.pf-actions{display:flex;gap:6px;justify-content:center}.pf-textarea{width:100%;min-height:110px;border:1px solid #d7ded7;border-radius:5px;padding:10px}</style>
<div class="pf-wrap">
  <h2 class="pf-page-title">공용시설 예약</h2>
  <p class="pf-page-desc">단지 내 공용시설 예약 정보를 조회합니다.</p>
  <form id="searchForm" method="get" action="${pageContext.request.contextPath}/resident/publicFacility/reservation">
    <div class="pf-card">
      <div class="pf-card-hd">검색 조건</div>
      <div class="pf-card-bd pf-search-grid">
        <div class="pf-field"><label>시설명</label><input name="searchWord" value="${searchVO.searchWord}" placeholder="시설명/좌석명"/></div>
        <div class="pf-field"><label>동</label><input name="searchDongNo" value="${searchVO.searchDongNo}" placeholder="동"/></div>
        <div class="pf-field"><label>상태</label><select name="searchRsvtSttsCd"><option value="">전체</option><option value="PENDING">승인대기</option><option value="APPROVED">승인완료</option><option value="REJECTED">거절</option><option value="CANCELLED">취소</option></select></div>
        <div class="pf-field"><label>시작일</label><input type="date" name="searchStartDt" value="${searchVO.searchStartDt}"/></div>
        <div class="pf-field"><label>종료일</label><input type="date" name="searchEndDt" value="${searchVO.searchEndDt}"/></div>
        <div class="pf-field"><label>입주민명</label><input name="searchUserNm" value="${searchVO.searchUserNm}" placeholder="이름"/></div>
        <button type="button" class="pf-btn pf-btn-light" onclick="location.href='${pageContext.request.contextPath}/resident/publicFacility/reservation'">초기화</button>
        <button class="pf-btn pf-btn-primary">검색</button>
      </div>
    </div>
  </form>
  <div class="pf-card">
    <div class="pf-card-hd"><span>공용시설 예약 <b>${pagingVO.totalRecord}</b>건</span></div>
    <div class="pf-card-bd">
      <table class="pf-table">
        <thead><tr><th>번호</th><th>시설명</th><th>세부시설</th><th>위치</th><th>운영상태</th><th>운영시간</th><th>예약</th></tr></thead>
        <tbody>
        <c:forEach items="${pagingVO.dataList}" var="row" varStatus="st">
          <tr><td>${pagingVO.totalRecord - ((pagingVO.currentPage - 1) * pagingVO.screenSize) - st.index}</td><td>${row.cmnFacilityNm}</td><td>${row.itemNm}</td><td>${row.dongNm} ${row.locCn}</td><td><span class="pf-badge pf-badge-ok">${row.cmnFacilitySttsCd}</span></td><td>${row.cmnFacilityOprHr}</td><td><button class="pf-btn pf-btn-primary" onclick="openReserve('${row.cmnFacilityItemNo}', '${row.cmnFacilityNm}')">예약</button></td></tr>
        </c:forEach>
        <c:if test="${empty pagingVO.dataList}"><tr><td colspan="10">조회된 데이터가 없습니다.</td></tr></c:if>
        </tbody>
      </table>
      <div class="pf-paging">${pagingVO.pagingHTML}</div>
    </div>
  </div>
</div>
<script>
document.addEventListener('click', function(e){
  const a = e.target.closest('.page-link');
  if(!a || !a.dataset.page) return;
  e.preventDefault();
  const form = document.getElementById('searchForm');
  const page = document.createElement('input');
  page.type='hidden'; page.name='currentPage'; page.value=a.dataset.page;
  form.appendChild(page); form.submit();
});
</script>
<div id="reserveModal" class="pf-modal"><div class="pf-modal-box"><div class="pf-modal-title">예약 신청</div>
<form id="reserveForm">
<input type="hidden" name="cmnFacilityItemNo" id="mItemNo"><input type="hidden" name="cmnFacilityNm" id="mFacilityNm">
<div class="pf-field"><label>예약일</label><input type="date" name="rsvtDt" required></div>
<div class="pf-field"><label>시작일시</label><input name="rsvtBgngDttm" placeholder="YYYY-MM-DD HH:mm" required></div>
<div class="pf-field"><label>종료일시</label><input name="rsvtEndDttm" placeholder="YYYY-MM-DD HH:mm" required></div>
<div class="pf-field"><label>이용목적</label><textarea class="pf-textarea" name="purposeCn"></textarea></div>
<div class="pf-actions"><button type="button" class="pf-btn pf-btn-light" onclick="closeReserve()">닫기</button><button class="pf-btn pf-btn-primary">신청</button></div>
</form></div></div>
<script>
function openReserve(itemNo, facilityNm){document.getElementById('mItemNo').value=itemNo;document.getElementById('mFacilityNm').value=facilityNm;document.getElementById('reserveModal').classList.add('is-open');}
function closeReserve(){document.getElementById('reserveModal').classList.remove('is-open');}
document.getElementById('reserveForm').addEventListener('submit', function(e){
 e.preventDefault();
 fetch('${pageContext.request.contextPath}/resident/publicFacility/reservation',{method:'POST',body:new URLSearchParams(new FormData(this))})
 .then(r=>r.text()).then(t=>{alert('예약 신청이 완료되었습니다. 예약번호: '+t);location.reload();});
});
</script>