package kr.or.ddit.domain.apt.mgmtOffice.employee.controller;

import kr.or.ddit.domain.apt.mgmtOffice.employee.service.IOfficeVhclService;
import kr.or.ddit.domain.member.manager.vo.ManagerVO;
import kr.or.ddit.domain.member.manager.vo.MngrVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager/resident/auto")
@RequiredArgsConstructor
public class OfficeVhclController {

    private final IOfficeVhclService officeVhclService;

    @PreAuthorize("hasRole('MNGR') and @authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping({"/management/{mgmtOfcNo}", "/list/{mgmtOfcNo}"})
    public String vehicleList(
            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser user,
            Model model) {

        MngrVO mngrVO = (MngrVO) user.getMember();

        String aptCmplexNo = mngrVO.getAptCmplexNo();

        List<RsidVhclVO> vehicleList =
                officeVhclService.getVehicleList(aptCmplexNo);

        List<RsidVhclVO> waitList = vehicleList.stream()
                .filter(v -> "WAIT".equals(v.getVhclSttsCd()))
                .toList();

        model.addAttribute("waitList", waitList);
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("vehicleList", vehicleList);
        model.addAttribute("totalCnt", vehicleList.size());
        model.addAttribute("aprvCnt", vehicleList.stream()
                .filter(vehicle -> "APRV".equals(vehicle.getVhclSttsCd()))
                .count());
        model.addAttribute("waitCnt", vehicleList.stream()
                .filter(vehicle -> "WAIT".equals(vehicle.getVhclSttsCd()))
                .count());

        model.addAttribute("rjctCnt", vehicleList.stream()
                .filter(vehicle -> "RJCT".equals(vehicle.getVhclSttsCd()))
                .count());

        return "apt/mgmtOffice/resident/vehicle_list";
    }

    @PreAuthorize("hasRole('MNGR')")
    @GetMapping("/register/{mgmtOfcNo}")
    public String registerPage(  @PathVariable("mgmtOfcNo") String mgmtOfcNo,
                                 Model model) {
        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        return "apt/mgmtOffice/resident/vehicle_register";
    }

    @PreAuthorize("hasRole('MNGR')")
    @PostMapping("/register")
    public String registerVehicle(
        @AuthenticationPrincipal CustomUser user,
            @RequestParam("userNo") String userNo,
            @RequestParam("hoNo") String hoNo,
            @RequestParam("vhclNo") String vhclNo,
            @RequestParam("vhclNm") String vhclNm,
            @RequestParam("mgmtOfcNo") String mgmtOfcNo,
            @RequestParam(value = "uploadFile", required = false)
            MultipartFile uploadFile

    ) {

        MngrVO mngrVO = (MngrVO) user.getMember();
        String aptCmplexNo = mngrVO.getAptCmplexNo();

        try {

            RsidVhclVO vo = new RsidVhclVO();

            vo.setUserNo(userNo);
            vo.setHoNo(hoNo);
            vo.setVhclNo(vhclNo);
            vo.setVhclNm(vhclNm);

            vo.setVhclSttsCd("WAIT");

            officeVhclService.registerVehicle(vo, uploadFile);

            return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;

        } catch (Exception e) {

            log.error("차량 등록 실패", e);

            return "redirect:/manager/resident/auto/register/" + mgmtOfcNo;
        }
    }

    @PreAuthorize("hasRole('MNGR') and @authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/detail/{mgmtOfcNo}/{rsidVhclNo}")
    public String detailPage(


            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @PathVariable("rsidVhclNo") String rsidVhclNo,
            Model model
    ) {
        RsidVhclVO vehicle = officeVhclService.getVehicle(rsidVhclNo);
        if (vehicle == null) {
            return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;
        }

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("vehicle", vehicle);
        return "apt/mgmtOffice/resident/vehicle_detail";
    }

    @PreAuthorize("hasRole('MNGR')")
    @GetMapping("/update/{mgmtOfcNo}/{rsidVhclNo}")
    public String updatePage(
            @PathVariable("mgmtOfcNo") String mgmtOfcNo,
            @PathVariable("rsidVhclNo") String rsidVhclNo,
            Model model
    ) {
        RsidVhclVO vehicle = officeVhclService.getVehicle(rsidVhclNo);
        if (vehicle == null) {
            return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;
        }

        model.addAttribute("mgmtOfcNo", mgmtOfcNo);
        model.addAttribute("vehicle", vehicle);
        return "apt/mgmtOffice/resident/vehicle_update";
    }

    @PreAuthorize("hasRole('MNGR')")
    @PostMapping("/update")
    public String updateVehicle(

            @RequestParam("rsidVhclNo") String rsidVhclNo,
            @RequestParam("userNo") String userNo,
            @RequestParam("hoNo") String hoNo,
            @RequestParam("vhclNo") String vhclNo,
            @RequestParam("vhclNm") String vhclNm,
            @RequestParam("mgmtOfcNo") String mgmtOfcNo,
            @RequestParam(value = "uploadFile", required = false)
            MultipartFile uploadFile

    ) {

        try {

            RsidVhclVO vo = new RsidVhclVO();

            vo.setRsidVhclNo(rsidVhclNo);
            vo.setUserNo(userNo);
            vo.setHoNo(hoNo);
            vo.setVhclNo(vhclNo);
            vo.setVhclNm(vhclNm);


            officeVhclService.updateVehicle(vo, uploadFile);

            return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;

        } catch (Exception e) {

            log.error("차량 수정 실패", e);

            return "redirect:/manager/resident/auto/update/"
                    + mgmtOfcNo + "/"
                    + rsidVhclNo;
        }
    }

    @PreAuthorize("hasRole('MNGR')")
    @PostMapping("/delete")
    public String deleteVehicle(

            @RequestParam("rsidVhclNo") String rsidVhclNo,
            @RequestParam("mgmtOfcNo") String mgmtOfcNo

    ) {

        try {

            officeVhclService.deleteVehicle(rsidVhclNo);

            return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;

        } catch (Exception e) {

            log.error("차량 삭제 실패", e);

            return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;
        }
    }



    @ResponseBody
    @GetMapping(value="/search", produces="application/json;charset=UTF-8")
    public Map<String, Object> searchResident(

            @AuthenticationPrincipal CustomUser user,

            @RequestParam("mgmtOfcNo") String mgmtOfcNo,
            @RequestParam("dongNo") String dongNo,
            @RequestParam("hoNo") String hoNo,
            @RequestParam("residentName") String residentName

    ){

        Map<String,Object> param = new HashMap<>();

        String parsedDongNo = dongNo.replace("0", "");

        MngrVO mngrVO = (MngrVO) user.getMember();

        String aptCmplexNo = mngrVO.getAptCmplexNo();

        String fullHoNo =
                aptCmplexNo + "_"
                        + parsedDongNo + "_"
                        + hoNo;

        param.put("hoNo", fullHoNo);
        param.put("residentName", residentName);

        Map<String,Object> result =
                officeVhclService.searchResident(param);

        System.out.println("조회 결과 = " + result);

        return result;
    }
    @PreAuthorize("hasRole('MNGR')")
    @PostMapping("/approve")
    public String approveVehicle(

            @RequestParam("rsidVhclNo") String rsidVhclNo,
            @RequestParam("mgmtOfcNo") String mgmtOfcNo

    ){

        officeVhclService.updateVehicleStatus(
                rsidVhclNo,
                "APRV"
        );

        return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;
    }

    @PreAuthorize("hasRole('MNGR')")
    @PostMapping("/reject")
    public String rejectVehicle(

            @RequestParam("rsidVhclNo") String rsidVhclNo,
            @RequestParam("mgmtOfcNo") String mgmtOfcNo

    ){

        officeVhclService.updateVehicleStatus(
                rsidVhclNo,
                "RJCT"
        );

        return "redirect:/manager/resident/auto/list/" + mgmtOfcNo;
    }


}
