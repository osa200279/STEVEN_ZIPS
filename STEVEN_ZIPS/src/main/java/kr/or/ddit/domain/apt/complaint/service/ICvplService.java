package kr.or.ddit.domain.apt.complaint.service;

import kr.or.ddit.common.enums.ServiceResult;

public interface ICvplService {
    ServiceResult applyCvpl(String userNo, String aptCmplexNo);
}
