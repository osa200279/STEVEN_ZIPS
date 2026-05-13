package kr.or.ddit.domain.member.resident.service;


import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;
import kr.or.ddit.domain.member.resident.mapper.IResidentFacilityMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 입주민 시설관리이력 Service 구현체
 *
 * Service란?
 * → Controller와 Mapper 사이에서 업무 로직을 처리하는 클래스.
 */
@Service
@RequiredArgsConstructor
public class ResidentFacilityServiceImpl implements IResidentFacilityService {

    private final IResidentFacilityMapper residentFacilityMapper;

    @Override
    public String getResidentAptCmplexNo(String userNo) {
        return residentFacilityMapper.selectResidentAptCmplexNo(userNo);
    }

    @Override
    public FacilityInfoDTO getAptInfo(String aptCmplexNo) {
        return residentFacilityMapper.selectAptInfo(aptCmplexNo);
    }

    @Override
    public List<ResidentFacilityHistoryDTO> getFacilityStatusCardList(String aptCmplexNo) {
        return residentFacilityMapper.selectFacilityStatusCardList(aptCmplexNo);
    }

    @Override
    public List<FacilityInfoDTO> getResidentFacilityInfoList(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String locCn,
            String sortColumn,
            String sortOrder,
            int startRow,
            int endRow
    ) {
        return residentFacilityMapper.selectResidentFacilityInfoList(
                aptCmplexNo,
                facilityTyCd,
                facilityNm,
                locCn,
                sortColumn,
                sortOrder,
                startRow,
                endRow
        );
    }

    @Override
    public int getResidentFacilityInfoCount(
            String aptCmplexNo,
            String facilityTyCd,
            String facilityNm,
            String locCn
    ) {
        return residentFacilityMapper.selectResidentFacilityInfoCount(
                aptCmplexNo,
                facilityTyCd,
                facilityNm,
                locCn
        );
    }


    @Override
    public List<ResidentFacilityHistoryDTO> getFacilityHistoryList(
            String aptCmplexNo,
            String facilityTyCd,
            int startRow,
            int endRow
    ) {

        /*
         * 시설 점검 상세 이력도 시설유형으로 필터링해야 하므로
         * aptCmplexNo만 넘기면 부족하다.
         */
        return residentFacilityMapper.selectFacilityHistoryList(
                aptCmplexNo,
                facilityTyCd,
                startRow,
                endRow
        );
    }

    @Override
    public int getFacilityHistoryCount(String aptCmplexNo, String facilityTyCd) {

        /*
         * 페이징 전체 개수도 검색조건과 동일해야 한다.
         * 목록은 필터링했는데 count는 전체를 세면 페이지 수가 틀어진다.
         */
        return residentFacilityMapper.selectFacilityHistoryCount(aptCmplexNo, facilityTyCd);
    }


}