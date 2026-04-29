package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IResidentMapper {

    ResidentVO getResidentInfo(String userNo);
}
