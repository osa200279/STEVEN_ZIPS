package kr.or.ddit.domain.apt.main.controller;

import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/apt")
public class AptController {

    @Autowired
    IAptComplexService aptComplexService;

    /**
     * 단지별 메인 페이지 컨트롤러
     * @author 이용로
     * @param aptCmplexNo 단지코드
     * @param model
     * @return apt-main.jsp
     */
    @GetMapping("/main/{aptCmplexNo}")
    public String aptMain(@PathVariable String aptCmplexNo, Model model) {
        log.info("aptMain() 실행 \n아파트 코드 : {}", aptCmplexNo);

        // 아파트 메인페이지 DTO정보 가져오기
        AptMainPageDTO.ResponseDto aptMainPageDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptMainPageDTO);

        return "apt-main";
    }

}
