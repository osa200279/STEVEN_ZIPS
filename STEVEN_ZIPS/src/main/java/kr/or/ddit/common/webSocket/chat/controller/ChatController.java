package kr.or.ddit.common.webSocket.chat.controller;

import kr.or.ddit.common.webSocket.chat.service.IChatService;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/residentChat")
public class ChatController {

    @Autowired
    private IChatService service;

    // 내 채팅방 목록 가져오기
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/myRooms/{aptCmplexNo}")
    @ResponseBody
    public List<ChatRoomVO> myRooms(
            @PathVariable String aptCmplexNo
            ,@AuthenticationPrincipal CustomUser user
    ) {

        String userNo = user.getMember().getUserNo();
        return service.selectMyRoomList(userNo,aptCmplexNo);
    }

    // 메시지 조회
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/messages/{aptCmplexNo}")
    @ResponseBody
    public List<ChatMessageVO> messages(
            @PathVariable String aptCmplexNo
            ,@RequestParam String chatRoomNo
            ,@AuthenticationPrincipal CustomUser user
    ) {

/*        String userNo = user.getMember().getUserNo();
        if(!service.isRoomMember(chatRoomNo, userNo)){
            return null;
        }*/
        return service.getMessages(chatRoomNo);
    }

    // 입장
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/enter/{aptCmplexNo}")
    @ResponseBody
    public String enter(
                        @PathVariable String aptCmplexNo
                        ,@RequestParam String chatRoomNo
                        ,@AuthenticationPrincipal CustomUser user) {

        service.enterRoom(chatRoomNo, user.getMember().getUserNo());
        return "ok";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/createRoom/{aptCmplexNo}")
    @ResponseBody
    public ChatRoomVO createRoom(
            @PathVariable String aptCmplexNo
            ,@RequestBody ChatRoomVO roomVO
            ,@AuthenticationPrincipal CustomUser user
    ) {

        String userNo = user.getMember().getUserNo();
        roomVO.setAptCmplexNo(aptCmplexNo);
        return service.createRoom(roomVO, userNo);
    }
}