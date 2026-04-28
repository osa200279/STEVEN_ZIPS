package kr.or.ddit.common.file.service;

import kr.or.ddit.common.file.vo.AttachFileVO;

public interface IAttachFileService {

    AttachFileVO getAttachFile(String fileGroupNo, String fileSavedUuid);

    AttachFileVO setFileMetaData(String fileId);
}
