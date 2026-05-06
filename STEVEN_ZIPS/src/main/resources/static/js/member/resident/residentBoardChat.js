window.onload = function () {
    loadMyRooms();
};

let currentRoomNo = null;
let currentRoomNm = null;


/* 내 채팅방 목록에서 눌렀을때 실행됨 */
function openMyRoom(roomNo,roomNm,el) {

    currentRoomNo = roomNo;
    currentRoomNm = roomNm;

    if (el) setActiveRoom(el);

    /* 채팅방 메시지 가져오는 메서드! */
    fetch(contextPath + '/residentChat/messages/' + aptCmplexNo + '?chatRoomNo=' + roomNo)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                    <h3>${roomNm}</h3>
                </div>
                <div class="message-stream">
            `;

            list.forEach(msg => {

                const isMe = String(msg.userNo) === String(userNo);

                html += `
                          <div class="message ${isMe ? 'me' : 'other'}">
                            ${msg.msgCn}
                          </div>
                        `;
            });

            html += `</div>
                <div class="search-row">
                    <input id="msg" class="fake-input"/>
                    <button onclick="sendMessage()">전송</button>
                </div>
            `;

            document.getElementById("chat-content").innerHTML = html;
        });
}

/* 오픈채팅방 리스트를 가져옴*/
function openDiscover() {

    fetch(contextPath + '/residentChat/openRooms/' + aptCmplexNo)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                    <h3>오픈채팅방</h3>
                </div>
                <div class="search-row">
                    <input class="fake-input" placeholder="채팅방 검색" />
                </div>
                <div class="room-grid">
            `;

            list.forEach(room => {
                html += `
                    <div class="room-box available"
                         onclick="enterRoom('${room.chatRoomNo}')">
                        ${room.chatRoomNm}
                    </div>
                `;
            });

            html += `</div>`;

            document.getElementById("chat-content").innerHTML = html;
        });
}

function enterRoom(roomNo) {

    fetch(contextPath + '/residentChat/enter/' + aptCmplexNo + '?chatRoomNo=' + roomNo, {
        method: 'POST'
    }).then(() => {
        openMyRoom(roomNo, "");
        loadMyRooms();
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
    fetch(contextPath + '/residentChat/myRooms/' +aptCmplexNo)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                  <h3>채팅방 목록</h3>
                  <button onclick="openCreateRoom()" 
                          style="background:#2b674e;color:white;border:none;border-radius:6px;padding:4px 10px;cursor:pointer;">
                    +
                  </button>
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

function sendMessage() {

    const content = document.getElementById("msg").value;

    fetch(contextPath + '/residentChat/send/' + aptCmplexNo, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(   {
            chatRoomNo: currentRoomNo,
            msgCn: content
        })
    }).then(() => {
        document.getElementById("msg").value = "";
        openMyRoom(currentRoomNo, currentRoomNm);
    });
}


function openCreateRoom() {
    const roomName = prompt("채팅방 이름 입력");

    if (!roomName) return;

    createRoom(roomName);
}

function createRoom(roomName) {

    fetch(contextPath + '/residentChat/createRoom/' + aptCmplexNo, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            chatRoomNm: roomName
        })
    })
        .then(res => res.json())
        .then(room => {

            openMyRoom(room.chatRoomNo, room.chatRoomNm, this);
            loadMyRooms();
        });
}