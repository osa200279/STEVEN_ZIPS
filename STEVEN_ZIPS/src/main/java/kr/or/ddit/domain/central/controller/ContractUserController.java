package kr.or.ddit.domain.central.controller;

import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import kr.or.ddit.domain.central.service.IContractUserService;
import kr.or.ddit.domain.central.vo.RentCtrtVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
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
@RequestMapping("/contract")
public class ContractUserController {

    @Autowired
    private IContractUserService contractUserService;

    @Autowired
    private IAnnouncementService announcementService;

    @Autowired
    private IAttachFileMapper iAttachFileMapper;

    @GetMapping("/list.do")
    public String contractList() {
        return "central/contract/contractList";
    }

    @GetMapping("/apply.do")
    public String contractApply() {
        return "central/contract/contractApply";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/notice.do")
    public String contractNoticeList(AnnouncementDTO searchVO, Model model) {
        List<AnnouncementDTO> list = announcementService.selectAnnouncementList(searchVO);
        if (!list.isEmpty()) {
            log.info("첫번째 aptCmplexNo: {}", list.get(0).getAptCmplexNo());
        }
        model.addAttribute("list", list);
        return "central/contract/contractNotice";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/notice.json")
    @ResponseBody
    public List<AnnouncementDTO> contractNoticeListJson(AnnouncementDTO searchVO) {
        return announcementService.selectAnnouncementList(searchVO);
    }

    @PreAuthorize("hasRole('MEMBER')")
    @ResponseBody
    @PostMapping("/request.do")
    public Map<String, Object> contractRequest(@RequestBody Map<String, Object> params,
                                               @AuthenticationPrincipal CustomUser principal) {
        Map<String, Object> result = new HashMap<>();
        try {
            params.put("userNo", principal.getMember().getUserNo());
            contractUserService.insertAplct(params);
            result.put("success", true);
        } catch (Exception e) {
            log.error("계약 신청 오류: {}", e.getMessage());
            result.put("success", false);
            result.put("message", e.getMessage());
        }
        return result;
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/detail.do")
    public String contractDetail(
            @RequestParam("annNo") String annNo,
            @AuthenticationPrincipal CustomUser principal,
            Model model) {
        contractUserService.updateInqCnt(annNo);
        AnnouncementDTO announcement = announcementService.selectAnnouncement(annNo);

        List<Map<String, Object>> exclusiveSize = contractUserService.selectExcluseAreaDetail(announcement.getAptCmplexNo());

        if (announcement.getAtchFileId() != null) {
            List<AttachFileVO> fileList = iAttachFileMapper.selecAttachFileList(announcement.getAtchFileId());
            model.addAttribute("fileList", fileList);
        }

        log.info("aptCmplexNo: {}", announcement.getAptCmplexNo());
        log.info("exclusiveSize: {}", exclusiveSize);
        model.addAttribute("announcement", announcement);
        model.addAttribute("exclusiveSize", exclusiveSize);
        model.addAttribute("principal", principal);
        return "central/contract/contractNoticeDetail";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/history.do")
    public String contractHistory(
            @AuthenticationPrincipal CustomUser principal,
            Model model) {
        String userNo = principal.getMember().getUserNo();
        List<Map<String, Object>> list = contractUserService.selectAplctList(userNo);
        log.info("aplctList: {}", list);
        model.addAttribute("list", list);
        return "central/contract/contractAList";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @PutMapping("/update.do")
    @ResponseBody
    public Map<String, Object> contractUpdate(@RequestBody RentCtrtVO rentCtrtVO,
                                              @AuthenticationPrincipal CustomUser principal) {
        String userNo = principal.getMember().getUserNo();
        rentCtrtVO.setUserNo(userNo);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    @PreAuthorize("hasRole('MEMBER')")
    @PutMapping("/cancel.do")
    @ResponseBody
    public Map<String, Object> cancelContract(@RequestBody Map<String, Object> params) {
        contractUserService.cancelContract((String) params.get("aplctNo"));
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    @GetMapping("/historyDetail.do")
    public String contractHistoryDetail(@RequestParam String aplctNo,
                                        @AuthenticationPrincipal CustomUser principal,
                                        Model model) {
        String userNo = principal.getMember().getUserNo();
        MemberVO memberVO = principal.getMember();
        Map<String, Object> detail = contractUserService.selectOneContractHistoryDetail(aplctNo);
        //List<Map<String, Object>> docList = contractUserService.selectSbmsnDocList(aplctNo);
        List<Map<String, Object>> docList = contractUserService.selectAplctDocList(aplctNo);
        log.info("detail: {}", detail);
        log.info("docList: {}", docList);
        model.addAttribute("memberVO", memberVO);
        model.addAttribute("detail", detail);
        model.addAttribute("docList", docList);
        model.addAttribute("aplctNo", aplctNo);
        model.addAttribute("userNo", userNo);
        return "central/contract/contractADetail";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @PostMapping("/insertContractDoc.do")
    @ResponseBody
    public Map<String, Object> insertContractDoc(
            @RequestParam MultipartFile file,
            @RequestParam String aplctNo,
            @RequestParam String sbmsnDocTyCd,
            @AuthenticationPrincipal CustomUser principal
            ){
        Map<String, Object> result = new HashMap<>();

        try {
            String userNo = principal.getMember().getUserNo();
            contractUserService.insertContractDoc(file, sbmsnDocTyCd, aplctNo, userNo);
            result.put("success", true);
        } catch (Exception e){
            log.error("에러");
            result.put("success", false);
        }
        return result;

    }
}