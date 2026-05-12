import { BrowserRouter, Route, Routes } from 'react-router-dom';
import { AgGridReact } from 'ag-grid-react';
import { ModuleRegistry, AllCommunityModule } from 'ag-grid-community';
ModuleRegistry.registerModules([AllCommunityModule]);
import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';
import './styles/centralAside.css';
import './styles/centralHeader.css';
import './styles/centralCommon.css';
import MainLayout from "./components/layout/MainLayout";
import Home from "./pages/Home";
import Ctrt from "./pages/Ctrt";
import Applicant from "./pages/Applicant";
import AptRegister from "./pages/AptRegister";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route element={<MainLayout />}>
          <Route path="/" element={<Home />} />
          {/* 아파트 등록 메뉴 */}
          <Route path="/adm/apt/register" element={<AptRegister /> } />
          {/* 아파트 통합 검색 메뉴 */}
          {/* 매물 등록 메뉴 */}
          {/* 매물 통합 검색 메뉴 */}
          {/* 청약 신청 관리 */}
          <Route path="/adm/applicant" element={<Applicant /> } />
          {/* 계약 관리 */}
          <Route path="/adm/ctrt" element={<Ctrt /> } />
          {/* 계약 서식 관리 */}
          {/* 회원 관리 메뉴 */}
          {/* 입주민 관리 메뉴 */}
          {/* 공고 관리 */}
          {/* 문의 관리 */}
          {/* 단지관리자 계정 관리 */}
          {/* 통계 */}
          </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;