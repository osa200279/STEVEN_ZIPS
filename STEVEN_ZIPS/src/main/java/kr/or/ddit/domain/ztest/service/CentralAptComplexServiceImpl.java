package kr.or.ddit.domain.ztest.service;

import kr.or.ddit.domain.apt.vo.AptComplexVO;
import kr.or.ddit.domain.ztest.mapper.ICentralAptComplexMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CentralAptComplexServiceImpl implements ICentralAptComplexService {

    @Autowired
    private ICentralAptComplexMapper aptComplexMapper;

    @Override
    public List<AptComplexVO> selectAptComplexList(String initial) {
        return aptComplexMapper.selectAptComplexList(initial);
    }
}
