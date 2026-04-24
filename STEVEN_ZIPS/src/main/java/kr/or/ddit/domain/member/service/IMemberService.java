package kr.or.ddit.domain.member.service;

import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.domain.member.vo.MemberVO;

import java.util.Map;

public interface IMemberService {

    ServiceResult joinMember(MemberVO member);
    ServiceResult updateMember(MemberVO member);

    void deleteMember(String userNo);

    void updatePassword(String userNo, String newPw);

    MemberVO getMemberByUserNo(String userNo);

    void updateAlarm(Map<String, Object> param);
}
