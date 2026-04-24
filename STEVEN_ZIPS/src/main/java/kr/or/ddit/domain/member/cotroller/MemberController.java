package kr.or.ddit.domain.member.cotroller;

import kr.or.ddit.domain.member.service.IMemberService;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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

    @PostMapping("/join")
    public String joinMember(MemberVO member, Model model){
        service.joinMember(member);

        return "redirect:/main";
    }
}
