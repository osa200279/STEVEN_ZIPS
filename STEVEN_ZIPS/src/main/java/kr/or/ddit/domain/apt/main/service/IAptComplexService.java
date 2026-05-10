package kr.or.ddit.domain.apt.main.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;

import java.util.List;

public interface IAptComplexService {

   AptComplexVO selectAptComplex(String aptCmplexNo);

   /* public AptComplexVO selectAptDetailList(String aptCmplexNo);*/

   String selectManagerAptCmplexNo(String userNo);

   int updateAptComplex(AptComplexVO aptComplexVO);

   // 헤더, 푸터 용 DTO 셀렉트
   AptMainPageDTO.ResponseDto selectAptCommonDTO(String aptCmplexNo);

   // 아파트 메인페이지 DTO 셀렉트
   AptMainPageDTO.ResponseDto selectAptMainDTO(String aptCmplexNo);

   List<String> selectSidoList();

   int selectMainAptCount(String sidoNm, String keyword);

   List<AptComplexVO> selectMainAptList(PaginationInfoVO<AptComplexVO> pagingVO,
                                        String sidoNm,
                                        String keyword);

}
