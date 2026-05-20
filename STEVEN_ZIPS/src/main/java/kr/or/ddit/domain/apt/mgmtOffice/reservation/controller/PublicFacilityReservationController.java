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

    /** 단지관리자 - 공용시설 목록 */
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
        return "apt/mgmtOffice/publicFacility/managerFacilityList";
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
        return "apt/mgmtOffice/publicFacility/managerReservationApproval";
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
        return "apt/mgmtOffice/publicFacility/managerUseHistory";
    }

    /** 입주민 - 시설예약 */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/resident/publicFacility/reservation")
    public String residentReservePage(@RequestParam(defaultValue = "1") int currentPage,
                                      PublicFacilityReservationVO searchVO,
                                      @AuthenticationPrincipal CustomUser customUser,
                                      Model model) {
        searchVO.setAptCmplexNo(service.getResidentAptCmplexNo(customUser.getMember().getUserNo()));
        PaginationInfoVO<PublicFacilityReservationVO> pagingVO = service.getResidentFacilityPaging(searchVO, currentPage);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);
        return "apt/mgmtOffice/publicFacility/residentReservation";
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
        return "apt/mgmtOffice/publicFacility/residentMyReservation";
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
}
