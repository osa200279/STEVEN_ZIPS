package kr.or.ddit.common.webSocket.chat.service;

import kr.or.ddit.common.webSocket.chat.mapper.IChatMapper;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class ChatServiceImpl implements IChatService{

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
    public void sendMessage(ChatMessageVO vo, String userNo) {

        // 1️⃣ memberId 찾기
        String memberId = mapper.selectMemberId(vo.getChatRoomNo(), userNo);

        vo.setChatMemberId(memberId);

        // 2️⃣ 메시지 저장
        mapper.insertMessage(vo);

        // 3️⃣ 읽음 처리까지 넣어도 좋음 (옵션)
    }

    @Override
    public void enterRoom(String chatRoomNo, String userNo) {

        String memberId = mapper.selectMemberId(chatRoomNo, userNo);

        if (memberId == null) {
            mapper.insertMember(chatRoomNo, userNo);
        }
    }

}
