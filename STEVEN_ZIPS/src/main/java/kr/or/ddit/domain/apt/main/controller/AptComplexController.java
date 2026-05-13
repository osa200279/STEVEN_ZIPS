package kr.or.ddit.domain.apt.main.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

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
}