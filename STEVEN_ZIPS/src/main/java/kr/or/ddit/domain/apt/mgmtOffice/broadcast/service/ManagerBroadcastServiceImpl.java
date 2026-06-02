package kr.or.ddit.domain.apt.mgmtOffice.broadcast.service;

import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;

@Service
public class ManagerBroadcastServiceImpl implements IManagerBroadcastService {

    private static final String TTS_SERVICE_BASE = "http://localhost:8060";

    @Override
    public byte[] convertTextToSpeech(String text, String languageCode, String voiceName) throws Exception {
        String query = "text=" + URLEncoder.encode(text, StandardCharsets.UTF_8)
                + "&languageCode=" + URLEncoder.encode(languageCode, StandardCharsets.UTF_8)
                + "&voiceName=" + URLEncoder.encode(voiceName, StandardCharsets.UTF_8);
        URI uri = URI.create(TTS_SERVICE_BASE + "/tts/synthesize?" + query);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(uri)
                .GET()
                .build();

        HttpResponse<byte[]> response = HttpClient.newHttpClient()
                .send(request, HttpResponse.BodyHandlers.ofByteArray());

        if (response.statusCode() != 200) {
            throw new IllegalStateException(
                    "TTS 서비스 오류: HTTP " + response.statusCode());
        }

        byte[] audio = response.body();
        if (!isLikelyMp3(audio)) {
            throw new IllegalStateException("TTS 서비스 응답이 유효한 MP3가 아닙니다.");
        }
        return audio;
    }

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
