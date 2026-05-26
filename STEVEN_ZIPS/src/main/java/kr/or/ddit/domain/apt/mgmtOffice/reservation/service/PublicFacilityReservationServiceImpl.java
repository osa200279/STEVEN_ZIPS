package kr.or.ddit.domain.apt.mgmtOffice.reservation.service;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.mapper.IPublicFacilityReservationMapper;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import java.util.List;

/**
 * ServiceImpl란? 실제 업무 규칙을 처리하는 클래스입니다.
 * 왜 사용? Controller는 요청/응답만 담당하고, 중복예약검사·승인상태변경 같은 업무는 Service에 모읍니다.
 */
@Service
@RequiredArgsConstructor
public class PublicFacilityReservationServiceImpl implements IPublicFacilityReservationService {

    private final IPublicFacilityReservationMapper mapper;

    private PaginationInfoVO<PublicFacilityReservationVO> buildPaging(
            PublicFacilityReservationVO searchVO, int currentPage, int totalRecord, List<PublicFacilityReservationVO> dataList) {
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = new PaginationInfoVO<>(10, 5);
        pagingVO.setSearchVO(searchVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setCurrentPage(currentPage);
        pagingVO.setDataList(dataList);
        return pagingVO;
    }

    private void applyPaging(PublicFacilityReservationVO searchVO, PaginationInfoVO<PublicFacilityReservationVO> pagingVO) {
        searchVO.setStartRow(pagingVO.getStartRow());
        searchVO.setEndRow(pagingVO.getEndRow());
    }

    @Override public String getManagerAptCmplexNo(String mgmtOfcNo) { return mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo); }
    @Override public String getResidentAptCmplexNo(String userNo) { return mapper.selectAptCmplexNoByResidentUserNo(userNo); }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectFacilityListCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectFacilityList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getApprovalPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectApprovalListCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectApprovalList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getUseHistoryPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectUseHistoryCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectUseHistoryList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getResidentFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectResidentFacilityListCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectResidentFacilityList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override
    public PaginationInfoVO<PublicFacilityReservationVO> getMyReservationPaging(PublicFacilityReservationVO searchVO, int currentPage) {
        int total = mapper.selectMyReservationCount(searchVO);
        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
        paging.setDataList(mapper.selectMyReservationList(searchVO)); paging.setSearchVO(searchVO);
        return paging;
    }

    @Override public PublicFacilityReservationVO getMyReservationDetail(PublicFacilityReservationVO searchVO) { return mapper.selectMyReservationDetail(searchVO); }

    @Override
    @Transactional
    public String reserve(PublicFacilityReservationVO vo) {

        /*
         * DB 기준 시설정보 조회
         * 왜 사용? 사용자가 화면에서 시설명을 조작해도 서버가 DB 기준으로 판단하기 위해 사용합니다.
         */
        PublicFacilityReservationVO facilityInfo = mapper.selectFacilityInfoByItemNo(vo);

        if (facilityInfo == null) {
            throw new IllegalArgumentException("예약 가능한 시설 정보가 없습니다.");
        }

        /*
         * 이미 예약된 시간인지 검사합니다.
         */
        if (mapper.selectDuplicateReservationCount(vo) > 0) {
            throw new IllegalStateException("이미 예약된 시간입니다.");
        }

        vo.setRsvtNo(mapper.selectNextRsvtNo());
        vo.setCmnFacilityNo(facilityInfo.getCmnFacilityNo());
        vo.setCmnFacilityNm(facilityInfo.getCmnFacilityNm());

        String facilityNm = facilityInfo.getCmnFacilityNm() == null ? "" : facilityInfo.getCmnFacilityNm();

        /*
         * 승인 정책
         * - 회의실/커뮤니티룸: 관리자 승인 필요 → PENDING
         * - 독서실/헬스장: 자동 승인 → APPROVED
         */
        if (facilityNm.contains("회의실") || facilityNm.contains("커뮤니티룸")) {
            vo.setRsvtSttsCd("PENDING");
            vo.setAutoApproveYn("N");
        } else {
            vo.setRsvtSttsCd("APPROVED");
            vo.setAutoApproveYn("Y");
        }

        mapper.insertReservation(vo);

        /*
         * 승인대기 예약도 다른 사람이 같은 시간에 중복 예약하지 못하도록
         * FACILITY_HSTRY에서 PENDING 상태로 조회되게 합니다.
         *
         * 주의:
         * PUBLIC_ITEM 자체를 REPAIR로 바꾸면 전체 시간대에서 좌석이 막힐 수 있으므로
         * 시간대별 예약 여부는 FACILITY_HSTRY 기준으로 판단하는 게 더 안전합니다.
         */
        return vo.getRsvtNo();
    }

    @Override
    @Transactional
    public void approve(PublicFacilityReservationVO vo) {
        mapper.approveReservation(vo);

        /*
         * 관리자가 승인하면 회의실 자원 상태를 USE(사용중)로 변경합니다.
         */
        mapper.updateItemStatusUse(vo);
    }

    @Override
    @Transactional
    public void reject(PublicFacilityReservationVO vo) {
        if (!StringUtils.hasText(vo.getRejectReason())) throw new IllegalArgumentException("거절사유는 필수입니다.");
        mapper.rejectReservation(vo);
    }

    @Override
    @Transactional
    public void cancel(PublicFacilityReservationVO vo) {
        /*
         * 취소 가능 조건은 Mapper에서 처리합니다.
         * Mapper 조건: 본인 예약 + 승인대기/승인완료 + 예약 시작 전
         */
        int result = mapper.cancelReservation(vo);
        if (result == 0) {
            throw new IllegalStateException("예약 시작 시간이 지났거나 취소할 수 없는 예약입니다.");
        }
    }

    @Override
    public List<PublicFacilityReservationVO> getResidentFacilityGroupList(PublicFacilityReservationVO searchVO) {
        return mapper.selectResidentFacilityGroupList(searchVO);
    }

    @Override
    public List<PublicFacilityReservationVO> getResidentFacilityItemList(PublicFacilityReservationVO searchVO) {
        return mapper.selectResidentFacilityItemList(searchVO);
    }

    @Override
    public List<String> getReservedItemNoList(PublicFacilityReservationVO searchVO) {
        return mapper.selectReservedItemNoList(searchVO);
    }

    @Override
    public List<PublicFacilityReservationVO> getReservationTimeSlotList(PublicFacilityReservationVO searchVO) {
        /*
         * 시간표 조회
         * 선택한 예약대상 + 선택한 날짜 기준으로 1시간 단위 예약현황을 조회합니다.
         */
        return mapper.selectReservationTimeSlotList(searchVO);
    }
}





//package kr.or.ddit.domain.apt.mgmtOffice.reservation.service;
//
//import kr.or.ddit.common.model.PaginationInfoVO;
//import kr.or.ddit.domain.apt.mgmtOffice.reservation.mapper.IPublicFacilityReservationMapper;
//import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
//import lombok.RequiredArgsConstructor;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//import org.springframework.util.StringUtils;
//import java.util.List;
//
///**
// * ServiceImpl란? 실제 업무 규칙을 처리하는 클래스입니다.
// * 왜 사용? Controller는 요청/응답만 담당하고, 중복예약검사·승인상태변경 같은 업무는 Service에 모읍니다.
// */
//@Service
//@RequiredArgsConstructor
//public class PublicFacilityReservationServiceImpl implements IPublicFacilityReservationService {
//
//    private final IPublicFacilityReservationMapper mapper;
//
//    private PaginationInfoVO<PublicFacilityReservationVO> buildPaging(
//            PublicFacilityReservationVO searchVO, int currentPage, int totalRecord, List<PublicFacilityReservationVO> dataList) {
//        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = new PaginationInfoVO<>(10, 5);
//        pagingVO.setSearchVO(searchVO);
//        pagingVO.setTotalRecord(totalRecord);
//        pagingVO.setCurrentPage(currentPage);
//        pagingVO.setDataList(dataList);
//        return pagingVO;
//    }
//
//    private void applyPaging(PublicFacilityReservationVO searchVO, PaginationInfoVO<PublicFacilityReservationVO> pagingVO) {
//        searchVO.setStartRow(pagingVO.getStartRow());
//        searchVO.setEndRow(pagingVO.getEndRow());
//    }
//
//    @Override public String getManagerAptCmplexNo(String mgmtOfcNo) { return mapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo); }
//    @Override public String getResidentAptCmplexNo(String userNo) { return mapper.selectAptCmplexNoByResidentUserNo(userNo); }
//
//    @Override
//    public PaginationInfoVO<PublicFacilityReservationVO> getFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage) {
//        int total = mapper.selectFacilityListCount(searchVO);
//        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
//        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
//        paging.setDataList(mapper.selectFacilityList(searchVO)); paging.setSearchVO(searchVO);
//        return paging;
//    }
//
//    @Override
//    public PaginationInfoVO<PublicFacilityReservationVO> getApprovalPaging(PublicFacilityReservationVO searchVO, int currentPage) {
//        int total = mapper.selectApprovalListCount(searchVO);
//        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
//        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
//        paging.setDataList(mapper.selectApprovalList(searchVO)); paging.setSearchVO(searchVO);
//        return paging;
//    }
//
//    @Override
//    public PaginationInfoVO<PublicFacilityReservationVO> getUseHistoryPaging(PublicFacilityReservationVO searchVO, int currentPage) {
//        int total = mapper.selectUseHistoryCount(searchVO);
//        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
//        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
//        paging.setDataList(mapper.selectUseHistoryList(searchVO)); paging.setSearchVO(searchVO);
//        return paging;
//    }
//
//    @Override
//    public PaginationInfoVO<PublicFacilityReservationVO> getResidentFacilityPaging(PublicFacilityReservationVO searchVO, int currentPage) {
//        int total = mapper.selectResidentFacilityListCount(searchVO);
//        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
//        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
//        paging.setDataList(mapper.selectResidentFacilityList(searchVO)); paging.setSearchVO(searchVO);
//        return paging;
//    }
//
//    @Override
//    public PaginationInfoVO<PublicFacilityReservationVO> getMyReservationPaging(PublicFacilityReservationVO searchVO, int currentPage) {
//        int total = mapper.selectMyReservationCount(searchVO);
//        PaginationInfoVO<PublicFacilityReservationVO> paging = new PaginationInfoVO<>(10, 5);
//        paging.setTotalRecord(total); paging.setCurrentPage(currentPage); applyPaging(searchVO, paging);
//        paging.setDataList(mapper.selectMyReservationList(searchVO)); paging.setSearchVO(searchVO);
//        return paging;
//    }
//
//    @Override public PublicFacilityReservationVO getMyReservationDetail(PublicFacilityReservationVO searchVO) { return mapper.selectMyReservationDetail(searchVO); }
//
//    @Override
//    @Transactional
//    public String reserve(PublicFacilityReservationVO vo) {
//        if (mapper.selectDuplicateReservationCount(vo) > 0) throw new IllegalStateException("이미 예약된 시간입니다.");
//        String rsvtNo = mapper.selectNextRsvtNo();
//        vo.setRsvtNo(rsvtNo);
//        /*
//         * 예약 승인 정책
//         * - 단지독서실, 피트니스센터: 자동 승인
//         * - 주민회의실, 커뮤니티룸: 관리자 승인 필요
//         */
//        if ("주민회의실".equals(vo.getCmnFacilityNm())
//                || "커뮤니티룸".equals(vo.getCmnFacilityNm())) {
//            vo.setRsvtSttsCd("PENDING");
//        } else {
//            vo.setRsvtSttsCd("APPROVED");
//        }
//        mapper.insertReservation(vo);
//        return rsvtNo;
//    }
//
//    @Override @Transactional public void approve(PublicFacilityReservationVO vo) { mapper.approveReservation(vo); }
//
//    @Override
//    @Transactional
//    public void reject(PublicFacilityReservationVO vo) {
//        if (!StringUtils.hasText(vo.getRejectReason())) throw new IllegalArgumentException("거절사유는 필수입니다.");
//        mapper.rejectReservation(vo);
//    }
//
//    @Override @Transactional public void cancel(PublicFacilityReservationVO vo) { mapper.cancelReservation(vo); }
//
//    @Override
//    public List<PublicFacilityReservationVO> getResidentFacilityGroupList(PublicFacilityReservationVO searchVO) {
//        return mapper.selectResidentFacilityGroupList(searchVO);
//    }
//
//    @Override
//    public List<PublicFacilityReservationVO> getResidentFacilityItemList(PublicFacilityReservationVO searchVO) {
//        return mapper.selectResidentFacilityItemList(searchVO);
//    }
//
//    @Override
//    public List<String> getReservedItemNoList(PublicFacilityReservationVO searchVO) {
//        return mapper.selectReservedItemNoList(searchVO);
//    }
//
//    @Override
//    public List<PublicFacilityReservationVO> getReservationTimeSlotList(PublicFacilityReservationVO searchVO) {
//        /*
//         * 시간표 조회
//         * 선택한 예약대상 + 선택한 날짜 기준으로 1시간 단위 예약현황을 조회합니다.
//         */
//        return mapper.selectReservationTimeSlotList(searchVO);
//    }
//}
