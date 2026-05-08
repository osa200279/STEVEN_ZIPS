package kr.or.ddit.domain.apt.mgmtOffice.mapper;

import kr.or.ddit.domain.member.manager.vo.MngrVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IMngrMapper {

    MngrVO selectOneMngrInfo(String userNo);
}
