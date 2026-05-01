package kr.or.ddit.domain.member.manager.servcie;

import kr.or.ddit.domain.apt.dto.AptMainDTO;
import kr.or.ddit.domain.apt.vo.AptComplexVO;

public interface IAptComplexService {

   AptComplexVO selectAptComplex(String aptCmplexNo);

    /* public AptComplexVO selectAptDetailList(String aptCmplexNo);*/

   String selectManagerAptCmplexNo(String userNo);

   int updateAptComplex(AptComplexVO aptComplexVO);

   // 아파트 메인페이지 DTO 셀렉트
   AptMainDTO selectAptMainDTO(String aptCmplexNo);
}
