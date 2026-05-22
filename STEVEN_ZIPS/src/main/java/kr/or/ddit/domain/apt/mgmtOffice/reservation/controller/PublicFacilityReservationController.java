package kr.or.ddit.domain.apt.mgmtOffice.reservation.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.service.IPublicFacilityReservationService;
import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Controller란? 브라우저 요청 URL을 받아 JSP 화면 또는 JSON 응답으로 연결하는 클래스입니다.
 * 권한: 단지관리자(MNGR), 입주민(RESIDENT)을 메서드별로 분리했습니다.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping
public class PublicFacilityReservationController {

    private final IPublicFacilityReservationService service;
    private final IManagerModelService managerModelService;

    /** 단지관리자 - 편의시설 목록 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/manager/publicFacility/reservation/facilities/{mgmtOfcNo}")
    public String managerFacilityList(@PathVariable String mgmtOfcNo,
                                      @RequestParam(defaultValue = "1") int currentPage,
                                      PublicFacilityReservationVO searchVO,
                                      @AuthenticationPrincipal CustomUser customUser,
                                      Model model) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getFacilityPaging(searchVO, currentPage);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        return "apt/mgmtOffice/facility/reservation/managerFacilityList";
    }

    /** 단지관리자 - 예약승인관리 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}")
    public String approvalList(@PathVariable String mgmtOfcNo,
                               @RequestParam(defaultValue = "1") int currentPage,
                               PublicFacilityReservationVO searchVO,
                               @AuthenticationPrincipal CustomUser customUser,
                               Model model) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getApprovalPaging(searchVO, currentPage);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        return "apt/mgmtOffice/facility/reservation/managerReservationApproval";
    }

    /** 단지관리자 - 승인 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}/{rsvtNo}/approve")
    @ResponseBody
    public String approve(@PathVariable String mgmtOfcNo, @PathVariable String rsvtNo, PublicFacilityReservationVO vo) {
        vo.setRsvtNo(rsvtNo);
        vo.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        service.approve(vo);
        return "OK";
    }

    /** 단지관리자 - 거절 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}/{rsvtNo}/reject")
    @ResponseBody
    public String reject(@PathVariable String mgmtOfcNo, @PathVariable String rsvtNo, PublicFacilityReservationVO vo) {
        vo.setRsvtNo(rsvtNo);
        vo.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        service.reject(vo);
        return "OK";
    }

    /** 단지관리자 - 예약시설 이용이력 */
    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/manager/publicFacility/reservation/history/{mgmtOfcNo}")
    public String useHistory(@PathVariable String mgmtOfcNo,
                             @RequestParam(defaultValue = "1") int currentPage,
                             PublicFacilityReservationVO searchVO,
                             @AuthenticationPrincipal CustomUser customUser,
                             Model model) {
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getUseHistoryPaging(searchVO, currentPage);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        return "apt/mgmtOffice/facility/reservation/managerUseHistory";
    }

    /** 입주민 - 시설예약 */
    /**
     * 입주민 - 공용시설 예약 메인
     *
     * 공용시설 예약 메인 화면입니다.
     * 이 화면에서는 바로 예약하지 않고,
     * 단지독서실 / 주민회의실 / 피트니스센터 중 하나를 선택합니다.
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation")
    public String residentReservePage(
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /*
         * 로그인한 입주민이 속한 단지번호 조회
         */
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));

        /*
         * 예약 가능한 공용시설 종류 목록 조회
         */
        model.addAttribute("facilityList", service.getResidentFacilityGroupList(searchVO));

        return "member/resident/facility/residentReservation";
    }

    /**
     * 입주민 - 공용시설 상세 예약 화면
     *
     * 예:
     * /resident/publicFacility/reservation/PF000000000001
     *
     * cmnFacilityNo란?
     * 공용시설 번호입니다.
     * 예: 단지독서실, 주민회의실 같은 큰 시설 1개를 구분하는 번호입니다.
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}")
    public String residentReserveDetailPage(
            @PathVariable String cmnFacilityNo,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);

        List<PublicFacilityReservationVO> itemList = service.getResidentFacilityItemList(searchVO);

        PublicFacilityReservationVO facility = null;

        if (itemList != null && !itemList.isEmpty()) {
            facility = itemList.get(0);
        }

        model.addAttribute("facility", facility);
        model.addAttribute("itemList", itemList);
        /*
         * PathVariable로 받은 시설번호를 JSP에서 Ajax URL 만들 때 사용합니다.
         * facility가 null이어도 cmnFacilityNo는 유지됩니다.
         */
        model.addAttribute("cmnFacilityNo", cmnFacilityNo);

        /*
         * PathVariable로 받은 시설번호를 JSP에서 Ajax URL 만들 때 사용합니다.
         * facility가 null이어도 cmnFacilityNo는 유지됩니다.
         */
        model.addAttribute("cmnFacilityNo", cmnFacilityNo);

        return "member/resident/facility/residentReservationDetail";
    }

    /**
     * 입주민 - 선택 시간 기준 예약된 좌석 조회
     *
     * Ajax란?
     * 화면 전체 새로고침 없이 서버와 데이터를 주고받는 방식입니다.
     * 왜 사용?
     * 날짜/시간을 바꿀 때마다 예약 불가능한 좌석만 다시 표시하기 위해 사용합니다.
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}/reserved-items")
    @ResponseBody
    public List<String> reservedItemList(
            @PathVariable String cmnFacilityNo,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);

        return service.getReservedItemNoList(searchVO);
    }

    /** 입주민 - 예약 등록 */
    @PreAuthorize("hasRole('RESIDENT')")
    @PostMapping("/resident/publicFacility/reservation")
    @ResponseBody
    public String reserve(PublicFacilityReservationVO vo, @AuthenticationPrincipal CustomUser customUser) {
        vo.setUserNo(customUser.getMember().getUserNo());
        vo.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        return service.reserve(vo);
    }

    /** 입주민 - 내 예약내역 */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/myReservation")
    public String myReservation(@RequestParam(defaultValue = "1") int currentPage,
                                PublicFacilityReservationVO searchVO,
                                @AuthenticationPrincipal CustomUser customUser,
                                Model model) {
        searchVO.setUserNo(customUser.getMember().getUserNo());
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getMyReservationPaging(searchVO, currentPage);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        return "member/resident/facility/residentMyReservation";
    }

    /** 입주민 - 예약 상세 JSON */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/myReservation/{rsvtNo}")
    @ResponseBody
    public PublicFacilityReservationVO myReservationDetail(@PathVariable String rsvtNo,
                                                           @AuthenticationPrincipal CustomUser customUser) {
        PublicFacilityReservationVO searchVO = new PublicFacilityReservationVO();
        searchVO.setRsvtNo(rsvtNo);
        searchVO.setUserNo(customUser.getMember().getUserNo());
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        return service.getMyReservationDetail(searchVO);
    }

    /** 입주민 - 예약 취소 */
    @PreAuthorize("hasRole('RESIDENT')")
    @PostMapping("/resident/publicFacility/myReservation/{rsvtNo}/cancel")
    @ResponseBody
    public String cancel(@PathVariable String rsvtNo, @AuthenticationPrincipal CustomUser customUser) {
        PublicFacilityReservationVO vo = new PublicFacilityReservationVO();
        vo.setRsvtNo(rsvtNo);
        vo.setUserNo(customUser.getMember().getUserNo());
        vo.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        service.cancel(vo);
        return "OK";
    }

    /*
     * 입주민 - 선택한 시설/좌석의 시간표 조회
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}/time-slots")
    @ResponseBody
    public List<PublicFacilityReservationVO> reservationTimeSlots(
            @PathVariable String cmnFacilityNo,
            PublicFacilityReservationVO searchVO,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);

        return service.getReservationTimeSlotList(searchVO);
    }


}




//package kr.or.ddit.domain.apt.mgmtOffice.reservation.controller;
//
//import kr.or.ddit.common.model.PaginationInfoVO;
//import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
//import kr.or.ddit.domain.apt.mgmtOffice.reservation.service.IPublicFacilityReservationService;
//import kr.or.ddit.domain.apt.mgmtOffice.reservation.vo.PublicFacilityReservationVO;
//import kr.or.ddit.domain.member.vo.CustomUser;
//import lombok.RequiredArgsConstructor;
//import org.springframework.security.access.prepost.PreAuthorize;
//import org.springframework.security.core.annotation.AuthenticationPrincipal;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.List;
//
///**
// * Controller란? 브라우저 요청 URL을 받아 JSP 화면 또는 JSON 응답으로 연결하는 클래스입니다.
// * 권한: 단지관리자(MNGR), 입주민(RESIDENT)을 메서드별로 분리했습니다.
// */
//@Controller
//@RequiredArgsConstructor
//@RequestMapping
//public class PublicFacilityReservationController {
//
//    private final IPublicFacilityReservationService service;
//    private final IManagerModelService managerModelService;
//
//    /** 단지관리자 - 편의시설 목록 */
//    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
//    @GetMapping("/manager/publicFacility/reservation/facilities/{mgmtOfcNo}")
//    public String managerFacilityList(@PathVariable String mgmtOfcNo,
//                                      @RequestParam(defaultValue = "1") int currentPage,
//                                      PublicFacilityReservationVO searchVO,
//                                      @AuthenticationPrincipal CustomUser customUser,
//                                      Model model) {
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
//        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
//        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getFacilityPaging(searchVO, currentPage);
//        model.addAttribute("pagingVO", pagingVO);
//        model.addAttribute("searchVO", searchVO);
//        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
//        return "apt/mgmtOffice/facility/reservation/managerFacilityList";
//    }
//
//    /** 단지관리자 - 예약승인관리 */
//    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
//    @GetMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}")
//    public String approvalList(@PathVariable String mgmtOfcNo,
//                               @RequestParam(defaultValue = "1") int currentPage,
//                               PublicFacilityReservationVO searchVO,
//                               @AuthenticationPrincipal CustomUser customUser,
//                               Model model) {
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
//        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
//        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getApprovalPaging(searchVO, currentPage);
//        model.addAttribute("pagingVO", pagingVO);
//        model.addAttribute("searchVO", searchVO);
//        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
//        return "apt/mgmtOffice/facility/reservation/managerReservationApproval";
//    }
//
//    /** 단지관리자 - 승인 */
//    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
//    @PostMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}/{rsvtNo}/approve")
//    @ResponseBody
//    public String approve(@PathVariable String mgmtOfcNo, @PathVariable String rsvtNo, PublicFacilityReservationVO vo) {
//        vo.setRsvtNo(rsvtNo);
//        vo.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
//        service.approve(vo);
//        return "OK";
//    }
//
//    /** 단지관리자 - 거절 */
//    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
//    @PostMapping("/manager/publicFacility/reservation/approval/{mgmtOfcNo}/{rsvtNo}/reject")
//    @ResponseBody
//    public String reject(@PathVariable String mgmtOfcNo, @PathVariable String rsvtNo, PublicFacilityReservationVO vo) {
//        vo.setRsvtNo(rsvtNo);
//        vo.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
//        service.reject(vo);
//        return "OK";
//    }
//
//    /** 단지관리자 - 예약시설 이용이력 */
//    @PreAuthorize("hasRole('MNGR') and @authService.canMgmtCrud(principal, #mgmtOfcNo)")
//    @GetMapping("/manager/publicFacility/reservation/history/{mgmtOfcNo}")
//    public String useHistory(@PathVariable String mgmtOfcNo,
//                             @RequestParam(defaultValue = "1") int currentPage,
//                             PublicFacilityReservationVO searchVO,
//                             @AuthenticationPrincipal CustomUser customUser,
//                             Model model) {
//        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);
//        searchVO.setAptCmplexNo(service.getManagerAptCmplexNo(mgmtOfcNo));
//        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getUseHistoryPaging(searchVO, currentPage);
//        model.addAttribute("pagingVO", pagingVO);
//        model.addAttribute("searchVO", searchVO);
//        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
//        return "apt/mgmtOffice/facility/reservation/managerUseHistory";
//    }
//
//    /** 입주민 - 시설예약 */
//    /**
//     * 입주민 - 공용시설 예약 메인
//     *
//     * 공용시설 예약 메인 화면입니다.
//     * 이 화면에서는 바로 예약하지 않고,
//     * 단지독서실 / 주민회의실 / 피트니스센터 중 하나를 선택합니다.
//     */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @GetMapping("/resident/publicFacility/reservation")
//    public String residentReservePage(
//            PublicFacilityReservationVO searchVO,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        /*
//         * 로그인한 입주민이 속한 단지번호 조회
//         */
//        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//
//        /*
//         * 예약 가능한 공용시설 종류 목록 조회
//         */
//        model.addAttribute("facilityList", service.getResidentFacilityGroupList(searchVO));
//
//        return "member/resident/facility/residentReservation";
//    }
//
//    /**
//     * 입주민 - 공용시설 상세 예약 화면
//     *
//     * 예:
//     * /resident/publicFacility/reservation/PF000000000001
//     *
//     * cmnFacilityNo란?
//     * 공용시설 번호입니다.
//     * 예: 단지독서실, 주민회의실 같은 큰 시설 1개를 구분하는 번호입니다.
//     */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}")
//    public String residentReserveDetailPage(
//            @PathVariable String cmnFacilityNo,
//            PublicFacilityReservationVO searchVO,
//            @AuthenticationPrincipal CustomUser customUser,
//            Model model
//    ) {
//        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);
//
//        List<PublicFacilityReservationVO> itemList = service.getResidentFacilityItemList(searchVO);
//
//        PublicFacilityReservationVO facility = null;
//
//        if (itemList != null && !itemList.isEmpty()) {
//            facility = itemList.get(0);
//        }
//
//        model.addAttribute("facility", facility);
//        model.addAttribute("itemList", itemList);
//        /*
//         * PathVariable로 받은 시설번호를 JSP에서 Ajax URL 만들 때 사용합니다.
//         * facility가 null이어도 cmnFacilityNo는 유지됩니다.
//         */
//        model.addAttribute("cmnFacilityNo", cmnFacilityNo);
//
//        /*
//         * PathVariable로 받은 시설번호를 JSP에서 Ajax URL 만들 때 사용합니다.
//         * facility가 null이어도 cmnFacilityNo는 유지됩니다.
//         */
//        model.addAttribute("cmnFacilityNo", cmnFacilityNo);
//
//        return "member/resident/facility/residentReservationDetail";
//    }
//
//    /**
//     * 입주민 - 선택 시간 기준 예약된 좌석 조회
//     *
//     * Ajax란?
//     * 화면 전체 새로고침 없이 서버와 데이터를 주고받는 방식입니다.
//     * 왜 사용?
//     * 날짜/시간을 바꿀 때마다 예약 불가능한 좌석만 다시 표시하기 위해 사용합니다.
//     */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}/reserved-items")
//    @ResponseBody
//    public List<String> reservedItemList(
//            @PathVariable String cmnFacilityNo,
//            PublicFacilityReservationVO searchVO,
//            @AuthenticationPrincipal CustomUser customUser
//    ) {
//        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);
//
//        return service.getReservedItemNoList(searchVO);
//    }
//
//    /** 입주민 - 예약 등록 */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @PostMapping("/resident/publicFacility/reservation")
//    @ResponseBody
//    public String reserve(PublicFacilityReservationVO vo, @AuthenticationPrincipal CustomUser customUser) {
//        vo.setUserNo(customUser.getMember().getUserNo());
//        vo.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//        return service.reserve(vo);
//    }
//
//    /** 입주민 - 내 예약내역 */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @GetMapping("/resident/publicFacility/myReservation")
//    public String myReservation(@RequestParam(defaultValue = "1") int currentPage,
//                                PublicFacilityReservationVO searchVO,
//                                @AuthenticationPrincipal CustomUser customUser,
//                                Model model) {
//        searchVO.setUserNo(customUser.getMember().getUserNo());
//        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getMyReservationPaging(searchVO, currentPage);
//        model.addAttribute("pagingVO", pagingVO);
//        model.addAttribute("searchVO", searchVO);
//        return "member/resident/facility/residentMyReservation";
//    }
//
//    /** 입주민 - 예약 상세 JSON */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @GetMapping("/resident/publicFacility/myReservation/{rsvtNo}")
//    @ResponseBody
//    public PublicFacilityReservationVO myReservationDetail(@PathVariable String rsvtNo,
//                                                          @AuthenticationPrincipal CustomUser customUser) {
//        PublicFacilityReservationVO searchVO = new PublicFacilityReservationVO();
//        searchVO.setRsvtNo(rsvtNo);
//        searchVO.setUserNo(customUser.getMember().getUserNo());
//        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//        return service.getMyReservationDetail(searchVO);
//    }
//
//    /** 입주민 - 예약 취소 */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @PostMapping("/resident/publicFacility/myReservation/{rsvtNo}/cancel")
//    @ResponseBody
//    public String cancel(@PathVariable String rsvtNo, @AuthenticationPrincipal CustomUser customUser) {
//        PublicFacilityReservationVO vo = new PublicFacilityReservationVO();
//        vo.setRsvtNo(rsvtNo);
//        vo.setUserNo(customUser.getMember().getUserNo());
//        vo.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//        service.cancel(vo);
//        return "OK";
//    }
//
//    /*
//     * 입주민 - 선택한 시설/좌석의 시간표 조회
//     */
//    @PreAuthorize("hasRole('RESIDENT')")
//    @GetMapping("/resident/publicFacility/reservation/{cmnFacilityNo}/time-slots")
//    @ResponseBody
//    public List<PublicFacilityReservationVO> reservationTimeSlots(
//            @PathVariable String cmnFacilityNo,
//            PublicFacilityReservationVO searchVO,
//            @AuthenticationPrincipal CustomUser customUser
//    ) {
//        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
//        searchVO.setSearchCmnFacilityNo(cmnFacilityNo);
//
//        return service.getReservationTimeSlotList(searchVO);
//    }
//
//
//}
