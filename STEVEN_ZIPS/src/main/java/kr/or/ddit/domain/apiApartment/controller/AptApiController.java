package kr.or.ddit.domain.apiApartment.controller;

import kr.or.ddit.domain.apiApartment.service.IAptApiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller // IAptApiService 구현체가 없어 서버 기동이 막혀 임시 비활성화
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
