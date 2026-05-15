package kr.or.ddit.domain.apt.mgmtOffice.resident.service;

import kr.or.ddit.domain.apt.mgmtOffice.resident.mapper.IMngResidentAuthMapper;
import kr.or.ddit.domain.apt.mgmtOffice.resident.vo.MngResidentAuthVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MngResidentAuthServiceImpl implements IMngResidentAuthService {

    private final IMngResidentAuthMapper mapper;

    @Override
    public List<MngResidentAuthVO> selectResidentAuthList() {
        return mapper.selectResidentAuthList();
    }

    @Override
    public int rejectResidentAuth(MngResidentAuthVO vo) {
        return mapper.rejectResidentAuth(vo);
    }

    @Override
    public int approveResidentAuth(MngResidentAuthVO vo) {
        return mapper.approveResidentAuth(vo);
    }
}
