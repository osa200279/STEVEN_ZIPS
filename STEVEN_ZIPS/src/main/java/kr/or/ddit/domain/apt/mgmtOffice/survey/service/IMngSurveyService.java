package kr.or.ddit.domain.apt.mgmtOffice.survey.service;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;

import java.util.List;

public interface IMngSurveyService {

    void registerSurvey(MngSurveyDTO dto);

    List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo);

    MngSurveyDTO selectSurveyDetail(String surveyNo);

    void updateSurvey(MngSurveyDTO dto);

    void deleteSurvey(String surveyNo);
}
