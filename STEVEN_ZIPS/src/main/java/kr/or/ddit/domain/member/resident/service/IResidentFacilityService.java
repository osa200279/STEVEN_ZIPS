package kr.or.ddit.domain.member.resident.service;


import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;

import java.util.List;

public interface IResidentFacilityService {

    String getResidentAptCmplexNo(String userNo);

    FacilityInfoDTO getAptInfo(String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> getFacilityStatusCardList(String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> getFacilityHistoryList(String aptCmplexNo, int startRow, int endRow);

    int getFacilityHistoryCount(String aptCmplexNo);
}