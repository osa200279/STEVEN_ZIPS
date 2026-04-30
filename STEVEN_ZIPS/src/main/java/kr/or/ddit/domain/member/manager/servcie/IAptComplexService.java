package kr.or.ddit.domain.member.manager.servcie;

import kr.or.ddit.domain.apt.vo.AptComplexVO;

public interface IAptComplexService {

   AptComplexVO selectAptComplex(String aptCmplexNo);

    /* public AptComplexVO selectAptDetailList(String aptCmplexNo);*/

   String selectManagerAptCmplexNo(String userNo);

   int updateAptComplex(AptComplexVO aptComplexVO);

   // 아파트 단지 정보 가져오기
   AptComplexVO getAptCmplexInfo(String aptCmplexNo);
}
