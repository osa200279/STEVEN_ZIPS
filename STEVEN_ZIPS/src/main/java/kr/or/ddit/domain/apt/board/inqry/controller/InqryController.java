package kr.or.ddit.domain.apt.board.inqry.controller;

import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;
import kr.or.ddit.domain.apt.board.inqry.service.IInqryService;
import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
@RequestMapping("/board/inqry")
public class InqryController {

    private final IInqryService inqryService;

    @GetMapping("/list.do")
    public String inqryList(
            @RequestParam(value = "page", defaultValue = "1") int currentPage,
            Model model,
            Authentication auth
    ) {
        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        PaginationInfoVO<InqryDTO> pagingVO = new PaginationInfoVO<>();

        pagingVO.setScreenSize(2);
        pagingVO.setCurrentPage(currentPage);

        int totalRecord = inqryService.getTotalCount(
                user.getUserNo(),
                user.getUserId()
        );

        pagingVO.setTotalRecord(totalRecord);

        List<InqryDTO> list = inqryService.getList(
                user.getUserNo(),
                user.getUserId(),
                pagingVO.getStartRow(),
                pagingVO.getEndRow()
        );

        pagingVO.setDataList(list);

        model.addAttribute("pagingVO", pagingVO);

        return "apt/inqry/inqryList";
    }

    @GetMapping("/writeForm.do")
    public String writeForm() {
        return "apt/inqry/inqryListDetail";
    }

    @PostMapping("/writeProc.do")
    public String writeProc(
            InqryDTO dto,
            Authentication auth,
            Model model
    ) {
        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        dto.setWrtrId(user.getUserId());

        try {
            inqryService.insertInqry(dto, user.getUserNo());
        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "apt/inqry/inqryListDetail";
        }

        return "redirect:/board/inqry/list.do";
    }





    @GetMapping("/updateForm.do")
    public String updateForm(
            @RequestParam String postNo,
            Authentication auth,
            Model model
    ) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        InqryDTO inqry = inqryService.detail(
                postNo,
                user.getUserNo(),
                user.getUserId()
        );

        model.addAttribute("inqry", inqry);

        return "apt/inqry/inqryListDetail";
    }

    @PostMapping("/updateProc.do")
    public String updateProc(
            InqryDTO dto,
            Authentication auth,
            Model model
    ) {

        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        dto.setWrtrId(user.getUserId());
        dto.setUserNo(user.getUserNo());

        try {

            inqryService.updateInqry(
                    dto,
                    user.getUserNo(),
                    user.getUserId()
            );

        } catch (RuntimeException e) {

            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("inqry", dto);

            return "apt/inqry/inqryListDetail";
        }

        return "redirect:/board/inqry/list.do";
    }






    @GetMapping("/delete.do")
    public String deleteInqry(
            @RequestParam String postNo,
            Authentication auth
    ) {
        CustomUser customUser = (CustomUser) auth.getPrincipal();
        MemberVO user = customUser.getMember();

        inqryService.deleteInqry(
                postNo,
                user.getUserNo(),
                user.getUserId()
        );

        return "redirect:/board/inqry/list.do";
    }
}

