package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

import java.util.List;


@Data
public class ContractVO {

    private String rentCtrtNo;
    private String rentLstgNo;
    private String ctrtId;
    private String mvinYn;
    private String mvinDt;
    private String mvoutDt;
    private String mvoutCmplDt;
    private String regDt;
    private String mdfDt;
    private String ctrtSttsCd;
    private long ctrtAmt;
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
