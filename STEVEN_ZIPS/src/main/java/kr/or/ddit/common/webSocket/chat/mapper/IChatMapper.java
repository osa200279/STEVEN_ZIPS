package kr.or.ddit.common.webSocket.chat.mapper;

import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IChatMapper {
    List<ChatRoomVO> selectMyRooms(String userNo);

    List<ChatMessageVO> selectMessages(String chatRoomNo);

    String selectMemberId(String chatRoomNo, String userNo);

    void insertMessage(ChatMessageVO vo);

    void insertMember(String chatRoomNo, String userNo);

    int updateLastRead(ChatMessageVO vo);
}
