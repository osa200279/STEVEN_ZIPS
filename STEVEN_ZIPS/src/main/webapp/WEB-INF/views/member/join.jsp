<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="/js/common/file-util.js"></script>

    <title>회원가입 팝업</title>
    <style>
        /* 전체 배경 및 폰트 설정 */
        body {
            background-color: #F7F5EE;
            font-family: 'Malgun Gothic', sans-serif;
            padding: 40px;
            color: #333;
            margin: 0;
        }

        /* 상단 헤더 영역 */
        .header {
            margin-bottom: 30px;
        }

        .badge {
            background: #E9E6D7;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            color: #7A745C;
            font-weight: bold;
        }

        h2 {
            font-size: 32px;
            margin: 15px 0;
            letter-spacing: -1px;
        }

        .desc {
            color: #888;
            font-size: 14px;
            line-height: 1.5;
        }

        /* 안내 박스 */
        .info-box {
            background: #FCF9F0;
            border: 1px solid #EAE2C8;
            padding: 15px;
            border-radius: 8px;
            font-size: 13px;
            color: #8B8365;
            margin: 25px 0;
        }

        /* 입력 폼 구조 */
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

        .form-label span {
            color: #C0392B;
            margin-left: 3px;
        }

        .input-control {
            width: 100%;
            box-sizing: border-box;
            padding: 15px;
            border: 1px solid #DDD;
            border-radius: 10px;
            font-size: 14px;
            outline: none;
            background-color: #FFF;
        }

        .input-control:focus {
            border-color: #7BA131;
        }

        .input-hint {
            font-size: 12px;
            color: #AAA;
            margin-top: 5px;
        }

        /* 프로필 사진 섹션 */
        .profile-section {
            margin-bottom: 30px;
        }

        .profile-flex {
            display: flex;
            align-items: flex-start;
            gap: 20px;
        }

        .photo-preview {
            width: 100px;
            height: 120px;
            background: #FFF;
            border: 1px solid #EAE2C8;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: #AAA;
        }

        .photo-btn {
            background: #ffaa76;
            border: none;
            padding: 10px 18px;
            border-radius: 5px;
            cursor: pointer;
            color: #7A745C;
            font-weight: bold;
            font-size: 14px;
        }

        .tel-area {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 0px;
            padding-bottom: 8px;
        }

        /* 하단 버튼 영역 */
        .btn-area {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 40px;
            padding-bottom: 20px;
        }

        .btn-submit {
            background: #7BA131;
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
            border: 1px solid #DDD;
            padding: 15px 60px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
        }
    </style>
</head>
<body>
<div class="header">
    <span class="badge">일반사용자</span>
    <h2>회원가입</h2>
    <p class="desc">기본 서비스 이용을 위한 일반 사용자 회원가입 화면입니다.<br>이후 입주 신고를 통해 입주민 권한으로 변경할 수 있습니다.</p>
</div>

<div class="info-box">
    회원가입 후 일부 공용 서비스 이용이 가능합니다. 입주민 전용 기능은 입주민 인증 완료 후 사용할 수 있습니다.
</div>

<form action="/member/join" id="joinForm" method="post" enctype="multipart/form-data">

    <div class="profile-section">
        <div class="form-label">프로필 사진</div>
        <div class="profile-flex">
            <div class="photo-preview" id="preview">
                  미리보기
            </div>
            <div>
                <button type="button" class="photo-btn" onclick="document.getElementById('img').click();">
                    사진 선택
                </button>
                <input type="file" id="img" name="profFileId" style="display:none;">
                <div id="fileName" class="input-hint">선택된 파일 없음</div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="form-label">아이디 <span>*</span></div>
        <input type="text" name="userId" class="input-control" placeholder="아이디를 입력하세요">
        <div class="input-hint">영문, 숫자 조합 4~20자 권장</div>
    </div>

    <div class="form-group">
        <div class="form-label">비밀번호 <span>*</span></div>
        <input type="password" name="userPw" class="input-control" placeholder="비밀번호를 입력하세요">
        <div class="input-hint">비밀번호는 영문, 숫자, 특수문자 조합 8~20자로 입력해주세요</div>
    </div>

    <div class="form-group">
        <div class="form-label">비밀번호 확인 <span>*</span></div>
        <input type="password" name="userPwConfirm" class="input-control" placeholder="비밀번호를 다시 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">이름 <span>*</span></div>
        <input type="text" name="userNm" class="input-control" placeholder="이름을 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">주민등록번호 <span>*</span></div>
        <input type="text" name="userRrno" class="input-control" placeholder="주민등록 번호를 입력하세요">
        <div class="input-hint">예시 000000-0000000</div>
    </div>

    <div class="form-group">
        <div class="form-label">연락처 <span>*</span></div>
        <div class="tel-area">
            <select id="tel1" class="input-control">
                <option value="010" selected>010</option>
                <option value="011">011</option>
                <option value="016">016</option>
                <option value="017">017</option>
                <option value="018">018</option>
                <option value="019">019</option>
            </select>
            -
            <input type="text" class="input-control" id="tel2"/>
            -
            <input type="text" class="input-control" id="tel3"/>
        </div>
        <input type="text" name="userTelno" id="userTelno" hidden="hidden">
    </div>

    <div class="form-group">
        <div class="form-label">이메일 <span>*</span></div>
        <input type="email" name="userEml" class="input-control" placeholder="이메일을 입력하세요">
    </div>

    <%-- 토큰 추가 --%>
    <sec:csrfInput/>
    <div class="btn-area">
        <button type="submit" class="btn-submit" id="memRegBtn">회원등록</button>
        <button type="button" class="btn-cancel" onclick="window.close()">취소</button>
    </div>
</form>

<script type="module">
document.addEventListener('DOMContentLoaded', function () {

    // 회원등록 버튼 클릭 이벤트
    const memRegBtn = document.querySelector("#memRegBtn");
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
            userId: {
                label: "아이디",
                regex: /^[a-zA-Z0-9]{4,20}$/,
                invalidMsg: "아이디는 영문, 숫자 조합 4~20자로 입력해주세요."
            },
            userPw: {
                label: "비밀번호",
                regex: /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[^a-zA-Z0-9가-힣\s])[^가-힣\s]{8,20}$/,  // ( ?= )전방 탐색, 공백, 한글 검사
                invalidMsg: "비밀번호는 영문, 숫자, 특수문자 조합 8~20자로 입력해주세요."
            },
            userNm: {
                label: "이름",
                regex: /^[가-힣]{2,10}$/,
                invalidMsg: "이름은 한글로 작성해주세요"
            },
            userRrno: {
                label: "주민등록번호",
                regex: /^[0-9]{6}-[0-9]{7}$/,  // 형식 000000-0000000
                invalidMsg: "주민등록번호 형식이 올바르지 않습니다."
            },
            userTelno: {
                label: "전화번호",
                regex: /^[0-9]{10,11}$/,
                invalidMsg: "전화번호는 10~11자리 숫자입니다."
            },
            userEml: {
                label: "이메일",
                regex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
                invalidMsg: "올바른 이메일 형식이 아닙니다."
            }
        };

        // 유효성 체크
        for (const [inputName, rule] of Object.entries(validationRules)) {
            const input = form.elements[inputName];
            if (!input) continue;

            const value = input.value.trim();

            // 미입력 체크
            if (!value) {
                alert(`\${rule.label}을(를) 입력해주세요.`);
                console.log(rule.label);
                input.focus();
                return;
            }

            // 정규식 체크 :: 일치 true, 불일치 false
            if (rule.regex && !rule.regex.test(value)) {
                alert(rule.invalidMsg);
                input.focus();
                return;
            }

        }
        // 비밀번호 확인 일치여부
        if (form.userPw.value !== form.userPwConfirm.value) {
            alert("비밀번호가 일치하지 않습니다.");
            form.userPwConfirm.focus();
            return;
        }


        // 비동기 통신 회원가입
        try {
            const formData = new FormData(form);


        } catch (err) {
            console.error("통신 에러 발생 : ", err);
            alert("서버와 통신 중 문제가 발생했습니다.")
        }
    });
});

// 이미지 썸네일 미리보기
let preview = document.querySelector("#preview");   // 미리보기 div
let img = document.querySelector("#img");           // input
if(img) {
    img.addEventListener('change', function () {
        imgPreview(img, preview);

        if(img.files.length > 0) {
            document.querySelector("#fileName").textContent = img.files[0].name;
        }
    });
}
</script>
</body>
</html>