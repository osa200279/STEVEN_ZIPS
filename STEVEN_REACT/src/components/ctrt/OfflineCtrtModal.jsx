import { useState } from 'react';

function OfflineCtrtModal({

    open,

    onClose

}) {

    if (!open) return null;

    const [form, setForm] = useState({

        userId: '',

        userNm: '',

        aptNm: '',

        dong: '',

        ho: '',

        rentTypeCd: 'JS',

        dpstAmt: '',

        mthlyRentAmt: '',

        mvinDt: '',

        mvoutDt: ''

    });

    const handleChange = (e) => {

        const { name, value } = e.target;

        setForm(prev => ({

            ...prev,

            [name]: value

        }));
    };

    const handleSubmit = () => {

        console.log(form);

        onClose();
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
                    width: '620px',

                    background: '#fff',

                    borderRadius: '18px',

                    padding: '28px'
                }}
            >

                {/* 헤더 */}
                <div
                    style={{
                        display: 'flex',

                        justifyContent: 'space-between',

                        alignItems: 'center',

                        marginBottom: '24px'
                    }}
                >

                    <div>

                        <div
                            style={{
                                fontSize: '22px',

                                fontWeight: '700'
                            }}
                        >
                            오프라인 계약 등록
                        </div>

                        <div
                            style={{
                                marginTop: '4px',

                                color: '#64748b',

                                fontSize: '14px'
                            }}
                        >
                            수기 계약 정보를 등록합니다.
                        </div>

                    </div>

                    <button
                        onClick={onClose}

                        style={{
                            border: 'none',

                            background: 'none',

                            fontSize: '20px',

                            cursor: 'pointer'
                        }}
                    >
                        ✕
                    </button>

                </div>

                {/* 입력 영역 */}
                <div
                    style={{
                        display: 'grid',

                        gridTemplateColumns:
                            '1fr 1fr',

                        gap: '16px'
                    }}
                >

                    <input
                        type="text"

                        name="userId"

                        value={form.userId}

                        onChange={handleChange}

                        placeholder="입주민 ID"

                        className="modal-input"
                    />

                    <input
                        type="text"

                        name="userNm"

                        value={form.userNm}

                        onChange={handleChange}

                        placeholder="입주민 이름"

                        className="modal-input"
                    />

                    <input
                        type="text"

                        name="aptNm"

                        value={form.aptNm}

                        onChange={handleChange}

                        placeholder="아파트명"

                        className="modal-input"
                    />

                    <input
                        type="text"

                        name="dong"

                        value={form.dong}

                        onChange={handleChange}

                        placeholder="동"

                        className="modal-input"
                    />

                    <input
                        type="text"

                        name="ho"

                        value={form.ho}

                        onChange={handleChange}

                        placeholder="호"

                        className="modal-input"
                    />

                    <select
                        name="rentTypeCd"

                        value={form.rentTypeCd}

                        onChange={handleChange}

                        className="modal-input"
                    >

                        <option value="JS">
                            전세
                        </option>

                        <option value="WS">
                            월세
                        </option>

                    </select>

                    <input
                        type="number"

                        name="dpstAmt"

                        value={form.dpstAmt}

                        onChange={handleChange}

                        placeholder="보증금"

                        className="modal-input"
                    />

                    <input
                        type="number"

                        name="mthlyRentAmt"

                        value={form.mthlyRentAmt}

                        onChange={handleChange}

                        placeholder="월세"

                        disabled={
                            form.rentTypeCd !== 'WS'
                        }

                        className="modal-input"
                    />

                    <input
                        type="date"

                        name="mvinDt"

                        value={form.mvinDt}

                        onChange={handleChange}

                        className="modal-input"
                    />

                    <input
                        type="date"

                        name="mvoutDt"

                        value={form.mvoutDt}

                        onChange={handleChange}

                        className="modal-input"
                    />

                </div>

                {/* 버튼 */}
                <div
                    style={{
                        display: 'flex',

                        justifyContent: 'flex-end',

                        gap: '10px',

                        marginTop: '28px'
                    }}
                >

                    <button
                        onClick={onClose}

                        style={{
                            height: '42px',

                            padding: '0 18px',

                            border:
                                '1px solid #d1d5db',

                            borderRadius: '10px',

                            background: '#fff',

                            cursor: 'pointer'
                        }}
                    >
                        취소
                    </button>

                    <button
                        onClick={handleSubmit}

                        style={{
                            height: '42px',

                            padding: '0 20px',

                            border: 'none',

                            borderRadius: '10px',

                            background: '#2563eb',

                            color: '#fff',

                            fontWeight: '600',

                            cursor: 'pointer'
                        }}
                    >
                        계약 등록
                    </button>

                </div>

            </div>

        </div>
    );
}

export default OfflineCtrtModal;