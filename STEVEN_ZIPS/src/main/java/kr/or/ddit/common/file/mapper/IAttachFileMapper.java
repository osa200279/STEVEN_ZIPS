package kr.or.ddit.common.file.mapper;

import kr.or.ddit.common.vo.AttachFileVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IAttachFileMapper {

    public void insertAttachFile(AttachFileVO attachFile);

}
