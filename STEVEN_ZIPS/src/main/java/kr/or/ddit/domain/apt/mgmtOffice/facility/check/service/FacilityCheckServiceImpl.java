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
     * - 시설번호, 업체번호, 점검유형, 점검상태, 점검일자, 점검내용 필수값 검증
     * - 계약 관리 기능 구현 후 partnerNo + facilityNo + chkDt 기준 유효 계약 검증 예정
     * - selectKey로 채번된 facChkHstryNo 반환
     */
    @Override
    @Transactional
    public String insertFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO) {

        // 점검 이력 등록 전 필수값 검증
        validateCheckRequired(facilityCheckHstryVO);

        // TODO 계약 관리 기능 구현 후 유효 계약 검증 예정
        // - partnerNo + facilityNo + chkDt 기준
        // - 같은 업체, 같은 시설, 점검일자가 계약기간 안에 있는지 확인

        // 시설 점검 이력 등록
        facilityCheckHstryMapper.insertFacilityCheckHistory(facilityCheckHstryVO);

        // selectKey로 채번된 점검이력번호 반환
        return facilityCheckHstryVO.getFacChkHstryNo();
    }
    /**
     * 시설 점검 이력 수정
     * - 시설번호, 업체번호, 점검유형, 점검상태, 점검일자, 점검내용 필수값 검증
     * - 계약 관리 기능 구현 후 partnerNo + facilityNo + chkDt 기준 유효 계약 검증 예정
     */
    @Override
    @Transactional
    public boolean updateFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO) {

        // 점검 이력 수정 전 필수값 검증
        validateCheckRequired(facilityCheckHstryVO);

        // TODO 계약 관리 기능 구현 후 유효 계약 검증 예정
        // - 수정 시에도 점검일자 변경으로 계약기간 밖으로 벗어날 수 있으므로 확인 필요

        // 시설 점검 이력 수정
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

    /**
     * 시설 점검 이력 필수값 검증
     * - 화면 JS 검증을 우회해도 서버에서 빈 값 저장을 막기 위한 검증
     * - 계약 검증 전 기본 데이터 무결성 보장
     */
    private void validateCheckRequired(FacilityCheckHstryVO checkVO) {

        // 요청 객체 검증
        if (checkVO == null) {
            throw new IllegalArgumentException("시설 점검 이력 정보가 없습니다.");
        }

        // 시설번호 필수 검증
        if (isBlank(checkVO.getFacilityNo())) {
            throw new IllegalArgumentException("점검 대상 시설을 선택해 주세요.");
        }

        // 협력업체번호 필수 검증
        if (isBlank(checkVO.getPartnerNo())) {
            throw new IllegalArgumentException("협력업체를 선택해 주세요.");
        }

        // 점검유형 필수 검증
        if (isBlank(checkVO.getChkTyCd())) {
            throw new IllegalArgumentException("점검유형을 선택해 주세요.");
        }

        // 점검상태 필수 검증
        if (isBlank(checkVO.getChkSttsCd())) {
            throw new IllegalArgumentException("점검상태를 선택해 주세요.");
        }

        // 점검일자 필수 검증
        if (isBlank(checkVO.getChkDt())) {
            throw new IllegalArgumentException("점검일자를 입력해 주세요.");
        }

        // 점검내용 필수 검증
        if (isBlank(checkVO.getChkCn())) {
            throw new IllegalArgumentException("점검내용을 입력해 주세요.");
        }
    }

        /**
         * 문자열 공백 여부 확인
         * - null, 빈 문자열, 공백 문자열을 모두 빈 값으로 판단
         */
        private boolean isBlank(String value) {
            return value == null || value.trim().isEmpty();
        }
}