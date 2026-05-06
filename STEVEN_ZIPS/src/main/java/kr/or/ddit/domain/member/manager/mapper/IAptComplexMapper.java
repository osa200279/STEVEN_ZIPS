package kr.or.ddit.domain.member.manager.mapper;

import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IAptComplexMapper {
    AptComplexVO selectAptComplex(String aptCmplexNo);   // 단지 1건 조회

//  AptComplexVO selectAptDetailList(String aptCmplexNo);    // 단지 세대/호실 목록 조회

    int updateAptComplex(AptComplexVO aptComplexVO); // 단지 정보 수정

    String selectManagerAptCmplexNo(String userId);

    AptMainPageDTO selectAptMainDTO(String aptCmplexNo);
}
