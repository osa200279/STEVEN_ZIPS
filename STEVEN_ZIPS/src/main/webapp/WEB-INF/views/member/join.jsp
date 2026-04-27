
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${editMode}">회원정보 수정</c:when><c:otherwise>회원가입</c:otherwise></c:choose></title>
    <style>
        body {
            background-color: #f7f5ee;
            font-family: "Malgun Gothic", sans-serif;
            padding: 40px;
            color: #333;
            margin: 0;
        }
        .header { margin-bottom: 30px; }
        .badge {
            background: #e9e6d7;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            color: #7a745c;
            font-weight: bold;
        }
        h2 { font-size: 32px; margin: 15px 0; letter-spacing: -1px; }
        .desc { color: #888; font-size: 14px; line-height: 1.5; }
        .info-box {
            background: #fcf9f0;
            border: 1px solid #eae2c8;
            padding: 15px;
            border-radius: 8px;
            font-size: 13px;
            color: #8b8365;
            margin: 25px 0;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: bold;
            font-size: 15px;
            margin-bottom: 8px;
        }
        .form-label span { color: #c0392b; margin-left: 3px; }
        .input-control {
            width: 100%;
            box-sizing: border-box;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            background-color: #fff;
        }
        .input-control:focus { border-color: #7ba131; }
        .input-hint {
            font-size: 12px;
            color: #aaa;
            margin-top: 5px;
        }
        .profile-section { margin-bottom: 30px; }
        .profile-flex { display: flex; align-items: flex-start; gap: 20px; }
        .photo-preview {
            width: 100px;
            height: 120px;
            background: #fff;
            border: 1px solid #eae2c8;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #aaa;
        }
        .photo-btn {
            background: #ffaa76;
            border: none;
            padding: 10px 18px;
            border-radius: 5px;
            cursor: pointer;
            color: #7a745c;
            font-weight: bold;
            font-size: 14px;
        }
        .tel-area {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 0;
            padding-bottom: 8px;
        }
        .btn-area {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 40px;
            padding-bottom: 20px;
        }
        .btn-submit {
            background: #7ba131;
            color: white;
            border: none;
            padding: 15px 60px;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            font-size: 16px;
        }
        .btn-cancel {
            background: white;
            border: 1px solid #ddd;
            padding: 15px 60px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
        }
    </style>
</head>
<body>
<div class="header">
    <span class="badge">
        <c:choose>
            <c:when test="${editMode}">수정 모드</c:when>
            <c:otherwise>가입 모드</c:otherwise>
        </c:choose>
    </span>
    <h2>
        <c:choose>
            <c:when test="${editMode}">회원정보 수정</c:when>
            <c:otherwise>회원가입</c:otherwise>
        </c:choose>
    </h2>
    <p class="desc">
        <c:choose>
            <c:when test="${editMode}">현재 회원 정보가 아래에 미리 입력되어 있습니다.</c:when>
            <c:otherwise>신규 회원 등록을 위해 아래 폼을 입력하세요.</c:otherwise>
        </c:choose>
    </p>
</div>

<div class="info-box">
    <c:choose>
        <c:when test="${editMode}">회원 정보 수정 화면입니다. 비밀번호는 빈칸으로 표시됩니다.</c:when>
        <c:otherwise>회원가입 후 회원 서비스를 이용할 수 있습니다.</c:otherwise>
    </c:choose>
</div>

<form action="${pageContext.request.contextPath}${editMode ? '/member/update' : '/member/join'}" id="joinForm" method="post" enctype="multipart/form-data">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <input type="hidden" name="userNo" value="${member.userNo}">

    <div class="profile-section">
        <div class="form-label">프로필 사진</div>
        <div class="profile-flex">
            <div class="photo-preview" id="preview">미리보기</div>
            <div>
                <button type="button" class="photo-btn" onclick="document.getElementById('fileInput').click();">사진 선택</button>
                <input type="file" id="fileInput" name="profilePic" style="display:none;">
                <div id="fileName" class="input-hint">선택된 파일 없음</div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="form-label">아이디<span>*</span></div>
        <input type="text" name="userId" class="input-control" value="${member.userId}" placeholder="아이디를 입력하세요" ${editMode ? 'readonly' : ''}>
        <div class="input-hint">영문, 숫자 조합 4~20자 권장</div>
    </div>

    <div class="form-group">
        <div class="form-label">비밀번호 <span>*</span></div>
        <input type="password" name="userPw" class="input-control" value="" placeholder="비밀번호를 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">비밀번호 확인 <span>*</span></div>
        <input type="password" name="userPwConfirm" class="input-control" value="" placeholder="비밀번호를 다시 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">이름 <span>*</span></div>
        <input type="text" name="userNm" class="input-control" value="${member.userNm}" placeholder="이름을 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">주민등록번호 <span>*</span></div>
        <input type="text" name="userRrno" class="input-control" value="${member.userRrno}" placeholder="주민등록번호를 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">연락처<span>*</span></div>
        <div class="tel-area">
            <select id="tel1" class="input-control">
                <option value="010">010</option>
                <option value="011">011</option>
                <option value="016">016</option>
                <option value="017">017</option>
                <option value="018">018</option>
                <option value="019">019</option>
            </select>
            -
            <input type="text" class="input-control" id="tel2">
            -
            <input type="text" class="input-control" id="tel3">
        </div>
        <input type="hidden" id="userTelno" name="userTelno" value="${member.userTelno}">
    </div>

    <div class="form-group">
        <div class="form-label">이메일<span>*</span></div>
        <input type="email" name="userEml" class="input-control" value="${member.userEml}" placeholder="이메일을 입력하세요">
    </div>

    <div class="btn-area">
        <button type="submit" class="btn-submit" id="memRegBtn">
            <c:choose>
                <c:when test="${editMode}">정보수정</c:when>
                <c:otherwise>회원가입</c:otherwise>
            </c:choose>
        </button>
        <button type="button" class="btn-cancel" onclick="history.back()">취소</button>
    </div>
</form>

<script>
    window.addEventListener('DOMContentLoaded', function () {
        const tel1 = document.getElementById('tel1');
        const tel2 = document.getElementById('tel2');
        const tel3 = document.getElementById('tel3');
        const userTelno = document.getElementById('userTelno');
        const fileInput = document.getElementById('fileInput');
        const fileName = document.getElementById('fileName');
        const joinForm = document.getElementById('joinForm');

<<<<<<< .mine
        if (userTelno.value) {
            const tel = userTelno.value.replace(/[^0-9]/g, '');
            if (tel.length >= 10) {
                tel1.value = tel.substring(0, 3);
                if (tel.length === 10) {
                    tel2.value = tel.substring(3, 6);
                    tel3.value = tel.substring(6);
                } else {
                    tel2.value = tel.substring(3, 7);
                    tel3.value = tel.substring(7);
                }
||||||| .r509400
    const memRegBtn = document.querySelector("#memRegBtn");
    // 회원등록 버튼 클릭 이벤트
    memRegBtn.addEventListener("click", (e) => {
        e.preventDefault();
        const form = document.querySelector("#joinForm");

        let tel1box = document.querySelector('#tel1');
        let tel1 = tel1box.options[tel1box.selectedIndex].value;
        let tel2 = document.querySelector('#tel2').value;
        let tel3 = document.querySelector('#tel3').value;
        let userTelno = document.querySelector('#userTelno');
        userTelno.value = tel1 + tel2 + tel3;

        // 인풋 별 정규식 및 안내문구 설정
        const validationRules = {
            userId : {
                label : "아이디",
                regex : /^[a-zA-Z0-9]{4,20}$/,
                invalidMsg : "아이디는 영문, 숫자 조합 4~20자로 입력해주세요."
            },
            userPw : {
                label : "비밀번호",
                regex : /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[^a-zA-Z0-9가-힣\s])[^가-힣\s]{8,20}$/,  // ( ?= )전방 탐색, 공백, 한글 검사
                invalidMsg : "비밀번호는 영문, 숫자, 특수문자 조합 8~20자로 입력해주세요."
            },
            userNm : {
                label : "이름",
                regex : /^[가-힣]{2,10}$/,
                invalidMsg : "이름은 한글로 작성해주세요"
            },
            userRrno : {
                label : "주민등록번호",
                regex : /^[0-9]{6}-[0-9]{7}$/,  // 형식 000000-0000000
                invalidMsg : "주민등록번호 형식이 올바르지 않습니다."
            },
            userTelno : {
                label : "전화번호",
                regex : /^[0-9]{10,11}$/,
                invalidMsg : "전화번호는 10~11자리 숫자입니다."
            },
            userEml : {
                label : "이메일",
                regex : /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                invalidMsg : "올바른 이메일 형식이 아닙니다."
=======
    const memRegBtn = document.querySelector("#memRegBtn");
    // 회원등록 버튼 클릭 이벤트
    memRegBtn.addEventListener("click", async (e) => {
        e.preventDefault();
        const form = document.querySelector("#joinForm");

        let tel1box = document.querySelector('#tel1');
        let tel1 = tel1box.options[tel1box.selectedIndex].value;
        let tel2 = document.querySelector('#tel2').value;
        let tel3 = document.querySelector('#tel3').value;
        let userTelno = document.querySelector('#userTelno');
        userTelno.value = tel1 + tel2 + tel3;

        // 인풋 별 정규식 및 안내문구 설정
        const validationRules = {
            userId : {
                label : "아이디",
                regex : /^[a-zA-Z0-9]{4,20}$/,
                invalidMsg : "아이디는 영문, 숫자 조합 4~20자로 입력해주세요."
            },
            userPw : {
                label : "비밀번호",
                regex : /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[^a-zA-Z0-9가-힣\s])[^가-힣\s]{8,20}$/,  // ( ?= )전방 탐색, 공백, 한글 검사
                invalidMsg : "비밀번호는 영문, 숫자, 특수문자 조합 8~20자로 입력해주세요."
            },
            userNm : {
                label : "이름",
                regex : /^[가-힣]{2,10}$/,
                invalidMsg : "이름은 한글로 작성해주세요"
            },
            userRrno : {
                label : "주민등록번호",
                regex : /^[0-9]{6}-[0-9]{7}$/,  // 형식 000000-0000000
                invalidMsg : "주민등록번호 형식이 올바르지 않습니다."
            },
            userTelno : {
                label : "전화번호",
                regex : /^[0-9]{10,11}$/,
                invalidMsg : "전화번호는 10~11자리 숫자입니다."
            },
            userEml : {
                label : "이메일",
                regex : /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                invalidMsg : "올바른 이메일 형식이 아닙니다."
>>>>>>> .r509403
            }
<<<<<<< .mine
||||||| .r509400
        };

        // 유효성 체크
        for (const [inputName, rule] of Object.entries(validationRules)) {
            const input = form.elements[inputName];
            if(!input) continue;

            const value = input.value.trim();

            // 미입력 체크
            if(!value){
                alert(`\${rule.label}을(를) 입력해주세요.`);
                console.log(rule.label);
                input.focus();
                return false;
            }

            // 정규식 체크 :: 일치 true, 불일치 false
            if(rule.regex && !rule.regex.test(value)){
                alert(rule.invalidMsg);
                input.focus();
                return false;
            }

=======
        };

        // 유효성 체크
        for (const [inputName, rule] of Object.entries(validationRules)) {
            const input = form.elements[inputName];
            if(!input) continue;

            const value = input.value.trim();

            // 미입력 체크
            if(!value){
                alert(`\${rule.label}을(를) 입력해주세요.`);
                console.log(rule.label);
                input.focus();
                return;
            }

            // 정규식 체크 :: 일치 true, 불일치 false
            if(rule.regex && !rule.regex.test(value)){
                alert(rule.invalidMsg);
                input.focus();
                return;
            }

>>>>>>> .r509403
        }

<<<<<<< .mine
        fileInput.addEventListener('change', function () {
            fileName.textContent = this.files.length > 0 ? this.files[0].name : '선택된 파일 없음';
        });
||||||| .r509400
        // 비밀번호 확인 일치여부
        if(form.userPw.value !== form.userPwConfirm.value ) {
            alert("비밀번호가 일치하지 않습니다.");
            form.userPwConfirm.focus();
            return false;
        }
=======
        // 비밀번호 확인 일치여부
        if(form.userPw.value !== form.userPwConfirm.value ) {
            alert("비밀번호가 일치하지 않습니다.");
            form.userPwConfirm.focus();
            return;
        }
>>>>>>> .r509403

<<<<<<< .mine
        joinForm.addEventListener('submit', function () {
            userTelno.value = tel1.value + tel2.value + tel3.value;
        });
||||||| .r509400
        alert("회원가입 성공!");
        form.submit();
=======
        try{
            const formData = new FormData(form);

        }catch (err){
            console.error("통신 에러 발생 : ", err);
            alert("서버와 통신 중 문제가 발생했습니다.")
        }


>>>>>>> .r509403
    });
</script>
</body>
</html>

