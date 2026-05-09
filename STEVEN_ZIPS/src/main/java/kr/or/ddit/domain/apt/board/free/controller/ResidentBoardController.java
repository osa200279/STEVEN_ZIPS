package kr.or.ddit.domain.apt.board.free.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.board.free.service.IResidentBoardService;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/resident")
@RequiredArgsConstructor
public class ResidentBoardController {

    private final IResidentBoardService service;

    //@PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @PostMapping("/boardFreeWrite.do")
    public String boardFreeWrite(
            RsidBoardVO rsidBoardVO,
            @RequestParam String aptCmplexNo,
            @RequestParam(required = false) MultipartFile attachFile,
            @AuthenticationPrincipal CustomUser principal) throws IOException {

        rsidBoardVO.setWrtrId(principal.getMember().getUserId());
        rsidBoardVO.setBoardNo(aptCmplexNo + "_free");
        service.insertBoardFree(rsidBoardVO, attachFile);
        System.out.println("aptCmplexNo: " + aptCmplexNo);
        System.out.println("boardNo: " + rsidBoardVO.getBoardNo());
        return "redirect:/resident/boardFreeList/" + aptCmplexNo;
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/boardFreeList/{aptCmplexNo}")
    public String boardFreeList(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam(name = "page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name = "searchWord", required = false) String searchWord,
            @RequestParam(name = "searchType", required = false) String searchType,
            Model model) {

        PaginationInfoVO<RsidBoardVO> pagingVO = new PaginationInfoVO<>();

        if (StringUtils.isNotBlank(searchWord)) {
            pagingVO.setSearchWord(searchWord);
            model.addAttribute("searchWord", searchWord);
        }
        if (StringUtils.isNotBlank(searchType)) {
            pagingVO.setSearchType(searchType);
            model.addAttribute("searchType", searchType);
        }

        pagingVO.setAptCmplexNo(aptCmplexNo + "_free");
        pagingVO.setSearchWord(searchWord);
        pagingVO.setSearchType(searchType);

        pagingVO.setCurrentPage(currentPage);
        int totalRecord = service.selectBoardFreeCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        List<RsidBoardVO> dataList = service.boardFreeList(pagingVO);
        System.out.println("dataList: " + dataList);
        System.out.println("dataList size: " + dataList.size());
        pagingVO.setDataList(dataList);

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("aptCmplexNo", aptCmplexNo);

        return "member/resident/board/board_free_list";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/boardFreeDetail/{postNo}/{aptCmplexNo}")
    public String boardFreeDetail(@PathVariable String postNo,
                                  @PathVariable String aptCmplexNo,
                                  @AuthenticationPrincipal CustomUser principal,
                                  RsidBoardVO rsidBoardVO,
                                  Model model){
        System.out.println("=== 상세보기 디버그 ===");
        System.out.println("postNo: " + postNo);
        rsidBoardVO.setPostNo(postNo);
        System.out.println("rsidBoardVO.postNo: " + rsidBoardVO.getPostNo());
        service.updateInqCnt(postNo);
        RsidBoardVO board = service.selectOneBoardFree(rsidBoardVO);
        model.addAttribute("freeBoard", board);
        System.out.println("board.ttl: " + (board != null ? board.getTtl() : "NULL"));
        System.out.println("====================");

        model.addAttribute("freeBoard", board);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("postNo", postNo);
        return "member/resident/board/board_free_detail";
    }

    @PutMapping("/boardFreeUpdate")
    @ResponseBody
    public Map<String, Object> boardFreeUpdate(@RequestBody RsidBoardVO rsidBoardVO){
        Map<String, Object> result =  new HashMap<>();
        int cnt = service.updateBoardFree(rsidBoardVO);
        result.put("success", cnt > 0);
        return result;
    }

    @PutMapping("/boardFreeDelete/{postNo}")
    @ResponseBody
    public Map<String, Object> boardFreeDelete(@PathVariable String postNo){
        Map<String, Object> result = new HashMap<>();
        int cnt = service.deleteBoardFree(postNo);
        System.out.println("updateResult: " + cnt);
        result.put("success", cnt > 0);
        return result;
    }

    @PostMapping("/insertBoardComment/{postNo}")
    @ResponseBody
    public Map<String, Object> insertBoardComment(@RequestBody RsidBoardCommentVO rsidBoardCommentVO,
                                                  @PathVariable String postNo,
                                                  @AuthenticationPrincipal CustomUser principal
                                                  ){

        Map<String, Object> result = new HashMap<>();
        rsidBoardCommentVO.setPostNo(postNo);
        rsidBoardCommentVO.setUserNo(principal.getMember().getUserNo());
        int cnt = service.insertBoardComment(rsidBoardCommentVO);
        result.put("success", cnt > 0);
        return result;

    }

    @GetMapping("/boardFreeComment/{postNo}")
    @ResponseBody
    public List<RsidBoardCommentVO> boardFreeComment(@PathVariable String postNo) {
        return service.boardFreeComment(postNo);
    }

    @PutMapping("/updateBoardComment")
    @ResponseBody
    public Map<String, Object> updateBoardComment(@RequestBody RsidBoardCommentVO rsidBoardCommentVO){
        Map<String, Object> result = new HashMap<>();
        int cnt = service.updateBoardComment(rsidBoardCommentVO);
        result.put("success", cnt > 0);
        return result;
    }

    @PutMapping("/deleteBoardComment/{cmtNo}")
    @ResponseBody
    public Map<String, Object> deleteBoardComment(@PathVariable String cmtNo){
        Map<String, Object> result = new HashMap<>();
        int cnt = service.deleteBoardComment(cmtNo);
        result.put("success", cnt > 0);
        return result;
    }

    @PostMapping("/insertSubComment/{cmtNo}")
    @ResponseBody
    public Map<String, Object> insertSubComment(@RequestBody RsidBoardCommentVO rsidBoardCommentVO,
                                                @PathVariable String cmtNo,
                                                @AuthenticationPrincipal CustomUser principal){
        Map<String, Object> result = new HashMap<>();
        rsidBoardCommentVO.setCmtNo(cmtNo);
        rsidBoardCommentVO.setUserNo(principal.getMember().getUserNo());
        int cnt = service.insertSubComment(rsidBoardCommentVO);
        result.put("success", cnt > 0);
        return result;

    }






}
