package kr.or.ddit.domain.apt.board.inqry.mapper;

import kr.or.ddit.domain.apt.board.inqry.dto.InqryDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IInqryMapper {

    List<InqryDTO> getList(
            @Param("wrtrId") String wrtrId,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("boardTyCd") String boardTyCd,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow
    );

    void insertQna(InqryDTO dto);

    void deleteQna(
            @Param("postNo") String postNo,
            @Param("wrtrId") String wrtrId,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("boardTyCd") String boardTyCd
    );

    int getTotalCount(
            @Param("wrtrId") String wrtrId,
            @Param("aptCmplexNo") String aptCmplexNo,
            @Param("boardTyCd") String boardTyCd
    );

    Map<String, Object> getResidentInfo(@Param("userNo") String userNo);
}


//package kr.or.ddit.domain.apt.board.inqry.mapper;
//
//import kr.or.ddit.domain.apt.complaint.vo.CvplVO;
//import org.apache.ibatis.annotations.Mapper;
//import org.apache.ibatis.annotations.Param;
//
//import java.util.List;
//import java.util.Map;
//
//@Mapper
//public interface IInqryMapper {
//
//
//    List<CvplVO> getList(
//            @Param("userNo") String userNo,
//            @Param("startRow") int startRow,
//            @Param("endRow") int endRow
//    );
//
//    void insertQna(CvplVO vo);
//
//    void deleteQna(
//            @Param("cvplNo") String cvplNo,
//            @Param("userNo") String userNo
//    );
//
//    int getTotalCount(String userNo);
//
//
//    Map<String, Object> getResidentInfo(String userNo);
//}
