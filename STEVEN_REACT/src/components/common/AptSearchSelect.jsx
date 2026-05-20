import { useEffect, useRef, useState } from 'react';

import requestApi
    from '../../util/api/requestApi';

function AptSearchSelect({
    value,
    onChange
}) {

    const dropdownRef = useRef(null);
    const [keyword, setKeyword] = useState('');
    const [showDropdown, setShowDropdown] = useState(false);
    const [loading, setLoading] = useState(false);
    const [aptList, setAptList] = useState([]);
    const [page, setPage] = useState(1);
    const [hasNext, setHasNext] = useState(true);

    /* 검색 API */
    const searchApartment =
        async (
            searchKeyword,
            currentPage = 1
        ) => {

            if (
                searchKeyword.trim().length < 2
            ) {
                setAptList([]);
                setHasNext(false);
                return;
            }
            try {
                setLoading(true);
                const response =
                    await requestApi.get(
                        '/api/react/apt/search',
                        {
                            params: {
                                keyword: searchKeyword,
                                page: currentPage,
                                size: 10
                            }
                        }
                    );

                const data = response.data;
                if (currentPage === 1) {
                    setAptList(data.content || []);

                } else {
                    setAptList(prev => [
                        ...prev,
                        ...(data.content || [])
                    ]);
                }

                setHasNext(
                    data.hasNext
                );

            } catch (err) {

                console.error(err);

            } finally {

                setLoading(false);
            }
        };

    /* debounce */
    useEffect(() => {

        const timer =
            setTimeout(() => {

                setPage(1);

                searchApartment(
                    keyword,
                    1
                );

            }, 300);

        return () =>
            clearTimeout(timer);

    }, [keyword]);

    /* 무한 스크롤 */
    const handleScroll = async (e) => {
        const {
            scrollTop,
            clientHeight,
            scrollHeight
        } = e.target;
        const isBottom =
            scrollTop + clientHeight >=
            scrollHeight - 10;
        if (
            isBottom &&
            hasNext &&
            !loading
        ) {

            const nextPage =
                page + 1;
            setPage(nextPage);
            await searchApartment(
                keyword,
                nextPage
            );
        }
    };

    /* 선택 */
    const handleSelect = (apt) => {
        onChange?.(apt);
        setKeyword(
            apt.aptNm
        );
        setShowDropdown(false);
        setAptList([]);
    };

    /* 바깥 클릭 */
    useEffect(() => {
        const handleClickOutside =
            (e) => {
                if (
                    dropdownRef.current &&
                    !dropdownRef.current.contains(
                        e.target
                    )
                ) {
                    setShowDropdown(false);
                }
            };

        document.addEventListener(
            'mousedown',
            handleClickOutside
        );

        return () => {

            document.removeEventListener(
                'mousedown',
                handleClickOutside
            );
        };

    }, []);

    return (

        <div
            style={{
                width: '100%'
            }}
        >

            {/* 라벨 */}
            <div
                style={{
                    fontSize: '14px',
                    fontWeight: '700',
                    marginBottom: '10px'
                }}
            >
                아파트 선택
            </div>

            {/* 검색 영역 */}
            <div
                ref={dropdownRef}

                style={{
                    position: 'relative'
                }}
            >

                <input
                    type="text"
                    value={keyword}
                    onChange={(e) => {
                        setKeyword(
                            e.target.value
                        );
                        setShowDropdown(
                            true
                        );
                    }}

                    onFocus={() =>
                        setShowDropdown(true)
                    }

                    placeholder="아파트명을 검색해주세요."
                    style={{
                        width: '100%',
                        height: '48px',
                        border: '1px solid #d1d5db',
                        borderRadius:
                            '12px',

                        padding:
                            '0 16px',

                        fontSize: '14px',

                        outline: 'none'
                    }}
                />

                {/* 드롭다운 */}
                {showDropdown && (

                    <div
                        onScroll={
                            handleScroll
                        }

                        style={{
                            position:
                                'absolute',

                            top: '56px',

                            left: 0,

                            right: 0,

                            background:
                                '#fff',

                            border:
                                '1px solid #e2e8f0',

                            borderRadius:
                                '12px',

                            overflowY:
                                'auto',

                            maxHeight:
                                '320px',

                            boxShadow:
                                '0 10px 25px rgba(0,0,0,0.08)',

                            zIndex: 100
                        }}
                    >

                        {keyword.length < 2 ? (

                            <div
                                style={{
                                    padding:
                                        '14px 16px',

                                    color:
                                        '#94a3b8',

                                    fontSize:
                                        '14px'
                                }}
                            >
                                2글자 이상 입력해주세요.
                            </div>

                        ) : loading &&
                            aptList.length === 0 ? (

                            <div
                                style={{
                                    padding:
                                        '14px 16px',

                                    color:
                                        '#64748b',

                                    fontSize:
                                        '14px'
                                }}
                            >
                                검색중...
                            </div>

                        ) : aptList.length === 0 ? (

                            <div
                                style={{
                                    padding:
                                        '14px 16px',

                                    color:
                                        '#94a3b8',

                                    fontSize:
                                        '14px'
                                }}
                            >
                                검색 결과가 없습니다.
                            </div>

                        ) : (

                            aptList.map(
                                (apt) => (

                                    <div
                                        key={
                                            apt.aptCmplexNo
                                        }

                                        onClick={() =>
                                            handleSelect(
                                                apt
                                            )
                                        }

                                        style={{
                                            padding: '14px 16px',
                                            cursor: 'pointer',
                                            borderBottom: '1px solid #f1f5f9',
                                            transition: 'background 0.15s ease'
                                        }}
                                        onMouseEnter={(e) => {
                                            e.currentTarget.style.background =
                                                '#f8fafc';
                                        }}
                                        onMouseLeave={(e) => {
                                            e.currentTarget.style.background =
                                                '#fff';
                                        }}
                                    >
                                        <div
                                            style={{
                                                fontSize:
                                                    '14px',
                                                fontWeight:
                                                    '600',
                                                color:
                                                    '#111827'
                                            }}
                                        >
                                            {apt.aptNm}
                                        </div>
                                        <div
                                            style={{
                                                marginTop:
                                                    '2px',

                                                fontSize:
                                                    '12px',

                                                color:
                                                    '#64748b'
                                            }}
                                        >
                                            {apt.address}
                                        </div>

                                    </div>

                                )
                            )

                        )}

                        {/* 추가 로딩 */}
                        {loading &&
                            aptList.length > 0 && (

                                <div
                                    style={{
                                        padding:
                                            '12px',

                                        textAlign:
                                            'center',

                                        fontSize:
                                            '13px',

                                        color:
                                            '#64748b'
                                    }}
                                >
                                    불러오는 중...
                                </div>

                            )}

                    </div>

                )}

            </div>

            {/* 선택 결과 */}
            {value && (

                <div
                    style={{
                        marginTop: '14px',

                        padding: '16px',

                        borderRadius: '14px',

                        background: '#f8fafc',

                        border:
                            '1px solid #e2e8f0'
                    }}
                >

                    <div
                        style={{
                            fontSize: '13px',

                            color: '#64748b',

                            marginBottom: '6px'
                        }}
                    >
                        선택된 아파트
                    </div>

                    <div
                        style={{
                            fontSize: '16px',

                            fontWeight: '700'
                        }}
                    >
                        {value.aptNm}
                    </div>

                    <div
                        style={{
                            marginTop: '4px',

                            fontSize: '13px',

                            color: '#64748b'
                        }}
                    >
                        {value.address}
                    </div>

                </div>

            )}

        </div>

    );
}

export default AptSearchSelect;