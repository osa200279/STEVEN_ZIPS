package kr.or.ddit.domain.central.admin.mapper;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AnnRegisterMapper {
    List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm);

    String selectDorojuso(String aptCmplexNo);

    List<Map<String, Object>> selectHoTyNo(String aptCmplexNo);

    List<Map<String, Object>> selectSbmsnDocList(String aptCmplexNo);

    void insertAnn(Map<String, Object> params);
}
