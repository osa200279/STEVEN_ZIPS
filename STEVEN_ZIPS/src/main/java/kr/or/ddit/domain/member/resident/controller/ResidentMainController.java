package kr.or.ddit.domain.member.resident.controller;

import kr.or.ddit.domain.apt.manager.service.IMgmtOfficeService;
import kr.or.ddit.domain.apt.manager.vo.MgmtOfficeVO;
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
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/resident")
public class ResidentMainController {

    @Autowired
    private IMgmtOfficeService mgmtOfficeService;

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/myApt")
    public String myApt(@AuthenticationPrincipal CustomUser customUser, Model model) {
        ResidentVO resident = (ResidentVO) customUser.getMember();

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
        return "member/resident/bill_inquiry";
    }

    @GetMapping("/bill/guide")
    public String billGuide() {
        return "member/resident/bill_guide";
    }

    @GetMapping("/bill/auto")
    public String billAuto() {
        return "member/resident/bill_auto";
    }

    @GetMapping("/bill/receipt")
    public String billReceipt() {
        return "member/resident/bill_receipt";
    }

    /* =========================
     * 생활지원서비스
     * ========================= */
    @GetMapping("/service/moving")
    public String serviceMoving() {
        return "member/resident/service_moving";
    }

    @GetMapping("/service/car")
    public String serviceCar() {
        return "member/resident/service_car";
    }

    @GetMapping("/service/visitor")
    public String serviceVisitor() {
        return "member/resident/service_visitor";
    }

    @GetMapping("/service/facility")
    public String serviceFacility() {
        return "member/resident/service_facility";
    }

    @GetMapping("/service/facility/reservations")
    public String serviceFacilityReservation() {
        return "member/resident/facility_reservation_list";
    }

    @GetMapping("/service/facility/detail")
    public String serviceFacilityDetail() {
        return "member/resident/facility_reservation_detail";
    }

    @GetMapping("/service/facility/meeting-room")
    public String serviceMeetingroom() {
        return "member/resident/facility_meeting_room";
    }

    @GetMapping("/service/facility/reading-room")
    public String serviceReadingroom() {
        return "member/resident/facility_reading_room";
    }

    @GetMapping("/service/facility/tennis")
    public String serviceTennis() {
        return "member/resident/facility_tennis";
    }

    /* =========================
     * 민원접수
     * ========================= */
    @GetMapping("/complaint/apply")
    public String complaintApply() {
        return "member/resident/complaint_apply";
    }

    @GetMapping("/complaint/live")
    public String complaintLive() {
        return "member/resident/complaint_live";
    }

    @GetMapping("/complaint/chatbot")
    public String complaintChatbot() {
        return "member/resident/complaint_chatbot";
    }

    @GetMapping("/complaint/status")
    public String complaintStatus() {
        return "member/resident/complaint_status";
    }

    /* =========================
     * 전자투표 및 설문
     * ========================= */
    @GetMapping("/vote")
    public String voteResident() {
        return "member/resident/vote_resident";
    }

    @GetMapping("/vote/list")
    public String voteList() {
        return "member/resident/vote_resident_list";
    }

    @GetMapping("/vote/detail")
    public String voteDetail() {
        return "member/resident/vote_resident_detail";
    }

    @GetMapping("/vote/result")
    public String voteResult() {
        return "member/resident/vote_resident_result";
    }

    @GetMapping("/survey")
    public String survey() {
        return "member/resident/survey";
    }

    @GetMapping("/survey/detail")
    public String surveyDetail() {
        return "member/resident/survey_detail";
    }

    @GetMapping("/survey/result")
    public String surveyResult() {
        return "member/resident/survey_result";
    }

    @GetMapping("/survey/list")
    public String surveyList() {
        return "member/resident/survey_list";
    }

    /* =========================
     * 입주민게시판
     * ========================= */
    @GetMapping("/board/notice")
    public String boardNotice() {
        return "member/resident/board_notice";
    }

    @GetMapping("/board/free")
    public String boardFree() {
        return "member/resident/board_free";
    }

    @GetMapping("/board/free/list")
    public String boardFreeList() {
        return "member/resident/board_free_list";
    }

    @GetMapping("/board/free/write")
    public String boardFreeWrite() {
        return "member/resident/board_free_write";
    }

    @GetMapping("/board/free/detail")
    public String boardFreeDetail() {
        return "member/resident/board_free_detail";
    }

    @GetMapping("/board/chat")
    public String boardChat() {
        return "member/resident/board_chat";
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
