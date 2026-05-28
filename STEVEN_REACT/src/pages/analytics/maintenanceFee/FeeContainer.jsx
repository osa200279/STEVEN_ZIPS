import React, { useState } from 'react'
import FeeChart from './FeeChart';
import FeeFilter from './FeeFilter';

function FeeContainer() {
    const [feeData, setFeeData] = useState([]);
    const [loading, setLoading] = useState(false);

    // 데이터 가져오는 함수
    const fetchMaintenanceFees = async (aptList = []) =>{
        setLoading(true);
        try{

        } catch(error) {
            
        }
    };


    return (
        <div>
        </div>
    )
}

export default FeeContainer