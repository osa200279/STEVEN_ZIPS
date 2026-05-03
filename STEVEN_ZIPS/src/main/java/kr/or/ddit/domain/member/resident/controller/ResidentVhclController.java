package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.member.resident.service.IResidentMainService;
import kr.or.ddit.domain.member.resident.service.IResidentVhclService;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.resident.vo.RsidVhclVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/vhcl")
public class ResidentVhclController {

    @Autowired
    private IResidentVhclService residentService;



    /**
     * 로그인한 유저 기준으로 등록된 차량을 가져오는 메서드
     * 로그인한 유저의 호수와 파라메타에 입력된 아파트단지번호와 동일한 차량만 가져온다.
     *
     * @param principal 로그인 사용자 정보(스프링시큐리티)
     * @param aptCmplexNo 아파트 단지번호
     * @return 사용자가 등록한 차량 LIST
     */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/myVhcl/{aptCmplexNo}")
    @ResponseBody
    public List<RsidVhclVO> selectMyVhclList(@PathVariable String aptCmplexNo, @AuthenticationPrincipal CustomUser principal) {

        String userNo = principal.getMember().getUserNo();

        return residentService.selectMyVhclList(userNo, aptCmplexNo);
    }

    @PreAuthorize("hasRole('RESIDENT')")
    @PostMapping("/register/{aptCmplexNo}")
    @ResponseBody
    public String register(
            @PathVariable String aptCmplexNo,
            @RequestParam String vhclNm,
            @RequestParam String vhclNo,
            @RequestParam String dong,
            @RequestParam String ho,
            @RequestParam MultipartFile file,
            @AuthenticationPrincipal CustomUser principal
    ) {

        ResidentVO resident = (ResidentVO) principal.getMember();

        boolean isValid = resident.getMyAptList().stream()
                .anyMatch(a ->
                        a.getAptCmplexNo().equals(aptCmplexNo) &&
                                a.getDongNm().equals(dong) &&
                                a.getHo().equals(ho)
                );

        if (!isValid) {
            throw new RuntimeException("동/호 정보 불일치");
        }

        String hoNo = aptCmplexNo + "_" + dong + "_" + ho;

        RsidVhclVO vo = new RsidVhclVO();
        vo.setVhclNm(vhclNm);
        vo.setVhclNo(vhclNo);
        vo.setUserNo(resident.getUserNo());
        vo.setHoNo(hoNo);

        residentService.registerVhcl(vo, file);

        return "ok";
    }

    @PostMapping("/requestExtra/{aptCmplexNo}")
    @ResponseBody
    public String requestExtra(
            @PathVariable String aptCmplexNo,
            @RequestParam String vhclNm,
            @RequestParam String vhclNo,
            @RequestParam String dong,
            @RequestParam String ho,
            @RequestParam MultipartFile file,
            @AuthenticationPrincipal CustomUser principal
    ) {

        ResidentVO resident = (ResidentVO) principal.getMember();

        boolean isValid = resident.getMyAptList().stream()
                .anyMatch(a ->
                        a.getAptCmplexNo().equals(aptCmplexNo) &&
                                a.getDongNm().equals(dong) &&
                                a.getHo().equals(ho)
                );

        if (!isValid) {
            throw new RuntimeException("동/호 불일치");
        }

        String hoNo = aptCmplexNo + "_" + dong + "_" + ho;

        RsidVhclVO vo = new RsidVhclVO();
        vo.setVhclNm(vhclNm);
        vo.setVhclNo(vhclNo);
        vo.setUserNo(resident.getUserNo());
        vo.setHoNo(hoNo);

        residentService.requestExtraVhcl(vo, file);

        return "ok";
    }

}