import { useState } from 'react';

import AptSearchSelect
    from '../../components/ctrt/AptSearchSelect';

function OfflineCtrtModal({

    open,

    onClose

}) {

    const [selectedApt, setSelectedApt]
        = useState(null);

    if (!open) return null;

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
                    width: '700px',

                    background: '#fff',

                    borderRadius: '20px',

                    padding: '32px'
                }}
            >

                {/* 헤더 */}
                <div
                    style={{
                        display: 'flex',

                        justifyContent:
                            'space-between',

                        alignItems: 'center',

                        marginBottom: '28px'
                    }}
                >

                    <div>

                        <div
                            style={{
                                fontSize: '24px',

                                fontWeight: '700'
                            }}
                        >
                            오프라인 계약 등록
                        </div>

                        <div
                            style={{
                                marginTop: '6px',

                                color: '#64748b',

                                fontSize: '14px'
                            }}
                        >
                            계약할 아파트를 선택해주세요.
                        </div>

                    </div>

                    <button
                        onClick={onClose}

                        style={{
                            border: 'none',

                            background: 'none',

                            fontSize: '22px',

                            cursor: 'pointer'
                        }}
                    >
                        ✕
                    </button>

                </div>

                {/* 아파트 검색 */}
                <AptSearchSelect
                    value={selectedApt}
                    onChange={setSelectedApt}
                />

            </div>

        </div>

    );
}

export default OfflineCtrtModal;