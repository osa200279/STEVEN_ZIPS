package kr.or.ddit.domain.ztest.service;

import kr.or.ddit.domain.ztest.vo.CvplVO;

import java.util.List;
import java.util.Map;

public interface IQnaService {

    List<CvplVO> getList(String userNo);

    void insertQna(CvplVO vo);

    void deleteQna(String cvplNo, String userNo);
}
