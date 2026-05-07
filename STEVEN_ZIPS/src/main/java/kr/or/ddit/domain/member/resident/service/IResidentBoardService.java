package kr.or.ddit.domain.member.resident.service;

import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.member.resident.vo.RsidBoardVO;

import java.util.List;

public interface IResidentBoardService {


    void insertBoardFree(RsidBoardVO rsidBoardVO);

    

    int selectBoardFreeCount(PaginationInfoVO<RsidBoardVO> pagingVO);

    List<RsidBoardVO> boardFreeList(PaginationInfoVO<RsidBoardVO> pagingVO);

    RsidBoardVO selectOneBoardFree(RsidBoardVO rsidBoardVO);

    int deleteBoardFree(String annNo);

    int updateBoardFree(RsidBoardVO rsidBoardVO);

    void updateInqCnt(String annNo);
}
