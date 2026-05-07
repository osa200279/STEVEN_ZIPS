package kr.or.ddit.domain.central.controller;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.service.ICentralAptComplexService;
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
@RequestMapping("/apt")
public class AptRetrieveController {

    @Autowired
    private ICentralAptComplexService aptComplexService;

    @GetMapping("/list.do")
    public String list(
            @RequestParam(value = "initial", required = false) String initial,
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "sidoNm", required = false) String sido,
            @RequestParam(value = "sigunguNm", required = false) String sigungu,
            @RequestParam(value = "unitCnt", required = false) String unitCnt,
            @RequestParam(value = "page", required = false, defaultValue = "1") int currentPage,
            Model model
    ) {

        PaginationInfoVO<AptComplexVO> pagingVO = new PaginationInfoVO<>();
        pagingVO.setScreenSize(12);

        pagingVO.setCurrentPage(currentPage);

        // ㄱ~ㅎ 초성검색
        pagingVO.setSearchWord(initial);

        // 단지명 검색
        pagingVO.setSearchType(keyword);

        // 총 개수
        int totalRecord =
                aptComplexService.selectAptComplexCount(pagingVO);
        pagingVO.setTotalRecord(totalRecord);

        // 페이징 목록 조회
        pagingVO.setDataList(
                aptComplexService.selectAptComplexList(pagingVO)
        );

        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("selectedInitial", initial);

        return "central/aptList";
    }

    @GetMapping("/search.do")
    public String search(
            @RequestParam(required = false) String keyword,
            Model model
    ) {

        List<AptComplexVO> aptList = aptComplexService.searchApt(keyword);

        model.addAttribute("aptList", aptList);

        return "central/aptSearch";
    }

}
