package kr.or.ddit.common.webSocket.chat.controller;

import kr.or.ddit.common.webSocket.chat.service.IChatService;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
    public List<ChatRoomVO> myRooms(@AuthenticationPrincipal CustomUser user) {

        String userNo = user.getMember().getUserNo();
        return service.getMyRooms(userNo);
    }

    // 메시지 조회
    @GetMapping("/messages")
    @ResponseBody
    public List<ChatMessageVO> messages(@RequestParam String chatRoomNo) {
        return service.getMessages(chatRoomNo);
    }

    // 입장
    @PostMapping("/enter")
    @ResponseBody
    public String enter(@RequestParam String chatRoomNo,
                        @AuthenticationPrincipal CustomUser user) {

        service.enterRoom(chatRoomNo, user.getMember().getUserNo());
        return "ok";
    }
}