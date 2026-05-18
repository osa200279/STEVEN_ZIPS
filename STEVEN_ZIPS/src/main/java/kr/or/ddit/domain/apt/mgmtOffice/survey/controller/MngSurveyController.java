package kr.or.ddit.domain.apt.mgmtOffice.survey.controller;

import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.service.IMngSurveyService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/manager/survey")
@RequiredArgsConstructor
@PreAuthorize("hasRole('MNGR')")
public class MngSurveyController {

    private final IMngSurveyService surveyService;
    private final IManagerModelService managerAccessService;

    /**
     * 설문 관리 페이지
     * GET /manager/survey/{mgmtOfcNo}
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String surveyManage(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        managerAccessService.addManagerViewModel(
                model,
                customUser,
                mgmtOfcNo
        );

        model.addAttribute(
                "mgmtOfcNo",
                mgmtOfcNo
        );

        return "apt/mgmtOffice/survey/mngr_survey_manage";
    }

    /**
     * 설문 등록 API
     * POST /manager/survey/{mgmtOfcNo}/register
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/{mgmtOfcNo}/register")
    @ResponseBody
    public ResponseEntity<?> registerSurvey(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            @RequestBody MngSurveyDTO dto
    ) {

        System.out.println("설문 등록 호출");
        System.out.println("mgmtOfcNo = " + mgmtOfcNo);
        System.out.println(dto);

        dto.setRgtrId(
                customUser.getMember().getUserNo()
        );


        surveyService.registerSurvey(dto);

        return ResponseEntity.ok().build();
    }

    /**
     * 설문 목록 조회 API
     * GET /manager/survey/{mgmtOfcNo}/list
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}/list")
    @ResponseBody
    public ResponseEntity<?> selectSurveyList(
            @PathVariable String mgmtOfcNo
    ) {

        System.out.println("설문 목록 조회");
        System.out.println("mgmtOfcNo = " + mgmtOfcNo);

        return ResponseEntity.ok(
                surveyService.selectSurveyList(mgmtOfcNo)
        );
    }
}