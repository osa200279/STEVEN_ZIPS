package kr.or.ddit.domain.apt.mgmtOffice.contract.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
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

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 시설 계약 관리 Service 구현체
 *
 * 기준 테이블
 * - FACILITY_CONTRACT
 * - FACILITY_CONTRACT_TARGET
 * - UTILITY_PROVIDER
 * - ATTACH_FILE
 *
 * 파일 저장 기준
 * - Google Drive 폴더 : apt/FC_contract/{aptCmplexNo}/{contNo}
 * - ATTACH_FILE.CAT : FC_CONTRACT
 */
@Slf4j
@Service
public class FacilityContractServiceImpl implements IFacilityContractService {

    @Autowired
    private IFacilityContractMapper facilityContractMapper;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

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
        // 계약 기본 상세 조회
        FacilityContractDTO contract = facilityContractMapper.selectContractDetail(mgmtOfcNo, contNo);

        // 계약이 없으면 그대로 반환
        if (contract == null) {
            return null;
        }

        // 계약 대상 시설 목록 조회
        contract.setTargetFacilityList(facilityContractMapper.selectContractTargetList(contNo));

        // 수정 폼 체크박스 선택값 복원용 시설번호 목록 조회
        contract.setTargetFacilityNoList(facilityContractMapper.selectContractTargetNoList(contNo));

        // 검침 설정 조회
        FacilityContractDTO utilityInfo = facilityContractMapper.selectUtilityProviderByContNo(contNo);

        if (utilityInfo != null) {
            // 검침 설정번호 세팅
            contract.setUtilityProviderNo(utilityInfo.getUtilityProviderNo());

            // CSV 식별키 세팅
            contract.setCsvIdntfKey(utilityInfo.getCsvIdntfKey());

            // 외부 고객번호 세팅
            contract.setExtCustNo(utilityInfo.getExtCustNo());

            // 검침 설정 비고 세팅
            contract.setUtilityRmrkCn(utilityInfo.getUtilityRmrkCn());

            // 검침 종류 세팅
            // - UTILITY_PROVIDER.METER_TY_CD
            // - 수정 화면에서 전기/수도/가스 선택값 복원용
            contract.setMeterTyCd(utilityInfo.getMeterTyCd());
        }

        // 첨부파일 목록 조회
        if (contract.getFileGroupNo() != null) {
            contract.setFileList(facilityContractMapper.selectContractFileList(contract.getFileGroupNo()));
        }

        return contract;
    }

    /**
     * 계약유형 공통코드 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectContractTypeList() {
        return facilityContractMapper.selectContractTypeList();
    }

    /**
     * 시설 등록 화면용 연결 가능한 설치계약 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectAvailableInstallContractList(String mgmtOfcNo) {
        return facilityContractMapper.selectAvailableInstallContractList(mgmtOfcNo);
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
     *
     * 처리 순서
     * 1. 계약번호 생성
     * 2. 관리사무소 번호 기준 단지번호 세팅
     * 3. 대표 시설번호 보정
     * 4. 계약서 파일 업로드 및 FILE_GROUP_NO 세팅
     * 5. 계약 기본정보 등록
     * 6. 대상 시설 연결 등록
     * 7. 검침 계약이면 검침 설정 등록
     */
    @Override
    @Transactional
    public void insertContract(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            String userNo
    ) {
        // 계약번호 생성
        contract.setContNo(facilityContractMapper.selectNextContNo());

        // 관리사무소 번호로 단지번호 조회
        contract.setAptCmplexNo(facilityContractMapper.selectAptCmplexNoByMgmtOfcNo(contract.getMgmtOfcNo()));

        // 대표 시설번호 보정
        applyMainFacilityNo(contract);

        // 계약서 파일 업로드
        uploadContractFiles(contract, contractFiles, userNo);

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
     *
     * 처리 순서
     * 1. 관리사무소 번호 기준 단지번호 세팅
     * 2. 삭제 선택 파일 처리
     * 3. 대표 시설번호 보정
     * 4. 새 계약서 파일 업로드
     * 5. 계약 기본정보 수정
     * 6. 대상 시설 재연결
     * 7. 검침 계약이면 검침 설정 등록/수정
     */
    @Override
    @Transactional
    public void updateContract(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            List<String> deleteFileSaveUuidList,
            String userNo
    ) {
        // 관리사무소 번호로 단지번호 조회
        contract.setAptCmplexNo(facilityContractMapper.selectAptCmplexNoByMgmtOfcNo(contract.getMgmtOfcNo()));

        // 기존 첨부파일 삭제
        deleteContractFiles(contract.getFileGroupNo(), deleteFileSaveUuidList);

        // 대표 시설번호 보정
        applyMainFacilityNo(contract);

        // 새 계약서 파일 업로드
        uploadContractFiles(contract, contractFiles, userNo);

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
            // 검침 종류 필수 확인
            // - 수정 화면에서 검침 종류가 빠진 상태로 저장되는 것을 방지한다.
            validateMeterTyCd(contract);

            // 기존 검침 설정 존재 여부 확인
            int utilityCount = facilityContractMapper.countUtilityProviderByContNo(contract.getContNo());

            // 기존 설정이 있으면 수정, 없으면 신규 등록
            if (utilityCount > 0) {
                facilityContractMapper.updateUtilityProvider(contract);
            } else {
                insertUtilityProvider(contract);
            }
        }
    }

    /**
     * 설치계약을 신규 시설자산에 연결
     */
    @Override
    @Transactional
    public void connectInstallContractToFacility(String contNo, String facilityNo) {
        // 필수값 없음
        if (contNo == null || contNo.isBlank() || facilityNo == null || facilityNo.isBlank()) {
            return;
        }

        // 계약 대상 시설 중복 확인
        int duplicateCount = facilityContractMapper.countContractTarget(contNo, facilityNo);

        // 중복이 아니면 대상 시설 연결 등록
        if (duplicateCount == 0) {
            FacilityContractTargetVO target = new FacilityContractTargetVO();
            target.setContNo(contNo);
            target.setFacilityNo(facilityNo);

            facilityContractMapper.insertContractTarget(target);
        }

        // 대표 시설번호도 보정
        facilityContractMapper.updateContractMainFacilityNo(contNo, facilityNo);
    }

    /**
     * 대표 시설번호 보정
     * - 시설 대상 계약에서 선택 시설이 있으면 첫 번째 시설을 FACILITY_CONTRACT.FACILITY_NO에도 보관한다.
     * - 설치공사처럼 아직 대상 시설이 없으면 null 상태로 둔다.
     */
    private void applyMainFacilityNo(FacilityContractDTO contract) {
        // 선택 시설이 있으면 첫 번째 시설을 대표 시설번호로 사용
        if (contract.getTargetFacilityNoList() != null && !contract.getTargetFacilityNoList().isEmpty()) {
            contract.setFacilityNo(contract.getTargetFacilityNoList().get(0));
            return;
        }

        // 선택 시설이 없으면 대표 시설번호 없음
        contract.setFacilityNo(null);
    }

    /**
     * 계약 대상 시설 연결 등록
     */
    private void insertContractTargets(FacilityContractDTO contract) {
        // 대상 시설 없음
        if (contract.getTargetFacilityNoList() == null || contract.getTargetFacilityNoList().isEmpty()) {
            return;
        }

        for (String facilityNo : contract.getTargetFacilityNoList()) {
            // 빈 시설번호 제외
            if (facilityNo == null || facilityNo.isBlank()) {
                continue;
            }

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
        // 검침 종류 필수 확인
        // - UTILITY_PROVIDER.METER_TY_CD 저장값
        // - 전기/수도/가스 구분이 없으면 검침 화면에서 데이터 분류가 어려워진다.
        validateMeterTyCd(contract);

        // UTILITY_PROVIDER_NO 생성
        contract.setUtilityProviderNo(facilityContractMapper.selectNextUtilityProviderNo());

        // 검침 설정 비고는 DB에서 NOT NULL이므로 비어 있으면 기본값 세팅
        if (contract.getUtilityRmrkCn() == null || contract.getUtilityRmrkCn().isBlank()) {
            contract.setUtilityRmrkCn("-");
        }

        // 검침 설정 등록
        facilityContractMapper.insertUtilityProvider(contract);
    }

    /**
     * 검침 종류 필수 검증
     * - 검침 계약은 전기/수도/가스 구분값이 반드시 필요하다.
     * - 화면에서 검침 종류를 선택하지 않고 저장되는 것을 방지한다.
     */
    private void validateMeterTyCd(FacilityContractDTO contract) {
        // 검침 종류가 없으면 저장 중단
        if (contract.getMeterTyCd() == null || contract.getMeterTyCd().isBlank()) {
            throw new RuntimeException("검침 계약은 검침 종류를 선택해야 합니다.");
        }
    }

    /**
     * 계약서 첨부파일 업로드
     *
     * 처리 순서
     * 1. 실제 업로드 파일 존재 확인
     * 2. FILE_GROUP_NO 확보
     * 3. Google Drive 업로드
     * 4. ATTACH_FILE 등록
     * 5. 업로드 실패 시 Google Drive 롤백
     */
    private void uploadContractFiles(
            FacilityContractDTO contract,
            List<MultipartFile> contractFiles,
            String userNo
    ) {
        // 업로드 파일 없음
        if (!hasFiles(contractFiles)) {
            return;
        }

        // Google Drive 롤백 대상 ID 목록
        List<String> uploadedGoogleIds = new ArrayList<>();

        // Google Drive 객체
        Drive drive = null;

        try {
            // Google Drive 객체 생성
            drive = googleDriveService.getDriveService();

            // 파일그룹번호 확보
            Long fileGroupNo = contract.getFileGroupNo();

            if (fileGroupNo == null) {
                fileGroupNo = attachFileMapper.getSeqFileGroupNo();
                contract.setFileGroupNo(fileGroupNo);
            }

            // 파일 정렬 순서
            int sortOrder = 0;

            for (MultipartFile contractFile : contractFiles) {
                // 빈 파일 제외
                if (contractFile == null || contractFile.isEmpty()) {
                    continue;
                }

                // 원본 파일명
                String originalFilename = contractFile.getOriginalFilename();

                // 저장 UUID
                String uuid = UUID.randomUUID().toString().replace("-", "");

                // 저장 파일명
                String savedFileName = uuid + "_" + originalFilename;

                // Google Drive 폴더 경로
                String folderPath = "apt/FC_contract/"
                        + contract.getAptCmplexNo() + "/"
                        + contract.getContNo();

                // DB 저장용 전체 경로
                String fullPath = folderPath + "/" + savedFileName;

                // Google Drive 업로드 시작 시간
                long uploadStartTime = System.currentTimeMillis();

                // Google Drive 업로드
                String googleId = googleDriveService.uploadFile(
                        contractFile,
                        folderPath,
                        savedFileName
                );

                // Google Drive 업로드 로그
                log.info("계약서 Google Drive 업로드 완료 userNo={}, elapsed={}ms, fileName={}",
                        userNo,
                        System.currentTimeMillis() - uploadStartTime,
                        originalFilename
                );

                // Google Drive 롤백 대상 추가
                uploadedGoogleIds.add(googleId);

                // 첨부파일 VO 생성
                AttachFileVO file = AttachFileVO.fileSettings(
                        contractFile,
                        fileGroupNo,
                        "FC_CONTRACT",
                        savedFileName,
                        googleId,
                        fullPath,
                        sortOrder
                );

                // ATTACH_FILE 등록
                attachFileMapper.insertAttachFile(file);

                // 정렬 순서 증가
                sortOrder++;
            }
        } catch (Exception e) {
            // 계약서 파일 업로드 오류 로그
            log.error("계약서 파일 업로드 오류", e);

            // Google Drive 업로드 롤백
            rollbackUploadedFiles(drive, uploadedGoogleIds);

            // 트랜잭션 롤백용 RuntimeException
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 계약 첨부파일 삭제
     * - Google Drive 휴지통 이동 후 ATTACH_FILE 레코드를 삭제한다.
     * - Google Drive 권한이 꼬인 테스트 파일이면 여기서 403이 날 수 있다.
     */
    private void deleteContractFiles(Long fileGroupNo, List<String> deleteFileSaveUuidList) {
        // 삭제 대상 없음
        if (fileGroupNo == null || deleteFileSaveUuidList == null || deleteFileSaveUuidList.isEmpty()) {
            return;
        }

        // 기존 파일 목록 조회
        List<Map<String, Object>> fileList = facilityContractMapper.selectContractFileList(fileGroupNo);

        // Google Drive 객체
        Drive drive = null;

        try {
            // Google Drive 객체 생성
            drive = googleDriveService.getDriveService();

            for (String fileSaveUuid : deleteFileSaveUuidList) {
                // 빈 UUID 제외
                if (fileSaveUuid == null || fileSaveUuid.isBlank()) {
                    continue;
                }

                // 삭제 대상 파일의 Google ID 조회
                String googleId = findGoogleId(fileList, fileSaveUuid.trim());

                // Google ID가 있으면 Drive 휴지통 이동
                if (googleId != null && !googleId.isBlank()) {
                    googleDriveService.moveToTrash(drive, googleId);
                }

                // ATTACH_FILE DB 삭제
                facilityContractMapper.deleteAttachFileByUuid(fileSaveUuid.trim());
            }
        } catch (Exception e) {
            // 계약 첨부파일 삭제 오류 로그
            log.error("계약 첨부파일 삭제 오류", e);

            // 트랜잭션 롤백용 RuntimeException
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 파일 목록에서 저장 UUID 기준 Google ID 찾기
     */
    private String findGoogleId(List<Map<String, Object>> fileList, String fileSaveUuid) {
        // 파일 목록 없음
        if (fileList == null || fileList.isEmpty()) {
            return null;
        }

        for (Map<String, Object> file : fileList) {
            // 파일 정보 없음
            if (file == null) {
                continue;
            }

            // Map key는 XML alias 기준
            Object savedUuid = file.get("fileSaveUuid");

            if (savedUuid != null && fileSaveUuid.equals(String.valueOf(savedUuid))) {
                Object googleId = file.get("googleId");
                return googleId == null ? null : String.valueOf(googleId);
            }
        }

        return null;
    }

    /**
     * Google Drive 업로드 롤백
     */
    private void rollbackUploadedFiles(Drive drive, List<String> uploadedGoogleIds) {
        // 롤백 대상 없음
        if (drive == null || uploadedGoogleIds == null || uploadedGoogleIds.isEmpty()) {
            return;
        }

        for (String googleId : uploadedGoogleIds) {
            try {
                // Google Drive 휴지통 이동
                googleDriveService.moveToTrash(drive, googleId);
            } catch (Exception e) {
                // Google Drive 롤백 실패 로그
                log.error("계약서 파일 롤백 실패 googleId={}", googleId, e);
            }
        }
    }

    /**
     * 실제 업로드 파일 존재 여부 확인
     */
    private boolean hasFiles(List<MultipartFile> files) {
        // 파일 목록 없음
        if (files == null || files.isEmpty()) {
            return false;
        }

        // 실제 파일이 하나라도 있으면 true
        return files.stream().anyMatch(file -> file != null && !file.isEmpty());
    }
}
