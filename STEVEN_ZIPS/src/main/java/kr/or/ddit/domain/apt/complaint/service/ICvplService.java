package kr.or.ddit.domain.apt.complaint.service;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.domain.apt.complaint.vo.CvplHstryVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.List;

public interface ICvplService {
    ServiceResult applyCvpl(CvplVO cvplVO, MultipartFile[] attachFiles) throws GeneralSecurityException, IOException;

    List<CvplHstryVO> selectCvplHstryList(String aptCmplexNo, String userNo);
}
