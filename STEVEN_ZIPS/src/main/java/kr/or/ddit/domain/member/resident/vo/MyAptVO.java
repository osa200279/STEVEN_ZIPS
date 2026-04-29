package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

@Data
public class MyAptVO {
    private String aptCmplexNo;    // 아파트 코드
    private String aptCmplexNm;    // 아파트 명
    private String dongNm;         // 동
    private String hoNo;           // 호수
    private String dorojuso;       // 도로명 주소
    private String bjdCd;          // 법정동 코드
}
