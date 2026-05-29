package kr.or.ddit.domain.apt.mgmtOffice.broadcast.service;

import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.texttospeech.v1.*;
import com.google.cloud.texttospeech.v1.TextToSpeechClient;
import org.springframework.stereotype.Service;

@Service
public class ManagerBroadcastServiceImpl implements IManagerBroadcastService {

    @Override
    public byte[] convertTextToSpeech(String text, String languageCode, String voiceName) throws Exception {

        GoogleCredentials credentials = GoogleCredentials.fromStream(
                getClass().getResourceAsStream("/tts-key.json")
        );

        try (TextToSpeechClient client = TextToSpeechClient.create(
                TextToSpeechSettings.newBuilder()
                        .setCredentialsProvider(FixedCredentialsProvider.create(credentials))
                        .build()
        )) {
            SynthesisInput input = SynthesisInput.newBuilder().setText(text).build();
            VoiceSelectionParams voice = VoiceSelectionParams.newBuilder()
                    .setLanguageCode(languageCode)
                    .setName(voiceName)
                    .build();
            AudioConfig audioConfig = AudioConfig.newBuilder()
                    .setAudioEncoding(AudioEncoding.MP3)
                    .build();

            return client.synthesizeSpeech(input, voice, audioConfig)
                    .getAudioContent()
                    .toByteArray();
        }
    }
}
