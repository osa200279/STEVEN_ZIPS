package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IResidentMapper {

    ResidentVO getResidentInfo(String userNo);

    List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo);

    List<ChatRoomVO> selectMyRoomList(String userNo, String aptCmplexNo);

    int existsVhclNo(String vhclNo);

    void insertVhcl(RsidVhclVO vo);
}
