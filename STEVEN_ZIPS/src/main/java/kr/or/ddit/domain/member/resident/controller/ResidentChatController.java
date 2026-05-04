package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.service.IResidentChatService;
import kr.or.ddit.domain.member.resident.service.IResidentMainService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/residentChat")
public class ResidentChatController {

    @Autowired
    private IResidentChatService residentService;

    /**
     * 로그인한 사용자의 채팅방 목록 조회
     *
     * - 현재 로그인한 사용자 기준으로 참여한 채팅방 목록을 가져온다
     * - 채팅방 리스트에는 다음 정보가 포함된다:
     *   · 채팅방 이름
     *   · 마지막 메시지
     *   · 마지막 메시지 시간
     *   · 안읽은 메시지 수
     *   · 참여자 수
     *
     * @param principal  로그인 사용자 정보 (Spring Security)
     * @param aptCmplexNo 아파트 단지 번호 (채팅방 필터링용)
     * @return 사용자가 속한 채팅방 목록
     */
    @PreAuthorize("hasRole('RESIDENT') and principal.member.aptCmplexNo == #aptCmplexNo")
@GetMapping("/myRooms")
    @ResponseBody
    public List<ChatRoomVO> selectMyRoomList(@AuthenticationPrincipal CustomUser principal, String aptCmplexNo, Model model) {

        String userNo = principal.getMember().getUserNo();

        return residentService.selectMyRoomList(userNo, aptCmplexNo);
    }

    @PreAuthorize("hasRole('RESIDENT')")
    @PostMapping("/createRoom")
    @ResponseBody
    public ChatRoomVO createRoom(@AuthenticationPrincipal CustomUser principal,
                                 @RequestBody ChatRoomVO vo) {

        String userNo = principal.getMember().getUserNo();

        return residentService.createRoom(vo, userNo);
    }

}