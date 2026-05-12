package kr.or.ddit.domain.apt.main.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IAptComplexMapper {
    AptComplexVO selectAptComplex(String aptCmplexNo);   // 단지 1건 조회

//  AptComplexVO selectAptDetailList(String aptCmplexNo);    // 단지 세대/호실 목록 조회

    int updateAptComplex(AptComplexVO aptComplexVO); // 단지 정보 수정

    String selectManagerAptCmplexNo(String userId);

    List<String> selectSidoList();

    int selectMainAptCount(@Param("sidoNm") String sidoNm,
                           @Param("keyword") String keyword);

    List<AptComplexVO> selectMainAptList(@Param("pagingVO") PaginationInfoVO<AptComplexVO> pagingVO,
                                         @Param("sidoNm") String sidoNm,
                                         @Param("keyword") String keyword);

    AptComplexVO selectMgmtOfcNoAptComplex(String mgmtOfcNo);
}
