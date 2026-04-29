package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.central.admin.vo.*;
import org.springframework.ui.Model;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface CentralService {
    void insertContract(RentContractVO vo, MultipartFile[] files) throws Exception;

    int selectContractCount(PaginationInfoVO<ContractVO> pagingVO);

    List<ContractVO> selectContractList(PaginationInfoVO<ContractVO> pagingVO);

    ContractVO selectContractDeatil(String ctrtNo);

    void updateContract(RentContractVO vo, MultipartFile[] files) throws Exception;

    void contractModifyStatus(String rentCtrtNo, String status);

    void insertContractForm(ContractFormVO contractFormVO, MultipartFile formFile);
    void deleteContractForm(String frmNo);

    List<ContractAptVO> contractForm(Model model);

    int selectContractFormCount(PaginationInfoVO<ContractFormVO> pagingVO);

    List<ContractFormVO> selectContractFormList(PaginationInfoVO<ContractFormVO> pagingVO);


    ContractFormVO contractFormDetail(String frmNo);

    void contractFormUpdate(ContractFormVO contractFormVO);
}
