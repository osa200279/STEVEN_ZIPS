package kr.or.ddit.common.sms.sender;

import kr.or.ddit.common.sms.dto.SmsReceiver;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;

/**
 * Solapi 실제 문자 발송기
 * 운영 환경에서 sms.sender-type=solapi 로 바꾸면 사용됩니다.
 * 테스트중이라 아직 사용안하는 중. - 김보라
 */
@Component
@RequiredArgsConstructor
@ConditionalOnProperty(name = "sms.sender-type", havingValue = "solapi")
public class SolapiSmsSender implements SmsSender {

    @Value("${solapi.api-key}")
    private String apiKey;

    @Value("${solapi.api-secret}")
    private String apiSecret;

    @Value("${solapi.from}")
    private String from;

    @Override
    public void send(SmsReceiver receiver, String message) {
        /*
         * 현재 발표용은 Mock을 사용할 것이므로 여기서는 구조만 만들어둡니다.
         * 실제 운영 시 Solapi SDK 의존성을 추가하고 이 안에서 API를 호출하면 됩니다.
         */
        throw new UnsupportedOperationException("Solapi 실제 발송은 운영 환경에서 SDK 연결 후 사용하세요.");
    }
}