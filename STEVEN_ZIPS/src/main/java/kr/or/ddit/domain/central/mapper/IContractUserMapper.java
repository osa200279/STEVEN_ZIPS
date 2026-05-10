package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.central.vo.ContractUserVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IContractUserMapper {

    String selectRentCtrtNo(String userNo);

    void insertContractDoc(ContractUserVO contractUserVO);

    List<ContractUserVO> selectContractDoc(String userNo);
}
