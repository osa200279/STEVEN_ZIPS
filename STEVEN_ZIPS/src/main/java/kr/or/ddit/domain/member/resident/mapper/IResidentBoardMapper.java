package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface IResidentBoardMapper {
    void insertBoardFree(RsidBoardVO rsidBoardVO);

    List<RsidBoardVO> boardFreeList(RsidBoardVO rsidBoardVO);
}
