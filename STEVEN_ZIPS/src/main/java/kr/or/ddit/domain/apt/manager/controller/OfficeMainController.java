package kr.or.ddit.domain.apt.manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/office")
public class OfficeMainController {

    @GetMapping("/main")

    public String officeMain(){
        return "manager/office";
    }
}
