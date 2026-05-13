import React, { useEffect, useMemo, useState } from 'react'
import { AgGridReact } from 'ag-grid-react';
import { useOutletContext } from 'react-router-dom';
import { Check, X } from 'lucide-react';
import requestApi, { getCookie } from '../util/api/requestApi';
import axios from 'axios';
import '../styles/applicant.css'

const Applicant = () => {
    const { admInfo } = useOutletContext();
    const [rowData, setRowData] = useState([]);

    useEffect(() => {
        const fetchApplicants = async () => {
            try {

                const response = await requestApi.get('/api/react/adm/aplct');
                
                if (Array.isArray(response.data)) {
                    setRowData(response.data);
                } else {
                    console.error("서버 응답이 배열 형식이 아닙니다:", response.data);
                    setRowData([]);
                }
            } catch (error) {
                console.error("데이터 로드 실패 : ", error);
                setRowData([]);
            }
        };
        fetchApplicants();
    }, []);

    const columnDefs = useMemo(() => [
        { field: 'aplctNo', headerName: '신청 번호', flex: 1.1 },
        { field: 'userId', headerName: '회원ID', width: 170, flex: 1 },
        { field: 'userNm', headerName: '이름', width: 150, flex: 0.8 },
        { field: 'annNo', headerName: '공고 번호', width: 130, flex: 0.8 },
        { field: 'ttl', headerName: '공고 명', flex: 1 },
        { field: 'aptCmplexNo', headerName: '단지코드', width: 150 },
        { field: 'tyNm', headerName: '호 타입', width: 105 },
        { field: 'exclusiveSize', headerName: '전용 면적(㎡)', width: 130 },
        {
            field: 'aplctSttsCd', headerName: '상태',
            valueFormatter: (p) => {
                if (p.value === 'SUBMIT') return '대기';
                if (p.value === 'WINNER') return '승인';
                if (p.value === 'LOSER') return '반려';
                if (p.value === 'CANCEL') return '취소';
                return p.value;
            },
            // 2. 필터가 작동할 때 참조할 값을 정의 (화면에 보이는 값 기준)
            filterValueGetter: (p) => {
                if (p.data.aplctSttsCd === 'SUBMIT') return '대기';
                if (p.data.aplctSttsCd === 'WINNER') return '승인';
                if (p.data.aplctSttsCd === 'LOSER') return '반려';
                if (p.data.aplctSttsCd === 'CANCEL') return '취소';
                return p.data.aplctSttsCd;
            },
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') return <span className="stts-apply">대기</span>;
                if (p.value === 'WINNER') return <span className="stts-pass">승인</span>;
                if (p.value === 'LOSER') return <span className="stts-reject">반려</span>;
                if (p.value === 'CANCEL') return <span className="stts-reject">취소</span>;
                return <span>{p.value}</span>; // 기본값
            },
            width: 110
        },
        {
            field: 'aplctSttsCd', headerName: '관리',
            cellRenderer: (p) => {
                if (p.value === 'SUBMIT') {

                    return (
                        <div>
                            <button className='btn-pass' onClick={() => updStts(p, true)}>
                                <Check className='check' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                            &nbsp;&nbsp;
                            <button className='btn-reject' onClick={() => updStts(p, false)}>
                                <X className='reject' style={{ marginTop: '0px', padding: '0px' }} size={24} />
                            </button>
                        </div>
                    )
                }
            },
            filter:false,
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

    const updStts = async (p , isApproval) => {
        const ag = p.api;
        const selectedNodes = ag.getSelectedNodes();
        const aplctSttsCd = isApproval ? 'WINNER' : 'LOSER' ;
        const actionNm = isApproval? '승인' : '반려';

        let validTargetNos = [];
        let confirmMsg = "";

        // 현재 클릭한 행이 선택된 행들 중에 포함되어 있는지 확인
        const isCurrentNodeSelected = selectedNodes.some(node => node.data.aplctNo === p.data.aplctNo);

        if(selectedNodes && selectedNodes.length > 1 && isCurrentNodeSelected){
            const validNodes = selectedNodes.filter(node => node.data.aplctSttsCd === 'SUBMIT')
            validTargetNos = validNodes.map(node => node.data.aplctNo);
            
            if(validTargetNos.length === 0){
                alert("선택된 항목 중 처리 가능한 '대기'건이 없습니다.");
                return;
            }

            confirmMsg = `현재 선택된 ${selectedNodes.length}개의 행 중에 처리대기 건이 ${validTargetNos.length}개 있습니다. \n일괄 ${actionNm} 처리하시겠습니까?`;
        }else {
            // 선택된 행이 없거나 1개만 선택된 경우 (단일 처리)
            if(p.data.aplctSttsCd !== 'SUBMIT'){
                alert("이미 처리가 완료된 항목입니다.");
                return;
            }
            validTargetNos = [p.data.aplctNo];
            confirmMsg = `해당 신청 건을 ${actionNm} 처리하시겠습니까?`
        }

        if(!window.confirm(confirmMsg)) return;

        try {
            const response = await requestApi.put(`/api/react/adm/aplct/upd`, {
                aplctNos : validTargetNos,
                aplctSttsCd
            });

            if(response.status === 200 && response.data > 0){
                alert(`${response.data}건의 처리가 완료되었습니다.`);
                
                setRowData(prevData => 
                    prevData.map(item => 
                        validTargetNos.includes(item.aplctNo) ?
                        { ...item, aplctSttsCd }
                        : item 
                    )
                );
                
                ag.deselectAll();
            }
        } catch (error) {
            console.log(error);
        }
    };

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