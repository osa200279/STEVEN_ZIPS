package kr.or.ddit.domain.member.manager.vo;

import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.MemberVO;

public class MngrVO extends MemberVO {

    private String mgmtOfcNo;
    private String mgnrDutyCd;

    // 단지관리자이면서 어딘가의 입주민일 때
    private ResidentVO resident;
}
