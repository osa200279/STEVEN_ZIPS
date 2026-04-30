package kr.or.ddit.common.file.service;

import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author 이용로
 */
@Slf4j
@Service
public class AttachFileServiceImpl implements IAttachFileService {

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Override
    public AttachFileVO getAttachFile(String fileGroupNo, String fileSaveUuid) {
        return attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);
    }

    /**
     * 타겟 파일 메타데이터 세팅
     * @author 이용로
     * @param fileId - target(FILE_GROUP_NO + "_" + SAVE_FILE_UUID)
     * @return (AttachFileVO)file
     */
    @Override
    public AttachFileVO setFileMetaData(String fileId) {

        if(fileId == null || fileId.isBlank()) return null;

        try {
            String fileGroupNo = fileId.split("_")[0];
            String fileSaveUuid = fileId.split("_",2)[1];   // limit 총 몇개로 나눌지
            log.info("** 파일그룹번호 : {}, 파일저장명 : {}", fileGroupNo, fileSaveUuid);
            AttachFileVO file = this.getAttachFile(fileGroupNo, fileSaveUuid);
            log.info("파일 있음? {}", file);
            return (file != null) ? file : null;
        } catch (IndexOutOfBoundsException e) {
            e.printStackTrace();
            return null;
        }
    }
}
