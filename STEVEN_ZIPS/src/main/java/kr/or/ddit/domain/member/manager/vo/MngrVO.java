package kr.or.ddit.domain.member.manager.vo;

import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.Data;

@Data
public class MngrVO extends MemberVO {

    private String mgmtOfcNo;
    private String mngrDutyCd;

}
