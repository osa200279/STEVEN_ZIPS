package kr.or.ddit.domain.member.manager.vo;

import kr.or.ddit.domain.member.resident.vo.ResidentVO;
import kr.or.ddit.domain.member.vo.MemberVO;
import lombok.Data;

@Data
public class MngrVO extends MemberVO {

    private String mgmtOfcNo;   // 관리사무소 번호
    private String mngrDutyCd;  // 직무

    // 관리사무소 테이블 조인
    private String mgmtOfcNm;   // 관리사무소 명
    private String AptCmplexNo; // 아파트 단지 번호
}
