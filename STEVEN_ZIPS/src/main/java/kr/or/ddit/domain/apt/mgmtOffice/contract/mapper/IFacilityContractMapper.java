package kr.or.ddit.domain.apt.mgmtOffice.contract.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractDTO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSummaryVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractTargetVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 시설 계약 관리 Mapper
 */
@Mapper
public interface IFacilityContractMapper {

    /** 다음 계약번호 조회 */
    String selectNextContNo();

    /** 다음 파일그룹번호 조회 */
    Long selectNextFileGroupNo();

    /** 다음 검침 설정번호 조회 */
    String selectNextUtilityProviderNo();

    /** 관리사무소 번호 기준 단지번호 조회 */
    String selectAptCmplexNoByMgmtOfcNo(String mgmtOfcNo);

    /** 계약 목록 조회 */
    List<FacilityContractDTO> selectContractList(FacilityContractSearchVO search);

    /** 계약 현황 카드 조회 */
    FacilityContractSummaryVO selectContractSummary(FacilityContractSearchVO search);

    /** 계약 상세 조회 */
    FacilityContractDTO selectContractDetail(
            @Param("mgmtOfcNo") String mgmtOfcNo,
            @Param("contNo") String contNo
    );

    /** 계약 대상 시설 상세 목록 조회 */
    List<FacilityContractTargetVO> selectContractTargetList(String contNo);

    /** 계약 대상 시설번호 목록 조회 */
    List<String> selectContractTargetNoList(String contNo);

    /** 계약 첨부파일 목록 조회 */
    List<Map<String, Object>> selectContractFileList(Long fileGroupNo);

    /** 계약 등록/수정 폼용 협력업체 목록 조회 */
    List<Map<String, Object>> selectContractPartnerList(String mgmtOfcNo);

    /** 계약 등록/수정 폼용 시설 목록 조회 */
    List<Map<String, Object>> selectContractFacilityList(String mgmtOfcNo);

    /** 계약 등록 */
    int insertContract(FacilityContractDTO contract);

    /** 계약 수정 */
    int updateContract(FacilityContractDTO contract);

    /** 계약 대상 시설 등록 */
    int insertContractTarget(FacilityContractTargetVO target);

    /** 계약 대상 시설 전체 삭제 */
    int deleteContractTargets(String contNo);

    /** 계약번호 기준 검침 설정 조회 */
    FacilityContractDTO selectUtilityProviderByContNo(String contNo);

    /** 계약번호 기준 검침 설정 개수 조회 */
    int countUtilityProviderByContNo(String contNo);

    /** 검침 설정 등록 */
    int insertUtilityProvider(FacilityContractDTO contract);

    /** 검침 설정 수정 */
    int updateUtilityProvider(FacilityContractDTO contract);

    /** 첨부파일 DB 삭제 */
    int deleteAttachFileByUuid(String fileSaveUuid);
}
