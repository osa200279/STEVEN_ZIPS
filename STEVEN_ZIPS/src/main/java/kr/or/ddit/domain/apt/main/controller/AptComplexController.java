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

/*    @GetMapping
    @ResponseBody
    public List<AptComplexVO> selectComplexList(
            @PathVariable String mgmtOfcNo
    ) {

        return *//*aptComplexService.selectComplexList(mgmtOfcNo)*//*;
    }*/

}