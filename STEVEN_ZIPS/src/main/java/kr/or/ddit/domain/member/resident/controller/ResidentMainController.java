package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.apt.main.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.main.service.IAptComplexService;
import kr.or.ddit.domain.apt.mgmtOffice.main.service.IMgmtOfficeService;
import kr.or.ddit.domain.central.dto.FacilityInfoDTO;
import kr.or.ddit.domain.member.resident.dto.ResidentFacilityHistoryDTO;
import kr.or.ddit.domain.member.resident.service.IResidentFacilityService;
import kr.or.ddit.domain.member.resident.vo.MyAptVO;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/resident")
public class ResidentMainController {

    @Autowired
    private IMgmtOfficeService mgmtOfficeService;

    @Autowired
    private IAptComplexService aptComplexService;

    @Autowired
    private IResidentFacilityService residentFacilityService;

    /**
     * 내 아파트 목록 조회 컨트롤러
     * @author 이용로
     * @param customUser 인증 객체
     * @param model
     * @return myApt.jsp 내 아파트 목록 조회 페이지
     */
    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/myApt")
    public String myApt(@AuthenticationPrincipal CustomUser customUser, Model model) {
        log.info("myApt() 실행");
        MemberVO member = customUser.getMember();

        // 입주민이라면 customUser가 member=resident로 초기화 된 member를 반환받아 갖고 있음
        if(member instanceof ResidentVO resident) {  // 따라서 순수 member객체인지 resident를 담고있는 member객체인지 확인
            // 다운캐스팅
            log.info("RESIDENT INFO : {}", resident);

            model.addAttribute("resident", resident);
        }

        return "member/resident/myApt";
    }

    /**
     * @author 이윤진
     * @param authentication 로그인 한 사용자 정보를 가져오기 위한 객체
     * @param model
     * @return 관리사무소 소개 페이지
     */
    @GetMapping("/manage/intro")
    public String manageIntro(Authentication authentication, Model model) {

        // 1. 로그인 여부 체크
        if (authentication == null || !authentication.isAuthenticated()) {
            model.addAttribute("message", "로그인이 필요합니다.");
            model.addAttribute("redirectUrl", "/login");
            return "member/resident/resident_auth_error";
        }

        // 2. 입주민 권한 체크
        boolean isResident = authentication.getAuthorities().stream()
                .anyMatch(auth -> "ROLE_RESIDENT".equals(auth.getAuthority()));

        // 3. 입주민이 아니면 진입 불가
        if (!isResident) {
            model.addAttribute("message", "입주민 권한으로 로그인 해 주세요!");
            model.addAttribute("redirectUrl", "/login.do");
            return "member/resident/resident_auth_error";
        }

        // 4. 정상 접근
        // office, aptInfo는 HeaderModelAdvice가 자동으로 model에 넣어줌
        return "member/resident/manage_intro";
    }

    @GetMapping("/manage/operation")
    public String manageOperation() {
        return "member/resident/manage_operation";
    }

    /* 입주민 시설관리이력 */
    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/manage/facility/{aptCmplexNo}")
    public String manageFacility(
            @AuthenticationPrincipal CustomUser customUser,
            @PathVariable String aptCmplexNo,
            @RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,
            @RequestParam(value = "facilityTyCd", required = false) String facilityTyCd,
            Model model
    ) {
        /*
         * @PreAuthorize("hasRole('RESIDENT')")
         * → 입주민 이상만 접근 가능.
         * SecurityConfig의 권한 계층 때문에 MNGR, ADMIN도 접근 가능.
         */

        String userNo = customUser.getMember().getUserNo();

        /*
         * aptCmplexNo가 없으면 로그인한 입주민의 단지번호를 DB에서 조회한다.
         */
        if (aptCmplexNo == null || aptCmplexNo.isBlank()) {
            aptCmplexNo = residentFacilityService.getResidentAptCmplexNo(userNo);
        }

        int screenSize = 5;
        int startRow = (currentPage - 1) * screenSize + 1;
        int endRow = currentPage * screenSize;

        int totalRecord = residentFacilityService.getFacilityHistoryCount(aptCmplexNo, facilityTyCd);
        int totalPage = (int) Math.ceil((double) totalRecord / screenSize);

        List<ResidentFacilityHistoryDTO> statusCardList =
                residentFacilityService.getFacilityStatusCardList(aptCmplexNo);

        /*
         * 입주민 시설관리이력 화면용 단지 기본정보
         */
        FacilityInfoDTO facilityAptInfo = residentFacilityService.getAptInfo(aptCmplexNo);

        /*
         * 입주민 화면에 보여줄 단지 시설 목록
         */
        List<FacilityInfoDTO> facilityInfoList =
                residentFacilityService.getResidentFacilityInfoList(aptCmplexNo, facilityTyCd);

        List<ResidentFacilityHistoryDTO> historyList =
                residentFacilityService.getFacilityHistoryList(aptCmplexNo, facilityTyCd, startRow, endRow);


        /* 입주민 아파트 헤더레이아웃 */
        AptMainPageDTO.ResponseDto aptCommonDTO = aptComplexService.selectAptCommonDTO(aptCmplexNo);
        model.addAttribute("aptInfo", aptCommonDTO);
        model.addAttribute("aptCmplexNo", aptCmplexNo);

        model.addAttribute("statusCardList", statusCardList);
        model.addAttribute("historyList", historyList);
        model.addAttribute("currentPage", currentPage);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("totalRecord", totalRecord);

        model.addAttribute("facilityAptInfo", facilityAptInfo);
        model.addAttribute("facilityInfoList", facilityInfoList);
        model.addAttribute("facilityTyCd", facilityTyCd);

        return "member/resident/manage_facility";
    }

    @GetMapping("/manage/favorite")
    public String manageFavorite() {
        return "member/resident/manage_favorite";
    }

    /* =========================
     * 아파트관리비
     * ========================= */
    @GetMapping("/bill/inquiry")
    public String billInquiry() {
        return "member/resident/bill/bill_inquiry";
    }

    @GetMapping("/bill/guide")
    public String billGuide() {
        return "member/resident/bill/bill_guide";
    }

    @GetMapping("/bill/auto")
    public String billAuto() {
        return "member/resident/bill/bill_auto";
    }

    @GetMapping("/bill/receipt")
    public String billReceipt() {
        return "member/resident/bill/bill_receipt";
    }

    /* =========================
     * 생활지원서비스
     * ========================= */
    @GetMapping("/service/moving")
    public String serviceMoving() {
        return "member/resident/service/service_moving";
    }


    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/service/car/{aptCmplexNo}")
    public String serviceCar(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            Model model
    ) {

        MemberVO member = principal.getMember();

        String userNo = member.getUserNo();

        List<MyAptVO> aptList = List.of();

        if (member instanceof ResidentVO resident) {

            aptList = resident.getMyAptList().stream()
                    .filter(apt ->
                            apt.getAptCmplexNo().equals(aptCmplexNo)
                    )
                    .toList();
        }

        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptCommonDTO);

        model.addAttribute("userNo", userNo);
        model.addAttribute("aptCmplexNo", aptCmplexNo);
        model.addAttribute("aptList", aptList);

        model.addAttribute(
                "memberType",
                member.getClass().getSimpleName()
        );

        return "member/resident/service/service_car";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/service/visitor/{aptCmplexNo}")
    public String serviceVisitor(
            @AuthenticationPrincipal CustomUser principal,
            @PathVariable String aptCmplexNo,
            Model model
    ) {

        AptMainPageDTO.ResponseDto aptCommonDTO =
                aptComplexService.selectAptCommonDTO(aptCmplexNo);

        model.addAttribute("aptInfo", aptCommonDTO);

        MemberVO member = principal.getMember();

        model.addAttribute(
                "memberType",
                member.getClass().getSimpleName()
        );

        return "member/resident/service/service_visitor";
    }

    @GetMapping("/service/facility")
    public String serviceFacility() {
        return "member/resident/service/service_facility";
    }

    @GetMapping("/service/facility/reservations")
    public String serviceFacilityReservation() {
        return "member/resident/facility/facility_reservation_list";
    }

    @GetMapping("/service/facility/detail")
    public String serviceFacilityDetail() {
        return "member/resident/facility/facility_reservation_detail";
    }

    @GetMapping("/service/facility/meeting-room")
    public String serviceMeetingroom() {
        return "member/resident/facility/facility_meeting_room";
    }

    @GetMapping("/service/facility/reading-room")
    public String serviceReadingroom() {
        return "member/resident/facility/facility_reading_room";
    }

    @GetMapping("/service/facility/tennis")
    public String serviceTennis() {
        return "member/resident/facility/facility_tennis";
    }

    /* =========================
     * 민원접수
     * ========================= */

    @GetMapping("/complaint/live")
    public String complaintLive() {
        return "member/resident/complaint/complaint_live";
    }

    @GetMapping("/complaint/chatbot")
    public String complaintChatbot() {
        return "member/resident/complaint/complaint_chatbot";
    }

    @GetMapping("/complaint/status")
    public String complaintStatus() {
        return "member/resident/complaint/complaint_status";
    }

    /* =========================
     * 전자투표 및 설문
     * ========================= */
    @GetMapping("/vote")
    public String voteResident() {
        return "member/resident/survey/vote_resident";
    }

    @GetMapping("/vote/list")
    public String voteList() {
        return "member/resident/survey/vote_resident_list";
    }

    @GetMapping("/vote/detail")
    public String voteDetail() {
        return "member/resident/survey/vote_resident_detail";
    }

    @GetMapping("/vote/result")
    public String voteResult() {
        return "member/resident/survey/vote_resident_result";
    }

    @GetMapping("/survey")
    public String survey() {
        return "member/resident/survey/survey";
    }

    @GetMapping("/survey/detail")
    public String surveyDetail() {
        return "member/resident/survey/survey_detail";
    }

    @GetMapping("/survey/result")
    public String surveyResult() {
        return "member/resident/survey/survey_result";
    }

    @GetMapping("/survey/list")
    public String surveyList() {
        return "member/resident/survey/survey_list";
    }

    /* =========================
     * 입주민게시판
     * ========================= */
    @GetMapping("/board/notice")
    public String boardNotice() {
        return "member/resident/board/board_notice";
    }

    @GetMapping("/board/free")
    public String boardFree() {
        return "member/resident/board/board_free";
    }

    @GetMapping("/board/free/list")
    public String boardFreeList() {
        return "member/resident/board/board_free_list";
    }

    @GetMapping("/board/free/write")
    public String boardFreeWrite() {
        return "member/resident/board/board_free_write";
    }

    @GetMapping("/board/free/detail")
    public String boardFreeDetail() {
        return "member/resident/board/board_free_detail";
    }

    @PreAuthorize("@authService.hasAccess(principal, #aptCmplexNo)")
    @GetMapping("/board/chat/{aptCmplexNo}")
    public String boardChat(@AuthenticationPrincipal CustomUser principal
            ,@PathVariable String aptCmplexNo
            ,Model model
            ) {

        model.addAttribute("userNo", principal.getMember().getUserNo());
        model.addAttribute("aptCmplexNo",aptCmplexNo);

        return "member/resident/board/board_chat";
    }

    /* =========================
     * 우리아파트통계
     * ========================= */
    @GetMapping("/stats/custom")
    public String statsCustom() {
        return "member/resident/stats_custom";
    }
    @GetMapping("/stats/apartment")
    public String statsApartment() {
        return "member/resident/stats_apartment";
    }

    @GetMapping("/service/moving/in")
    public String seriveMoveIn() {
        return "member/resident/service/service_move_in";
    }
    @GetMapping("/service/moving/out")
    public String seriveMoveOut() {
        return "member/resident/service/service_move_out";
    }
    @GetMapping("/service/moving/settlement")
    public String seriveMoveSettlement() {
        return "member/resident/service/service_move_settlement";
    }


}


