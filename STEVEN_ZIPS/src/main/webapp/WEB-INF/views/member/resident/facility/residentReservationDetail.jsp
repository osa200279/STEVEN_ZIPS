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

            <div class="reserve-layout">

                <div class="seat-map-card">
                    <div class="card-head">
                        <div class="card-title">${facility.cmnFacilityNm} 배치도</div>
                        <div class="card-desc">예약할 좌석 또는 세부시설을 선택하세요.</div>
                    </div>

                    <div class="seat-map-body">
                        <div class="seat-grid">
                            <c:forEach var="item" items="${itemList}">
                                <button type="button"
                                        class="seat-btn ${item.cmnFacilitySttsCd ne 'NORMAL' ? 'disabled' : ''}"
                                        data-item-no="${item.cmnFacilityItemNo}"
                                        data-item-name="${item.itemNm}"
                                    ${item.cmnFacilitySttsCd ne 'NORMAL' ? 'disabled' : ''}>
                                        ${item.itemNm}
                                </button>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="reservation-card">
                    <div class="card-head">
                        <div class="card-title">예약 정보 입력</div>
                        <div class="card-desc">날짜, 시간, 이용 목적을 입력한 뒤 예약을 신청하세요.</div>
                    </div>

                    <div class="reservation-card-body">
                        <form id="reserveForm">
                            <input type="hidden" name="cmnFacilityItemNo" id="cmnFacilityItemNo">
                            <input type="hidden" name="cmnFacilityNm" value="${facility.cmnFacilityNm}">

                            <div class="selected-box" id="selectedBox">
                                선택된 항목이 없습니다.
                            </div>

                            <div class="form-row">
                                <div class="form-field">
                                    <label>예약일</label>
                                    <input type="date" name="rsvtDt" id="rsvtDt" required>
                                </div>

                                <div class="form-field">
                                    <label>시작시간</label>
                                    <input type="time" id="startTime" required>
                                </div>

                                <div class="form-field">
                                    <label>종료시간</label>
                                    <input type="time" id="endTime" required>
                                </div>
                            </div>

                            <input type="hidden" name="rsvtBgngDttm" id="rsvtBgngDttm">
                            <input type="hidden" name="rsvtEndDttm" id="rsvtEndDttm">

                            <div class="form-field">
                                <label>이용 목적</label>
                                <textarea name="purposeCn" placeholder="이용 목적을 입력하세요."></textarea>
                            </div>

                            <div class="btn-area">
                                <button type="button"
                                        class="btn btn-light"
                                        onclick="location.href='${pageContext.request.contextPath}/resident/publicFacility/reservation'">
                                    목록으로
                                </button>

                                <button type="submit" class="btn btn-primary">
                                    예약 신청
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>

        </div>
    </main>
</div>

<%@ include file="/WEB-INF/views/include/apt_footerLayout.jsp" %>

<script>
    const contextPath = '${pageContext.request.contextPath}';
    const cmnFacilityNo = '${facility.cmnFacilityNo}';

    const selectedBox = document.getElementById('selectedBox');
    const itemNoInput = document.getElementById('cmnFacilityItemNo');
    const rsvtDtInput = document.getElementById('rsvtDt');
    const startTimeInput = document.getElementById('startTime');
    const endTimeInput = document.getElementById('endTime');
    const bgngInput = document.getElementById('rsvtBgngDttm');
    const endInput = document.getElementById('rsvtEndDttm');

    document.querySelectorAll('.seat-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            if (btn.classList.contains('disabled') || btn.classList.contains('reserved')) {
                return;
            }

            document.querySelectorAll('.seat-btn').forEach(function(otherBtn) {
                otherBtn.classList.remove('selected');
            });

            btn.classList.add('selected');
            itemNoInput.value = btn.dataset.itemNo;
            selectedBox.innerText = '선택 항목: ' + btn.dataset.itemName;
        });
    });

    function loadReservedItems() {
        const rsvtDt = rsvtDtInput.value;
        const startTime = startTimeInput.value;
        const endTime = endTimeInput.value;

        if (!rsvtDt || !startTime || !endTime) {
            return;
        }

        const bgng = rsvtDt + ' ' + startTime;
        const end = rsvtDt + ' ' + endTime;

        bgngInput.value = bgng;
        endInput.value = end;

        fetch(contextPath + '/resident/publicFacility/reservation/' + cmnFacilityNo
            + '/reserved-items?rsvtBgngDttm=' + encodeURIComponent(bgng)
            + '&rsvtEndDttm=' + encodeURIComponent(end))
            .then(function(response) {
                return response.json();
            })
            .then(function(reservedList) {
                document.querySelectorAll('.seat-btn').forEach(function(btn) {
                    btn.classList.remove('reserved');

                    if (!btn.classList.contains('disabled')) {
                        btn.disabled = false;
                    }

                    if (reservedList.includes(btn.dataset.itemNo)) {
                        btn.classList.remove('selected');
                        btn.classList.add('reserved');
                        btn.disabled = true;

                        if (itemNoInput.value === btn.dataset.itemNo) {
                            itemNoInput.value = '';
                            selectedBox.innerText = '선택된 항목이 없습니다.';
                        }
                    }
                });
            });
    }

    rsvtDtInput.addEventListener('change', loadReservedItems);
    startTimeInput.addEventListener('change', loadReservedItems);
    endTimeInput.addEventListener('change', loadReservedItems);

    document.getElementById('reserveForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const rsvtDt = rsvtDtInput.value;
        const startTime = startTimeInput.value;
        const endTime = endTimeInput.value;

        if (!itemNoInput.value) {
            alert('예약할 좌석 또는 세부시설을 선택하세요.');
            return;
        }

        if (!rsvtDt || !startTime || !endTime) {
            alert('예약일과 시간을 입력하세요.');
            return;
        }

        bgngInput.value = rsvtDt + ' ' + startTime;
        endInput.value = rsvtDt + ' ' + endTime;

        fetch(contextPath + '/resident/publicFacility/reservation', {
            method: 'POST',
            body: new URLSearchParams(new FormData(this))
        })
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('예약 처리 중 오류가 발생했습니다.');
                }
                return response.text();
            })
            .then(function(rsvtNo) {
                alert('예약 신청이 완료되었습니다. 예약번호: ' + rsvtNo);
                location.href = contextPath + '/resident/publicFacility/myReservation';
            })
            .catch(function(error) {
                alert(error.message);
            });
    });
</script>

</body>
</html>