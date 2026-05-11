package kr.or.ddit.domain.apt.mgmtOffice.employee.controller;

import kr.or.ddit.domain.apt.mgmtOffice.employee.service.IOfficeVhclService;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/manager/resident/auto")
@RequiredArgsConstructor
public class OfficeVhclController {

    private final IOfficeVhclService officeVhclService;

    /**
     * 페이지 이동
     */
    @GetMapping
    public String residentAutoPage() {

        return "apt/mgmtOffice/employee/mngr_resident_auto";
    }

    /**
     * 차량 직접 등록
     */
    @PostMapping("/register")
    @ResponseBody
    public ResponseEntity<String> registerVehicle(
            @RequestParam("userNo") String userNo,
            @RequestParam("hoNo") String hoNo,
            @RequestParam("vhclNo") String vhclNo,
            @RequestParam("vhclNm") String vhclNm,
            @RequestParam(value = "uploadFile", required = false)
            MultipartFile uploadFile
    ) {

        try {

            RsidVhclVO vo = new RsidVhclVO();

            vo.setUserNo(userNo);
            vo.setHoNo(hoNo);
            vo.setVhclNo(vhclNo);
            vo.setVhclNm(vhclNm);

            vo.setVhclSttsCd("APRV");


            int result = officeVhclService.registerVehicle(vo, uploadFile);

            if (result > 0) {

                return ResponseEntity.ok("등록 성공");
            }

            return ResponseEntity.badRequest().body("등록 실패");

        } catch (Exception e) {

            log.error("차량 등록 실패", e);

            return ResponseEntity.badRequest().body("등록 실패");
        }
    }
    @GetMapping("/list")
    @ResponseBody
    public List<RsidVhclVO> getVehicleList() {

        return officeVhclService.getVehicleList();
    }

    @PostMapping("/delete")
    @ResponseBody
    public ResponseEntity<String> deleteVehicle(
            @RequestParam("rsidVhclNo") String rsidVhclNo
    ) {

        try {

            int result = officeVhclService.deleteVehicle(rsidVhclNo);

            if (result > 0) {

                return ResponseEntity.ok("삭제 성공");
            }

            return ResponseEntity.badRequest().body("삭제 실패");

        } catch (Exception e) {

            log.error("차량 삭제 실패", e);

            return ResponseEntity.badRequest().body("삭제 실패");
        }
    }




}