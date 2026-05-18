import React, { useEffect, useState } from 'react';
import { useOutletContext } from 'react-router-dom';
import '../styles/common.css';
import { ChartSpline,  ContrastIcon, Download, FileChartLine, FileClock, FileXCorner, Plus, SquarePen } from 'lucide-react';
import requestApi from '../util/api/requestApi';

const Ctrt = () => {
  const { admInfo } = useOutletContext() || {};
  const [list, setList] = useState([]);

  const [pagination, setPagination] = useState({
    curPage: 1,
    totalPage: 1,
    totalRecord: 0
  });

  useEffect(() => {
    const fetchContracts = async () =>{
      try{
        const response = await requestApi.get(`/api/react/adm/ctrt?page=${pagination.curPage}`);

        if(Array.isArray(response.data.ctrtList)){
          setList(response.data.ctrtList);
          setPagination(prev=>({
            ...prev,
            totalPage: response.data.totalPage,
            totalRecord: response.data.totalRecord
          }));
        }else {
          console.error("서버 응답이 배열 형식이 아닙니다: ", response.data);
          setList([]);
        }
      }catch(error){
        console.error("데이터 로드 실패 : ", error);
        setList([]);
      }
    };
    fetchContracts();
  }, [pagination.curPage]);

  const board = [
    { label: '이행 중인 계약', value: '1,234', change: '+12%', icon: <FileChartLine />, color: 'bg-primary-fixed', hasTrend: true },

    { label: '미승인 계약', value: '29', icon: <SquarePen />, color: 'bg-pending-container', pending: true },

    { label: '만료 임박 계약', value: '14', icon: <FileClock />, color: 'bg-error-container', urgent: true },
    
    { label: '만료된 계약', value: '14', icon: <FileXCorner />, color: 'bg-expired-container', expired: true },
  ];

  return (
    <div className="content-wrapper" style={{paddingTop:'0px'}}>
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
        {board.map((stat, i) => (
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
                <th style={{ textAlign: 'left', marginRight: '0px', paddingRight: '0px' }}>계약 번호</th>
                <th>ID</th>
                <th>아파트</th>
                <th>승인일</th>
                <th>계약 기간</th>
                <th>전·월세</th>
                <th>임대료</th>   {/* 전세면 보증금, 월세면 월 임대 금액 */}
                <th>상태</th>
                <th>담당자</th>
                <th>상세</th>
              </tr>
            </thead>
            <tbody>
              {contracts.map((item, i) => (
                <tr key={i}>
                  <td style={{ textAlign: 'left', marginRight: '0px', paddingRight: '0px' }}>  {/* 계약 번호 */}
                    <div>
                      <p className="cell-title" style={{marginRight: '0px'}}>{item.rent_ctrt_no}</p>
                    </div>
                  </td>
                  <td> {/* ID */}
                    <div>
                      <p className="cell-title">{item.user_id}</p>
                      <p className="cell-sub">이름 : {item.user_name}</p>
                    </div>
                  </td>
                  <td> {/* 아파트 */}
                    <p className="cell-title">{item.aptCmplexNo}</p>
                    <p className="cell-sub">{item.aptCmplexNm}</p>
                  </td>
                  <td> {/* 계약 승인일 */}
                    <span className="cell-title">{item.approvalDt}</span>
                  </td>
                  <td> {/* 기간 */}
                    <span className="cell-title">{item.period}</span>
                  </td>
                  <td> {/* 임대 타입 */}
                    <span className="cell-title">
                      {item.rent_type}
                    </span>
                  </td>
                  <td className='price'> {/* 임대료 */}
                    <span className='cell-title'>
                      {item.price}
                    </span>
                  </td>
                  <td> {/* 상태 */}
                    <span className={`cell-text ${item.isExpiryUrgent ? 'text-error font-semibold' : ''} `}>{item.ctrt_stts}</span>
                  </td>
                  <td> {/* 담당자 */}
                    <p className='cell-title'>{item.mgr}</p>
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