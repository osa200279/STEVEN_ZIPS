package kr.or.ddit.domain.apt.apiApartment.controller;

import kr.or.ddit.domain.apt.apiApartment.service.IAptApiService;
import kr.or.ddit.domain.apt.apiApartment.service.IAptMemberApiService;
import kr.or.ddit.domain.apt.apiApartment.vo.AptBass;
import kr.or.ddit.domain.apt.apiApartment.vo.AptComplexEntity;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/api")
@Slf4j
public class AptApiController {

    @Autowired
    private IAptApiService aptService;

    @Autowired
    private IAptMemberApiService aptMemberService;



    @PostMapping("/apt/collect")
    @ResponseBody
    public String collectApt(@RequestBody Map<String, String> param) {

        String sido = param.get("sido");
        String sigungu = param.get("sigungu");
        String emd = param.get("emd");

        aptService.collectApt(sido, sigungu, emd);

        return "OK";
    }

    @GetMapping("/sido")
    @ResponseBody
    public List<String> getSido() {
        return aptMemberService.getSidoList();
    }

    @GetMapping("/sigungu")
    @ResponseBody
    public List<String> getSigungu(@RequestParam String sido) {
        return aptMemberService.getSigunguList(sido);
    }

    @GetMapping("/emd")
    @ResponseBody
    public List<String> getEmd(@RequestParam String sido,
                               @RequestParam String sigungu) {
        return aptMemberService.getEmdList(sido, sigungu);
    }

    @GetMapping("/aptList")
    @ResponseBody
    public List<AptComplexEntity> getAptList(
            @RequestParam(required = false) String sido,
            @RequestParam(required = false) String sigungu,
            @RequestParam(required = false) String emd) {

        return aptMemberService.getAptList(sido, sigungu, emd);
    }

    @PostMapping("/user/createDummy")
    @ResponseBody
    public String createDummyUser(@RequestBody Map<String, Object> param) {

        int count = Integer.parseInt(param.get("count").toString());

        aptMemberService.createDummyUsers(count);

        return count + "명 생성 완료";
    }

    @GetMapping("/user/notAssignedCount")
    @ResponseBody
    public int getNotAssignedCount() {
        return aptMemberService.getNotAssignedUserCount();
    }


    @PostMapping("/updateLatLng.do")
    @ResponseBody
    public String updateLatLng() {

        aptService.updateLatLng();

        return "좌표 업데이트 완료";
    }

    @PostMapping("/apt/assignResidents")
    @ResponseBody
    public String assignResidents(@RequestBody Map<String, Object> param) {

        List<String> aptList = (List<String>) param.get("aptList");
        int count = Integer.parseInt(param.get("count").toString());

        aptService.assignResidents(aptList, count);

        return count + "명 입주 완료";
    }

    @PostMapping("/apt/checkBaseInfo")
    @ResponseBody
    public List<AptBass> checkBaseInfo(@RequestBody Map<String, String> param){

        log.info("search Start");

        String sido = param.get("sido");
        String sigungu = param.get("sigungu");
        String emd = param.get("emd");

        return aptService.checkBaseInfo(sido, sigungu, emd);
    }

}
