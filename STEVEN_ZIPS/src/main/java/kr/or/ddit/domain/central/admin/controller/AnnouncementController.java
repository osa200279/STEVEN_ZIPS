package kr.or.ddit.domain.central.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
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

    /**
     * 공고 관리 JSP 화면 이동
     */
    @GetMapping
    public String announcementPage() {
        return "centralAdmin/announcement";
    }

    /**
     * 공고 목록 조회 API
     */
    @ResponseBody
    @GetMapping("/list")
    public ResponseEntity<?> list(AnnouncementDTO searchVO) {
        return ResponseEntity.ok(announcementService.selectAnnouncementList(searchVO));
    }

    /**
     * 공고 상세 조회 API
     */
    @ResponseBody
    @GetMapping("/{annNo}")
    public ResponseEntity<?> detail(@PathVariable String annNo) {
        return ResponseEntity.ok(announcementService.selectAnnouncement(annNo));
    }

    /**
     * 공고 등록 API
     */
    @ResponseBody
    @PostMapping
    public ResponseEntity<?> insert(@RequestBody AnnouncementDTO announcementDTO) {

        /*
          임시 작성자 ID
          → 나중에는 로그인한 중앙관리자 ID로 교체하는 것이 실무 방식.
        */
        announcementDTO.setWrtrId("admin");

        /*
          기본값 세팅
          → DB NOT NULL 또는 기본 상태 처리를 위해 사용.
        */
        announcementDTO.setTopFixYn("N");
        announcementDTO.setDelYn("N");
        announcementDTO.setOpnYn("Y");

        int result = announcementService.insertAnnouncement(announcementDTO);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);
        resultMap.put("annNo", announcementDTO.getAnnNo());

        return ResponseEntity.ok(resultMap);
    }

    /**
     * 공고 수정 API
     */
    @ResponseBody
    @PutMapping("/{annNo}")
    public ResponseEntity<?> update(
            @PathVariable String annNo,
            @RequestBody AnnouncementDTO announcementDTO
    ) {
        announcementDTO.setAnnNo(annNo);

        int result = announcementService.updateAnnouncement(announcementDTO);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);

        return ResponseEntity.ok(resultMap);
    }

    /**
     * 공고 삭제 API
     *
     * 실제 DELETE가 아니라 DEL_YN = 'Y'로 변경한다.
     */
    @ResponseBody
    @DeleteMapping("/{annNo}")
    public ResponseEntity<?> delete(@PathVariable String annNo) {

        int result = announcementService.deleteAnnouncement(annNo);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);

        return ResponseEntity.ok(resultMap);
    }

    /**
     * 단지 목록 조회 API
     */
    @ResponseBody
    @GetMapping("/aptComplexList")
    public List<AnnouncementDTO> aptComplexList() {
        return announcementService.selectAptComplexList();
    }
}