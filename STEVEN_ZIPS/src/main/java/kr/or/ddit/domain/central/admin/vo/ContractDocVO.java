package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

// 계약 서류 페이지용 VO
@Data
public class ContractDocVO {

    private String sbmsnDocNo;
    private String sbmsnDocTyCd;
    private String sbmsnDocSttsCd;
    private String rjctRsnCn;
    private String regDt;
    private String mdfDt;
    private String atchFileId;
    private String rentCtrtNo;
    private String rentTypeCd;

}
