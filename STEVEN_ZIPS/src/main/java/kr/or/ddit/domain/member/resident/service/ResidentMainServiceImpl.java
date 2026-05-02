package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.mapper.IResidentMapper;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ResidentMainServiceImpl implements IResidentMainService{

    @Autowired
    IResidentMapper residentMapper;

    @Override
    public List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo) {

        return residentMapper.selectMyVhclList(userNo,aptCmplexNo);
    }

    @Override
    public List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo) {

        return residentMapper.selectMyRoomList(userNo, aptCmplexNo);
    }

}
