package kr.or.ddit.domain.apt.manager.service;

import kr.or.ddit.domain.apt.manager.mapper.IAptComplexMapper;
import kr.or.ddit.domain.apt.vo.AptComplexVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AptComplexServiceImpl implements IAptComplexService{

    @Autowired
    private IAptComplexMapper aptComplexMapper;

    @Override
    public AptComplexVO selectAptComplex(String aptCmplexNo) {
        return aptComplexMapper.selectAptComplex(aptCmplexNo);
    }

    /*@Override
    public AptComplexVO selectAptDetailList(String aptCmplexNo) {
        return aptComplexMapper.selectAptDetailList(aptCmplexNo);
    }*/

    @Override
    @Transactional
    public int updateAptComplex(AptComplexVO aptComplexVO) {
        return aptComplexMapper.updateAptComplex(aptComplexVO);
    }
}
