package kr.or.ddit.domain.member.admin;

import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.MemberVO;

public class AdminVO extends MemberVO {

    private String deptNm;  // 부서 명
    private String pstnNm;  // 직위 명

    ResidentVO resident;    // 중앙관리자이면서 입주민인 경우
}
