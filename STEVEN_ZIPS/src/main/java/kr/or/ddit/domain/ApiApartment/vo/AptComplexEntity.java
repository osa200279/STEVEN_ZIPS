package kr.or.ddit.domain.ApiApartment.vo;

import lombok.Data;

@Data
public class AptComplexEntity {

    private String aptCmplexNo;
    private String aptCmplexNm;
    private String bjdCd;
    private String sidoNm;
    private String sigunguNm;
    private String emdNm;
    private int latVal;
    private int lonVal;
    private int unitCnt;
    private int bldYr;
    private String cnscoNm;

    private String imgFileNo;
    private String rprsntImgFileNo;
    private String heatTyCd;
    private int pkgCnt;
    private int maxFloor;
    private int freePkgCnt;
    private int dongCnt;
    private String dorojuso;
}
