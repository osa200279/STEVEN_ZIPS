package kr.or.ddit.domain.member.controller;

import kr.or.ddit.common.enums.ServiceResult;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

    // 회원가입 폼
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

    // 아이디 중복 체크 컨트롤러
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

    // 마이페이지 컨트롤러
    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/myPage.do")
    public String myPage(@AuthenticationPrincipal CustomUser customUser,
                         Model model) {
        log.info("myPage() 실행");
        // 인증 객체에서 멤버 정보 가져오기
        MemberVO member = customUser.getMember();
        String profFileId = member.getProfFileId();

        if(profFileId != null && !profFileId.isBlank()){
            // 파일 데이터 세팅
            AttachFileVO file = attachFileService.setOnlyOneFileMetaData(profFileId);

            if(file != null){
                model.addAttribute("file", file);   // 파일 정보 전체
            }
        }
        model.addAttribute("member", member);

        return "member/mypage";
    }

    /**
     * 회원정보 수정 컨트롤러
     * @author 박진아
     * @param member
     * @param profileImagedlrj
     * @param customUser
     * @return
     */
    @PreAuthorize("hasAnyRole('MEMBER', 'RESIDENT')")
    @PostMapping("/updateSimple")
    public String updateMember(MemberVO member,
                               @RequestParam(value="profileImage", required=false) MultipartFile profileImage,
                               @AuthenticationPrincipal CustomUser customUser,
                               RedirectAttributes ra) {

        if (customUser != null && customUser.getMember() != null) {
            String userNo = customUser.getMember().getUserNo();
            member.setUserNo(userNo.trim());
        }


        if(member.getUserPw() == null || member.getUserPw().isEmpty()){
            member.setUserPw(null);  // 🔥 그냥 null 넘겨
        }

        ServiceResult result = service.updateMember(member);

        if (result == ServiceResult.OK) {
            MemberVO updated = service.getMemberByUserNo(member.getUserNo());
            customUser.setMember(updated);
            ra.addFlashAttribute("msg", "success");
        } else {
            log.error("❌ 회원 수정 실패");
        }

        // 🔥 무조건 마이페이지로 보냄
        return "redirect:/member/myPage.do";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @PostMapping("/alarm/update")
    @ResponseBody
    public String updateAlarm(
            @RequestBody Map<String, Object> param,
            @AuthenticationPrincipal CustomUser customUser) {

        if (customUser != null && customUser.getMember() != null) {
            String userNo = customUser.getMember().getUserNo();
            param.put("userNo", userNo);
        }

        // 🔥 부모 OFF면 자식 강제 OFF
        if ("N".equals(param.get("emlRcvYn"))) {
            param.put("emlNtcRcvYn", "N");
            param.put("emlCtrtRcvYn", "N");
        }

        if ("N".equals(param.get("smsRcvYn"))) {
            param.put("smsNtcRcvYn", "N");
            param.put("smsCtrtRcvYn", "N");
        }

        service.updateAlarm(param);

        return "OK";
    }
}
