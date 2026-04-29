package kr.or.ddit.domain.central.admin.vo;

import java.util.Date;

import lombok.Data;

/**
 * 단지 관리자 계정 화면 전용 VO
 *
 * 왜 화면 전용 VO를 쓰나?
 * → MNGR_RQST, MEMBER, MANAGER, MGMT_OFFICE, APT_COMPLEX 데이터를 한 화면에서 같이 보여주기 위해 사용한다.
 */
@Data
public class SubAdminVO {

    /* MNGR_RQST: 단지 관리자 신청 정보 */
    private String rqstNo;
    private String rqstLoginId;
    private String rqstMngrNm;
    private String rqstDutyCd;
    private Date rqstDt;
    private Date aprvDt;
    private String rqstSttsCd;
    private String aprvId;
    private String rjctRsnCn;
    private String rmrkCn;
    private String userNo;

    /* 단지/관리사무소 정보 */
    private String aptCmplexNo;
    private String aptCmplexNm;
    private String mgmtOfcNo;

    /* MEMBER + MANAGER: 승인 후 실제 계정 목록 */
    private String userId;
    private String userNm;
    private String userTelno;
    private String userEml;
    private String userYn;
    private String mngrDutyCd;
    private Date regDt;
    private Date mdfcnDt;

    /* 화면 표시용 */
    private String dutyNm;
    private String sttsNm;
    private String lastLoginDt;
    private String lastLoginTm;
}
