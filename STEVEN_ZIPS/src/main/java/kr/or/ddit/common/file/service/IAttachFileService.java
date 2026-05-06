package kr.or.ddit.common.file.service;

import kr.or.ddit.common.file.vo.AttachFileVO;

import java.util.List;

public interface IAttachFileService {

    // 단일 파일 메타데이터 세팅
    AttachFileVO setOnlyOneFileMetaData(String fileId);

    // 묶음 파일 메타데이터 세팅
    List<AttachFileVO> setFileMetaData(String groupNo);
}
