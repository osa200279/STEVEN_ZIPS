package kr.or.ddit.domain.apt.mgmtOffice.survey.mapper;

import kr.or.ddit.domain.apt.mgmtOffice.survey.dto.MngSurveyDTO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface IMngSurveyMapper {


    void insertSurvey(MngSurveyDTO dto);

    List<MngSurveyDTO> selectSurveyList(String mgmtOfcNo);

    MngSurveyDTO selectSurveyDetail(String surveyNo);

    void updateSurvey(MngSurveyDTO dto);

    void deleteSurvey(String surveyNo);

    Map<String, Object> selectSurveyResult(String surveyNo);
}
