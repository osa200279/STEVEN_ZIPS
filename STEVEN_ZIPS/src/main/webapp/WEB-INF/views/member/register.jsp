<%--
  Created by IntelliJ IDEA.
  User: PC-05
  Date: 2026-04-23
  Time: 오전 9:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>일반 사용자 회원가입</title>


  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: "Pretendard", "Noto Sans KR", "Malgun Gothic", sans-serif;
    }

    body {
      background: #f7f5f1;
      color: #222;
    }

    a {
      text-decoration: none;
      color: inherit;
    }

    button,
    input,
    select {
      font: inherit;
    }

    .container {
      width: 1280px;
      margin: 0 auto;
    }

    .header {
      background: #f7f5f1;
      border-bottom: 1px solid #e7e2d8;
    }

    .header-top {
      height: 82px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }

    .logo {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 36px;
      font-weight: 800;
      color: #5d6f1f;
      letter-spacing: -1px;
    }

    .logo-icon {
      font-size: 28px;
    }

    .util {
      display: flex;
      gap: 10px;
    }

    .util a {
      min-width: 88px;
      height: 40px;
      padding: 0 16px;
      border: 1px solid #d9d1c2;
      border-radius: 6px;
      background: #fff;
      color: #333;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      font-size: 14px;
      font-weight: 600;
    }

    .signup-page {
      padding: 50px 0 90px;
    }

    .signup-wrap {
      max-width: 760px;
      margin: 0 auto;
      background: #fff;
      border: 1px solid #e3ddd1;
      border-radius: 24px;
      box-shadow: 0 16px 36px rgba(67, 73, 41, 0.06);
      overflow: hidden;
    }

    .signup-top {
      padding: 38px 36px 24px;
      background: linear-gradient(180deg, #fbfaf6 0%, #f7f5f1 100%);
      border-bottom: 1px solid #eee6d9;
    }

    .signup-role {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 110px;
      height: 34px;
      padding: 0 14px;
      border-radius: 999px;
      background: #efe8db;
      color: #5d6f1f;
      font-size: 14px;
      font-weight: 800;
      margin-bottom: 18px;
    }

    .signup-title {
      font-size: 38px;
      font-weight: 800;
      color: #1f1f1f;
      letter-spacing: -1px;
      margin-bottom: 12px;
    }

    .signup-desc {
      font-size: 18px;
      color: #666;
      line-height: 1.7;
      word-break: keep-all;
    }

    .signup-body {
      padding: 32px 36px 36px;
    }

    .guide-box {
      background: #f6f2e5;
      border: 1px solid #eadfbf;
      border-radius: 14px;
      padding: 15px 18px;
      color: #5d6f1f;
      font-size: 14px;
      line-height: 1.8;
      margin-bottom: 24px;
    }

    .form-grid {
      display: grid;
      grid-template-columns: 150px 1fr;
      gap: 16px 18px;
      align-items: center;
    }

    .form-label {
      font-size: 16px;
      font-weight: 800;
      color: #333;
    }

    .required {
      color: #d84a3a;
      margin-left: 4px;
    }

    .form-control {
      width: 100%;
      height: 48px;
      padding: 0 14px;
      border: 1px solid #d7d0c2;
      border-radius: 10px;
      background: #fff;
      color: #333;
    }

    .form-control:focus {
      outline: none;
      border-color: #6b8e23;
      box-shadow: 0 0 0 3px rgba(107, 142, 35, 0.10);
    }

    .hint-text {
      grid-column: 2 / 3;
      font-size: 13px;
      color: #8a8273;
      margin-top: -8px;
      line-height: 1.6;
    }

    .btn-area {
      display: flex;
      justify-content: center;
      gap: 12px;
      margin-top: 30px;
    }

    .btn {
      min-width: 140px;
      height: 48px;
      padding: 0 20px;
      border-radius: 10px;
      border: 1px solid #cfc8ba;
      background: #fff;
      color: #333;
      font-size: 17px;
      font-weight: 800;
      cursor: pointer;
    }

    .btn-primary {
      background: #6b8e23;
      border-color: #6b8e23;
      color: #fff;
    }

    .btn-primary:hover {
      background: #5d7d1e;
      border-color: #5d7d1e;
    }

    .btn-secondary:hover {
      border-color: #6b8e23;
      color: #5d6f1f;
      background: #fbfaf6;
    }

    @media (max-width: 900px) {
      .container {
        width: calc(100% - 24px);
      }

      .form-grid {
        grid-template-columns: 1fr;
      }

      .hint-text {
        grid-column: auto;
        margin-top: -10px;
      }

      .signup-top,
      .signup-body {
        padding-left: 22px;
        padding-right: 22px;
      }
    }

    .profile-upload-wrap {
      display: flex;
      align-items: center;
      gap: 18px;
      flex-wrap: wrap;
    }

    .profile-preview {
      width: 96px;
      height: 96px;
      border-radius: 18px;
      border: 1px solid #d9d1c2;
      background: #fbfaf6;
      color: #8a8273;
      font-size: 13px;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
      background-size: cover;
      background-position: center;
      flex-shrink: 0;
    }

    .profile-upload-right {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }

    .file-hidden {
      display: none;
    }

    .file-btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 110px;
      height: 42px;
      border: 1px solid #cfc8ba;
      border-radius: 10px;
      background: #f5deb3;
      color: #5d6f1f;
      font-size: 14px;
      font-weight: 800;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .file-btn:hover {
      background: #f1d39e;
    }

    .file-name {
      font-size: 13px;
      color: #7a7467;
      line-height: 1.5;
    }
  </style>
</head>
<body>
<header class="header">
  <div class="container">
    <div class="header-top">
      <h1 class="logo">
        <span class="logo-icon">🏠</span>
        <span>대덕아파트</span>
      </h1>
      <div class="util">
        <a href="#">로그인</a>
        <a href="#">회원가입</a>
      </div>
    </div>
  </div>
</header>

<main class="signup-page">
  <div class="container">
    <section class="signup-wrap">
      <div class="signup-top">
        <div class="signup-role">일반사용자</div>
        <h2 class="signup-title">회원가입</h2>
        <p class="signup-desc">
          기본 서비스 이용을 위한 일반 사용자 회원가입 화면입니다.
          이후 입주 신고를 통해 입주민 권한으로 변경할 수 있습니다.
        </p>
      </div>

      <div class="signup-body">
        <div class="guide-box">
          회원가입 후 일부 공용 서비스 이용이 가능합니다.
          입주민 전용 기능은 입주민 인증 완료 후 사용할 수 있습니다.
        </div>

        <form >
          <label for="profileImg" class="form-label">프로필 사진</label>
          <div class="profile-upload-wrap">
            <div class="profile-preview" id="profilePreview">미리보기</div>

            <div class="profile-upload-right">
              <input
                      type="file"
                      id="profileImg"
                      name="profileImg"
                      class="file-hidden"
                      accept="image/*"
              />
              <label for="profileImg" class="file-btn">사진 선택</label>
              <div class="file-name" id="fileNameText">선택된 파일 없음</div>
            </div>
          </div>

          <div class="form-grid">
            <label for="userId" class="form-label">아이디<span class="required">*</span></label>
            <input type="text" id="userId"  name="userId" class="form-control" placeholder="아이디를 입력하세요" />

            <div></div>
            <div class="hint-text">영문, 숫자 조합 4~20자 권장</div>

            <label for="userPw" class="form-label">비밀번호<span class="required">*</span></label>
            <input type="password" name="userPw" id="userPw" class="form-control" placeholder="비밀번호를 입력하세요" />

            <label for="userPw2" class="form-label">비밀번호 확인<span class="required">*</span></label>
            <input type="password" id="userPw2" name="userPw2" class="form-control" placeholder="비밀번호를 다시 입력하세요" />

            <label for="userName" class="form-label">이름<span class="required">*</span></label>
            <input type="text" id="userName"  name="userName" class="form-control" placeholder="이름을 입력하세요" />

            <label for="userName" class="form-label">주민등록번호<span class="required">*</span></label>
            <input type="text" id="userPrno" name="userPrno" class="form-control" placeholder="이름을 입력하세요" />

            <label for="userPhone" class="form-label">연락처<span class="required">*</span></label>
            <input type="text" id="userPhone" name="userPhone" class="form-control" placeholder="예: 010-1234-5678" />

            <label for="userEmail" class="form-label">이메일<span class="required">*</span></label>
            <input type="email" id="userEmail" name="userEmail" class="form-control" placeholder="이메일을 입력하세요" />
          </div>

          <div class="btn-area">
            <button type="submit" class="btn btn-primary">회원가입</button>
            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
          </div>
        </form>
      </div>
    </section>
  </div>
</main>
</body>
<script !src="">




</script>
</html>
