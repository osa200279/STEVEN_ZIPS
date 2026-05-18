import { useEffect, useState } from 'react';
import { useOutletContext } from 'react-router-dom';

function SalesList() {

  const { setPageInfo } = useOutletContext();

  const [selectedBuilding, setSelectedBuilding] = useState('101동');

  useEffect(() => {
    setPageInfo({
      parent: '건물 · 매물',
      current: '임대 매물 관리'
    });
  }, []);

  const floorData = [
    { floor: '17F', rooms: ['1701', '1702', '1703', '1704'] },
    { floor: '16F', rooms: ['1601', '1602', '1603', '1604'] },
    { floor: '15F', rooms: ['1501', '1502', '1503', '1504'] },
    { floor: '14F', rooms: ['1401', '1402', '1403', '1404'] },
    { floor: '13F', rooms: ['1301', '1302', '1303', '1304'] },
    { floor: '12F', rooms: ['1201', '1202', '1203', '1204'] },
    { floor: '11F', rooms: ['1101', '1102', '1103', '1104'] },
    { floor: '10F', rooms: ['1001', '1002', '1003', '1004'] },
    { floor: '9F', rooms: ['901', '902', '903', '904'] },
    { floor: '8F', rooms: ['801', '802', '803', '804'] },
    { floor: '7F', rooms: ['701', '702', '703', '704'] },
    { floor: '6F', rooms: ['601', '602', '603', '604'] },
    { floor: '5F', rooms: ['501', '502', '503', '504'] },
    { floor: '4F', rooms: ['401', '402', '403', '404'] },
    { floor: '3F', rooms: ['301', '302', '303', '304'] },
    { floor: '2F', rooms: ['201', '202', '203', '204'] },
    { floor: '1F', rooms: ['101', '102', '103', '104'] },
  ];

  return (
    <div className="content-wrapper">

      {/* 검색 영역 */}
      <div
        style={{
          display: 'flex',
          gap: '12px',
          alignItems: 'center'
        }}
      >

        <select
          style={{
            height: '42px',
            minWidth: '160px',
            border: '1px solid var(--outline)',
            borderRadius: '8px',
            padding: '0 12px',
            background: '#fff'
          }}
        >
          <option>시, 도 검색</option>
        </select>

        <select
          style={{
            height: '42px',
            minWidth: '160px',
            border: '1px solid var(--outline)',
            borderRadius: '8px',
            padding: '0 12px',
            background: '#fff'
          }}
        >
          <option>시 군 구 검색</option>
        </select>

        <select
          style={{
            height: '42px',
            minWidth: '160px',
            border: '1px solid var(--outline)',
            borderRadius: '8px',
            padding: '0 12px',
            background: '#fff'
          }}
        >
          <option>동읍면 검색</option>
        </select>

        <input
          type="text"
          placeholder="아파트 이름으로 검색"
          style={{
            flex: 1,
            height: '42px',
            border: '1px solid var(--outline)',
            borderRadius: '8px',
            padding: '0 14px',
            background: '#fff'
          }}
        />

        <button className="btn btn-primary">
          검색
        </button>

      </div>

      {/* 메인 레이아웃 */}
      <div
        style={{
          display: 'flex',
          gap: '20px',
          height: 'calc(100vh - 220px)',
          marginTop: '20px'
        }}
      >

        {/* 좌측 */}
        <div
          style={{
            width: '380px',
            display: 'flex',
            flexDirection: 'column',
            gap: '20px'
          }}
        >

          {/* 배치도 카드 */}
          <div
            style={{
              flex: 1,
              background: '#fff',
              border: '1px solid var(--outline-variant)',
              borderRadius: '16px',
              overflow: 'hidden',
              display: 'flex',
              flexDirection: 'column'
            }}
          >

            {/* 상단 헤더 */}
            <div
              style={{
                padding: '20px',
                borderBottom: '1px solid #e5e7eb',
                background: '#f8fafc'
              }}
            >

              {/* 동 선택 */}
              <div
                style={{
                  marginBottom: '16px'
                }}
              >

                <select
                  value={selectedBuilding}
                  onChange={(e) => setSelectedBuilding(e.target.value)}
                  style={{
                    width: '100%',
                    height: '42px',
                    border: '1px solid #d1d5db',
                    borderRadius: '10px',
                    padding: '0 14px',
                    background: '#fff',
                    fontWeight: '600',
                    fontSize: '14px'
                  }}
                >
                  <option>101동</option>
                  <option>102동</option>
                  <option>103동</option>
                  <option>104동</option>
                </select>

              </div>

              {/* 타이틀 */}
              <div
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '14px'
                }}
              >

                <div
                  style={{
                    width: '42px',
                    height: '42px',
                    borderRadius: '12px',
                    background: '#eef2ff',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    fontSize: '18px'
                  }}
                >
                  🏢
                </div>

                <div>
                  <div
                    style={{
                      fontSize: '18px',
                      fontWeight: '600',
                      color: '#111827'
                    }}
                  >
                    {selectedBuilding} 배치도
                  </div>

                  <div
                    style={{
                      fontSize: '13px',
                      color: '#6b7280',
                      marginTop: '4px'
                    }}
                  >
                    동별 세대 구조를 확인할 수 있습니다.
                  </div>
                </div>

              </div>

            </div>

            {/* 배치도 */}
            <div
              style={{
                flex: 1,
                overflowY: 'auto',
                padding: '10px'
              }}
            >

              {floorData.map((floorObj) => (
                <div
                  key={floorObj.floor}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',

                    marginBottom: '6px',
                    width: '100%',
                  }}
>

                  {/* 층 */}
                  <div
                    style={{
                      width: '40px',
                      fontWeight: '700',
                      color: '#64748b',
                      fontSize: '13px'
                    }}
                  >
                    {floorObj.floor}
                  </div>

                  {/* 호 리스트 */}
                    <div
                      style={{
                        display: 'grid',
                        gridTemplateColumns: `repeat(${floorObj.rooms.length}, auto)`,
                        gap: '6px',
                        justifyContent: 'center',
                        flex: 1
                      }}
                    >

                    {floorObj.rooms.map((room) => (
                      <button
                        key={room}
                        style={{
                          height: '28px',
                          width: '54px',
                          padding: '0 10px',

                          borderRadius: '8px',
                          border: '1px solid #86efac',

                          background: '#ecfdf5',
                          color: '#15803d',

                          fontWeight: '600',
                          fontSize: '15px',

                          cursor: 'pointer',

                          transition: '0.2s',

                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center'
                        }}
                      >
                        {room}
                      </button>
                    ))}

                  </div>

                </div>
              ))}

            </div>

          </div>

        </div>

        {/* 우측 */}
        <div
          style={{
            flex: 1,
            display: 'flex',
            flexDirection: 'column'
          }}
        >

          {/* grid 영역 */}
          <div
            style={{
              flex: 1,
              background: '#fff',
              border: '1px solid var(--outline-variant)',
              borderRadius: '12px',
              overflow: 'hidden'
            }}
          >

            <div style={{ padding: '24px', lineHeight: '2' }}>
              우측 트리/grid 영역
            </div>

          </div>

          {/* 하단 버튼 */}
          <div
            style={{
              marginTop: '16px',
              display: 'flex',
              justifyContent: 'flex-end'
            }}
          >

            <button className="btn btn-primary">
              선택호 일괄 등록
            </button>

          </div>

        </div>

      </div>

    </div>
  );
}

export default SalesList;