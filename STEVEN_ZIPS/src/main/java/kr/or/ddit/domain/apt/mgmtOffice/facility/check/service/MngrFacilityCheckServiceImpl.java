package kr.or.ddit.domain.apt.mgmtOffice.facility.check.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.mapper.IFacilityCheckHstryMapper;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckCodeVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 시설 점검 이력 Service 구현체
 */
@Service
@RequiredArgsConstructor
public class MngrFacilityCheckServiceImpl implements IMngrFacilityCheckService {

    /** 시설 점검 이력 Mapper */
    private final IFacilityCheckHstryMapper facilityCheckHstryMapper;

    /** 시설 점검 이력 목록 건수 조회 */
    @Override
    public int selectFacilityCheckCount(PaginationInfoVO<FacilityCheckHstryVO> pagingVO) {
        return facilityCheckHstryMapper.selectFacilityCheckCount(pagingVO);
    }

    /** 시설 점검 이력 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFacilityCheckList(PaginationInfoVO<FacilityCheckHstryVO> pagingVO) {
        return facilityCheckHstryMapper.selectFacilityCheckList(pagingVO);
    }

    /** 시설 점검 이력 현황 카드 건수 조회 */
    @Override
    public FacilityCheckHstryVO selectFacilityCheckSummary(String mgmtOfcNo) {
        /* 관리사무소 전체 기준 현황 건수 조회 */
        return facilityCheckHstryMapper.selectFacilityCheckSummary(mgmtOfcNo);
    }

    /** 시설 점검 이력 상세 조회 */
    @Override
    public FacilityCheckHstryVO selectFacilityCheckDetail(String mgmtOfcNo, String facChkHstryNo) {
        return facilityCheckHstryMapper.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);
    }

    /** 시설 선택 모달 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFacilitySelectList(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectFacilitySelectList(mgmtOfcNo);
    }

    /** 협력업체 선택 모달 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectPartnerSelectList(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectPartnerSelectList(mgmtOfcNo);
    }

    /** 점검유형 공통코드 목록 조회 */
    @Override
    public List<FacilityCheckCodeVO> selectCheckTypeList() {
        return facilityCheckHstryMapper.selectCommonCodeList("CHECK_TY");
    }

    /** 점검상태 공통코드 목록 조회 */
    @Override
    public List<FacilityCheckCodeVO> selectCheckStatusList() {
        return facilityCheckHstryMapper.selectCommonCodeList("CHECK_STTS");
    }

    /** 시설 점검 이력 등록 */
    @Override
    @Transactional
    public String insertFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO) {
        facilityCheckHstryMapper.insertFacilityCheckHistory(facilityCheckHstryVO);
        return facilityCheckHstryVO.getFacChkHstryNo();
    }

    /** 시설 점검 이력 수정 */
    @Override
    @Transactional
    public boolean updateFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO) {
        return facilityCheckHstryMapper.updateFacilityCheckHistory(facilityCheckHstryVO) > 0;
    }
}
