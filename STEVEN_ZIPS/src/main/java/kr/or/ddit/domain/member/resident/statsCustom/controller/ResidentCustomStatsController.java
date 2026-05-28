package kr.or.ddit.domain.member.resident.statsCustom.controller;

import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.member.resident.statsCustom.dto.ResidentCustomStatsResponseDTO;
import kr.or.ddit.domain.member.resident.statsCustom.service.IResidentCustomStatsService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
@PreAuthorize("hasRole('RESIDENT')")
public class ResidentCustomStatsController {

    private final IResidentCustomStatsService residentCustomStatsService;
    private final IAptComplexService aptComplexService;

    /*
     * 화면 진입 라우트 ResidentMainController 로 이관
     * 사유 - 다른 입주민 화면 라우트들과 동일 패턴 유지 (@authService.hasAccess + @AuthenticationPrincipal + Model)
     * 본 컨트롤러는 데이터 API 전담
     */

//    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
//    @GetMapping("/resident/stats/apartment/{aptCmplexNo}")
//    public String aptStatsPage(
//            @PathVariable String aptCmplexNo,
//            Model model
//    ) {
//        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
//        model.addAttribute("aptInfo", aptCommonDTO);
//        model.addAttribute("aptCmplexNo", aptCmplexNo);
//        return "member/resident/stats_apartment";
//    }
//
//    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
//    @GetMapping("/resident/stats/custom/{aptCmplexNo}")
//    public String customStatsPage(
//            @PathVariable String aptCmplexNo,
//            Model model
//    ) {
//        // 단지 공통 정보
//        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
//        model.addAttribute("aptInfo", aptCommonDTO);
//        model.addAttribute("aptCmplexNo", aptCmplexNo);
//
//        return "member/resident/stats_custom";
//    }

    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
    @GetMapping("/resident/stats/custom/{aptCmplexNo}/data")
    @ResponseBody
    public ResidentCustomStatsResponseDTO customStatsData(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* 로그인 사용자 기준 통계 조회 */
        String userNo = customUser.getMember().getUserNo();
        return residentCustomStatsService.selectCustomStats(userNo, aptCmplexNo);
    }

    @GetMapping("/resident/stats/custom/data")
    @ResponseBody
    public ResidentCustomStatsResponseDTO customStatsData(
            @AuthenticationPrincipal CustomUser customUser
    ) {
        /* 기본 진입 화면 통계 조회 */
        String userNo = customUser.getMember().getUserNo();
        return residentCustomStatsService.selectCustomStats(userNo);
    }
}
