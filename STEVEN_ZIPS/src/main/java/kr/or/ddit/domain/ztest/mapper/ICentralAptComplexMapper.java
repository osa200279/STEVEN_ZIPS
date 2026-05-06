package kr.or.ddit.domain.ztest.mapper;

import kr.or.ddit.domain.apt.vo.AptComplexVO;
import kr.or.ddit.domain.ztest.service.ICentralAptComplexService;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper
public interface ICentralAptComplexMapper {



    // 아파트 단지 목록 조회
    public List<AptComplexVO> selectAptComplexList(@Param("initial") String initial);

    List<AptComplexVO> searchApt(String keyword);
}
