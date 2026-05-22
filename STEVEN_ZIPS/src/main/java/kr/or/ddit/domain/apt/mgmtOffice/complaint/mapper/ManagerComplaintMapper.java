package kr.or.ddit.domain.apt.mgmtOffice.complaint.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.complaint.dto.ManagerComplaintDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface ManagerComplaintMapper {
    int selectComplaintCount(PaginationInfoVO<ManagerComplaintDTO> page);

    List<ManagerComplaintDTO> selectComplaintList(PaginationInfoVO<ManagerComplaintDTO> page);
}
