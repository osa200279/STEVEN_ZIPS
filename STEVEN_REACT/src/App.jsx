import { AllCommunityModule, ModuleRegistry } from 'ag-grid-community';
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';
import { BrowserRouter, Route, Routes, Outlet } from 'react-router-dom';
import MainLayout from "./components/layout/MainLayout";
import Applicant from "./pages/Applicant";
import AptRegister from "./pages/AptRegister";
import Ctrt from "./pages/Ctrt";
import Home from "./pages/Home";
import './styles/sidebar.css';
import './styles/common.css';
import './styles/header.css';
import { getCookie } from './util/api/requestApi';
ModuleRegistry.registerModules([AllCommunityModule]);

function App() {
  const AuthCheck = () => {
    const token = getCookie('JWT');

    if (!token) {
      // 쿠키가 없으면 윈도우 창 자체를 JSP 로그인 페이지로 이동
      window.location.href = "http://localhost:8080/login.do";
      return null; // 이동 중에는 아무것도 렌더링하지 않음
    }

    // 토큰이 있으면 자식 컴포넌트(MainLayout 등)를 보여줌
    return <Outlet />;
  };

  return (
    <BrowserRouter>
      <Routes>
        <Route element={<AuthCheck />}>
          <Route element={<MainLayout />}>
            <Route path="/" element={<Home />} />
            {/* 아파트 등록 메뉴 */}
            <Route path="/adm/apt/register" element={<AptRegister />} />
            {/* 아파트 통합 검색 메뉴 */}
            {/* 매물 등록 메뉴 */}
            {/* 매물 통합 검색 메뉴 */}
            {/* 청약 신청 관리 */}
            <Route path="/adm/applicant" element={<Applicant />} />
            {/* 계약 관리 */}
            <Route path="/adm/ctrt" element={<Ctrt />} />
            {/* 계약 서식 관리 */}
            {/* 회원 관리 메뉴 */}
            {/* 입주민 관리 메뉴 */}
            {/* 공고 관리 */}
            {/* 문의 관리 */}
            {/* 단지관리자 계정 관리 */}
            {/* 통계 */}
          </Route>
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;