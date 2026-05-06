package kr.or.ddit.domain.central.admin.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@Controller
@RestController("/api")
public class AdmDashBoardRestController {

    @PreAuthorize("hasRole('MEMBER')")
    @ResponseBody
    @GetMapping("/test")
    public ResponseEntity<String> test(){

        return null;
    }
}
