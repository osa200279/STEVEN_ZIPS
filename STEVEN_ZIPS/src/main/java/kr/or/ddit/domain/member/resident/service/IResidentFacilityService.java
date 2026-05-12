package kr.or.ddit.domain.member.resident.service;


import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;

import java.util.List;

public interface IResidentFacilityService {

    String getResidentAptCmplexNo(String userNo);

    FacilityInfoDTO getAptInfo(String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> getFacilityStatusCardList(String aptCmplexNo);

    /*
     * 입주민이 본인 단지의 시설 목록을 확인하기 위한 조회
     */
    List<FacilityInfoDTO> getResidentFacilityInfoList(String aptCmplexNo, String facilityTyCd);

    List<ResidentFacilityHistoryDTO> getFacilityHistoryList(
            String aptCmplexNo,
            String facilityTyCd,
            int startRow,
            int endRow
    );

    int getFacilityHistoryCount(String aptCmplexNo, String facilityTyCd);
}