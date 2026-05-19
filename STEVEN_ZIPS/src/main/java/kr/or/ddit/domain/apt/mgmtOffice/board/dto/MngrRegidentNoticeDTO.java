package kr.or.ddit.domain.apt.mgmtOffice.board.dto;

import lombok.Data;

import java.util.Date;

@Data
public class MngrRegidentNoticeDTO {

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

    private String topFixYn;       // 긴급공지 여부
    // Y : 긴급공지
    // N : 일반공지

    private String searchTtl;
    private String searchStartDt;
    private String searchEndDt;

    private int startRow;
    private int endRow;

    private String searchAnnNo;     // 공지번호 검색어
    private String searchWrtrId;    // 작성자 검색어

    private int rowNo;              // 화면용 번호

    private String atchFileId;      // 첨부파일ID

    private int fileCnt;            // 첨부파일 개수

    private String fileOgName;      // 원본 파일명
    private String fileSaveUuid;    // 서버 저장용 UUID
    private String filePath;        // 파일 저장 경로
    private String fileExt;         // 확장자
    private long fileSize;          // 파일 크기
    private String mimeType;        // 파일 종류

    /*
     * 긴급공지 검색 여부
     * Y이면 TOP_FIX_YN = 'Y'인 게시글만 조회
     */
    private String searchTopFixYn;

    /*
     * 첨부파일 검색 여부
     * Y이면 첨부파일 있는 글만 조회
     * N이면 첨부파일 없는 글만 조회
     */
    private String searchAttachYn;

    /*
     * 공고 시작일
     * 화면 input type="date" 값이 문자열로 들어옴.
     */
    private String pblancBgngDt;

    /*
     * 공고 종료일
     */
    private String pblancEndDt;

    /*
     * 정렬 컬럼
     * 예: REG_DTTM, ANN_NO
     */
    private String sortColumn;

    /*
     * 정렬 방향
     * ASC / DESC
     */
    private String sortOrder;

    /* 파일 업로드 */
    private String googleId;

    private String mgmtOfcNo;



}