package kr.or.ddit.domain.member.manager.servcie;

import kr.or.ddit.domain.member.manager.mapper.IAptComplexMapper;
import kr.or.ddit.domain.apt.vo.AptComplexVO;
import kr.or.ddit.domain.member.manager.servcie.IAptComplexService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AptComplexServiceImpl implements IAptComplexService {

    @Autowired
    private IAptComplexMapper aptComplexMapper;

    @Override
    public AptComplexVO selectAptComplex(String aptCmplexNo) {
        return aptComplexMapper.selectAptComplex(aptCmplexNo);
    }

   /* @Override
    public AptComplexVO selectAptDetailList(String aptCmplexNo) {
        return aptComplexMapper.selectAptDetailList(aptCmplexNo);
    }*/

    @Override
    public String selectManagerAptCmplexNo(String userNo) {
        return aptComplexMapper.selectManagerAptCmplexNo(userNo);
    }

    @Override
    @Transactional
    public int updateAptComplex(AptComplexVO aptComplexVO) {
        return aptComplexMapper.updateAptComplex(aptComplexVO);
    }

    /**
     * 단지 정보 가져오기
     * @param aptCmplexNo 아파트 단지 코드
     * @return AptComplexVO
     */
    @Override
    public AptComplexVO getAptCmplexInfo(String aptCmplexNo) {
        return aptComplexMapper.getAptCmplexInfo(aptCmplexNo);
    }
}
