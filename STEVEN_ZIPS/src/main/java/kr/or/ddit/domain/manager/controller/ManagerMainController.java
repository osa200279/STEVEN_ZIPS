package kr.or.ddit.domain.manager.controller;

import kr.or.ddit.domain.manager.vo.ManagerVO;
import kr.or.ddit.domain.manager.vo.MngrRqstVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;
@Controller
@RequestMapping("/manager")
public class ManagerMainController {

    @GetMapping("/vacation")
    public String vacation(Model model) {
        return "manager/employee/vacation";
    }

    @GetMapping("/resident/list")
    public String residentList(Model model) {
        return "manager/mngr_resident_list";
    }

    @GetMapping("/resident/auth")
    public String residentAuth() {
        return "manager/mngr_resident_auth";
    }


    @GetMapping("/resident/moveList")
    public String moveList() {
        return "manager/mngr_resident_moveList";
    }


    @GetMapping("/resident/auto")
    public String residentAuto() {
        return "manager/mngr_resident_auto";
    }

    @GetMapping("/facilityList")
    public String facilityList() {
        return "manager/mngr_facility_list";
    }

    @GetMapping("/publicFacilityList")
    public String publicFacilityList() {
        return "manager/mngr_public_facility";
    }

    @GetMapping("/meterReading")
    public String meterReading() {
        return "manager/mngr_meterReading";
    }

    @GetMapping("/checkHistory")
    public String checkHistory() {
        return "manager/mngr_facility_history";
    }

    @GetMapping("/facility/workCalendar")
    public String workCalendar() {
        return "manager/mngr_facility_workCalendar";
    }
}
