package kr.or.ddit.domain.central.admin.vo;

import lombok.Data;

/**
 * 중앙관리자 공고 관리 VO
 *
 */
@Data
public class AnnouncementVO {

    /* CENTER_ANN_BOARD_POST 기본 컬럼 */
    private String annNo;          // 공고번호
    private String boardNo;        // 게시판번호
    private String ttl;            // 제목
    private String cn;             // 내용
    private String wrtrId;         // 작성자아이디
    private String topFixYn;       // 상단고정여부

    private String pblancBgngDt;   // 공고게시시작일
    private String pblancEndDt;    // 공고게시종료일
    private String rcrtBgngDt;     // 모집시작일
    private String rcrtEndDt;      // 모집종료일

    private String regDttm;        // 등록일시
    private String mdfDttm;        // 수정일시
    private Integer inqCnt;        // 조회수
    private String delYn;          // 삭제여부
    private String atchFileId;     // 첨부파일ID
    private String opnYn;          // 공개여부

    /* CENTER_BOARD_INSTANCE 조인 컬럼 */
    private String boardNm;        // 게시판명
    private String boardTyCd;      // 게시판유형코드

    /* 화면 표시용 */
    private String statusNm;       // 진행상태명: 예정, 진행중, 마감

    /* 검색 조건 */
    private String searchTtl;      // 검색 제목
    private String searchFrom;     // 검색 시작일
    private String searchTo;       // 검색 종료일
    private String searchStatus;   // 검색 상태
}