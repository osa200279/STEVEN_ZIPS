package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/adm")
public class AdmJspToReactController {

    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @GetMapping("/home")
    public String home(){
        return "redirect:http://localhost:7777";
    }

}
