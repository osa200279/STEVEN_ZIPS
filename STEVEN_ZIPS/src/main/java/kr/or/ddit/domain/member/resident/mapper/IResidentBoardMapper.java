package kr.or.ddit.domain.member.resident.mapper;

import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface IResidentBoardMapper {
    void insertBoardFree(RsidBoardVO rsidBoardVO);

    

    int selectBoardFreeCount(PaginationInfoVO<RsidBoardVO> pagingVO);

    List<RsidBoardVO> boardFreeList(PaginationInfoVO<RsidBoardVO> pagingVO);

    RsidBoardVO selectOneBoardFree(RsidBoardVO rsidBoardVO);

    int deleteBoardFree(String annNo);

    int updateBoardFree(RsidBoardVO rsidBoardVO);

    void updateInqCnt(String annNo);

    int insertBoardComment(RsidBoardCommentVO rsidBoardCommentVO);
}
