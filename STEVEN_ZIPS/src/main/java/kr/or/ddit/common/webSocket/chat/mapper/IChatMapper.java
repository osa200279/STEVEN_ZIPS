package kr.or.ddit.common.webSocket.chat.mapper;

import kr.or.ddit.common.webSocket.chat.vo.ChatMemberVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IChatMapper {
    List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo);

    List<ChatMessageVO> selectMessages(String chatRoomNo);

    String selectMemberId(String chatRoomNo, String userNo);

    void insertMessage(ChatMessageVO vo);

    int updateLastRead(ChatMessageVO vo);

    String getRoomNoSeq();

    void insertChatRoom(ChatRoomVO roomVO);

    int insertRoomMember(ChatMemberVO memberVO);
}
