package kr.or.ddit.domain.apt.complaint.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@PreAuthorize("hasRole('RESIDENT')")
@RequestMapping("/apt/complaint")
public class CvplController {

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/apply.do/{aptCmplexNo}")
    public String complaintApplyForm(@PathVariable String aptCmplexNo) {
        log.info("complaintApplyForm() 실행");

        return "apt/complaint/complaint_apply";
    }

}
