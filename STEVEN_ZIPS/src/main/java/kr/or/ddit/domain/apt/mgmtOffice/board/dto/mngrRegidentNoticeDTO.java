package kr.or.ddit.domain.apt.mgmtOffice.board.dto;

import lombok.Data;

import java.util.Date;

@Data
public class mngrRegidentNoticeDTO {

    private String annNo;          // 공지번호
    private String boardNo;        // 게시판번호
    private String aptCmplexNo;    // 아파트단지번호

    private String ttl;            // 제목
    private String cn;             // 내용
    private String wrtrId;         // 작성자ID

    private Date  regDttm;        // 작성일
    private Date mdfDttm;        // 수정일

    private int inqCnt;            // 조회수

    private String delYn;          // 삭제여부
    // Y : 삭제
    // N : 정상

    private String atchFileId;     // 첨부파일ID

    private String topFixYn;       // 긴급공지 여부
    // Y : 긴급공지
    // N : 일반공지

    private String searchTtl;
    private String searchStartDt;
    private String searchEndDt;

    private int startRow;
    private int endRow;
}