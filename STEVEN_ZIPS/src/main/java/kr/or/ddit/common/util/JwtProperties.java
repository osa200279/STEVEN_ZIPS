package kr.or.ddit.common.util;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties("kr.or.ddit.jwt")
public class JwtProperties {
    private String issuer;
    private String secretKey;
}
