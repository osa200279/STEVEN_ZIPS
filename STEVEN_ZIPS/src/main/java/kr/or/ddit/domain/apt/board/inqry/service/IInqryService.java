package kr.or.ddit.domain.apt.board.inqry.service;

import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;

import java.util.List;

public interface IInqryService {

    List<InqryDTO> getList(String userNo, String wrtrId, int startRow, int endRow);

    void insertInqry(InqryDTO dto, String userNo);

    void deleteInqry(String postNo, String userNo, String wrtrId);

    int getTotalCount(String userNo, String wrtrId);
}

//package kr.or.ddit.domain.apt.board.inqry.service;
//
//
//import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
//
//import java.util.List;
//import java.util.Map;
//
//public interface IInqryService {
//
//    List<CvplVO> getList(
//            String userNo,
//            int startRow,
//            int endRow
//    );
//
//    void insertQna(CvplVO vo);
//
//    void deleteQna(String cvplNo, String userNo);
//
//    int getTotalCount(String userNo);
//
//
//    Map<String, Object> getResidentInfo(String userNo);
//}
