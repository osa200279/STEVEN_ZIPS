<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${facility.cmnFacilityNm} 예약</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/headerStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarStyle.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/footerStyle.css">

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif !important;
            background: var(--bg);
            color: var(--text-dark);
            margin: 0;
        }

        .main-shell {
            display: flex;
            align-items: stretch;
            width: 100%;
            min-height: calc(100vh - 114px);
            margin-top: 114px;
            background: var(--bg);
        }

        .content-area {
            flex: 1;
            min-width: 0;
            padding: 32px 40px 64px;
        }

        .page-content-wrap {
            max-width: 1080px;
            width: 100%;
            margin: 0 auto;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 12px;
            color: var(--text-light);
            margin-bottom: 18px;
        }

        .breadcrumb a {
            color: var(--text-light);
            text-decoration: none;
        }

        .breadcrumb .cur {
            color: var(--green-dark);
            font-weight: 700;
        }

        .page-title {
            font-size: 22px;
            font-weight: 800;
            color: var(--text-dark);
            padding-bottom: 14px;
            border-bottom: 2px solid var(--green-dark);
            margin-bottom: 16px;
        }

        .reserve-top-card,
        .seat-map-card,
        .reservation-card {
            background: #ffffff;
            border: 1px solid var(--border);
            border-radius: 14px;
            box-shadow: 0 10px 24px rgba(30, 60, 40, 0.05);
        }

        .reserve-top-card {
            padding: 20px 24px;
            margin-bottom: 18px;
        }

        .reserve-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .reserve-desc {
            font-size: 13px;
            color: var(--text-light);
            line-height: 1.7;
        }

        .reserve-layout {
            display: grid;
            grid-template-columns: 330px 1fr;
            gap: 16px;
        }

        .seat-map-card,
        .reservation-card {
            overflow: hidden;
        }

        .card-head {
            padding: 18px 20px;
            border-bottom: 1px solid var(--border);
        }

        .card-title {
            font-size: 16px;
            font-weight: 800;
            color: var(--text-dark);
        }

        .card-desc {
            margin-top: 4px;
            font-size: 12px;
            color: var(--text-light);
        }

        .seat-map-body {
            padding: 16px;
            max-height: 560px;
            overflow-y: auto;
        }

        .seat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 8px;
        }

        .seat-btn {
            height: 38px;
            border-radius: 10px;
            border: 1px solid #c8d8ce;
            background: #eef7f0;
            color: var(--green-dark);
            font-weight: 800;
            cursor: pointer;
        }

        .seat-btn.selected {
            background: var(--green-dark);
            border-color: var(--green-dark);
            color: #ffffff;
        }

        .seat-btn.disabled {
            border-color: #d1d5db;
            background: #e5e7eb;
            color: #6b7280;
            cursor: not-allowed;
        }

        .seat-btn.reserved {
            border-color: #fca5a5;
            background: #fee2e2;
            color: #b91c1c;
            cursor: not-allowed;
        }

        .reservation-card-body {
            padding: 22px;
        }

        .form-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
            margin-bottom: 16px;
        }

        .form-field label {
            display: block;
            font-size: 13px;
            font-weight: 800;
            color: #374151;
            margin-bottom: 6px;
        }

        .form-field input,
        .form-field textarea {
            width: 100%;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-field textarea {
            min-height: 100px;
            resize: vertical;
        }

        .selected-box {
            padding: 14px;
            border-radius: 12px;
            background: #f0f8f2;
            border: 1px solid #c8e2cf;
            color: var(--green-dark);
            font-weight: 800;
            margin-bottom: 16px;
        }

        .btn-area {
            display: flex;
            justify-content: flex-end;
            gap: 8px;
            margin-top: 18px;
        }

        .btn {
            height: 40px;
            border-radius: 999px;
            padding: 0 20px;
            font-weight: 800;
            cursor: pointer;
            border: none;
        }

        .btn-primary {
            background: #006b4f;
            color: #ffffff;
        }

        .btn-light {
            background: #66758d;
            color: #ffffff;
        }

        @media (max-width: 900px) {
            .main-shell {
                flex-direction: column;
            }

            .content-area {
                padding: 24px 18px 48px;
            }

            .reserve-layout {
                grid-template-columns: 1fr;
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }

        .time-table-card {
            margin-top: 16px;
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
        }

        .pf-time-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        .pf-time-table th {
            padding: 14px;
            border-bottom: 2px solid #0074d9;
            text-align: center;
            font-weight: 800;
        }

        .pf-time-table td {
            padding: 13px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }

        .time-available {
            color: #006b4f;
            font-weight: 800;
            cursor: pointer;
        }

        .time-reserved {
            color: #444;
        }

        .reservation-body{
            display:flex;
            gap:24px;
            margin-top:20px;
        }

        .time-panel{
            width:320px;
            background:#fff;
            border:1px solid #ddd;
            border-radius:14px;
            padding:20px;
        }

        .seat-panel{
            flex:1;
            background:#fff;
            border:1px solid #ddd;
            border-radius:14px;
            padding:20px;
        }

        .time-slot-list{
            margin-top:20px;
            display:flex;
            flex-direction:column;
            gap:10px;
        }

        .time-slot-btn{
            border:none;
            border-radius:10px;
            padding:12px;
            font-weight:700;
            cursor:pointer;
            background:#eef7f0;
            color:#006b4f;
        }

        .time-slot-btn.selected{
            background:#006b4f;
            color:#fff;
        }

        .empty-text{
            color:#777;
            font-size:14px;
        }

        .seat-grid{
            display:grid;
            grid-template-columns:repeat(4,1fr);
            gap:10px;
            margin-top:18px;
            margin-bottom:20px;
        }

        .purpose-textarea{
            width:100%;
            min-height:120px;
            border:1px solid #d1d5db;
            border-radius:10px;
            padding:12px;
            resize:none;
            box-sizing:border-box;
        }

        .reserve-btn{
            width:100%;
            height:46px;
            border:none;
            border-radius:12px;
            background:#006b4f;
            color:#fff;
            font-weight:800;
            margin-top:18px;
            cursor:pointer;
        }

        .reserve-btn:disabled{
            background:#cbd5d1;
            cursor:not-allowed;
        }
    </style>
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
                <a href="${pageContext.request.contextPath}/resident/publicFacility/reservation">편의시설예약</a>
                <span>›</span>
                <span class="cur">${facility.cmnFacilityNm} 예약</span>
            </div>

            <h1 class="page-title">${facility.cmnFacilityNm} 예약</h1>

            <div class="reserve-top-card">
                <div class="reserve-title">${facility.cmnFacilityNm} 예약</div>
                <div class="reserve-desc">
                    ${facility.cmnFacilityNm}의 예약 가능한 좌석 또는 세부시설을 선택한 뒤 예약 시간을 입력하세요.
                </div>
            </div>

<%--            <div class="reserve-layout">--%>

<%--                <div class="seat-map-card">--%>
<%--                    <div class="card-head">--%>
<%--                        <div class="card-title">${facility.cmnFacilityNm} 배치도</div>--%>
<%--                        <div class="card-desc">예약할 좌석 또는 세부시설을 선택하세요.</div>--%>
<%--                    </div>--%>

<%--                    <div class="seat-map-body">--%>
<%--                        <div class="seat-grid">--%>
<%--                            <c:forEach var="item" items="${itemList}">--%>
<%--                                <button type="button"--%>
<%--                                        class="seat-btn ${item.cmnFacilitySttsCd ne 'NORMAL' ? 'disabled' : ''}"--%>
<%--                                        data-item-no="${item.cmnFacilityItemNo}"--%>
<%--                                        data-item-name="${item.itemNm}"--%>
<%--                                    ${item.cmnFacilitySttsCd ne 'NORMAL' ? 'disabled' : ''}>--%>
<%--                                        ${item.itemNm}--%>
<%--                                </button>--%>
<%--                            </c:forEach>--%>

<%--                            <div class="time-table-card">--%>
<%--                                <div class="card-head">--%>
<%--                                    <div class="card-title">예약현황</div>--%>
<%--                                    <div class="card-desc">날짜와 세부시설을 선택하면 시간대별 예약현황이 표시됩니다.</div>--%>
<%--                                </div>--%>

<%--                                <table class="pf-time-table">--%>
<%--                                    <thead>--%>
<%--                                    <tr>--%>
<%--                                        <th>이용시간</th>--%>
<%--                                        <th>예약자</th>--%>
<%--                                        <th>상태</th>--%>
<%--                                    </tr>--%>
<%--                                    </thead>--%>
<%--                                    <tbody id="timeSlotBody">--%>
<%--                                    <tr>--%>
<%--                                        <td colspan="3">예약일과 세부시설을 선택하세요.</td>--%>
<%--                                    </tr>--%>
<%--                                    </tbody>--%>
<%--                                </table>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--                <div class="reservation-card">--%>
<%--                    <div class="card-head">--%>
<%--                        <div class="card-title">예약 정보 입력</div>--%>
<%--                        <div class="card-desc">날짜, 시간, 이용 목적을 입력한 뒤 예약을 신청하세요.</div>--%>
<%--                    </div>--%>

<%--                    <div class="reservation-card-body">--%>
<%--                        <form id="reserveForm">--%>
<%--                            <input type="hidden" name="cmnFacilityItemNo" id="cmnFacilityItemNo">--%>
<%--                            <input type="hidden" name="cmnFacilityNm" value="${facility.cmnFacilityNm}">--%>

<%--                            <div class="selected-box" id="selectedBox">--%>
<%--                                선택된 항목이 없습니다.--%>
<%--                            </div>--%>

<%--                            <div class="form-row">--%>
<%--                                <div class="form-field">--%>
<%--                                    <label>예약일</label>--%>
<%--                                    <input type="date" name="rsvtDt" id="rsvtDt" required>--%>
<%--                                </div>--%>

<%--                                <div class="form-field">--%>
<%--                                    <label>시작시간</label>--%>
<%--                                    <input type="time" id="startTime" required>--%>
<%--                                </div>--%>

<%--                                <div class="form-field">--%>
<%--                                    <label>종료시간</label>--%>
<%--                                    <input type="time" id="endTime" required>--%>
<%--                                </div>--%>
<%--                            </div>--%>

<%--                            <input type="hidden" name="rsvtBgngDttm" id="rsvtBgngDttm">--%>
<%--                            <input type="hidden" name="rsvtEndDttm" id="rsvtEndDttm">--%>

<%--                            <div class="form-field">--%>
<%--                                <label>이용 목적</label>--%>
<%--                                <textarea name="purposeCn" placeholder="이용 목적을 입력하세요."></textarea>--%>
<%--                            </div>--%>

<%--                            <div class="btn-area">--%>
<%--                                <button type="button"--%>
<%--                                        class="btn btn-light"--%>
<%--                                        onclick="location.href='${pageContext.request.contextPath}/resident/publicFacility/reservation'">--%>
<%--                                    목록으로--%>
<%--                                </button>--%>

<%--                                <button type="submit" class="btn btn-primary">--%>
<%--                                    예약 신청--%>
<%--                                </button>--%>
<%--                            </div>--%>
<%--                        </form>--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--            </div>--%>

            <div class="reservation-body">

                <!-- 왼쪽: 시간대 목록 -->
                <div class="time-panel">

                    <h3>이용시간 선택</h3>

                    <input type="date" id="rsvtDt" name="rsvtDt" />

                    <div id="timeSlotList" class="time-slot-list">
                        <p class="empty-text">
                            예약일을 선택하면 시간대가 표시됩니다.
                        </p>
                    </div>
                </div>

                <!-- 오른쪽: 좌석 선택 -->
                <div class="seat-panel">

                    <h3>좌석 선택</h3>

                    <div id="selectedTimeInfo" class="selected-box">
                        선택된 시간대가 없습니다.
                    </div>

                    <div id="seatGrid" class="seat-grid">

                        <c:forEach var="item" items="${itemList}">
                            <button type="button"
                                    class="seat-btn
                        ${item.cmnFacilitySttsCd ne 'NORMAL' ? 'disabled' : ''}"
                                    data-item-no="${item.cmnFacilityItemNo}"
                                    data-item-nm="${item.itemNm}"
                                ${item.cmnFacilitySttsCd ne 'NORMAL' ? 'disabled' : ''}>

                                    ${item.itemNm}

                            </button>
                        </c:forEach>

                    </div>

                    <label class="form-label">이용 목적</label>

                    <textarea id="purposeCn"
                              name="purposeCn"
                              class="purpose-textarea"
                              placeholder="이용 목적을 입력하세요."></textarea>

                    <button type="button"
                            id="reserveBtn"
                            class="reserve-btn"
                            disabled>
                        예약 신청
                    </button>

                </div>
            </div>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const cmnFacilityNo = '${facility.cmnFacilityNo}';

    const rsvtDtInput = document.getElementById('rsvtDt');
    const timeSlotList = document.getElementById('timeSlotList');
    const selectedTimeInfo = document.getElementById('selectedTimeInfo');
    const purposeCn = document.getElementById('purposeCn');
    const reserveBtn = document.getElementById('reserveBtn');

    let selectedStartDttm = '';
    let selectedEndDttm = '';
    let selectedItemNo = '';

    /*
     * 날짜 선택 시 시간대 목록 조회
     */
    function loadTimeSlotsByDate() {
        const rsvtDt = rsvtDtInput.value;

        selectedStartDttm = '';
        selectedEndDttm = '';
        selectedItemNo = '';

        selectedTimeInfo.innerText = '선택된 시간대가 없습니다.';
        reserveBtn.disabled = true;

        document.querySelectorAll('.seat-btn').forEach(btn => {
            btn.classList.remove('selected');
        });

        if (!rsvtDt) {
            timeSlotList.innerHTML = '<p class="empty-text">예약일을 선택하면 시간대가 표시됩니다.</p>';
            return;
        }

        fetch(contextPath + '/resident/publicFacility/reservation/' + cmnFacilityNo
            + '/time-slots?searchStartDt=' + encodeURIComponent(rsvtDt))
            .then(response => response.json())
            .then(list => {
                timeSlotList.innerHTML = '';

                if (!list || list.length === 0) {
                    timeSlotList.innerHTML = '<p class="empty-text">예약 가능한 시간대가 없습니다.</p>';
                    return;
                }

                list.forEach(row => {
                    const btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'time-slot-btn';
                    btn.innerText = row.timeLabel;

                    btn.addEventListener('click', function () {
                        document.querySelectorAll('.time-slot-btn').forEach(other => {
                            other.classList.remove('selected');
                        });

                        btn.classList.add('selected');

                        selectedStartDttm = row.rsvtBgngDttm;
                        selectedEndDttm = row.rsvtEndDttm;

                        selectedTimeInfo.innerText = '선택 시간: ' + row.timeLabel;

                        document.querySelectorAll('.seat-btn').forEach(seat => {
                            seat.classList.remove('selected');
                        });

                        selectedItemNo = '';
                        checkReserveButton();
                    });

                    timeSlotList.appendChild(btn);
                });
            })
            .catch(error => {
                console.error(error);
                timeSlotList.innerHTML = '<p class="empty-text">시간대 조회 중 오류가 발생했습니다.</p>';
            });
    }

    /*
     * 좌석 선택
     */
    document.querySelectorAll('.seat-btn').forEach(btn => {
        btn.addEventListener('click', function () {
            if (btn.classList.contains('disabled') || btn.disabled) {
                return;
            }

            if (!selectedStartDttm || !selectedEndDttm) {
                alert('먼저 이용시간을 선택하세요.');
                return;
            }

            document.querySelectorAll('.seat-btn').forEach(other => {
                other.classList.remove('selected');
            });

            btn.classList.add('selected');
            selectedItemNo = btn.dataset.itemNo;

            const selectedTimeBtn = document.querySelector('.time-slot-btn.selected');
            selectedTimeInfo.innerText =
                '선택 시간: ' + selectedTimeBtn.innerText
                + ' / 선택 좌석: ' + btn.dataset.itemNm;

            checkReserveButton();
        });
    });

    /*
     * 이용 목적 입력 여부까지 확인해서 버튼 활성화
     */
    function checkReserveButton() {
        reserveBtn.disabled = !(
            rsvtDtInput.value &&
            selectedStartDttm &&
            selectedEndDttm &&
            selectedItemNo &&
            purposeCn.value.trim()
        );
    }

    /*
     * 예약 신청
     */
    reserveBtn.addEventListener('click', function () {
        if (reserveBtn.disabled) {
            return;
        }

        const formData = new URLSearchParams();
        formData.append('cmnFacilityItemNo', selectedItemNo);
        formData.append('cmnFacilityNm', '${facility.cmnFacilityNm}');
        formData.append('rsvtBgngDttm', selectedStartDttm);
        formData.append('rsvtEndDttm', selectedEndDttm);
        formData.append('purposeCn', purposeCn.value.trim());

        fetch(contextPath + '/resident/publicFacility/reservation', {
            method: 'POST',
            body: formData
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('예약 처리 중 오류가 발생했습니다.');
                }
                return response.text();
            })
            .then(rsvtNo => {
                alert('예약 신청이 완료되었습니다. 예약번호: ' + rsvtNo);
                location.href = contextPath + '/resident/publicFacility/myReservation';
            })
            .catch(error => {
                alert(error.message);
            });
    });

    rsvtDtInput.addEventListener('change', loadTimeSlotsByDate);
    purposeCn.addEventListener('input', checkReserveButton);
</script>

</body>
</html>