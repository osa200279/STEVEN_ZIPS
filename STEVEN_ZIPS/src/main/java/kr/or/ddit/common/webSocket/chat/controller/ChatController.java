package kr.or.ddit.common.webSocket.chat.controller;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.common.webSocket.chat.service.IChatService;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private IChatService service;

    // 내 채팅방 목록 가져오기
    @GetMapping("/myRooms")
    @ResponseBody
    public List<ChatRoomVO> myRooms(HttpSession session) {
        String userNo = "U001";
        return service.getMyRooms(userNo);
    }

    // 메시지 조회
    @GetMapping("/messages")
    @ResponseBody
    public List<ChatMessageVO> messages(@RequestParam String chatRoomNo) {
        return service.getMessages(chatRoomNo);
    }

    // 메시지 전송
    @PostMapping("/send")
    @ResponseBody
    public String send(@RequestBody ChatMessageVO vo) {
        String userNo = "U001";
        service.sendMessage(vo, userNo);
        return "ok";
    }

    // 입장
    @PostMapping("/enter")
    @ResponseBody
    public String enter(@RequestParam String roomId) {
        String userNo = "U001";
        service.enterRoom(roomId, userNo);
        return "ok";
    }
}