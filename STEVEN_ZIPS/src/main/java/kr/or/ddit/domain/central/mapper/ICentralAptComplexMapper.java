package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ICentralAptComplexMapper {


    int selectAptComplexCount(
            @Param("searchWord") String searchWord,
            @Param("keyword") String keyword
    );

    // 아파트 단지 목록 조회 (페이징)
    List<AptComplexVO> selectAptComplexList(
            @Param("searchWord") String searchWord,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow
    );

    // 검색
    List<AptComplexVO> searchApt(String keyword);
}

