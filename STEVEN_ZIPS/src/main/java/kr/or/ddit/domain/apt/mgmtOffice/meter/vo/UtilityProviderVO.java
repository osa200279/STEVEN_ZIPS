package kr.or.ddit.domain.apt.mgmtOffice.meter.vo;

import lombok.Data;

/**
 * 공급/검침 설정 VO
 * - UTILITY_PROVIDER와 PARTNER 조인 결과를 CSV 업로드 선택값으로 사용함
 */
@Data
public class UtilityProviderVO {

    /** 공급/검침 설정번호 */
    private String utilityProviderNo;

    /** 아파트단지번호 */
    private String aptCmplexNo;

    /** 협력업체번호 */
    private String partnerNo;

    /** CSV 식별키 */
    private String csvIdntfKey;

    /** 외부 고객번호 */
    private String extCustNo;

    /** 설정 비고 */
    private String rmrkCn;

    /** 협력업체명 */
    private String partnerNm;
}
