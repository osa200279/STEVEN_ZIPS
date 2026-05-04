package kr.or.ddit.common.util;

import io.jsonwebtoken.Header;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import kr.or.ddit.common.security.CustomUserDetailsService;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.Date;

@Slf4j
@Component
public class TokenProvider {

    @Autowired
    private JwtProperties jwtProperties;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    public String generateToken(MemberVO memberVO, Duration expiredAt){
        Date now = new Date();

        // 토큰 생성시, 현재시간 + 설정시간을 더한 기간으로 토큰을 생성한다.
        return makeToken(new Date(now.getTime() + expiredAt.toMillis()), memberVO);
    }

    /**
     *
     * @param expiry 만료시간
     * @param memberVO 유저 정보
     * @return
     */
    public String makeToken(Date expiry, MemberVO memberVO){
        Date now = new Date();
        return Jwts.builder()
                .setHeaderParam(Header.TYPE, Header.JWT_TYPE)   // 헤더
                // 공용설정
                .setIssuer(jwtProperties.getIssuer())
                .setIssuedAt(now)
                .setExpiration(expiry)
                .setSubject(memberVO.getUserNo())
                // 개인설정
                .claim("no", memberVO.getUserNo())
                .claim("id", memberVO.getUserId())
                .claim("auth", memberVO.getAuthList())
                // 서명 : 비밀키와 함께 해시값을 HS256방식으로 암호화한다.
                .signWith(SignatureAlgorithm.HS256, jwtProperties.getSecretKey().getBytes())
                .compact();
    }



}
