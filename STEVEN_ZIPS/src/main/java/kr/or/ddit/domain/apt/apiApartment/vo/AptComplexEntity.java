package kr.or.ddit.domain.apt.apiApartment.vo;

import lombok.Data;

@Data
public class AptComplexEntity {

    private String aptCmplexNo;
    private String aptCmplexNm;
    private String bjdCd;
    private String sidoNm;
    private String sigunguNm;
    private String emdNm;
    private double latVal;
    private double lonVal;
    private int unitCnt;
    private String bldYr;  //준공년도
    private String cnscoNm; // 시공사

    private String imgFileNo;
    private String rprsntImgFileNo;
    private String heatTy;
    private int pkgCnt;
    private int maxFloor;
    private int freePkgCnt;
    private int dongCnt;
    private String dorojuso;
}
