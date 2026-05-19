
function SalesBuildingMap({
  floorData,
  selectedRooms,
  setSelectedRooms
}) {

  if (!floorData?.length) {

    return (
      <div
        style={{
          flex: 1,

          background: '#fff',

          border:
            '1px solid var(--outline-variant)',

          borderRadius: '16px',

          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',

          color: '#94a3b8',

          fontSize: '14px',

          fontWeight: '500'
        }}
      >
        동을 선택해주세요.
      </div>
    );
  }

  const handleRoomClick = (
    roomNo
  ) => {

    const exists =
      selectedRooms.some(
        item => item.ho === roomNo
      );

    if (exists) {

      setSelectedRooms(

        selectedRooms.filter(
          item => item.ho !== roomNo
        )

      );

    } else {

      setSelectedRooms([
        ...selectedRooms,

        {
          ho: roomNo
        }
      ]);
    }
  };

  return (
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

      {/* 상단 */}
      <div
        style={{
          padding: '20px',
          borderBottom: '1px solid #eee'
        }}
      >
      </div>

      {/* 배치도 */}
      <div
        style={{
          padding: '14px',
          overflowY: 'auto',
          flex: 1
        }}
      >

        {floorData.map((floorObj) => (

          <div
            key={floorObj.floor}
            style={{
              display: 'flex',
              alignItems: 'center',
              alignItems: 'flex-start',
              marginBottom: '8px'
            }}
          >

            {/* 층 */}
            <div
              style={{
                width: '42px',
                flexShrink: 0,
                fontSize: '12px',
                fontWeight: '700'
              }}
            >
              {floorObj.floor}
            </div>

            {/* 호 */}
            <div
              style={{
                display: 'grid',

                gridTemplateColumns:
                  'repeat(auto-fill, minmax(54px, 1fr))',

                gap: '6px',

                width: '100%'
              }}
            >

              {floorObj.rooms.map((room) => {

                const isSelected =
                  selectedRooms.some(
                    item => item.ho === room
                  );

                return (
                  <button
                    key={room}
                    onClick={() => handleRoomClick(room)}
                    style={{
                      height: '28px',
                      minWidth: '54px',
                      padding: '0 10px',

                      borderRadius: '8px',
                      border: isSelected
                        ? '1px solid #2563eb'
                        : '1px solid #86efac',

                      background: isSelected
                        ? '#dbeafe'
                        : '#ecfdf5',

                      color: isSelected
                        ? '#1d4ed8'
                        : '#15803d',

                      fontWeight: '600',
                      fontSize: '11px',

                      cursor: 'pointer'
                    }}
                  >
                    {room}
                  </button>
                );
              })}

            </div>

          </div>

        ))}

      </div>

    </div>
  );
}

export default SalesBuildingMap;