package kr.or.ddit.domain.apartment.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class AptBassDto {

    private String kaptCode;
    private String kaptName;
    private String kaptAddr;
    private String codeSaleNm;
    private String codeHeatNm;

    private double kaptTarea; // 실수

    private String kaptDongCnt;
    private int kaptdaCnt;

    private String kaptBcompany;
    private String kaptAcompany;
    private String kaptTel;
    private String kaptUrl;
    private String codeAptNm;
    private String doroJuso;
    private String codeMgrNm;
    private String codeHallNm;

    private String kaptUsedate; // 날짜지만 문자열로 받는게 안전

    private String kaptFax;

    private int hoCnt;

    private double kaptMarea;

    private int kaptMparea60;
    private int kaptMparea85;
    private int kaptMparea135;
    private int kaptMparea136;

    private String privArea; // 얘도 문자열로 오는 경우 있음

    private String bjdCode;

    private int kaptTopFloor;
    private int ktownFlrNo;
    private int kaptBaseFloor;

    private int kaptdEcntp;

    private String zipcode;
}
