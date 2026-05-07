package kr.or.ddit.domain.central.admin.dto;

import lombok.Data;

/**
 * 중앙관리자 공고 관리 VO
 *
 */
@Data
public class AnnouncementDTO {

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

    /* CENTER_BOARD_INSTANCE 조인 컬럼 */
    private String boardNm;        // 게시판명
    private String boardTyCd;      // 게시판유형코드

    /* APT_COMPLEX 조인 컬럼 */
    private String aptCmplexNo;    // 아파트단지번호
    private String aptCmplexNm;    // 아파트단지명

    /*
      공급세대수

      DB 저장 위치
      → CENTER_ANN_BOARD_POST에 저장하지 않음.

      조회 방식
      → APT_UNIT.UNIT_CNT 합계 또는 APT_COMPLEX.UNIT_CNT 값으로 화면에 표시.
    */
    private Integer unitCnt;       // 공급세대수

    /*
      제출서류명

      현재 구조
      → CENTER_ANN_BOARD_POST.ATCH_FILE_ID
      → ATTACH_FILE.FILE_GROUP_ID 와 연결해서 첨부파일명을 표시.
    */
    private String sbmsnDocNm;     // 제출서류명

    /* 화면 표시용 */
    private String statusNm;       // 진행상태명: 예정, 진행중, 마감

    /* 검색 조건 */
    private String searchTtl;          // 검색 제목
    private String searchAptCmplexNo;  // 검색 단지번호
    private String searchFrom;         // 검색 시작일
    private String searchTo;           // 검색 종료일
    private String searchStatus;       // 검색 상태
}