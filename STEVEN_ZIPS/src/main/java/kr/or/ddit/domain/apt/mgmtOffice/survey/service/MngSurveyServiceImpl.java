package kr.or.ddit.domain.apt.mgmtOffice.survey.service;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.mapper.IMngSurveyMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class MngSurveyServiceImpl implements IMngSurveyService {


    private final IMngSurveyMapper iMngSurveyMapper;


    @Override
    public void registerSurvey(MngSurveyDTO dto) {

        log.info("dto : {}", dto);

        iMngSurveyMapper.insertSurvey(dto);
    }

    @Override
    public List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo) {
        return iMngSurveyMapper.selectSurveyList(mgmtOfcNo);
    }


}
