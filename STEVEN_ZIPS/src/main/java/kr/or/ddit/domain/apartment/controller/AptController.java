package kr.or.ddit.domain.apartment.controller;

import kr.or.ddit.domain.apartment.service.IAptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/apt")
public class AptController {

    @Autowired
    private IAptService aptService;

    @PostMapping("/collect")
    @ResponseBody
    public String collectMapoApt() {

        aptService.collectMapoApt();

        return "OK";
    }
}
