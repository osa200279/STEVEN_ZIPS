package kr.or.ddit.domain.apt.mgmtOffice.facility.check.vo;

import lombok.Data;

/**
 * 시설 점검 이력 VO
 * - FACILITY_CHECK_HSTRY 테이블 기준 CRUD
 * - 목록/상세 화면에서 필요한 FACILITY, PARTNER, COMMON_CODE 조인 표시값 포함
 * - 시설 선택 모달, 협력업체 선택 모달 검색 조건 포함
 */
@Data
public class FacilityCheckHstryVO {

    /** 관리사무소 번호 검색 조건 */
    private String mgmtOfcNo;

    /** 시설점검이력번호 */
    private String facChkHstryNo;

    /** 시설번호 */
    private String facilityNo;

    /** 업체번호 */
    private String partnerNo;

    /** 점검일자 */
    private String chkDt;

    /** 점검상태코드 */
    private String chkSttsCd;

    /** 점검내용 */
    private String chkCn;

    /** 비고 */
    private String rmk;

    /** 등록일자 */
    private String regDt;

    /** 수정일자 */
    private String mdfDt;

    /** 점검유형코드 */
    private String chkTyCd;

    /** 점검유형명 */
    private String chkTyNm;

    /** 점검상태명 */
    private String chkSttsNm;

    /** 시설명 */
    private String facilityNm;

    /** 시설유형코드 */
    private String facilityTyCd;

    /** 시설유형명 */
    private String facilityTyNm;

    /** 시설 위치 */
    private String locCn;

    /** 시설 설치일자 */
    private String instlDt;

    /** 시설 사용여부 */
    private String useYn;

    /** 업체명 */
    private String partnerNm;

    /** 업종명 */
    private String bizTyNm;

    /** 사업자등록번호 */
    private String bizrno;

    /** 업체 담당자명 */
    private String picNm;

    /** 업체 담당자 전화번호 */
    private String picTelno;

    /** 업체 담당자 이메일 */
    private String picEmail;

    /** 검색 시작 점검일자 */
    private String chkStartDt;

    /** 검색 종료 점검일자 */
    private String chkEndDt;

    /** 현황 카드 전체 이력 건수 */
    private Integer totalCnt;

    /** 현황 카드 점검대기 건수 */
    private Integer waitCnt;

    /** 현황 카드 점검중 건수 */
    private Integer ingCnt;

    /** 현황 카드 이상발견 건수 */
    private Integer faultCnt;

    /** 동 번호 */
    private String dongNo;

    /** 동 이름 */
    private String dongNm;

    /** 시설 선택 모달 검색어 */
    private String facilitySearchWord;

    /** 시설 선택 모달 사용여부 검색 조건 */
    private String facilityUseYn;

    /** 시설 선택 모달 위치 검색 조건 */
    private String facilityLocCn;

    /** 협력업체 선택 모달 사용여부 검색 조건 */
    private String partnerUseYn;

    /** 협력업체 선택 모달 검색어 */
    private String partnerSearchWord;
}