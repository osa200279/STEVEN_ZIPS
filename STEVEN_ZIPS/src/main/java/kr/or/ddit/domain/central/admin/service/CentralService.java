package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.central.admin.vo.ContractVO;
import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.admin.vo.RentContractVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface CentralService {
    void insertContract(RentContractVO vo, MultipartFile[] files) throws Exception;

    int selectContractCount(PaginationInfoVO<ContractVO> pagingVO);

    List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO);

    ContractVO selectContractDeatil(String ctrtNo);
}
