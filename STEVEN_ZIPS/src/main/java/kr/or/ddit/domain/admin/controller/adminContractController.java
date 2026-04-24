package kr.or.ddit.domain.admin.controller;


import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/admin")
public class adminContractController {

    @GetMapping("/list.do")
    public String adminContractList(){

        return "admin/adminContractMgmt";
    }

    @GetMapping("/subList.do")
    public String adminSubList(){

        return "admin/adminSubMgmt";
    }




}
