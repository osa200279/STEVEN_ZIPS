package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;

import java.util.List;

public interface IAnnRegisterService {
    List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm);
}
