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
public class FacilityCheckServiceImpl implements IFacilityCheckService {

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
        return facilityCheckHstryMapper.selectFacilityCheckSummary(mgmtOfcNo);
    }

    /** 시설 점검 이력 상세 조회 */
    @Override
    public FacilityCheckHstryVO selectFacilityCheckDetail(String mgmtOfcNo, String facChkHstryNo) {
        return facilityCheckHstryMapper.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);
    }

    /** 시설 선택 모달 기본 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFacilitySelectList(String mgmtOfcNo) {
        return facilityCheckHstryMapper.selectFacilitySelectList(mgmtOfcNo);
    }

    /** 협력업체 선택 모달 기본 목록 조회 */
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

    /**
     * 일반 시설자산 유형 목록 조회
     * - 시설 선택 모달 optgroup(일반시설) 렌더링용
     */
    @Override
    public List<FacilityCheckCodeVO> selectAssetFacilityTypeList() {
        return facilityCheckHstryMapper.selectAssetFacilityTypeList();
    }

    /**
     * 편의시설 유형 목록 조회
     * - 시설 선택 모달 optgroup(편의시설) 렌더링용
     */
    @Override
    public List<FacilityCheckCodeVO> selectPublicFacilityTypeList() {
        return facilityCheckHstryMapper.selectPublicFacilityTypeList();
    }

    /**
     * 시설 점검 이력 등록
     * - selectKey로 채번된 facChkHstryNo 반환
     */
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

    /**
     * 선택한 시설의 기존 점검 이력 목록 조회
     * - 상세/폼 왼쪽 이력 목록, AJAX 갱신 공통 사용
     */
    @Override
    public List<FacilityCheckHstryVO> selectSameFacilityCheckList(String mgmtOfcNo, String facilityNo) {
        return facilityCheckHstryMapper.selectSameFacilityCheckList(mgmtOfcNo, facilityNo);
    }

    /** 시설 선택 모달 서버 검색 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectFacilitySearchList(FacilityCheckHstryVO searchVO) {
        return facilityCheckHstryMapper.selectFacilitySearchList(searchVO);
    }

    /** 협력업체 선택 모달 서버 검색 목록 조회 */
    @Override
    public List<FacilityCheckHstryVO> selectPartnerSearchList(FacilityCheckHstryVO searchVO) {
        return facilityCheckHstryMapper.selectPartnerSearchList(searchVO);
    }
}