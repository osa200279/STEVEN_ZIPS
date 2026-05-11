import axios from "axios";

// 쿠키 꺼내는 함수
const getCookie = (name) => {
    const value = document.cookie.match('(^|;) ?' + name + '=([^;]*)(;|$)');
    return value ? value[2] : null;
};

// Axios 인스턴스 설정
const requestApi = axios.create({
    baseURL: 'http://localhost:8080',
    withCredentials: true,
})

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

export default requestApi;