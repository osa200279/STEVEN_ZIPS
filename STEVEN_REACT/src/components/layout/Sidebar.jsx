
const Sidebar = ({ isCollapsed, toggleSidebar, admInfo }) => {
  return (
    <aside id="sidebar" className={isCollapsed ? 'collapsed' : ''}>
      <div className="sidebar-logo">
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div className="logo-icon">
            <span className="material-symbols-rounded">home_work</span>
          </div>
          {!isCollapsed && (
            <div>
              <h1 style={{ fontSize: '16px', fontWeight: '700', margin: 0, color: '#009785FF' }}>우리집맵핑</h1>
              <p style={{ fontSize: '10px', color: 'var(--sb-label)', margin: 0 }}>중앙관리 시스템</p>
            </div>
          )}
        </div>
        <button onClick={toggleSidebar} style={{ background: 'none', border: 'none', color: 'white', cursor: 'pointer' }}>
          <span className="material-symbols-rounded">{isCollapsed ? 'side_navigation' : 'left_panel_close'}</span>
        </button>
      </div>

      <nav className="sidebar-nav">
        <a href="/" className="nav-item active">
          <span className="material-symbols-rounded">dashboard</span>
          {!isCollapsed && <span style={{ marginLeft: '12px' }}>대시보드</span>}
        </a>
        <div className="nav-divider"></div>
      </nav>


      {/* 관리자 명함 카드 */}
      <div className="admin-card">
        <div style={{ width: '34px', height: '34px', background: '#3b9e52', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <span className="material-symbols-rounded" style={{ color: '#fff', fontSize: '18px' }}>person</span>
        </div>
        {!isCollapsed && (
          <div style={{ flex: 1, marginLeft: '12px' }}>
            <p style={{ color: '#fff', fontSize: '12px', fontWeight: '700', margin: 0 }}>중앙관리자</p>
            <span style={{ color: 'var(--sb-label)', fontSize: '10px' }}>{ admInfo ? `${admInfo.userNm} 님` : '정보 로딩중...' }</span>
          </div>
        )}
      </div>
    </aside>
  );
};

export default Sidebar;