package kr.or.ddit.domain.member.controller;

import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.service.IMemberService;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/member")
public class MemberController {

    @Autowired
    private IMemberService service;

    @Autowired
    private IAttachFileService attachFileService;

    @GetMapping("/join.do")
    public String joinPage() {
        return "member/join";
    }

    // 비동기 회원가입 처리
    @ResponseBody
    @PostMapping(value = "/join")
    public ResponseEntity<Map<String, String>> joinMember(
            MemberVO member, @RequestParam(value = "profFile", required = false) MultipartFile profFile) {

        log.info("joinMember() 실행");
        log.info("입력된 회원 정보 : {}", member);

        Map<String, String> resp = new HashMap<>();

        try {
            ServiceResult result = service.joinMember(member, profFile);

            if (ServiceResult.OK.equals(result)) {
                resp.put("message", "회원가입 완료!");
                return new ResponseEntity<>(resp, HttpStatus.OK);
            } else {
                resp.put("message", "가입 실패!");
                return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            resp.put("message", "서버에러");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @ResponseBody
    @GetMapping("/idCheck")
    public ResponseEntity<Map<String, String>> idCheck(@RequestParam String userId) {
        log.info("idCheck() 실행");
        Map<String, String> resp = new HashMap<>();

        try {
            ServiceResult result = service.idCheck(userId);

            if (ServiceResult.EXIST.equals(result)) {
                resp.put("res", "EXIST");
                resp.put("message", "이미 사용 중인 아이디입니다!");
            } else {
                resp.put("res", "NOTEXIST");
                resp.put("message", "사용 가능한 아이디입니다!");
            }
            return new ResponseEntity<>(resp, HttpStatus.OK);
        } catch (Exception e) {
            resp.put("message", "서버 에러로 인해 중복확인에 실패하였습니다.");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
