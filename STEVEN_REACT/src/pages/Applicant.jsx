import React, { useMemo, useState } from 'react'
import { AgGridReact } from 'ag-grid-react';
import { useOutletContext } from 'react-router-dom';
import '../styles/applicant.css'
import { Check, X } from 'lucide-react';

const Applicant = () => {

    const { admInfo } = useOutletContext();

    const columnDefs = useMemo(() => [
        { field: 'aplcntNo', headerName: '신청 번호', flex: 1.1 },
        { field: 'userId', headerName: '회원ID', width: 170, flex: 1 },
        { field: 'userNm', headerName: '이름', width: 150, flex: 0.8 },
        { field: 'annNo', headerName: '공고 번호', width: 130, flex: 0.8 },
        { field: 'annNm', headerName: '공고 명', flex: 1 },
        { field: 'aptCmplexNo', headerName: '단지코드', width: 150 },
        { field: 'hoTyCd', headerName: '호 타입', width: 105 },
        { field: 'exclusiveSize', headerName: '전용 면적', width: 105 },
        {
            field: 'aplcntSttsCd', headerName: '상태',
            valueFormatter: (p) => {
                if (p.value === 'SUBMIT') return '대기';
                if (p.value === 'WINNER') return '승인';
                if (p.value === 'LOSER') return '반려';
                return p.value;
            },
            // 2. 필터가 작동할 때 참조할 값을 정의 (화면에 보이는 값 기준)
            filterValueGetter: (p) => {
                if (p.data.aplcntSttsCd === 'SUBMIT') return '대기';
                if (p.data.aplcntSttsCd === 'WINNER') return '승인';
                if (p.data.aplcntSttsCd === 'LOSER') return '반려';
                return p.data.aplcntSttsCd;
            },
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') return <span className="stts-apply">대기</span>;
                if (p.value === 'WINNER') return <span className="stts-pass">승인</span>;
                if (p.value === 'LOSER') return <span className="stts-reject">반려</span>;
                return <span>{p.value}</span>; // 기본값
            },
            width: 110
        },
        {
            field: 'aplcntSttsCd', headerName: '관리',
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') {

                    return (
                        <div>
                            <button className='btn-pass'><Check className='check' style={{ marginTop: '0px', padding: '0px' }} size={24} /></button>
                            &nbsp;&nbsp;
                            <button className='btn-reject'><X className='reject' style={{ marginTop: '0px', padding: '0px' }} size={24} /></button>
                        </div>
                    )
                }
            },
            width: 120
        },
    ], []);

    const rowSelection = useMemo(() => ({       // 행 옵션
        mode: 'multiRow',               // 여러 행 선택
        headerCheckbox: true,           // 맨 앞에 체크박스
        checkboxes: true                // 체크박스 표시
    }), []);

    const defaultColDef = useMemo(() => ({      // 
        sortable: true,
        filter: true,           // 일반 필터 활성화
        floatingFilter: false,   // 상단 입력창 필터 비활성화 
        resizable: true
    }), []);

    /* 임시 데이터 */
    const [rowData] = useState([
        {
            aplcntNo: '20260505_t_711_01'
            , userId: 'uuuu'
            , userNm: '유혜린'
            , annNo: 'ANN01'
            , annNm: '한빛아파트 1차 분양'
            , aptCmplexNo: 'A013123'
            , hoTyCd: 'A타입'
            , exclusiveSize: '34㎡'
            , aplcntSttsCd: 'WINNER'
        },
        {
            aplcntNo: '20260412_1_01'
            , userId: 'ive01'
            , userNm: '장원영'
            , annNo: 'ANN03'
            , annNm: '한빛아파트 2차 분양'
            , aptCmplexNo: 'A013123'
            , hoTyCd: 'B타입'
            , exclusiveSize: '45㎡'
            , aplcntSttsCd: 'SUBMIT'
        },
        {
            aplcntNo: '20260412_5_01'
            , userId: 'peng9'
            , userNm: '펭구'
            , annNo: 'ANN03'
            , annNm: '한빛아파트 2차 분양'
            , aptCmplexNo: 'A013123'
            , hoTyCd: 'B타입'
            , exclusiveSize: '45㎡'
            , aplcntSttsCd: 'SUBMIT'
        },
    ]);

    return (
        <div style={{ width: '100%', height: '100%' }}>
            <div style={{ marginBottom: '15px' }}>
                <h2 style={{ fontSize: '20px', fontWeight: '700' }}>청약 신청 현황</h2>
            </div>

            {/* AG Grid 테마 적용 영역 */}
            <div className="ag-theme-alpine" style={{ height: 'calc(100vh - 200px)', width: '100%' }}>
                <AgGridReact
                    theme="legacy"
                    rowData={rowData}
                    columnDefs={columnDefs}
                    defaultColDef={defaultColDef}
                    rowSelection={rowSelection}
                    pagination={true}
                />
            </div>
        </div>
    );
};

export default Applicant