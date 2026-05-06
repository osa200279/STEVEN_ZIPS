package kr.or.ddit.domain.ztest.mapper;

import kr.or.ddit.domain.ztest.vo.CvplVO;
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

    void deleteQna(String cvplNo, String userNo);

    int getTotalCount(String userNo);
}
