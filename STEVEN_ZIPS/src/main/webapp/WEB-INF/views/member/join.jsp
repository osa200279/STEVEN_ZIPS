<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <%-- 서버가 정해준 이름(편지봉투) --%>
    <meta name="_csrf" content="${_csrf.token}"/>
    <%-- 실제 1회용 암호 값(편지) --%>
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

        /* 힌트와 버튼을 양 끝으로 배치 */
        .id-check-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 5px;
        }

        /* 힌트 메시지 기본 여백 제거 */
        .id-check-row .input-hint {
            margin-top: 0;
        }

        .id-btn-small {
            background: #E9E6D7;
            border: 1px solid #D1CDBA;
            color: #7A745C;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s;
        }

        .id-btn-small:hover {
            background: #DEDAC6;
        }

        .input-control:read-only {
            background-color: #F9F9F9;
            color: #888;
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

        .tel-area span {
            display: inline-block;
            transform: translateY(8px);
            font-weight: bold;
            font-size: 18px;
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

        /* 스위치 컨테이너 */
        .toggle-group {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 5px;
            border-bottom: 1px solid #F0EDE4;
        }

        .toggle-label {
            font-size: 14px;
            color: #555;
            font-weight: 500;
        }

        /* 스위치 본체 */
        .switch {
            position: relative;
            display: inline-block;
            width: 44px;
            height: 22px;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #E9E6D7;
            transition: .4s;
            border-radius: 34px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 16px;
            width: 16px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #7BA131;
        }

        input:checked + .slider:before {
            transform: translateX(22px);
        }

        /* 자식 스위치 영역 (애니메이션) */
        .sub-toggle-area {
            background: #FCF9F0;
            border-radius: 8px;
            padding: 5px 15px;
            margin-top: 5px;
            display: none; /* 기본 숨김 */
        }

        /* (선택) 문구 스타일 */
        .optional-text {
            font-size: 12px; /* 작게 */
            color: rgba(97, 45, 7, 0.53) !important;
            font-weight: normal; /* 굵지 않게 */
            margin-left: 5px; /* 레이블과 약간의 간격 */
        }

        .sub-toggle-area .toggle-label {
            font-size: 13px;
            color: #8B8365;
        }
    </style>
</head>
<body>
<div class="header">
    <span class="badge">일반사용자</span>
    <h2>회원가입</h2>
    <p class="desc">기본 서비스 이용을 위한 일반 사용자 회원가입 화면입니다.<br>
        이후 입주 신고를 통해 입주민 권한으로 변경할 수 있습니다.</p>
</div>

<form action="/member/join" id="joinForm" method="post" enctype="multipart/form-data">

    <div class="profile-section">
        <div class="form-label">프로필 사진</div>
        <div class="profile-flex">
            <div class="photo-preview" id="preview">
                미리보기
            </div>
            <div>
                <button type="button" class="photo-btn" onclick="document.querySelector('#img').click();">
                    사진 선택
                </button>
                <input type="file" id="img" name="profFile" style="display:none;">
                <div id="fileName" class="input-hint">선택된 파일 없음</div>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="form-label">아이디 <span>*</span></div>
        <input type="text" name="userId" id="userId" class="input-control" placeholder="아이디를 입력하세요">
        <div class="id-check-row">
            <div class="input-hint">영문, 숫자 조합 4~20자 권장</div>
            <button type="button" id="idCheckBtn" class="id-btn-small">
                중복확인
            </button>
        </div>

        <input type="hidden" id="isIdChecked" value="N">
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
        <input type="text" name="userRrno" id="userRrno" class="input-control" hidden="hidden">
        <div class="tel-area">
            <input type="text" class="input-control" id="rrno1" name="rrno1" placeholder="주민번호 앞자리 6자">
            <span>-</span>
            <input type="text" class="input-control" id="rrno2" name="rrno2" placeholder="주민번호 뒷자리 7자">
        </div>
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
            <span>-</span>
            <input type="text" class="input-control" id="tel2"/>
            <span>-</span>
            <input type="text" class="input-control" id="tel3"/>
        </div>
        <input type="text" name="userTelno" id="userTelno" hidden="hidden">
    </div>

    <div class="form-group">

        <div class="toggle-group">
            <div class="form-label">SMS 수신여부<span class="optional-text">(선택)</span></div>
            <label class="switch">
                <input type="checkbox" id="smsRcvYn" name="smsRcvYn">
                <span class="slider"></span>
            </label>
        </div>

        <div id="subSmsArea" class="sub-toggle-area">
            <div class="toggle-group">
                <span class="toggle-label">공지사항 알림</span>
                <label class="switch">
                    <input type="checkbox" id="smsNtcRcvYn" name="smsNtcRcvYn">
                    <span class="slider"></span>
                </label>
            </div>
            <div class="toggle-group" style="border:none;">
                <span class="toggle-label">계약관련 알림</span>
                <label class="switch">
                    <input type="checkbox" id="smsCtrtRcvYn" name="smsCtrtRcvYn">
                    <span class="slider"></span>
                </label>
            </div>
        </div>
    </div>

    <div class="form-group">
        <div class="form-label">이메일 <span>*</span></div>
        <input type="email" name="userEml" class="input-control" placeholder="이메일을 입력하세요">
    </div>

    <div class="form-group">
        <div class="toggle-group">
            <div class="form-label">e-mail 수신여부<span class="optional-text">(선택)</span></div>
            <label class="switch">
                <input type="checkbox" id="emlRcvYn" name="emlRcvYn">
                <span class="slider"></span>
            </label>
        </div>

        <div id="subEmlArea" class="sub-toggle-area">
            <div class="toggle-group">
                <span class="toggle-label">공지사항 알림</span>
                <label class="switch">
                    <input type="checkbox" id="emlNtcRcvYn" name="emlNtcRcvYn">
                    <span class="slider"></span>
                </label>
            </div>
            <div class="toggle-group" style="border:none;">
                <span class="toggle-label">계약관련 알림</span>
                <label class="switch">
                    <input type="checkbox" id="emlCtrtRcvYn" name="emlCtrtRcvYn">
                    <span class="slider"></span>
                </label>
            </div>
        </div>
    </div>


    <%-- 토큰 추가 (동기방식 이용시)
        <sec:csrfInput/>
        --%>
    <div class="btn-area">
        <button type="submit" class="btn-submit" id="memRegBtn">회원등록</button>
        <button type="button" class="btn-cancel" onclick="window.close()">취소</button>
    </div>
</form>

<script type="module">
    document.addEventListener('DOMContentLoaded', function () {

        // SMS 수신여부 스위치 토글 제어
        const smsYnSwitch = document.querySelector('#smsRcvYn');
        const subSmsArea = document.querySelector('#subSmsArea');

        smsYnSwitch.addEventListener('change', function () {
            if (this.checked) {
                subSmsArea.style.display = 'block';
                subSmsArea.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = true);
            } else {
                subSmsArea.style.display = 'none';
                // 부모가 꺼지면 자식 체크도 모두 해제
                subSmsArea.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
            }
        });

        // e-mail 수신여부 스위치 토글 제어
        const emlYnSwitch = document.querySelector('#emlRcvYn');
        const subEmlArea = document.querySelector('#subEmlArea');

        emlYnSwitch.addEventListener('change', function () {
            if (this.checked) {
                subEmlArea.style.display = 'block';
                subEmlArea.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = true);
            } else {
                subEmlArea.style.display = 'none';
                // 부모가 꺼지면 자식 체크도 모두 해제
                subEmlArea.querySelectorAll('input[type="checkbox"]').forEach(cb => cb.checked = false);
            }
        });

        // 아이디 중복확인 기능
        const idCheckBtn = document.querySelector('#idCheckBtn');
        idCheckBtn.addEventListener('click', async e => {
            e.preventDefault();
            const form = document.querySelector("#joinForm");
            const userId = document.querySelector('#userId').value.trim();

            if (!userId) {
                alert("아이디를 입력해주세요.");
                form.elements['userId'].focus();
                return;
            }

            const regex = /^[a-zA-Z0-9]{4,20}$/;

            if (regex && !regex.test(userId)) {
                alert("아이디는 영문, 숫자 조합 4~20자로 입력해주세요.");
                form.elements['userId'].focus();
                return;
            }

            try {
                const resp = await fetch(`/member/idCheck?userId=\${userId}`);

                const result = await resp.json();
                if (result.res === "NOTEXIST") {
                    document.querySelector('#isIdChecked').value = "Y";
                    alert(result.message);
                } else {
                    document.querySelector('#isIdChecked').value = "N";
                    alert(result.message);
                }

            } catch (error) {
                console.log("Fetch 에러발생 : ", error);
            }
        });

        // 아이디 입력란 값이 바뀌면 아이디 중복체크 상태 초기화
        document.querySelector('#userId').addEventListener('input', () => {
            document.querySelector('#isIdChecked').value = "N";
        });

        // 회원등록 버튼 클릭 이벤트
        const memRegBtn = document.querySelector("#memRegBtn");
        memRegBtn.addEventListener("click", async (e) => {
            e.preventDefault();
            const form = document.querySelector("#joinForm");

            const rrno1 = form.elements['rrno1'].value;
            const rrno2 = form.elements['rrno2'].value;

            let userRrno = document.querySelector("#userRrno");
            userRrno.value = rrno1 + rrno2;


            const tel1box = document.querySelector('#tel1');
            const tel1 = tel1box.options[tel1box.selectedIndex].value;
            const tel2 = document.querySelector('#tel2').value;
            const tel3 = document.querySelector('#tel3').value;
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
                rrno1: {
                    label: "주민등록번호 앞자리",
                    regex: /^[0-9]{6}$/,  // 형식 000000-0000000
                    invalidMsg: "주민등록번호 형식이 올바르지 않습니다."
                },
                rrno2: {
                    label: "주민등록번호 뒷자리",
                    regex: /^[0-9]{7}$/,  // 형식 000000-0000000
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

            // id중복체크 여부 확인
            if (document.querySelector('#isIdChecked').value === "N") {
                alert("아이디 중복체크를 해주세요!");
                return;
            }

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
            const formData = new FormData(form);
            const csrfHeader = document.querySelector('meta[name="_csrf_header"]').content;
            const csrfToken = document.querySelector('meta[name="_csrf"]').content;

            formData.set('smsRcvYn', document.querySelector('#smsRcvYn').checked ? 'Y' : 'N');
            formData.set('emlRcvYn', document.querySelector('#emlRcvYn').checked ? 'Y' : 'N');

            const subAreas = ['#subSmsArea', '#subEmlArea'];

            subAreas.forEach(area => {
                const container = document.querySelector(area);
                if (container) {
                    const checkboxes = container.querySelectorAll('input[type="checkbox"]');
                    checkboxes.forEach(cb => {
                        formData.set(cb.id, cb.checked ? 'Y' : 'N');
                    });
                }
            });

            try {
                const resp = await fetch('/member/join', {
                    method: 'POST',
                    headers: {
                        [csrfHeader]: csrfToken,
                    },
                    body: formData
                });

                const result = await resp.json();
                if (resp.ok) {
                    alert(result.message);
                    window.close(); // 성공시 팝업 닫기
                } else {
                    alert("가입 실패: " + result.message);
                }
            } catch (error) {
                console.error("통신 에러 발생 : ", error);
                alert("서버와 통신 중 문제가 발생했습니다.")
            }
        });
    });

    // 이미지 썸네일 미리보기
    let preview = document.querySelector("#preview");   // 미리보기 div
    let img = document.querySelector("#img");           // input
    if (img) {
        img.addEventListener('change', function () {
            imgPreview(img, preview);

            if (img.files.length > 0) {
                document.querySelector("#fileName").textContent = img.files[0].name;
            }
        });
    }
</script>
</body>
</html>