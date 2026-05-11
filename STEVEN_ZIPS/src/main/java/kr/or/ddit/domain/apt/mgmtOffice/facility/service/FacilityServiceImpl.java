package kr.or.ddit.domain.apt.mgmtOffice.facility.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.mapper.IFacilityMapper;
import kr.or.ddit.domain.apt.mgmtOffice.facility.vo.FacilityVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 시설자산 Service 구현체
 * FACILITY 기본 CRUD + 사진 업로드/삭제 + 이용불가 통계
 */
@Slf4j
@Service
@Transactional(rollbackFor = Exception.class)
public class FacilityServiceImpl implements IFacilityService {

    @Autowired
    private IFacilityMapper facilityMapper;         // 시설 Mapper

    @Autowired
    private IAttachFileMapper attachFileMapper;     // 공통 첨부파일 Mapper

    @Autowired
    private GoogleDriveService googleDriveService;  // Google Drive 업로드·삭제

    /**
     * 시설 목록 조회
     */
    @Override
    public List<FacilityVO> selectFacilityList(Map<String, Object> paramMap) {
        return facilityMapper.selectFacilityList(paramMap);
    }

    /**
     * 시설 상세 조회
     */
    @Override
    public FacilityVO selectFacilityDetail(String mgmtOfcNo, String facilityNo) {
        return facilityMapper.selectFacilityDetail(mgmtOfcNo, facilityNo);
    }

    /**
     * 시설 첨부파일 목록 조회
     * fileGroupNo 없는 시설은 사진 없음으로 처리
     */
    @Override
    public List<AttachFileVO> selectFacilityFileList(Long fileGroupNo) {
        /* 파일그룹번호 없으면 빈 목록 반환 */
        if (fileGroupNo == null) {
            return List.of();
        }

        return facilityMapper.selectFacilityFileList(fileGroupNo);
    }

    /**
     * 이용불가 시설 통계 조회
     * 현황 카드 표시용
     * 반환 키: DISABLED_TOTAL(전체) / DISABLED_TODAY(오늘 FAULT 판정)
     */
    @Override
    public Map<String, Object> selectDisabledStats(String mgmtOfcNo) {
        return facilityMapper.selectDisabledStats(mgmtOfcNo);
    }

    /**
     * 시설 등록
     *
     * 처리 순서
     * 1. 시설번호 채번 (시퀀스 기반 FAC0001)
     * 2. 단지번호 서버 기준 세팅 (화면 위변조 방지)
     * 3. 사용여부 기본값 처리
     * 4. 사진 업로드
     * 5. FACILITY INSERT
     */
    @Override
    public boolean insertFacility(
            String mgmtOfcNo,
            FacilityVO facilityVO,
            MultipartFile[] facilityFiles,
            String userNo
    ) {
        /* 시설번호 채번 및 세팅 */
        String facilityNo = facilityMapper.getFacilityNo();  // 생성된 시설번호
        facilityVO.setFacilityNo(facilityNo);

        /* 서버 기준 단지번호 세팅 (화면 위변조 방지) */
        String aptCmplexNo = facilityMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo); // 단지번호
        facilityVO.setAptCmplexNo(aptCmplexNo);

        /* 사용여부 기본값: 미전달 시 이용 가능(Y) */
        if (facilityVO.getUseYn() == null || facilityVO.getUseYn().isBlank()) {
            facilityVO.setUseYn("Y");
        }

        /* 사진 업로드 (파일 없으면 내부에서 바로 리턴) */
        uploadFacilityFiles(facilityVO, facilityFiles, userNo);

        return facilityMapper.insertFacility(facilityVO) > 0;
    }

    /**
     * 시설 수정
     *
     * 수정 가능 항목: 시설명 · 설치일자 · 상세위치 · 사용여부 · 사진
     * 수정 제외 항목: 시설유형 · 단지번호 · 동번호
     *
     * deleteFileUuids: 삭제할 FILE_SAVE_UUID 목록 (쉼표 구분)
     */
    @Override
    public boolean updateFacility(
            String mgmtOfcNo,
            FacilityVO facilityVO,
            MultipartFile[] facilityFiles,
            String deleteFileUuids,
            String userNo
    ) {
        /* 기존 시설 조회 (보정값 확보용) */
        FacilityVO savedFacility = facilityMapper.selectFacilityDetail(
                mgmtOfcNo,
                facilityVO.getFacilityNo()
        ); // 기존 저장된 시설 정보

        if (savedFacility == null) {
            return false;
        }

        /* 파일 경로 생성에 필요한 기존 값 보정 */
        facilityVO.setAptCmplexNo(savedFacility.getAptCmplexNo()); // 단지번호
        facilityVO.setFacilityTyCd(savedFacility.getFacilityTyCd()); // 시설유형코드

        /* 파일그룹번호: 화면에서 미전달 시 기존 값 유지 */
        if (facilityVO.getFileGroupNo() == null) {
            facilityVO.setFileGroupNo(savedFacility.getFileGroupNo());
        }

        /* 기존 사진 삭제 (Google Drive 휴지통 이동 + ATTACH_FILE 삭제) */
        if (deleteFileUuids != null && !deleteFileUuids.isBlank()) {
            for (String fileSaveUuid : deleteFileUuids.split(",")) {
                if (fileSaveUuid == null || fileSaveUuid.isBlank()) continue;

                /* 삭제 파라미터 구성 */
                Map<String, Object> param = new HashMap<>();
                param.put("fileGroupNo",  facilityVO.getFileGroupNo()); // 파일그룹번호
                param.put("fileSaveUuid", fileSaveUuid.trim());         // 저장 UUID

                deleteFacilityFile(param);
            }
        }

        /* 신규 사진 업로드 */
        uploadFacilityFiles(facilityVO, facilityFiles, userNo);

        /* 기본정보 수정 (SQL에서 시설유형·단지번호·동번호 제외) */
        return facilityMapper.updateFacility(facilityVO) > 0;
    }

    /**
     * 시설유형 정정 가능 여부 조회
     *
     * 정정 버튼 클릭 시 실제 변경 전 먼저 호출되는 조회 전용 메서드
     * 연결 데이터 없으면 true (정정 가능) / 있으면 false (정정 불가)
     * selectFacilityLinkedCount 단일 쿼리로 계약·점검이력·검침기록 합산 확인
     */
    @Override
    public boolean checkFacilityTypeCorrection(String mgmtOfcNo, FacilityVO facilityVO) {
        /* 연결 데이터 건수 합산 조회 */
        int linkedCnt = facilityMapper.selectFacilityLinkedCount(facilityVO.getFacilityNo());

        /* 0이면 정정 가능 */
        return linkedCnt == 0;
    }

    /**
     * 시설유형 정정
     *
     * 계약·점검이력·검침기록 중 하나라도 연결되어 있으면 정정 불가
     * 단일 통합 쿼리로 3번 DB 왕복을 1번으로 처리
     */
    @Override
    public boolean correctFacilityType(String mgmtOfcNo, FacilityVO facilityVO) {
        /* 연결 데이터 건수 합산 조회 */
        int linkedCnt = facilityMapper.selectFacilityLinkedCount(facilityVO.getFacilityNo()); // 연결 건수 합계

        /* 연결 데이터 존재 시 정정 불가 */
        if (linkedCnt > 0) {
            return false;
        }

        return facilityMapper.correctFacilityType(facilityVO) > 0;
    }

    /**
     * 시설 사용여부 변경
     * 삭제 대신 USE_YN 변경
     * FAULT 판정 시 트리거(trg_facility_use_yn) 자동 N
     * 복구(Y)는 관리자 수동 호출
     */
    @Override
    public boolean updateFacilityUseYn(String mgmtOfcNo, FacilityVO facilityVO) {
        return facilityMapper.updateFacilityUseYn(facilityVO) > 0;
    }

    /**
     * 시설 첨부파일 삭제
     *
     * 처리 순서
     * 1. FILE_GROUP_NO + FILE_SAVE_UUID 기준 ATTACH_FILE 조회
     * 2. Google Drive 파일 휴지통 이동
     * 3. ATTACH_FILE 레코드 삭제
     */
    @Override
    public boolean deleteFacilityFile(Map<String, Object> param) {
        try {
            /* 파일그룹번호 (ATTACH_FILE 복합 PK 첫 번째) */
            Long fileGroupNo = Long.valueOf(String.valueOf(param.get("fileGroupNo")));

            /* 저장 UUID (ATTACH_FILE 복합 PK 두 번째) */
            String fileSaveUuid = String.valueOf(param.get("fileSaveUuid"));

            /* 삭제 대상 파일 조회 */
            AttachFileVO file = facilityMapper.selectFacilityFile(fileGroupNo, fileSaveUuid); // 조회된 파일 정보

            if (file == null) {
                return false;
            }

            /* Google Drive 휴지통 이동 (경로 아닌 googleId 기준) */
            Drive drive = googleDriveService.getDriveService(); // Drive 서비스 객체
            googleDriveService.moveToTrash(drive, file.getGoogleId());

            return facilityMapper.deleteFacilityFile(fileGroupNo, fileSaveUuid) > 0;

        } catch (Exception e) {
            log.error("시설 파일 삭제 오류", e);
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 동 목록 조회
     * 시설 등록 화면 동 선택 드롭다운용
     */
    @Override
    public List<FacilityVO> selectDongList(String mgmtOfcNo) {
        return facilityMapper.selectDongList(mgmtOfcNo);
    }

    /**
     * 시설 첨부파일 업로드 (등록·수정 공통)
     *
     * 처리 순서
     * 1. 업로드할 파일 없으면 종료
     * 2. 파일그룹번호 없으면 신규 채번
     * 3. Google Drive 업로드
     * 4. ATTACH_FILE INSERT
     *
     * 중간 실패 시 이미 업로드된 파일을 Google Drive 휴지통으로 롤백
     */
    private void uploadFacilityFiles(
            FacilityVO facilityVO,
            MultipartFile[] facilityFiles,
            String userNo
    ) {
        /* 업로드할 파일 없으면 종료 */
        if (facilityFiles == null || facilityFiles.length == 0) {
            return;
        }

        /* 롤백용 업로드 완료 Google Drive ID 목록 */
        List<String> uploadedGoogleIds = new ArrayList<>();

        /* catch 블록에서도 필요하므로 try 밖 선언 */
        Drive drive = null;

        try {
            drive = googleDriveService.getDriveService(); // Drive 서비스 객체

            /* 파일그룹번호: 없으면 신규 채번 */
            Long fileGroupNo = facilityVO.getFileGroupNo(); // 파일그룹번호
            if (fileGroupNo == null) {
                fileGroupNo = attachFileMapper.getSeqFileGroupNo();
                facilityVO.setFileGroupNo(fileGroupNo);
            }

            int size = facilityFiles.length; // 업로드 파일 수

            /* ATTACH_FILE INSERT용 VO 배열 */
            AttachFileVO[] files = new AttachFileVO[size];

            for (int i = 0; i < size; i++) {
                if (facilityFiles[i] == null || facilityFiles[i].isEmpty()) continue;

                String originalFilename = facilityFiles[i].getOriginalFilename(); // 원본 파일명
                String uuid             = UUID.randomUUID().toString().replace("-", ""); // 중복 방지 UUID
                String savedFileName    = uuid + "_" + originalFilename; // 저장 파일명 (FILE_SAVE_UUID)

                /* Google Drive 폴더 경로 */
                String folderPath = "apt/facility/"
                        + userNo                         + "/"
                        + facilityVO.getAptCmplexNo()    + "/"
                        + facilityVO.getFacilityTyCd()   + "/"
                        + facilityVO.getFacilityNo();

                String fullPath = folderPath + "/" + savedFileName; // DB 저장용 전체 경로

                /* Google Drive 업로드 (반환값: 파일 식별 ID) */
                String googleId = googleDriveService.uploadFile(
                        facilityFiles[i],
                        folderPath,
                        savedFileName
                ); // Google Drive 파일 ID

                uploadedGoogleIds.add(googleId);

                /* ATTACH_FILE INSERT용 VO 생성 */
                files[i] = AttachFileVO.fileSettings(
                        facilityFiles[i],
                        fileGroupNo,
                        "시설사진",     // 파일 카테고리
                        savedFileName,
                        googleId,
                        fullPath,
                        i               // 정렬 순서
                );
            }

            /* ATTACH_FILE INSERT */
            for (AttachFileVO file : files) {
                if (file != null) {
                    attachFileMapper.insertAttachFile(file);
                }
            }

        } catch (Exception e) {
            log.error("시설 파일 업로드 오류", e);

            /* 업로드 완료된 파일 Google Drive 롤백 */
            if (drive != null && !uploadedGoogleIds.isEmpty()) {
                for (String googleId : uploadedGoogleIds) {
                    try {
                        googleDriveService.moveToTrash(drive, googleId);
                    } catch (Exception ex) {
                        log.error("시설 파일 롤백 실패 googleId={}", googleId, ex);
                    }
                }
            }

            throw new RuntimeException(e.getMessage(), e);
        }
    }
}