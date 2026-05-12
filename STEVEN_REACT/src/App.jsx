import { BrowserRouter, Route, Routes } from 'react-router-dom';
import './styles/centralAside.css';
import './styles/centralHeader.css';
import './styles/centralCommon.css';
import MainLayout from "./components/layout/MainLayout";
import Home from "./pages/Home";
import Ctrt from "./pages/Ctrt";
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
          {/* 회원 관리 메뉴 */}
          {/* 입주민 관리 메뉴 */}
          {/* 계약 관리 */}
          <Route path="/adm/ctrt" element={<Ctrt /> } />
          {/* 계약 서식 관리 */}
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