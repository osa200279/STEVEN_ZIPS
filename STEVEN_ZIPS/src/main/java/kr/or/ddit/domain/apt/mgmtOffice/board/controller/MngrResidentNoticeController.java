package kr.or.ddit.domain.apt.mgmtOffice.board.controller;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.mngrRegidentNoticeDTO;
import kr.or.ddit.domain.apt.mgmtOffice.board.service.ImngrRegidentNoticeService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mgmtOffice")
public class MngrResidentNoticeController {

    private final ImngrRegidentNoticeService mngrRegidentNoticeService;

    /*
     * @Controller
     * → 이 클래스가 화면 이동용 컨트롤러라는 뜻.
     *
     * @RequestMapping
     * → 공통 URL 앞주소.
     * 예: /apt/mgmtOffice/mngrResidentNotice/관리사무소번호
     *
     * final
     * → 생성자 주입 방식에서 사용하는 키워드.
     * 왜 사용?
     * → 서비스 객체가 중간에 바뀌지 않게 고정하기 위해.
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/mngrResidentNotice/{mgmtOfcNo}")
    public String mngrResidentNotice(
            @PathVariable String mgmtOfcNo,
            @RequestParam(required = false) String searchTtl,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        mngrRegidentNoticeDTO dto = new mngrRegidentNoticeDTO();

        dto.setSearchTtl(searchTtl);

        dto.setStartRow(1);
        dto.setEndRow(9999);

        List<mngrRegidentNoticeDTO> noticeList =
                mngrRegidentNoticeService.selectNoticeList(dto);

        model.addAttribute("noticeList", noticeList);

        mngrRegidentNoticeService.addManagerViewModel(
                model,
                customUser,
                mgmtOfcNo
        );

        return "apt/mgmtOffice/mngrResidentNotice";
    }

    /* 게시글 등록 */
    @PostMapping("/notice/insert")
    public String insertNotice(
            mngrRegidentNoticeDTO dto,
            @RequestParam String mgmtOfcNo
    ) {

        mngrRegidentNoticeService.insertNotice(dto);

        return "redirect:/mgmtOffice/mngrResidentNotice/" + mgmtOfcNo;
    }


}


