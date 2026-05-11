package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.vo.ContractUserVO;
import kr.or.ddit.domain.central.vo.RentCtrtVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IContractUserMapper {

    String selectRentCtrtNo(String userNo);

    void insertContractDoc(ContractUserVO contractUserVO);

    List<ContractUserVO> selectContractDoc(String userNo);

    void insertRentCtrtVO(RentCtrtVO rentCtrtVO);

    String selectRentLstgNo(String aptCmplexNo);
}
