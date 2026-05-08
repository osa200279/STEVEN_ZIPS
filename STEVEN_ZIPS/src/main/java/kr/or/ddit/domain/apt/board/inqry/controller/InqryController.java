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
        pagingVO.setScreenSize(5);
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


//package kr.or.ddit.domain.apt.board.inqry.controller;
//
//import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
//import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
//import kr.or.ddit.domain.member.vo.CustomUser;
//import kr.or.ddit.domain.member.vo.MemberVO;
//import kr.or.ddit.domain.apt.board.inqry.service.IInqryService;
//import lombok.extern.slf4j.Slf4j;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.security.core.Authentication;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//
//import java.util.List;
//import java.util.Map;
//
//@Slf4j
//@Controller
//@RequestMapping("/board/qna")
//public class InqryController {
//
//
//    @Autowired
//    private IInqryService qnaService;
//
//    @GetMapping("/list.do")
//    public String qnaList(
//            @RequestParam(value = "page", defaultValue = "1") int currentPage,
//            Model model,
//            Authentication auth
//    ) {
//
//        CustomUser customUser = (CustomUser) auth.getPrincipal();
//        MemberVO user = customUser.getMember();
//
//        PaginationInfoVO<CvplVO> pagingVO = new PaginationInfoVO<>();
//        // 페이지당 개수
//        pagingVO.setScreenSize(2);
//        // 현재 페이지
//        pagingVO.setCurrentPage(currentPage);
//
//        // 전체 개수
//        int totalRecord =
//                qnaService.getTotalCount(user.getUserNo());
//
//        pagingVO.setTotalRecord(totalRecord);
//
//        // 목록 조회
//        List<CvplVO> list =
//                qnaService.getList(
//                        user.getUserNo(),
//                        pagingVO.getStartRow(),
//                        pagingVO.getEndRow()
//                );
//
//        pagingVO.setDataList(list);
//
//        model.addAttribute("pagingVO", pagingVO);
//
//        return "central/board/qna/qnaList";
//    }
//
//
//
//
//    @GetMapping("/writeForm.do")
//    public String writeForm() {
//        return "central/board/qna/qnaListDetail";
//    }
//
//    @PostMapping("/writeProc.do")
//    public String writeProc(CvplVO vo, Authentication auth, Model model) {
//
//        CustomUser customUser = (CustomUser) auth.getPrincipal();
//        MemberVO user = customUser.getMember();
//
//        Map<String, Object> info;
//
//        try {
//            info = qnaService.getResidentInfo(user.getUserNo());
//        } catch (RuntimeException e) {
//            model.addAttribute("errorMessage", "세대 정보가 연결되지 않아 문의를 등록할 수 없습니다. 관리자에게 입주민 승인 상태를 확인해주세요.");
//            return "central/board/qna/qnaListDetail";
//            // return이란?
//            // → 이동할 JSP 화면 경로를 정하는 것.
//            // 여기서는 등록 실패 시 작성 화면으로 다시 보냄.
//        }
//
//        vo.setUserNo(user.getUserNo());
//        vo.setHoNo(String.valueOf(info.get("HONO")));
//        vo.setAptCmplexNo(String.valueOf(info.get("APTCMPLEXNO")));
//
//        qnaService.insertQna(vo);
//
//        return "redirect:/board/qna/list.do";
//    }
//
////    @PostMapping("/writeProc.do")
////    public String writeProc(CvplVO dto, Authentication auth) {
////
////        CustomUser customUser = (CustomUser) auth.getPrincipal();
////        MemberVO user = customUser.getMember();
////
////
////        Map<String, Object> info =
////                qnaService.getResidentInfo(user.getUserNo());
////
////        dto.setUserNo(user.getUserNo());
////        dto.setHoNo((String) info.get("HO_NO"));
////        dto.setAptCmplexNo((String) info.get("APT_CMPLEX_NO"));
////        //dto.setAptCmplexNo(user.getAptCmplexNo());
////
//////        System.out.println("apt = " + user.getAptCmplexNo());
////       /* dto.setAptCmplexNo(user.getAptCmplexNo());*/
////
////
////       /* System.out.println("apt = " + user.getAptCmplexNo());*/
////
////        qnaService.insertQna(dto);
////
////        return "redirect:/board/qna/list.do";
////    }
//
//    @GetMapping("/delete.do")
//    public String deleteQna(@RequestParam String cvplNo,
//                            Authentication auth) {
//
//        CustomUser customUser = (CustomUser) auth.getPrincipal();
//        MemberVO user = customUser.getMember();
//
//        qnaService.deleteQna(cvplNo, user.getUserNo());
//
//        return "redirect:/board/qna/list.do";
//    }
//
//}
