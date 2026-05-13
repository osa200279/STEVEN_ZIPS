package kr.or.ddit.domain.apt.mgmtOffice.main.controller;

import kr.or.ddit.domain.apt.apiApartment.vo.AptHoTyVO;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtAptHoTyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    @PostMapping("/insert")
    @ResponseBody
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    public ResponseEntity<Map<String, Object>> insertHoType(

            @RequestParam String mgmtOfcNo,

            AptHoTyVO aptHoTyVO,

            @RequestParam(required = false)
            MultipartFile imageFile

    ) {

        Map<String, Object> result = new HashMap<>();

        try{

            hoTyService.insertHoType(
                    mgmtOfcNo,
                    aptHoTyVO,
                    imageFile
            );

            result.put("success", true);

        }catch(Exception e){

            e.printStackTrace();

            result.put("success", false);

        }

        return ResponseEntity.ok(result);

    }


}
