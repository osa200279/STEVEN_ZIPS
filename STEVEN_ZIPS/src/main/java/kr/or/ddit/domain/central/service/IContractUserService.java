package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.central.vo.ContractUserVO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface IContractUserService {
    void insertContractDoc(MultipartFile[] contractDocFile, List<String> docTypeList, String userNo) throws IOException;

    List<ContractUserVO> selectContractDoc(String userNo);
}
