package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.domain.central.admin.dto.AplctDTO;
import kr.or.ddit.domain.central.admin.service.IAplctService;
import kr.or.ddit.domain.central.rentCtrt.service.IRentCtrtService;
import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@CrossOrigin(origins = "http://localhost:7777")
@RestController
@PreAuthorize("hasRole('ADMIN')")
@RequestMapping("/api/react/adm")
public class AdmDashBoardRestController {

    @Autowired
    private IAplctService aplctService;

    @Autowired
    private IRentCtrtService rentCtrtService;

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
        try {
            List<AplctDTO> list = aplctService.selectAplctList();

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
    public ResponseEntity<Integer> updAplct(@RequestBody Map<String, Object> params,
                                            @AuthenticationPrincipal CustomUser customUser) {
        log.info("#### 상태 변경 진입 :" + params);
        MemberVO member = (MemberVO) customUser.getMember();
        AdmVO adm = (AdmVO) member;

        List<Map<String, Object>> updateList = (List<Map<String, Object>>) params.get("aplctMapList");

        if (updateList == null || updateList.isEmpty()) {
            return ResponseEntity.badRequest().body(0);
        }

        // 최종 승인시 가계약 인서트 및 담당자 인서트
        int cnt = aplctService.approveAplct(updateList, adm.getUserNo());

        // 서비스에 트랜잭셔널 어노테이션을 써서 어떠한 값이 오더라도 성공으로 간주
        // (쿼리에 익명블록 사용으로 성공해도 -1의 값이 올 수 있음)
        return cnt != 0 ? ResponseEntity.ok(cnt)
                : ResponseEntity.badRequest().body(0);
    }


    // 임대 계약 생성 및 담당자 배정
    @PreAuthorize("hasRole('ADMIN')")
    @PostMapping("/ctrt/make")
    public ResponseEntity<?> makeCtrt(
            @AuthenticationPrincipal CustomUser customUser
            , String aplctNo) {

        return null;
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/ctrt")
    public ResponseEntity<?> getCtrtList() {

        return null;
    }

}
