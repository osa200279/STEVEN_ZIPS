package kr.or.ddit.domain.ztest;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/contract")
public class UserContractController {



    @GetMapping("/list.do")
    public String contractList() {
        return "ztestview/contractList";
    }
}
