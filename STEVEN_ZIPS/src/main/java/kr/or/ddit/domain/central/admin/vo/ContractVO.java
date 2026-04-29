package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

import java.util.Date;

@Data
public class ContractVO {

    private String rentCtrtNo;
    private String rentLstgNo;
    private String ctrtId;
    private String mvinYn;
    private Date mvinDt;
    private Date mvoutDt;
    private Date mvoutCmplDt;
    private Date regDt;
    private Date mdfDt;
    private String ctrtSttsCd;
    private long CTRT_AMT;
    private long midPayAmt;
    private long balAmt;
    private long dpstAmt;
    private long mthlyRentAmt;
    private String userNo;

    private String userId;
    private String rentTypeCd;
    private String aptCmplexNm;
    private String hoNo;
    private String dongNo;
    private String ctrtSttsNm;
    private String rentTypeNm;
    private String mgrNm;

}
