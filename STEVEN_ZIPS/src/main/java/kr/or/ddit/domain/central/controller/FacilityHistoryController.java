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
            Model model
    ) {

        /*
         * searchYn
         * → 사용자가 조회 버튼을 눌렀는지 구분하는 값.
         *
         * 왜 필요?
         * → 처음 화면에 들어왔을 때는 검색하지 않고 빈 화면으로 보여주기 위해.
         *
         * 사용 상황
         * → JSP 검색 form에 hidden input으로 searchYn=Y를 보내면
         *   그때만 DB 조회를 실행한다.
         */
        boolean searched = "Y".equals(searchYn);

        List<FacilityHistoryVO> list = facilityHistoryService.getFacilityHistoryList();

        List<FacilityInfoDTO> facilityInfoList = null;
        FacilityInfoDTO aptInfo = null;

        /*
         * 카드 목록 데이터
         *
         * 검색 결과로 여러 단지가 조회될 수 있으므로
         * 카드 형태로 먼저 보여주기 위해 사용.
         */
        List<FacilityInfoDTO> aptCardList = null;

        /*
         * 검색 버튼 클릭 시 카드 목록 조회
         */
        if (searched) {
            aptCardList = facilityInfoService.getAptCardList(dto);
        }

        /*
         * 카드 클릭 시 상세조회
         *
         * aptCmplexNo가 존재하면
         * 선택한 단지 상세정보를 조회한다.
         */
        if (dto.getAptCmplexNo() != null
                && !dto.getAptCmplexNo().isEmpty()) {

            facilityInfoList = facilityInfoService.getFacilityInfoList(dto);

            if (facilityInfoList != null
                    && !facilityInfoList.isEmpty()) {

                aptInfo = facilityInfoList.get(0);
            }
        }

        /*
         * 검색용 지역 목록 조회
         */
        List<String> sidoList = facilityInfoService.getSidoList();

        List<String> sigunguList = null;

        /*
         * 시/도가 선택된 경우에만
         * 해당 시/군/구 목록 조회
         */
        if (dto.getSidoNm() != null
                && !dto.getSidoNm().isEmpty()) {

            sigunguList = facilityInfoService.getSigunguList(dto.getSidoNm());
        }

        model.addAttribute("list", list);
        model.addAttribute("dto", dto);
        model.addAttribute("searched", searched);
        model.addAttribute("aptInfo", aptInfo);
        model.addAttribute("facilityInfoList", facilityInfoList);
        model.addAttribute("aptCardList", aptCardList);
        model.addAttribute("sidoList", sidoList);
        model.addAttribute("sigunguList", sigunguList);

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
