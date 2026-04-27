package kr.or.ddit.domain.manager.vo;

import lombok.Data;

/*
 * 단지관리자 VO
 *
 * MANAGER 테이블과 매핑되는 VO이다.
 *
 * MANAGER 테이블 자체에는 USER_NO, MGMT_OFC_NO, MNGR_DUTY_CD만 있으므로
 * 직원명, 로그인 아이디, 연락처, 이메일 등은 MEMBER 테이블과 조인해서 가져온다.
 *
 * MEMBER 정보는 기존 MemberVO를 중첩 빈즈로 가진다.
 */
@Data
public class ManagerVO {

    /* MANGER
     * 사용자 번호
     * MANAGER.USER_NO
     *
     * MEMBER.USER_NO와 연결된다.
     */
    private String userNo;

    /*
     * 관리사무소 번호
     * MANAGER.MGMT_OFC_NO
     */
    private String mgmtOfcNo;

    /*
     * 관리자 직무 코드
     * MANAGER.MNGR_DUTY_CD
     *
     * 예:
     * - 관리소장
     * - 행정
     * - 시설관리
     * - 회계
     *
     * 실제 값은 공통코드 기준에 맞춘다.
     */
    private String mngrDutyCd;


    // DTO 형식 - Member vo
    private String userId;
    private String userNm;
    private String userTelno;
    private String userEml;
    private String userYn;
}