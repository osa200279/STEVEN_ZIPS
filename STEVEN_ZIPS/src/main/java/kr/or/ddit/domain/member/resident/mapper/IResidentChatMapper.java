package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IResidentChatMapper {

    List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo);

}
