package kr.or.ddit.domain.central.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
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
}
