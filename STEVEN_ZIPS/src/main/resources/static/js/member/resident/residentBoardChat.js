document.addEventListener("DOMContentLoaded", function () {
    loadMyRooms();
    openDiscover();
});

let subscription = null;
let currentRoomNo = null;
let currentRoomNm = null;

/* websocket 구독하는 함수 */
function subscribeRoom(roomId) {

    if (subscription) {
        subscription.unsubscribe();
    }

    subscription = stomp.subscribe('/sub/chat/room/' + roomId, function(msg) {

        const data = JSON.parse(msg.body);

        appendMessage(data);
    });
}

/* 내 채팅방 목록에서 눌렀을때 실행됨 */
function openMyRoom(roomNo, roomNm, el) {

    currentRoomNo = roomNo;
    currentRoomNm = roomNm;

    if (el) setActiveRoom(el);

    //기존 구독 끊기
    if (subscription) {
        subscription.unsubscribe();
    }

    //새 채팅방 구독
    subscribeRoom(roomNo);

    // 기존 메시지 로딩
    fetch(contextPath + '/residentChat/messages/' + aptCmplexNo + '?chatRoomNo=' + roomNo)
        .then(res => res.json())
        .then(list => {

            let html = `
                <div class="section-hd">
                    <h3>${roomNm}</h3>
                    
                    <button
                        onclick="leaveRoom()"
                        style="
                            border:none;
                            background:#ef4444;
                            color:white;
                            padding:6px 12px;
                            border-radius:8px;
                            cursor:pointer;
                            font-size:12px;
                        ">
                        방 나가기
                    </button>
                </div>
                <div class="message-stream" id="message-area">
            `;

            list.forEach(msg => {
                html += renderMessage(msg);
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
    })  .then(room => room.json())
        .then(room => {

            loadMyRooms();

            openMyRoom(
                room.chatRoomNo,
                room.chatRoomNm
            );
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

    stomp.send("/pub/chat/send", {}, JSON.stringify({
        chatRoomNo: currentRoomNo,
        msgCn: content,
        msgTyCd: "TEXT"
    }));

    document.getElementById("msg").value = "";
}

function openCreateRoom() {

    document.getElementById('create-room-modal').style.display = 'flex';
}

function submitCreateRoom() {

    const roomName =
        document.getElementById('create-room-name').value.trim();

    const roomType =
        document.querySelector(
            'input[name="room-type"]:checked'
        ).value;

    if (!roomName) {
        alert('채팅방 이름을 입력하세요.');
        return;
    }

    createRoom(roomName, roomType);
}

function createRoom(roomName, roomType) {

    fetch(contextPath + '/residentChat/createRoom/' + aptCmplexNo, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },

        body: JSON.stringify({
            chatRoomNm: roomName,
            chatRoomTyCd: roomType
        })
    })
        .then(res => res.json())
        .then(room => {

            closeCreateRoomModal();

            loadMyRooms();
            openMyRoom(room.chatRoomNo, room.chatRoomNm);
        });
}

function appendMessage(msg) {

    const isMe = String(msg.senderUserNo) === String(userNo);

    const html = `
        <div class="message ${isMe ? 'me' : 'other'}">
            ${msg.msgCn}
        </div>
    `;

    const area = document.getElementById("message-area");
    area.insertAdjacentHTML('beforeend', html);

    area.scrollTop = area.scrollHeight; // 자동 스크롤
}

function renderMessage(msg) {
    const isMe = String(msg.senderUserNo) === String(userNo);

    return `
        <div class="message ${isMe ? 'me' : 'other'}">
            ${msg.msgCn}
        </div>
    `;
}

function closeCreateRoomModal() {

    document.getElementById('create-room-modal').style.display = 'none';

    document.getElementById('create-room-name').value = '';

    document.querySelector(
        'input[name="room-type"][value="OPEN"]'
    ).checked = true;
}

function outsideClose(e) {

    if (e.target.id === 'create-room-modal') {
        closeCreateRoomModal();
    }
}

function leaveRoom() {

    if (!currentRoomNo) {
        return;
    }

    if (!confirm('채팅방을 나가시겠습니까?')) {
        return;
    }

    fetch(
        contextPath +
        '/residentChat/leave/' +
        aptCmplexNo +
        '?chatRoomNo=' +
        currentRoomNo,
        {
            method: 'POST'
        }
    )
        .then(res => res.text())
        .then(() => {

            // 구독 끊기
            if (subscription) {
                subscription.unsubscribe();
                subscription = null;
            }

            currentRoomNo = null;
            currentRoomNm = null;

            // 기본 화면 복귀
            openDiscover();

            // 목록 새로고침
            loadMyRooms();
        });
}