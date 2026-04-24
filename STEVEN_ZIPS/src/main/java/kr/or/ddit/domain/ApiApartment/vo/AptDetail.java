package kr.or.ddit.domain.ApiApartment.vo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@JsonIgnoreProperties(ignoreUnknown = true)
@Data
public class AptDetail {

    private int kaptdEcnt;

    private String kaptdPcnt;
    private String kaptdPcntu;

    private String kaptdCccnt;  // cctv갯수

    private String welfareFacility; // 공용시설 종류
    private String kaptdWtimebus;   // 걸리는시간
    private String subwayLine;      // 지하철라인?
    private String subwayStation;   // 지하철역
    private String kaptdWtimesub;   // 걸리는시간
    private String convenientFacility;  // 편의시설?
    private String educationFacility;   // 교육시설

    private int groundElChargerCnt;
    private int undergroundElChargerCnt;

    private String useYn;
}