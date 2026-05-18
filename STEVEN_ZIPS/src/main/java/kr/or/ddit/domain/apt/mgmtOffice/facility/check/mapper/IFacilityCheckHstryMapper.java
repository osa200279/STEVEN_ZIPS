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
    FacilityCheckHstryVO selectFacilityCheckDetail(@Param("mgmtOfcNo") String mgmtOfcNo,
                                                   @Param("facChkHstryNo") String facChkHstryNo);

    /** 시설 선택 모달 목록 조회 */
    List<FacilityCheckHstryVO> selectFacilitySelectList(@Param("mgmtOfcNo") String mgmtOfcNo);

    /** 협력업체 선택 모달 목록 조회 */
    List<FacilityCheckHstryVO> selectPartnerSelectList(@Param("mgmtOfcNo") String mgmtOfcNo);

    /** 공통코드 목록 조회 */
    List<FacilityCheckCodeVO> selectCommonCodeList(@Param("groupCodeNo") String groupCodeNo);

    /** 시설 점검 이력 등록 */
    int insertFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO);

    /** 시설 점검 이력 수정 */
    int updateFacilityCheckHistory(FacilityCheckHstryVO facilityCheckHstryVO);
}
