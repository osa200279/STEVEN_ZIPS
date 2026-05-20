package kr.or.ddit.domain.apt.mgmtOffice.survey.service;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import kr.or.ddit.domain.apt.mgmtOffice.survey.mapper.IMngSurveyMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

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

    @Override
    public MngSurveyDTO selectSurveyDetail(String surveyNo) {

        return iMngSurveyMapper
                .selectSurveyDetail(surveyNo);
    }

    @Override
    public void updateSurvey(
            MngSurveyDTO dto
    ) {

        iMngSurveyMapper.updateSurvey(dto);
    }

    @Override
    public void deleteSurvey(
            String surveyNo
    ) {

        iMngSurveyMapper.deleteSurvey(surveyNo);
    }

    @Override
    public Map<String, Object> selectSurveyResult(
            String surveyNo
    ) {

        return iMngSurveyMapper
                .selectSurveyResult(surveyNo);
    }

    @Override
    public String selectMySurveyResponse(
            String surveyNo,
            String userNo
    ) {

        return iMngSurveyMapper
                .selectMySurveyResponse(
                        surveyNo,
                        userNo
                );
    }

    @Override
    public void insertSurveyResponse(
            String surveyNo,
            String response,
            String userNo

    ) {

        iMngSurveyMapper.insertSurveyResponse(
                surveyNo,
                response,
                userNo


        );
    }

    @Override
    public boolean existsSurveyResponse(
            String surveyNo,
            String userNo
    ) {

        return iMngSurveyMapper.existsSurveyResponse(
                surveyNo,
                userNo
        ) > 0;
    }

    @Override
    public List<MngSurveyDTO> selectSurveyTypeList(
            String type
    ) {

        return iMngSurveyMapper
                .selectSurveyTypeList(type);
    }

}
