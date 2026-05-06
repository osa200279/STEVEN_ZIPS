package kr.or.ddit.common.webSocket.chat.service;

import kr.or.ddit.common.webSocket.chat.mapper.IChatMapper;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j
public class ChatServiceImpl implements IChatService {

    @Autowired
    private IChatMapper mapper;

    @Override
    public List<ChatRoomVO> getMyRooms(String userNo) {
        return mapper.selectMyRooms(userNo);
    }

    @Override
    public List<ChatMessageVO> getMessages(String chatRoomNo) {
        return mapper.selectMessages(chatRoomNo);
    }

    @Override
    @Transactional
    public void sendMessage(ChatMessageVO vo, String userNo) {

        // memberId 찾기
        String memberId = mapper.selectMemberId(vo.getChatRoomNo(), userNo);

        vo.setChatMemberId(memberId);

        // 메시지 저장
        mapper.insertMessage(vo);

        // 읽음 처리
        mapper.updateLastRead(vo);
    }

    @Override
    @Transactional
    public void enterRoom(String chatRoomNo, String userNo) {

        String memberId = mapper.selectMemberId(chatRoomNo, userNo);

        if (memberId == null) {
            mapper.insertMember(chatRoomNo, userNo);
        }
    }

}