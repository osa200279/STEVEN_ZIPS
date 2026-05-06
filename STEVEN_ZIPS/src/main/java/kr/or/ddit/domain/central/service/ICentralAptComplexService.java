package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;

import java.util.List;

public interface ICentralAptComplexService {

    List<AptComplexVO> selectAptComplexList(
            PaginationInfoVO<AptComplexVO> pagingVO
    );

    List<AptComplexVO> searchApt(String keyword);

    int selectAptComplexCount(String initial);
}
