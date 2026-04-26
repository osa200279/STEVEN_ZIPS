package kr.or.ddit.domain.member.service;

import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.domain.member.vo.MemberVO;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

public interface IMemberService {

    ServiceResult joinMember(MemberVO member, MultipartFile profFile);

    ServiceResult updateMember(MemberVO member);

    void deleteMember(String userNo);

    void updatePassword(String userNo, String newPw);

    MemberVO getMemberByUserNo(String userNo);

    void updateAlarm(Map<String, Object> param);
}
