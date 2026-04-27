package kr.or.ddit.common.file.service;

import kr.or.ddit.common.file.mapper.IAttachFileMapper;
import kr.or.ddit.common.file.vo.AttachFileVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AttachFileServiceImpl implements IAttachFileService {

    @Autowired
    private IAttachFileMapper attachFileMapper;

    @Override
    public AttachFileVO getAttachFile(String fileGroupNo, String fileSaveUuid) {
        return attachFileMapper.getAttachFile(fileGroupNo, fileSaveUuid);
    }
}
