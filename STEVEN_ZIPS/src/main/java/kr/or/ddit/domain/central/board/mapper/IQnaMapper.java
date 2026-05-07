package kr.or.ddit.domain.central.board.mapper;

import kr.or.ddit.domain.central.board.vo.CvplVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

@Mapper
public interface IQnaMapper {


    List<CvplVO> getList(
            @Param("userNo") String userNo,
            @Param("startRow") int startRow,
            @Param("endRow") int endRow
    );

    void insertQna(CvplVO vo);

    void deleteQna(
            @Param("cvplNo") String cvplNo,
            @Param("userNo") String userNo
    );

    int getTotalCount(String userNo);


    Map<String, Object> getResidentInfo(String userNo);
}
