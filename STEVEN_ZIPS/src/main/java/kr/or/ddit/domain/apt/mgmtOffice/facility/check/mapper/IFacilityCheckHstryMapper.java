package kr.or.ddit.domain.apt.mgmtOffice.facility.check.mapper;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckCodeVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 시설 점검 이력 Mapper
 * - FACILITY_CHECK_HSTRY 목록/상세/등록/수정
 * - 등록/수정 폼 선택 모달용 시설/협력업체 조회
 * - 같은 시설 기존 이력 조회
 * - 시설 선택 모달 optgroup 렌더링용 시설유형 목록 조회
 */
@Mapper
public interface IFacilityCheckHstryMapper {

    /** 시설 점검 이력 전체 건수 조회 */
    int selectFacilityCheckCount(PaginationInfoVO<FacilityCheckHstryVO> pagingVO);

    /** 시설 점검 이력 목록 조회 */
    List<FacilityCheckHstryVO> selectFacilityCheckList(PaginationInfoVO<FacilityCheckHstryVO> pagingVO);

    /** 시설 점검 이력 현황 카드 건수 조회 */
    FacilityCheckHstryVO selectFacilityCheckSummary(@Param("mgmtOfcNo") String mgmtOfcNo);

    /** 시설 점검 이력 상세 조회 */
    FacilityCheckHstryVO selectFacilityCheckDetail(
            @Param("mgmtOfcNo") String mgmtOfcNo,
            @Param("facChkHstryNo") String facChkHstryNo
    );

    /** 시설 선택 모달 기본 목록 조회 */
    List<FacilityCheckHstryVO> selectFacilitySelectList(@Param("mgmtOfcNo") String mgmtOfcNo);

    /** 협력업체 선택 모달 기본 목록 조회 */
    List<FacilityCheckHstryVO> selectPartnerSelectList(@Param("mgmtOfcNo") String mgmtOfcNo);

    /** 공통코드 목록 조회 */
    List<FacilityCheckCodeVO> selectCommonCodeList(@Param("groupCodeNo") String groupCodeNo);

    /**
     * 일반 시설자산 유형 목록 조회
     * - ELV/WTR/ELC/GAS/FIRE/SEC/ETC 코드 기준
     * - 시설 선택 모달 시설유형 셀렉트 optgroup(일반시설) 렌더링용
     */
    List<FacilityCheckCodeVO> selectAssetFacilityTypeList();

    /**
     * 편의시설 유형 목록 조회
     * - 일반 시설자산 코드를 제외한 나머지 FACILITY_TY 코드
     * - 시설 선택 모달 시설유형 셀렉트 optgroup(편의시설) 렌더링용
     */
    List<FacilityCheckCodeVO> selectPublicFacilityTypeList();

    /** 시설 점검 이력 등록 */
    int insertFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO);

    /** 시설 점검 이력 수정 */
    int updateFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO);

    /**
     * 선택한 시설의 기존 점검 이력 목록 조회
     * - 상세 화면의 같은 시설 이력 목록
     * - 등록/수정 통합 폼 왼쪽 이력 목록
     * - 시설 선택 후 AJAX 이력 목록 갱신
     */
    List<FacilityCheckHstryVO> selectSameFacilityCheckList(
            @Param("mgmtOfcNo") String mgmtOfcNo,
            @Param("facilityNo") String facilityNo
    );

    /**
     * 시설 선택 모달 서버 검색 목록 조회
     * - 시설유형, 동, 사용여부, 위치, 통합검색 조건 기준 시설 목록 조회
     */
    List<FacilityCheckHstryVO> selectFacilitySearchList(FacilityCheckHstryVO searchVO);

    /**
     * 협력업체 선택 모달 서버 검색 목록 조회
     * - 업종, 사용여부, 담당자명, 통합검색 조건 기준 협력업체 목록 조회
     */
    List<FacilityCheckHstryVO> selectPartnerSearchList(FacilityCheckHstryVO searchVO);
}