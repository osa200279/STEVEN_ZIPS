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
                        class="leave-btn">
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
                    <input id="msg" class="fake-input" onkeydown="handleEnter(event)"/>
                    <button onclick="sendMessage()">전송</button>
                </div>
            `;

            document.getElementById("chat-content").innerHTML = html;

            const area = document.getElementById("message-area");

            area.scrollTop = area.scrollHeight;

            loadMyRooms();
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
                    <input
                        class="fake-input"
                        placeholder="채팅방 검색"
                        oninput="filterElements('#open-chat-list .chat-room-item', this.value)"
                    />
                </div>
            `;

            if(list.length === 0){

                html += `
                    <div style="
                        flex:1;
                        display:flex;
                        align-items:center;
                        justify-content:center;
                        color:#999;
                        font-size:13px;
                        min-height:180px;
                    ">
                        참여 가능한 오픈채팅방이 없습니다.
                    </div>
                `;
            }

            list.forEach(room => {

                html += `
                    <div class="chat-room-item"
                         onclick="enterRoom('${room.chatRoomNo}')">

                        <div class="room-top">

                            <div class="room-title">
                                ${room.chatRoomNm}
                            </div>

                            <div class="room-member">
                                참여자 ${room.memberCnt}명
                            </div>

                        </div>

                        <div class="room-meta">

                            <div class="room-desc">
                                ${room.chatRoomDesc ?? '채팅방 소개가 없습니다.'}
                            </div>

                            <div class="room-last-msg">
                                참여하려면 클릭하세요
                            </div>

                        </div>

                    </div>
                `;
            });

            document.getElementById("open-chat-list").innerHTML = html;
        });
}

function enterRoom(roomNo) {

    const ok = confirm('채팅방에 입장하시겠습니까?');

    if (!ok) {
        return;
    }

    fetch(
        contextPath +
        '/residentChat/enter/' +
        aptCmplexNo +
        '?chatRoomNo=' +
        roomNo,
        {
            method: 'POST',
            headers: {
                ...csrfHeaders()
            }
        }
    )
        .then(room => room.json())
        .then(room => {

            loadMyRooms();

            openDiscover();

            openMyRoom(
                room.chatRoomNo,
                room.chatRoomNm
            );
        });
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
                <input class="fake-input" placeholder="검색" oninput="filterElements('.chat-room-item', this.value)"/>                </div>
            `;

            list.forEach(room => {

                html += `
                <div class="chat-room-item
                     ${String(currentRoomNo) === String(room.chatRoomNo) ? 'active' : ''}
                     "
                     onclick="openMyRoom('${room.chatRoomNo}', '${room.chatRoomNm}', this)">

            ${
                    room.unreadCnt > 0
                        ? `
                    <div class="room-unread">
                        ${room.unreadCnt}
                    </div>
                  `
                        : ''
                }

            <div class="room-top">

                <div class="room-title">
                    ${room.chatRoomNm}
                </div>

                <div class="room-member">
                    참여자 ${room.memberCnt}명
                </div>

            </div>

            <div class="room-meta">

                <div class="room-desc">
                    ${room.chatRoomDesc ?? '채팅방 소개가 없습니다.'}
                </div>

                <div class="room-last-msg">
                    ${room.lastMsg ?? '대화 내역이 없습니다.'}
                </div>

            </div>

        </div>
    `;
            });

            document.querySelector('.chat-list').innerHTML = html;
        });
}

function sendMessage() {

    const input = document.getElementById("msg");

    const content = input.value;

    if (content === "") {
        return;
    }

    stomp.send("/pub/chat/send", {}, JSON.stringify({
        chatRoomNo: currentRoomNo,
        msgCn: content,
        msgTyCd: "TEXT"
    }));

    input.value = "";
}

function openCreateRoom() {

    document.getElementById('create-room-modal').style.display = 'flex';
}

function submitCreateRoom() {

    const roomName =
        document.getElementById('create-room-name').value.trim();

    const roomDesc =
        document.getElementById('create-room-desc').value;

    const roomType =
        document.querySelector(
            'input[name="room-type"]:checked'
        ).value;

    if (!roomName) {
        alert('채팅방 이름을 입력하세요.');
        return;
    }

    createRoom(roomName, roomType, roomDesc);
}

function createRoom(roomName, roomType, roomDesc) {

    fetch(contextPath + '/residentChat/createRoom/' + aptCmplexNo, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json',
            ...csrfHeaders()
        },

        body: JSON.stringify({
            chatRoomNm: roomName,
            chatRoomTyCd: roomType,
            chatRoomDesc: roomDesc
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

    const area = document.getElementById("message-area");

    // 시스템 메시지
    if (msg.senderTy === 'SYSTEM') {

        area.insertAdjacentHTML(
            'beforeend',
            `
                <div class="system-message">
                    ${msg.msgCn}
                </div>
            `
        );

        area.scrollTop = area.scrollHeight;
        loadMyRooms();

        return;
    }

    const isMe =
        String(msg.senderUserNo) === String(userNo);

    const html = `
        <div class="message-wrap ${isMe ? 'me' : 'other'}">

            ${!isMe
        ? `
                    <div class="sender-name">
                        ${msg.senderUserNm}
                    </div>
                  `
        : ''
    }

            <div class="message-row ${isMe ? 'me' : 'other'}">
            
                ${isMe
                    ? `
                        <div class="message-time">
                            ${formatMessageTime(msg.regDttm)}
                        </div>
            
                        <div class="message me">
                            ${msg.msgCn}
                        </div>
                      `
                    : `
                        <div class="message other">
                            ${msg.msgCn}
                        </div>
            
                        <div class="message-time">
                            ${formatMessageTime(msg.regDttm)}
                        </div>
                      `
                }
            
            </div>
        </div>
    `;

    area.insertAdjacentHTML('beforeend', html);

    area.scrollTop = area.scrollHeight;
    loadMyRooms();
}

function renderMessage(msg) {

    // 시스템 메시지
    if (msg.senderTy === 'SYSTEM') {

        return `
            <div class="system-message">
                ${msg.msgCn}
            </div>
        `;
    }

    const isMe =
        String(msg.senderUserNo) === String(userNo);

    return `
        <div class="message-wrap ${isMe ? 'me' : 'other'}">

            ${!isMe
        ? `
                    <div class="sender-name">
                        ${msg.senderUserNm}
                    </div>
                  `
        : ''
    }

            <div class="message-row ${isMe ? 'me' : 'other'}">
            
                ${isMe
                    ? `
                        <div class="message-time">
                            ${formatMessageTime(msg.regDttm)}
                        </div>
            
                        <div class="message me">
                            ${msg.msgCn}
                        </div>
                      `
                    : `
                        <div class="message other">
                            ${msg.msgCn}
                        </div>
            
                        <div class="message-time">
                            ${formatMessageTime(msg.regDttm)}
                        </div>
                      `
                }
            
            </div>
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
            method: 'POST',
            headers: {
                ...csrfHeaders()
            }
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

            document.getElementById("chat-content").innerHTML = `
                <div style="
                    height:100%;
                    display:flex;
                    align-items:center;
                    justify-content:center;
                    color:#999;
                    font-size:14px;
                ">
                    채팅방을 선택해주세요.
                </div>
            `;
            // 목록 새로고침
            loadMyRooms();
        });
}
function csrfHeaders() {

    return {
        [document.querySelector('meta[name="_csrf_header"]').content]:
        document.querySelector('meta[name="_csrf"]').content
    };
}

function filterElements(selector, keyword) {

    keyword = keyword.toLowerCase().trim();

    document.querySelectorAll(selector)
        .forEach(el => {

            const title =
                el.querySelector('.room-title')?.innerText.toLowerCase() ?? '';

            const desc =
                el.querySelector('.room-desc')?.innerText.toLowerCase() ?? '';

            const targetText = `${title} ${desc}`;

            el.style.display =
                targetText.includes(keyword)
                    ? ""
                    : "none";
        });
}

function handleEnter(e) {

    if (e.key === 'Enter') {

        e.preventDefault();

        sendMessage();
    }
}

function formatMessageTime(regDttm) {

    if (!regDttm) {
        return '';
    }

    // "2026-05-07 14:21:33" -> "2026-05-07T14:21:33"
    const normalized =
        String(regDttm).replace(' ', 'T');

    const date = new Date(normalized);

    // 파싱 실패 방지
    if (isNaN(date.getTime())) {
        return '';
    }

    const now = new Date();

    const isToday =
        date.getFullYear() === now.getFullYear()
        && date.getMonth() === now.getMonth()
        && date.getDate() === now.getDate();

    if (isToday) {

        return date.toLocaleTimeString('ko-KR', {
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        });
    }

    return `${date.getMonth() + 1}월 ${date.getDate()}일`;
}