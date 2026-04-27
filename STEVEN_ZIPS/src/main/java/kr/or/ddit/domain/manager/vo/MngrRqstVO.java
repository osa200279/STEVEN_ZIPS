package kr.or.ddit.domain.manager.vo;

import java.util.Date;

import lombok.Data;

/**
 * 단지관리자 생성요청 VO
 *
 * MNGR_RQST 테이블과 매핑되는 VO
 * 관리사무소 화면에서는 계정 생성 요청 등록, 수정, 취소, 상세 조회
 *
 * 승인/반려 처리는 관리사무소 화면이 아니라 중앙관리자 화면에서 처리한다.
 */
@Data
public class MngrRqstVO {
    /* 요청번호 - 시퀀스 또는 채번 규칙으로 RQST_NO 생성
    *  화면 표시용 번호 따로 서버에서 만들기도. */
    private String rqstNo;        // 요청 번호
    private String rqstLoginId;   // 요청 계정 로그인 아이디
    private String rqstPw;        // 요청 계정 비밀번호
    private String rqstMngrNm;    // 요청 관리자명
    private String rqstRrno;      // 요청 주민등록번호
    private String rqstTelno;     // 요청 전화번호
    private String rqstEml;       // 요청 이메일
    private String rqstDutyCd;    // 요청 직무 코드
    private Date rqstDt;          // 요청 일시
    /*
     * 승인 일자
     * MNGR_RQST.APRV_DT
     * 중앙관리자 기능에서 처리
     */
    private Date aprvDt;

    /*
     * 요청 상태 코드
     * MNGR_RQST.RQST_STTS_CD
     *
     * 예:
     * - 대기
     * - 승인
     * - 반려
     * - 취소
     *
     * 실제 코드값은 공통코드 기준에.
     */
    private String rqstSttsCd;



    private String aprvId;        // 승인자 아이디
    private String rjctRsnCn;     // 반려 사유 내용
    private String rmrkCn;         // 비고 내용

    /*
     * 사용자 번호
     * MNGR_RQST.USER_NO
     *
     * 승인 후 생성된 MEMBER.USER_NO와 연결될 수 있다.
     * 요청 등록 시에는 비어 있을 수 있다.
     */
    private String userNo;        // 요청자 사용자 번호
}