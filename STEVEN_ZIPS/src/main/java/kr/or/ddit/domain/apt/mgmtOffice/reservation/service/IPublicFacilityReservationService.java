package kr.or.ddit.domain.apt.mgmtOffice.reservation.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;

public interface IPublicFacilityReservationService {
    String getManagerAptCmplexNo(String mgmtOfcNo);
    String getResidentAptCmplexNo(String userNo);

    PaginationInfoVO<PublicFacilityReservationVO> getFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getApprovalPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getUseHistoryPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getResidentFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage);
    PaginationInfoVO<PublicFacilityReservationVO> getMyReservationPaging(PublicFacilityReservationVO searchVO, int currentPage);

    PublicFacilityReservationVO getMyReservationDetail(PublicFacilityReservationVO searchVO);
    String reserve(PublicFacilityReservationVO vo);
    void approve(PublicFacilityReservationVO vo);
    void reject(PublicFacilityReservationVO vo);
    void cancel(PublicFacilityReservationVO vo);
}
