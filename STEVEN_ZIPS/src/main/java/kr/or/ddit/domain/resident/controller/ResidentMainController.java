package kr.or.ddit.domain.resident.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/resident")
public class ResidentMainController {

    /* =========================
     * 관리사무소
     * ========================= */
    @GetMapping("/manage/intro")
    public String manageIntro() {
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
        return "member/resident/facility_reservation";
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
    @GetMapping("/vote/resident")
    public String voteResident() {
        return "member/resident/vote_resident";
    }

    @GetMapping("/vote/survey")
    public String voteSurvey() {
        return "member/resident/vote_survey";
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
