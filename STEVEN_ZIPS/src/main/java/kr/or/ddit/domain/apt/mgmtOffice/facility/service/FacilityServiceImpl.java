package kr.or.ddit.domain.apt.mgmtOffice.facility.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityDTO;
import kr.or.ddit.domain.apt.mgmtOffice.facility.dto.FacilityLocationDTO;
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
 * 시설 Service 구현체
 *
 * 역할
 * - FACILITY 기본 CRUD
 * - 시설 화면 조회
 * - 시설 사진 업로드/삭제
 * - 시설유형 정정
 * - 위치 조회
 *
 * 저장 방식
 * - 시설 등록/수정과 사진 처리를 같은 요청 안에서 동기 처리
 */
@Slf4j
@Service
@Transactional(rollbackFor = Exception.class)
public class FacilityServiceImpl implements IFacilityService {

    @Autowired
    private IFacilityMapper facilityMapper; // 시설 Mapper

    @Autowired
    private IAttachFileMapper attachFileMapper; // 공통 첨부파일 Mapper

    @Autowired
    private GoogleDriveService googleDriveService; // Google Drive Service

    /**
     * 시설 목록 조회
     */
    @Override
    public List<FacilityVO> selectFacilityList(Map<String, Object> paramMap) {
        /* 시설 목록 반환 */
        return facilityMapper.selectFacilityList(paramMap);
    }

    /**
     * 시설 화면 목록 조회
     */
    @Override
    public List<FacilityDTO> selectFacilityViewList(Map<String, Object> paramMap) {
        /* 시설 화면 목록 반환 */
        return facilityMapper.selectFacilityViewList(paramMap);
    }

    /**
     * 시설 화면 목록 건수 조회
     */
    @Override
    public int selectFacilityViewCount(Map<String, Object> paramMap) {
        /* 시설 화면 목록 건수 반환 */
        return facilityMapper.selectFacilityViewCount(paramMap);
    }

    /**
     * 시설 화면 상세 조회
     */
    @Override
    public FacilityDTO selectFacilityViewDetail(String mgmtOfcNo, String facilityNo) {
        /* 시설 화면 상세 반환 */
        return facilityMapper.selectFacilityViewDetail(mgmtOfcNo, facilityNo);
    }

    /**
     * 시설 상세 조회
     */
    @Override
    public FacilityVO selectFacilityDetail(String mgmtOfcNo, String facilityNo) {
        /* 시설 상세 반환 */
        return facilityMapper.selectFacilityDetail(mgmtOfcNo, facilityNo);
    }

    /**
     * 시설 첨부파일 목록 조회
     */
    @Override
    public List<AttachFileVO> selectFacilityFileList(Long fileGroupNo) {
        /* 파일그룹번호 없음 */
        if (fileGroupNo == null) {
            return new ArrayList<>();
        }

        /* 시설 첨부파일 목록 반환 */
        return facilityMapper.selectFacilityFileList(fileGroupNo);
    }

    /**
     * 이용불가 시설 통계 조회
     */
    @Override
    public Map<String, Object> selectDisabledStats(String mgmtOfcNo) {
        /* 이용불가 시설 통계 반환 */
        return facilityMapper.selectDisabledStats(mgmtOfcNo);
    }

    /**
     * 시설유형 필터 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectFacilityTypeList(Map<String, Object> paramMap) {
        /* 시설유형 필터 목록 반환 */
        return facilityMapper.selectFacilityTypeList(paramMap);
    }

    /**
     * 등록 화면 편의시설 유형 목록 조회
     */
    @Override
    public List<Map<String, Object>> selectPublicFacilityTypeList() {
        /* 편의시설 유형 목록 반환 */
        return facilityMapper.selectPublicFacilityTypeList();
    }

    /**
     * 시설 등록
     *
     * 처리 순서
     * 1. 시설번호 채번
     * 2. 단지번호 세팅
     * 3. 사용여부 기본값 세팅
     * 4. 시설 사진 업로드
     * 5. FACILITY 등록
     */
    @Override
    public boolean insertFacility(
            String mgmtOfcNo,
            FacilityVO facilityVO,
            MultipartFile[] facilityFiles,
            String userNo
    ) {
        /* 시설번호 채번 */
        String facilityNo = facilityMapper.getFacilityNo();
        facilityVO.setFacilityNo(facilityNo);

        /* 단지번호 세팅 */
        String aptCmplexNo = facilityMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);
        facilityVO.setAptCmplexNo(aptCmplexNo);

        /* 사용여부 기본값 */
        if (facilityVO.getUseYn() == null || facilityVO.getUseYn().isBlank()) {
            facilityVO.setUseYn("Y");
        }

        /* 시설 사진 업로드 */
        uploadFacilityFiles(facilityVO, facilityFiles, userNo);

        /* 시설 기본정보 등록 */
        return facilityMapper.insertFacility(facilityVO) > 0;
    }

    /**
     * 시설 수정
     *
     * 처리 순서
     * 1. 기존 시설 조회
     * 2. 단지번호/시설유형/파일그룹번호 보정
     * 3. 기존 사진 삭제
     * 4. 신규 사진 업로드
     * 5. FACILITY 기본정보 수정
     */
    @Override
    public boolean updateFacility(
            String mgmtOfcNo,
            FacilityVO facilityVO,
            MultipartFile[] facilityFiles,
            String deleteFileUuids,
            String userNo
    ) {
        /* 기존 시설 조회 */
        FacilityVO savedFacility = facilityMapper.selectFacilityDetail(
                mgmtOfcNo,
                facilityVO.getFacilityNo()
        );

        /* 기존 시설 없음 */
        if (savedFacility == null) {
            return false;
        }

        /* 단지번호 보정 */
        facilityVO.setAptCmplexNo(savedFacility.getAptCmplexNo());

        /* 시설유형 보정 */
        facilityVO.setFacilityTyCd(savedFacility.getFacilityTyCd());

        /* 파일그룹번호 보정 */
        if (facilityVO.getFileGroupNo() == null) {
            facilityVO.setFileGroupNo(savedFacility.getFileGroupNo());
        }

        /* 기존 사진 삭제 */
        deleteFacilityFiles(facilityVO.getFileGroupNo(), deleteFileUuids);

        /* 신규 사진 업로드 */
        uploadFacilityFiles(facilityVO, facilityFiles, userNo);

        /* 시설 기본정보 수정 */
        return facilityMapper.updateFacility(facilityVO) > 0;
    }

    /**
     * 시설유형 정정 가능 여부 조회
     */
    @Override
    public boolean checkFacilityTypeCorrection(String mgmtOfcNo, FacilityVO facilityVO) {
        /* 시설 연결 데이터 건수 */
        int linkedCnt = facilityMapper.selectFacilityLinkedCount(facilityVO.getFacilityNo());

        /* 연결 데이터 없음 여부 */
        return linkedCnt == 0;
    }

    /**
     * 시설유형 정정
     */
    @Override
    public boolean correctFacilityType(String mgmtOfcNo, FacilityVO facilityVO) {
        /* 시설 연결 데이터 건수 */
        int linkedCnt = facilityMapper.selectFacilityLinkedCount(facilityVO.getFacilityNo());

        /* 연결 데이터 존재 */
        if (linkedCnt > 0) {
            return false;
        }

        /* 시설유형 정정 */
        return facilityMapper.correctFacilityType(facilityVO) > 0;
    }

    /**
     * 시설 사용여부 변경
     */
    @Override
    public boolean updateFacilityUseYn(String mgmtOfcNo, FacilityVO facilityVO) {
        /* 시설 사용여부 변경 */
        return facilityMapper.updateFacilityUseYn(facilityVO) > 0;
    }

    /**
     * 시설 첨부파일 삭제
     */
    @Override
    public boolean deleteFacilityFile(Map<String, Object> param) {
        try {
            /* 파일그룹번호 */
            Long fileGroupNo = Long.valueOf(String.valueOf(param.get("fileGroupNo")));

            /* 저장 UUID */
            String fileSaveUuid = String.valueOf(param.get("fileSaveUuid"));

            /* 삭제 대상 파일 조회 */
            AttachFileVO file = facilityMapper.selectFacilityFile(fileGroupNo, fileSaveUuid);

            /* 삭제 대상 파일 없음 */
            if (file == null) {
                return false;
            }

            /* Google Drive 객체 */
            Drive drive = googleDriveService.getDriveService();

            /* Google Drive 휴지통 이동 */
            googleDriveService.moveToTrash(drive, file.getGoogleId());

            /* ATTACH_FILE 삭제 */
            return facilityMapper.deleteFacilityFile(fileGroupNo, fileSaveUuid) > 0;
        } catch (Exception e) {
            /* 시설 파일 삭제 오류 로그 */
            log.error("시설 파일 삭제 오류", e);

            /* 트랜잭션 롤백용 RuntimeException */
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * 동 목록 조회
     */
    @Override
    public List<FacilityVO> selectDongList(String mgmtOfcNo) {
        /* 시설 동 목록 반환 */
        return facilityMapper.selectDongList(mgmtOfcNo);
    }

    /**
     * 시설 위치 동 목록 조회
     */
    @Override
    public List<FacilityLocationDTO> selectFacilityUnitList(String mgmtOfcNo) {
        /* 관리사무소 기준 단지번호 */
        String aptCmplexNo = facilityMapper.selectAptCmplexNoByMgmtOfcNo(mgmtOfcNo);

        /* 시설 위치 동 목록 반환 */
        return facilityMapper.selectFacilityUnitList(aptCmplexNo);
    }

    /**
     * 시설 위치 층 목록 조회
     */
    @Override
    public List<FacilityLocationDTO> selectFacilityFloorList(String dongNo) {
        /* 시설 위치 층 목록 반환 */
        return facilityMapper.selectFacilityFloorList(dongNo);
    }

    /**
     * 시설 위치 호 목록 조회
     */
    @Override
    public List<FacilityLocationDTO> selectFacilityRoomList(String dongNo, String floor) {
        /* 시설 위치 호 목록 반환 */
        return facilityMapper.selectFacilityRoomList(dongNo, floor);
    }

    /**
     * 시설 사진 삭제 목록 처리
     */
    private void deleteFacilityFiles(Long fileGroupNo, String deleteFileUuids) {
        /* 삭제 대상 없음 */
        if (fileGroupNo == null || deleteFileUuids == null || deleteFileUuids.isBlank()) {
            return;
        }

        /* 삭제 UUID 반복 처리 */
        for (String fileSaveUuid : deleteFileUuids.split(",")) {
            /* 빈 UUID 제외 */
            if (fileSaveUuid == null || fileSaveUuid.isBlank()) {
                continue;
            }

            /* 삭제 파라미터 */
            Map<String, Object> param = new HashMap<>();
            param.put("fileGroupNo", fileGroupNo);
            param.put("fileSaveUuid", fileSaveUuid.trim());

            /* 시설 사진 삭제 */
            deleteFacilityFile(param);
        }
    }

    /**
     * 시설 첨부파일 업로드
     *
     * 처리 순서
     * 1. 업로드 파일 존재 확인
     * 2. 파일그룹번호 채번
     * 3. Google Drive 업로드
     * 4. ATTACH_FILE 등록
     * 5. 업로드 실패 시 Google Drive 롤백
     */
    private void uploadFacilityFiles(
            FacilityVO facilityVO,
            MultipartFile[] facilityFiles,
            String userNo
    ) {
        /* 업로드 파일 없음 */
        if (facilityFiles == null || facilityFiles.length == 0) {
            return;
        }

        //** 수정: 파일 input이 비어 있어도 빈 MultipartFile 배열이 넘어올 수 있어 실제 파일 존재 여부를 먼저 확인
        boolean hasRealUploadFile = false;
        for (MultipartFile facilityFile : facilityFiles) {
            if (facilityFile != null && !facilityFile.isEmpty()) {
                hasRealUploadFile = true;
                break;
            }
        }
        if (!hasRealUploadFile) {
            return;
        }

        /* Google Drive 롤백 대상 ID 목록 */
        List<String> uploadedGoogleIds = new ArrayList<>();

        /* Google Drive 객체 */
        Drive drive = null;

        try {
            /* Google Drive 객체 생성 */
            drive = googleDriveService.getDriveService();

            /* 파일그룹번호 */
            Long fileGroupNo = facilityVO.getFileGroupNo();

            /* 파일그룹번호 신규 채번 */
            if (fileGroupNo == null) {
                fileGroupNo = attachFileMapper.getSeqFileGroupNo();
                facilityVO.setFileGroupNo(fileGroupNo);
            }

            /* 업로드 파일 수 */
            int size = facilityFiles.length;

            /* ATTACH_FILE 등록 대상 배열 */
            AttachFileVO[] files = new AttachFileVO[size];

            for (int i = 0; i < size; i++) {
                /* 빈 파일 제외 */
                if (facilityFiles[i] == null || facilityFiles[i].isEmpty()) {
                    continue;
                }

                /* 원본 파일명 */
                String originalFilename = facilityFiles[i].getOriginalFilename();

                /* 저장 UUID */
                String uuid = UUID.randomUUID().toString().replace("-", "");

                /* 저장 파일명 */
                String savedFileName = uuid + "_" + originalFilename;

                /* Google Drive 폴더 경로 */
                String folderPath = "apt/facility/"
                        + userNo + "/"
                        + facilityVO.getAptCmplexNo() + "/"
                        + facilityVO.getFacilityTyCd() + "/"
                        + facilityVO.getFacilityNo();

                /* DB 저장용 전체 경로 */
                String fullPath = folderPath + "/" + savedFileName;


                /* Google Drive 업로드 시작 시간 */
                long uploadStartTime = System.currentTimeMillis();

                /* Google Drive 업로드 */
                String googleId = googleDriveService.uploadFile(
                        facilityFiles[i],
                        folderPath,
                        savedFileName
                );

                /* Google Drive 업로드 소요 시간 로그 */
                log.info("시설 사진 Google Drive 업로드 소요시간: {}ms, fileName={}",
                        System.currentTimeMillis() - uploadStartTime,
                        originalFilename
                );

                /* Google Drive 롤백 대상 추가 */
                uploadedGoogleIds.add(googleId);

                /* 첨부파일 VO 생성 */
                files[i] = AttachFileVO.fileSettings(
                        facilityFiles[i],
                        fileGroupNo,
                        "시설사진",
                        savedFileName,
                        googleId,
                        fullPath,
                        i
                );
            }

            /* 첨부파일 DB 등록 */
            for (AttachFileVO file : files) {
                /* 빈 배열 요소 제외 */
                if (file != null) {
                    attachFileMapper.insertAttachFile(file);
                }
            }
        } catch (Exception e) {
            /* 시설 파일 업로드 오류 로그 */
            log.error("시설 파일 업로드 오류", e);

            /* Google Drive 업로드 롤백 */
            rollbackUploadedFiles(drive, uploadedGoogleIds);

            /* 트랜잭션 롤백용 RuntimeException */
            throw new RuntimeException(e.getMessage(), e);
        }
    }

    /**
     * Google Drive 업로드 롤백
     */
    private void rollbackUploadedFiles(Drive drive, List<String> uploadedGoogleIds) {
        /* 롤백 대상 없음 */
        if (drive == null || uploadedGoogleIds == null || uploadedGoogleIds.isEmpty()) {
            return;
        }

        for (String googleId : uploadedGoogleIds) {
            try {
                /* Google Drive 휴지통 이동 */
                googleDriveService.moveToTrash(drive, googleId);
            } catch (Exception e) {
                /* Google Drive 롤백 실패 로그 */
                log.error("시설 파일 롤백 실패 googleId={}", googleId, e);
            }
        }
    }
}
