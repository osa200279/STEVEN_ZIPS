package kr.or.ddit.common.webSocket.chat.service;

import kr.or.ddit.common.webSocket.chat.mapper.IChatMapper;
import kr.or.ddit.common.webSocket.chat.vo.ChatMemberVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatMessageVO;
import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.RandomStringUtils;
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
    public List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo) {
        return mapper.selectMyRoomList(userNo, aptCmplexNo);
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
            ChatMemberVO memberVO = new ChatMemberVO();

            memberVO.setChatRoomNo(chatRoomNo);
            memberVO.setUserNo(userNo);
            memberVO.setChatroleCd("MEMBER");

            mapper.insertRoomMember(memberVO);
        }
    }

    @Override
    public int insertRoomMember(ChatMemberVO memberVO) {
        return mapper.insertRoomMember(memberVO);
    }

    @Override
    @Transactional
    public ChatRoomVO createRoom(ChatRoomVO roomVO, String userNo) {

        String roomNo = mapper.getRoomNoSeq();

        String joinKey = RandomStringUtils
                .randomAlphanumeric(6)
                .toUpperCase();

        roomVO.setChatRoomNo(roomNo);
        roomVO.setChatJoinKey(joinKey);
        roomVO.setRgtrId(userNo);

        mapper.insertChatRoom(roomVO);

        ChatMemberVO memberVO = new ChatMemberVO();

        memberVO.setChatRoomNo(roomNo);
        memberVO.setUserNo(userNo);
        memberVO.setChatroleCd("OWNER");

        mapper.insertRoomMember(memberVO);

        return roomVO;
    }
}