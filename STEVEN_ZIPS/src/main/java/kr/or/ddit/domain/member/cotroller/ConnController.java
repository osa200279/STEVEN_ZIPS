package kr.or.ddit.domain.member.cotroller;

import kr.or.ddit.domain.member.service.IMemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

@Slf4j
@Controller
public class ConnController {

    @Autowired
    private IMemberService service;

    // 로그인 페이지
    @GetMapping("/login.do")
    public String loginPage(){
        log.info("loginPage() 실행");
        return "member/login";
    }

}
