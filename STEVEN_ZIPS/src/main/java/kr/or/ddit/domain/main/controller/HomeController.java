package kr.or.ddit.domain.main.controller;

import kr.or.ddit.domain.apt.manager.service.IMgmtOfficeService;
import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Slf4j
@Controller
public class HomeController {

	@Autowired
	private IMgmtOfficeService mgmtOfficeService;

	@GetMapping("/")
	public String main() {
		return "main";
	}

	@GetMapping("/apt-main")
	public String aptMain(Authentication authentication, Model model) {

		if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
			log.info("apt-main 비로그인 접근");

			// JSP에서 office가 null일 때 기본 문구 처리하도록 넘김
			model.addAttribute("office", null);

			return "apt-main";
		}

		String userId = authentication.getName();
		MgmtOfficeVO office = mgmtOfficeService.selectMgmtOfficeByManagerUserNo(userId);
		model.addAttribute("office", office);
		return "apt-main";
	}

}
