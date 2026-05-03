package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface IResidentChatService {

    List<ChatRoomVO> selectMyRoomList(String userNo, String aptNo);

    ChatRoomVO createRoom(ChatRoomVO vo, String userNo);

}
