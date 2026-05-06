package kr.or.ddit.domain.central.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ICentralAptComplexMapper {



    // 아파트 단지 목록 조회
    public List<AptComplexVO> selectAptComplexList(@Param("initial") String initial);

    List<AptComplexVO> searchApt(String keyword);
}
