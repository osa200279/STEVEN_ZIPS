package kr.or.ddit.domain.apt.mgmtOffice.broadcast.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Google Cloud TTS REST 호출 (tts-key.json + google-auth 1.19).
 * google-cloud-texttospeech 클라이언트(gax)는 Drive용 auth 버전과 충돌하여 사용하지 않음.
 */
@Service
@Slf4j
public class ManagerBroadcastServiceImpl implements IManagerBroadcastService {

    private static final String TTS_KEY_CLASSPATH = "tts-key.json";
    private static final String TTS_SCOPE = "https://www.googleapis.com/auth/cloud-platform";
    private static final String TTS_REST_URL = "https://texttospeech.googleapis.com/v1/text:synthesize";

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    public byte[] convertTextToSpeech(String text, String languageCode, String voiceName) throws Exception {
        String accessToken = obtainAccessToken();

        Map<String, Object> input = new LinkedHashMap<>();
        input.put("text", text);

        Map<String, Object> voice = new LinkedHashMap<>();
        voice.put("languageCode", languageCode);
        voice.put("name", voiceName);

        Map<String, Object> audioConfig = new LinkedHashMap<>();
        audioConfig.put("audioEncoding", "MP3");

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("input", input);
        body.put("voice", voice);
        body.put("audioConfig", audioConfig);

        String json = objectMapper.writeValueAsString(body);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(TTS_REST_URL))
                .header("Authorization", "Bearer " + accessToken)
                .header("Content-Type", "application/json; charset=UTF-8")
                .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = HttpClient.newHttpClient()
                .send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

        if (response.statusCode() != 200) {
            String errBody = response.body();
            if (errBody != null && errBody.length() > 400) {
                errBody = errBody.substring(0, 400) + "...";
            }
            log.warn("Google TTS REST 실패 status={} body={}", response.statusCode(), errBody);
            throw new IllegalStateException("Google TTS REST 오류: HTTP " + response.statusCode());
        }

        JsonNode root = objectMapper.readTree(response.body());
        JsonNode audioNode = root.get("audioContent");
        if (audioNode == null || audioNode.isNull() || !audioNode.isTextual()) {
            throw new IllegalStateException("Google TTS 응답에 audioContent 없음");
        }

        byte[] audio = Base64.getDecoder().decode(audioNode.asText());
        if (!isLikelyMp3(audio)) {
            throw new IllegalStateException("TTS 응답이 유효한 MP3가 아닙니다.");
        }
        return audio;
    }

    private String obtainAccessToken() throws Exception {
        ClassPathResource keyResource = new ClassPathResource(TTS_KEY_CLASSPATH);
        if (!keyResource.exists()) {
            throw new IllegalStateException("classpath에 tts-key.json이 없습니다.");
        }
        GoogleCredentials credentials;
        try (InputStream in = keyResource.getInputStream()) {
            credentials = GoogleCredentials.fromStream(in)
                    .createScoped(Collections.singletonList(TTS_SCOPE));
        }
        credentials.refreshIfExpired();
        if (credentials.getAccessToken() == null) {
            throw new IllegalStateException("Google TTS access token 발급 실패");
        }
        return credentials.getAccessToken().getTokenValue();
    }

    /*
     * [도커 TTS 미사용] 외부 TTS 도커(8060) HTTP 프록시 — 주석 보관
     *
    private final String ttsServiceBase;

    public ManagerBroadcastServiceImpl(
            @Value("${tts.service.base-url:http://localhost:8060}") String ttsServiceBase) {
        this.ttsServiceBase = trimTrailingSlash(ttsServiceBase);
    }

    public byte[] convertTextToSpeechDocker(String text, String languageCode, String voiceName) throws Exception {
        ...
    }
     */

    private boolean isLikelyMp3(byte[] audio) {
        if (audio == null || audio.length < 128) {
            return false;
        }
        if (audio[0] == (byte) 0xFF && (audio[1] & 0xE0) == 0xE0) {
            return true;
        }
        return audio[0] == 0x49 && audio[1] == 0x44 && audio[2] == 0x33;
    }
}
