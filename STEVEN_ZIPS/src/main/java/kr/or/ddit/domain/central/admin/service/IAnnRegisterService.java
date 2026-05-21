package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;

import java.util.List;
import java.util.Map;

public interface IAnnRegisterService {
    List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm);

    Map<String, Object> selectOneAptDetail(String aptCmplexNo);

    List<Map<String, Object>> selectSbmsnDocList(String aptCmplexNo);

    void insertAnn(Map<String, Object> params);

    List<Map<String, Object>> selectRentList(String aptCmplexNo);



}
