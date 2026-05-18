package kr.or.ddit.domain.apt.mgmtOffice.survey;

import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/manager/survey")
@RequiredArgsConstructor
@PreAuthorize("hasRole('MNGR')")
public class MngSurveyController {

    private final IManagerModelService managerAccessService;

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/{mgmtOfcNo}")
    public String surveyManage(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        managerAccessService.addManagerViewModel(model, customUser, mgmtOfcNo);

        return "apt/mgmtOffice/survey/mngr_survey_manage";
    }
}