package kr.or.ddit.domain.ztest.service;

import kr.or.ddit.domain.ztest.vo.FacilityHistoryVO;

import java.util.List;

public interface IFacilityHistoryService {
    List<FacilityHistoryVO> getFacilityHistoryList();

    FacilityHistoryVO getFacilityHistoryDetail(String id);
}
