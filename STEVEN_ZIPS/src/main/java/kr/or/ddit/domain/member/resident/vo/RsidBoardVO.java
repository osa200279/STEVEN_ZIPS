package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

import java.util.Date;

@Data
public class RsidBoardVO {

    private String annNo;
    private String ttl;
    private String cn;
    private String wrtrId;
    private String topFixYn;
    private Date pblancBgngDt;
    private Date pblancEndDt;
    private Date regDttm;
    private Date mdfDttm;
    private int inqCnt;
    private String delYn;
    private String atchFileId;
    private String boardNo;
    private String aptCmplexNo;

}
