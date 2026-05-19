function SalesBuildingMap({
  selectedBuilding,
  setSelectedBuilding,
  selectedRooms,
  setSelectedRooms
}) {

  const floorData = [
    { floor: '3F', rooms: ['301', '302', '303', '304'] },
    { floor: '2F', rooms: ['201', '202', '203', '204'] },
    { floor: '1F', rooms: ['101', '102', '103', '104'] },
  ];

  const handleRoomClick = (roomNo) => {

    const exists = selectedRooms.includes(roomNo);

    if (exists) {
      setSelectedRooms(
        selectedRooms.filter(room => room !== roomNo)
      );
    } else {
      setSelectedRooms([
        ...selectedRooms,
        roomNo
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

        <select
          value={selectedBuilding}
          onChange={(e) => setSelectedBuilding(e.target.value)}
          style={{
            width: '100%',
            height: '40px'
          }}
        >
          <option>101동</option>
          <option>102동</option>
        </select>

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
              justifyContent: 'center',
              marginBottom: '8px'
            }}
          >

            {/* 층 */}
            <div
              style={{
                width: '32px',
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
                gridTemplateColumns: `repeat(${floorObj.rooms.length}, auto)`,
                gap: '6px'
              }}
            >

              {floorObj.rooms.map((room) => {

                const isSelected =
                  selectedRooms.includes(room);

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