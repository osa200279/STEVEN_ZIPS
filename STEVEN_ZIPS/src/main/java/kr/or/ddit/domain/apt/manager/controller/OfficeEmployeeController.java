package kr.or.ddit.domain.apt.manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/office/employee")
public class OfficeEmployeeController {

    @GetMapping({"/mngr_account", "/account"})
    public String accountFragment() {
        return "manager/employee/mngr_account";
    }

    @GetMapping("/vacation")
    public String statusFragment() {
        return "manager/employee/vacation";
    }

    @GetMapping("/vacationFragment")
    public String vacationFragment() {
        return "manager/employee/MNGR_VACATION";
    }
}
