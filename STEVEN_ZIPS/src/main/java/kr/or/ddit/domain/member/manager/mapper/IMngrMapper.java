package kr.or.ddit.domain.member.manager.mapper;

import kr.or.ddit.domain.member.manager.vo.MngrVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IMngrMapper {

    MngrVO selectOneMngrInfo(String userNo);
}
