package kr.or.ddit.domain.central.contract.controller;

import kr.or.ddit.domain.central.contract.service.ContractService;
import kr.or.ddit.domain.central.contract.vo.ContractVO;
import kr.or.ddit.domain.central.contract.vo.PaginationInfoVO;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/conManagement")
public class ContractController {

    private final ContractService service;
    
    @GetMapping("/dashboard")
    public String dashboardForm(){
        return "centralAdmin/dashboard";
    }
    @GetMapping("/buildSearch")
    public String buildSearchForm(){
        return "centralAdmin/buildSearch";
    }
    @GetMapping("/buildRegister")
    public String buildRegisterForm(){
        return "centralAdmin/buildRegister";
    }
    @GetMapping("/residentList")
    public String residentListForm(){
        return "centralAdmin/residentList";
    }
    @GetMapping("/statistics")
    public String statisticsForm(){
        return "centralAdmin/statistics";
    }
    @GetMapping("/conManagement")
    public String conManagementForm(){
        return "centralAdmin/conManagement";
    }
    @GetMapping("/ai")
    public String aiForm(){
        return "centralAdmin/ai";
    }
    @GetMapping("/civilCom")
    public String civilComForm(){
        return "centralAdmin/civilCom";
    }
    @GetMapping("/announcement")
    public String announcementForm(){
        return "centralAdmin/announcement";
    }
    @GetMapping("/notice")
    public String noticeForm(){
        return "centralAdmin/notice";
    }
    @GetMapping("/proHistory")
    public String proHistoryForm(){
        return "centralAdmin/proHistory";
    }
    @GetMapping("/resident")
    public String residentForm(){
        return "centralAdmin/resident";
    }
    @GetMapping("/residentStatus")
    public String residentStatusForm(){
        return "centralAdmin/residentStatus";
    }


    @GetMapping("/facility")
    public String facilityForm(){
        return "centralAdmin/facility";
    }

    @GetMapping("/subAdmin")
    public String subAdminForm(){
        return "centralAdmin/subAdmin";
    }


    @GetMapping("/contractList.do")
    public String contractList(
            @RequestParam(name="page", required = false, defaultValue = "1") int currentPage,
            @RequestParam(name="type", required = false) String type,
            @RequestParam(name="user", required = false) String user,
            @RequestParam(name="status", required = false) String status,
            Model model
    ) {
        PaginationInfoVO<ContractVO> pagingVO = new PaginationInfoVO<>();

        // 검색 시 추가
        if(StringUtils.isNotBlank(type)) {
            pagingVO.setType(type);
            model.addAttribute("type", type);
        }
        if(StringUtils.isNotBlank(status)) {
            pagingVO.setStatus(status);
            model.addAttribute("status", status);
        }
        if(StringUtils.isNotBlank(user)) {
            pagingVO.setUser(user);
            model.addAttribute("user", user);
        }

        // start/endRow, start/endPage 필드 설정
        pagingVO.setCurrentPage(currentPage);
        int totalRecord = service.selectContractCount(pagingVO);
        // totalPage 설정
        pagingVO.setTotalRecord(totalRecord);
        // 1page에 해당하는 screenSize(10개) 만큼의 게시글 목록을 가져옵니다.
        List<ContractVO> dataList = service.selectContractList(pagingVO);
        System.out.println("[contractList] totalRecord = " + totalRecord);
        System.out.println("[contractList] dataList.size=" + (dataList == null ? "null" : dataList.size()));
        if (dataList != null && !dataList.isEmpty()){
            System.out.println("[contractList] first.rentCtrtNo=" + dataList.get(0).getRentCtrtNo());
        }
        pagingVO.setDataList(dataList);

        model.addAttribute("pagingVO", pagingVO);

        return "centralAdmin/conManagement";
    }


}
