package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.mapper.AnnRegisterMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AnnRegisterServiceImpl implements IAnnRegisterService{

    private final AnnRegisterMapper annRegisterMapper;

    @Override
    public void insertAnn(Map<String, Object> params) {
        annRegisterMapper.insertAnn(params);
    }

    @Override
    public List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm) {
        return annRegisterMapper.selectAptList(sidoNm, sigunguNm, emdNm);
    }

    @Override
    public Map<String, Object> selectOneAptDetail(String aptCmplexNo) {
        Map<String, Object> result = new HashMap<>();
        result.put("dorojuso", annRegisterMapper.selectDorojuso(aptCmplexNo));
        result.put("hoTyNo", annRegisterMapper.selectHoTyNo(aptCmplexNo));
        return result;

    }

    @Override
    public List<Map<String, Object>> selectSbmsnDocList(String aptCmplexNo) {
        return annRegisterMapper.selectSbmsnDocList(aptCmplexNo);
    }

}
