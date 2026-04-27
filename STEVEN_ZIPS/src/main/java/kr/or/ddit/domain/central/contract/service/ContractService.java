package kr.or.ddit.domain.central.contract.service;

import kr.or.ddit.domain.central.contract.vo.ContractVO;
import kr.or.ddit.domain.central.contract.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.contract.vo.RentContractVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface ContractService {
    void insertContract(RentContractVO vo, MultipartFile[] files) throws Exception;

    int selectContractCount(PaginationInfoVO<ContractVO> pagingVO);

    List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO);

    ContractVO selectContractDeatil(String ctrtNo);
}
