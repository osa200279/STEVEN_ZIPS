package kr.or.ddit.common.webSocket.chat.controller;

import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.messaging.simp.SimpMessagingTemplate;

@Controller
@RequiredArgsConstructor
public class ChatWsController {

    private final SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat/send")
    public void sendMessage(ChatMessageVO message) {

        // chatService.saveMessage(message);

        // 전송 메서드
        messagingTemplate.convertAndSend(
                "/sub/chat/room/" + message.getChatRoomNo(),
                message
        );
    }
}