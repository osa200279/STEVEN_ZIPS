package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;

import java.util.List;

public interface IResidentMainService {
    List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo);

    List<ChatRoomVO> selectMyRoomList(String userNo, String aptNo);
}
