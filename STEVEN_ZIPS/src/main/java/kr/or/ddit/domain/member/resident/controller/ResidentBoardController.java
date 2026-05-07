package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.service.IResidentBoardService;
import kr.or.ddit.domain.member.resident.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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
            @AuthenticationPrincipal CustomUser principal) {

        rsidBoardVO.setWrtrId(principal.getMember().getUserId());
        rsidBoardVO.setBoardNo(aptCmplexNo + "_free");
        service.insertBoardFree(rsidBoardVO);
        System.out.println("aptCmplexNo: " + aptCmplexNo);
        System.out.println("boardNo: " + rsidBoardVO.getBoardNo());
        return "redirect:/resident/boardFreeList/" + aptCmplexNo;
    }

    //@PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/boardFreeList/{aptCmplexNo}")
    public String boardFreeList(
            @PathVariable String aptCmplexNo,
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
    
    @GetMapping("/boardFreeDetail/{annNo}/{aptCmplexNo}")
    public String boardFreeDetail(@PathVariable String annNo,
                                  @PathVariable String aptCmplexNo,
                                  @AuthenticationPrincipal CustomUser principal,
                                  RsidBoardVO rsidBoardVO,
                                  Model model){
        rsidBoardVO.setAnnNo(annNo);
        service.updateInqCnt(annNo);
        RsidBoardVO board = service.selectOneBoardFree(rsidBoardVO);
        System.out.println("board: " + board);

        model.addAttribute("board", board);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("annNo", annNo);
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

    @PutMapping("/boardFreeDelete/{annNo}")
    @ResponseBody
    public Map<String, Object> boardFreeDelete(@PathVariable String annNo){
        Map<String, Object> result = new HashMap<>();
        int cnt = service.deleteBoardFree(annNo);
        System.out.println("updateResult: " + cnt);
        result.put("success", cnt > 0);
        return result;
    }

    @PostMapping("/insertBoardComment")
    @ResponseBody
    public Map<String, Object> insertBoardComment(@RequestBody RsidBoardCommentVO rsidBoardCommentVO,
                                                  @PathVariable String annNo,
                                                  @AuthenticationPrincipal CustomUser principal
                                                  ){
        Map<String, Object> result = new HashMap<>();
        rsidBoardCommentVO.setPostNo(annNo);
        rsidBoardCommentVO.setUserNo(principal.getMember().getUserId());
        int cnt = service.insertBoardComment(rsidBoardCommentVO);
        result.put("success", cnt > 0);
        return result;

    }




}
