import { AllCommunityModule, ModuleRegistry } from 'ag-grid-community';
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';
import { BrowserRouter, Outlet, Route, Routes } from 'react-router-dom';
import MainLayout from "./components/layout/MainLayout";
import AnnRegister from './pages/annRegister/components/AnnRegister';
import Applicant from "./pages/Applicant";
import AptRegister from "./pages/AptRegister";
import Ctrt from "./pages/ctrt/Ctrt";
import Home from "./pages/Home";
import SalesList from './pages/sales/SalesList';
import Member from './pages/member/member';
import MngrRqstAprv from './pages/MngrRqstAprv/MngrRqstAprv';
import ResidentAssignPage from './components/ctrt/ResidentAssignPage';
import './styles/common.css';
import './styles/header.css';
import './styles/sidebar.css';
import { getCookie } from './util/api/requestApi';
import CtrtDetail from './pages/ctrt/CtrtDetail';
import AptRegisterPage from './pages/sales/AptRegisterPage';
ModuleRegistry.registerModules([AllCommunityModule]);

function App() {
  const AuthCheck = () => {
    const token = getCookie('JWT');

    if (!token) {
      // 쿠키가 없으면 윈도우 창 자체를 JSP 로그인 페이지로 이동
      window.location.href = "/login.do";
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
            <Route path="/adm/apt/register" element={<AptRegisterPage />} />
            {/* 아파트 통합 검색 메뉴 */}
            {/* 임대 매물 관리 */}
            <Route path="/adm/sales" element={<SalesList />} />
            {/* 청약 신청 관리 */}
            <Route path="/adm/applicant" element={<Applicant />} />
            {/* 계약 관리 */}
            <Route path="/adm/ctrt" element={<Ctrt />} />
            {/* 계약 상세 */}
            <Route path="/adm/ctrt/detail/:RENT_CTRT_NO" element={<CtrtDetail />} />

            <Route
              path="/apt/residentAssign"
              element={<ResidentAssignPage />}
            />
            {/* 계약 서식 관리 */}
            {/* 회원 관리 */}
            <Route path="/adm/member" element={<Member />} />
            {/* 하위 관리자 계정 관리 */}
            <Route path="/adm/mgmtOfc/account" element={<MngrRqstAprv />} />
            {/* 입주민 관리 메뉴 */}
            {/* 공고 등록 */}
            <Route path="/adm/ann" element={<AnnRegister />} />
            <Route path="/adm/ann/register" element={<AnnRegister />} />
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