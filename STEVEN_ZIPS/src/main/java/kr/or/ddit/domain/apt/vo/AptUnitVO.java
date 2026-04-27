package kr.or.ddit.domain.apt.vo;

import lombok.Data;

@Data
public class AptUnitVO {
    private String dongNo;
    private String dongNm;
    private int floor;
    private int unitCnt;
    private String aptCmplexNo;
}
