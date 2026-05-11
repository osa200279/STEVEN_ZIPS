package kr.or.ddit.domain.apt.mgmtOffice.facility.dto;

import lombok.Data;

import java.util.Date;

/**
 * 시설 조회 DTO
 *
 * [기준]
 * - FACILITY: 모든 시설의 공통 마스터
 * - PUBLIC_FACILITY: 편의시설 전용 확장 정보
 *
 * [용도]
 * - 시설 목록 조회
 * - 시설 상세 요약 조회
 * - 일반시설/편의시설 구분 표시
 * - 관련 관리 화면 이동 전 요약 표시
 *
 * [주의]
 * - 등록/수정 저장용 객체 아님
 * - FACILITY 등록/수정은 FacilityVO 사용
 * - 편의시설 등록/수정은 기존 편의시설관리 화면 사용
 */
@Data
public class FacilityDTO {

    /* ─────────────────────────────
     * 1. 시설 구분
     * ───────────────────────────── */

    private String facilityKind;     // 시설종류, SQL 생성값, FACILITY/PUBLIC
    private String facilityKindNm;   // 시설종류명, 일반시설/편의시설

    /* ─────────────────────────────
     * 2. 시설 공통 정보
     * ───────────────────────────── */

    private String facilityNo;       // 시설번호, FACILITY.FACILITY_NO
    private String facilityNm;       // 화면 표시 시설명, 편의시설이면 CMN_FACILITY_NM 우선
    private String facilityTyCd;     // 시설유형코드, FACILITY.FACILITY_TY_CD
    private String facilityTyNm;     // 시설유형명, COMMON_CODE.FACILITY_TY의 CODE_NAME

    private Date instlDt;            // 설치일자, FACILITY.INSTL_DT
    private String aptCmplexNo;      // 아파트단지번호, FACILITY.APT_CMPLEX_NO
    private String dongNo;           // 동 원본값, FACILITY.DONG_NO
    private String displayDongNo;    // 동 표시값, A1215003_1 -> 1
    private String locCn;            // 상세위치, FACILITY.LOC_CN
    private String useYn;          // 사용여부, FACILITY.USE_YN
    private String useYnNm;        // 사용여부명, 사용 가능/사용 불가
    private String useCheckNeedYn; // 사용여부 확인필요 여부, DB 컬럼 아님, USE_YN = 'N' + 최근 점검상태 DONE이면 Y
    private String useCheckMsg;    // 사용여부 확인 안내문, DB 컬럼 아님, 예: 점검완료 후 사용여부 확인 필요

    /* ─────────────────────────────
     * 3. 편의시설 전용 요약
     * ───────────────────────────── */

    private String cmnFacilityNo;    // 편의시설번호, PUBLIC_FACILITY.CMN_FACILITY_NO
    private String cmnFacilityNm;    // 편의시설명, PUBLIC_FACILITY.CMN_FACILITY_NM
    private String cmnFacilityRsvYn; // 예약가능여부, PUBLIC_FACILITY.CMN_FACILITY_RSV_YN
    private String cmnFacilityOprHr; // 운영시간, PUBLIC_FACILITY.CMN_FACILITY_OPR_HR

}