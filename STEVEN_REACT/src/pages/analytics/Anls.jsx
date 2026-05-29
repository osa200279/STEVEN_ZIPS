import React from 'react'
import FeeContainer from './maintenanceFee/FeeContainer'
import RecruitmentDashboard from './RecruitmentDashboard'

function Anls() {
  const dummyData = [
    { annNo: 1, ttl: '행복주택 1차 모집', supplyCnt: 100, applicantCnt: 85 },
    { annNo: 2, ttl: '청년전용 임대주택', supplyCnt: 50, applicantCnt: 25 },
    { annNo: 3, ttl: '신혼부부 보금자리', supplyCnt: 200, applicantCnt: 210 },
  ];

  return (
    <div>
      통계 페이지
      <FeeContainer />
      <RecruitmentDashboard data={dummyData}/>
    </div>
  )
}

export default Anls;