package kr.or.ddit.domain.member.controller;

import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.domain.member.service.IMemberService;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Slf4j
@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private IMemberService service;

    @GetMapping("/join.do")
    public String joinPage(){
        return "member/join";
    }

    // 2026.04.24 임시 회원가입
    @PostMapping("/join")
    public String joinMember(MemberVO member){
        log.info("joinMember() 실행");

        ServiceResult result = service.joinMember(member);
        if(result.equals(ServiceResult.OK)){
            return "redirect:/login.do";
        }else{
            return "member/join";
        }

    }
}
