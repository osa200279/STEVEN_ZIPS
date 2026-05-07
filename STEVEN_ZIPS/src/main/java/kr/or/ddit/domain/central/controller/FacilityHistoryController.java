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

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/facility")
public class FacilityHistoryController {

    @Autowired
    private IFacilityHistoryService facilityHistoryService;

    @GetMapping("/history.do")
    public String facilityHistory(Model model) {

        List<FacilityHistoryVO> list = facilityHistoryService.getFacilityHistoryList();

        model.addAttribute("list", list);

        return "central/facility/fac-mnt-history";
    }



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
