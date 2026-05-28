import React from 'react'
import * as Rc from 'recharts';

function FeeChart({data}) {
    return (
        <Rc.ResponsiveContainer width="100%" height={200}>
            <Rc.BarChart data={data}>
                {/* 1. 배경 격자: 수치를 눈으로 확인하기 쉽게 해줌 */}
                <Rc.CartesianGrid strokeDasharray="3 3" />
                {/* 2. X, Y축 라벨: 데이터의 단위나 의미를 명확히 함 */}
                <Rc.XAxis dataKey="month" />
                <Rc.YAxis />
                {/* 3. 툴팁(Tooltip): 마우스를 올렸을 때 정확한 수치를 보여줌 */}
                <Rc.Tooltip />
                {/* 4. 범례(Legend): 어떤 색상이 어떤 아파트인지 구분 */}
                <Rc.Legend />
                <Rc.Bar dataKey="A" fill="#82ca9d" name="A아파트" />
            </Rc.BarChart>
        </Rc.ResponsiveContainer>)
}

export default FeeChart