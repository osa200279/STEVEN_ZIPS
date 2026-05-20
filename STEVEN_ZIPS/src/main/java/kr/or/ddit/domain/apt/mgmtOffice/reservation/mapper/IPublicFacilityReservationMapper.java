package kr.or.ddit.domain.apt.mgmtOffice.reservation.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

/**
 * Mapper란? Java 메서드와 SQL XML을 연결하는 인터페이스입니다.
 * 왜 사용? Controller가 SQL을 직접 알지 않게 분리하기 위해 사용합니다.
 */
@Mapper
public interface IPublicFacilityReservationMapper {
    String selectAptCmplexNoByMgmtOfcNo(@Param("mgmtOfcNo") String mgmtOfcNo);
    String selectAptCmplexNoByResidentUserNo(@Param("userNo") String userNo);
    String selectNextRsvtNo();

    int selectFacilityListCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectFacilityList(PublicFacilityReservationVO searchVO);

    int selectApprovalListCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectApprovalList(PublicFacilityReservationVO searchVO);

    int selectUseHistoryCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectUseHistoryList(PublicFacilityReservationVO searchVO);

    int selectResidentFacilityListCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectResidentFacilityList(PublicFacilityReservationVO searchVO);

    int selectMyReservationCount(PublicFacilityReservationVO searchVO);
    List<PublicFacilityReservationVO> selectMyReservationList(PublicFacilityReservationVO searchVO);
    PublicFacilityReservationVO selectMyReservationDetail(PublicFacilityReservationVO searchVO);

    int insertReservation(PublicFacilityReservationVO vo);
    int approveReservation(PublicFacilityReservationVO vo);
    int rejectReservation(PublicFacilityReservationVO vo);
    int cancelReservation(PublicFacilityReservationVO vo);
    int selectDuplicateReservationCount(PublicFacilityReservationVO vo);
}
