package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.member.resident.service.IResidentVhclService;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/vhcl")
public class ResidentVhclController {

    @Autowired
    private IResidentVhclService residentVhclService;

    /**
     * 내 차량 조회
     */
    @GetMapping("/myVhcl/{aptCmplexNo}")
    @PreAuthorize("@authService.hasAptAccess(principal, #aptCmplexNo)")
    @ResponseBody
    public List<RsidVhclVO> selectMyVhclList(
            @PathVariable String aptCmplexNo,
            @AuthenticationPrincipal CustomUser principal
    ) {

        String userNo = principal.getMember().getUserNo();
        return residentVhclService.selectMyVhclList(userNo, aptCmplexNo);
    }



    @PostMapping("/check/{aptCmplexNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAptAccess(principal, #aptCmplexNo)")
    public String checkVhcl(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            @RequestParam String dong,
            @RequestParam String ho
    ) {

        String userNo = principal.getMember().getUserNo();

        String hoNo = aptCmplexNo + "_" + dong + "_" + ho;

        boolean isExtra = residentVhclService.isExtraRequired(userNo, aptCmplexNo, hoNo);

        return isExtra ? "EXTRA_REQUIRED" : "OK";
    }


    @PostMapping("/register/{aptCmplexNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAptAccess(principal, #aptCmplexNo)")
    public String registerVhcl(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            @RequestParam String vhclNm,
            @RequestParam String vhclNo,
            @RequestParam String dong,
            @RequestParam String ho,
            @RequestParam boolean isExtra,
            @RequestPart(required = false) MultipartFile file
    ) throws IOException {

        String userNo = principal.getMember().getUserNo();

        residentVhclService.registerVhcl(
                userNo, aptCmplexNo, vhclNm, vhclNo,
                dong, ho, isExtra, file
        );

        return "OK";
    }

}