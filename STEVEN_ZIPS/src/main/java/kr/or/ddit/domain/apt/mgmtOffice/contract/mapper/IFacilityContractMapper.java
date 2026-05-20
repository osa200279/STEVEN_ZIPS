package kr.or.ddit.domain.apt.mgmtOffice.contract.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

/**
 * 시설 계약 Mapper
 * - 계약 목록/등록/수정
 * - 만료 현황 조회
 * - 검침 설정 등록/수정
 */
@Mapper
public interface IFacilityContractMapper {

    /** 관리사무소의 단지번호 조회 */
    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    /** 계약 현황 조회 */
    Map<String, Object> selectContractStats(Map<String, Object> paramMap);

    /** 계약 목록 조회 */
    List<FacilityContractVO> selectContractList(Map<String, Object> paramMap);

    /** 만료임박 계약 목록 조회 */
    List<FacilityContractVO> selectExpiringContractList(Map<String, Object> paramMap);

    /** 시설 선택 목록 조회 */
    List<FacilityContractVO> selectFacilitySelectList(String aptCmplexNo);

    /** 협력업체 선택 목록 조회 */
    List<FacilityContractVO> selectPartnerSelectList(String aptCmplexNo);

    /** 입찰유형 공통코드 목록 조회 */
    List<Map<String, Object>> selectBidTypeCodeList();

    /** 계약상태 공통코드 목록 조회 */
    List<Map<String, Object>> selectContractStatusCodeList();

    /** 계약 등록 */
    int insertContract(FacilityContractVO contractVO);

    /** 계약 수정 */
    int updateContract(FacilityContractVO contractVO);

    /** 검침 설정 등록 */
    int insertUtilityProvider(FacilityContractVO contractVO);

    /** 검침 설정 수정 */
    int updateUtilityProvider(FacilityContractVO contractVO);
}
