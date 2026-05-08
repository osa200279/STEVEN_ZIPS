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
                pagingVO.getEndRow(),
                pagingVO.getSearchVO()
        );
    }

    @Override
    public List<AptComplexVO> searchApt(String keyword) {
        return aptComplexMapper.searchApt(keyword);
    }

    @Override
    public int selectAptComplexCount(
            PaginationInfoVO<AptComplexVO> pagingVO
    ) {
        return aptComplexMapper.selectAptComplexCount(
                pagingVO.getSearchWord(),
                pagingVO.getSearchType(),
                pagingVO.getSearchVO()
        );

    }

    @Override
    public List<String> selectSigunguList(String sidoNm) {
        return aptComplexMapper.selectSigunguList(sidoNm);
    }

    @Override
    public List<String> selectSidoList() {
        return aptComplexMapper.selectSidoList();
    }

    @Override
    public AptComplexVO selectAptComplexDetail(String aptCmplexNo) {
        return aptComplexMapper.selectAptComplexDetail(aptCmplexNo);
    }
}
