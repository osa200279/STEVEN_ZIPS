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
    public List<ResidentFacilityHistoryDTO> getFacilityHistoryList(String aptCmplexNo, int startRow, int endRow) {
        return residentFacilityMapper.selectFacilityHistoryList(aptCmplexNo, startRow, endRow);
    }

    @Override
    public int getFacilityHistoryCount(String aptCmplexNo) {
        return residentFacilityMapper.selectFacilityHistoryCount(aptCmplexNo);
    }
}