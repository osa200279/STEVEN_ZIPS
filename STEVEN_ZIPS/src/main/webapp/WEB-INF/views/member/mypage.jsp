<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        .toggle {
            width: 42px;
            height: 22px;
            appearance: none;
            background: #d1d5db;
            border-radius: 9999px;
            position: relative;
            cursor: pointer;
            transition: all 0.3s;
        }
        .toggle:checked { background: #16a34a; }
        .toggle::before {
            content: "";
            width: 18px;
            height: 18px;
            background: #fff;
            border-radius: 50%;
            position: absolute;
            top: 2px;
            left: 2px;
            transition: 0.3s;
        }
        .toggle:checked::before {
            transform: translateX(20px);
        }
    </style>

</head>

<body class="bg-gray-50">

<div class="max-w-6xl mx-auto p-8">

    <!-- 상단 -->
    <div class="flex justify-between items-center mb-8">
        <div>
            <h1 class="text-3xl font-bold">마이페이지</h1>
            <p class="text-gray-500">회원 정보 확인</p>
        </div>

        <div class="bg-green-100 text-green-700 px-4 py-2 rounded-full font-semibold">
            이용중
        </div>
    </div>

    <div class="grid grid-cols-3 gap-6">

        <!-- 좌측 프로필 -->
        <div class="bg-white rounded-2xl p-5 shadow-sm">

            <div class="w-24 h-24 mx-auto rounded-full bg-green-100 flex items-center justify-center text-2xl font-bold text-green-700">
                ${fn:substring(member.userNm,0,1)}
            </div>

            <h2 class="text-center text-xl font-bold mt-4">
                ${member.userNm}
            </h2>

            <p class="text-center text-gray-500 text-sm">
                가입일: <fmt:formatDate value="${member.regDt}" pattern="yyyy-MM-dd"/>
            </p>

            <div class="border-t mt-6 pt-4 grid grid-cols-2 text-center">
                <div>
                    <p class="text-gray-400 text-xs">회원번호</p>
                    <p class="font-semibold">${member.userNo}</p>
                </div>
                <div>
                    <p class="text-gray-400 text-xs">회원구분</p>
                    <p class="font-semibold">
                        <c:choose>
                            <c:when test="${role=='ROLE_ADMIN'}">관리자</c:when>
                            <c:when test="${role=='ROLE_RESIDENT'}">입주민</c:when>
                            <c:otherwise>사용자</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>


        </div>

        <!-- 우측 -->
        <div class="col-span-2 space-y-6">

            <!-- 기본 정보 -->
            <div class="bg-white rounded-2xl shadow-sm">
                <div class="px-6 py-4 border-b font-semibold">기본 정보</div>

                <div class="grid grid-cols-2 gap-6 p-6">
                    <div><p class="text-gray-400 text-xs">이름</p>${member.userNm}</div>
                    <div><p class="text-gray-400 text-xs">아이디</p>${member.userId}</div>
                    <div><p class="text-gray-400 text-xs">이메일</p>${member.userEml}</div>
                    <div><p class="text-gray-400 text-xs">연락처</p>${member.userTelno}</div>
                    <div><p class="text-gray-400 text-xs">주민번호</p>${member.userRrno}</div>
                    <div><p class="text-gray-400 text-xs">프로필ID</p>${member.profFileId}</div>
                </div>
            </div>

            <!-- 🔥 알림 설정 -->
            <div>

                <!-- SMS 수신 (부모) -->
                <!-- 🔥 알림 설정 -->
                <div class="bg-white rounded-2xl shadow-sm divide-y">

                    <!-- SMS 전체 -->
                    <div class="px-6 py-5">

                        <!-- 부모 -->
                        <div class="flex justify-between items-center mb-4">
                            <div>
                                <p class="font-semibold">문자 알림</p>
                                <p class="text-sm text-gray-400">긴급 알림 수신</p>
                            </div>
                            <input type="checkbox"
                                   id="smsRcv"
                                   name="smsRcvYn"
                                   class="toggle"
                            ${smsRcv ? "checked":""}>
                        </div>

                        <!-- 자식 -->
                        <div class="ml-6 space-y-4">

                            <!-- 공지 -->
                            <div class="flex justify-between items-center">
                                <div>
                                    <p class="font-medium">공지사항 알림</p>
                                    <p class="text-xs text-gray-400">관리사무소 공지</p>
                                </div>
                                <input type="checkbox"
                                       class="toggle sms-child"
                                       name="smsNtcRcvYn"
                                ${smsNtcRcv ? "checked":""}>
                            </div>

                            <!-- 계약 -->
                            <div class="flex justify-between items-center">
                                <div>
                                    <p class="font-medium">계약 상태 알림</p>
                                    <p class="text-xs text-gray-400">신청 상태 변경</p>
                                </div>
                                <input type="checkbox"
                                       class="toggle sms-child"
                                       name="smsCtrtRcvYn"
                                ${smsCtrtRcv ? "checked":""}>
                            </div>

                        </div>
                    </div>

                    <!-- 이메일 전체 -->
                    <div class="px-6 py-5">

                        <!-- 부모 -->
                        <div class="flex justify-between items-center mb-4">
                            <div>
                                <p class="font-semibold">이메일 알림</p>
                                <p class="text-sm text-gray-400">상세 안내 수신</p>
                            </div>
                            <input type="checkbox"
                                   id="emlRcv"
                                   name="emlRcvYn"
                                   class="toggle"
                            ${emlRcv ? "checked":""}>
                        </div>

                        <!-- 자식 -->
                        <div class="ml-6 space-y-4">

                            <!-- 공지 -->
                            <div class="flex justify-between items-center">
                                <div>
                                    <p class="font-medium">공지사항 알림</p>
                                    <p class="text-xs text-gray-400">이메일 공지</p>
                                </div>
                                <input type="checkbox"
                                       class="toggle eml-child"
                                       name="emlNtcRcvYn"
                                ${emlNtcRcv ? "checked":""}>
                            </div>

                            <!-- 계약 -->
                            <div class="flex justify-between items-center">
                                <div>
                                    <p class="font-medium">계약 상태 알림</p>
                                    <p class="text-xs text-gray-400">이메일 상태 변경</p>
                                </div>
                                <input type="checkbox"
                                       class="toggle eml-child"
                                       name="emlCtrtRcvYn"
                                ${emlCtrtRcv ? "checked":""}>
                            </div>

                        </div>
                    </div>

                </div>
<!-- 하단 버튼 -->
<div class="flex justify-end gap-3 mt-6">

    <a href="${pageContext.request.contextPath}/member/edit.do"
       class="px-5 py-2 bg-green-700 text-white rounded-lg">
        수정하기
    </a>

    <a href="${pageContext.request.contextPath}/member/password"
       class="px-5 py-2 bg-gray-600 text-white rounded-lg">
        비밀번호 변경
    </a>

    <form action="${pageContext.request.contextPath}/member/delete"
          method="post"
          onsubmit="return confirm('정말 탈퇴하시겠습니까?');">

        <button type="submit"
                class="px-5 py-2 border border-red-600 text-red-600 rounded-lg">
            탈퇴하기
        </button>
    </form>
</div>

</div>
</body>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        const smsParent = document.getElementById("smsRcv");
        const smsChildren = document.querySelectorAll(".sms-child");

        function updateSmsChildren() {
            if (!smsParent.checked) {
                smsChildren.forEach(ch => {
                    ch.checked = false;   // 🔥 자식 OFF
                    ch.disabled = true;   // 🔥 클릭 못하게
                });
            } else {
                smsChildren.forEach(ch => {
                    ch.disabled = false;  // 🔥 다시 활성화
                });
            }
        }

        // 부모 변경 시 실행
        smsParent.addEventListener("change", updateSmsChildren);

        // 처음 화면 로딩 시 적용
        updateSmsChildren();
    });

    function updateAlarmSetting() {

        const data = {
            smsRcvYn: document.getElementById("smsRcv").checked ? 'Y' : 'N',
            smsNtcRcvYn: document.querySelector("[name=smsNtcRcvYn]").checked ? 'Y' : 'N',
            smsCtrtRcvYn: document.querySelector("[name=smsCtrtRcvYn]").checked ? 'Y' : 'N'
        };

        fetch("/member/alarm/update", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(data)
        })
            .then(res => res.text())
            .then(res => console.log("저장 완료:", res))
            .catch(err => console.error(err));
    }

    document.querySelectorAll("input[type=checkbox]").forEach(cb => {
        cb.addEventListener("change", updateAlarmSetting);
    });
</script>
</html>