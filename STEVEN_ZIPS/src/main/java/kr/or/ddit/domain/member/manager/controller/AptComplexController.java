package kr.or.ddit.domain.member.manager.controller;

import kr.or.ddit.domain.apt.vo.AptComplexVO;
import kr.or.ddit.domain.member.manager.servcie.IAptComplexService;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager")
public class AptComplexController {

    @Autowired
    private IAptComplexService aptComplexService;

    // 단지 정보 화면
    @GetMapping("/complex/edit")
    public String complexEdit(Authentication authentication, Model model) {

//        log.info("단지정보수정 요청 aptCmplexNo");
//        AptComplexVO aptComplexVO = aptComplexService.selectAptComplex(aptCmplexNo);
////        List<AptDetailVO> detailList = (List<AptDetailVO>) aptComplexService.selectAptDetailList(aptCmplexNo);
//
//        model.addAttribute("complex", aptComplexVO);
////        model.addAttribute("detailList", detailList);
//
//        return "manager/mngr_complex_edit";

        CustomUser customUser = (CustomUser) authentication.getPrincipal();

        MemberVO member = customUser.getMember();

        String userNo = member.getUserNo();

        log.info("로그인 사용자 번호 = {}", userNo);

        String aptCmplexNo = aptComplexService.selectManagerAptCmplexNo(userNo);

        log.info("관리소장 소속 단지번호 = {}", aptCmplexNo);

        if (aptCmplexNo == null || aptCmplexNo.trim().isEmpty()) {
            model.addAttribute("message", "해당 계정에 연결된 단지 정보가 없습니다.");
            return "manager/mngr_complex_error";
        }

        AptComplexVO aptComplexVO = aptComplexService.selectAptComplex(aptCmplexNo);

        model.addAttribute("complex", aptComplexVO);

        return "manager/mngr_complex_edit";
    }

    // 단지 정보 수정

    @PostMapping("/complex/update")
    @ResponseBody
    public Map<String, Object> updateComplex(
            AptComplexVO aptComplexVO,
            @RequestParam(value = "mainImgFile", required = false) MultipartFile mainImgFile,
            @RequestParam(value = "complexImgFiles", required = false) List<MultipartFile> complexImgFiles,
            Authentication authentication
    ) {
        Map<String, Object> result = new HashMap<>();

        try {
            String userNo = authentication.getName();

            String aptCmplexNo = aptComplexService.selectManagerAptCmplexNo(userNo);

            if (aptCmplexNo == null || aptCmplexNo.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "로그인 계정에 연결된 단지 정보가 없습니다.");
                return result;
            }

            // 클라이언트 hidden 값을 믿지 않고 서버에서 강제 세팅
            aptComplexVO.setAptCmplexNo(aptCmplexNo);

            int updateCnt = aptComplexService.updateAptComplex(aptComplexVO);

            if (updateCnt > 0) {
                result.put("success", true);
                result.put("message", "단지 정보가 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "수정된 데이터가 없습니다.");
            }

        } catch (Exception e) {
            log.error("단지 정보 수정 중 오류", e);

            result.put("success", false);
            result.put("message", "단지 정보 수정 중 오류가 발생했습니다.");
        }

        return result;
    }
}
