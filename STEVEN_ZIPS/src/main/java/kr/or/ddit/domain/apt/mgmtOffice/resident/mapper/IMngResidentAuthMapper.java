package kr.or.ddit.domain.apt.mgmtOffice.resident.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentAuthVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IMngResidentAuthMapper {

    List<MngResidentAuthVO> selectResidentAuthList();

    int rejectResidentAuth(MngResidentAuthVO vo);

    int approveResidentAuth(MngResidentAuthVO vo);
}
