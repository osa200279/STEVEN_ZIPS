import { useEffect, useState } from 'react';
import { Outlet } from 'react-router-dom';
import Header from './Header';
import Sidebar from './Sidebar';
import requestApi from '../../util/api/requestApi';

const MainLayout = ({ children }) => {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [admInfo, setAdmInfo] = useState(null); // 관리자 정보를 담을 상태
  const [profileError, setProfileError] = useState('');
  const [pageInfo, setPageInfo] = useState({ parent: "", current: "" });

  useEffect(() => {
    // 1. 페이지 로드 시 관리자 정보 요청 (JWT는 인터셉터가 알아서 챙김)
    const getAdmProfile = async () => {
      try {
        const res = await requestApi.get('/api/react/adm/info');
        setAdmInfo(res.data); // 받아온 정보를 상태에 저장
        console.log("관리자 인증 성공:", res.data);
      } catch (err) {
        console.error("관리자 정보 로딩 실패:", err);
        setProfileError('관리자 인증 정보를 확인하지 못했습니다. 다시 접속해 주세요.');
      }
    };

    getAdmProfile();
  }, []);

  // 서버에서 관리자 권한을 확인한 뒤에만 하위 화면과 목록 요청을 실행한다.
  if (!admInfo) {
    return <p role={profileError ? 'alert' : 'status'}>{profileError || '관리자 권한을 확인하는 중입니다.'}</p>;
  }

  return (
    <div id="wrapper">
      <Sidebar
        isCollapsed={isCollapsed}
        toggleSidebar={() => setIsCollapsed(!isCollapsed)}
        admInfo={admInfo} />
      <div className="main-wrap" style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
        <Header
          parent={pageInfo.parent}
          current={pageInfo.current}
          admInfo={admInfo} />
        <main className="main-content" style={{ flex: 1, padding: '10px 28px' }}>
          <Outlet context={{ admInfo, setPageInfo }} />
        </main>
      </div>
    </div>
  );
};

export default MainLayout;
