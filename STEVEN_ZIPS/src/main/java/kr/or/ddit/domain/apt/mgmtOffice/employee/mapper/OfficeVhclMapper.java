package kr.or.ddit.domain.apt.mgmtOffice.employee.mapper;


import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;

@Mapper
public interface OfficeVhclMapper {

    int insertVehicle(RsidVhclVO vo);

    List<RsidVhclVO> getVehicleList();

    int deleteVehicle(String rsidVhclNo);
}
