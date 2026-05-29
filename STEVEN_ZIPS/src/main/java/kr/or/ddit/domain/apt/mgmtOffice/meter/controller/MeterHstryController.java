package kr.or.ddit.domain.apt.mgmtOffice.meter.controller;

import kr.or.ddit.domain.apt.mgmtOffice.meter.service.IMeterHstryService;
import kr.or.ddit.domain.apt.mgmtOffice.meter.vo.MeterHstryVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
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
            @RequestParam(required = false) String complexMeterTyCd,
            @RequestParam(required = false) String complexMeterRsltCd,
            @RequestParam(required = false) String complexStartDt,
            @RequestParam(required = false) String complexEndDt,
            @RequestParam(required = false) String complexKeyword,
            // 시설 검침 검색 파라미터
            @RequestParam(required = false) String utilityProviderNo,
            @RequestParam(required = false) String meterTyCd,
            @RequestParam(required = false) String meterRsltCd,
            @RequestParam(required = false) String startDt,
            @RequestParam(required = false) String endDt,
            @RequestParam(required = false) String keyword,
            // 협력업체 상세에서 검침 이력으로 이동할 때 유지할 협력업체 필터
            @RequestParam(required = false) String partnerNo,
            Model model
    ) {
        // 단지별 검침 조회 조건
        Map<String, Object> complexParamMap = new HashMap<>();
        complexParamMap.put("mgmtOfcNo", mgmtOfcNo);
        complexParamMap.put("meterScope", "COMPLEX");
        complexParamMap.put("utilityProviderNo", complexUtilityProviderNo);
        complexParamMap.put("meterTyCd", complexMeterTyCd);
        complexParamMap.put("meterRsltCd", complexMeterRsltCd);
        complexParamMap.put("startDt", complexStartDt);
        complexParamMap.put("endDt", complexEndDt);
        complexParamMap.put("keyword", complexKeyword);
        // 협력업체 상세에서 넘어온 경우 단지별 검침에도 같은 업체 필터를 적용함
        complexParamMap.put("partnerNo", partnerNo);

        // 시설 검침 조회 조건
        Map<String, Object> facilityParamMap = new HashMap<>();
        facilityParamMap.put("mgmtOfcNo", mgmtOfcNo);
        facilityParamMap.put("meterScope", "FACILITY");
        facilityParamMap.put("utilityProviderNo", utilityProviderNo);
        facilityParamMap.put("meterTyCd", meterTyCd);
        facilityParamMap.put("meterRsltCd", meterRsltCd);
        facilityParamMap.put("startDt", startDt);
        facilityParamMap.put("endDt", endDt);
        facilityParamMap.put("keyword", keyword);
        // 협력업체 상세에서 넘어온 경우 시설 검침에도 같은 업체 필터를 적용함
        facilityParamMap.put("partnerNo", partnerNo);

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("complexSearch", complexParamMap);
        model.addAttribute("search", facilityParamMap);
        model.addAttribute("complexMeterList", meterHstryService.selectMeterHstryList(complexParamMap));
        model.addAttribute("facilityMeterList", meterHstryService.selectMeterHstryList(facilityParamMap));
        model.addAttribute("providerList", meterHstryService.selectUtilityProviderList(mgmtOfcNo));
        model.addAttribute("rsltCodeList", meterHstryService.selectMeterRsltCodeList());
        model.addAttribute("meterTyCodeList", meterHstryService.selectMeterTyCodeList());

        return "apt/mgmtOffice/meter/mngr_meter_hstry";
    }


    /**
     * CSV 업로드 전 미리보기/자동 매칭
     * - CSV 내부 csv_idntf_key, ext_cust_no를 읽어 공급/검침 설정을 자동으로 찾음
     * - 실제 등록은 하지 않고 화면 확인용 요약과 일부 행만 반환함
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/preview/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> previewCsv(
            @PathVariable String mgmtOfcNo,
            @RequestParam String meterScope,
            @RequestParam("csvFile") MultipartFile csvFile
    ) {
        Map<String, Object> result = new HashMap<>();
        try {
            result = meterHstryService.previewMeterCsv(mgmtOfcNo, meterScope, csvFile);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    /**
     * 검침 CSV 업로드
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/upload/{mgmtOfcNo}")
    public String uploadCsv(
            @PathVariable String mgmtOfcNo,
            @RequestParam String utilityProviderNo,
            @RequestParam String meterScope,
            @RequestParam("csvFile") MultipartFile csvFile,
            @AuthenticationPrincipal CustomUser customUser,
            RedirectAttributes redirectAttributes
    ) {
        try {
            String uploadUserNo = customUser.getMember().getUserNo();
            int insertCnt = meterHstryService.uploadMeterCsv(mgmtOfcNo, utilityProviderNo, meterScope, csvFile, uploadUserNo);
            redirectAttributes.addFlashAttribute("successMessage", insertCnt + "건의 검침 이력이 등록되었습니다.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/manager/meter/hstry/" + mgmtOfcNo;
    }

    /**
     * 다운로드 조건 기준 검침 건수 확인
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/download/check/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> checkDownloadCsv(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String meterScope,
            @RequestParam(required = false) String utilityProviderNo,
            @RequestParam(required = false) String partnerNo,
            @RequestParam(required = false) String meterTyCd,
            @RequestParam(required = false) String meterRsltCd,
            @RequestParam(required = false) String startDt,
            @RequestParam(required = false) String endDt,
            @RequestParam(required = false) String keyword
    ) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("meterScope", meterScope);
        paramMap.put("utilityProviderNo", utilityProviderNo);
        paramMap.put("partnerNo", partnerNo);
        paramMap.put("meterTyCd", meterTyCd);
        paramMap.put("meterRsltCd", meterRsltCd);
        paramMap.put("startDt", startDt);
        paramMap.put("endDt", endDt);
        paramMap.put("keyword", keyword);

        int count = meterHstryService.countDownloadMeter(mgmtOfcNo, paramMap);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("count", count);
        return result;
    }

    /**
     * 다운로드 조건 기준 검침 CSV 응답
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/download/{mgmtOfcNo}")
    public ResponseEntity<byte[]> downloadCsv(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String meterScope,
            @RequestParam(required = false) String utilityProviderNo,
            @RequestParam(required = false) String partnerNo,
            @RequestParam(required = false) String meterTyCd,
            @RequestParam(required = false) String meterRsltCd,
            @RequestParam(required = false) String startDt,
            @RequestParam(required = false) String endDt,
            @RequestParam(required = false) String keyword
    ) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("meterScope", meterScope);
        paramMap.put("utilityProviderNo", utilityProviderNo);
        paramMap.put("partnerNo", partnerNo);
        paramMap.put("meterTyCd", meterTyCd);
        paramMap.put("meterRsltCd", meterRsltCd);
        paramMap.put("startDt", startDt);
        paramMap.put("endDt", endDt);
        paramMap.put("keyword", keyword);

        byte[] csvBytes = meterHstryService.downloadMeterCsv(mgmtOfcNo, paramMap);
        String filename = "meter_hstry_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".csv";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(new MediaType("text", "csv", StandardCharsets.UTF_8));
        headers.setContentDisposition(ContentDisposition.attachment()
                .filename(filename, StandardCharsets.UTF_8)
                .build());

        return ResponseEntity.ok()
                .headers(headers)
                .body(csvBytes);
    }

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
