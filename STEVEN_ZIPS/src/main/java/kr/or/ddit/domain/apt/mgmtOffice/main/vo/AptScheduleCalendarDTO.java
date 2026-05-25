package kr.or.ddit.domain.apt.mgmtOffice.main.vo;

import lombok.Data;

/**
 * 단지 일정 캘린더 DTO
 * DTO란? Controller, Service, Mapper 사이에서 데이터를 옮기는 객체입니다.
 * 왜 사용? 화면 검색조건과 DB 조회 결과를 하나의 객체로 안전하게 전달하기 위해 사용합니다.
 */
@Data
public class AptScheduleCalendarDTO {

    /** 화면 접근 기준 관리사무소 번호 */
    private String mgmtOfcNo;

    /** 관리사무소가 소속된 아파트 단지 번호 */
    private String aptCmplexNo;

    /** 일정 원본 PK. 예: ANN_NO, VACATION_SCHDL_NO, FAC_CHK_HSTRY_NO */
    private String scheduleNo;

    /** 일정 분류 코드: NOTICE, EVENT, VACATION, CONSTRUCTION, METER, CHECK */
    private String scheduleTy;

    /** 일정 분류명: 공지, 행사, 휴가, 공사, 검침, 점검 */
    private String scheduleTyNm;

    /** 일정 제목 */
    private String scheduleTtl;

    /** 일정 내용 */
    private String scheduleCn;

    /** 일정 장소 또는 상세 위치 */
    private String locCn;

    /** 시작일 yyyy-MM-dd */
    private String startDt;

    /** 종료일 yyyy-MM-dd */
    private String endDt;

    /** 화면 표시용 색상/상태 코드 */
    private String colorCd;

    /** 등록자 ID 또는 직원명 */
    private String rgtrId;

    /** 직원 휴가 등록 시 대상 직원 번호 */
    private String userNo;

    /** 직원 휴가 등록 시 대상 직원명 */
    private String userNm;

    /** 월 조회 시작일 yyyy-MM-dd */
    private String monthStartDt;

    /** 월 조회 종료일 yyyy-MM-dd */
    private String monthEndDt;

    /** 검색어 */
    private String keyword;

    /** 통계: 전체 일정 수 */
    private int totalCnt;

    /** 통계: 오늘 일정 수 */
    private int todayCnt;

    /** 통계: 이번 달 일정 수 */
    private int monthCnt;

    /** 통계: 직원 휴가 일정 수 */
    private int vacationCnt;
}
