package kr.or.ddit.domain.apt.mgmtOffice.main.controller;

import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.main.vo.AptDetailGridDTO;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtAptHoTyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/manager/compolexEdit")
@PreAuthorize("hasRole('MNGR')")
public class MgmtAptComplexEditController {

    @Autowired
    private IAptComplexService aptComplexService;

    @GetMapping("/hoList/{mgmtOfcNo}")
    @ResponseBody
    public List<AptDetailGridDTO> selectComplexList(
            @PathVariable String mgmtOfcNo
    ) {

        return aptComplexService.selectComplexList(mgmtOfcNo);
    }

}
