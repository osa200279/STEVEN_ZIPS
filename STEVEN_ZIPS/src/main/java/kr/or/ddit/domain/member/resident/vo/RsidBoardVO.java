package kr.or.ddit.domain.member.resident.vo;

import lombok.Data;

import java.util.Date;

@Data
public class RsidBoardVO {

    private String annNo;       // 게시글 번호
    private String ttl;         // 제목
    private String cn;          // 내용
    private String wrtrId;      // 작성자
    private String topFixYn;    // 상단 고정 여부
    private Date pblancBgngDt;
    private Date pblancEndDt;
    private Date regDttm;       // 등록일시
    private Date mdfDttm;       // 수정일시
    private int inqCnt;         // 조회수
    private String delYn;       // 삭제여부
    private String atchFileId;  // 첨부파일 아이디
    private String boardNo;     // 게시판 번호
    private String aptCmplexNo; // 아파트 단지 번호

}
