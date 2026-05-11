package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

public interface IOfficeVhclService {


    int registerVehicle(RsidVhclVO vo, MultipartFile uploadFile);

    List<RsidVhclVO> getVehicleList();

    int deleteVehicle(String rsidVhclNo);
}
