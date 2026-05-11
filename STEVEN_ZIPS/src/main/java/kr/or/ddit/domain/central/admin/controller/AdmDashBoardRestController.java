package kr.or.ddit.domain.central.admin.controller;

import kr.or.ddit.domain.member.admin.vo.AdmVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@PreAuthorize("hasRole('ADMIN')")
@RequestMapping("/api/react/adm")
public class AdmDashBoardRestController {

    // 리액트 페이지로 로그인한 관리자 정보를 넘김
    @GetMapping("/info")
    public ResponseEntity<?> getAdminInfo(@AuthenticationPrincipal CustomUser customUser){
        if(customUser == null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("인증 정보가 없습니다.");
        }
        AdmVO adm = (AdmVO)customUser.getMember();

        log.info("## 리액트 레이아웃에서 관리자 정보 요청함: {}", adm.getUserNm());

        return ResponseEntity.ok(adm);
    }
}
