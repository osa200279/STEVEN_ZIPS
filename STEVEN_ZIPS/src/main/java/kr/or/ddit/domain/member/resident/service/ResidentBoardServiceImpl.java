package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.mapper.IResidentBoardMapper;
import kr.or.ddit.domain.member.resident.vo.RsidBoardCommentVO;
import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ResidentBoardServiceImpl implements IResidentBoardService {

    private final IResidentBoardMapper mapper;

    @Override
    public int insertBoardComment(RsidBoardCommentVO rsidBoardCommentVO) {
        return mapper.insertBoardComment(rsidBoardCommentVO);
    }

    @Override
    public int deleteBoardFree(String annNo) {
        return mapper.deleteBoardFree(annNo);
    }

    @Override
    public int updateBoardFree(RsidBoardVO rsidBoardVO) {
        return mapper.updateBoardFree(rsidBoardVO);
    }

    @Override
    public void updateInqCnt(String annNo) {
        mapper.updateInqCnt(annNo);
    }

    @Override
    public List<RsidBoardVO> boardFreeList(PaginationInfoVO<RsidBoardVO> pagingVO) {
        return mapper.boardFreeList(pagingVO);
    }

    @Override
    public RsidBoardVO selectOneBoardFree(RsidBoardVO rsidBoardVO) {
        return mapper.selectOneBoardFree(rsidBoardVO);
    }



    @Override
    public void insertBoardFree(RsidBoardVO rsidBoardVO) {
        mapper.insertBoardFree(rsidBoardVO);
    }



    @Override
    public int selectBoardFreeCount(PaginationInfoVO<RsidBoardVO> pagingVO) {
        return mapper.selectBoardFreeCount(pagingVO);
    }

}
