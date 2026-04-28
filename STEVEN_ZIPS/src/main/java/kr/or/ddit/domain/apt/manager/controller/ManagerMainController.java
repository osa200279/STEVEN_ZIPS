package kr.or.ddit.domain.apt.manager.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/manager")
public class ManagerMainController {

    @GetMapping("/main")
    public String managerMain(){
        return "manager/office";
    }

    @GetMapping("/vacation")
    public String vacation() {
        return "manager/employee/vacation";
    }

    @GetMapping("/resident/list")
    public String residentList() {
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

    @GetMapping("/visit/auto")
    public String visitAuto() {
        return "manager/mngr_visit_auto";
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

    @GetMapping("/facility/partnerList")
    public String partnerList() {
        return "manager/mngr_partnerList";
    }

    @GetMapping("/bill/charge")
    public String billCharge() {
        return "manager/mngr_billCharge";
    }

    @GetMapping("/bill/issue")
    public String billIssue() {
        return "manager/mngr_billIssue";
    }

    @GetMapping("/bill/item-summary")
    public String billItemSummary() {
        return "manager/mngr_billItemSummary";
    }

    @GetMapping("/account/arrears")
    public String accountArrears() {
        return "manager/mngr_accountArrears";
    }

    @GetMapping("/complex/edit")
    public String complexEdit() {
        return "manager/mngr_complex_edit";
    }
}
