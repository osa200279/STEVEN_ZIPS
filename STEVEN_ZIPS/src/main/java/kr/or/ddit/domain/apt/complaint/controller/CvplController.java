package kr.or.ddit.domain.apt.complaint.controller;

import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.common.model.PaginationInfoVO;
import kr.or.ddit.domain.apt.complaint.service.ICvplService;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.member.resident.vo.MyAptVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
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

    /**
     * 민원신청 페이지
     *
     * @author 이용로
     */
    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
    @GetMapping("/apply.do/{aptCmplexNo}")
    public String complaintApplyForm(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , @RequestParam(defaultValue = "1") int curPage
            , Model model) {
        log.info("complaintApplyForm() 실행");
        ResidentVO residentVO = (ResidentVO) customUser.getMember();

        // 페이징VO 생성 및 현재페이지 세팅
        PaginationInfoVO<CvplVO> page = new PaginationInfoVO<>(11, 5);

        // 검색조건 설정
        CvplVO searchVO = new CvplVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setUserNo(residentVO.getUserNo());
        page.setSearchVO(searchVO);

        // 전체 데이터 갯수 조회
        int totalRecord = cvplService.selectCvplCount(page.getSearchVO());
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(curPage);

        // 해당 페이지 범위에 맞는 리스트만 조회
        List<CvplVO> cvplList = cvplService.selectMyCvplList(page);
        page.setDataList(cvplList);

        model.addAttribute("page", page);

        // 헤더, 푸터 DTO
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);
        return "apt/complaint/complaint_apply";
    }

    /**
     * 민원 신청 비동기
     *
     * @author 이용로
     */
    @PreAuthorize("@authService.isResidentOnly(principal, #aptCmplexNo)")
    @ResponseBody
    @PostMapping(value = "/apply/{aptCmplexNo}")
    public ResponseEntity<Map<String, String>> complaintApply(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , @RequestParam(required = false) MultipartFile[] attachFiles
            , CvplVO cvplVO) {
        log.info("complaintApply() 실행");

        ResidentVO resident = (ResidentVO) customUser.getMember();

        for (MyAptVO apt : resident.getMyAptList()) {
            if (apt.getAptCmplexNo().equals(aptCmplexNo)) {
                cvplVO.setHoNo(apt.getHoNo());
            }
        }
        cvplVO.setUserNo(resident.getUserNo());
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

        try {
            ServiceResult result = cvplService.applyCvpl(cvplVO, finalFiles);

            if (ServiceResult.OK.equals(result)) {
                resp.put("message", "민원이 접수되었습니다.");
                return new ResponseEntity<>(resp, HttpStatus.OK);
            } else {
                resp.put("message", "민원 접수에 실패했습니다.");
                return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            resp.put("message", "서버에러");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 비동기 민원 내역 리스트 불러오기
     *
     * @param customUser
     * @param aptCmplexNo
     * @return
     */
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @ResponseBody
    @GetMapping(value = "/ajax/load-cvpl/{aptCmplexNo}")
    public ResponseEntity<List<CvplVO>> ajaxLoadCvpl(
            @AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , Model model) {
        PaginationInfoVO<CvplVO> page = new PaginationInfoVO<>(11, 5);
        ResidentVO resident = (ResidentVO) customUser.getMember();

        // 검색조건 설정
        CvplVO searchVO = new CvplVO();
        searchVO.setAptCmplexNo(aptCmplexNo);
        searchVO.setUserNo(resident.getUserNo());
        page.setSearchVO(searchVO);

        // 전체 데이터 갯수 조회
        int totalRecord = cvplService.selectCvplCount(page.getSearchVO());
        page.setTotalRecord(totalRecord);
        page.setCurrentPage(1);

        // 해당 페이지 범위에 맞는 리스트만 조회
        List<CvplVO> cvplList = cvplService.selectMyCvplList(page);
        page.setDataList(cvplList);

        model.addAttribute("page", page);

        return ResponseEntity.ok(cvplList);
    }


    // 민원 리스트 페이지
    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/list/{aptCmplexNo}")
    public String cvplList(@AuthenticationPrincipal CustomUser customUser
            , @PathVariable String aptCmplexNo
            , Model model) {
        ResidentVO resident = (ResidentVO) customUser.getMember();
        List<CvplVO> cvplList = cvplService.selectCvplListByAptCmplexNo(aptCmplexNo, resident.getUserNo());

        model.addAttribute("cvplList", cvplList);

        // 헤더, 푸터 DTO
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);

        return "apt/complaint/complaint_list";
    }
}
