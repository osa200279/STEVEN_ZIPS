package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import kr.or.ddit.domain.central.admin.service.IAplctService;
import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@CrossOrigin(origins = "http://localhost:7777")
@RestController
@PreAuthorize("hasRole('ADMIN')")
@RequestMapping("/api/react/adm")
public class AdmDashBoardRestController {

    @Autowired
    private IAplctService aplctService;

    // 리액트 페이지로 로그인한 관리자 정보를 넘김
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/info")
    public ResponseEntity<?> getAdminInfo(@AuthenticationPrincipal CustomUser customUser) {
        if (customUser == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("인증 정보가 없습니다.");
        }
        AdmVO adm = (AdmVO) customUser.getMember();

        log.info("## 리액트 레이아웃에서 관리자 정보 요청함: {}", adm.getUserNm());

        return ResponseEntity.ok(adm);
    }

    // 청약 신청 목록 조회
    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/aplct")
    public ResponseEntity<List<AplctDTO>> getAplctList() {
        // log.info("#####청약 신청 리스트 컨트롤러 진입!!");
        try {
            List<AplctDTO> list = aplctService.selectAplctList();
            // log.info("##### 청약 리스트 : {}", list);
            if (list.isEmpty()) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    // 청약 신청 처리(업데이트)
    @PreAuthorize("hasRole('ADMIN')")
    @PutMapping("/aplct/upd")
    public ResponseEntity<Integer> updAplct(@RequestBody Map<String, Object> params) {

        String aplctSttsCd = (String) params.get("aplctSttsCd");
        List<String> aplctNos = (List<String>) params.get("aplctNos");

        int cnt = aplctService.approveAplct(aplctNos, aplctSttsCd);

        return cnt > 0 ? ResponseEntity.ok(cnt)
                : ResponseEntity.badRequest().body(0);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/ctrt")
    public ResponseEntity<List<AplctDTO>> getCtrtList() {
         log.info("#####계약 리스트 컨트롤러 진입!!");
        try {
            List<AplctDTO> list = aplctService.selectAplctList();
             log.info("##### 청약 리스트 : {}", list);
            if (list.isEmpty()) {
                return ResponseEntity.noContent().build();
            }
            return ResponseEntity.ok(list);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

}
