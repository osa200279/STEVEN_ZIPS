package kr.or.ddit.domain.apartment.vo;

import lombok.Data;

@Data
public class AptComplexEntity {
    private String imgFileNo;
    private String rprsntImgFileNo;
    private String heatTyCd;
    private int pkgCnt;
    private int maxFloor;
    private int freePkgCnt;
    private int dongCnt;
    private String dorojuso;
}
