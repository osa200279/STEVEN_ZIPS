package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.service.IAnnRegisterService;
import kr.or.ddit.domain.central.service.ICentralAptComplexService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@Slf4j
@RequestMapping("/api/annRegister")
@RequiredArgsConstructor
public class AnnRegisterController {

    private final ICentralAptComplexService centralAptComplexService;

    private final IAnnRegisterService annRegisterService;

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sido")
    public List<String> getSido() {
        return centralAptComplexService.selectSidoList();
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/sigungu")
    public List<String> getSigunguList(
            @RequestParam String sidoNm
    ) {

        return centralAptComplexService.selectSigunguList(sidoNm);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/emd")
    public List<String> getDongList(
            @RequestParam String sidoNm,
            @RequestParam String sigunguNm
    ) {
        return centralAptComplexService.selectDongList(
                sidoNm,
                sigunguNm
        );
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/aptList")
    public List<AptComplexVO> getAptList(
            @RequestParam(required = false) String sidoNm,
            @RequestParam(required = false) String sigunguNm,
            @RequestParam(required = false) String emdNm
    ){
        return annRegisterService.selectAptList(
                sidoNm, sigunguNm, emdNm);
    }




}
