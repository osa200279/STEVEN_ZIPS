package kr.or.ddit.domain.apt.complaint.service;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;

public interface ICvplService {
    ServiceResult applyCvpl(String userNo, String aptCmplexNo, CvplVO cvplVO);
}
