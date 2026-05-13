package kr.or.ddit.domain.apt.main.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager/complex")
@PreAuthorize("hasRole('MNGR')")
public class AptComplexController {

    @Autowired
    private IAptComplexService aptComplexService;

    @GetMapping("/list/{mgmtOfcNo}")
    @ResponseBody
    public List<AptDetailGridDTO> selectComplexList(
            @PathVariable String mgmtOfcNo
    ) {

        return aptComplexService.selectComplexList(mgmtOfcNo);
    }

    // 단지 정보 수정
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/update/{mgmtOfcNo}")
    @ResponseBody
    public Map<String, Object> updateComplex(
            @PathVariable String mgmtOfcNo,
            AptComplexVO aptComplexVO,
            @RequestParam(value = "mainImgFile", required = false) MultipartFile mainImgFile,
            @RequestParam(value = "complexImgFiles", required = false) List<MultipartFile> complexImgFiles,
            Authentication authentication
    ) {
        Map<String, Object> result = new HashMap<>();

        return result;
    }
}