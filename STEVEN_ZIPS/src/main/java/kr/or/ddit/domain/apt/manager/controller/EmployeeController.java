package kr.or.ddit.domain.apt.manager.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.or.ddit.domain.apt.manager.service.IEmployeeService;
import kr.or.ddit.domain.apt.manager.vo.ManagerVO;
import kr.or.ddit.domain.apt.manager.vo.MngrRqstVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@PreAuthorize("hasAnyRole('ROLE_MANAGER', 'ROLE_ADMIN')")
@RequestMapping("/manager/employee")
public class EmployeeController {

    @Autowired
    private IEmployeeService employeeService;

    // 직원 계정 관리 화면
    @GetMapping("/account")
    public String accountPage() {
        return "manager/employee/mngr_account";
    }

    // 로그인 소장 정보 조회
    @GetMapping("/info")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getLoginInfo(
            @AuthenticationPrincipal CustomUser customUser) {
        Map<String, Object> result = new HashMap<>();
        try {
            String userNo = customUser.getMember().getUserNo();
            ManagerVO loginInfo = employeeService.getLoginManagerInfo(userNo);
            result.put("loginInfo", loginInfo);
        } catch (Exception e) {
            log.error("소장 정보 조회 오류", e);
            result.put("loginInfo", null);
        }
        return ResponseEntity.ok(result);
    }

    // 재직 직원 목록 조회
    @GetMapping("/manager/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getManagerList(
            @AuthenticationPrincipal CustomUser customUser) {
        Map<String, Object> result = new HashMap<>();
        try {
            String userNo = customUser.getMember().getUserNo();
            ManagerVO loginInfo = employeeService.getLoginManagerInfo(userNo);
            List<ManagerVO> list = employeeService.getManagerList(loginInfo.getMgmtOfcNo());
            result.put("list", list);
        } catch (Exception e) {
            log.error("직원 목록 조회 오류", e);
            result.put("list", new ArrayList<>());
        }
        return ResponseEntity.ok(result);
    }

    // 요청 목록 조회
    @GetMapping("/request/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getRequestList(
            @AuthenticationPrincipal CustomUser customUser) {
        Map<String, Object> result = new HashMap<>();
        try {
            String userNo = customUser.getMember().getUserNo();
            ManagerVO loginInfo = employeeService.getLoginManagerInfo(userNo);
            List<MngrRqstVO> list = employeeService.getRequestList(loginInfo.getMgmtOfcNo());
            result.put("list", list);
        } catch (Exception e) {
            log.error("요청 목록 조회 오류", e);
            result.put("list", new ArrayList<>());
        }
        return ResponseEntity.ok(result);
    }

    // 재직 직원 직무 수정
    @PostMapping("/manager/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateManager(@RequestBody ManagerVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = employeeService.updateManagerDuty(vo);
            result.put("success", success);
            result.put("message", success ? "수정되었습니다." : "수정에 실패했습니다.");
        } catch (Exception e) {
            log.error("직원 수정 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }

    // 요청 등록
    @PostMapping("/request/insert")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> insertRequest(
            @RequestBody MngrRqstVO vo,
            @AuthenticationPrincipal CustomUser customUser) {

        vo.setUserNo(customUser.getMember().getUserNo());

        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = employeeService.insertRequest(vo);
            result.put("success", success);
            result.put("message", success ? "요청이 등록되었습니다." : "등록에 실패했습니다.");
        } catch (Exception e) {
            log.error("요청 등록 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }

    // 요청 수정
    @PostMapping("/request/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateRequest(@RequestBody MngrRqstVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = employeeService.updateRequest(vo);
            result.put("success", success);
            result.put("message", success ? "수정되었습니다." : "수정에 실패했습니다.");
        } catch (Exception e) {
            log.error("요청 수정 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }

    // 요청 취소
    @PostMapping("/request/cancel")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cancelRequest(@RequestBody MngrRqstVO vo) {
        Map<String, Object> result = new HashMap<>();
        try {
            boolean success = employeeService.cancelRequest(vo);
            result.put("success", success);
            result.put("message", success ? "취소되었습니다." : "취소에 실패했습니다.");
        } catch (Exception e) {
            log.error("요청 취소 오류", e);
            result.put("success", false);
            result.put("message", "처리 중 오류가 발생했습니다.");
        }
        return ResponseEntity.ok(result);
    }

    /*// 회원 검색 (팝업용)
    @GetMapping("/member/search")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchMember(@RequestParam(required = false, defaultValue = "") String keyword) {
        Map<String, Object> result = new HashMap<>();
        try {
            List<MemberSearchVO> list = employeeService.searchMember(keyword);
            result.put("list", list);
        } catch (Exception e) {
            log.error("회원 검색 오류", e);
            result.put("list", new ArrayList<>());
        }
        return ResponseEntity.ok(result);
    }*/
}