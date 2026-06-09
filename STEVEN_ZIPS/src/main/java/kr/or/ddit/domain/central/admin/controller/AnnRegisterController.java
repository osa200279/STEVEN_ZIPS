package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.common.response.ApiResponse;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.service.IAnnRegisterService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@Slf4j
@RequestMapping("/api/react/adm/annRegister")
@RequiredArgsConstructor
public class AnnRegisterController {

    private final IAnnRegisterService annRegisterService;

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sido")
    public ResponseEntity<ApiResponse<List<String>>> getSido() {
        return ResponseEntity.ok(
                ApiResponse.<List<String>>builder()
                        .code(200)
                        .data(annRegisterService.selectSidoList())
                        .build()
        );
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sigungu")
    public ResponseEntity<ApiResponse<List<String>>> getSigunguList(
            @RequestParam String sidoNm
    ) {
        return ResponseEntity.ok(
                ApiResponse.<List<String>>builder()
                        .code(200)
                        .data(annRegisterService.selectSigunguList(sidoNm))
                        .build()
        );
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/emd")
    public ResponseEntity<ApiResponse<List<String>>> getDongList(
            @RequestParam String sidoNm,
            @RequestParam String sigunguNm
    ) {
        return ResponseEntity.ok(
                ApiResponse.<List<String>>builder()
                        .code(200)
                        .data(annRegisterService.selectEmdList(sidoNm, sigunguNm))
                        .build()
        );
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/aptList")
    public ResponseEntity<ApiResponse<List<AptComplexVO>>> getAptList(
            @RequestParam(required = false) String sidoNm,
            @RequestParam(required = false) String sigunguNm,
            @RequestParam(required = false) String emdNm
    ) {
        return ResponseEntity.ok(
                ApiResponse.<List<AptComplexVO>>builder()
                        .code(200)
                        .data(annRegisterService.selectAptList(sidoNm, sigunguNm, emdNm))
                        .build()
        );

    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/rentList")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getRentList(
            @RequestParam String aptCmplexNo
    ) {
        log.info("rentList 요청 aptCmplexNo: {}", aptCmplexNo);
        return ResponseEntity.ok(
                ApiResponse.<List<Map<String, Object>>>builder()
                        .code(200)
                        .data(annRegisterService.selectRentList(aptCmplexNo))
                        .build()
        );
        /*Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> rentList = annRegisterService.selectRentList(aptCmplexNo);
            result.put("success", true);
            result.put("list", rentList);
        } catch (Exception e) {
            log.info("매물조회 오류:{}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;*/
    }


    



    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/aptDetail")
    public ResponseEntity<ApiResponse<Map<String, Object>>> getAptDetail(
            @RequestParam String aptCmplexNo
    ) {
        return ResponseEntity.ok(
                ApiResponse.<Map<String, Object>>builder()
                        .code(200)
                        .data(annRegisterService.selectOneAptDetail(aptCmplexNo))
                        .build()
        );
        /*Map<String, Object> result = new HashMap<>();
        try {
            Map<String, Object> data = annRegisterService.selectOneAptDetail(aptCmplexNo);
            result.put("success", true);
            result.put("dorojuso", data.get("dorojuso"));
            result.put("hoTyNo", data.get("hoTyNo"));
        } catch (Exception e) {
            log.error("단지 상세 정보 오류:{}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;*/
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sbmsnDocList")
    public ResponseEntity<ApiResponse<List<Map<String, Object>>>> getSbmsnDocList(
            @RequestParam List<String> rentLstgNoList
    ) {
        return ResponseEntity.ok(
                ApiResponse.<List<Map<String, Object>>>builder()
                        .code(200)
                        .data(annRegisterService.selectSbmsnDocList(rentLstgNoList))
                        .build()
        );
        /*Map<String, Object> result = new HashMap<>();
        try {
            List<Map<String, Object>> list = annRegisterService.selectSbmsnDocList(rentLstgNoList);
            result.put("success", true);
            result.put("list", list);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;*/
    }

    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/insertAnn")
    public ResponseEntity<ApiResponse<Void>> insertAnn(
            @RequestBody Map<String, Object> params,
            @AuthenticationPrincipal CustomUser principal
    ){
        params.put("wrtrId", principal.getMember().getUserNo());
        annRegisterService.insertAnn(params);
        return ResponseEntity.ok(
                ApiResponse.<Void>builder()
                        .code(200)
                        .build()
        );
        /*Map<String, Object> result = new HashMap<>();
        try {
            log.info("받은 params: {}", params);
            log.info("aptCmplexNo: {}", params.get("aptCmplexNo"));
            params.put("wrtrId", principal.getMember().getUserNo());
            annRegisterService.insertAnn(params);
            result.put("success", true);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;*/
    }

}