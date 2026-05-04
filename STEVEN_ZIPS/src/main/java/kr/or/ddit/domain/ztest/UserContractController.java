package kr.or.ddit.domain.ztest;

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
public class UserContractController {


    @Autowired
    private INoticeService noticeService;

        @GetMapping("/list.do")
        public String contractList() {

            return "ztestview/contractList";
        }

        @GetMapping("/notice.do")
        public String contractNotice() {
            return "ztestview/contractNotice"; // JSP 이름
        }

        @GetMapping("/apply.do")
        public String contractApply() {
            return "ztestview/contractApply";
        }

        @GetMapping("/noticeList.do")
        public String noticeList() {
        return "ztestview/notice";
    }

    @GetMapping("/history.do")
    public String contractHistory() {
        return "ztestview/contractAList";
    }

    @GetMapping("/detail.do")
    public String contractDetail(String annNo, Model model) {

        NoticeVO notice = noticeService.getNoticeDetail(annNo);
        model.addAttribute("notice", notice);


        return "ztestview/contractNoticeDetail"; // 상세 JSP
    }
}
