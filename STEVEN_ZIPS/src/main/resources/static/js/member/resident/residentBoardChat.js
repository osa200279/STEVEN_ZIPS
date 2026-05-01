window.onload = function () {
    loadMyRooms();
};

currentView = "discover";  // 기본값

let currentRoomId = null;

function openMyRoom(roomId,roomNm,el) {

    if (el) setActiveRoom(el);

    /* 채팅방 메시지 가져오는 메서드! */
    fetch(contextPath + '/residentChat/messages?chatRoomNo=' + roomId)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                    <h3>${roomNm}</h3>
                </div>
                <div class="message-stream">
            `;

            list.forEach(msg => {

                const isMe = String(msg.userNo) === String(userNo); // 나중에 세션

                html += `
                          <div class="message ${isMe ? 'me' : 'other'}">
                            ${msg.msgCn}
                          </div>
                        `;
            });

            html += `</div>
                <div class="search-row">
                    <input id="msg" class="fake-input"/>
                    <button onclick="sendMessage('${roomId}')">전송</button>
                </div>
            `;

            document.getElementById("chat-content").innerHTML = html;
        });
}

function openDiscover() {
    currentView = "discover";

    document.getElementById("chat-content").innerHTML = `
        <div class="section-hd">
            <h3>오픈채팅방</h3>
        </div>

        <div class="search-row">
            <input class="fake-input" placeholder="채팅방 검색" />
        </div>

        <div class="room-grid">
            <div class="room-box available" onclick="enterRoom('1')">운동 모임</div>
            <div class="room-box available" onclick="enterRoom('2')">독서 모임</div>
            <div class="room-box available" onclick="enterRoom('3')">게임 모임</div>
        </div>
    `;
}

function enterRoom(roomId) {

    fetch(contextPath + '/residentChat/enter?chatRoomNo=' + roomId, {
        method: 'POST'
    }).then(() => {
        openMyRoom(roomId);
        loadMyRooms(); // 리스트 갱신
    });
}

function closeChat() {
    openDiscover();
}

function setActiveRoom(el) {
    document.querySelectorAll(".chat-room-item").forEach(item => {
        item.classList.remove("active");
    });
    el.classList.add("active");
}

function loadMyRooms() {
    fetch(contextPath + '/residentChat/myRooms')
        .then(res => res.json())
        .then(list => {

            let html = `
        <div class="section-hd">
          <h3>채팅방 목록</h3>
          <span>검색 가능</span>
        </div>
        <div class="search-row">
          <input class="fake-input" placeholder="검색"/>
        </div>
      `;

            list.forEach(room => {
                html += `
          <div class="chat-room-item"
               onclick="openMyRoom('${room.chatRoomNo}', '${room.chatRoomNm}', this)">

            <div style="display:flex;justify-content:space-between;">
              <strong>${room.chatRoomNm}</strong>

              ${room.unreadCnt > 0
                    ? `<span style="background:red;color:white;border-radius:50%;padding:4px 7px;font-size:11px;">
                     ${room.unreadCnt}
                   </span>`
                    : ``}
            </div>

            <div style="font-size:12px;color:#888;">
              참여자 ${room.memberCnt}명
            </div>

            <div style="font-size:12px;color:#aaa;">
              ${room.lastMsg ?? ''}
            </div>
          </div>
        `;
            });

            document.querySelector('.chat-list').innerHTML = html;
        });
}

function sendMessage(roomId) {

    const content = document.getElementById("msg").value;

    fetch(contextPath + '/residentChat/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            chatRoomNo: roomId,
            msgCn: content
        })
    }).then(() => {
        document.getElementById("msg").value = "";
        openMyRoom(roomId); // 다시 조회
    });
}