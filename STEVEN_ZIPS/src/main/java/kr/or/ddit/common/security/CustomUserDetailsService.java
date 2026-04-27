package kr.or.ddit.common.security;

import kr.or.ddit.domain.member.mapper.IMemberMapper;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class CustomUserDetailsService implements UserDetailsService{

	@Autowired
	private IMemberMapper memberMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.info("## CustomUserDetailsService.loadUserByUsername() 실행...!");
		log.info("## username : " + username);
		
		MemberVO member = memberMapper.readByUserInfo(username);
		log.info("## member : " + member);

		// 넘겨받은 member가 null인 경우라면 UsernameNotFoundException 에러에 의해 회원정보가 존재하지 않는다는
		// 에러를 응답으로 출력한다.
		return member == null ? null : new CustomUser(member);
	}
}
