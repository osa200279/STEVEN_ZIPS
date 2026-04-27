package kr.or.ddit.domain.central.contract.mapper;

import kr.or.ddit.domain.central.contract.vo.ContractVO;
import kr.or.ddit.domain.central.contract.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.contract.vo.RentContractVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface ContractMapper {
    int selectContractCount(PaginationInfoVO<ContractVO> pagingVO);
    List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO);

    void insertContract(RentContractVO rentContractVO);

    ContractVO selectContractDetail(String ctrtNo);
}
