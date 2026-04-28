package kr.or.ddit.domain.apt.manager.service;

import kr.or.ddit.domain.apt.vo.AptComplexVO;

public interface IAptComplexService {
   public AptComplexVO selectAptComplex(String aptCmplexNo);

//   public AptComplexVO selectAptDetailList(String aptCmplexNo);

   public int updateAptComplex(AptComplexVO aptComplexVO);
}
