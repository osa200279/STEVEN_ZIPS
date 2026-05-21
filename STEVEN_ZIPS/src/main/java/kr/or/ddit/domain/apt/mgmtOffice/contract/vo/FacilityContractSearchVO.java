package kr.or.ddit.domain.apt.mgmtOffice.contract.vo;

import lombok.Data;

/**
 * 계약 목록 검색조건 VO
 *
 * JSP 검색조건과 Mapper where절을 연결한다.
 */
@Data
public class FacilityContractSearchVO {

    private String mgmtOfcNo;
    private String contTyCd;
    private String contTargetCd;

    /** 계약시작일 검색 시작/종료 */
    private String startDt;
    private String endDt;

    /** 계약종료일 검색 시작/종료 */
    private String endStartDt;
    private String endEndDt;

    /** 계약명, 업체명, 시설명 통합검색 */
    private String keyword;
}
