package kr.or.ddit.domain.central.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import kr.or.ddit.domain.central.admin.vo.AnnouncementVO;
import lombok.RequiredArgsConstructor;

/**
 * 중앙관리자 공고 관리 Controller
 *
 * Controller란?
 * → 브라우저 요청을 받아서 JSP 화면 또는 JSON 데이터를 응답하는 클래스.
 */
@Controller
@RequiredArgsConstructor
@RequestMapping("/centralAdmin/announcement")
public class AnnouncementController {

    private final IAnnouncementService announcementService;

    @GetMapping
    public String announcementPage() {
        return "centralAdmin/announcement";
    }

    @ResponseBody
    @GetMapping("/list")
    public ResponseEntity<?> list(AnnouncementVO searchVO) {
        return ResponseEntity.ok(announcementService.selectAnnouncementList(searchVO));
    }

    @ResponseBody
    @GetMapping("/{annNo}")
    public ResponseEntity<?> detail(@PathVariable String annNo) {
        return ResponseEntity.ok(announcementService.selectAnnouncement(annNo));
    }

    @ResponseBody
    @PostMapping
    public ResponseEntity<?> insert(@RequestBody AnnouncementVO announcementVO) {
        announcementVO.setWrtrId("admin");
        announcementVO.setTopFixYn("N");
        announcementVO.setDelYn("N");
        announcementVO.setOpnYn("Y");

        int result = announcementService.insertAnnouncement(announcementVO);

        Map<String, Object> map = new HashMap<>();
        map.put("success", result > 0);
        return ResponseEntity.ok(map);
    }

    @ResponseBody
    @PutMapping("/{annNo}")
    public ResponseEntity<?> update(
            @PathVariable String annNo,
            @RequestBody AnnouncementVO announcementVO
    ) {
        announcementVO.setAnnNo(annNo);

        int result = announcementService.updateAnnouncement(announcementVO);

        Map<String, Object> map = new HashMap<>();
        map.put("success", result > 0);
        return ResponseEntity.ok(map);
    }

    @ResponseBody
    @DeleteMapping("/{annNo}")
    public ResponseEntity<?> delete(@PathVariable String annNo) {
        int result = announcementService.deleteAnnouncement(annNo);

        Map<String, Object> map = new HashMap<>();
        map.put("success", result > 0);
        return ResponseEntity.ok(map);
    }
}