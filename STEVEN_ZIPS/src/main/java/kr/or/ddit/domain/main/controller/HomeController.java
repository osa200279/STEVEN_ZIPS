package kr.or.ddit.domain.main.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.mgmtOffice.service.IMgmtOfficeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
public class HomeController {

	@Autowired
	private IMgmtOfficeService mgmtOfficeService;

	@Autowired
	private IAptComplexService aptComplexService;

	@GetMapping("/")
	public String main() {
		return "main";
	}

	// 접근 거부 핸들러에서 오는 컨트롤러
	@GetMapping("/accessError")
	public String accessError(
			@RequestParam(required = false) String msg,
			@RequestParam(required = false) String prevPage ,Model model) {

		model.addAttribute("msg", msg);
		model.addAttribute("prevPage", prevPage);

		return "accessError";
	}

	@GetMapping("/error")
	public String error(
			@RequestParam(required = false) String msg,
			@RequestParam(required = false) String prevPage ,Model model) {

		model.addAttribute("msg", msg);
		model.addAttribute("prevPage", prevPage);

		return "accessError";
	}
}
