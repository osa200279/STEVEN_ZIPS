package kr.or.ddit.domain.apt.mgmtOffice.meter.controller;

import kr.or.ddit.domain.apt.mgmtOffice.meter.service.IMeterHstryService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
     * - 관리사무소 번호 기준으로 단지번호를 찾고 검침 이력을 조회함
     * - 필터 조건은 JSP의 검색 폼에서 전달함
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String list(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String utilityProviderNo,
            @RequestParam(required = false) String meterRsltCd,
            @RequestParam(required = false) String startDt,
            @RequestParam(required = false) String endDt,
            Model model
    ) {
        // 검색 조건 구성
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("mgmtOfcNo", mgmtOfcNo);
        paramMap.put("keyword", keyword);
        paramMap.put("utilityProviderNo", utilityProviderNo);
        paramMap.put("meterRsltCd", meterRsltCd);
        paramMap.put("startDt", startDt);
        paramMap.put("endDt", endDt);

        // 화면 공통 데이터 조회
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("search", paramMap);
        model.addAttribute("meterList", meterHstryService.selectMeterHstryList(paramMap));
        model.addAttribute("providerList", meterHstryService.selectUtilityProviderList(mgmtOfcNo));
        model.addAttribute("rsltCodeList", meterHstryService.selectMeterRsltCodeList());

        return "apt/mgmtOffice/meter/mngr_meter_hstry";
    }

    /**
     * 검침 CSV 업로드
     * - CSV 원본 파일은 ATTACH_FILE에 저장함
     * - 업로드 결과는 METER_UPLOAD_HSTRY에 저장함
     * - 정상 행은 METER_HSTRY에 등록함
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
            // 로그인 사용자 번호 추출
            String uploadUserNo = customUser.getMember().getUserNo();

            // CSV 업로드 및 검침 이력 등록 처리
            int insertCnt = meterHstryService.uploadMeterCsv(
                    mgmtOfcNo,
                    utilityProviderNo,
                    csvFile,
                    uploadUserNo
            );

            redirectAttributes.addFlashAttribute("successMessage", insertCnt + "건의 검침 이력이 등록되었습니다.");

        } catch (Exception e) {
            // 업로드 실패 메시지 전달
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }

        return "redirect:/manager/meter/hstry/" + mgmtOfcNo;
    }
}
