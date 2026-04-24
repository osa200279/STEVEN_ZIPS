package kr.or.ddit.domain.member.mapper;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IMemberMapper {

    // 로그인 시큐리티 인증시 유저정보 가져오기
    MemberVO readByUserInfo(String username);

    int joinMember(MemberVO member);

    void addAuth(String userNo);
}
