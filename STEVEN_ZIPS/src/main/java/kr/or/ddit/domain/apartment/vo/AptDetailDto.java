package kr.or.ddit.domain.apartment.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class AptDetailDto {
    private String kaptCode;
    private String kaptName;
    private String codeMgr;
    private String kaptMgrCnt;
    private String kaptCcompany;
    private String codeSec;
    private String kaptdScnt;
    private String kaptdSecCom;
    private String codeClean;
    private String kaptdClcnt;
    private String codeGarbage;
    private String codeDisinf;
    private String kaptdDcnt;
    private String disposalType;
    private String codeStr;
    private String kaptdEcapa;
    private String codeEcon;
    private String codeEmgr;
    private String codeFalarm;
    private String codeWsupply;
    private String codeElev;

    private int kaptdEcnt;

    private String kaptdPcnt;
    private String kaptdPcntu;
    private String codeNet;
    private String kaptdCccnt;
    private String welfareFacility;
    private String kaptdWtimebus;
    private String subwayLine;
    private String subwayStation;
    private String kaptdWtimesub;
    private String convenientFacility;
    private String educationFacility;

    private int groundElChargerCnt;
    private int undergroundElChargerCnt;

    private String useYn;
}