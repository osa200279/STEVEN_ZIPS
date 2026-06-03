package kr.or.ddit.domain.apt.mgmtOffice.broadcast.service;

import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.texttospeech.v1.AudioConfig;
import com.google.cloud.texttospeech.v1.AudioEncoding;
import com.google.cloud.texttospeech.v1.SynthesisInput;
import com.google.cloud.texttospeech.v1.SynthesizeSpeechRequest;
import com.google.cloud.texttospeech.v1.SynthesizeSpeechResponse;
import com.google.cloud.texttospeech.v1.TextToSpeechClient;
import com.google.cloud.texttospeech.v1.TextToSpeechSettings;
import com.google.cloud.texttospeech.v1.VoiceSelectionParams;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.InputStream;

@Service
public class ManagerBroadcastServiceImpl implements IManagerBroadcastService {

    private static final String TTS_KEY_CLASSPATH = "tts-key.json";

    @Override
    public byte[] convertTextToSpeech(String text, String languageCode, String voiceName) throws Exception {
        GoogleCredentials credentials;
        try (InputStream in = new ClassPathResource(TTS_KEY_CLASSPATH).getInputStream()) {
            credentials = GoogleCredentials.fromStream(in);
        }

        TextToSpeechSettings settings = TextToSpeechSettings.newBuilder()
                .setCredentialsProvider(FixedCredentialsProvider.create(credentials))
                .build();

        try (TextToSpeechClient client = TextToSpeechClient.create(settings)) {
            SynthesisInput input = SynthesisInput.newBuilder().setText(text).build();
            VoiceSelectionParams voice = VoiceSelectionParams.newBuilder()
                    .setLanguageCode(languageCode)
                    .setName(voiceName)
                    .build();
            AudioConfig audioConfig = AudioConfig.newBuilder()
                    .setAudioEncoding(AudioEncoding.MP3)
                    .build();

            SynthesizeSpeechResponse response = client.synthesizeSpeech(
                    SynthesizeSpeechRequest.newBuilder()
                            .setInput(input)
                            .setVoice(voice)
                            .setAudioConfig(audioConfig)
                            .build());

            byte[] audio = response.getAudioContent().toByteArray();
            if (!isLikelyMp3(audio)) {
                throw new IllegalStateException("TTS 응답이 유효한 MP3가 아닙니다.");
            }
            return audio;
        }
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
        String query = "text=" + URLEncoder.encode(text, StandardCharsets.UTF_8)
                + "&languageCode=" + URLEncoder.encode(languageCode, StandardCharsets.UTF_8)
                + "&voiceName=" + URLEncoder.encode(voiceName, StandardCharsets.UTF_8);
        URI uri = URI.create(ttsServiceBase + "/tts/synthesize?" + query);

        HttpRequest request = HttpRequest.newBuilder().uri(uri).GET().build();
        HttpResponse<byte[]> response = HttpClient.newHttpClient()
                .send(request, HttpResponse.BodyHandlers.ofByteArray());

        if (response.statusCode() != 200) {
            throw new IllegalStateException("TTS 서비스 오류: HTTP " + response.statusCode());
        }
        byte[] audio = response.body();
        if (!isLikelyMp3(audio)) {
            throw new IllegalStateException("TTS 서비스 응답이 유효한 MP3가 아닙니다.");
        }
        return audio;
    }

    private static String trimTrailingSlash(String base) {
        if (base == null || base.isBlank()) {
            return "http://localhost:8060";
        }
        String trimmed = base.trim();
        while (trimmed.endsWith("/")) {
            trimmed = trimmed.substring(0, trimmed.length() - 1);
        }
        return trimmed;
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
