package kr.or.ddit.domain.apt.complaint.service;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.domain.apt.complaint.mapper.ICvplMapper;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CvplServiceImpl implements ICvplService {

    @Autowired
    private ICvplMapper cvplMapper;

    @Override
    public ServiceResult applyCvpl(String userNo, String aptCmplexNo, CvplVO cvplVO) {

        return null;
    }
}
