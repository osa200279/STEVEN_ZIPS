package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.central.admin.vo.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.ui.Model;
import java.util.List;


@Mapper
public interface CentralMapper {

    int selectContractCount(kr.or.ddit.domain.central.admin.vo.PaginationInfoVO<ContractVO> pagingVO);

    List<ContractVO> selectContractList(kr.or.ddit.domain.central.admin.vo.PaginationInfoVO<ContractVO> pagingVO);

    void insertContract(RentContractVO rentContractVO);

    ContractVO selectContractDetail(String ctrtNo);

    int updateContract(RentContractVO rentContractVO);

    void contractModifyStatus(@Param("rentCtrtNo") String rentCtrtNo, @Param("status") String status);

    void contractFormInsert(ContractFormVO contractFormVO);

    void contractFormDelete(@Param("frmNo") String frmNo);

    List<ContractAptVO> contractForm(Model model);

    int selectContractFormCount(kr.or.ddit.domain.central.admin.vo.PaginationInfoVO<ContractFormVO> pagingVO);

    List<ContractFormVO> SelectContractFormList(kr.or.ddit.domain.central.admin.vo.PaginationInfoVO<ContractFormVO> pagingVO);

    ContractFormVO contractFormDetail(String frmNo);

    void contractFormUpdate(ContractFormVO contractFormVO);

    int selectContractDocCount(PaginationInfoVO<ContractDocVO> pagingVO);

    List<ContractDocVO> selectContractDocList(PaginationInfoVO<ContractDocVO> pagingVO);
}
