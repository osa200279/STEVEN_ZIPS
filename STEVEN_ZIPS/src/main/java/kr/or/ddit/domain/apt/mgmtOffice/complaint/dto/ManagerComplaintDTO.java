package kr.or.ddit.domain.apt.mgmtOffice.complaint.dto;

import lombok.Data;

@Data
public class ManagerComplaintDTO {

    /**
     * 민원 접수 현황 전체 조회 필드(민원 테이블)
     */
    private String cvplNo;
    private String cvplTyCd;
    private String cvplLoc;
    private String cvplCn;
    private String cvplSttsCd;
    private String cvplRegDt;
    private String cvplMdfDt;
    private String cvplRcptDt;
    private String cvplEndDt;
    private String cvplPrrt;
    private String cvplFileNo;
    private String cvplTtl;
    private String userNo;
    private String hoNo;
    private String aptCmplexNo;

    /**
     * 민원 이력 필드(민원이력 테이블)
     */
    private String cvplHstryId;
    private String cvplAns;
    private String picId;

    /**
     * 민원 AI분석 필드(민원AI분석 테이블)
     */
    private String analysisNo;
    private int riskScr;
    private String riskGrad;
    private String predCtgry;
    private String chnRiskCn;
    private String anlsDt;

    /**
     * 신고자 정보(일반회원 테이블)
     */
    private String userId;
    private String userNm;
}
