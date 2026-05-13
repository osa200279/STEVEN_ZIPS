package kr.or.ddit.domain.central.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/rent")
public class RentController {
    /**
     * 임대 매물 지도 화면
     *
     * 현재는 화면/JS에서 하드코딩 데이터로 먼저 구현하고,
     * 추후 RENT_LISTING 테이블 조회 API를 연결할 예정
     */
    @GetMapping("/map")
    public String rentMap() {
        log.info("임대 매물 지도 화면 진입");
        return "central/rentMap";
    }

    /**
     * 임대 매물 목록 화면
     *
     * 현재는 rentList.jsp 내부에서 하드코딩 매물 데이터를 사용하고,
     * 추후 DB 연동 시 Model에 매물 목록을 담아 전달하도록 확장 예정
     *
     * 접속 주소:
     * /rent/list
     */
    @GetMapping("/list")
    public String rentList() {
        log.info("임대 매물 목록 화면 진입");
        return "central/rentList";
    }

    @GetMapping("/detail/{rentNo}")
    //@GetMapping("/detail")
    public String rentDetail(@PathVariable String rentNo, Model model) {

        // 1. 매물 기본 정보 조회
        // RentDetailDTO rentDetail = rentService.selectRentDetail(rentNo);

        // 2. 단지 정보 조회
        // AptComplexInfo aptInfo = aptComplexService.selectAptComplexInfo(...);

        // 3. 면적별 정보 조회
        // List<AptAreaInfo> areaList = aptComplexService.selectAptAreaInfoList(...);

        // model.addAttribute("rentDetail", rentDetail);
        // model.addAttribute("aptInfo", aptInfo);
        // model.addAttribute("areaList", areaList);

        return "central/rentDetail";
    }
}
