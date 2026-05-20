package kr.or.ddit.domain.apt.mgmtOffice.contract.controller;

import kr.or.ddit.domain.apt.mgmtOffice.contract.service.IFacilityContractService;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractVO;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * 시설 계약 처리 Controller
 * - 계약 등록 처리
 * - 계약 수정 처리
 * - 재계약 등록 처리
 * - 검침 설정 저장 처리
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/manager/contract")
@PreAuthorize("hasRole('MNGR')")  // 계층 구조상 ADMIN도 통과
public class FacilityContractController {

    /** 시설 계약 Service */
    private final IFacilityContractService contractService;

    /**
     * 계약 등록
     * - FACILITY_CONTRACT 신규 등록
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/insert/{mgmtOfcNo}")
    public String insert(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractVO contractVO,
            RedirectAttributes redirectAttributes
    ) {
        try {
            // 계약 등록 처리
            contractService.insertContract(mgmtOfcNo, contractVO);

            // 성공 메시지
            redirectAttributes.addFlashAttribute("successMessage", "계약이 등록되었습니다.");
        } catch (Exception e) {
            // 오류 메시지
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        // 계약 화면 재이동
        return "redirect:/manager/contract/" + mgmtOfcNo;
    }

    /**
     * 계약 수정
     * - FACILITY_CONTRACT 기존 계약 수정
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    public String update(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractVO contractVO,
            RedirectAttributes redirectAttributes
    ) {
        try {
            // 계약 수정 처리
            contractService.updateContract(mgmtOfcNo, contractVO);

            // 성공 메시지
            redirectAttributes.addFlashAttribute("successMessage", "계약이 수정되었습니다.");
        } catch (Exception e) {
            // 오류 메시지
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        // 계약 화면 재이동
        return "redirect:/manager/contract/" + mgmtOfcNo;
    }

    /**
     * 재계약 등록
     * - 기존 계약 수정이 아닌 신규 계약 등록
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/renew/{mgmtOfcNo}")
    public String renew(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractVO contractVO,
            RedirectAttributes redirectAttributes
    ) {
        try {
            // 재계약 등록 처리
            contractService.insertRenewContract(mgmtOfcNo, contractVO);

            // 성공 메시지
            redirectAttributes.addFlashAttribute("successMessage", "재계약이 등록되었습니다.");
        } catch (Exception e) {
            // 오류 메시지
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        // 계약 화면 재이동
        return "redirect:/manager/contract/" + mgmtOfcNo;
    }

    /**
     * 검침 설정 저장
     * - UTILITY_PROVIDER 등록/수정
     * - CONT_NO 기준 계약 연결
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/utility/save/{mgmtOfcNo}")
    public String saveUtilityProvider(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute FacilityContractVO contractVO,
            RedirectAttributes redirectAttributes
    ) {
        try {
            // 검침 설정 저장 처리
            contractService.saveUtilityProvider(mgmtOfcNo, contractVO);

            // 성공 메시지
            redirectAttributes.addFlashAttribute("successMessage", "검침 설정이 저장되었습니다.");
        } catch (Exception e) {
            // 오류 메시지
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        // 계약 화면 재이동
        return "redirect:/manager/contract/" + mgmtOfcNo;
    }
}