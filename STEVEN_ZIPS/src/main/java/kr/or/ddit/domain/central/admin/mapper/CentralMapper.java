package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.central.admin.vo.*;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.ui.Model;
import java.util.List;


@Mapper
public interface CentralMapper {

    int selectContractCount(PaginationInfoVO<ContractVO> pagingVO);

    List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO);

    void insertContract(ContractVO contractVO);

    ContractVO selectOneContract(String ctrtNo);

    int updateContract(ContractVO contractVO);

    void contractModifyStatus(@Param("rentCtrtNo") String rentCtrtNo, @Param("status") String status);

    void contractFormInsert(ContractFormVO contractFormVO);

    void contractFormDelete(@Param("frmNo") String frmNo);

    List<ContractFormVO> contractForm(Model model);

    int selectContractFormCount(PaginationInfoVO<ContractFormVO> pagingVO);

    List<ContractFormVO> SelectContractFormList(PaginationInfoVO<ContractFormVO> pagingVO);

    ContractFormVO selectOneContractForm(String frmNo);

    void contractFormUpdate(ContractFormVO contractFormVO);

    int selectContractDocCount(PaginationInfoVO<ContractDocVO> pagingVO);

    List<ContractDocVO> selectContractDocList(PaginationInfoVO<ContractDocVO> pagingVO);




}
