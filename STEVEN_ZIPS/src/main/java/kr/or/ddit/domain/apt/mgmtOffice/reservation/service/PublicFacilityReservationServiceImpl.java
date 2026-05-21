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
        if (mapper.selectDuplicateReservationCount(vo) > 0) throw new IllegalStateException("이미 예약된 시간입니다.");
        String rsvtNo = mapper.selectNextRsvtNo();
        vo.setRsvtNo(rsvtNo);
        // 주민회의실은 승인대기, 나머지 시설은 자동승인
        if ("주민회의실".equals(vo.getCmnFacilityNm())) vo.setRsvtSttsCd("PENDING");
        else vo.setRsvtSttsCd("APPROVED");
        mapper.insertReservation(vo);
        return rsvtNo;
    }

    @Override @Transactional public void approve(PublicFacilityReservationVO vo) { mapper.approveReservation(vo); }

    @Override
    @Transactional
    public void reject(PublicFacilityReservationVO vo) {
        if (!StringUtils.hasText(vo.getRejectReason())) throw new IllegalArgumentException("거절사유는 필수입니다.");
        mapper.rejectReservation(vo);
    }

    @Override @Transactional public void cancel(PublicFacilityReservationVO vo) { mapper.cancelReservation(vo); }

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
}
