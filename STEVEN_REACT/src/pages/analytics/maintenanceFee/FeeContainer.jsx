import React, { useState } from 'react'
import FeeChart from './FeeChart';

function FeeContainer() {
    // 1. 데이터와 상태를 여기서 관리
    const [feeData, setFeeData] = useState([
        { month: '1월', A: 400, B: 300 },
        { month: '2월', A: 350, B: 380 }
    ]);

    // 2. 필터 변경 시 실행될 함수
    const handleFilterChange = (newFilter) => {
        console.log("필터 적용:", newFilter);
        // 여기서 axios로 서버 데이터 다시 가져오기(fetch)
    };

    return (
        <div>
            <FeeChart data={feeData} />
        </div>
    )
}

export default FeeContainer