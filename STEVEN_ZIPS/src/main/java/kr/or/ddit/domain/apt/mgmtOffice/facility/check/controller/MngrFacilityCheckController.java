package kr.or.ddit.domain.apt.mgmtOffice.facility.check.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.service.IMngrFacilityCheckService;
import kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo.FacilityCheckHstryVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 시설 점검 이력 Controller
 *
 * 역할
 * - 시설 점검 이력 목록/상세/등록/수정 화면 이동
 * - 일반 table + PaginationInfoVO 서버 페이징 처리
 * - office_sidebar.jsp 직접 수정 없이 office_active_sidebar.jspf 기준 active 처리
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('MNGR')")
@RequiredArgsConstructor
@RequestMapping("/manager/checkHistory")
public class MngrFacilityCheckController {

    /** 시설 점검 이력 Service */
    private final IMngrFacilityCheckService facilityCheckService;

    /** 관리사무소 공통 모델 Service */
    private final IManagerModelService managerModelService;

    /**
     * 시설 점검 이력 목록 화면
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String list(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false, defaultValue = "1") int page,
            @RequestParam(required = false, defaultValue = "") String searchWord,
            @RequestParam(required = false, defaultValue = "") String chkTyCd,
            @RequestParam(required = false, defaultValue = "") String chkSttsCd,
            @RequestParam(required = false, defaultValue = "") String chkStartDt,
            @RequestParam(required = false, defaultValue = "") String chkEndDt,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 검색 조건 VO */
        FacilityCheckHstryVO searchVO = new FacilityCheckHstryVO();
        searchVO.setMgmtOfcNo(mgmtOfcNo);
        searchVO.setChkTyCd(chkTyCd);
        searchVO.setChkSttsCd(chkSttsCd);
        searchVO.setChkStartDt(chkStartDt);
        searchVO.setChkEndDt(chkEndDt);

        /* 공통 페이지네이션 VO */
        PaginationInfoVO<FacilityCheckHstryVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setSearchWord(searchWord);
        pagingVO.setSearchVO(searchVO);

        /* 전체 건수 조회 후 현재 페이지 row 계산 */
        int totalRecord = facilityCheckService.selectFacilityCheckCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);
        pagingVO.setCurrentPage(page);

        /* 현재 페이지 목록 조회 */
        pagingVO.setDataList(facilityCheckService.selectFacilityCheckList(pagingVO));

        /* 화면 표시 모델 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("searchVO", searchVO);

        /* 현황 카드 건수 - 검색 조건과 무관한 관리사무소 전체 기준 */
        model.addAttribute("summary", facilityCheckService.selectFacilityCheckSummary(mgmtOfcNo));
        model.addAttribute("checkTypeList", facilityCheckService.selectCheckTypeList());
        model.addAttribute("checkStatusList", facilityCheckService.selectCheckStatusList());

        return "apt/mgmtOffice/facility/check/mngr_facility_check_list";
    }

    /**
     * 시설 점검 이력 상세 화면
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{facChkHstryNo}")
    public String detail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 상세 대상 조회 */
        FacilityCheckHstryVO check = facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("check", check);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_detail";
    }

    /**
     * 시설 점검 이력 등록 화면
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/register/{mgmtOfcNo}")
    public String registerPage(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 등록 화면 공통 모델 */
        setFormModel(mgmtOfcNo, "register", new FacilityCheckHstryVO(), model);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_form";
    }

    /**
     * 시설 점검 이력 등록 처리
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/register/{mgmtOfcNo}")
    public String register(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityCheckHstryVO facilityCheckHstryVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 관리사무소 번호 보정 */
        facilityCheckHstryVO.setMgmtOfcNo(mgmtOfcNo);

        /* 시설 점검 이력 등록 */
        String facChkHstryNo = facilityCheckService.insertFacilityCheckHistory(facilityCheckHstryVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "시설 점검 이력이 등록되었습니다.");

        return "redirect:/manager/checkHistory/detail/" + mgmtOfcNo + "/" + facChkHstryNo;
    }

    /**
     * 시설 점검 이력 수정 화면
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @GetMapping("/update/{mgmtOfcNo}/{facChkHstryNo}")
    public String updatePage(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {
        /* 관리사무소 공통 화면 모델 */
        managerModelService.addManagerViewModel(model, customUser, mgmtOfcNo);

        /* 수정 대상 조회 */
        FacilityCheckHstryVO check = facilityCheckService.selectFacilityCheckDetail(mgmtOfcNo, facChkHstryNo);

        /* 수정 화면 공통 모델 */
        setFormModel(mgmtOfcNo, "update", check, model);

        return "apt/mgmtOffice/facility/check/mngr_facility_check_form";
    }

    /**
     * 시설 점검 이력 수정 처리
     */
    @PreAuthorize("@authService.canMgmtCrud(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}/{facChkHstryNo}")
    public String update(
            @PathVariable String mgmtOfcNo,
            @PathVariable String facChkHstryNo,
            @ModelAttribute FacilityCheckHstryVO facilityCheckHstryVO,
            RedirectAttributes redirectAttributes
    ) {
        /* 수정 기준값 보정 */
        facilityCheckHstryVO.setMgmtOfcNo(mgmtOfcNo);
        facilityCheckHstryVO.setFacChkHstryNo(facChkHstryNo);

        /* 시설 점검 이력 수정 */
        facilityCheckService.updateFacilityCheckHistory(facilityCheckHstryVO);

        /* 완료 메시지 */
        redirectAttributes.addFlashAttribute("message", "시설 점검 이력이 수정되었습니다.");

        return "redirect:/manager/checkHistory/detail/" + mgmtOfcNo + "/" + facChkHstryNo;
    }

    /**
     * 등록/수정 폼 공통 모델 세팅
     */
    private void setFormModel(String mgmtOfcNo, String formMode, FacilityCheckHstryVO check, Model model) {
        /* 화면 기본값 */
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("formMode", formMode);
        model.addAttribute("check", check);

        /* 선택 모달 목록 */
        model.addAttribute("facilityList", facilityCheckService.selectFacilitySelectList(mgmtOfcNo));
        model.addAttribute("partnerList", facilityCheckService.selectPartnerSelectList(mgmtOfcNo));

        /* 공통코드 목록 */
        model.addAttribute("checkTypeList", facilityCheckService.selectCheckTypeList());
        model.addAttribute("checkStatusList", facilityCheckService.selectCheckStatusList());
    }
}
