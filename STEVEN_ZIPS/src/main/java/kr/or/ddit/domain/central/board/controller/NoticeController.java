package kr.or.ddit.domain.central.board.controller;

import kr.or.ddit.domain.central.board.service.INoticeService;
import kr.or.ddit.domain.central.board.vo.NoticeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/")
public class NoticeController {

    @Autowired
    private INoticeService noticeService;

    @GetMapping("/notice/list.do")
    public String noticeList(Model model) {


        List<NoticeVO> noticeList = noticeService.getNoticeList();

        model.addAttribute("noticeList", noticeList);

        return "ztestview/notice";

    }
}
