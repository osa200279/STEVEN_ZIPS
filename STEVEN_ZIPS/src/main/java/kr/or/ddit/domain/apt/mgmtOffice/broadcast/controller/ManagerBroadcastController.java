package kr.or.ddit.domain.apt.mgmtOffice.broadcast.controller;


import kr.or.ddit.domain.apt.mgmtOffice.broadcast.service.ManagerBroadcastServiceImpl;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ManagerBroadcastController {

    private final ManagerBroadcastServiceImpl managerBroadcastService;

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @GetMapping(value = "/tts/synthesize/{mgmtOfcNo}", produces = "audio/mpeg")
    public ResponseEntity<byte[]> synthesizeGet(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam String text,
            @RequestParam(defaultValue = "ko-KR") String languageCode,
            @RequestParam(defaultValue = "ko-KR-Standard-C") String voiceName) {
        return synthesize(mgmtOfcNo, principal, text, languageCode, voiceName);
    }

    @PreAuthorize("@authService.hasAccess(principal, #mgmtOfcNo)")
    @PostMapping(value = "/tts/synthesize/{mgmtOfcNo}", produces = "audio/mpeg")
    public ResponseEntity<byte[]> synthesize(
            @PathVariable String mgmtOfcNo,
            @AuthenticationPrincipal CustomUser principal,
            @RequestParam String text,
            @RequestParam(defaultValue = "ko-KR") String languageCode,
            @RequestParam(defaultValue = "ko-KR-Standard-C") String voiceName) {
        try {
            if (text == null || text.isBlank()) {
                return ResponseEntity.badRequest().build();
            }
            byte[] audio = managerBroadcastService.convertTextToSpeech(text.trim(), languageCode, voiceName);
            if (audio == null || audio.length < 128) {
                log.warn("TTS 빈 응답 mgmtOfcNo={}, voice={}, textLen={}", mgmtOfcNo, voiceName, text.length());
                return ResponseEntity.unprocessableEntity().build();
            }
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("audio/mpeg"))
                    .header(HttpHeaders.CACHE_CONTROL, "no-store")
                    .body(audio);
        } catch (Throwable t) {
            log.error("TTS 변환 실패 mgmtOfcNo={}, voice={}, textLen={}", mgmtOfcNo, voiceName, text != null ? text.length() : 0, t);
            return ResponseEntity.internalServerError().build();
        }
    }
}

