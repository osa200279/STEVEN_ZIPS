import React, { useState, useEffect } from 'react';
import FeeChart from './FeeChart';
import FeeFilter from './FeeFilter';

const FeeContainer = () => {
    const [feeData, setFeeData] = useState([]);
    const [filters, setFilters] = useState({
        selectedApts: ["반포자이", "래미안원베일리", "아크로리버파크", "헬리오시티"]
    });

    // 15개 아파트 데이터가 포함된 전체 더미
    const dummy = [
        { month: '1월', 반포자이: 480, 래미안원베일리: 510, 아크로리버파크: 495, 헬리오시티: 380, 잠실엘스: 360, 트리지움: 355, 고덕그라시움: 320, 마포래미안푸르지오: 340, 경희궁자이: 350, 은평뉴타운: 280, 래미안대치팰리스: 450, 은마아파트: 300, 도곡렉슬: 410, 개포래미안포레스트: 420, 디에이치자이개포: 430 },
        { month: '2월', 반포자이: 475, 래미안원베일리: 505, 아크로리버파크: 490, 헬리오시티: 375, 잠실엘스: 355, 트리지움: 350, 고덕그라시움: 315, 마포래미안푸르지오: 335, 경희궁자이: 345, 은평뉴타운: 275, 래미안대치팰리스: 445, 은마아파트: 295, 도곡렉슬: 405, 개포래미안포레스트: 415, 디에이치자이개포: 425 },
        { month: '3월', 반포자이: 490, 래미안원베일리: 520, 아크로리버파크: 505, 헬리오시티: 390, 잠실엘스: 370, 트리지움: 365, 고덕그라시움: 330, 마포래미안푸르지오: 350, 경희궁자이: 360, 은평뉴타운: 290, 래미안대치팰리스: 460, 은마아파트: 310, 도곡렉슬: 420, 개포래미안포레스트: 430, 디에이치자이개포: 440 },
        { month: '4월', 반포자이: 485, 래미안원베일리: 515, 아크로리버파크: 500, 헬리오시티: 385, 잠실엘스: 365, 트리지움: 360, 고덕그라시움: 325, 마포래미안푸르지오: 345, 경희궁자이: 355, 은평뉴타운: 285, 래미안대치팰리스: 455, 은마아파트: 305, 도곡렉슬: 415, 개포래미안포레스트: 425, 디에이치자이개포: 435 }
    ];

    const handleSearch = () => {
        // 1. 선택된 아파트 이름 중 실제로 존재하는 값만 필터링
        const activeApts = filters.selectedApts.filter(apt => apt && apt.trim() !== "");
        
        // 2. dummy 데이터에서 각 월(month)마다 선택된 아파트의 정보만 추출
        const filtered = dummy.map(item => {
            const newItem = { month: item.month };
            activeApts.forEach(apt => {
                // 더미 데이터에 해당 아파트 키가 있으면 가져오고, 없으면 0으로 처리 (차트 오류 방지)
                newItem[apt] = item[apt] || 0;
            });
            return newItem;
        });
        setFeeData(filtered);
    };

    useEffect(() => {
        handleSearch();
    }, []);

    return (
        <div className="content-wrapper">
            <h2 className="page-title">관리비 비교 분석</h2>
            {/* 필터 컴포넌트 */}
            <FeeFilter filters={filters} setFilters={setFilters} onSearch={handleSearch} />
            {/* 차트 컴포넌트 */}
            <div className="card-container" style={{ marginTop: '0px' }}>
                <FeeChart data={feeData} />
            </div>
        </div>
    );
};

export default FeeContainer;