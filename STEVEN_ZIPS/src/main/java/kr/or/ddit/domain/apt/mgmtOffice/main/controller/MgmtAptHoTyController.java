package kr.or.ddit.domain.apt.mgmtOffice.main.controller;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyVO;
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
@RequestMapping("/manager/ho-type")
@PreAuthorize("hasRole('MNGR')")
public class MgmtAptHoTyController {

    @Autowired
    private IMgmtAptHoTyService hoTyService;


    @GetMapping("/list/{mgmtOfcNo}")
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    public List<AptHoTyVO> selectHoTypeList(@PathVariable String mgmtOfcNo) {


        /*mgmtOfcNo 로 hotyList 가져오기*/
        return hoTyService.selectHoTypeList(mgmtOfcNo);
    }

}
