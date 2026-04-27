package kr.or.ddit.common.file.service;

import kr.or.ddit.common.file.vo.AttachFileVO;
import org.springframework.stereotype.Service;

public interface IAttachFileService {
    AttachFileVO getAttachFile(String fileGroupNo, String fileSavedUuid);
}
