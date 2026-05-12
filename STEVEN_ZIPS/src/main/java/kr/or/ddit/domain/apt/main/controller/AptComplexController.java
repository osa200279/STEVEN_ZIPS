package kr.or.ddit.domain.apt.main.controller;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.mgmtOffice.common.service.IManagerModelService;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
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
@RequestMapping("/manager/edit")
@PreAuthorize("hasRole('MNGR')")
public class AptComplexController {

    @Autowired
    private IAptComplexService aptComplexService;

    // 단지 정보 수정
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
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
            CustomUser customUser = (CustomUser) authentication.getPrincipal();
            MemberVO member = customUser.getMember();
            String userNo = member.getUserNo(); // 로그인 사용자 번호

            String aptCmplexNo = aptComplexService.selectManagerAptCmplexNo(userNo);

            if (aptCmplexNo == null || aptCmplexNo.trim().isEmpty()) {
                result.put("success", false);
                result.put("message", "로그인 계정에 연결된 단지 정보가 없습니다.");
                return result;
            }

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
