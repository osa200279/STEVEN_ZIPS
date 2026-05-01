package kr.or.ddit.domain.apt.cotnroller;

import kr.or.ddit.domain.apt.dto.AptMainDTO;
import kr.or.ddit.domain.apt.vo.AptComplexVO;
import kr.or.ddit.domain.member.manager.servcie.IAptComplexService;
import lombok.extern.slf4j.Slf4j;
import org.checkerframework.checker.units.qual.A;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
    @GetMapping("/main")
    public String aptMain(@RequestParam String aptCmplexNo, Model model) {
        log.info("aptMain() 실행 \n아파트 코드 : {}} ", aptCmplexNo);

        AptMainDTO aptMainDTO = aptComplexService.selectAptMainDTO(aptCmplexNo);


		/*
		if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
			log.info("apt-main 비로그인 접근");

			// JSP에서 office가 null일 때 기본 문구 처리하도록 넘김
			model.addAttribute("office", null);
			return "apt-main";
		}

		String userId = authentication.getName();
		MgmtOfficeVO office = mgmtOfficeService.selectMgmtOfficeByManagerUserNo(userId);
		model.addAttribute("office", office);
		*/

        return "apt-main";
    }
}
