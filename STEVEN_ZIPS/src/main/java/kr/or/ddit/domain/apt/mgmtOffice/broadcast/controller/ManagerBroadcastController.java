package kr.or.ddit.domain.apt.mgmtOffice.broadcast.controller;


import kr.or.ddit.domain.apt.mgmtOffice.broadcast.service.ManagerBroadcastServiceImpl;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ManagerBroadcastController {

    private final ManagerBroadcastServiceImpl managerBroadcastService;

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping("/tts/synthesize/{mgmtOfcNo}")
    public ResponseEntity<byte[]> synthesize(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam String text,
            @RequestParam(defaultValue = "ko-KR") String languageCode,
            @RequestParam(defaultValue = "ko-KR-Standard-A") String voiceName) {
        try {
            byte[] audio = managerBroadcastService.convertTextToSpeech(text, languageCode, voiceName);
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_TYPE, "audio/mpeg")
                    .body(audio);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}

