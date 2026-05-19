package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptDetailVO;
import kr.or.ddit.domain.central.admin.mapper.IReactSalesMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReactSalesServiceImpl implements IReactSalesService{

    @Autowired
    private IReactSalesMapper reactSalesMapper;

    @Override
    public List<String> selectBuildingList(String aptCmplexNo) {
        return reactSalesMapper.selectBuildingList(aptCmplexNo);
    }

    @Override
    public List<AptDetailVO> selectHoList(String aptCmplexNo, String dongNm) {
        return reactSalesMapper.selectHoList(aptCmplexNo,dongNm);
    }
}
