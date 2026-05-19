package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AnnRegisterMapper {
    List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm);
}
