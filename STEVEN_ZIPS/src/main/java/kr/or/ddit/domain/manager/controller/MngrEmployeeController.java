package kr.or.ddit.domain.manager.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.or.ddit.domain.manager.service.IMngrEmployeeService;
import kr.or.ddit.domain.manager.vo.ManagerVO;
import kr.or.ddit.domain.manager.vo.MngrRqstVO;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Slf4j
@Controller
@RequestMapping("/manager/employee")
public class MngrEmployeeController {

    @Autowired
    private IMngrEmployeeService service;

    @GetMapping("/account")
    public String mngrAccount(Model model) {
        List<ManagerVO> managerList = service.selectManagerList();
        List<MngrRqstVO> requestList = service.selectRequestList();

        log.info("managerList size : {}", managerList.size());
        log.info("requestList size : {}", requestList.size());

        model.addAttribute("managerList", managerList);
        model.addAttribute("requestList", requestList);

        return "manager/employee/mngr_account";
    }

    @ResponseBody
    @GetMapping("/manager/list")
    public List<ManagerVO> selectManagerList() {
        return service.selectManagerList();
    }

    @ResponseBody
    @GetMapping("/request/list")
    public List<MngrRqstVO> selectRequestList() {
        return service.selectRequestList();
    }

    @ResponseBody
    @GetMapping("/manager/{userNo}")
    public ManagerVO selectManagerDetail(@PathVariable String userNo) {
        return service.selectManagerDetail(userNo);
    }

    @ResponseBody
    @GetMapping("/request/{rqstNo}")
    public MngrRqstVO selectRequestDetail(@PathVariable String rqstNo) {
        return service.selectRequestDetail(rqstNo);
    }

    @ResponseBody
    @PostMapping("/request/insert")
    public Map<String, Object> insertRequest(@RequestBody MngrRqstVO mngrRqstVO) {
        int result = service.insertRequest(mngrRqstVO);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("success", result > 0);
        resultMap.put("message", result > 0 ? "계정 생성 요청을 등록했습니다." : "계정 생성 요청 등록에 실패했습니다.");
        return resultMap;
    }

    @ResponseBody
    @PostMapping("/request/update")
    public Map<String, Object> updateRequest(@RequestBody MngrRqstVO mngrRqstVO) {
        int result = service.updateRequest(mngrRqstVO);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("success", result > 0);
        resultMap.put("message", result > 0 ? "계정 생성 요청을 수정했습니다." : "계정 생성 요청 수정에 실패했습니다.");
        return resultMap;
    }

    @ResponseBody
    @PostMapping("/request/cancel")
    public Map<String, Object> cancelRequest(@RequestBody MngrRqstVO mngrRqstVO) {
        int result = service.cancelRequest(mngrRqstVO);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("success", result > 0);
        resultMap.put("message", result > 0 ? "계정 생성 요청을 취소했습니다." : "계정 생성 요청 취소에 실패했습니다.");
        return resultMap;
    }

    @ResponseBody
    @PostMapping("/manager/update")
    public Map<String, Object> updateManager(@RequestBody ManagerVO managerVO) {
        int result = service.updateManager(managerVO);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("success", result > 0);
        resultMap.put("message", result > 0 ? "직원 정보를 수정했습니다." : "직원 정보 수정에 실패했습니다.");
        return resultMap;
    }

    @ResponseBody
    @PostMapping("/manager/deactivate")
    public Map<String, Object> deactivateManager(@RequestBody ManagerVO managerVO) {
        int result = service.deactivateManager(managerVO);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("success", result > 0);
        resultMap.put("message", result > 0 ? "직원 계정을 비활성화했습니다." : "직원 계정 비활성화에 실패했습니다.");
        return resultMap;
    }
}
