package kr.or.ddit.domain.central.admin.service;

import kr.or.ddit.domain.apt.main.vo.AptComplexVO;
import kr.or.ddit.domain.central.admin.mapper.AnnRegisterMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AnnRegisterServiceImpl implements IAnnRegisterService{

    private final AnnRegisterMapper annRegisterMapper;

    @Override
    public List<AptComplexVO> selectAptList(String sidoNm, String sigunguNm, String emdNm) {
        return annRegisterMapper.selectAptList(sidoNm, sigunguNm, emdNm);
    }
}
