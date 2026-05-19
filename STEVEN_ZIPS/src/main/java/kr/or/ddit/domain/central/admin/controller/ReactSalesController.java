package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.service.IReactSalesService;
import kr.or.ddit.domain.central.service.ICentralAptComplexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@Slf4j
@RequestMapping("/api/sales")
public class ReactSalesController {

    @Autowired
    private ICentralAptComplexService aptComplexService;

    @Autowired
    private IReactSalesService ReactSalesService;

    /**
     * 시도 조회
     */
    @GetMapping("/sido.do")
    public List<String> getSidoList() {

        return aptComplexService.selectSidoList();
    }

    /**
     * 시군구 조회
     */
    @GetMapping("/sigungu.do")
    public List<String> getSigunguList(
            @RequestParam String sidoNm
    ) {

        return aptComplexService.selectSigunguList(sidoNm);
    }

    /**
     * 읍면동 조회
     */
    @GetMapping("/dong.do")
    public List<String> getDongList(
            @RequestParam String sidoNm,
            @RequestParam String sigunguNm
    ) {

        return aptComplexService.selectDongList(
                sidoNm,
                sigunguNm
        );
    }

    @GetMapping("/apt/list")
    public PaginationInfoVO<AptComplexVO> searchAptList(
            AptComplexVO searchVO,
            @RequestParam(required = false) String keyword,
            @RequestParam(defaultValue = "1") int currentPage
    ) {

        PaginationInfoVO<AptComplexVO> pagingVO =
                new PaginationInfoVO<>();

        pagingVO.setScreenSize(10);

        pagingVO.setCurrentPage(currentPage);

        pagingVO.setSearchType(keyword);

        pagingVO.setSearchVO(searchVO);

        int totalRecord =
                aptComplexService.selectAptComplexCount(
                        pagingVO
                );

        pagingVO.setTotalRecord(totalRecord);

        pagingVO.setDataList(aptComplexService.selectAptComplexList(pagingVO));

        return pagingVO;
    }

    /**
     * 동 리스트 조회
     */
    @GetMapping("/building/list")
    public List<String> getBuildingList(
            @RequestParam String aptCmplexNo
    ) {

        return ReactSalesService.selectBuildingList(aptCmplexNo);
    }

}
