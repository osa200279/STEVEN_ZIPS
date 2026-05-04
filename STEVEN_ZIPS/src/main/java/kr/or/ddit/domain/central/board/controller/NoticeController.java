package kr.or.ddit.domain.central.board.controller;

import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.board.service.INoticeService;
import kr.or.ddit.domain.central.board.vo.NoticeVO;
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
@RequestMapping("/")
public class NoticeController {

    @Autowired
    private INoticeService noticeService;

    @GetMapping("/notice/list.do")
    public String noticeList(
            @RequestParam(defaultValue = "1") int page,
            Model model) {

        PaginationInfoVO<NoticeVO> pagingVO = new PaginationInfoVO<>();

        pagingVO.setScreenSize(6);

        pagingVO.setCurrentPage(page);



        int totalRecord = noticeService.getTotalCount();
        pagingVO.setTotalRecord(totalRecord);

        List<NoticeVO> noticeList = noticeService.getNoticeList(pagingVO);
        pagingVO.setDataList(noticeList);

        model.addAttribute("pagingVO", pagingVO);

        return "ztestview/notice";
    }

    @GetMapping("/notice/detail.do")
    public String noticeDetail(String annNo, Model model) {


        noticeService.incrementInqCnt(annNo);

        NoticeVO notice = noticeService.getNoticeDetail(annNo);

        model.addAttribute("notice", notice);

        return "ztestview/noticeDetail";
    }

}










