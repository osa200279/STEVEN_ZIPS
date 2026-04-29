package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.central.admin.vo.ContractVO;
import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.admin.vo.RentContractVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface CentralMapper {
    int selectContractCount(PaginationInfoVO<ContractVO> pagingVO);
    List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO);

    void insertContract(RentContractVO rentContractVO);

    ContractVO selectContractDetail(String ctrtNo);
}
