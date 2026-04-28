package kr.or.ddit.domain.apt.manager.vo;

import lombok.Data;

@Data
public class ManagerVO {
    private String userNo;
    private String mgmtOfcNo;
    private String mngrDutyCd;

    // MEMBER
    private String userId;
    private String userNm;
    private String telno;
    private String userEml;
    private String userYn;
    private String birthDate;   // USER_RRNO 앞 6자리

    // MGMT_OFFICE / APT_COMPLEX
    private String mgmtOfcNm;
    private String aptCmplexNm;
}
