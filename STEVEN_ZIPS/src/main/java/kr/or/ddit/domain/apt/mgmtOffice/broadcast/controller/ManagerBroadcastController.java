package kr.or.ddit.domain.apt.mgmtOffice.broadcast.controller;

import kr.or.ddit.domain.apt.mgmtOffice.broadcast.service.ManagerBroadcastServiceImpl;
import kr.or.ddit.domain.member.vo.CustomUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
    @GetMapping(value = "/tts/synthesize/{mgmtOfcNo}", produces = "audio/mpeg") // → GET 요청, 응답은 audio/mpeg 형식
    public ResponseEntity<byte[]> synthesizeGet(
            @PathVariable String mgmtOfcNo,     // URL의 {mgmtOfcNo}값
            @AuthenticationPrincipal CustomUser principal,      // 로그인한 유저 정보
            @RequestParam String text,          // 변환할 텍스트
            @RequestParam(defaultValue = "ko-KR") String languageCode,      // 언어 (기본 한국어)
            @RequestParam(defaultValue = "ko-KR-Standard-C") String voiceName) {    // 음성 (기본 여성C)
        return synthesize(mgmtOfcNo, principal, text, languageCode, voiceName);     // POST 메서드로 위임
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
            // 1. 텍스트 유효성 검사
            if (text == null || text.isBlank()) {
                return ResponseEntity.badRequest().build();
            }
            // 2. tts 변환 실행
            byte[] audio = managerBroadcastService.convertTextToSpeech(text.trim(), languageCode, voiceName);

            // 3. 변환 결과 검증
            if (audio == null || audio.length < 128) {
                // MP3 최소 크기보다 작으면 비정상 응답
                log.warn("TTS 빈 응답 mgmtOfcNo={}, voice={}, textLen={}", mgmtOfcNo, voiceName, text.length());
                return ResponseEntity.unprocessableEntity().build();    // 422 에러
            }

            // 4. 정상 응답
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("audio/mpeg"))        // Content-Type 설정
                    .header(HttpHeaders.CACHE_CONTROL, "no-store")  // 캐시 저장 금지
                    .body(audio);   // MP3 바이트 배열 반환

            // 5. 예외 처리
        } catch (Throwable t) {
            log.error("TTS 변환 실패 mgmtOfcNo={}, voice={}, textLen={}", mgmtOfcNo, voiceName, text != null ? text.length() : 0, t);
            return ResponseEntity.internalServerError().build();    // 500 에러
        }
    }
}
