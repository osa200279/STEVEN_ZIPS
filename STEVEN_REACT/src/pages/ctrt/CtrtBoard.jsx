import { ChartSpline, FileBracesCorner, FileChartLine, FileClock, FileXCorner, SquarePen } from 'lucide-react';
import React, { useEffect, useState } from 'react'
import requestApi from '../../util/api/requestApi';

function CtrtBoard() {

  // 대시보드 통계 상태
  const [stats, setStats] = useState({
    activeCnt: 0,
    pendingCnt: 0,
    urgentCnt: 0,
    expiredCnt: 0
  });

  // 대시보드 통계 API 호출
  useEffect(() => {
    const fetchDashboardStats = async () => {
      try {
        const response = await requestApi.get(`/api/react/adm/ctrt/dashboard`);
        if (response.data) {
          setStats({
            totalCnt: response.data.totalCnt,
            activeCnt: response.data.activeCnt,
            pendingCnt: response.data.pendingCnt,
            urgentCnt: response.data.urgentCnt,
            expiredCnt: response.data.expiredCnt
          });
        }
      } catch (error) {
        console.error("대시보드 데이터 로드 실패", error);
      }
    }
  }, []);


  const board = [
    { label: '총 계약', value: '1,234', change: '+12%', icon: <FileChartLine />, color: 'bg-primary-fixed', hasTrend: true },

    { label: '유효 계약', value: '1,234', icon: <FileBracesCorner />, color: 'bg-primary-fixed' },

    { label: '미승인 계약', value: '29', icon: <SquarePen />, color: 'bg-pending-container', pending: true },

    { label: '만료 임박 계약', value: '14', icon: <FileClock />, color: 'bg-error-container', urgent: true },

    { label: '만료된 계약', value: '14', icon: <FileXCorner />, color: 'bg-expired-container', expired: true },
  ];

  return (
    <>
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
            <div style={{display:'flex', justifyContent:'space-between'}}>
              <h3 className="stat-value">{stat.value}</h3>
              {stat.expired && <p className='sub-info'>중도 해지 : stat.terminated 건 </p>}
            </div>
          </div>
        ))}
      </div>
    </>
  )
}

export default CtrtBoard