import React, { useMemo, useState } from 'react'
import { AgGridReact } from 'ag-grid-react';
import { useOutletContext } from 'react-router-dom';
import '../styles/applicant.css'
import { Check, X } from 'lucide-react';

const Applicant = () => {

    const { admInfo } = useOutletContext();

    const columnDefs = useMemo(() => [
        { field: 'aplcntNo', headerName: '신청 번호' },
        { field: 'userId', headerName: '회원ID', flex: 1 },
        { field: 'userNm', headerName: '이름', flex: 1 },
        { field: 'annNo', headerName: '공고 번호', flex: 1 },
        { field: 'annNm', headerName: '공고 명', flex: 1 },
        { field: 'aptCmplexNo', headerName: '단지코드' },
        { field: 'hoTyCd', headerName: '호 타입 명' },
        { field: 'exclusiveSize', headerName: '전용 면적' },
        {
            field: 'aplcntSttsCd', headerName: '상태',
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') return <span className="stts-apply">대기</span>;
                if (p.value === 'WINNER') return <span className="stts-pass">승인</span>;
                if (p.value === 'LOSER') return <span className="stts-reject">반려</span>;
                return <span>{p.value}</span>; // 기본값
            }
        },
        {
            field: 'aplcntSttsCd', headerName: '관리',
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') {

                    return (
                        <div>
                            <button className='btn-pass'><Check className='check' style={{marginTop:'0px', padding:'0px'}} size={24} /></button>
                            &nbsp;&nbsp;
                            <button className='btn-reject'><X className='reject' style={{marginTop:'0px', padding:'0px'}} size={24} /></button>
                        </div>
                    )
                }
            }
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
        floatingFilter: true,   // 상단 입력창 필터 활성화 (두 번째 이미지 기능)
        resizable: true
    }), []);

    /* 임시 데이터 */
    const [rowData] = useState([
        {
            aplcntNo: '20260505_t_711_A001'
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
            aplcntNo: '20260412_1_A001'
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
            aplcntNo: '20260412_5_A001'
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