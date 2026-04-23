<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
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
        .header { margin-bottom: 30px; }
        .badge {
            background: #E9E6D7;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
            color: #7A745C;
            font-weight: bold;
        }
        h2 { font-size: 32px; margin: 15px 0; letter-spacing: -1px; }
        .desc { color: #888; font-size: 14px; line-height: 1.5; }

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
        .form-label span { color: #C0392B; margin-left: 3px; }

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
        .input-control:focus { border-color: #7BA131; }
        .input-hint {
            font-size: 12px;
            color: #AAA;
            margin-top: 5px;
        }

        /* 프로필 사진 섹션 */
        .profile-section { margin-bottom: 30px; }
        .profile-flex { display: flex; align-items: flex-start; gap: 20px; }
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
            background: #EAE2C8;
            border: none;
            padding: 10px 18px;
            border-radius: 5px;
            cursor: pointer;
            color: #7A745C;
            font-weight: bold;
            font-size: 14px;
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

<form action="member/register" method="post" enctype="multipart/form-data">

    <div class="profile-section">
        <div class="form-label">프로필 사진</div>
        <div class="profile-flex">
            <div class="photo-preview" id="preview">미리보기</div>
            <div>
                <button type="button" class="photo-btn" onclick="document.getElementById('fileInput').click();">사진 선택</button>
                <input type="file" id="fileInput" name="profilePic" style="display:none;" onchange="updateFileName(this)">
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
    </div>

    <div class="form-group">
        <div class="form-label">비밀번호 확인 <span>*</span></div>
        <input type="password" name="userPwConfirm" class="input-control" placeholder="비밀번호를 다시 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">이름 <span>*</span></div>
        <input type="text" name="userName" class="input-control" placeholder="이름을 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">주민등록번호 <span>*</span></div>
        <input type="text" name="userSsn" class="input-control" placeholder="이름을 입력하세요">
    </div>

    <div class="form-group">
        <div class="form-label">연락처 <span>*</span></div>
        <input type="text" name="userPhone" class="input-control" placeholder="예: 010-1234-5678">
    </div>

    <div class="form-group">
        <div class="form-label">이메일 <span>*</span></div>
        <input type="email" name="userEmail" class="input-control" placeholder="이메일을 입력하세요">
    </div>

    <div class="btn-area">
        <button type="submit" class="btn-submit" id="memRegBtn">회원가입</button>
        <button type="button" class="btn-cancel" onclick="window.close()">취소</button>
    </div>
</form>

<script>
document.addEventListener("DOMContentLoaded", () => {

    const memRegBtn = document.querySelector("#memRegBtn");

    // 회원등록 버튼 클릭 이벤트
    memRegBtn.addEventListener("click", (e) => {
        e.preventDefault();



        // 유효성 체크

    });
});


</script>
</body>
</html>