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
     * 시설 점검 이력 등록
     * - Mapper insert 후 selectKey 또는 RETURNING 방식으로 세팅된 facChkHstryNo 반환
     */
    @Override
    @Transactional
    public String insertFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO) {
        /* 시설 점검 이력 등록 */
        facilityCheckHstryMapper.insertFacilityCheckHistory(facilityCheckHstryVO);

        /* 등록 후 생성된 이력번호 반환 */
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
     * - 상세 화면의 같은 시설 이력 목록
     * - 등록/수정 통합 폼의 왼쪽 이력 목록
     * - 시설 선택 후 AJAX 이력 목록 갱신
     */
    @Override
    public List<FacilityCheckHstryVO> selectSameFacilityCheckList(String mgmtOfcNo, String facilityNo) {
        return facilityCheckHstryMapper.selectSameFacilityCheckList(mgmtOfcNo, facilityNo);
    }

    /**
     * 시설 선택 모달 서버 검색 목록 조회
     * - 시설유형, 동, 사용여부, 위치, 통합검색 조건 기준 시설 목록 조회
     */
    @Override
    public List<FacilityCheckHstryVO> selectFacilitySearchList(FacilityCheckHstryVO searchVO) {
        return facilityCheckHstryMapper.selectFacilitySearchList(searchVO);
    }

    /**
     * 협력업체 선택 모달 서버 검색 목록 조회
     * - 업종, 사용여부, 담당자명, 통합검색 조건 기준 협력업체 목록 조회
     */
    @Override
    public List<FacilityCheckHstryVO> selectPartnerSearchList(FacilityCheckHstryVO searchVO) {
        return facilityCheckHstryMapper.selectPartnerSearchList(searchVO);
    }
}