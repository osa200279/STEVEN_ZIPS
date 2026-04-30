package kr.or.ddit.domain.ztest;


import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/apt")
public class APTController {


    @GetMapping("/list.do")
    public String list() {
        return "ztestview/aptList";
    }

    @GetMapping("/search.do")
    public String search() {
        return "ztestview/aptSearch";
    }

    @GetMapping("/dashboard.do")
    public String dashboard() {
        return "ztestview/aptDashboard";
    }

    @GetMapping("/intro.do")
    public String intro() {
        return "ztestview/service";
    }

}
