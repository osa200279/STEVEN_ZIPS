package kr.or.ddit.domain.central.admin.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

/*  전체 중앙관리자 콘트롤러 */

@Controller
@RequiredArgsConstructor
@RequestMapping("/centralAdmin")
public class CentralController {

    @GetMapping("/dashboard")
    public String dashboardForm() {
        return "centralAdmin/dashboard";
    }

    @GetMapping("/buildSearch")
    public String buildSearchForm() {
        return "centralAdmin/buildSearch";
    }

    @GetMapping("/buildRegister")
    public String buildRegisterForm() {
        return "centralAdmin/buildRegister";
    }

    @GetMapping("/residentList")
    public String residentListForm() {
        return "centralAdmin/residentList";
    }

    @GetMapping("/statistics")
    public String statisticsForm() {
        return "centralAdmin/statistics";
    }

    @GetMapping("/conManagement")
    public String conManagementForm() {
        return "centralAdmin/conManagement";
    }

    // 호환(오타/이전 링크) 경로 방어: /centralAdmin/contractManagement → 계약목록으로 이동
    @GetMapping("/contractManagement")
    public String contractManagementAlias() {
        return "redirect:/centralAdmin/contractList.do";
    }

    @GetMapping("/ai")
    public String aiForm() {
        return "centralAdmin/ai";
    }

    @GetMapping("/civilCom")
    public String civilComForm() {
        return "centralAdmin/civilCom";
    }

    @GetMapping("/notice")
    public String noticeForm() {
        return "centralAdmin/notice";
    }

    @GetMapping("/proHistory")
    public String proHistoryForm() {
        return "centralAdmin/proHistory";
    }

    @GetMapping("/resident")
    public String residentForm() {
        return "centralAdmin/resident";
    }

    @GetMapping("/residentStatus")
    public String residentStatusForm() {
        return "centralAdmin/residentStatus";
    }

    @GetMapping("/facility")
    public String facilityForm() {
        return "centralAdmin/facility";
    }

    /* 중앙관리자 직원계정요청 승인 */
    @GetMapping("/mngrRqstAprv")
    public String mngrRqstAprvForm() {
        return "centralAdmin/mngrRqstAprv";
    }

    @GetMapping("/contractForm.do")
    public String contractForm() {
        return "redirect:/centralAdmin/contractFormList.do";
    }

    @GetMapping("/contractDoc.do")
    public String contractDocForm(){
        return "centralAdmin/contractDoc";
    }
}
