package kr.or.ddit.domain.central.controller;

import kr.or.ddit.domain.central.board.service.INoticeService;
import kr.or.ddit.domain.central.board.vo.NoticeVO;
import kr.or.ddit.domain.central.service.IContractUserService;
import kr.or.ddit.domain.central.vo.ContractUserVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/contract")
public class ContractUserController {

    @Autowired
    private INoticeService noticeService;

    @Autowired
    private IContractUserService contractUserService;

    @GetMapping("/list.do")
    public String contractList() {

        return "central/contract/contractList";
    }

    @GetMapping("/notice.do")
    public String contractNotice() {
        return "central/contract/contractNotice"; // JSP 이름
    }


    @GetMapping("/apply.do")
    public String contractApply() {
        return "central/contract/contractApply";
    }


    /*@PostMapping("/apply.do")
    public String applyContract(
            @RequestParam("uploadFiles") MultipartFile[] uploadFiles,
            @RequestParam("docTypeList") List<String> docTypeList,
            Model model
    ) {

        log.info("파일 개수 : {}", uploadFiles.length);

        for (int i = 0; i < uploadFiles.length; i++) {

            MultipartFile file = uploadFiles[i];

            log.info("====================");
            log.info("문서타입 : {}", docTypeList.get(i));
            log.info("파일명 : {}", file.getOriginalFilename());
            log.info("파일크기 : {}", file.getSize());

            String docType = docTypeList.get(i);

            if ("RESIDENT".equals(docType)) {
                model.addAttribute("residentFile",
                        file.getOriginalFilename());
            }

            if ("FAMILY".equals(docType)) {
                model.addAttribute("familyFile",
                        file.getOriginalFilename());
            }

            if ("FINANCE".equals(docType)) {
                model.addAttribute("financeFile",
                        file.getOriginalFilename());
            }

        }

        return "central/contract/contractAList";
    }*/

    @PreAuthorize("hasRole('MEMBER')")
    @PostMapping("/apply.do")
    public String applyContract(
            @RequestParam("uploadFiles") MultipartFile[] contractDocFile,
            @RequestParam("docTypeList") List<String> docTypeList,
            @AuthenticationPrincipal CustomUser principal
    ) throws IOException {
        String userNo = principal.getMember().getUserNo();
        contractUserService.insertContractDoc(contractDocFile, docTypeList, userNo);
        return "redirect:/contract/history.do";
    }

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/history.do")
    public String contractHistory(
            @AuthenticationPrincipal CustomUser principal,
            Model model
    ) {
        String userNo = principal.getMember().getUserNo();
        List<ContractUserVO> list = contractUserService.selectContractDoc(userNo);
        model.addAttribute("list", list);
        return "central/contract/contractAList";
    }











    @GetMapping("/noticeList.do")
    public String noticeList() {
        return "central/contract/notice";
    }

    /*@GetMapping("/history.do")
    public String contractHistory() {
        return "central/contract/contractAList";
    }*/

    @GetMapping("/detail.do")
    public String contractDetail(String annNo, Model model) {

        NoticeVO notice = noticeService.getNoticeDetail(annNo);
        model.addAttribute("notice", notice);


        return "central/contract/contractNoticeDetail"; // 상세 JSP
    }
}
