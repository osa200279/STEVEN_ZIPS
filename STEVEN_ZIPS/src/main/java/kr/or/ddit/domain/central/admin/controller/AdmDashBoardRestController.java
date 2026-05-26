package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.common.util.BusinessException;
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
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
    public ResponseEntity<?> updAplct(@RequestBody Map<String, Object> params,
                                        @AuthenticationPrincipal CustomUser customUser) {
        log.info("#### 상태 변경 진입 :" + params);
        MemberVO member = customUser.getMember();
        AdmVO adm = (AdmVO) member;

        List<Map<String, Object>> updateList = (List<Map<String, Object>>) params.get("aplctMapList");

        if (updateList == null || updateList.isEmpty()) {
            return ResponseEntity.badRequest().body(0);
        }

        // 최종 승인시 가계약 인서트 및 담당자 인서트
        try {
            int cnt = aplctService.approveAplct(updateList, adm.getUserNo());
            // 서비스에 트랜잭셔널 어노테이션을 써서 어떠한 값이 오더라도 성공으로 간주
            // (쿼리에 익명블록 사용으로 성공해도 -1의 값이 올 수 있음)
            return cnt != 0 ? ResponseEntity.ok(cnt)
                    : ResponseEntity.badRequest().body(0);
        }catch (BusinessException e) {
            // 임대 매물이 없을시 서비스에서 받은 에러 메시지 프론트에 보냄
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/ctrt")
    public ResponseEntity<Map<String, Object>> getCtrtList(
            @AuthenticationPrincipal CustomUser customUser,
            @RequestParam(value = "page", required = false, defaultValue = "1") int curPage
    ) {
        log.info("getCtrtList() 실행");
        String userNo = customUser.getMember().getUserNo();

        // 리액트용 페이징
        int screenSize = 12;
        int startRow = (curPage - 1) * screenSize + 1;
        int endRow = curPage * screenSize;

        // 서비스에 startRow, endRow를 넘겨서 한페이지만큼만 리스트 가져오기
        List<Map<String, Object>> ctrtList = rentCtrtService.selectCtrt(startRow, endRow);

        int totalRecord = rentCtrtService.selectCtrtCount(userNo);
        int totalPage = (int) Math.ceil((double) totalRecord / (double) screenSize);

        Map<String, Object> response = new HashMap<>();
        response.put("ctrtList", ctrtList);
        response.put("curPage", curPage);
        response.put("totalPage", totalPage);
        response.put("totalRecord", totalRecord);
        log.info("### ctrtList : {}", response.get("ctrtList"));

        return ResponseEntity.ok(response);
    }

    @PreAuthorize("hasRole('ADMIN')")
    @GetMapping("/ctrt/dashboard")
    public ResponseEntity<Map<String, Object>> getCtrtDashboard(){
        log.info("계약 대시보드 컨트롤러 진입");

        Map<String, Object> dashboard = rentCtrtService.selectCtrtDashboard();

        Map<String, Object> response = new HashMap<>();
        response.put("dashboard", dashboard);
        log.info("## dashboard : {}", response.get("dashboard"));

        return ResponseEntity.ok(response);
    }

    @GetMapping("ctrt/detail/{RENT_CTRT_NO}")
    public ResponseEntity<?> getCtrtDetail(@PathVariable("RENT_CTRT_NO") String rentCtrtNo){
        log.info("계약 상세 컨트롤러 진입, rentCtrtNo : {}", rentCtrtNo);
        Map<String, Object> response = new HashMap<>();

        Map<String, Object> ctrtDetail = rentCtrtService.selectOneCtrtDetail(rentCtrtNo);
        if (ctrtDetail == null) {
            return ResponseEntity.badRequest().body(null);
        }
        log.info("## ctrtDetail : {}", ctrtDetail);
        response.put("ctrtDetail", ctrtDetail);

        return ResponseEntity.ok(response);
    }

    @PutMapping("/ctrt/update/{RENT_CTRT_NO}")
    public ResponseEntity<?> updateCtrt(
            @PathVariable("RENT_CTRT_NO") String rentCtrtNo, @RequestBody Map<String, Object> detail) {
        log.info("계약 업데이트 컨트롤러 진입");

        int res = rentCtrtService.updateCtrt(rentCtrtNo, detail);

        if(res == 0){
            return ResponseEntity.badRequest().body("계약 정보 수정 실패");
        }

        return ResponseEntity.ok().build();
    }
}
