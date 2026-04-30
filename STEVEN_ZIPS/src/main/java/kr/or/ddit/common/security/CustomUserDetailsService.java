package kr.or.ddit.common.security;

import kr.or.ddit.common.util.member.resident.InoutCd;
import kr.or.ddit.domain.manager.vo.MngrVO;
import kr.or.ddit.domain.member.admin.AdminVO;
import kr.or.ddit.domain.member.mapper.IMemberMapper;
import kr.or.ddit.domain.member.resident.mapper.IResidentMapper;
import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.CustomUser;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.springframework.beans.BeanUtils;
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
	private IResidentMapper residentMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.info("## CustomUserDetailsService.loadUserByUsername() 실행...!");
		log.info("## username : " + username);
		
		MemberVO member = memberMapper.readByUserInfo(username);
		log.info("## member : " + member);

		String auth = member.getAuthList().get(0).getAuth();

		if("ROLE_RESIDENT".equals(auth)){
			ResidentVO resident = residentMapper.getResidentInfo(member.getUserNo());

			if(resident != null && InoutCd.LIVE == resident.getInoutCd()){	// LIVE(입주중) 상태이면 입주민으로 판단
				// BeanUtils.copyProperties(source, target) source와 target의 공통된 필드를 매핑해서 target에 복사(같은 이름 필드끼리 자동맵핑)
				BeanUtils.copyProperties(member, resident);
				member = resident;	// 다형성 이용
			}
		}else if("ROLE_MNGR".equals(auth)){
            MngrVO mngrVO;

		}else if("ROLE_ADMIN".equals(auth)){
			AdminVO adminVO;

		}

		// 넘겨받은 member가 null인 경우라면 UsernameNotFoundException 에러에 의해 회원정보가 존재하지 않는다는
		// 에러를 응답으로 출력한다.
		return member == null ? null : new CustomUser(member);
	}
}
