package kr.or.ddit.domain.central.controller;

import kr.or.ddit.domain.central.dto.RentListingMapDTO;
import kr.or.ddit.domain.central.service.IRentService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/rent")
public class RentController {

    @Autowired
    private IRentService rentService;

    /**
     * 작성자 : 이윤진
     * 임대 매물 지도 화면
     */
    @GetMapping("/map")
    public String rentMap() {
        log.info("임대 매물 지도 화면 진입");
        return "central/rentMap";
    }

    // 임대 매물 목록 화면
    @GetMapping("/list")
    public String rentList(Model model) {
        log.info("임대 매물 목록 화면 진입");

        List<RentListingMapDTO> rentList = rentService.selectRentListingMapList();
        model.addAttribute("rentList", rentList);
        return "central/rentList";
    }

    // 임대 매물 목록 JSON
    @GetMapping("/list-data")
    @ResponseBody
    public Map<String, Object> rentListData() {
        Map<String, Object> result = new HashMap<>();

        try {
            List<RentListingMapDTO> list = rentService.selectRentListingMapList();

            result.put("success", true);
            result.put("list", list);

        } catch (Exception e) {
            log.error("매물 목록 조회 중 오류 발생", e);

            result.put("success", false);
            result.put("message", "매물 목록 조회 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 임대 매물 상세 화면
    @GetMapping("/detail/{rentLstgNo}")
    public String rentDetail(@PathVariable String rentLstgNo, Model model) {

        log.info("임대 매물 상세 화면 진입 rentLstgNo={}", rentLstgNo);

        RentListingMapDTO rentDetail = rentService.selectRentListingDetail(rentLstgNo);
        model.addAttribute("rentDetail", rentDetail);

        return "central/rentDetail";
    }

    // 임대 매물 상세 JSON
    @GetMapping("/detail-data/{rentLstgNo}")
    @ResponseBody
    public Map<String, Object> rentDetailData(@PathVariable String rentLstgNo) {
        Map<String, Object> result = new HashMap<>();

        try {
            RentListingMapDTO detail = rentService.selectRentListingDetail(rentLstgNo);

            result.put("success", true);
            result.put("detail", detail);

        } catch (Exception e) {
            log.error("매물 상세 조회 중 오류 발생 rentLstgNo={}", rentLstgNo, e);

            result.put("success", false);
            result.put("message", "매물 상세 조회 중 오류가 발생했습니다.");
        }

        return result;
    }
}
