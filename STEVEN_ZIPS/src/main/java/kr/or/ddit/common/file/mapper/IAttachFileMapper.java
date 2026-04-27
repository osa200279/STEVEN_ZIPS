package kr.or.ddit.common.file.mapper;

import kr.or.ddit.common.file.vo.AttachFileVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IAttachFileMapper {

    int insertAttachFile(AttachFileVO attachFile);

    long seqNextVal();

    AttachFileVO getAttachFile(@Param("fileGroupNo") String fileGroupNo, @Param("fileSaveUuid") String fileSaveUuid);
}
