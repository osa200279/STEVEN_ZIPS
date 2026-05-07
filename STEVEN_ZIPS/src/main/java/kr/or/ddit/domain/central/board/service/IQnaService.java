package kr.or.ddit.domain.central.board.service;


import kr.or.ddit.domain.central.board.vo.CvplVO;

import java.util.List;

public interface IQnaService {

    List<CvplVO> getList(
            String userNo,
            int startRow,
            int endRow
    );

    void insertQna(CvplVO vo);

    void deleteQna(String cvplNo, String userNo);

    int getTotalCount(String userNo);
}
