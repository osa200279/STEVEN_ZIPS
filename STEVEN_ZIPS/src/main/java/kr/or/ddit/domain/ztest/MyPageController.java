package kr.or.ddit.domain.ztest;

import jakarta.servlet.http.HttpSession;
import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.service.IAttachFileService;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.member.service.IMemberService;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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

    @Autowired
    private IAttachFileService attachFileService;

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
            AttachFileVO file = attachFileService.setFileMetaData(profFileId);

            if(file != null){
                model.addAttribute("file", file);   // 파일 정보 전체
            }
        }
        model.addAttribute("member", member);

        return "member/mypage";
    }

    // 회원정보 수정
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