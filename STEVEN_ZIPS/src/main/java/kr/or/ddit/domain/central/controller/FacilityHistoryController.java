package kr.or.ddit.domain.central.controller;


import kr.or.ddit.domain.central.service.IFacilityHistoryService;
import kr.or.ddit.domain.central.vo.FacilityHistoryVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.central.service.IFacilityInfoService;
import kr.or.ddit.common.model.PaginationInfoVO;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/facility")
public class FacilityHistoryController {

    @Autowired
    private IFacilityHistoryService facilityHistoryService;

    @Autowired
    private IFacilityInfoService facilityInfoService;


    @GetMapping("/history.do")
    public String facilityHistory(
            FacilityInfoDTO dto,
            @RequestParam(value = "searchYn", required = false) String searchYn,
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            Model model
    ) {

        boolean searched = "Y".equals(searchYn);

        List<FacilityHistoryVO> list = facilityHistoryService.getFacilityHistoryList();

        List<FacilityInfoDTO> facilityInfoList = null;
        FacilityInfoDTO aptInfo = null;
        List<FacilityInfoDTO> aptCardList = null;

        String detailMessage = null;
        String detailErrorMessage = null;

        /*
         * PaginationInfoVO란?
         * → 페이징 계산을 대신 해주는 공통 객체.
         *
         * 왜 사용?
         * → startRow, endRow, totalPage, Prev/Next HTML을 직접 계산하지 않아도 된다.
         *
         * screenSize = 8
         * → 카드 4개 x 2줄 = 한 페이지에 8개 출력.
         */
        PaginationInfoVO<FacilityInfoDTO> pagingVO = new PaginationInfoVO<>(8, 5);
        pagingVO.setCurrentPage(currentPage);
        pagingVO.setSearchVO(dto);

        if (searched) {

            /*
             * 검색 조건 + 페이징 row 값을 DTO에 세팅
             * Mapper XML에서 #{startRow}, #{endRow}로 사용한다.
             */
            dto.setStartRow(pagingVO.getStartRow());
            dto.setEndRow(pagingVO.getEndRow());

            int totalRecord = facilityInfoService.getAptCardTotalCount(dto);

            pagingVO.setTotalRecord(totalRecord);
            pagingVO.setCurrentPage(currentPage);

            dto.setStartRow(pagingVO.getStartRow());
            dto.setEndRow(pagingVO.getEndRow());

            aptCardList = facilityInfoService.getAptCardList(dto);

            pagingVO.setDataList(aptCardList);
        }

        if (dto.getAptCmplexNo() != null && !dto.getAptCmplexNo().isEmpty()) {

            try {
                facilityInfoList = facilityInfoService.getFacilityInfoList(dto);

                if (facilityInfoList != null && !facilityInfoList.isEmpty()) {
                    aptInfo = facilityInfoList.get(0);
                } else {
                    detailMessage = "조회된 데이터가 없습니다.";
                }

            } catch (Exception e) {
                log.error("단지 시설 상세정보 조회 중 오류 발생", e);
                detailErrorMessage = "단지 시설정보를 불러오는 중 에러가 발생했습니다.";
            }
        }

        List<String> sidoList = facilityInfoService.getSidoList();

        List<String> sigunguList = null;

        if (dto.getSidoNm() != null && !dto.getSidoNm().isEmpty()) {
            sigunguList = facilityInfoService.getSigunguList(dto.getSidoNm());
        }

        model.addAttribute("list", list);
        model.addAttribute("dto", dto);
        model.addAttribute("searched", searched);
        model.addAttribute("aptInfo", aptInfo);
        model.addAttribute("facilityInfoList", facilityInfoList);
        model.addAttribute("aptCardList", aptCardList);
        model.addAttribute("pagingVO", pagingVO);
        model.addAttribute("sidoList", sidoList);
        model.addAttribute("sigunguList", sigunguList);
        model.addAttribute("detailMessage", detailMessage);
        model.addAttribute("detailErrorMessage", detailErrorMessage);

        return "central/facility/fac-mnt-history";
    }
//    @GetMapping("/history.do")
//    public String facilityHistory(Model model) {
//
//        List<FacilityHistoryVO> list = facilityHistoryService.getFacilityHistoryList();
//
//        model.addAttribute("list", list);
//
//        return "central/facility/fac-mnt-history";
//    }



    @GetMapping("/checkHistory.do")
    public String facilityCheckHistory() {
        return "central/facility/fac-chk-history";
    }

    @GetMapping("/historyDetail.do")
    public String detail(@RequestParam String id, Model model) {

        FacilityHistoryVO data = facilityHistoryService.getFacilityHistoryDetail(id);

        model.addAttribute("data", data);

        return "central/facility/fac-mnt-historyDetail";
    }


}
