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
        Drive drive = googleDriveService.getDriveService();
        List<String> uploadedGids = new ArrayList<>();
        long fileGroupNo;
        int size = attachFiles.length;

        try {
            // 1. 첨부 파일 먼저 업로드
            if (attachFiles != null && size > 0) {
                AttachFileVO[] files = new AttachFileVO[size];  // DB에 인서트 할 VO정보 담아두는 곳
                fileGroupNo = attachFileMapper.getSeqFileGroupNo(); // 파일 그룹 번호

                for (int i = 0; i < size; i++) {
                    String originalFilename = attachFiles[i].getOriginalFilename();
                    String uuid = UUID.randomUUID().toString().replace("-", "");
                    String savedFileName = uuid + "_" + originalFilename;
                    String folderPath = "apt/cvpl/" + cvplVO.getAptCmplexNo() + "/" + cvplVO.getUserNo();
                    String fullPath = folderPath + "/" + savedFileName;
                    String cat = "민원";

                    String googleId = googleDriveService.uploadFile(attachFiles[i], folderPath, savedFileName);
                    uploadedGids.add(googleId);

                    files[i] = AttachFileVO.fileSettings(attachFiles[i], fileGroupNo, cat, savedFileName, googleId, fullPath, i);
                }
                // 2. DB 인서트
                for (AttachFileVO f : files) {
                    int ins = attachFileMapper.insertAttachFile(f);
                    if (ins < 1) throw new RuntimeException("파일 정보 DB인서트 실패.");
                }
                cvplVO.setCvplFileNo(String.valueOf(fileGroupNo));
            }
            // 3. 민원 본문 저장
            int insertCheck = cvplMapper.insertCvplApply(cvplVO);
            if (insertCheck < 1) throw new RuntimeException("민원 본문 DB 저장 실패");
            return ServiceResult.OK;
        } catch (Exception e) {
            log.error("첨부 파일 업로드 중 오류 발생 : {}", e.getMessage());
            // 오류 발생시(DB 인서트 실패 등) 구글 드라이브 롤백 로직
            for(String gId : uploadedGids){
                try{
                    googleDriveService.moveToTrash(drive, gId);
                }catch (Exception ex){
                    log.error("구글 드라이브 롤백(파일 삭제) 실패(gId : {}) : {}", gId, ex.getMessage());
                }
            }
            throw new RuntimeException(e.getMessage(), e);  // 롤백 유도 예외
        }
    }
}
