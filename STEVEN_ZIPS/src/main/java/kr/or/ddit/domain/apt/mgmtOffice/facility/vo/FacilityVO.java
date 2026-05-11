package kr.or.ddit.domain.apt.mgmtOffice.facility.vo;

import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

/**
 * 시설자산 VO
 * FACILITY 테이블 기본 컬럼 + 화면 출력용 JOIN 컬럼
 */
@Data
public class FacilityVO {

    /* ── FACILITY 기본 컬럼 ─────────────────────────── */
    private String facilityNo;      // 시설번호 (PK)
    private String facilityTyCd;    // 시설유형코드 (공통코드 FACILITY_TY)

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date instlDt;           // 설치일자

    private String facilityNm;      // 시설명
    private String aptCmplexNo;     // 아파트단지번호 (FK → APT_COMPLEX)
    private String dongNo;          // 동번호 (nullable: 공용 위치 시설은 없음)
    private String locCn;           // 상세위치 내용
    private String useYn;           // 사용여부 (Y: 이용 가능 / N: 이용 불가)
    private Long fileGroupNo;       // 첨부파일그룹번호 (nullable: 사진 없으면 null)

    /* ── 화면 출력용 JOIN 컬럼 ──────────────────────── */
    private String facilityTyNm;    // 시설유형명 (COMMON_CODE JOIN)
    private String aptCmplexNm;     // 아파트단지명 (APT_COMPLEX JOIN)
    private String dongNm;          // 동이름 (APT_UNIT JOIN)

    /* ── 검침 연결 여부 ─────────────────────────────── */
    // METER_HSTRY에 해당 시설번호 존재 시 Y, 없으면 N
    // 목록·상세 화면의 검침 연결 배지 표시용
    private String meterLinkedYn;   // 검침 연결 여부

    /* ── 이용불가 시설 최근 FAULT 점검이력 ──────────── */
    // USE_YN = 'N' 시설의 이용불가 사유 표시용
    // 목록·상세 화면에서 최근 이상발견 점검 정보 출력에 사용

    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date latestFaultDt;     // 최근 이상발견 점검일자

    private String latestFaultTyCd; // 최근 이상발견 점검유형코드 (공통코드 CHECK_TY)
}