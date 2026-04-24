package kr.or.ddit.domain.ApiApartment.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class AptBass {

    private String kaptCode;
    private String kaptName;
    private String kaptAddr;
    private String codeSaleNm;
    private String codeHeatNm;

    private double kaptTarea;

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

    private String kaptUsedate;

    private String kaptFax;

    private int hoCnt;

    private double kaptMarea;

    private int kaptMparea60;
    private int kaptMparea85;
    private int kaptMparea135;
    private int kaptMparea136;

    private String privArea;

    private String bjdCode;

    private int kaptTopFloor;
    private int ktownFlrNo;
    private int kaptBaseFloor;

    private int kaptdEcntp;

    private String zipcode;
}
