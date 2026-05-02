package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.apt.dto.AptMainPageDTO;
import kr.or.ddit.domain.apt.manager.service.IMgmtOfficeService;
import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;
import kr.or.ddit.domain.member.manager.servcie.IAptComplexService;
import kr.or.ddit.domain.member.resident.service.IResidentMainService;
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

@Slf4j
@Controller
@RequestMapping("/resident")
public class ResidentMainController {

    @Autowired
    private IResidentMainService residentMainService;

    @Autowired
    private IMgmtOfficeService mgmtOfficeService;

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
        if(member instanceof ResidentVO) {  // 따라서 순수 member객체인지 resident를 담고있는 member객체인지 확인
            ResidentVO resident = (ResidentVO)member;
            log.info("RESIDENT INFO : {}", resident);

            model.addAttribute("resident", resident);
        }

        return "member/resident/myApt";
    }

    /* =========================
     * 관리사무소
     * ========================= */
    @GetMapping("/manage/intro")
    public String manageIntro(Authentication authentication, Model model) {
        String userId = authentication.getName();

        log.info("관리사무소 소개 조회 userId = {}", userId);

        MgmtOfficeVO office = mgmtOfficeService.selectMgmtOfficeByManagerUserNo(userId);

        log.info("조회된 관리사무소 정보 = {}", office);

        if (office == null) {
            model.addAttribute("message", "로그인 계정에 연결된 관리사무소 정보가 없습니다.");
            return "manager/mngr_office_error";
        }

        model.addAttribute("office", office);
        return "member/resident/manage_intro";
    }

    @GetMapping("/manage/operation")
    public String manageOperation() {
        return "member/resident/manage_operation";
    }

    @GetMapping("/manage/facility")
    public String manageFacility() {
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


    @GetMapping("/service/car/{aptCmplexNo}")
    @PreAuthorize("hasRole('RESIDENT')")
    public String serviceCar(@AuthenticationPrincipal CustomUser principal, @PathVariable String aptCmplexNo, Model model) {

        model.addAttribute("userNo", principal.getMember().getUserNo());

        model.addAttribute("aptCmplexNo", aptCmplexNo);

        return "member/resident/service_car";
    }

    @GetMapping("/service/visitor")
    public String serviceVisitor() {
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
    @GetMapping("/complaint/apply")
    public String complaintApply() {
        return "member/resident/complaint/complaint_apply";
    }

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

    @PreAuthorize("hasRole('RESIDENT')")
    @GetMapping("/board/chat")
    public String boardChat(@AuthenticationPrincipal CustomUser principal, Model model) {

        model.addAttribute("userNo", principal.getMember().getUserNo());

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
}
