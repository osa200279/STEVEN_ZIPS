package kr.or.ddit.domain.apt.mgmtOffice.meter.controller;

import kr.or.ddit.domain.apt.mgmtOffice.meter.service.IMeterHstryService;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

/**
 * 검침 이력 Controller
 * - 검침 이력 목록 화면 조회
 * - CSV 파일 업로드 후 METER_HSTRY 등록 처리
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/manager/meter/hstry")
public class MeterHstryController {

    private final IMeterHstryService meterHstryService;

    /**
     * 검침 이력 목록 화면
     * - 단지별 검침(ho_no IS NOT NULL)과 시설 검침(ho_no IS NULL)을 각각 조회하여 model에 담음
     * - 탭별 검색 파라미터를 분리하여 처리함
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String list(
            @PathVariable String mgmtOfcNo,
            // 단지별 검침 검색 파라미터
            @RequestParam(required = false) String complexUtilityProviderNo,
            @RequestParam(required = false) String complexMeterRsltCd,
            @RequestParam(required = false) String complexStartDt,
            @RequestParam(required = false) String complexEndDt,
            @RequestParam(required = false) String complexKeyword,
            // 시설 검침 검색 파라미터
            @RequestParam(required = false) String utilityProviderNo,
            @RequestParam(required = false) String meterRsltCd,
            @RequestParam(required = false) String startDt,
            @RequestParam(required = false) String endDt,
            @RequestParam(required = false) String keyword,
            Model model
    ) {
        // 단지별 검침 조회 조건
        Map<String, Object> complexParamMap = new HashMap<>();
        complexParamMap.put("mgmtOfcNo", mgmtOfcNo);
        complexParamMap.put("meterScope", "COMPLEX");
        complexParamMap.put("utilityProviderNo", complexUtilityProviderNo);
        complexParamMap.put("meterRsltCd", complexMeterRsltCd);
        complexParamMap.put("startDt", complexStartDt);
        complexParamMap.put("endDt", complexEndDt);
        complexParamMap.put("keyword", complexKeyword);

        // 시설 검침 조회 조건
        Map<String, Object> facilityParamMap = new HashMap<>();
        facilityParamMap.put("mgmtOfcNo", mgmtOfcNo);
        facilityParamMap.put("meterScope", "FACILITY");
        facilityParamMap.put("utilityProviderNo", utilityProviderNo);
        facilityParamMap.put("meterRsltCd", meterRsltCd);
        facilityParamMap.put("startDt", startDt);
        facilityParamMap.put("endDt", endDt);
        facilityParamMap.put("keyword", keyword);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("complexSearch", complexParamMap);
        model.addAttribute("search", facilityParamMap);
        model.addAttribute("complexMeterList", meterHstryService.selectMeterHstryList(complexParamMap));
        model.addAttribute("facilityMeterList", meterHstryService.selectMeterHstryList(facilityParamMap));
        model.addAttribute("providerList", meterHstryService.selectUtilityProviderList(mgmtOfcNo));
        model.addAttribute("rsltCodeList", meterHstryService.selectMeterRsltCodeList());

        return "apt/mgmtOffice/meter/mngr_meter_hstry";
    }

    /**
     * 검침 CSV 업로드
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/upload/{mgmtOfcNo}")
    public String uploadCsv(
            @PathVariable String mgmtOfcNo,
            @RequestParam String utilityProviderNo,
            @RequestParam("csvFile") MultipartFile csvFile,
            @AuthenticationPrincipal CustomUser customUser,
            RedirectAttributes redirectAttributes
    ) {
        try {
            String uploadUserNo = customUser.getMember().getUserNo();
            int insertCnt = meterHstryService.uploadMeterCsv(mgmtOfcNo, utilityProviderNo, csvFile, uploadUserNo);
            redirectAttributes.addFlashAttribute("successMessage", insertCnt + "건의 검침 이력이 등록되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/manager/meter/hstry/" + mgmtOfcNo;
    }

    /**
     * 검침 이력 상세 조회 (JSON)
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{meterHstryNo}")
    @ResponseBody
    public Map<String, Object> detail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String meterHstryNo
    ) {
        Map<String, Object> result = new HashMap<>();
        try {
            MeterHstryVO vo = meterHstryService.selectMeterHstryDetail(meterHstryNo);
            result.put("success", true);
            result.put("meterHstry", vo);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 검침 이력 수정
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    public String update(
            @PathVariable String mgmtOfcNo,
            MeterHstryVO meterHstryVO,
            RedirectAttributes redirectAttributes
    ) {
        try {
            meterHstryService.updateMeterHstry(meterHstryVO);
            redirectAttributes.addFlashAttribute("successMessage", "검침 이력이 수정되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/manager/meter/hstry/" + mgmtOfcNo;
    }
}