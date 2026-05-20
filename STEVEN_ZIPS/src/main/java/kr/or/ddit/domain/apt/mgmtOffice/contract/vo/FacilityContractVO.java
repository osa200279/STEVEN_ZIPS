package kr.or.ddit.domain.apt.mgmtOffice.contract.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 시설 계약 VO
 * - FACILITY_CONTRACT 계약 기본정보
 * - FACILITY, PARTNER, UTILITY_PROVIDER 화면 표시정보
 */
@Data
public class FacilityContractVO {

    /** 계약번호 */
    private String contNo;

    /** 시설번호 */
    private String facilityNo;

    /** 협력업체번호 */
    private String partnerNo;

    /** 계약명 */
    private String contNm;

    /** 입찰유형코드 */
    private String bidTyCd;

    /** 계약일자 */
    private Date contDt;

    /** 계약상태코드 */
    private String contSttsCd;

    /** 계약금액 */
    private BigDecimal contAmt;

    /** 지급예정일 */
    private Date pymtDt;

    /** 계약시작일자 */
    private Date contBgngDt;

    /** 계약종료일자 */
    private Date contEndDt;

    /** 시설명 */
    private String facilityNm;

    /** 시설유형명 */
    private String facilityTyNm;

    /** 협력업체명 */
    private String partnerNm;

    /** 입찰유형명 */
    private String bidTyNm;

    /** 계약상태명 */
    private String contSttsNm;

    /** 만료까지 남은 일수 */
    private Integer expireDays;

    /** 검침설정 여부 */
    private String meterSettingYn;

    /** 검침설정번호 */
    private String utilityProviderNo;

    /** CSV 식별키 */
    private String csvIdntfKey;

    /** 외부 고객번호 */
    private String extCustNo;

    /** 검침설정 비고 */
    private String utilityRmrkCn;

    /** 아파트단지번호 */
    private String aptCmplexNo;
}
