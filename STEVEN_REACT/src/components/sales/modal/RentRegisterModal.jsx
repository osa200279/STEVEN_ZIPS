import { useState } from 'react';
import { registerRentListing } from '../../../util/api/sales/salesApi';

function RentRegisterModal({

    open,

    onClose,

    selectedRooms,

    selectedAptNm,

    selectedDongNm

}) {

    if (!open) return null;

    const [form, setForm] =
        useState({
            rentTtl: '',
            rentTypeCd: 'JS',
            dpstAmt: '',
            mthlyRentAmt: '',
            rentLstgCn: ''
        });

    const handleChange = (e) => {

        const { name, value } = e.target;

        setForm(prev => ({

            ...prev,

            [name]: value

        }));
    };

    const handleSubmit =
        async () => {

            try {

                if (!form.rentTtl) {

                    alert(
                        '매물 제목을 입력해주세요.'
                    );

                    return;
                }

                if (!form.dpstAmt) {

                    alert(
                        '보증금을 입력해주세요.'
                    );

                    return;
                }

                if (
                    form.rentTypeCd ===
                    'MONTHLY' &&
                    !form.mthlyRentAmt
                ) {

                    alert(
                        '월 임대금액을 입력해주세요.'
                    );

                    return;
                }

                const payload = {

                    hoNos:
                        selectedRooms.map(
                            item => item.hoNo
                        ),

                    rentTtl:
                        form.rentTtl,

                    rentTypeCd:
                        form.rentTypeCd,

                    dpstAmt:
                        form.dpstAmt,

                    mthlyRentAmt:
                        form.mthlyRentAmt,

                    rentLstgCn:
                        form.rentLstgCn,

                    rentSttsCd:
                        'NORMAL'
                };

                await registerRentListing(
                    payload
                );

                alert(
                    '매물이 등록되었습니다.'
                );

                onClose();

            } catch (err) {

                console.error(err);

                alert(
                    '매물 등록 중 오류가 발생했습니다.'
                );

            }
        };


    return (

        <div
            style={{
                position: 'fixed',

                inset: 0,

                background:
                    'rgba(0,0,0,0.35)',

                display: 'flex',

                alignItems: 'center',

                justifyContent: 'center',

                zIndex: 9999
            }}
        >

            <div
                style={{
                    width: '520px',

                    background: '#fff',

                    borderRadius: '16px',

                    padding: '24px'
                }}
            >

                {/* 헤더 */}
                <div
                    style={{
                        display: 'flex',

                        justifyContent:
                            'space-between',

                        alignItems: 'center',

                        marginBottom: '20px'
                    }}
                >

                    <div>
                        <div
                            style={{
                                fontSize: '18px',

                                fontWeight: '700'
                            }}
                        >
                            매물 등록
                        </div>

                        <div
                            style={{
                                marginTop: '4px',

                                fontSize: '13px',

                                color: '#64748b'
                            }}
                        >
                            {selectedAptNm}
                            {' '}
                            {selectedDongNm}
                        </div>
                    </div>

                    <button
                        onClick={onClose}

                        style={{
                            border: 'none',

                            background: 'none',

                            cursor: 'pointer',

                            fontSize: '18px'
                        }}
                    >
                        ✕
                    </button>

                </div>

                {/* 선택 호 */}
                <div
                    style={{
                        marginBottom: '20px'
                    }}
                >

                    {/* 제목 */}
                    <div
                        style={{
                            fontSize: '13px',

                            fontWeight: '600',

                            marginBottom: '8px',

                            display: 'flex',

                            alignItems: 'center',

                            gap: '6px'
                        }}
                    >
                        선택 호

                        <span
                            style={{
                                color: '#2563eb'
                            }}
                        >
                            총 {selectedRooms.length}개
                        </span>

                    </div>

                    {/* 목록 */}
                    <div
                        style={{
                            display: 'flex',

                            flexWrap: 'wrap',

                            gap: '6px'
                        }}
                    >

                        {selectedRooms
                            .slice(0, 5)
                            .map((room) => (

                                <div
                                    key={room.hoNo}

                                    style={{
                                        padding: '6px 10px',

                                        borderRadius:
                                            '999px',

                                        background:
                                            '#eff6ff',

                                        color:
                                            '#2563eb',

                                        fontSize: '12px',

                                        fontWeight: '600'
                                    }}
                                >
                                    {room.ho}호
                                </div>

                            ))}

                        {selectedRooms.length > 5 && (

                            <div
                                style={{
                                    padding: '6px 10px',

                                    borderRadius:
                                        '999px',

                                    background:
                                        '#f1f5f9',

                                    color:
                                        '#64748b',

                                    fontSize: '12px',

                                    fontWeight: '600'
                                }}
                            >
                                +{selectedRooms.length - 5}개
                            </div>

                        )}

                    </div>

                </div>


                <div
                    style={{
                        marginBottom: '16px'
                    }}
                >

                    <div
                        style={{
                            fontSize: '13px',

                            fontWeight: '600',

                            marginBottom: '8px'
                        }}
                    >
                        매물 제목
                    </div>

                    <input
                        type="text"

                        name="rentTtl"

                        value={form.rentTtl}

                        onChange={handleChange}

                        placeholder="매물 제목 입력"

                        style={{
                            width: '100%',

                            height: '42px',

                            border:
                                '1px solid #d1d5db',

                            borderRadius: '8px',

                            padding: '0 14px',

                            fontSize: '14px'
                        }}
                    />

                </div>

                <div
                    style={{
                        display: 'grid',

                        gridTemplateColumns:
                            '120px 1fr 1fr',

                        gap: '12px',

                        marginBottom: '16px'
                    }}
                >

                    {/* 유형 */}
                    <div>

                        <div
                            style={{
                                fontSize: '13px',

                                fontWeight: '600',

                                marginBottom: '8px'
                            }}
                        >
                            유형
                        </div>

                        <select
                            name="rentTypeCd"

                            value={form.rentTypeCd}

                            onChange={handleChange}

                            style={{
                                width: '100%',

                                height: '42px',

                                border:
                                    '1px solid #d1d5db',

                                borderRadius: '8px',

                                padding: '0 12px'
                            }}
                        >

                            <option value="JEONSE">
                                전세
                            </option>

                            <option value="MONTHLY">
                                월세
                            </option>

                        </select>

                    </div>

                    {/* 보증금 */}
                    <div>

                        <div
                            style={{
                                fontSize: '13px',

                                fontWeight: '600',

                                marginBottom: '8px'
                            }}
                        >
                            보증금
                        </div>

                        <input
                            type="number"

                            name="dpstAmt"

                            value={form.dpstAmt}

                            onChange={handleChange}

                            placeholder="보증금 입력"

                            style={{
                                width: '100%',

                                height: '42px',

                                border:
                                    '1px solid #d1d5db',

                                borderRadius: '8px',

                                padding: '0 14px'
                            }}
                        />

                    </div>

                    <div>

                        <div
                            style={{
                                fontSize: '13px',

                                fontWeight: '600',

                                marginBottom: '8px'
                            }}
                        >
                            월 임대금액
                        </div>

                        <input
                            type="number"

                            name="mthlyRentAmt"

                            value={form.mthlyRentAmt}

                            onChange={handleChange}

                            disabled={
                                form.rentTypeCd !==
                                'MONTHLY'
                            }

                            placeholder="월 임대금액"

                            style={{
                                width: '100%',

                                height: '42px',

                                border:
                                    '1px solid #d1d5db',

                                borderRadius: '8px',

                                padding: '0 14px',

                                background:
                                    form.rentTypeCd !==
                                        'MONTHLY'
                                        ? '#f8fafc'
                                        : '#fff',

                                color:
                                    form.rentTypeCd !==
                                        'MONTHLY'
                                        ? '#94a3b8'
                                        : '#111827'
                            }}
                        />

                    </div>

                </div>
                <div
                    style={{
                        display: 'flex',

                        justifyContent: 'flex-end',

                        gap: '10px'
                    }}
                >

                    <button
                        onClick={onClose}

                        style={{
                            height: '40px',

                            padding: '0 16px',

                            border:
                                '1px solid #d1d5db',

                            borderRadius: '8px',

                            background: '#fff',

                            cursor: 'pointer'
                        }}
                    >
                        취소
                    </button>

                    <button
                        onClick={handleSubmit}

                        style={{
                            height: '40px',

                            padding: '0 18px',

                            border: 'none',

                            borderRadius: '8px',

                            background: '#2563eb',

                            color: '#fff',

                            fontWeight: '600',

                            cursor: 'pointer'
                        }}
                    >
                        등록
                    </button>

                </div>
            </div>

        </div>

    );
}

export default RentRegisterModal;