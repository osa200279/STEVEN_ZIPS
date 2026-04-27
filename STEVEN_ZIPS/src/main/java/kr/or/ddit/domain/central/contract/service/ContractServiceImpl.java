package kr.or.ddit.domain.central.contract.service;

import kr.or.ddit.domain.central.contract.mapper.ContractMapper;
import kr.or.ddit.domain.central.contract.service.ContractService;
import kr.or.ddit.domain.central.contract.vo.ContractVO;
import kr.or.ddit.domain.central.contract.vo.PaginationInfoVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ContractServiceImpl implements ContractService {

    private final ContractMapper mapper;

    @Override
    public int selectContractCount(PaginationInfoVO<ContractVO> pagingVO) {
        return mapper.selectContractCount(pagingVO);
    }

    @Override
    public List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO) {
        return mapper.selectContractList(pagingVO);
    }


}
