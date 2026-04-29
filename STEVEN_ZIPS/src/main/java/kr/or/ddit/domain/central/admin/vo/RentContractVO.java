package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

import java.util.Date;

@Data
public class RentContractVO {

    private String rentCtrtNo;
    private String rentLstgNo;
    private String ctrtId;
    private String mvinYn;
    private String mvinDt;
    private String mvoutDt;
    private String mvoutCmplDt;
    private Date regDt;
    private Date mdfDt;
    private String ctrtSttsCd;
    private long ctrtAmt;
    private long midPayAmt;
    private long balAmt;
    private long dpstAmt;
    private long mthlyRentAmt;
    private String userNo;

}
