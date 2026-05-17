import React, { useState } from 'react';
import { useOutletContext } from 'react-router-dom';
import '../styles/common.css';
import { ChartSpline, ContrastIcon, Download, FileChartLine, FileClock, FileXCorner, Plus, SquarePen } from 'lucide-react';

const Ctrt = ({ onViewChange }) => {
  const { admInfo } = useOutletContext() || {};
  const [currentView, setCurrentView] = useState('list');

  const stats = [
    { label: '이행 중인 계약', value: '1,234', change: '+12%', icon: <FileChartLine />, color: 'bg-primary-fixed', hasTrend: true },
    { label: '미승인 계약', value: '29', icon: <SquarePen />, color: 'bg-pending-container' },
    { label: '만료 임박 계약', value: '14', icon: <FileClock />, color: 'bg-error-container', urgent: true },
    { label: '만료된 계약', value: '14', icon: <FileXCorner />, color: '--bg-expired-container', expired: true },
  ];

  const contracts = [
    { rnet_ctrt_no: 'rent_ctrt_no', user_id: 'Yirho', user_name: '이용로', rent_type: '전세', period: '2025.04.01 ~ 2026.04.01', price: '₩1,240,000,000', ctrt_stts: '이행중', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025002', user_id: 'minsu12', user_name: '김민수', rent_type: '월세', period: '2025.03.15 ~ 2026.03.14', price: '₩850,000', ctrt_stts: '이행중', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025003', user_id: 'jiyeon88', user_name: '박지연', rent_type: '전세', period: '2025.02.01 ~ 2026.01.31', price: '₩980,000,000', ctrt_stts: '계약만료', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025004', user_id: 'donghyuk7', user_name: '최동혁', rent_type: '월세', period: '2025.05.01 ~ 2026.04.30', price: '₩1,200,000', ctrt_stts: '이행중', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025005', user_id: 'sohee99', user_name: '정소희', rent_type: '전세', period: '2024.11.10 ~ 2026.11.09', price: '₩1,450,000,000', ctrt_stts: '이행중', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025006', user_id: 'junseo21', user_name: '한준서', rent_type: '월세', period: '2025.01.20 ~ 2026.01.19', price: '₩730,000', ctrt_stts: '계약만료예정', detail: '상세보기', isExpiryUrgent: true },

    { rnet_ctrt_no: 'RC2025007', user_id: 'yerim_k', user_name: '강예림', rent_type: '전세', period: '2025.06.01 ~ 2027.05.31', price: '₩1,120,000,000', ctrt_stts: '이행중', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025008', user_id: 'taewoo44', user_name: '임태우', rent_type: '월세', period: '2025.04.10 ~ 2026.04.09', price: '₩950,000', ctrt_stts: '계약완료', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025009', user_id: 'eunji02', user_name: '서은지', rent_type: '전세', period: '2025.07.01 ~ 2027.06.30', price: '₩1,670,000,000', ctrt_stts: '이행중', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025010', user_id: 'hyunwoo55', user_name: '조현우', rent_type: '월세', period: '2025.08.15 ~ 2026.08.14', price: '₩670,000', ctrt_stts: '계약대기', detail: '상세보기', isExpiryUrgent: false },

    { rnet_ctrt_no: 'RC2025011', user_id: 'nari_dev', user_name: '이나리', rent_type: '전세', period: '2025.09.01 ~ 2027.08.31', price: '₩1,320,000,000', ctrt_stts: '이행중', detail: '상세보기', isExpiryUrgent: false }
  ];

  return (
    <div className="content-wrapper">
      {/* 타이틀 세션 */}
      <div className="page-header">
        <div>
          <h2 className="page-title">계약 관리</h2>
          <p className="page-subtitle">Contract management</p>
        </div>
        <div className="header-actions">
          <button className="btn-outline">
            <span className="material-symbols-outlined">.xls 다운로드</span><Download size={17} />
          </button>
        </div>
      </div>

      {/* 대시보드 통계 그리드*/}
      <div className="stats-grid">
        {stats.map((stat, i) => (
          <div key={i} className="stat-card">
            <div className="stat-icon-row">
              <div className={`icon-box-wrapper ${stat.color}`}>
                <span className="material-symbols-outlined">
                  {stat.icon}
                </span>
              </div>
              {stat.hasTrend && (
                <span className="stat-change">
                  <ChartSpline size={16} /><span className='text-[15px]'>{stat.change}</span>
                </span>
              )}
              {stat.expired && <span className="badge-expired">Expired</span>}
              {stat.urgent && <span className="badge-urgent">Urgent</span>}
            </div>
            <p className="stat-label">{stat.label}</p>
            <h3 className="stat-value">{stat.value}</h3>
          </div>
        ))}
      </div>

      {/* 필터 및 컨트롤 바 */}
      <div className="filter-bar">
        <div className="filter-badge">
          <span className="material-symbols-outlined select-icon">filter_list</span>
          <span>Status: All</span>
          <span className="material-symbols-outlined select-icon">expand_more</span>
        </div>
        <div className="filter-badge">
          <span>Department: Legal & HR</span>
          <span className="material-symbols-outlined select-icon">expand_more</span>
        </div>
        <div className="filter-badge">
          <span className="material-symbols-outlined select-icon">calendar_today</span>
          <span>Date Range: Q3 2024</span>
        </div>

        <div className="filter-right-group">
          <p className="table-info-text">Showing 10 of 1,284</p>
          <div className="view-toggle-box">
            <button className="toggle-btn active"><span className="material-symbols-outlined">list</span></button>
            <button className="toggle-btn"><span className="material-symbols-outlined">grid_view</span></button>
          </div>
        </div>
      </div>

      {/* 데이터 테이블 컨테이너 */}
      <div className="table-wrapper shadow-sm">
        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>계약 번호</th>
                <th>ID</th>
                <th>전·월세</th>
                <th>기간</th>
                <th>임대료</th>   {/* 전세면 보증금, 월세면 월 임대 금액 */}
                <th>상태</th>
                <th>상세</th>
              </tr>
            </thead>
            <tbody>
              {contracts.map((item, i) => (
                <tr key={i}>
                  <td>  {/* 계약 번호 */}
                    <div className="cell-flex">
                      <div>
                        <p className="cell-title">{item.rnet_ctrt_no}</p>
                      </div>
                    </div>
                  </td>
                  <td> {/* ID */}
                    <div className="cell-flex">
                      <div>
                        <p className="cell-title">{item.user_id}</p>
                        <p className="cell-sub">이름 : {item.user_name}</p>
                      </div>
                    </div>
                  </td>
                  <td> {/* 임대 타입 */}
                    <span className="cell-title">
                      {item.rent_type}
                    </span>
                  </td>
                  <td> {/* 기간 */}
                    <span className="cell-title">{item.period}</span>
                  </td>
                  <td className='price'> {/* 임대료 */}
                    <span className='cell-title'>
                      {item.price}
                    </span>
                  </td>
                  <td> {/* 상태 */}
                    <span className={`cell-text ${item.isExpiryUrgent ? 'text-error font-semibold' : ''} `}>{item.ctrt_stts}</span>
                  </td>
                  <td>{/* 상세 버튼 */}
                    <button className='btn-cell'>상세보기</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* 하단 페이징 영역 */}
        <div className="table-pagination">
          <div className="pagination-right">
            <p className="table-info-text mr-4">1-10 of 128</p>
            <button className="btn-page-nav" disabled>
              <span className="material-symbols-outlined">&lt;</span>
            </button>
            <div className="page-numbers">
              <button className="btn-page-number active">1</button>
              <button className="btn-page-number">2</button>
              <button className="btn-page-number">3</button>
              <span className="page-ellipsis">...</span>
              <button className="btn-page-number">13</button>
            </div>
            <button className="btn-page-nav">
              <span className="material-symbols-outlined">&gt;</span>
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};


export default Ctrt;