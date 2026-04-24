package kr.or.ddit.domain.ApiApartment.controller;

import kr.or.ddit.domain.ApiApartment.service.IAptApiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/api")
@Slf4j
public class AptApiController {

    @Autowired
    private IAptApiService aptService;

    @PostMapping("/apt/collect")
    @ResponseBody
    public String collectMapoApt() {
        log.info("collectMapoApt() 실행됨...!");

        aptService.collectMapoApt();

        return "OK";
    }
}