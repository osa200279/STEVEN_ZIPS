import { useEffect, useRef, useState } from 'react';
import { getDongList, getHoList, searchApartment } from '../../util/ctrt/offlineCtrtApi';

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
    const [selectedApt, setSelectedApt] = useState(null);
    const [dongList, setDongList] = useState([]);
    const [selectedDong, setSelectedDong] = useState('');
    const [hoList, setHoList] = useState([]);
    const [selectedHo, setSelectedHo] = useState('');

    /* 검색 API */
    const fetchApartment =
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
                const data =
                    await searchApartment(
                        searchKeyword,
                        currentPage,
                        10
                    );

                if (currentPage === 1) {
                    setAptList(
                        data.content || []
                    );
                } else {
                    setAptList(prev => [
                        ...prev,
                        ...(data.content || [])
                    ]);
                }

                setHasNext(data.hasNext);

            } catch (err) {

                console.error(err);

            } finally {

                setLoading(false);
            }
        };

    /* debounce */
    useEffect(() => {

        const timer = setTimeout(() => {

            setPage(1);
            fetchApartment(
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
            await fetchApartment(
                keyword,
                nextPage
            );
        }
    };

    /* 선택 */
    const handleSelect = async (apt) => {

        setSelectedApt(apt);
        setKeyword(apt.aptCmplexNm);
        setShowDropdown(false);
        setAptList([]);

        /* 초기화 */
        setSelectedDong('');
        setSelectedHo('');
        setHoList([]);

        /* 동 목록 조회 */
        const data = await getDongList(apt.aptCmplexNo);
        setDongList(data);
    };

    const handleDongChange =
        async (e) => {
            const dongNo =
                e.target.value;
            setSelectedDong(
                dongNo
            );
            setSelectedHo('');

             const data =
                 await getHoList(
                     selectedApt.aptCmplexNo,
                     dongNo
                 );

             setHoList(data);
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

                        ) : loading && aptList.length === 0 ? (

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
                                    padding: '14px 16px',
                                    color: '#94a3b8',
                                    fontSize: '14px'
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
                                            {apt.aptCmplexNm}
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
                                            {apt.dorojuso}
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
                <div
                    style={{
                        display: 'flex',

                        gap: '12px',

                        marginTop: '12px'
                    }}
                >

                    {/* 동 선택 */}
                    <select
                        value={selectedDong}

                        onChange={handleDongChange}

                        disabled={!selectedApt}

                        style={{
                            flex: 1,

                            height: '40px'
                        }}
                    >

                        <option value="">
                            동 선택
                        </option>

                        {dongList.map((dong) => (

                            <option
                                key={dong}
                                value={dong}
                            >
                                {dong}
                            </option>

                        ))}

                    </select>

                    {/* 호 선택 */}
                    <select
                        value={selectedHo}

                        onChange={(e) =>
                            setSelectedHo(
                                e.target.value
                            )
                        }

                        disabled={!selectedDong}

                        style={{
                            flex: 1,

                            height: '40px'
                        }}
                    >

                        <option value="">
                            호 선택
                        </option>

                        {hoList.map((ho) => (

                            <option
                                key={ho.HO_NO}
                                value={ho.HO}
                            >
                                {ho.HO}
                            </option>

                        ))}

                    </select>

                </div>

            </div>

        </div>

    );
}

export default AptSearchSelect;