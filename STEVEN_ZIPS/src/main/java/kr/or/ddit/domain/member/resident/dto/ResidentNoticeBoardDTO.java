package kr.or.ddit.domain.member.resident.dto;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class ResidentNoticeBoardDTO {

    private String annNo;          // 공지번호
    private String boardNo;        // 게시판번호
    private String aptCmplexNo;    // 아파트단지번호

    private String ttl;            // 제목
    private String cn;             // 내용
    private String wrtrId;         // 작성자ID

    private String regDttm;        // 작성일
    private String mdfDttm;        // 수정일

    private int inqCnt;            // 조회수
    private String delYn;          // 삭제여부
    private String atchFileId;     // 첨부파일ID

    private String boardTyCd;      // 게시판유형코드
    private String boardNm;        // 게시판명

    private String searchTtl;      // 제목 검색어
    private String searchStartDt;  // 작성일 시작일
    private String searchEndDt;    // 작성일 종료일

    private int startRow;          // 페이징 시작 행
    private int endRow;            // 페이징 끝 행


}