package kr.or.ddit.domain.central.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ContractUserVO {

    private String sbmsnDocNo;
    private String sbmsnDocTyCd;
    private String sbmsnDocSttsCd;
    private String rjctRsnCn;
    private Date regDt;
    private Date mdfcnDt;
    private String atchFileId;
    private String rentCtrtNo;
    private String ctrtSttsCd;  // 계약상태코드
    private String tyNm;
}
