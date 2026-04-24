package kr.or.ddit.domain.apiApartment.vo;

import lombok.Data;

import java.util.Date;

@Data
public class AptInfraEntity {
    private String infraNo;
    private String infraNm;
    private String categoryCd;
    private Date regDt;
    private String aptCmplexNo;
    private String trvlTmRng;
}
