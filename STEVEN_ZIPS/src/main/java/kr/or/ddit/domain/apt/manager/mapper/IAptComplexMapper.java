package kr.or.ddit.domain.apt.manager.mapper;

import kr.or.ddit.domain.apt.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IAptComplexMapper {
    public AptComplexVO selectAptComplex(String aptCmplexNo);   // 단지 1건 조회

//    public AptComplexVO selectAptDetailList(String aptCmplexNo);    // 단지 세대/호실 목록 조회

    public int updateAptComplex(AptComplexVO aptComplexVO); // 단지 정보 수정
}
