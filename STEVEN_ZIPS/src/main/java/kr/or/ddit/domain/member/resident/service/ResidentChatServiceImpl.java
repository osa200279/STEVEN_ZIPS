package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.mapper.IResidentChatMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ResidentChatServiceImpl implements IResidentChatService {

    @Autowired
    IResidentChatMapper residentMapper;


    @Override
    public List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo) {

        return residentMapper.selectMyRoomList(userNo, aptCmplexNo);
    }

    @Override
    public ChatRoomVO createRoom(ChatRoomVO vo, String userNo) {

/*        채팅방 생성 메서드
        residentMapper.insertChatRoom(vo);

        본인 방장으로 참여시킴
        residentMapper.insertChatRoomMember(vo.getChatRoomNo(), userNo);

        생성된 방 객체 리턴
        return residentMapper.selectChatRoom(vo.getChatRoomNo());*/
        return null;
    }


}
