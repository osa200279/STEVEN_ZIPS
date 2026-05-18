package kr.or.ddit.domain.apt.mgmtOffice.board.controller;

import kr.or.ddit.domain.apt.mgmtOffice.board.dto.MngrRegidentNoticeDTO;
import kr.or.ddit.domain.apt.mgmtOffice.board.service.IMngrRegidentNoticeService;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mgmtOffice")
public class MngrResidentNoticeController {

    /*
     * Service 호출 객체
     * → Controller는 DB 직접 접근하지 않고 Service를 통해 처리함.
     */
    private final IMngrRegidentNoticeService mngrRegidentNoticeService;

    /**
     * 관리사무소 공지사항 목록 조회
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param dto 공지사항 검색조건 DTO
     * @param customUser 로그인 사용자 정보
     * @param model 화면 전달 데이터
     * @return 공지사항 목록 화면 JSP
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/mngrResidentNotice/{mgmtOfcNo}")
    public String mngrResidentNotice(
            @PathVariable String mgmtOfcNo,
            @ModelAttribute MngrRegidentNoticeDTO dto,
            @AuthenticationPrincipal CustomUser customUser,
            Model model
    ) {

        /*
         * 로그인 관리사무소 기준
         * aptCmplexNo, boardNo 자동 세팅.
         */
        mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                dto,
                customUser,
                mgmtOfcNo
        );

        /*
         * 현재는 전체 조회.
         * 나중에 페이징 적용 시 startRow/endRow 계산 변경 예정.
         */
        dto.setStartRow(1);
        dto.setEndRow(9999);

        /*
         * 공지 목록 조회
         */
        List<MngrRegidentNoticeDTO> noticeList =
                mngrRegidentNoticeService.selectNoticeList(dto);

        /*
         * 공지 총 개수 조회
         */
        int noticeCount =
                mngrRegidentNoticeService.selectNoticeCount(dto);

        /*
         * JSP 전달 데이터
         */
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("noticeCount", noticeCount);
        model.addAttribute("searchDTO", dto);

        /*
         * 공통 화면 정보 세팅
         * (관리사무소 번호, 게시판번호 등)
         */
        mngrRegidentNoticeService.addManagerViewModel(
                model,
                customUser,
                mgmtOfcNo
        );

        /*
         * JSP 이동
         */
        return "apt/mgmtOffice/mngrResidentNotice";
    }

    /**
     * 관리사무소 공지사항 등록
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param dto 공지사항 등록 DTO
     * @param uploadFile 첨부파일
     * @param customUser 로그인 사용자 정보
     * @return 공지사항 목록 화면 redirect
     * @throws Exception 파일 업로드 및 저장 예외
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/notice/insert")
    public String insertNotice(
            @RequestParam String mgmtOfcNo,
            MngrRegidentNoticeDTO dto,
            @RequestParam(value = "uploadFile", required = false)
            MultipartFile uploadFile,
            @AuthenticationPrincipal CustomUser customUser
    ) throws Exception {

        /*
         * 현재 로그인 관리사무소 정보 세팅.
         */
        mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                dto,
                customUser,
                mgmtOfcNo
        );

        /*
         * 공지 저장
         */
        mngrRegidentNoticeService.insertNotice(dto, uploadFile);

        /*
         * 저장 후 목록 재조회
         */
        return "redirect:/mgmtOffice/mngrResidentNotice/" + mgmtOfcNo;
    }

    /**
     * 관리사무소 공지사항 상세조회
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param annNo 공지번호
     * @param customUser 로그인 사용자 정보
     * @return 공지사항 상세정보 DTO
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/notice/detail/{mgmtOfcNo}/{annNo}")
    @ResponseBody
    public MngrRegidentNoticeDTO noticeDetail(
            @PathVariable String mgmtOfcNo,
            @PathVariable String annNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {

        /*
         * 조회조건 DTO 생성
         */
        MngrRegidentNoticeDTO dto = new MngrRegidentNoticeDTO();

        /*
         * 공지번호 세팅
         */
        dto.setAnnNo(annNo);

        /*
         * 현재 로그인 관리사무소 기준 boardNo 세팅.
         */
        mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                dto,
                customUser,
                mgmtOfcNo
        );

        /*
         * 상세조회 결과 반환(JSON)
         */
        return mngrRegidentNoticeService.selectNoticeDetail(dto);
    }

    /**
     * 관리사무소 공지사항 수정
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param dto 공지사항 수정 DTO
     * @param customUser 로그인 사용자 정보
     * @return 공지사항 목록 화면 redirect
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/notice/update")
    public String updateNotice(
            @RequestParam String mgmtOfcNo,
            MngrRegidentNoticeDTO dto,
            @AuthenticationPrincipal CustomUser customUser
    ) {

        /*
         * 현재 로그인 사용자 기준 boardNo 세팅.
         */
        mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                dto,
                customUser,
                mgmtOfcNo
        );

        /*
         * 수정 실행
         */
        mngrRegidentNoticeService.updateNotice(dto);

        /*
         * 수정 후 목록 이동
         */
        return "redirect:/mgmtOffice/mngrResidentNotice/" + mgmtOfcNo;
    }

    /**
     * 관리사무소 공지사항 삭제
     * @author 김보라
     * @param mgmtOfcNo 관리사무소번호
     * @param annNo 공지번호
     * @param customUser 로그인 사용자 정보
     * @return 공지사항 목록 화면 redirect
     */
    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping("/notice/delete")
    public String deleteNotice(
            @RequestParam String mgmtOfcNo,
            @RequestParam String annNo,
            @AuthenticationPrincipal CustomUser customUser
    ) {

        /*
         * 삭제 조건 DTO 생성
         */
        MngrRegidentNoticeDTO dto = new MngrRegidentNoticeDTO();

        dto.setAnnNo(annNo);

        /*
         * 현재 관리사무소 boardNo 세팅.
         */
        mngrRegidentNoticeService.setManagerNoticeBaseInfo(
                dto,
                customUser,
                mgmtOfcNo
        );

        /*
         * 삭제 실행
         */
        mngrRegidentNoticeService.deleteNotice(dto);

        /*
         * 삭제 후 목록 재조회
         */
        return "redirect:/mgmtOffice/mngrResidentNotice/" + mgmtOfcNo;
    }
}