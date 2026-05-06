let stomp = null;

function connectWebSocket() {

    const socket = new SockJS('/ws-chat');
    stomp = Stomp.over(socket);

    stomp.connect({}, () => {
        console.log("웹소켓 연결됨");

        subscribeNotification();
    });
}

function subscribeNotification() {

    stomp.subscribe('/sub/notification/' + userNo, (msg) => {

        const data = JSON.parse(msg.body);

        console.log("알림:", data);
        // showToast(data);
    });
}