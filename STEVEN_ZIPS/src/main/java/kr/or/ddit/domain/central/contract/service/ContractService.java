package kr.or.ddit.domain.central.contract.service;

import kr.or.ddit.domain.central.contract.vo.ContractVO;
import kr.or.ddit.domain.central.contract.vo.PaginationInfoVO;

import java.util.List;

public interface ContractService {
    int selectContractCount(PaginationInfoVO<ContractVO> pagingVO);

    List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO);
}
