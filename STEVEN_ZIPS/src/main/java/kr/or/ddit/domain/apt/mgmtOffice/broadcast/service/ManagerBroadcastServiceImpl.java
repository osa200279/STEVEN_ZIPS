package kr.or.ddit.domain.apt.mgmtOffice.broadcast.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.google.auth.oauth2.GoogleCredentials;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Collections;

@Service
public class ManagerBroadcastServiceImpl implements IManagerBroadcastService {

    private static final String TTS_SCOPE = "https://www.googleapis.com/auth/cloud-platform";
    private static final String TTS_API_URL = "https://texttospeech.googleapis.com/v1/text:synthesize";
    private static final ObjectMapper MAPPER = new ObjectMapper();

    @Override
    public byte[] convertTextToSpeech(String text, String languageCode, String voiceName) throws Exception {
        GoogleCredentials credentials = loadCredentials();
        credentials.refreshIfExpired();

        ObjectNode body = MAPPER.createObjectNode();
        body.set("input", MAPPER.createObjectNode().put("text", text));
        ObjectNode voice = body.putObject("voice");
        voice.put("languageCode", languageCode);
        voice.put("name", voiceName);
        body.putObject("audioConfig").put("audioEncoding", "MP3");

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(TTS_API_URL))
                .header("Authorization", "Bearer " + credentials.getAccessToken().getTokenValue())
                .header("Content-Type", "application/json; charset=utf-8")
                .POST(HttpRequest.BodyPublishers.ofString(MAPPER.writeValueAsString(body), StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = HttpClient.newHttpClient()
                .send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));

        if (response.statusCode() != 200) {
            throw new IllegalStateException(
                    "Google TTS API 오류: HTTP " + response.statusCode() + " — " + response.body());
        }

        JsonNode json = MAPPER.readTree(response.body());
        JsonNode audioNode = json.path("audioContent");
        if (!audioNode.isTextual() || audioNode.asText().isBlank()) {
            throw new IllegalStateException("Google TTS API 응답에 audioContent가 없습니다.");
        }
        return Base64.getDecoder().decode(audioNode.asText());
    }

    private GoogleCredentials loadCredentials() throws Exception {
        InputStream keyStream = getClass().getResourceAsStream("/tts-key.json");
        if (keyStream == null) {
            throw new IllegalStateException("classpath에 tts-key.json이 없습니다.");
        }
        try (keyStream) {
            return GoogleCredentials.fromStream(keyStream)
                    .createScoped(Collections.singleton(TTS_SCOPE));
        }
    }
}
