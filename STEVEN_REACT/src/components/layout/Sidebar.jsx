import { Blocks, Building2, Files, FileSearchCorner, IdCardLanyard, MapPinHouse, Megaphone, MessageCircleQuestionMark, NotebookPen, ScrollText, SquareUserRound, Users } from 'lucide-react';

const Sidebar = ({ isCollapsed, toggleSidebar, admInfo }) => {
  return (
    /* 사이드바 헤더 부분 */
    <aside id="sidebar" className={isCollapsed ? 'collapsed' : ''}>
      <div className="sidebar-logo">
        <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
          <div className="logo-icon">
            <MapPinHouse />
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
      {/* 사이드바 헤더 부분 end */}

      {/* nav 영역 시작 */}
      <nav className="sidebar-nav">
        <a href="/" className="nav-item active">
          <span className="material-symbols-rounded">dashboard</span>
          {!isCollapsed && <span style={{ marginLeft: '12px' }}>대시보드</span>}
        </a>
        <div className="nav-divider"></div>

        {/* 대분류 */}
        <span className="nav-item section-label">건물 · 매물</span>

        {/* 아파트 등록 메뉴 */}
        <a className="nav-item" href="api/react/adm/apt/register">
          <Blocks className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 아파트 등록</span>}
        </a>

        {/* 아파트 통합 검색 메뉴 */}
        <a className="nav-item" href="api/react/adm/apt/search">
          <Building2 className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 아파트 통합 검색</span>}
        </a>

        {/* 매물 등록 메뉴 */}
        <a className="nav-item" href="api/react/adm/sales/register">
          <NotebookPen className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 임대 매물 등록</span>}
        </a>

        {/* 매물 통합 검색 메뉴 */}
        <a className="nav-item" href="api/react/adm/sales/list">
          <FileSearchCorner className='luci-icon' />
          {!isCollapsed && <span className='nav-menu'>&nbsp; 임대 매물 검색</span>}
        </a>

        <div className="nav-divider"></div>

        {/* 대분류 */}
        <span className="nav-item section-label">회원 · 계약</span>

        {/* 회원 관리 메뉴 */}
        <a className="nav-item" href="api/react/adm/resident">
          <Users className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 회원 관리</span>}
        </a>

        {/* 입주민 관리 메뉴 */}
        <a className="nav-item" href="api/react/adm/resident">
          <SquareUserRound className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 입주민 관리</span>}
        </a>

        {/* 계약 관리 */}
        <a className="nav-item" href="api/react/adm/ctrt">
          <ScrollText className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 계약 관리</span>}
        </a>

        {/* 계약 서식 관리 */}
        <a className="nav-item" href="api/react/adm/ctrt">
          <Files className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 계약 서식 관리</span>}
        </a>

        <div className="nav-divider"></div>

        {/* 대분류 */}
        <span className="nav-item section-label">커뮤니티</span>

        {/* 공고 관리 */}
        <a className="nav-item" href="api/react/adm/ann">
          <Megaphone className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 공고 관리</span>}
        </a>

        {/* 문의 관리 */}
        <a className="nav-item" href="api/react/adm/inqry">
          <MessageCircleQuestionMark className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 문의 관리</span>}
        </a>

        <div className="nav-divider"></div>

        {/* 대분류 */}
        <span className="nav-item section-label">하위 · 직원</span>

        {/* 단지관리자 계정 관리 */}
        <a className="nav-item" href="api/react/adm/mngr">
          <IdCardLanyard className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 단지관리자 계정 관리</span>}
        </a>

        <div className="nav-divider"></div>

        {/* 대분류 */}
        <span className="nav-item section-label">통계 · 수치</span>

        {/* 단지관리자 계정 관리 */}
        <a className="nav-item" href="api/react/adm/analytics">
          <IdCardLanyard className='luci-icon' />
          {!isCollapsed && <span>&nbsp; 통계</span>}
        </a>

      </nav>
      {/* nav 영역 end */}

      {/* 관리자 명함 카드 */}
      <div className="admin-card">
        <div style={{ width: '34px', height: '34px', background: '#3b9e52', borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <span className="material-symbols-rounded" style={{ color: '#fff', fontSize: '18px' }}>person</span>
        </div>
        {!isCollapsed && (
          <div style={{ flex: 1, marginLeft: '12px' }}>
            <p style={{ color: '#fff', fontSize: '12px', fontWeight: '700', margin: 0 }}>중앙관리자</p>
            <span style={{ color: 'var(--sb-label)', fontSize: '10px' }}>{admInfo ? `${admInfo.userNm} 님` : '정보 로딩중...'}</span>
          </div>
        )}
      </div>
    </aside>
  );
};

export default Sidebar;