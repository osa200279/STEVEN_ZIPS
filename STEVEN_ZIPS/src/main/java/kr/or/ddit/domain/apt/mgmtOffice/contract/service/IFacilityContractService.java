package kr.or.ddit.domain.apt.mgmtOffice.contract.service;

import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractVO;

import java.util.Map;

/**
 * 시설 계약 Service 인터페이스
 */
public interface IFacilityContractService {

    /** 계약 화면 데이터 조회 */
    Map<String, Object> selectContractPageData(String mgmtOfcNo, Map<String, Object> searchMap);

    /** 계약 등록 */
    int insertContract(String mgmtOfcNo, FacilityContractVO contractVO);

    /** 계약 수정 */
    int updateContract(String mgmtOfcNo, FacilityContractVO contractVO);

    /** 재계약 등록 */
    int insertRenewContract(String mgmtOfcNo, FacilityContractVO contractVO);

    /** 검침 설정 저장 */
    int saveUtilityProvider(String mgmtOfcNo, FacilityContractVO contractVO);
}
