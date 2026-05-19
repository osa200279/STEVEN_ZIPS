import { useState } from 'react';

import { getBuildingList, getHoList } from '../../util/api/sales/salesApi';


function SalesExplorer({ pagingVO, onPageChange }) {


  const [openAptMap, setOpenAptMap] = useState({});

  const [buildingMap, setBuildingMap] = useState({});

  const [openDongMap, setOpenDongMap] = useState({});

  const [hoMap, setHoMap] = useState({});


  const handleAptToggle = async (apt) => {

    const aptNo = apt.aptCmplexNo;

    // 이미 열려있으면 닫기
    if (openAptMap[aptNo]) {

      setOpenAptMap(prev => ({
        ...prev,
        [aptNo]: false
      }));

      return;
    }

    try {

      // 최초 조회
      if (!buildingMap[aptNo]) {

        const data =
          await getBuildingList(aptNo);

        setBuildingMap(prev => ({
          ...prev,
          [aptNo]: data
        }));
      }

      setOpenAptMap(prev => ({
        ...prev,
        [aptNo]: true
      }));

    } catch (err) {

      console.error(err);

    }
  };

  const handleDongToggle = async (
    aptNo,
    dongNm
  ) => {

    const key = `${aptNo}_${dongNm}`;

    // 이미 열려있으면 닫기
    if (openDongMap[key]) {

      setOpenDongMap(prev => ({
        ...prev,
        [key]: false
      }));

      return;
    }

    try {

      // 최초 조회
      if (!hoMap[key]) {

        const data =
          await getHoList(
            aptNo,
            dongNm
          );

        setHoMap(prev => ({
          ...prev,
          [key]: data
        }));
      }

      setOpenDongMap(prev => ({
        ...prev,
        [key]: true
      }));

    } catch (err) {

      console.error(err);

    }
  };

  return (
    <div
      style={{
        flex: 1,

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

          borderBottom: '1px solid #eee',

          display: 'flex',
          alignItems: 'center',

          padding: '0 20px',

          fontWeight: '700',
          fontSize: '15px'
        }}
      >
        매물 탐색기
      </div>

      {/* 리스트 */}
      <div
        style={{
          flex: 1,
          overflowY: 'auto'
        }}
      >

        {pagingVO?.dataList?.length > 0 ? (

          pagingVO.dataList.map((apt) => {

            const isSelected =
              openAptMap[apt.aptCmplexNo];

            return (
              <div
                key={apt.aptCmplexNo}

                onDoubleClick={() =>
                  handleAptToggle(apt)
                }

                style={{
                  padding: '5px 14px',

                  borderBottom:
                    '1px solid #f3f4f6',

                  cursor: 'pointer',

                  transition: '0.2s',

                  background:
                    isSelected
                      ? '#eff6ff'
                      : '#fff'
                }}
              >

                {/* 단지명 */}
                <div
                  style={{
                    fontSize: '14px',
                    fontWeight: '700',

                    display: 'flex',
                    alignItems: 'center',
                    gap: '8px'
                  }}
                >

                  <span>📁</span>

                  <span>
                    {apt.aptCmplexNm}
                  </span>

                </div>

                {/* 주소 */}
                <div
                  style={{
                    marginTop: '6px',

                    fontSize: '12px',
                    color: '#6b7280'
                  }}
                >
                  {apt.dorojuso}
                </div>

                {/* 하단 정보 */}
                <div
                  style={{
                    marginTop: '0px',

                    display: 'flex',
                    gap: '12px',

                    fontSize: '11px',
                    color: '#9ca3af'
                  }}
                >
                </div>
                {openAptMap[apt.aptCmplexNo] &&
                  buildingMap[apt.aptCmplexNo]?.length > 0 && (

                    <div
                      style={{
                        marginTop: '8px',
                        paddingLeft: '24px',

                        display: 'flex',
                        flexDirection: 'column',
                        gap: '4px'
                      }}
                    >

                      {buildingMap[apt.aptCmplexNo]
                        .map((dongNm) => {

                          const key =
                            `${apt.aptCmplexNo}_${dongNm}`;

                          return (

                            <div key={key}>

                              {/* 동 */}
                              <div
                                onDoubleClick={() =>
                                  handleDongToggle(
                                    apt.aptCmplexNo,
                                    dongNm
                                  )
                                }

                                style={{
                                  height: '30px',

                                  display: 'flex',
                                  alignItems: 'center',

                                  padding: '0 10px',

                                  borderRadius: '8px',

                                  background: '#f8fafc',

                                  border:
                                    '1px solid #e5e7eb',

                                  cursor: 'pointer',

                                  fontSize: '13px'
                                }}
                              >

                                🏢 {dongNm}

                              </div>

                              {/* 호 리스트 */}
                              {openDongMap[key] &&
                                hoMap[key]?.length > 0 && (

                                  <div
                                    style={{
                                      marginTop: '4px',
                                      marginLeft: '20px',

                                      display: 'flex',
                                      flexDirection: 'column',
                                      gap: '4px'
                                    }}
                                  >

                                    {hoMap[key].map((ho) => (

                                      <label
                                        key={ho}

                                        style={{
                                          display: 'flex',
                                          alignItems: 'center',
                                          gap: '8px',

                                          fontSize: '12px',

                                          color: '#4b5563'
                                        }}
                                      >

                                        <input type="checkbox" />

                                        🏠 {ho}

                                      </label>

                                    ))}

                                  </div>

                                )}

                            </div>

                          );
                        })}

                    </div>

                  )}

              </div>
            );
          })

        ) : (

          <div
            style={{
              height: '100%',

              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',

              color: '#9ca3af',
              fontSize: '14px'
            }}
          >
            검색 결과가 없습니다.
          </div>

        )}

      </div>
      {/* 페이지네이션 */}
      {pagingVO?.totalPage > 1 && (
        <div
          style={{
            display: 'flex',
            justifyContent: 'center',
            alignItems: 'center',
            gap: '6px',
            padding: '12px',
            borderTop: '1px solid #eee',
            background: '#fafafa'
          }}
        >

          {Array.from(
            { length: pagingVO.totalPage },
            (_, i) => i + 1
          ).map((page) => (

            <button
              key={page}

              onClick={() =>
                onPageChange(page)
              }

              style={{
                width: '30px',
                height: '30px',

                borderRadius: '8px',
                border:
                  page === pagingVO.currentPage
                    ? '1px solid #2563eb'
                    : '1px solid #d1d5db',

                background:
                  page === pagingVO.currentPage
                    ? '#2563eb'
                    : '#fff',

                color:
                  page === pagingVO.currentPage
                    ? '#fff'
                    : '#374151',

                fontWeight: '600',
                cursor: 'pointer'
              }}
            >
              {page}
            </button>

          ))}

        </div>
      )}
    </div>
  );
}

export default SalesExplorer;