package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

/**
 * 중앙관리자 공고 관리 VO
 *
 * VO란?
 * → DB 컬럼값과 화면에서 넘어온 값을 담는 객체.
 */
@Data
public class AnnouncementVO {

    private String annNo;
    private String boardNo;
    private String boardNm;
    private String boardTyCd;

    private String ttl;
    private String cn;
    private String wrtrId;
    private String topFixYn;

    private String pblancBgngDt;
    private String pblancEndDt;
    private String rcrtBgngDt;
    private String rcrtEndDt;

    private String regDttm;
    private String mdfDttm;
    private Integer inqCnt;
    private String delYn;
    private String atchFileId;
    private String opnYn;

    /* 검색 조건 */
    private String searchTtl;
    private String searchFrom;
    private String searchTo;
    private String searchStatus;
}