package kr.or.ddit.domain.member.resident.service;


import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;

import java.util.List;

public interface IResidentFacilityService {

    String getResidentAptCmplexNo(String userNo);

    FacilityInfoDTO getAptInfo(String aptCmplexNo);

    List<ResidentFacilityHistoryDTO> getFacilityStatusCardList(String aptCmplexNo);

    /*
     * 입주민 단지 시설 목록 조회
     *
     * facilityNm  → 시설명 검색어
     * locCn       → 상세위치 검색어
     * sortColumn  → 정렬할 DB 컬럼
     * sortOrder   → ASC 또는 DESC
     * startRow/endRow → Oracle 페이징 범위
     */
    List<FacilityInfoDTO> getResidentFacilityInfoList(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String locCn,
            String sortColumn,
            String sortOrder,
            int startRow,
            int endRow
    );

    int getResidentFacilityInfoCount(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String locCn
    );

    List<ResidentFacilityHistoryDTO> getFacilityHistoryList(
            String aptCmplexNo,
            String facilityTyCd,
            int startRow,
            int endRow
    );

    int getFacilityHistoryCount(String aptCmplexNo, String facilityTyCd);
}