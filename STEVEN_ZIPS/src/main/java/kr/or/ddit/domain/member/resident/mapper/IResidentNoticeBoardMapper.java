package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.domain.member.resident.dto.ResidentNoticeBoardDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface IResidentNoticeBoardMapper {

    int selectResidentBoardNoticeCount(ResidentNoticeBoardDTO searchDTO);

    List<ResidentNoticeBoardDTO> selectResidentBoardNoticeList(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectResidentBoardNoticeDetail(ResidentNoticeBoardDTO searchDTO);

    int updateResidentBoardNoticeInqCnt(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectPrevResidentNotice(ResidentNoticeBoardDTO searchDTO);

    ResidentNoticeBoardDTO selectNextResidentNotice(ResidentNoticeBoardDTO searchDTO);
}