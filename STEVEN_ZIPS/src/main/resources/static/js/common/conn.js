document.addEventListener("DOMContentLoaded", () => {

    // 로그인 기능
    const loginBtn = document.querySelector("#loginBtn");
    const loginForm = document.querySelector("#loginForm");

    if(loginBtn && loginForm){  // 로그인 버튼과 폼이 있을 때
        loginBtn.addEventListener("click", (e) => {
            e.preventDefault();
            let username = loginForm.querySelector("input[name=username]");
            let password = loginForm.querySelector("input[name=password]");

            if(!username){
                alert("아이디를 입력하세요");
                return;
            }
            if(!password){
                alert("비밀번호를 입력하세요");
                return;
            }

            loginForm.submit();
        });
    }

    // 로그아웃 기능
    const logoutBtn = document.querySelector("#logoutBtn");
    const logoutForm = document.querySelector("#logoutForm");

    if(logoutBtn && logoutForm){  // 버튼과 폼이 있을 때만 사용가능
        logoutBtn.addEventListener("click", (e) => {
            e.preventDefault();
            if(confirm("로그아웃 하시겠습니까?")){
                logoutForm.submit();
            }
        });
    }
});