package kr.or.ddit.domain.central.board.controller;

import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.board.vo.CvplVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import kr.or.ddit.domain.central.board.service.IQnaService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/board/qna")
public class QnaController {


    @Autowired
    private IQnaService qnaService;

    @GetMapping("/list.do")
    public String qnaList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            Model model,
            Authentication auth
    ) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        PaginationInfoVO<CvplVO> pagingVO = new PaginationInfoVO<>();
        // 페이지당 개수
        pagingVO.setScreenSize(2);
        // 현재 페이지
        pagingVO.setCurrentPage(currentPage);

        // 전체 개수
        int totalRecord =
                qnaService.getTotalCount(user.getUserNo());

        pagingVO.setTotalRecord(totalRecord);

        // 목록 조회
        List<CvplVO> list =
                qnaService.getList(
                        user.getUserNo(),
                        pagingVO.getStartRow(),
                        pagingVO.getEndRow()
                );

        pagingVO.setDataList(list);

        model.addAttribute("pagingVO", pagingVO);

        return "central/board/qna/qnaList";
    }




    @GetMapping("/writeForm.do")
    public String writeForm() {
        return "central/board/qna/qnaListDetail";
    }

    @PostMapping("/writeProc.do")
    public String writeProc(CvplVO vo, Authentication auth) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        vo.setUserNo(user.getUserNo());
        vo.setHoNo("101-101");

        qnaService.insertQna(vo);

        return "redirect:/board/qna/list.do";
    }

    @GetMapping("/delete.do")
    public String deleteQna(@RequestParam String cvplNo,
                            Authentication auth) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        qnaService.deleteQna(cvplNo, user.getUserNo());

        return "redirect:/board/qna/list.do";
    }

}
