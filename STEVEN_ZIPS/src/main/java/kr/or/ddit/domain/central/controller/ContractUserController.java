package kr.or.ddit.domain.central.controller;

import kr.or.ddit.domain.central.board.service.INoticeService;
import kr.or.ddit.domain.central.board.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/contract")
public class ContractUserController {

    @Autowired
    private INoticeService noticeService;

    @GetMapping("/list.do")
    public String contractList() {

        return "central/contract/contractList";
    }

    @GetMapping("/notice.do")
    public String contractNotice() {
        return "central/contract/contractNotice"; // JSP 이름
    }

    @GetMapping("/apply.do")
    public String contractApply() {
        return "central/contract/contractApply";
    }

    @GetMapping("/noticeList.do")
    public String noticeList() {
        return "central/contract/notice";
    }

    @GetMapping("/history.do")
    public String contractHistory() {
        return "central/contract/contractAList";
    }

    @GetMapping("/detail.do")
    public String contractDetail(String annNo, Model model) {

        NoticeVO notice = noticeService.getNoticeDetail(annNo);
        model.addAttribute("notice", notice);


        return "central/contract/contractNoticeDetail"; // 상세 JSP
    }
}
