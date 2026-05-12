package kr.or.ddit.domain.apt.mgmtOffice.employee.service;

import kr.or.ddit.domain.apt.mgmtOffice.employee.mapper.OfficeVhclMapper;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class OfficeVhclServiceImpl implements IOfficeVhclService {

    private final OfficeVhclMapper officeVhclMapper;
    @Override
    public int registerVehicle(RsidVhclVO vo, MultipartFile uploadFile) {

        vo.setRsidVhclNo(
                UUID.randomUUID()
                        .toString()
                        .replace("-", "")
                        .substring(0, 20)
        );

        return officeVhclMapper.insertVehicle(vo);
    }

    @Override
    public List<RsidVhclVO> getVehicleList(String mgmtOfcNo) {
        return officeVhclMapper.getVehicleList(mgmtOfcNo);
    }

    @Override
    public RsidVhclVO getVehicle(String rsidVhclNo) {
        return officeVhclMapper.selectVehicleById(rsidVhclNo);
    }

    @Override
    public int updateVehicle(RsidVhclVO vo, MultipartFile uploadFile) {
        return officeVhclMapper.updateVehicle(vo);
    }

    @Override
    public int deleteVehicle(String rsidVhclNo) {
        return officeVhclMapper.deleteVehicle(rsidVhclNo);
    }

    @Override
    public Map<String, Object> searchResident(Map<String, Object> param) {
        return officeVhclMapper.searchResident(param);
    }
}
