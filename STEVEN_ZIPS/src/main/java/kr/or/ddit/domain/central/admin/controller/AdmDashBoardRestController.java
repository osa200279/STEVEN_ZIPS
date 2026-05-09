package kr.or.ddit.domain.central.admin.controller;

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
@RequestMapping("/react")
public class AdmDashBoardRestController {

    @PreAuthorize("hasRole('MEMBER')")
    @GetMapping("/test")
    public ResponseEntity<String> test(@AuthenticationPrincipal CustomUser customUser){
        String auth = customUser.getMember().getAuthList().get(0).getAuth();
        log.info("## auth:{}", auth);
        return new ResponseEntity<>(auth , HttpStatus.OK);
    }


}
