<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>아파트 호 일괄 관리</title>

    <sec:csrfMetaTags/>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />

    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;600;700;800&display=swap" rel="stylesheet" />

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20,400,1,0" rel="stylesheet" />

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/office-layout.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/manager/manager-common.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/mgmtOfc/mngr_complex_edit.css">
</head>

<body>

<div class="app-wrapper">

    <%@ include file="/WEB-INF/views/include/office_sidebar.jsp" %>

    <div class="main-wrap">

        <%@ include file="/WEB-INF/views/include/office_header.jsp" %>

        <main class="main-content">

            <div class="office-page unit-manage-page">

                <!-- =====================================================
                     메인 컨텐츠
                ===================================================== -->
                <div class="unit-manage-wrap">

                    <!-- =====================================================
                         상단 구조 설정
                    ====================================================== -->
                    <section class="unit-top-panel">

                        <div class="unit-top-header">

                            단지 구조를 설정할 수 있는 필드 등 선택하고
                            총수와 층별 세대수를 설정 할 수 있다.

                        </div>

                        <div class="unit-top-grid">

                            <div class="form-field">

                                <label class="field-label">
                                    동 선택
                                </label>

                                <select class="form-select">

                                    <option>
                                        101동
                                    </option>

                                    <option>
                                        102동
                                    </option>

                                </select>

                            </div>

                            <div class="form-field">

                                <label class="field-label">
                                    총 층수
                                </label>

                                <input type="number"
                                       class="form-input"
                                       value="15">

                            </div>

                            <div class="form-field">

                                <label class="field-label">
                                    층별 세대수
                                </label>

                                <input type="number"
                                       class="form-input"
                                       value="5">

                            </div>

                            <div class="form-field">

                                <label class="field-label">
                                    현재 세대수
                                </label>

                                <input type="text"
                                       class="form-input"
                                       value="75세대"
                                       readonly>

                            </div>

                            <div class="unit-top-actions">

                                <button type="button"
                                        class="btn btn-secondary">

                                    새로고침

                                </button>

                                <button type="button"
                                        class="btn btn-primary">

                                    구조 변경 적용

                                </button>

                            </div>

                        </div>

                    </section>

                    <!-- =====================================================
                         메인 영역
                    ====================================================== -->
                    <section class="unit-main-grid">

                        <!-- =====================================================
                             좌측 층별 배치도
                        ====================================================== -->
                        <div class="unit-layout-panel">

                            <div class="unit-panel-title">

                                층별 배치도 삽입

                            </div>

                            <div class="unit-layout-grid">

                                <!-- 나중에 JS 반복 -->

                                <div class="unit-floor-row">

                                    <div class="unit-floor-label">
                                        15F
                                    </div>

                                    <div class="unit-cell selected">
                                        1501
                                    </div>

                                    <div class="unit-cell">
                                        1502
                                    </div>

                                    <div class="unit-cell">
                                        1503
                                    </div>

                                    <div class="unit-cell disabled">
                                        1504
                                    </div>

                                    <div class="unit-cell">
                                        1505
                                    </div>

                                </div>

                                <div class="unit-floor-row">

                                    <div class="unit-floor-label">
                                        14F
                                    </div>

                                    <div class="unit-cell">
                                        1401
                                    </div>

                                    <div class="unit-cell live">
                                        1402
                                    </div>

                                    <div class="unit-cell empty">
                                        1403
                                    </div>

                                    <div class="unit-cell">
                                        1404
                                    </div>

                                    <div class="unit-cell">
                                        1405
                                    </div>

                                </div>

                            </div>

                        </div>

                        <!-- =====================================================
                             우측 테이블 영역
                        ====================================================== -->
                        <div class="unit-table-panel">

                            <!-- 상단 액션 -->
                            <div class="unit-table-top">

                                <div class="unit-table-actions">

                                    <button type="button"
                                            class="btn btn-secondary">

                                        선택 호 비활성화

                                    </button>

                                    <button type="button"
                                            class="btn btn-secondary">

                                        선택 호 활성화

                                    </button>

                                </div>

                                <div class="unit-bulk-type">

                                    <select class="form-select">

                                        <option>
                                            84A
                                        </option>

                                        <option>
                                            84B
                                        </option>

                                        <option>
                                            59A
                                        </option>

                                    </select>

                                    <button type="button"
                                            class="btn btn-primary">

                                        평형 일괄 적용

                                    </button>

                                </div>

                            </div>

                            <!-- 필터 영역 -->
                            <div class="unit-filter-box">

                                ag-grid 로 필터

                            </div>

                            <!-- AG GRID 영역 -->
                            <div class="unit-table-area">

                                <div class="unit-table-placeholder">

                                    아파트 호 목록 가져오기

                                </div>

                            </div>

                        </div>

                    </section>

                </div>

            </div>

        </main>

    </div>

</div>

<script src="${pageContext.request.contextPath}/js/mgmtOfc/mngr_complex_edit.js"></script>

</body>
</html>