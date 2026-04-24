package kr.or.ddit.domain.member.service;

import kr.or.ddit.common.ServiceResult;
import kr.or.ddit.domain.member.vo.MemberVO;

public interface IMemberService {

    ServiceResult joinMember(MemberVO member);

}
