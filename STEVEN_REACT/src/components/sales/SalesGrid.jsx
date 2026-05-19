import { useEffect, useMemo, useState } from 'react';

import { AgGridReact } from 'ag-grid-react';

import {
    ModuleRegistry,
    AllCommunityModule
} from 'ag-grid-community';

import 'ag-grid-community/styles/ag-grid.css';
import 'ag-grid-community/styles/ag-theme-alpine.css';

import { getHoList }
    from '../../util/api/sales/salesApi';
import RentRegisterModal from './modal/RentRegisterModal';

ModuleRegistry.registerModules([
    AllCommunityModule
]);

function SalesGrid({
    aptCmplexNo
    , selectedAptNm
    , selectedDongNm
    , selectedRooms
    , setSelectedRooms
    , hoList
    , setHoList
}) {

    const [rowData, setRowData] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [gridApi, setGridApi] = useState(null);

    /* 호 목록 조회 */
    useEffect(() => {

        if (
            !aptCmplexNo ||
            !selectedDongNm
        ) {
            setRowData([]);
            return;
        }

        const fetchData = async () => {

            try {

                const data =
                    await getHoList(
                        aptCmplexNo,
                        selectedDongNm
                    );

                setRowData(data);

                setHoList(data);

            } catch (err) {

                console.error(err);

            }
        };

        fetchData();

    }, [
        aptCmplexNo,
        selectedDongNm
    ]);

    /* 상태 한글화 */
    const statusMap = {

        EMPTY: '공실',

        CONTRACT: '계약완료',

        HOLD: '예약중'

    };

    /* 컬럼 */
    const columnDefs = useMemo(() => [

        {
            headerCheckboxSelection: true,

            checkboxSelection: true,

            width: 55,

            pinned: 'left'
        },
        {
            field: 'ho',

            headerName: '호',

            filter: 'agTextColumnFilter',

            flex: 1,

            sort: 'asc',

            comparator: (a, b) => {

                return Number(a) - Number(b);

            }
        },
        {
            field: 'floor',

            headerName: '층',

            filter: 'agNumberColumnFilter',

            width: 90
        },
        {
            field: 'hoTyNo',

            headerName: '호 타입',

            filter: true,

            flex: 1
        },
        {
            field: 'hoSttsCd',
            headerName: '상태',
            filter: true,
            flex: 1,
            cellRenderer: ({ value }) => {
                const label = statusMap[value] || value;
                let bg = '#e2e8f0';
                let color = '#334155';
                if (value === 'EMPTY') {
                    bg = '#dcfce7';
                    color = '#166534';
                }
                if (value === 'CONTRACT') {
                    bg = '#fee2e2';
                    color = '#991b1b';
                }
                if (value === 'HOLD') {
                    bg = '#fef9c3';
                    color = '#854d0e';
                }
                return (
                    <div
                        style={{
                            display: 'flex',
                            alignItems: 'center',
                            height: '100%'
                        }}
                    >
                        <span
                            style={{
                                padding:
                                    '4px 10px',

                                borderRadius:
                                    '999px',

                                fontSize: '12px',

                                fontWeight: '600',

                                background: bg,

                                color
                            }}
                        >
                            {label}
                        </span>
                    </div>
                );
            }
        }

    ], []);

    /**
     * 선택 변경
     */
    const handleSelectionChanged = (event) => {

        const rows = event.api.getSelectedRows();

        setSelectedRooms(rows);

    };

    useEffect(() => {

        if (!gridApi) return;

        gridApi.forEachNode((node) => {

            const exists =
                selectedRooms.some(
                    item =>
                        item.ho === node.data.ho
                );

            node.setSelected(exists);

        });

    }, [
        selectedRooms,
        gridApi
    ]);

    const disabled = selectedRooms.length === 0;

    return (
        <div
            style={{
                height: '100%',

                background: '#fff',

                border:
                    '1px solid var(--outline-variant)',

                borderRadius: '16px',

                overflow: 'hidden',

                display: 'flex',
                flexDirection: 'column'
            }}
        >

            {/* 헤더 */}
            <div
                style={{
                    height: '56px',

                    borderBottom:
                        '1px solid #eee',

                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',

                    padding: '0 20px',

                    fontSize: '15px',
                    fontWeight: '700'
                }}
            >

                {selectedDongNm
                    ? `${selectedAptNm} ${selectedDongNm}`
                    : '동을 선택해주세요'}

                <button disabled={disabled} onClick={() => {
                    if (disabled) return;
                    setShowModal(true);
                }}

                    style={{
                        height: '36px',

                        padding: '0 16px',

                        border: 'none',

                        borderRadius: '8px',

                        fontSize: '13px',

                        fontWeight: '600',

                        background: disabled
                            ? '#e2e8f0'
                            : '#2563eb',

                        color: disabled
                            ? '#94a3b8'
                            : '#fff',

                        cursor: disabled
                            ? 'not-allowed'
                            : 'pointer',

                        opacity: disabled
                            ? 0.8
                            : 1,

                        transition: 'all 0.2s ease'
                    }}
                >
                    선택한 호 매물 등록
                </button>

            </div>

            {/* Grid */}
            <div
                className="ag-theme-alpine"

                style={{
                    flex: 1,
                    width: '100%'
                }}
            >

                {!selectedDongNm ? (

                    <div
                        style={{
                            height: '100%',

                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',

                            color: '#94a3b8'
                        }}
                    >
                        좌측 탐색기에서 동을 선택해주세요.
                    </div>

                ) : (

                    <AgGridReact

                        rowData={rowData}

                        columnDefs={columnDefs}

                        rowSelection="multiple"

                        suppressRowClickSelection={true}

                        animateRows={true}


                        onGridReady={(params) => {
                            setGridApi(params.api);
                        }}

                        onSelectionChanged={
                            handleSelectionChanged
                        }
                    />

                )}

                <RentRegisterModal

                    open={showModal}

                    onClose={() =>
                        setShowModal(false)
                    }

                    selectedRooms={
                        selectedRooms
                    }

                    selectedAptNm={
                        selectedAptNm
                    }

                    selectedDongNm={
                        selectedDongNm
                    }
                />
            </div>

        </div>
    );
}

export default SalesGrid;