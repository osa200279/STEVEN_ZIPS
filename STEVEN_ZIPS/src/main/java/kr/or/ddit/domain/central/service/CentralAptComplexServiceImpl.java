package kr.or.ddit.domain.central.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.vo.PaginationInfoVO;
import kr.or.ddit.domain.central.mapper.ICentralAptComplexMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CentralAptComplexServiceImpl implements ICentralAptComplexService {

    @Autowired
    private ICentralAptComplexMapper aptComplexMapper;

    @Override
    public List<AptComplexVO> selectAptComplexList(
            PaginationInfoVO<AptComplexVO> pagingVO
    ) {
        return aptComplexMapper.selectAptComplexList(
                pagingVO.getSearchWord(),
                pagingVO.getStartRow(),
                pagingVO.getEndRow()
        );
    }

    @Override
    public List<AptComplexVO> searchApt(String keyword) {
        return aptComplexMapper.searchApt(keyword);
    }

    @Override
    public int selectAptComplexCount(String initial) {
        return aptComplexMapper.selectAptComplexCount(initial);
    }
}
