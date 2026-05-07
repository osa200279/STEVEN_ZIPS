package kr.or.ddit.domain.apt.complaint.controller;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.domain.apt.complaint.service.ICvplService;
import kr.or.ddit.domain.apt.complaint.vo.CvplHstryVO;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.member.resident.mapper.IResidentMapper;
import kr.or.ddit.domain.member.resident.vo.MyAptVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author 이용로
 */
@Slf4j
@Controller
@PreAuthorize("hasRole('RESIDENT')")
@RequestMapping("/apt/complaint")
public class CvplController {

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private ICvplService cvplService;

    // 민원 신청 페이지
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/apply.do/{aptCmplexNo}")
    public String complaintApplyForm(
            @AuthenticationPrincipal CustomUser customUser,
            @PathVariable String aptCmplexNo, Model model) {
        log.info("complaintApplyForm() 실행");

        // 헤더, 푸터 DTO
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);

        ResidentVO residentVO = (ResidentVO)customUser.getMember();
//        List<CvplHstryVO> cvplHstry = cvplService.selectCvplHstryList(aptCmplexNo, residentVO.getUserNo());
//        model.addAttribute("cvplHstry", cvplHstry);

        return "apt/complaint/complaint_apply";
    }

    // 민원 신청 비동기 컨트롤러
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @ResponseBody
    @PostMapping(value = "/apply/{aptCmplexNo}")
    public ResponseEntity<Map<String, String>> complaintApply(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , @RequestParam(required = false) MultipartFile[] attachFiles
            , CvplVO cvplVO) {
        log.info("complaintApply() 실행");

        MemberVO member = customUser.getMember();
        ResidentVO resident = (ResidentVO)member;

        for(MyAptVO apt : resident.getMyAptList()){
            if(apt.getAptCmplexNo().equals(aptCmplexNo)){
                cvplVO.setHoNo(apt.getHoNo());
            }
        }
        cvplVO.setUserNo(member.getUserNo());
        cvplVO.setAptCmplexNo(aptCmplexNo);
        // 응답용 해시맵
        Map<String, String> resp = new HashMap<>();

        List<MultipartFile> validFileList = new ArrayList<>();
        if (attachFiles != null) {
            for (MultipartFile file : attachFiles) {
                // null이 아니고 비어있지 않은 파일만 리스트에 추가
                if (file != null && !file.isEmpty()) {
                    validFileList.add(file);
                }
            }
        }
        MultipartFile[] finalFiles = validFileList.isEmpty() ? null : validFileList.toArray(new MultipartFile[0]);

        try{
            ServiceResult result = cvplService.applyCvpl(cvplVO, finalFiles);

            if(ServiceResult.OK.equals(result)){
                resp.put("message", "민원이 접수되었습니다.");
                return new ResponseEntity<>(resp, HttpStatus.OK);
            }else {
                resp.put("message", "민원 접수에 실패했습니다.");
                return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
            }
        }catch (Exception e){
            resp.put("message", "서버에러");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
