package kr.or.ddit.domain.ztest;


import kr.or.ddit.domain.apt.vo.AptComplexVO;
import kr.or.ddit.domain.ztest.service.ICentralAptComplexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/apt")
public class APTController {

    @Autowired
    private ICentralAptComplexService aptComplexService;

    @GetMapping("/list.do")
    public String list(@RequestParam(value = "initial", required = false) String initial,
                       @RequestParam(value = "page", required = false, defaultValue = "1") int currentPage,
                       Model model) {
        List<AptComplexVO> aptList = aptComplexService.selectAptComplexList(initial);

        model.addAttribute("aptList", aptList);
        model.addAttribute("selectedInitial", initial);

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
