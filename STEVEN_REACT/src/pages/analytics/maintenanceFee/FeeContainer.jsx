import React, { useEffect, useState } from 'react'
import FeeChart from './FeeChart';
import FeeFilter from './FeeFilter';

function FeeContainer() {
    const [feeData, setFeeData] = useState([]);


    const dummy = [
        { month: '1월', A아파트: 400, B아파트: 300, C아파트: 200, D아파트: 500 },
        { month: '2월', A아파트: 350, B아파트: 380, C아파트: 250, D아파트: 450 }
    ];

    useEffect(() => {
        setFeeData(dummy);
    }, []);

    return (
        <div className="content-wrapper">
            <h2 className="page-title">관리비 비교 분석</h2>
            <div className="card-container">
                {/* 데이터가 있을 때만 차트를 렌더링 */}
                {feeData.length > 0 ? (
                    <FeeChart data={feeData} />
                ) : (
                    <div>데이터를 불러오는 중...</div>
                )}
            </div>
        </div>
    );
}

export default FeeContainer