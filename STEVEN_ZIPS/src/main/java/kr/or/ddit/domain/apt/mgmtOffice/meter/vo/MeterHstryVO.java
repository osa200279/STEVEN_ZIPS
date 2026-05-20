package kr.or.ddit.domain.apt.mgmtOffice.meter.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 검침 이력 VO
 * - METER_HSTRY 테이블 기준 조회/등록용 VO
 * - 목록 화면 표시를 위해 시설명, 업체명, 공통코드명 등 조인 필드를 함께 둠
 */
@Data
public class MeterHstryVO {

    /** 검침이력번호 */
    private String meterHstryNo;

    /** 시설번호 */
    private String facilityNo;

    /** 세대/호 번호 */
    private String hoNo;

    /** 검침일자 */
    private Date meterDt;

    /** 이전 검침값 */
    private BigDecimal preVal;

    /** 현재 검침값 */
    private BigDecimal currVal;

    /** 검침내용 */
    private String meterCn;

    /** 검침결과코드 */
    private String meterRsltCd;

    /** 등록일자 */
    private Date regDt;

    /** 수정일자 */
    private Date mdfDt;

    /** 공급/검침 설정번호 */
    private String utilityProviderNo;

    /** 시설명 */
    private String facilityNm;

    /** 시설유형코드 */
    private String facilityTyCd;

    /** 시설유형명 */
    private String facilityTyNm;

    /** 검침결과명 */
    private String meterRsltNm;

    /** CSV 식별키 */
    private String csvIdntfKey;

    /** 외부 고객번호 */
    private String extCustNo;

    /** 협력업체번호 */
    private String partnerNo;

    /** 협력업체명 */
    private String partnerNm;
}
