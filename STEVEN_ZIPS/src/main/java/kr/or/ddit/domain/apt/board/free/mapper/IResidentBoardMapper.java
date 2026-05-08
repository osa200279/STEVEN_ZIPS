package kr.or.ddit.domain.apt.board.free.mapper;

import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.apt.board.free.vo.RsidBoardVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;


@Mapper
public interface IResidentBoardMapper {
    void insertBoardFree(RsidBoardVO rsidBoardVO);

    

    int selectBoardFreeCount(PaginationInfoVO<RsidBoardVO> pagingVO);

    List<RsidBoardVO> boardFreeList(PaginationInfoVO<RsidBoardVO> pagingVO);

    RsidBoardVO selectOneBoardFree(RsidBoardVO rsidBoardVO);

    int deleteBoardFree(String postNo);

    int updateBoardFree(RsidBoardVO rsidBoardVO);

    void updateInqCnt(String postNo);

    int insertBoardComment(RsidBoardCommentVO rsidBoardCommentVO);

    List<RsidBoardCommentVO> boardFreeComment(String postNo);

    int updateBoardComment(RsidBoardCommentVO rsidBoardCommentVO);

    int deleteBoardComment(String cmtNo);

    int insertSubComment(RsidBoardCommentVO rsidBoardCommentVO);
}
