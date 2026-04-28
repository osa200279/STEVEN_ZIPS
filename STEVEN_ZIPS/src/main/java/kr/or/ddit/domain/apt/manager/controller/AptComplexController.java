package kr.or.ddit.domain.apt.manager.controller;

import kr.or.ddit.domain.apt.manager.service.IAptComplexService;
import kr.or.ddit.domain.apt.vo.AptComplexVO;
import kr.or.ddit.domain.apt.vo.AptDetailVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/manager")
public class AptComplexController {

    @Autowired
    private IAptComplexService aptComplexService;

    // 단지 정보 화면
    @GetMapping("/complex/edit")
    public String complexEdit(@RequestParam(value = "aptCmplexNo", required = false) String aptCmplexNo, Model model) {

        log.info("단지정보수정 요청 aptCmplexNo");
        AptComplexVO aptComplexVO = aptComplexService.selectAptComplex(aptCmplexNo);
//        List<AptDetailVO> detailList = (List<AptDetailVO>) aptComplexService.selectAptDetailList(aptCmplexNo);

        model.addAttribute("complex", aptComplexVO);
//        model.addAttribute("detailList", detailList);

        return "manager/mngr_complex_edit";
    }

    // 단지 정보 수정
    @PostMapping("/complex/update")
    @ResponseBody
    public Map<String, Object> updateComplex(
            AptComplexVO aptComplexVO,
            @RequestParam(value = "mainImgFile", required = false) MultipartFile mainImgFile,
            @RequestParam(value = "complexImgFiles", required = false) List<MultipartFile> complexImgFiles
    ) {

        Map<String, Object> result = new HashMap<>();

        try {
            /*
             * 파일 업로드는 아직
             * 나중에 mainImgFile 저장 후 rprsntImgFileNo 세팅,
             * complexImgFiles 저장 후 imgFileNo 세팅하는 흐름으로 확장하면 됨.
             */

            int updateCnt = aptComplexService.updateAptComplex(aptComplexVO);

            if (updateCnt > 0) {
                result.put("success", true);
                result.put("message", "단지 정보가 수정되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "수정된 데이터가 없습니다.");
            }

        } catch (Exception e) {
            e.printStackTrace();

            result.put("success", false);
            result.put("message", "단지 정보 수정 중 오류가 발생했습니다.");
        }

        return result;
    }

}
