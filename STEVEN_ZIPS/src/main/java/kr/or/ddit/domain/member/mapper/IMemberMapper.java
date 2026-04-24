package kr.or.ddit.domain.member.mapper;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.Map;

@Mapper
public interface IMemberMapper {

    // 로그인 시큐리티 인증시 유저정보 가져오기
    MemberVO readByUserInfo(String username);

    int joinMember(MemberVO member);
    int updateMember(MemberVO member);

    void addAuth(String userNo);

    void updatePassword(String userNo, String encodedPw);

    void deleteMember(String userNo);

    MemberVO getMemberByUserNo(String userNo);

    void updateAlarm(Map<String, Object> param);
}
