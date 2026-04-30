package kr.or.ddit.domain.ztest;


import kr.or.ddit.domain.ztest.service.IFacilityHistoryService;
import kr.or.ddit.domain.ztest.vo.FacilityHistoryVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/fac")
public class FacilityHistoryController {

    @Autowired
    private IFacilityHistoryService facilityHistoryService;

    @GetMapping("/facilityHistory.do")
    public String facilityHistory(Model model) {

        List<FacilityHistoryVO> list = facilityHistoryService.getFacilityHistoryList();

        model.addAttribute("list", list);

        return "ztestview/fac-mnt-history";
    }



    @GetMapping("/facilityCheckHistory.do")
    public String facilityCheckHistory() {
        return "ztestview/fac-chk-history";
    }

    @GetMapping("/facilityHistoryDetail.do")
    public String detail(@RequestParam String id, Model model) {

        FacilityHistoryVO data = facilityHistoryService.getFacilityHistoryDetail(id);

        model.addAttribute("data", data);

        return "ztestview/fac-mnt-historyDetail";
    }





}
