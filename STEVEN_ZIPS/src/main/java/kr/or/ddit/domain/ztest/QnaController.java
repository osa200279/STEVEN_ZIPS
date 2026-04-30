package kr.or.ddit.domain.ztest;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/qna")
public class QnaController {


    @GetMapping("/list.do")
    public String qnaList() {
        return "ztestview/qnaList";
    }


    @GetMapping("/writeForm.do")
    public String writeForm() {
        return "ztestview/qnaListDetail";
    }

}
