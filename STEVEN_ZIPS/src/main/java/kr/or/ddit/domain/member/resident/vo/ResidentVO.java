package kr.or.ddit.domain.member.resident.vo;

import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class ResidentVO extends MemberVO {
    // 필드
    private String inoutCd;         // 입퇴거 코드(여부)
    private Date moveInDt;          // 입주일
    private Date moveOutDt;         // 퇴거일
    private char headYn = 'N';      // 세대주 여부

    private List<MyAptVO> myAptList;    // 거주지 리스트

}
