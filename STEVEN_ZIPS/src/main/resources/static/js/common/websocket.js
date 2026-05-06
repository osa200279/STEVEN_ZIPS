let stomp = null;

function connectWebSocket() {

    if (stomp && stomp.connected) {
        console.log("이미 연결됨");
        return;
    }

    const socket = new SockJS('/ws-chat');
    stomp = Stomp.over(socket);

    stomp.connect(
        {},
        () => {
            console.log("웹소켓 연결됨");
            subscribeNotification();
        },
        (error) => {
            console.error("웹소켓 연결 실패", error);
        }
    );
}

function subscribeNotification() {

    const userNo = getUserNo();

    if (!userNo) {
        console.warn("userNo 없음 → 알림 구독 안함");
        return;
    }

    stomp.subscribe('/sub/notification/' + userNo, (msg) => {

        const data = JSON.parse(msg.body);

        console.log("알림:", data);
        // showToast(data);
    });
}

function getUserNo() {
    return document.body.dataset.userNo;
}