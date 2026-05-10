import { useState } from 'react';
import Header from './Header';
import Sidebar from './Sidebar';

const MainLayout = ({ children }) => {
  const [isCollapsed, setIsCollapsed] = useState(false);

  return (
    <div id="wrapper">
      <Sidebar isCollapsed={isCollapsed} toggleSidebar={() => setIsCollapsed(!isCollapsed)} />
      <div className="main-wrap" style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
        <Header parent="대시보드" current="홈" />
        <main className="main-content" style={{ flex: 1, padding: '28px' }}>
          {children}
        </main>
      </div>
    </div>
  );
};

export default MainLayout;