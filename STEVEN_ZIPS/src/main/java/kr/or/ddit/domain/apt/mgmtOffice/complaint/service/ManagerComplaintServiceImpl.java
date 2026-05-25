package kr.or.ddit.domain.apt.mgmtOffice.complaint.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.dto.ManagerComplaintDTO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.mapper.ManagerComplaintMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ManagerComplaintServiceImpl implements ManagerComplaintService{

    private final ManagerComplaintMapper managerComplaintMapper;

    @Override
    public int selectComplaintCount(PaginationInfoVO<ManagerComplaintDTO> page) {
        return managerComplaintMapper.selectComplaintCount(page);
    }

    @Override
    public List<ManagerComplaintDTO> selectComplaintList(PaginationInfoVO<ManagerComplaintDTO> page) {
        return managerComplaintMapper.selectComplaintList(page);
    }

    @Transactional
    public void updateComplaint(ManagerComplaintDTO dto) {
        managerComplaintMapper.updateCvplStts(dto);
        managerComplaintMapper.insertCvplHstry(dto);
    }
}
