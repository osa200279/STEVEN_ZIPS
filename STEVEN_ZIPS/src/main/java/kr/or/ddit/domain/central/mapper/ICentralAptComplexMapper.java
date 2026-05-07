package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ICentralAptComplexMapper {


    int selectAptComplexCount(
            @Param("searchWord") String searchWord,
            @Param("keyword") String keyword,
            @Param("searchVO") AptComplexVO searchVO

    );

    // 아파트 단지 목록 조회 (페이징)
    List<AptComplexVO> selectAptComplexList(
            @Param("searchWord") String searchWord,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow,
            @Param("searchVO") AptComplexVO searchVO
    );

    // 시/도 목록 조회
    List<String> selectSidoList();

    // 검색
    List<AptComplexVO> searchApt(String keyword);

    List<String> selectSigunguList(String sido);
}

