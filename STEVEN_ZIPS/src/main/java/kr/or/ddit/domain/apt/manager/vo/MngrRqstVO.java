package kr.or.ddit.domain.apt.manager.vo;

import lombok.Data;

@Data
public class MngrRqstVO {

    // MNGR_RQST
    private String rqstNo;
    private String rqstLoginId;
    private String rqstMngrNm;
    private String rqstDutyCd;
    private String rqstDt;
    private String aprvDt;
    private String rqstSttsCd;
    private String aprvId;
    private String rjctRsnCn;
    private String rmrkCn;
    private String userNo;

    // JOIN
    private String mgmtOfcNo;
    private String mgmtOfcNm;
    private String aptCmplexNm;


    // 관리사무소 - 직원 요청 승인자의 정보(ID, 이름)
    private String aprvUserId;
    private String aprvUserNm;
}