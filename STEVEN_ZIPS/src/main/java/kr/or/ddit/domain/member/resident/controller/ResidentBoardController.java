package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.member.resident.service.IResidentBoardService;
import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;


@Controller
@RequestMapping("/resident")
@RequiredArgsConstructor
public class ResidentBoardController {

    private final IResidentBoardService service;

    @PreAuthorize("@authService.hasAptAccess(principal, #aptCmplexNo)")
    @PostMapping("/boardFreeWrite.do")
    public String boardFreeWrite(
            RsidBoardVO rsidBoardVO,
            @RequestParam String aptCmplexNo,
            @RequestParam(required = false) MultipartFile attachFile,
            @AuthenticationPrincipal CustomUser principal) {

        rsidBoardVO.setWrtrId(principal.getMember().getUserId());
        rsidBoardVO.setBoardNo(aptCmplexNo + "_free");
        service.insertBoardFree(rsidBoardVO);
        return "redirect:/resident/boardFreeList.do";
    }

    @PreAuthorize("@authService.hasAptAccess(principal, #aptCmplexNo)")
    @GetMapping("/boardFreeList.do")
    public String boardFreeList(RsidBoardVO rsidBoardVO,
                                Model model){

        List<RsidBoardVO> list = service.boardFreeList(rsidBoardVO);
        model.addAttribute("list", list);
        return "member/resident/board/free/list";
    }





}
