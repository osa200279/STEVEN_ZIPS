package kr.or.ddit.domain.central.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import kr.or.ddit.domain.central.admin.service.IAnnouncementService;
import kr.or.ddit.domain.central.admin.dto.AnnouncementDTO;
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
     *
     * 동작 순서
     * 1. 브라우저에서 JSON으로 공고 정보를 보냄
     * 2. Controller가 기본값을 세팅함
     * 3. Service → Mapper → XML → DB INSERT 순서로 저장함
     */
    @ResponseBody
    @PostMapping
    public ResponseEntity<?> insert(@RequestBody AnnouncementDTO announcementDTO) {

    /*
      WRTR_ID란?
      → 작성자 아이디.
      왜 세팅?
      → DB의 WRTR_ID가 NOT NULL이면 값이 없을 때 INSERT 오류가 나기 때문.
      나중에는 "admin" 고정값 말고 로그인 사용자 ID로 바꾸는 게 실무 방식.
    */
        announcementDTO.setWrtrId("admin");

    /*
      TOP_FIX_YN이란?
      → 상단 고정 여부.
      N: 일반 공고
      Y: 상단 고정 공고
    */
        announcementDTO.setTopFixYn("N");

    /*
      DEL_YN이란?
      → 삭제 여부.
      N: 정상 공고
      Y: 삭제 처리된 공고
    */
        announcementDTO.setDelYn("N");

        int result = announcementService.insertAnnouncement(announcementDTO);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);

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
     */
    @ResponseBody
    @DeleteMapping("/{annNo}")
    public ResponseEntity<?> delete(@PathVariable String annNo) {

        int result = announcementService.deleteAnnouncement(annNo);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("success", result > 0);

        return ResponseEntity.ok(resultMap);
    }

    /*
      단지 목록 조회

      사용 이유
      → 공고 등록/검색 화면의 단지 select box 데이터 조회.
    */
    @ResponseBody
    @GetMapping("/aptComplexList")
    public List<AnnouncementDTO> aptComplexList() {

        return announcementService.selectAptComplexList();
    }
}