package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;

import java.util.List;

public interface ICentralAptComplexService {

    // 아파트 단지 목록 조회
    public List<AptComplexVO> selectAptComplexList(String initial);

    List<AptComplexVO> searchApt(String keyword);
}
