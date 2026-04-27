package kr.or.ddit.domain.ztest;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.domain.member.service.IMemberService;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;
@Slf4j
@Controller
@RequestMapping("/member")
public class MyPageController {

    @Autowired
    private IMemberService service;

    @GetMapping("/mypage.do")
    public String mypage(@AuthenticationPrincipal CustomUser customUser, Model model) {

        MemberVO member = new MemberVO();

        if (customUser != null && customUser.getMember() != null) {
            member = customUser.getMember();
        }
        String role = "ROLE_USER";

        if (customUser != null) {
            if (customUser.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
                role = "ROLE_ADMIN";
            } else if (customUser.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equals("ROLE_RESIDENT"))) {
                role = "ROLE_RESIDENT";
            }
        }
        model.addAttribute("member", member);
        model.addAttribute("role", role);
        model.addAttribute("activeMember", member.getUserYn() == 'Y');
        model.addAttribute("smsRcv", member.getSmsRcvYn() == 'Y');
        model.addAttribute("smsNtcRcv", member.getSmsNtcRcvYn() == 'Y');
        model.addAttribute("smsCtrtRcv", member.getSmsCtrtRcvYn() == 'Y');
        model.addAttribute("emlRcv", member.getEmlRcvYn() == 'Y');
        model.addAttribute("emlNtcRcv", member.getEmlNtcRcvYn() == 'Y');
        model.addAttribute("emlCtrtRcv", member.getEmlCtrtRcvYn() == 'Y');

        return "ztestview/mypage";
    }

    @PostMapping("/updateSimple")
    public String updateMember(MemberVO member,
                               @RequestParam(value="profileImage", required=false) MultipartFile profileImage,
                               @AuthenticationPrincipal CustomUser customUser) {

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
        } else {
            log.error("❌ 회원 수정 실패");
        }

        // 🔥 무조건 마이페이지로 보냄
        return "redirect:/member/mypage.do";
    }

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