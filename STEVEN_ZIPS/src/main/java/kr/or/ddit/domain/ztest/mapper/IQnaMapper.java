package kr.or.ddit.domain.ztest.mapper;

import kr.or.ddit.domain.ztest.vo.CvplVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IQnaMapper {


    List<CvplVO> getList(String userNo);

    void insertQna(CvplVO vo);

    void deleteQna(String cvplNo, String userNo);
}
