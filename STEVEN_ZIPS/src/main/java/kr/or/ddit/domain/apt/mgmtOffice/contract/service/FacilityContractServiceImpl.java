package kr.or.ddit.domain.apt.mgmtOffice.contract.service;

import kr.or.ddit.domain.apt.mgmtOffice.contract.mapper.IFacilityContractMapper;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractDTO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSearchVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractSummaryVO;
import kr.or.ddit.domain.apt.mgmtOffice.contract.vo.FacilityContractTargetVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 시설 계약 관리 Service 구현체
 *
 * 기준 테이블
 * - FACILITY_CONTRACT
 * - FACILITY_CONTRACT_TARGET
 * - UTILITY_PROVIDER
 * - ATTACH_FILE
 */
@Slf4j
@Service
public class FacilityContractServiceImpl implements IFacilityContractService {

    @Autowired
    private IFacilityContractMapper facilityContractMapper;

    /**
     * 계약 목록 조회
     */
    @Override
    public List<FacilityContractDTO> selectContractList(FacilityContractSearchVO search) {
        return facilityContractMapper.selectContractList(search);
    }

    /**
     * 계약 현황 카드 조회
     */
    @Override
    public FacilityContractSummaryVO selectContractSummary(FacilityContractSearchVO search) {
        return facilityContractMapper.selectContractSummary(search);
    }

    /**
     * 계약 상세 조회
     */
    @Override
    public FacilityContractDTO selectContractDetail(String mgmtOfcNo, String contNo) {
        // 계약 기본 상세
        FacilityContractDTO contract = facilityContractMapper.selectContractDetail(mgmtOfcNo, contNo);

        if (contract == null) {
            return null;
        }

        // 계약 대상 시설 목록
        contract.setTargetFacilityList(facilityContractMapper.selectContractTargetList(contNo));

        // 수정 폼 체크박스 선택값 복원용 시설번호 목록
        contract.setTargetFacilityNoList(facilityContractMapper.selectContractTargetNoList(contNo));

        // 검침 설정 조회
        FacilityContractDTO utilityInfo = facilityContractMapper.selectUtilityProviderByContNo(contNo);

        if (utilityInfo != null) {
            contract.setUtilityProviderNo(utilityInfo.getUtilityProviderNo());
            contract.setCsvIdntfKey(utilityInfo.getCsvIdntfKey());
            contract.setExtCustNo(utilityInfo.getExtCustNo());
            contract.setUtilityRmrkCn(utilityInfo.getUtilityRmrkCn());
        }

        // 첨부파일 목록 조회
        if (contract.getFileGroupNo() != null) {
            contract.setFileList(facilityContractMapper.selectContractFileList(contract.getFileGroupNo()));
        }

        return contract;
    }

    /**
     * 계약 등록/수정 폼용 협력업체 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectContractPartnerList(String mgmtOfcNo) {
        return facilityContractMapper.selectContractPartnerList(mgmtOfcNo);
    }

    /**
     * 계약 등록/수정 폼용 시설 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectContractFacilityList(String mgmtOfcNo) {
        return facilityContractMapper.selectContractFacilityList(mgmtOfcNo);
    }

    /**
     * 계약 등록
     */
    @Override
    @Transactional
    public void insertContract(FacilityContractDTO contract, List<MultipartFile> contractFiles) {
        // 계약번호 생성
        contract.setContNo(facilityContractMapper.selectNextContNo());

        // 관리사무소 번호로 단지번호 조회
        contract.setAptCmplexNo(facilityContractMapper.selectAptCmplexNoByMgmtOfcNo(contract.getMgmtOfcNo()));

        // 첨부파일이 있으면 FILE_GROUP_NO 생성
        if (hasFiles(contractFiles)) {
            Long fileGroupNo = facilityContractMapper.selectNextFileGroupNo();
            contract.setFileGroupNo(fileGroupNo);

            /*
             * 파일 실제 저장은 기존 파일/드라이브 서비스명 확인 후 연결해야 한다.
             * 여기서는 FACILITY_CONTRACT.FILE_GROUP_NO까지 흐름만 맞춘다.
             */
            log.debug("계약 첨부파일 저장 연결 필요 fileGroupNo={}, fileCount={}", fileGroupNo, contractFiles.size());
        }

        // 계약 기본정보 등록
        facilityContractMapper.insertContract(contract);

        // 시설 대상 계약이면 FACILITY_CONTRACT_TARGET 등록
        if ("FACILITY".equals(contract.getContTargetCd())) {
            insertContractTargets(contract);
        }

        // 검침 계약이면 UTILITY_PROVIDER 등록
        if ("METER".equals(contract.getContTargetCd())) {
            insertUtilityProvider(contract);
        }
    }

    /**
     * 계약 수정
     */
    @Override
    @Transactional
    public void updateContract(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            List<String> deleteFileSaveUuidList
    ) {
        // 관리사무소 번호로 단지번호 조회
        contract.setAptCmplexNo(facilityContractMapper.selectAptCmplexNoByMgmtOfcNo(contract.getMgmtOfcNo()));

        // 첨부파일 DB 삭제
        if (deleteFileSaveUuidList != null && !deleteFileSaveUuidList.isEmpty()) {
            for (String fileSaveUuid : deleteFileSaveUuidList) {
                facilityContractMapper.deleteAttachFileByUuid(fileSaveUuid);
            }
        }

        // 새 첨부파일이 있으면 FILE_GROUP_NO 확보
        if (hasFiles(contractFiles)) {
            if (contract.getFileGroupNo() == null) {
                Long fileGroupNo = facilityContractMapper.selectNextFileGroupNo();
                contract.setFileGroupNo(fileGroupNo);
            }

            /*
             * 파일 실제 저장은 기존 파일/드라이브 서비스명 확인 후 연결해야 한다.
             * 여기서는 FACILITY_CONTRACT.FILE_GROUP_NO까지 흐름만 맞춘다.
             */
            log.debug("계약 첨부파일 추가 저장 연결 필요 fileGroupNo={}, fileCount={}", contract.getFileGroupNo(), contractFiles.size());
        }

        // 계약 기본정보 수정
        facilityContractMapper.updateContract(contract);

        // 기존 대상 시설 연결 삭제
        facilityContractMapper.deleteContractTargets(contract.getContNo());

        // 시설 대상 계약이면 대상 시설 재등록
        if ("FACILITY".equals(contract.getContTargetCd())) {
            insertContractTargets(contract);
        }

        // 검침 계약이면 검침 설정 등록/수정
        if ("METER".equals(contract.getContTargetCd())) {
            int utilityCount = facilityContractMapper.countUtilityProviderByContNo(contract.getContNo());

            if (utilityCount > 0) {
                facilityContractMapper.updateUtilityProvider(contract);
            } else {
                insertUtilityProvider(contract);
            }
        }
    }

    /**
     * 계약 대상 시설 연결 등록
     */
    private void insertContractTargets(FacilityContractDTO contract) {
        if (contract.getTargetFacilityNoList() == null || contract.getTargetFacilityNoList().isEmpty()) {
            return;
        }

        for (String facilityNo : contract.getTargetFacilityNoList()) {
            FacilityContractTargetVO target = new FacilityContractTargetVO();

            // 계약번호 + 시설번호 연결
            target.setContNo(contract.getContNo());
            target.setFacilityNo(facilityNo);

            facilityContractMapper.insertContractTarget(target);
        }
    }

    /**
     * 검침 설정 등록
     */
    private void insertUtilityProvider(FacilityContractDTO contract) {
        // UTILITY_PROVIDER_NO 생성
        contract.setUtilityProviderNo(facilityContractMapper.selectNextUtilityProviderNo());

        // 검침 설정 비고는 DB에서 NOT NULL이므로 비어 있으면 기본값 세팅
        if (contract.getUtilityRmrkCn() == null || contract.getUtilityRmrkCn().isBlank()) {
            contract.setUtilityRmrkCn("-");
        }

        facilityContractMapper.insertUtilityProvider(contract);
    }

    /**
     * 실제 업로드 파일 존재 여부 확인
     */
    private boolean hasFiles(List<MultipartFile> files) {
        if (files == null || files.isEmpty()) {
            return false;
        }

        return files.stream().anyMatch(file -> file != null && !file.isEmpty());
    }
}
