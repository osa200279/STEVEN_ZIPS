package kr.or.ddit.domain.ztest;

import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import kr.or.ddit.domain.ztest.service.IQnaService;
import kr.or.ddit.domain.ztest.vo.CvplVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/member/qna")
public class QnaController {


    @Autowired
    private IQnaService qnaService;

    @GetMapping("/list.do")
    public String qnaList(Model model, Authentication auth) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        List<CvplVO> list = qnaService.getList(user.getUserNo());

        model.addAttribute("list", list);

        return "ztestview/qnaList";
    }
    @GetMapping("/writeForm.do")
    public String writeForm() {
        return "ztestview/qnaListDetail";
    }

    @PostMapping("/writeProc.do")
    public String writeProc(CvplVO vo, Authentication auth) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        vo.setUserNo(user.getUserNo());
        vo.setHoNo("101-101");

        qnaService.insertQna(vo);

        return "redirect:/member/qna/list.do";
    }

    @GetMapping("/delete.do")
    public String deleteQna(@RequestParam String cvplNo,
                            Authentication auth) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        qnaService.deleteQna(cvplNo, user.getUserNo());

        return "redirect:/member/qna/list.do";
    }

}
