package kr.or.ddit.common.webSocket.chat.service;

import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;

import java.util.List;

public interface IChatService {
    List<ChatRoomVO> getMyRooms(String userNo);

    List<ChatMessageVO> getMessages(String roomId);

    void sendMessage(ChatMessageVO vo, String userNo);

    void enterRoom(String roomId, String userNo);
}
