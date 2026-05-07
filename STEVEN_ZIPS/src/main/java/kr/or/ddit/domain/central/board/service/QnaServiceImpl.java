package kr.or.ddit.domain.central.board.service;

import kr.or.ddit.domain.central.board.mapper.IQnaMapper;
import kr.or.ddit.domain.central.board.vo.CvplVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
public class QnaServiceImpl implements IQnaService {

    @Autowired
    private IQnaMapper qnaMapper;

    @Override
    public List<CvplVO> getList(
            String userNo,
            int startRow,
            int endRow
    ) {
        return qnaMapper.getList(
                userNo,
                startRow,
                endRow
        );
    }

    @Override
    public void insertQna(CvplVO vo) {
        if (vo.getCvplTtl() == null || vo.getCvplTtl().trim().isEmpty()) {
            throw new RuntimeException("제목 없음");
        }

        if (vo.getCvplCn() == null || vo.getCvplCn().trim().isEmpty()) {
            throw new RuntimeException("내용 없음");
        }

        qnaMapper.insertQna(vo);
    }

    @Override
    public void deleteQna(String cvplNo, String userNo) {
        qnaMapper.deleteQna(cvplNo, userNo);
    }

    @Override
    public int getTotalCount(String userNo) {
        return qnaMapper.getTotalCount(userNo);
    }

    @Override
    public Map<String, Object> getResidentInfo(String userNo) {
        return qnaMapper.getResidentInfo(userNo);
    }

}
