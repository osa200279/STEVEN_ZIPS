package kr.or.ddit.domain.apt.complaint.service;

import com.google.api.services.drive.Drive;
import kr.or.ddit.common.api.google.service.GoogleDriveService;
import kr.or.ddit.common.enums.ServiceResult;
import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import kr.or.ddit.domain.apt.complaint.mapper.ICvplMapper;
import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Transactional(rollbackFor = Exception.class)
@Service
public class CvplServiceImpl implements ICvplService {

    @Autowired
    private ICvplMapper cvplMapper;

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Autowired
    private GoogleDriveService googleDriveService;

    @Override
    public ServiceResult applyCvpl(CvplVO cvplVO, MultipartFile[] attachFiles) throws GeneralSecurityException, IOException {

        List<String> uploadedGids = new ArrayList<>();
        Drive drive = null; // drive 객체를 밖으로 뺌

        try {
            drive = googleDriveService.getDriveService();

            // 2. 첨부 파일 처리 (null 체크 및 length 체크 순서 중요)
            if (attachFiles != null && attachFiles.length > 0) {
                int size = attachFiles.length;
                long fileGroupNo = attachFileMapper.getSeqFileGroupNo();
                AttachFileVO[] files = new AttachFileVO[size];

                for (int i = 0; i < size; i++) {
                    String originalFilename = attachFiles[i].getOriginalFilename();
                    String uuid = UUID.randomUUID().toString().replace("-", "");
                    String savedFileName = uuid + "_" + originalFilename;
                    String folderPath = "apt/cvpl/" + cvplVO.getAptCmplexNo() + "/" + cvplVO.getUserNo();

                    // 실제 업로드
                    String googleId = googleDriveService.uploadFile(attachFiles[i], folderPath, savedFileName);
                    uploadedGids.add(googleId);

                    files[i] = AttachFileVO.fileSettings(attachFiles[i], fileGroupNo, "민원", savedFileName, googleId, folderPath + "/" + savedFileName, i);
                }

                // DB 인서트
                for (AttachFileVO f : files) {
                    attachFileMapper.insertAttachFile(f);
                }
                cvplVO.setCvplFileNo(String.valueOf(fileGroupNo));
            }

            // 3. 민원 본문 저장
            int insertCheck = cvplMapper.insertCvplApply(cvplVO);
            if (insertCheck < 1) throw new RuntimeException("민원 본문 DB 저장 실패");

            return ServiceResult.OK;

        } catch (Exception e) {
            log.error("#### 에러 발생 원인: {}", e.getMessage());
            e.printStackTrace(); // 상세 스택트레이스 출력

            // 롤백: 이미 업로드된 파일들 삭제
            if (drive != null && !uploadedGids.isEmpty()) {
                for (String gId : uploadedGids) {
                    try {
                        googleDriveService.moveToTrash(drive, gId);
                    } catch (Exception ex) {
                        log.error("롤백 중 삭제 실패(gId: {}): {}", gId, ex.getMessage());
                    }
                }
            }
            throw new RuntimeException(e.getMessage(), e);
        }
    }
}
