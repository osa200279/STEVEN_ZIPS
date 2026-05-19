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

    private String fileOgName;      // 원본 파일명
    private String fileDownUrl;     // 파일 다운로드 URL

    private String topFixYn;    // 상단고정여부, Y이면 긴급 공지로 표시

    /*
     * MIME 타입
     * 예:
     * image/jpeg
     * image/png
     * application/pdf
     *
     * MIME 타입이란?
     * → 파일 종류를 나타내는 인터넷 표준 형식.
     * 왜 사용?
     * → 이미지인지 PDF인지 구분해서 화면 처리하기 위해.
     */
    private String mimeType;

    /*
     * 구글드라이브 파일 고유 ID
     * → /file/display/{googleId} 미리보기에 사용.
     */
    private String googleId;



}