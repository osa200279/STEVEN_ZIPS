package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.common.webSocket.chat.vo.ChatRoomVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IVhclMapper {

    List<RsidVhclVO> selectMyVhclList(String userNo, String aptCmplexNo);

    int existsVhclNo(String vhclNo);

    void insertVhcl(RsidVhclVO vhcl);

    List<String> selectMyHoList(String userNo);

    int countVhclByHoList(List<String> hoList);

    int countMyVhcl(String userNo, String hoNo);

    int selectFreePkgCnt(String aptCmplexNo);

    RsidVhclVO selectByVhclNo(String vhclNo);

    void deleteVhcl(String rsidVhclNo,String userNo);
}
