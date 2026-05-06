package kr.or.ddit.domain.apt.complaint.controller;

import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.member.manager.service.IAptComplexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@PreAuthorize("hasRole('RESIDENT')")
@RequestMapping("/apt/complaint")
public class CvplController {

    @Autowired
    private IAptComplexService aptComplexService;

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/apply.do/{aptCmplexNo}")
    public String complaintApplyForm(@PathVariable String aptCmplexNo, Model model) {
        log.info("complaintApplyForm() 실행");

        // 헤더, 푸터 DTO
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);

        return "apt/complaint/complaint_apply";
    }

}
