package kr.or.ddit.common.file.service;

import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author 이용로
 */
@Slf4j
@Service
public class AttachFileServiceImpl implements IAttachFileService {

    @Autowired
    private IAttachFileMapper attachFileMapper;

    /**
     * 타겟 파일 메타데이터 세팅 구버전 setFileMetaData 쓸 것 권장
     * @param fileId - target(FILE_GROUP_NO + "_" + SAVE_FILE_UUID)
     * @return (AttachFileVO)file
     * @author 이용로
     */
    @Override
    public AttachFileVO setOnlyOneFileMetaData(String fileId) {

        if (fileId == null || fileId.isBlank()) return null;

        try {
            String fileGroupNo = fileId.split("_")[0];
            String fileSaveUuid = fileId.split("_", 2)[1];   // limit 총 몇개로 나눌지
            log.info("** 파일그룹번호 : {}, 파일저장명 : {}", fileGroupNo, fileSaveUuid);
            AttachFileVO file = attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);
            log.info("파일 있음? {}", file);
            return (file != null) ? file : null;
        } catch (IndexOutOfBoundsException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * 타겟 파일(or 파일리스트) 메타데이터 세팅
     * 단일 파일도 List(.of())로 넘김
     * @author 이용로
     * @param fileId
     * @return List<AttachFileVO>
     */
    @Override
    public List<AttachFileVO> setFileMetaData(String fileId) {
        if (fileId == null || fileId.isBlank()) return null;

        if (fileId.contains("_")) {
            // '_'가 맨앞에 있는 경우 방어
            String[] parts = fileId.split("_", 2);
            if (parts.length < 2) return null;

            String fileGroupNo = parts[0];
            String fileSaveUuid = parts[1];   // limit 총 몇개로 나눌지
            log.info("** 찾을 파일그룹번호 : {}, 파일저장명 : {}", fileGroupNo, fileSaveUuid);

            AttachFileVO file = attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);

            return (file != null) ? List.of(file) : null;
        } else {
            log.info("** 찾을 파일그룹번호 : {}", fileId);
            List<AttachFileVO> fileList = attachFileMapper.selecAttachFileList(fileId);
            log.info("찾은 파일 갯수 : {}", fileList.size());
            return (fileList == null || fileList.isEmpty()) ? null : fileList;
        }
    }

}
