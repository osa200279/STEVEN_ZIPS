package kr.or.ddit.domain.apt.manager.vo;

import lombok.Data;
import org.checkerframework.checker.units.qual.A;
import org.checkerframework.checker.units.qual.C;

@Data
public class MgmtOfficeVO {

    private String mgmtOfcNo;
    private String aptCmplexNo;
    private String mgmtOfcNm;
    private String mgmtOfcTelno;
    private String mgmtOfcEmail;
    private String mgmtOfcBankCd;
    private String mgmtOfcAcntHldrNm;
    private String mgmtOfcAcntNo;
    private String useYn;

    // APT_COMPLEX
    private String aptCmplexNm;
    private String sidoNm;
    private String sigunguNm;
    private String emdNm;
    private String dorojuso;
    private Integer unitCnt;
    private Integer dongCnt;
    private String bldYr;
}
