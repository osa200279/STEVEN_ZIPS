package kr.or.ddit.domain.apt.main.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class AptComplexVO {
    private String aptCmplexNo; // kAptCode
    private String aptCmplexNm;
    private String bjdCd;
    private String sidoNm;
    private String sigunguNm;
    private String emdNm;
    private BigDecimal latVal;  // 경도
    private BigDecimal lonVal;  // 위도
    private int unitCnt;
    private String bldYr;
    private String cnscoNm;
    private String imgFileNo;
    private String rprsntImgFileNo;
    private String heatTy;
    private int pkgCnt;
    private int maxFloor;
    private int freePkgCnt;
    private int dongCnt;
    private String dorojuso;
    private String ccCnt;
}
