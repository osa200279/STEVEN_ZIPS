import axios from "axios";

// 쿠키에서 토큰 꺼내기
export const getCookie = (name) => {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) {
        return parts.pop().split(';').shift();
    }
};

// 쿠키 삭제
export const deleteCookie = (name) => {
    document.cookie =
        `${name}=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT; Max-Age=0;`;
};

/**
 * 1. const requestApi = axios.create(...) : 메모리에 requestApi라는 객체 생성
 * 2. requestApi.interceptors.request.use(...) : 생성된 requestApi 객체 내부의 설정(인터셉터) 칸에 함수를 직접 등록
 *      이 시점에서 requestApi는 이미 인터셉터가 장착된 상태로 업데이트
 * 3. export default requestApi : 인터셉터까지 모든 세팅이 완료된 그 객체 자체를 통째로 밖으로 내보냄
 */
// Axios 인스턴스 설정
const requestApi = axios.create({
    // localhost 제거
    baseURL: '/',
    withCredentials: true,
});

// 요청 인터셉터(모든 요청에 JWT헤더 추가)
requestApi.interceptors.request.use(
    (config) => {
        const token = getCookie('JWT');
        if (token) {
            config.headers.Authorization = `Bearer ${token}`;
        }
        return config;
    },
    (error) => Promise.reject(error)
);

let redirectingToLogin = false;

// 응답 인터셉터
requestApi.interceptors.response.use(
    (response) => response,
/* 응답에러가 발생했을때, 404, 등등 */
    (error) => {
        const status = error.response?.status;
        if ((status === 401 || status === 403) && !redirectingToLogin) {
            redirectingToLogin = true;
            if (status === 401) deleteCookie('JWT');
            alert(status === 403
                ? "중앙관리자 권한이 필요합니다. 관리자 계정으로 다시 로그인해 주세요."
                : "로그인 세션이 만료되었습니다. 다시 로그인해 주세요.");
            // localhost 제거
            window.location.href = "/login.do";
        }
        return Promise.reject(error);
    }
);

export default requestApi;
