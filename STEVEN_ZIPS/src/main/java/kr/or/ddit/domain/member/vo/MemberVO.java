package kr.or.ddit.domain.member.vo;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class MemberVO {
    private String userNo;
    private String userId;
    private String userPw;
    private String userNm;
    private String userRrno;
    private String userTelno;
    private String userEml;
    private Date regDt;
    private Date mdfcnDt;
    private char userYn;
    private char smsRcvYn;
    private char smsNtcRcvYn;
    private char smsCtrtRcvYn;
    private char emlRcvYn;
    private char emlNtcRcvYn;
    private char emlCtrtRcvYn;
    private String profFileId;
    private List<AuthVO> authList;
}

