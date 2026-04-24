package kr.or.ddit.domain.ztest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ztest")
public class ZTestController {

    @GetMapping("/mainn")
    public String mainn() {
        return  "ztestview/mainn";
    }

    @GetMapping("/introduce")
    public String introduce(){
        return "member/resident/manage_intro";
    }

    @GetMapping("/aptapi")
    public String aptapi(){
        return "ztestview/aptapi";
    }
}
