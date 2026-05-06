package kr.or.ddit.domain.apt.complaint.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@PreAuthorize("hasRole('RESIDENT') and @authService.hasAccess(principal, #aptCmplexNo)")
@RequestMapping("/apt/cvpl/{aptCmplexNo}")
public class CvplController {

}
